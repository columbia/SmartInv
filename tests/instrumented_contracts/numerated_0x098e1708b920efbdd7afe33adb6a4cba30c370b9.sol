1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 9068f80
6 Repository: https://github.com/renproject/darknode-sol
7 Issues: https://github.com/renproject/darknode-sol/issues
8 
9 Licenses
10 @openzeppelin/contracts: (MIT) https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
11 darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity 0.5.16;
16 
17 
18 library SafeMath {
19     
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         
43         
44         
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51 
52         return c;
53     }
54 
55     
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         
66 
67         return c;
68     }
69 
70     
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     
76     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b != 0, errorMessage);
78         return a % b;
79     }
80 }
81 
82 contract Initializable {
83 
84   
85   bool private initialized;
86 
87   
88   bool private initializing;
89 
90   
91   modifier initializer() {
92     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
93 
94     bool isTopLevelCall = !initializing;
95     if (isTopLevelCall) {
96       initializing = true;
97       initialized = true;
98     }
99 
100     _;
101 
102     if (isTopLevelCall) {
103       initializing = false;
104     }
105   }
106 
107   
108   function isConstructor() private view returns (bool) {
109     
110     
111     
112     
113     
114     address self = address(this);
115     uint256 cs;
116     assembly { cs := extcodesize(self) }
117     return cs == 0;
118   }
119 
120   
121   uint256[50] private ______gap;
122 }
123 
124 contract Context is Initializable {
125     
126     
127     constructor () internal { }
128     
129 
130     function _msgSender() internal view returns (address payable) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view returns (bytes memory) {
135         this; 
136         return msg.data;
137     }
138 }
139 
140 interface IERC20 {
141     
142     function totalSupply() external view returns (uint256);
143 
144     
145     function balanceOf(address account) external view returns (uint256);
146 
147     
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     
157     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
158 
159     
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 contract ERC20 is Initializable, Context, IERC20 {
167     using SafeMath for uint256;
168 
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     
176     function totalSupply() public view returns (uint256) {
177         return _totalSupply;
178     }
179 
180     
181     function balanceOf(address account) public view returns (uint256) {
182         return _balances[account];
183     }
184 
185     
186     function transfer(address recipient, uint256 amount) public returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     
192     function allowance(address owner, address spender) public view returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     
197     function approve(address spender, uint256 amount) public returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     
203     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     
210     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
212         return true;
213     }
214 
215     
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
218         return true;
219     }
220 
221     
222     function _transfer(address sender, address recipient, uint256 amount) internal {
223         require(sender != address(0), "ERC20: transfer from the zero address");
224         require(recipient != address(0), "ERC20: transfer to the zero address");
225 
226         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
227         _balances[recipient] = _balances[recipient].add(amount);
228         emit Transfer(sender, recipient, amount);
229     }
230 
231     
232     function _mint(address account, uint256 amount) internal {
233         require(account != address(0), "ERC20: mint to the zero address");
234 
235         _totalSupply = _totalSupply.add(amount);
236         _balances[account] = _balances[account].add(amount);
237         emit Transfer(address(0), account, amount);
238     }
239 
240      
241     function _burn(address account, uint256 amount) internal {
242         require(account != address(0), "ERC20: burn from the zero address");
243 
244         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
245         _totalSupply = _totalSupply.sub(amount);
246         emit Transfer(account, address(0), amount);
247     }
248 
249     
250     function _approve(address owner, address spender, uint256 amount) internal {
251         require(owner != address(0), "ERC20: approve from the zero address");
252         require(spender != address(0), "ERC20: approve to the zero address");
253 
254         _allowances[owner][spender] = amount;
255         emit Approval(owner, spender, amount);
256     }
257 
258     
259     function _burnFrom(address account, uint256 amount) internal {
260         _burn(account, amount);
261         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
262     }
263 
264     uint256[50] private ______gap;
265 }
266 
267 library Address {
268     
269     function isContract(address account) internal view returns (bool) {
270         
271         
272         
273 
274         
275         
276         
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         
280         assembly { codehash := extcodehash(account) }
281         return (codehash != 0x0 && codehash != accountHash);
282     }
283 
284     
285     function toPayable(address account) internal pure returns (address payable) {
286         return address(uint160(account));
287     }
288 
289     
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         
294         (bool success, ) = recipient.call.value(amount)("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 }
298 
299 library SafeERC20 {
300     using SafeMath for uint256;
301     using Address for address;
302 
303     function safeTransfer(IERC20 token, address to, uint256 value) internal {
304         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
305     }
306 
307     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
309     }
310 
311     function safeApprove(IERC20 token, address spender, uint256 value) internal {
312         
313         
314         
315         
316         require((value == 0) || (token.allowance(address(this), spender) == 0),
317             "SafeERC20: approve from non-zero to non-zero allowance"
318         );
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
320     }
321 
322     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).add(value);
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     
333     function callOptionalReturn(IERC20 token, bytes memory data) private {
334         
335         
336 
337         
338         
339         
340         
341         
342         require(address(token).isContract(), "SafeERC20: call to non-contract");
343 
344         
345         (bool success, bytes memory returndata) = address(token).call(data);
346         require(success, "SafeERC20: low-level call failed");
347 
348         if (returndata.length > 0) { 
349             
350             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
351         }
352     }
353 }
354 
355 library Math {
356     
357     function max(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a >= b ? a : b;
359     }
360 
361     
362     function min(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a < b ? a : b;
364     }
365 
366     
367     function average(uint256 a, uint256 b) internal pure returns (uint256) {
368         
369         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
370     }
371 }
372 
373 library ERC20WithFees {
374     using SafeMath for uint256;
375     using SafeERC20 for IERC20;
376 
377     
378     
379     function safeTransferFromWithFees(
380         IERC20 token,
381         address from,
382         address to,
383         uint256 value
384     ) internal returns (uint256) {
385         uint256 balancesBefore = token.balanceOf(to);
386         token.safeTransferFrom(from, to, value);
387         uint256 balancesAfter = token.balanceOf(to);
388         return Math.min(value, balancesAfter.sub(balancesBefore));
389     }
390 }
391 
392 contract Proxy {
393   
394   function () payable external {
395     _fallback();
396   }
397 
398   
399   function _implementation() internal view returns (address);
400 
401   
402   function _delegate(address implementation) internal {
403     assembly {
404       
405       
406       
407       calldatacopy(0, 0, calldatasize)
408 
409       
410       
411       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
412 
413       
414       returndatacopy(0, 0, returndatasize)
415 
416       switch result
417       
418       case 0 { revert(0, returndatasize) }
419       default { return(0, returndatasize) }
420     }
421   }
422 
423   
424   function _willFallback() internal {
425   }
426 
427   
428   function _fallback() internal {
429     _willFallback();
430     _delegate(_implementation());
431   }
432 }
433 
434 library OpenZeppelinUpgradesAddress {
435     
436     function isContract(address account) internal view returns (bool) {
437         uint256 size;
438         
439         
440         
441         
442         
443         
444         
445         assembly { size := extcodesize(account) }
446         return size > 0;
447     }
448 }
449 
450 contract BaseUpgradeabilityProxy is Proxy {
451   
452   event Upgraded(address indexed implementation);
453 
454   
455   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
456 
457   
458   function _implementation() internal view returns (address impl) {
459     bytes32 slot = IMPLEMENTATION_SLOT;
460     assembly {
461       impl := sload(slot)
462     }
463   }
464 
465   
466   function _upgradeTo(address newImplementation) internal {
467     _setImplementation(newImplementation);
468     emit Upgraded(newImplementation);
469   }
470 
471   
472   function _setImplementation(address newImplementation) internal {
473     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
474 
475     bytes32 slot = IMPLEMENTATION_SLOT;
476 
477     assembly {
478       sstore(slot, newImplementation)
479     }
480   }
481 }
482 
483 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
484   
485   constructor(address _logic, bytes memory _data) public payable {
486     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
487     _setImplementation(_logic);
488     if(_data.length > 0) {
489       (bool success,) = _logic.delegatecall(_data);
490       require(success);
491     }
492   }  
493 }
494 
495 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
496   
497   event AdminChanged(address previousAdmin, address newAdmin);
498 
499   
500 
501   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
502 
503   
504   modifier ifAdmin() {
505     if (msg.sender == _admin()) {
506       _;
507     } else {
508       _fallback();
509     }
510   }
511 
512   
513   function admin() external ifAdmin returns (address) {
514     return _admin();
515   }
516 
517   
518   function implementation() external ifAdmin returns (address) {
519     return _implementation();
520   }
521 
522   
523   function changeAdmin(address newAdmin) external ifAdmin {
524     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
525     emit AdminChanged(_admin(), newAdmin);
526     _setAdmin(newAdmin);
527   }
528 
529   
530   function upgradeTo(address newImplementation) external ifAdmin {
531     _upgradeTo(newImplementation);
532   }
533 
534   
535   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
536     _upgradeTo(newImplementation);
537     (bool success,) = newImplementation.delegatecall(data);
538     require(success);
539   }
540 
541   
542   function _admin() internal view returns (address adm) {
543     bytes32 slot = ADMIN_SLOT;
544     assembly {
545       adm := sload(slot)
546     }
547   }
548 
549   
550   function _setAdmin(address newAdmin) internal {
551     bytes32 slot = ADMIN_SLOT;
552 
553     assembly {
554       sstore(slot, newAdmin)
555     }
556   }
557 
558   
559   function _willFallback() internal {
560     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
561     super._willFallback();
562   }
563 }
564 
565 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
566   
567   function initialize(address _logic, bytes memory _data) public payable {
568     require(_implementation() == address(0));
569     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
570     _setImplementation(_logic);
571     if(_data.length > 0) {
572       (bool success,) = _logic.delegatecall(_data);
573       require(success);
574     }
575   }  
576 }
577 
578 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
579   
580   function initialize(address _logic, address _admin, bytes memory _data) public payable {
581     require(_implementation() == address(0));
582     InitializableUpgradeabilityProxy.initialize(_logic, _data);
583     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
584     _setAdmin(_admin);
585   }
586 }
587 
588 contract Ownable is Initializable, Context {
589     address private _owner;
590 
591     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593     
594     function initialize(address sender) public initializer {
595         _owner = sender;
596         emit OwnershipTransferred(address(0), _owner);
597     }
598 
599     
600     function owner() public view returns (address) {
601         return _owner;
602     }
603 
604     
605     modifier onlyOwner() {
606         require(isOwner(), "Ownable: caller is not the owner");
607         _;
608     }
609 
610     
611     function isOwner() public view returns (bool) {
612         return _msgSender() == _owner;
613     }
614 
615     
616     function renounceOwnership() public onlyOwner {
617         emit OwnershipTransferred(_owner, address(0));
618         _owner = address(0);
619     }
620 
621     
622     function transferOwnership(address newOwner) public onlyOwner {
623         _transferOwnership(newOwner);
624     }
625 
626     
627     function _transferOwnership(address newOwner) internal {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         emit OwnershipTransferred(_owner, newOwner);
630         _owner = newOwner;
631     }
632 
633     uint256[50] private ______gap;
634 }
635 
636 contract ERC20Detailed is Initializable, IERC20 {
637     string private _name;
638     string private _symbol;
639     uint8 private _decimals;
640 
641     
642     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
643         _name = name;
644         _symbol = symbol;
645         _decimals = decimals;
646     }
647 
648     
649     function name() public view returns (string memory) {
650         return _name;
651     }
652 
653     
654     function symbol() public view returns (string memory) {
655         return _symbol;
656     }
657 
658     
659     function decimals() public view returns (uint8) {
660         return _decimals;
661     }
662 
663     uint256[50] private ______gap;
664 }
665 
666 library Roles {
667     struct Role {
668         mapping (address => bool) bearer;
669     }
670 
671     
672     function add(Role storage role, address account) internal {
673         require(!has(role, account), "Roles: account already has role");
674         role.bearer[account] = true;
675     }
676 
677     
678     function remove(Role storage role, address account) internal {
679         require(has(role, account), "Roles: account does not have role");
680         role.bearer[account] = false;
681     }
682 
683     
684     function has(Role storage role, address account) internal view returns (bool) {
685         require(account != address(0), "Roles: account is the zero address");
686         return role.bearer[account];
687     }
688 }
689 
690 contract PauserRole is Initializable, Context {
691     using Roles for Roles.Role;
692 
693     event PauserAdded(address indexed account);
694     event PauserRemoved(address indexed account);
695 
696     Roles.Role private _pausers;
697 
698     function initialize(address sender) public initializer {
699         if (!isPauser(sender)) {
700             _addPauser(sender);
701         }
702     }
703 
704     modifier onlyPauser() {
705         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
706         _;
707     }
708 
709     function isPauser(address account) public view returns (bool) {
710         return _pausers.has(account);
711     }
712 
713     function addPauser(address account) public onlyPauser {
714         _addPauser(account);
715     }
716 
717     function renouncePauser() public {
718         _removePauser(_msgSender());
719     }
720 
721     function _addPauser(address account) internal {
722         _pausers.add(account);
723         emit PauserAdded(account);
724     }
725 
726     function _removePauser(address account) internal {
727         _pausers.remove(account);
728         emit PauserRemoved(account);
729     }
730 
731     uint256[50] private ______gap;
732 }
733 
734 contract Pausable is Initializable, Context, PauserRole {
735     
736     event Paused(address account);
737 
738     
739     event Unpaused(address account);
740 
741     bool private _paused;
742 
743     
744     function initialize(address sender) public initializer {
745         PauserRole.initialize(sender);
746 
747         _paused = false;
748     }
749 
750     
751     function paused() public view returns (bool) {
752         return _paused;
753     }
754 
755     
756     modifier whenNotPaused() {
757         require(!_paused, "Pausable: paused");
758         _;
759     }
760 
761     
762     modifier whenPaused() {
763         require(_paused, "Pausable: not paused");
764         _;
765     }
766 
767     
768     function pause() public onlyPauser whenNotPaused {
769         _paused = true;
770         emit Paused(_msgSender());
771     }
772 
773     
774     function unpause() public onlyPauser whenPaused {
775         _paused = false;
776         emit Unpaused(_msgSender());
777     }
778 
779     uint256[50] private ______gap;
780 }
781 
782 contract ERC20Pausable is Initializable, ERC20, Pausable {
783     function initialize(address sender) public initializer {
784         Pausable.initialize(sender);
785     }
786 
787     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
788         return super.transfer(to, value);
789     }
790 
791     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
792         return super.transferFrom(from, to, value);
793     }
794 
795     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
796         return super.approve(spender, value);
797     }
798 
799     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
800         return super.increaseAllowance(spender, addedValue);
801     }
802 
803     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
804         return super.decreaseAllowance(spender, subtractedValue);
805     }
806 
807     uint256[50] private ______gap;
808 }
809 
810 contract ERC20Burnable is Initializable, Context, ERC20 {
811     
812     function burn(uint256 amount) public {
813         _burn(_msgSender(), amount);
814     }
815 
816     
817     function burnFrom(address account, uint256 amount) public {
818         _burnFrom(account, amount);
819     }
820 
821     uint256[50] private ______gap;
822 }
823 
824 contract RenToken is Ownable, ERC20Detailed, ERC20Pausable, ERC20Burnable {
825     string private constant _name = "REN";
826     string private constant _symbol = "REN";
827     uint8 private constant _decimals = 18;
828 
829     uint256 public constant INITIAL_SUPPLY = 1000000000 *
830         10**uint256(_decimals);
831 
832     
833     constructor() public {
834         ERC20Pausable.initialize(msg.sender);
835         ERC20Detailed.initialize(_name, _symbol, _decimals);
836         Ownable.initialize(msg.sender);
837         _mint(msg.sender, INITIAL_SUPPLY);
838     }
839 
840     function transferTokens(address beneficiary, uint256 amount)
841         public
842         onlyOwner
843         returns (bool)
844     {
845         
846         
847         require(amount > 0);
848 
849         _transfer(msg.sender, beneficiary, amount);
850         emit Transfer(msg.sender, beneficiary, amount);
851 
852         return true;
853     }
854 }
855 
856 contract Claimable is Initializable, Ownable {
857     address public pendingOwner;
858 
859     function initialize(address _nextOwner) public initializer {
860         Ownable.initialize(_nextOwner);
861     }
862 
863     modifier onlyPendingOwner() {
864         require(
865             _msgSender() == pendingOwner,
866             "Claimable: caller is not the pending owner"
867         );
868         _;
869     }
870 
871     function transferOwnership(address newOwner) public onlyOwner {
872         require(
873             newOwner != owner() && newOwner != pendingOwner,
874             "Claimable: invalid new owner"
875         );
876         pendingOwner = newOwner;
877     }
878 
879     function claimOwnership() public onlyPendingOwner {
880         _transferOwnership(pendingOwner);
881         delete pendingOwner;
882     }
883 }
884 
885 library LinkedList {
886 
887     
888     address public constant NULL = address(0);
889 
890     
891     struct Node {
892         bool inList;
893         address previous;
894         address next;
895     }
896 
897     
898     struct List {
899         mapping (address => Node) list;
900     }
901 
902     
903     function insertBefore(List storage self, address target, address newNode) internal {
904         require(newNode != address(0), "LinkedList: invalid address");
905         require(!isInList(self, newNode), "LinkedList: already in list");
906         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
907 
908         
909         address prev = self.list[target].previous;
910 
911         self.list[newNode].next = target;
912         self.list[newNode].previous = prev;
913         self.list[target].previous = newNode;
914         self.list[prev].next = newNode;
915 
916         self.list[newNode].inList = true;
917     }
918 
919     
920     function insertAfter(List storage self, address target, address newNode) internal {
921         require(newNode != address(0), "LinkedList: invalid address");
922         require(!isInList(self, newNode), "LinkedList: already in list");
923         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
924 
925         
926         address n = self.list[target].next;
927 
928         self.list[newNode].previous = target;
929         self.list[newNode].next = n;
930         self.list[target].next = newNode;
931         self.list[n].previous = newNode;
932 
933         self.list[newNode].inList = true;
934     }
935 
936     
937     function remove(List storage self, address node) internal {
938         require(isInList(self, node), "LinkedList: not in list");
939         
940         address p = self.list[node].previous;
941         address n = self.list[node].next;
942 
943         self.list[p].next = n;
944         self.list[n].previous = p;
945 
946         
947         
948         self.list[node].inList = false;
949         delete self.list[node];
950     }
951 
952     
953     function prepend(List storage self, address node) internal {
954         
955 
956         insertBefore(self, begin(self), node);
957     }
958 
959     
960     function append(List storage self, address node) internal {
961         
962 
963         insertAfter(self, end(self), node);
964     }
965 
966     function swap(List storage self, address left, address right) internal {
967         
968 
969         address previousRight = self.list[right].previous;
970         remove(self, right);
971         insertAfter(self, left, right);
972         remove(self, left);
973         insertAfter(self, previousRight, left);
974     }
975 
976     function isInList(List storage self, address node) internal view returns (bool) {
977         return self.list[node].inList;
978     }
979 
980     
981     function begin(List storage self) internal view returns (address) {
982         return self.list[NULL].next;
983     }
984 
985     
986     function end(List storage self) internal view returns (address) {
987         return self.list[NULL].previous;
988     }
989 
990     function next(List storage self, address node) internal view returns (address) {
991         require(isInList(self, node), "LinkedList: not in list");
992         return self.list[node].next;
993     }
994 
995     function previous(List storage self, address node) internal view returns (address) {
996         require(isInList(self, node), "LinkedList: not in list");
997         return self.list[node].previous;
998     }
999 
1000     function elements(List storage self, address _start, uint256 _count) internal view returns (address[] memory) {
1001         require(_count > 0, "LinkedList: invalid count");
1002         require(isInList(self, _start) || _start == address(0), "LinkedList: not in list");
1003         address[] memory elems = new address[](_count);
1004 
1005         
1006         uint256 n = 0;
1007         address nextItem = _start;
1008         if (nextItem == address(0)) {
1009             nextItem = begin(self);
1010         }
1011 
1012         while (n < _count) {
1013             if (nextItem == address(0)) {
1014                 break;
1015             }
1016             elems[n] = nextItem;
1017             nextItem = next(self, nextItem);
1018             n += 1;
1019         }
1020         return elems;
1021     }
1022 }
1023 
1024 contract CanReclaimTokens is Claimable {
1025     using SafeERC20 for ERC20;
1026 
1027     mapping(address => bool) private recoverableTokensBlacklist;
1028 
1029     function initialize(address _nextOwner) public initializer {
1030         Claimable.initialize(_nextOwner);
1031     }
1032 
1033     function blacklistRecoverableToken(address _token) public onlyOwner {
1034         recoverableTokensBlacklist[_token] = true;
1035     }
1036 
1037     
1038     
1039     function recoverTokens(address _token) external onlyOwner {
1040         require(
1041             !recoverableTokensBlacklist[_token],
1042             "CanReclaimTokens: token is not recoverable"
1043         );
1044 
1045         if (_token == address(0x0)) {
1046             msg.sender.transfer(address(this).balance);
1047         } else {
1048             ERC20(_token).safeTransfer(
1049                 msg.sender,
1050                 ERC20(_token).balanceOf(address(this))
1051             );
1052         }
1053     }
1054 }
1055 
1056 contract DarknodeRegistryStore is Claimable, CanReclaimTokens {
1057     using SafeMath for uint256;
1058 
1059     string public VERSION; 
1060 
1061     
1062     
1063     
1064     
1065     
1066     struct Darknode {
1067         
1068         
1069         
1070         
1071         address payable owner;
1072         
1073         
1074         
1075         uint256 bond;
1076         
1077         uint256 registeredAt;
1078         
1079         uint256 deregisteredAt;
1080         
1081         
1082         
1083         
1084         bytes publicKey;
1085     }
1086 
1087     
1088     mapping(address => Darknode) private darknodeRegistry;
1089     LinkedList.List private darknodes;
1090 
1091     
1092     RenToken public ren;
1093 
1094     
1095     
1096     
1097     
1098     constructor(string memory _VERSION, RenToken _ren) public {
1099         Claimable.initialize(msg.sender);
1100         CanReclaimTokens.initialize(msg.sender);
1101         VERSION = _VERSION;
1102         ren = _ren;
1103         blacklistRecoverableToken(address(ren));
1104     }
1105 
1106     
1107     
1108     
1109     
1110     
1111     
1112     
1113     
1114     
1115     function appendDarknode(
1116         address _darknodeID,
1117         address payable _darknodeOperator,
1118         uint256 _bond,
1119         bytes calldata _publicKey,
1120         uint256 _registeredAt,
1121         uint256 _deregisteredAt
1122     ) external onlyOwner {
1123         Darknode memory darknode = Darknode({
1124             owner: _darknodeOperator,
1125             bond: _bond,
1126             publicKey: _publicKey,
1127             registeredAt: _registeredAt,
1128             deregisteredAt: _deregisteredAt
1129         });
1130         darknodeRegistry[_darknodeID] = darknode;
1131         LinkedList.append(darknodes, _darknodeID);
1132     }
1133 
1134     
1135     function begin() external view onlyOwner returns (address) {
1136         return LinkedList.begin(darknodes);
1137     }
1138 
1139     
1140     
1141     function next(address darknodeID)
1142         external
1143         view
1144         onlyOwner
1145         returns (address)
1146     {
1147         return LinkedList.next(darknodes, darknodeID);
1148     }
1149 
1150     
1151     
1152     function removeDarknode(address darknodeID) external onlyOwner {
1153         uint256 bond = darknodeRegistry[darknodeID].bond;
1154         delete darknodeRegistry[darknodeID];
1155         LinkedList.remove(darknodes, darknodeID);
1156         require(
1157             ren.transfer(owner(), bond),
1158             "DarknodeRegistryStore: bond transfer failed"
1159         );
1160     }
1161 
1162     
1163     
1164     function updateDarknodeBond(address darknodeID, uint256 decreasedBond)
1165         external
1166         onlyOwner
1167     {
1168         uint256 previousBond = darknodeRegistry[darknodeID].bond;
1169         require(
1170             decreasedBond < previousBond,
1171             "DarknodeRegistryStore: bond not decreased"
1172         );
1173         darknodeRegistry[darknodeID].bond = decreasedBond;
1174         require(
1175             ren.transfer(owner(), previousBond.sub(decreasedBond)),
1176             "DarknodeRegistryStore: bond transfer failed"
1177         );
1178     }
1179 
1180     
1181     function updateDarknodeDeregisteredAt(
1182         address darknodeID,
1183         uint256 deregisteredAt
1184     ) external onlyOwner {
1185         darknodeRegistry[darknodeID].deregisteredAt = deregisteredAt;
1186     }
1187 
1188     
1189     function darknodeOperator(address darknodeID)
1190         external
1191         view
1192         onlyOwner
1193         returns (address payable)
1194     {
1195         return darknodeRegistry[darknodeID].owner;
1196     }
1197 
1198     
1199     function darknodeBond(address darknodeID)
1200         external
1201         view
1202         onlyOwner
1203         returns (uint256)
1204     {
1205         return darknodeRegistry[darknodeID].bond;
1206     }
1207 
1208     
1209     function darknodeRegisteredAt(address darknodeID)
1210         external
1211         view
1212         onlyOwner
1213         returns (uint256)
1214     {
1215         return darknodeRegistry[darknodeID].registeredAt;
1216     }
1217 
1218     
1219     function darknodeDeregisteredAt(address darknodeID)
1220         external
1221         view
1222         onlyOwner
1223         returns (uint256)
1224     {
1225         return darknodeRegistry[darknodeID].deregisteredAt;
1226     }
1227 
1228     
1229     function darknodePublicKey(address darknodeID)
1230         external
1231         view
1232         onlyOwner
1233         returns (bytes memory)
1234     {
1235         return darknodeRegistry[darknodeID].publicKey;
1236     }
1237 }
1238 
1239 interface IDarknodePaymentStore {}
1240 
1241 interface IDarknodePayment {
1242     function changeCycle() external returns (uint256);
1243     function store() external view returns (IDarknodePaymentStore);
1244 }
1245 
1246 interface IDarknodeSlasher {}
1247 
1248 contract DarknodeRegistryStateV1 {
1249     using SafeMath for uint256;
1250 
1251     string public VERSION; 
1252 
1253     
1254     
1255     
1256     struct Epoch {
1257         uint256 epochhash;
1258         uint256 blocktime;
1259     }
1260 
1261     uint256 public numDarknodes;
1262     uint256 public numDarknodesNextEpoch;
1263     uint256 public numDarknodesPreviousEpoch;
1264 
1265     
1266     uint256 public minimumBond;
1267     uint256 public minimumPodSize;
1268     uint256 public minimumEpochInterval;
1269     uint256 public deregistrationInterval;
1270 
1271     
1272     
1273     
1274     uint256 public nextMinimumBond;
1275     uint256 public nextMinimumPodSize;
1276     uint256 public nextMinimumEpochInterval;
1277 
1278     
1279     Epoch public currentEpoch;
1280     Epoch public previousEpoch;
1281 
1282     
1283     RenToken public ren;
1284 
1285     
1286     DarknodeRegistryStore public store;
1287 
1288     
1289     IDarknodePayment public darknodePayment;
1290 
1291     
1292     IDarknodeSlasher public slasher;
1293     IDarknodeSlasher public nextSlasher;
1294 }
1295 
1296 contract DarknodeRegistryLogicV1 is
1297     Claimable,
1298     CanReclaimTokens,
1299     DarknodeRegistryStateV1
1300 {
1301     
1302     
1303     
1304     
1305     event LogDarknodeRegistered(
1306         address indexed _darknodeOperator,
1307         address indexed _darknodeID,
1308         uint256 _bond
1309     );
1310 
1311     
1312     
1313     
1314     event LogDarknodeDeregistered(
1315         address indexed _darknodeOperator,
1316         address indexed _darknodeID
1317     );
1318 
1319     
1320     
1321     
1322     event LogDarknodeRefunded(
1323         address indexed _darknodeOperator,
1324         address indexed _darknodeID,
1325         uint256 _amount
1326     );
1327 
1328     
1329     
1330     
1331     
1332     
1333     event LogDarknodeSlashed(
1334         address indexed _darknodeOperator,
1335         address indexed _darknodeID,
1336         address indexed _challenger,
1337         uint256 _percentage
1338     );
1339 
1340     
1341     event LogNewEpoch(uint256 indexed epochhash);
1342 
1343     
1344     event LogMinimumBondUpdated(
1345         uint256 _previousMinimumBond,
1346         uint256 _nextMinimumBond
1347     );
1348     event LogMinimumPodSizeUpdated(
1349         uint256 _previousMinimumPodSize,
1350         uint256 _nextMinimumPodSize
1351     );
1352     event LogMinimumEpochIntervalUpdated(
1353         uint256 _previousMinimumEpochInterval,
1354         uint256 _nextMinimumEpochInterval
1355     );
1356     event LogSlasherUpdated(
1357         address indexed _previousSlasher,
1358         address indexed _nextSlasher
1359     );
1360     event LogDarknodePaymentUpdated(
1361         IDarknodePayment indexed _previousDarknodePayment,
1362         IDarknodePayment indexed _nextDarknodePayment
1363     );
1364 
1365     
1366     modifier onlyDarknodeOperator(address _darknodeID) {
1367         require(
1368             store.darknodeOperator(_darknodeID) == msg.sender,
1369             "DarknodeRegistry: must be darknode owner"
1370         );
1371         _;
1372     }
1373 
1374     
1375     modifier onlyRefunded(address _darknodeID) {
1376         require(
1377             isRefunded(_darknodeID),
1378             "DarknodeRegistry: must be refunded or never registered"
1379         );
1380         _;
1381     }
1382 
1383     
1384     modifier onlyRefundable(address _darknodeID) {
1385         require(
1386             isRefundable(_darknodeID),
1387             "DarknodeRegistry: must be deregistered for at least one epoch"
1388         );
1389         _;
1390     }
1391 
1392     
1393     
1394     modifier onlyDeregisterable(address _darknodeID) {
1395         require(
1396             isDeregisterable(_darknodeID),
1397             "DarknodeRegistry: must be deregisterable"
1398         );
1399         _;
1400     }
1401 
1402     
1403     modifier onlySlasher() {
1404         require(
1405             address(slasher) == msg.sender,
1406             "DarknodeRegistry: must be slasher"
1407         );
1408         _;
1409     }
1410 
1411     
1412     
1413     modifier onlyDarknode(address _darknodeID) {
1414         require(
1415             isRegistered(_darknodeID),
1416             "DarknodeRegistry: invalid darknode"
1417         );
1418         _;
1419     }
1420 
1421     
1422     
1423     
1424     
1425     
1426     
1427     
1428     
1429     
1430     function initialize(
1431         string memory _VERSION,
1432         RenToken _renAddress,
1433         DarknodeRegistryStore _storeAddress,
1434         uint256 _minimumBond,
1435         uint256 _minimumPodSize,
1436         uint256 _minimumEpochIntervalSeconds,
1437         uint256 _deregistrationIntervalSeconds
1438     ) public initializer {
1439         Claimable.initialize(msg.sender);
1440         CanReclaimTokens.initialize(msg.sender);
1441         VERSION = _VERSION;
1442 
1443         store = _storeAddress;
1444         ren = _renAddress;
1445 
1446         minimumBond = _minimumBond;
1447         nextMinimumBond = minimumBond;
1448 
1449         minimumPodSize = _minimumPodSize;
1450         nextMinimumPodSize = minimumPodSize;
1451 
1452         minimumEpochInterval = _minimumEpochIntervalSeconds;
1453         nextMinimumEpochInterval = minimumEpochInterval;
1454         deregistrationInterval = _deregistrationIntervalSeconds;
1455 
1456         uint256 epochhash = uint256(blockhash(block.number - 1));
1457         currentEpoch = Epoch({
1458             epochhash: epochhash,
1459             blocktime: block.timestamp
1460         });
1461         emit LogNewEpoch(epochhash);
1462     }
1463 
1464     
1465     
1466     
1467     
1468     
1469     
1470     
1471     
1472     
1473     
1474     function register(address _darknodeID, bytes calldata _publicKey)
1475         external
1476         onlyRefunded(_darknodeID)
1477     {
1478         require(
1479             _darknodeID != address(0),
1480             "DarknodeRegistry: darknode address cannot be zero"
1481         );
1482 
1483         
1484         require(
1485             ren.transferFrom(msg.sender, address(store), minimumBond),
1486             "DarknodeRegistry: bond transfer failed"
1487         );
1488 
1489         
1490         store.appendDarknode(
1491             _darknodeID,
1492             msg.sender,
1493             minimumBond,
1494             _publicKey,
1495             currentEpoch.blocktime.add(minimumEpochInterval),
1496             0
1497         );
1498 
1499         numDarknodesNextEpoch = numDarknodesNextEpoch.add(1);
1500 
1501         
1502         emit LogDarknodeRegistered(msg.sender, _darknodeID, minimumBond);
1503     }
1504 
1505     
1506     
1507     
1508     
1509     
1510     
1511     function deregister(address _darknodeID)
1512         external
1513         onlyDeregisterable(_darknodeID)
1514         onlyDarknodeOperator(_darknodeID)
1515     {
1516         deregisterDarknode(_darknodeID);
1517     }
1518 
1519     
1520     
1521     
1522     function epoch() external {
1523         if (previousEpoch.blocktime == 0) {
1524             
1525             require(
1526                 msg.sender == owner(),
1527                 "DarknodeRegistry: not authorized to call first epoch"
1528             );
1529         }
1530 
1531         
1532         require(
1533             block.timestamp >= currentEpoch.blocktime.add(minimumEpochInterval),
1534             "DarknodeRegistry: epoch interval has not passed"
1535         );
1536         uint256 epochhash = uint256(blockhash(block.number - 1));
1537 
1538         
1539         previousEpoch = currentEpoch;
1540         currentEpoch = Epoch({
1541             epochhash: epochhash,
1542             blocktime: block.timestamp
1543         });
1544 
1545         
1546         numDarknodesPreviousEpoch = numDarknodes;
1547         numDarknodes = numDarknodesNextEpoch;
1548 
1549         
1550         if (nextMinimumBond != minimumBond) {
1551             minimumBond = nextMinimumBond;
1552             emit LogMinimumBondUpdated(minimumBond, nextMinimumBond);
1553         }
1554         if (nextMinimumPodSize != minimumPodSize) {
1555             minimumPodSize = nextMinimumPodSize;
1556             emit LogMinimumPodSizeUpdated(minimumPodSize, nextMinimumPodSize);
1557         }
1558         if (nextMinimumEpochInterval != minimumEpochInterval) {
1559             minimumEpochInterval = nextMinimumEpochInterval;
1560             emit LogMinimumEpochIntervalUpdated(
1561                 minimumEpochInterval,
1562                 nextMinimumEpochInterval
1563             );
1564         }
1565         if (nextSlasher != slasher) {
1566             slasher = nextSlasher;
1567             emit LogSlasherUpdated(address(slasher), address(nextSlasher));
1568         }
1569         if (address(darknodePayment) != address(0x0)) {
1570             darknodePayment.changeCycle();
1571         }
1572 
1573         
1574         emit LogNewEpoch(epochhash);
1575     }
1576 
1577     
1578     
1579     
1580     function transferStoreOwnership(DarknodeRegistryLogicV1 _newOwner)
1581         external
1582         onlyOwner
1583     {
1584         store.transferOwnership(address(_newOwner));
1585         _newOwner.claimStoreOwnership();
1586     }
1587 
1588     
1589     
1590     
1591     function claimStoreOwnership() external {
1592         store.claimOwnership();
1593 
1594         
1595         
1596         (
1597             numDarknodesPreviousEpoch,
1598             numDarknodes,
1599             numDarknodesNextEpoch
1600         ) = getDarknodeCountFromEpochs();
1601     }
1602 
1603     
1604     
1605     
1606     
1607     function updateDarknodePayment(IDarknodePayment _darknodePayment)
1608         external
1609         onlyOwner
1610     {
1611         require(
1612             address(_darknodePayment) != address(0x0),
1613             "DarknodeRegistry: invalid Darknode Payment address"
1614         );
1615         IDarknodePayment previousDarknodePayment = darknodePayment;
1616         darknodePayment = _darknodePayment;
1617         emit LogDarknodePaymentUpdated(
1618             previousDarknodePayment,
1619             darknodePayment
1620         );
1621     }
1622 
1623     
1624     
1625     
1626     function updateMinimumBond(uint256 _nextMinimumBond) external onlyOwner {
1627         
1628         nextMinimumBond = _nextMinimumBond;
1629     }
1630 
1631     
1632     
1633     function updateMinimumPodSize(uint256 _nextMinimumPodSize)
1634         external
1635         onlyOwner
1636     {
1637         
1638         nextMinimumPodSize = _nextMinimumPodSize;
1639     }
1640 
1641     
1642     
1643     function updateMinimumEpochInterval(uint256 _nextMinimumEpochInterval)
1644         external
1645         onlyOwner
1646     {
1647         
1648         nextMinimumEpochInterval = _nextMinimumEpochInterval;
1649     }
1650 
1651     
1652     
1653     
1654     function updateSlasher(IDarknodeSlasher _slasher) external onlyOwner {
1655         require(
1656             address(_slasher) != address(0),
1657             "DarknodeRegistry: invalid slasher address"
1658         );
1659         nextSlasher = _slasher;
1660     }
1661 
1662     
1663     
1664     
1665     
1666     
1667     function slash(address _guilty, address _challenger, uint256 _percentage)
1668         external
1669         onlySlasher
1670         onlyDarknode(_guilty)
1671     {
1672         require(_percentage <= 100, "DarknodeRegistry: invalid percent");
1673 
1674         
1675         if (isDeregisterable(_guilty)) {
1676             deregisterDarknode(_guilty);
1677         }
1678 
1679         uint256 totalBond = store.darknodeBond(_guilty);
1680         uint256 penalty = totalBond.div(100).mul(_percentage);
1681         uint256 challengerReward = penalty.div(2);
1682         uint256 darknodePaymentReward = penalty.sub(challengerReward);
1683         if (challengerReward > 0) {
1684             
1685             store.updateDarknodeBond(_guilty, totalBond.sub(penalty));
1686 
1687             
1688             require(
1689                 address(darknodePayment) != address(0x0),
1690                 "DarknodeRegistry: invalid payment address"
1691             );
1692             require(
1693                 ren.transfer(
1694                     address(darknodePayment.store()),
1695                     darknodePaymentReward
1696                 ),
1697                 "DarknodeRegistry: reward transfer failed"
1698             );
1699             require(
1700                 ren.transfer(_challenger, challengerReward),
1701                 "DarknodeRegistry: reward transfer failed"
1702             );
1703         }
1704 
1705         emit LogDarknodeSlashed(
1706             store.darknodeOperator(_guilty),
1707             _guilty,
1708             _challenger,
1709             _percentage
1710         );
1711     }
1712 
1713     
1714     
1715     
1716     
1717     
1718     function refund(address _darknodeID) external onlyRefundable(_darknodeID) {
1719         address darknodeOperator = store.darknodeOperator(_darknodeID);
1720 
1721         
1722         uint256 amount = store.darknodeBond(_darknodeID);
1723 
1724         
1725         store.removeDarknode(_darknodeID);
1726 
1727         
1728         require(
1729             ren.transfer(darknodeOperator, amount),
1730             "DarknodeRegistry: bond transfer failed"
1731         );
1732 
1733         
1734         emit LogDarknodeRefunded(darknodeOperator, _darknodeID, amount);
1735     }
1736 
1737     
1738     
1739     function getDarknodeOperator(address _darknodeID)
1740         external
1741         view
1742         returns (address payable)
1743     {
1744         return store.darknodeOperator(_darknodeID);
1745     }
1746 
1747     
1748     
1749     function getDarknodeBond(address _darknodeID)
1750         external
1751         view
1752         returns (uint256)
1753     {
1754         return store.darknodeBond(_darknodeID);
1755     }
1756 
1757     
1758     
1759     function getDarknodePublicKey(address _darknodeID)
1760         external
1761         view
1762         returns (bytes memory)
1763     {
1764         return store.darknodePublicKey(_darknodeID);
1765     }
1766 
1767     
1768     
1769     
1770     
1771     
1772     
1773     
1774     
1775     
1776     
1777     function getDarknodes(address _start, uint256 _count)
1778         external
1779         view
1780         returns (address[] memory)
1781     {
1782         uint256 count = _count;
1783         if (count == 0) {
1784             count = numDarknodes;
1785         }
1786         return getDarknodesFromEpochs(_start, count, false);
1787     }
1788 
1789     
1790     
1791     function getPreviousDarknodes(address _start, uint256 _count)
1792         external
1793         view
1794         returns (address[] memory)
1795     {
1796         uint256 count = _count;
1797         if (count == 0) {
1798             count = numDarknodesPreviousEpoch;
1799         }
1800         return getDarknodesFromEpochs(_start, count, true);
1801     }
1802 
1803     
1804     
1805     
1806     function isPendingRegistration(address _darknodeID)
1807         public
1808         view
1809         returns (bool)
1810     {
1811         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1812         return registeredAt != 0 && registeredAt > currentEpoch.blocktime;
1813     }
1814 
1815     
1816     
1817     function isPendingDeregistration(address _darknodeID)
1818         public
1819         view
1820         returns (bool)
1821     {
1822         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1823         return deregisteredAt != 0 && deregisteredAt > currentEpoch.blocktime;
1824     }
1825 
1826     
1827     function isDeregistered(address _darknodeID) public view returns (bool) {
1828         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1829         return deregisteredAt != 0 && deregisteredAt <= currentEpoch.blocktime;
1830     }
1831 
1832     
1833     
1834     
1835     function isDeregisterable(address _darknodeID) public view returns (bool) {
1836         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1837         
1838         
1839         return isRegistered(_darknodeID) && deregisteredAt == 0;
1840     }
1841 
1842     
1843     
1844     
1845     function isRefunded(address _darknodeID) public view returns (bool) {
1846         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1847         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1848         return registeredAt == 0 && deregisteredAt == 0;
1849     }
1850 
1851     
1852     
1853     function isRefundable(address _darknodeID) public view returns (bool) {
1854         return
1855             isDeregistered(_darknodeID) &&
1856             store.darknodeDeregisteredAt(_darknodeID) <=
1857             (previousEpoch.blocktime - deregistrationInterval);
1858     }
1859 
1860     
1861     function isRegistered(address _darknodeID) public view returns (bool) {
1862         return isRegisteredInEpoch(_darknodeID, currentEpoch);
1863     }
1864 
1865     
1866     function isRegisteredInPreviousEpoch(address _darknodeID)
1867         public
1868         view
1869         returns (bool)
1870     {
1871         return isRegisteredInEpoch(_darknodeID, previousEpoch);
1872     }
1873 
1874     
1875     
1876     
1877     
1878     function isRegisteredInEpoch(address _darknodeID, Epoch memory _epoch)
1879         private
1880         view
1881         returns (bool)
1882     {
1883         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1884         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1885         bool registered = registeredAt != 0 && registeredAt <= _epoch.blocktime;
1886         bool notDeregistered = deregisteredAt == 0 ||
1887             deregisteredAt > _epoch.blocktime;
1888         
1889         
1890         return registered && notDeregistered;
1891     }
1892 
1893     
1894     
1895     
1896     
1897     
1898     function getDarknodesFromEpochs(
1899         address _start,
1900         uint256 _count,
1901         bool _usePreviousEpoch
1902     ) private view returns (address[] memory) {
1903         uint256 count = _count;
1904         if (count == 0) {
1905             count = numDarknodes;
1906         }
1907 
1908         address[] memory nodes = new address[](count);
1909 
1910         
1911         uint256 n = 0;
1912         address next = _start;
1913         if (next == address(0)) {
1914             next = store.begin();
1915         }
1916 
1917         
1918         while (n < count) {
1919             if (next == address(0)) {
1920                 break;
1921             }
1922             
1923             bool includeNext;
1924             if (_usePreviousEpoch) {
1925                 includeNext = isRegisteredInPreviousEpoch(next);
1926             } else {
1927                 includeNext = isRegistered(next);
1928             }
1929             if (!includeNext) {
1930                 next = store.next(next);
1931                 continue;
1932             }
1933             nodes[n] = next;
1934             next = store.next(next);
1935             n += 1;
1936         }
1937         return nodes;
1938     }
1939 
1940     
1941     function deregisterDarknode(address _darknodeID) private {
1942         address darknodeOperator = store.darknodeOperator(_darknodeID);
1943 
1944         
1945         store.updateDarknodeDeregisteredAt(
1946             _darknodeID,
1947             currentEpoch.blocktime.add(minimumEpochInterval)
1948         );
1949         numDarknodesNextEpoch = numDarknodesNextEpoch.sub(1);
1950 
1951         
1952         emit LogDarknodeDeregistered(darknodeOperator, _darknodeID);
1953     }
1954 
1955     function getDarknodeCountFromEpochs()
1956         private
1957         view
1958         returns (uint256, uint256, uint256)
1959     {
1960         
1961         uint256 nPreviousEpoch = 0;
1962         uint256 nCurrentEpoch = 0;
1963         uint256 nNextEpoch = 0;
1964         address next = store.begin();
1965 
1966         
1967         while (true) {
1968             
1969             if (next == address(0)) {
1970                 break;
1971             }
1972 
1973             if (isRegisteredInPreviousEpoch(next)) {
1974                 nPreviousEpoch += 1;
1975             }
1976 
1977             if (isRegistered(next)) {
1978                 nCurrentEpoch += 1;
1979             }
1980 
1981             
1982             
1983             if (
1984                 ((isRegistered(next) && !isPendingDeregistration(next)) ||
1985                     isPendingRegistration(next))
1986             ) {
1987                 nNextEpoch += 1;
1988             }
1989             next = store.next(next);
1990         }
1991         return (nPreviousEpoch, nCurrentEpoch, nNextEpoch);
1992     }
1993 }
1994 
1995 contract DarknodeRegistryProxy is InitializableAdminUpgradeabilityProxy {}
1996 
1997 contract DarknodePaymentStore is Claimable {
1998     using SafeMath for uint256;
1999     using SafeERC20 for ERC20;
2000     using ERC20WithFees for ERC20;
2001 
2002     string public VERSION; 
2003 
2004     
2005     address public constant ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
2006 
2007     
2008     mapping(address => mapping(address => uint256)) public darknodeBalances;
2009 
2010     
2011     mapping(address => uint256) public lockedBalances;
2012 
2013     
2014     
2015     
2016     constructor(string memory _VERSION) public {
2017         Claimable.initialize(msg.sender);
2018         VERSION = _VERSION;
2019     }
2020 
2021     
2022     function() external payable {}
2023 
2024     
2025     
2026     
2027     
2028     function totalBalance(address _token) public view returns (uint256) {
2029         if (_token == ETHEREUM) {
2030             return address(this).balance;
2031         } else {
2032             return ERC20(_token).balanceOf(address(this));
2033         }
2034     }
2035 
2036     
2037     
2038     
2039     
2040     
2041     
2042     function availableBalance(address _token) public view returns (uint256) {
2043         return
2044             totalBalance(_token).sub(
2045                 lockedBalances[_token],
2046                 "DarknodePaymentStore: locked balance exceed total balance"
2047             );
2048     }
2049 
2050     
2051     
2052     
2053     
2054     
2055     
2056     function incrementDarknodeBalance(
2057         address _darknode,
2058         address _token,
2059         uint256 _amount
2060     ) external onlyOwner {
2061         require(_amount > 0, "DarknodePaymentStore: invalid amount");
2062         require(
2063             availableBalance(_token) >= _amount,
2064             "DarknodePaymentStore: insufficient contract balance"
2065         );
2066 
2067         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token]
2068             .add(_amount);
2069         lockedBalances[_token] = lockedBalances[_token].add(_amount);
2070     }
2071 
2072     
2073     
2074     
2075     
2076     
2077     
2078     function transfer(
2079         address _darknode,
2080         address _token,
2081         uint256 _amount,
2082         address payable _recipient
2083     ) external onlyOwner {
2084         require(
2085             darknodeBalances[_darknode][_token] >= _amount,
2086             "DarknodePaymentStore: insufficient darknode balance"
2087         );
2088         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token]
2089             .sub(
2090             _amount,
2091             "DarknodePaymentStore: insufficient darknode balance for transfer"
2092         );
2093         lockedBalances[_token] = lockedBalances[_token].sub(
2094             _amount,
2095             "DarknodePaymentStore: insufficient token balance for transfer"
2096         );
2097 
2098         if (_token == ETHEREUM) {
2099             _recipient.transfer(_amount);
2100         } else {
2101             ERC20(_token).safeTransfer(_recipient, _amount);
2102         }
2103     }
2104 
2105 }
2106 
2107 contract DarknodePayment is Claimable {
2108     using SafeMath for uint256;
2109     using SafeERC20 for ERC20;
2110     using ERC20WithFees for ERC20;
2111 
2112     string public VERSION; 
2113 
2114     
2115     address public constant ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
2116 
2117     DarknodeRegistryLogicV1 public darknodeRegistry; 
2118 
2119     
2120     
2121     DarknodePaymentStore public store; 
2122 
2123     
2124     
2125     address public cycleChanger;
2126 
2127     uint256 public currentCycle;
2128     uint256 public previousCycle;
2129 
2130     
2131     
2132     
2133     address[] public pendingTokens;
2134 
2135     
2136     
2137     address[] public registeredTokens;
2138 
2139     
2140     
2141     mapping(address => uint256) public registeredTokenIndex;
2142 
2143     
2144     
2145     
2146     mapping(address => uint256) public unclaimedRewards;
2147 
2148     
2149     
2150     mapping(address => uint256) public previousCycleRewardShare;
2151 
2152     
2153     uint256 public cycleStartTime;
2154 
2155     
2156     uint256 public nextCyclePayoutPercent;
2157 
2158     
2159     uint256 public currentCyclePayoutPercent;
2160 
2161     
2162     
2163     
2164     mapping(address => mapping(uint256 => bool)) public rewardClaimed;
2165 
2166     
2167     
2168     
2169     event LogDarknodeClaim(address indexed _darknode, uint256 _cycle);
2170 
2171     
2172     
2173     
2174     
2175     event LogPaymentReceived(
2176         address indexed _payer,
2177         address indexed _token,
2178         uint256 _amount
2179     );
2180 
2181     
2182     
2183     
2184     
2185     
2186     event LogDarknodeWithdrew(
2187         address indexed _darknodeOperator,
2188         address indexed _darknodeID,
2189         address indexed _token,
2190         uint256 _value
2191     );
2192 
2193     
2194     
2195     
2196     event LogPayoutPercentChanged(uint256 _newPercent, uint256 _oldPercent);
2197 
2198     
2199     
2200     
2201     event LogCycleChangerChanged(
2202         address indexed _newCycleChanger,
2203         address indexed _oldCycleChanger
2204     );
2205 
2206     
2207     
2208     event LogTokenRegistered(address indexed _token);
2209 
2210     
2211     
2212     event LogTokenDeregistered(address indexed _token);
2213 
2214     
2215     
2216     
2217     event LogDarknodeRegistryUpdated(
2218         DarknodeRegistryLogicV1 indexed _previousDarknodeRegistry,
2219         DarknodeRegistryLogicV1 indexed _nextDarknodeRegistry
2220     );
2221 
2222     
2223     modifier onlyDarknode(address _darknode) {
2224         require(
2225             darknodeRegistry.isRegistered(_darknode),
2226             "DarknodePayment: darknode is not registered"
2227         );
2228         _;
2229     }
2230 
2231     
2232     modifier validPercent(uint256 _percent) {
2233         require(_percent <= 100, "DarknodePayment: invalid percentage");
2234         _;
2235     }
2236 
2237     
2238     modifier onlyCycleChanger {
2239         require(
2240             msg.sender == cycleChanger,
2241             "DarknodePayment: not cycle changer"
2242         );
2243         _;
2244     }
2245 
2246     
2247     
2248     
2249     
2250     
2251     
2252     
2253     constructor(
2254         string memory _VERSION,
2255         DarknodeRegistryLogicV1 _darknodeRegistry,
2256         DarknodePaymentStore _darknodePaymentStore,
2257         uint256 _cyclePayoutPercent
2258     ) public validPercent(_cyclePayoutPercent) {
2259         Claimable.initialize(msg.sender);
2260         VERSION = _VERSION;
2261         darknodeRegistry = _darknodeRegistry;
2262         store = _darknodePaymentStore;
2263         nextCyclePayoutPercent = _cyclePayoutPercent;
2264         
2265         cycleChanger = msg.sender;
2266 
2267         
2268         (currentCycle, cycleStartTime) = darknodeRegistry.currentEpoch();
2269         currentCyclePayoutPercent = nextCyclePayoutPercent;
2270     }
2271 
2272     
2273     
2274     
2275     
2276     function updateDarknodeRegistry(DarknodeRegistryLogicV1 _darknodeRegistry)
2277         external
2278         onlyOwner
2279     {
2280         require(
2281             address(_darknodeRegistry) != address(0x0),
2282             "DarknodePayment: invalid Darknode Registry address"
2283         );
2284         DarknodeRegistryLogicV1 previousDarknodeRegistry = darknodeRegistry;
2285         darknodeRegistry = _darknodeRegistry;
2286         emit LogDarknodeRegistryUpdated(
2287             previousDarknodeRegistry,
2288             darknodeRegistry
2289         );
2290     }
2291 
2292     
2293     
2294     
2295     
2296     
2297     function withdraw(address _darknode, address _token) public {
2298         address payable darknodeOperator = darknodeRegistry.getDarknodeOperator(
2299             _darknode
2300         );
2301         require(
2302             darknodeOperator != address(0x0),
2303             "DarknodePayment: invalid darknode owner"
2304         );
2305 
2306         uint256 amount = store.darknodeBalances(_darknode, _token);
2307 
2308         
2309         if (amount > 0) {
2310             store.transfer(_darknode, _token, amount, darknodeOperator);
2311             emit LogDarknodeWithdrew(
2312                 darknodeOperator,
2313                 _darknode,
2314                 _token,
2315                 amount
2316             );
2317         }
2318     }
2319 
2320     function withdrawMultiple(
2321         address[] calldata _darknodes,
2322         address[] calldata _tokens
2323     ) external {
2324         for (uint256 i = 0; i < _darknodes.length; i++) {
2325             for (uint256 j = 0; j < _tokens.length; j++) {
2326                 withdraw(_darknodes[i], _tokens[j]);
2327             }
2328         }
2329     }
2330 
2331     
2332     function() external payable {
2333         address(store).transfer(msg.value);
2334         emit LogPaymentReceived(msg.sender, ETHEREUM, msg.value);
2335     }
2336 
2337     
2338     
2339     function currentCycleRewardPool(address _token)
2340         external
2341         view
2342         returns (uint256)
2343     {
2344         uint256 total = store.availableBalance(_token).sub(
2345             unclaimedRewards[_token],
2346             "DarknodePayment: unclaimed rewards exceed total rewards"
2347         );
2348         return total.div(100).mul(currentCyclePayoutPercent);
2349     }
2350 
2351     function darknodeBalances(address _darknodeID, address _token)
2352         external
2353         view
2354         returns (uint256)
2355     {
2356         return store.darknodeBalances(_darknodeID, _token);
2357     }
2358 
2359     
2360     function changeCycle() external onlyCycleChanger returns (uint256) {
2361         
2362         uint256 arrayLength = registeredTokens.length;
2363         for (uint256 i = 0; i < arrayLength; i++) {
2364             _snapshotBalance(registeredTokens[i]);
2365         }
2366 
2367         
2368         previousCycle = currentCycle;
2369         (currentCycle, cycleStartTime) = darknodeRegistry.currentEpoch();
2370         currentCyclePayoutPercent = nextCyclePayoutPercent;
2371 
2372         
2373         _updateTokenList();
2374         return currentCycle;
2375     }
2376 
2377     
2378     
2379     
2380     
2381     function deposit(uint256 _value, address _token) external payable {
2382         uint256 receivedValue;
2383         if (_token == ETHEREUM) {
2384             require(
2385                 _value == msg.value,
2386                 "DarknodePayment: mismatched deposit value"
2387             );
2388             receivedValue = msg.value;
2389             address(store).transfer(msg.value);
2390         } else {
2391             require(
2392                 msg.value == 0,
2393                 "DarknodePayment: unexpected ether transfer"
2394             );
2395             require(
2396                 registeredTokenIndex[_token] != 0,
2397                 "DarknodePayment: token not registered"
2398             );
2399             
2400             receivedValue = ERC20(_token).safeTransferFromWithFees(
2401                 msg.sender,
2402                 address(store),
2403                 _value
2404             );
2405         }
2406         emit LogPaymentReceived(msg.sender, _token, receivedValue);
2407     }
2408 
2409     
2410     
2411     
2412     
2413     function forward(address _token) external {
2414         if (_token == ETHEREUM) {
2415             
2416             
2417             
2418             
2419             address(store).transfer(address(this).balance);
2420         } else {
2421             ERC20(_token).safeTransfer(
2422                 address(store),
2423                 ERC20(_token).balanceOf(address(this))
2424             );
2425         }
2426     }
2427 
2428     
2429     
2430     function claim(address _darknode) external onlyDarknode(_darknode) {
2431         require(
2432             darknodeRegistry.isRegisteredInPreviousEpoch(_darknode),
2433             "DarknodePayment: cannot claim for this epoch"
2434         );
2435         
2436         _claimDarknodeReward(_darknode);
2437         emit LogDarknodeClaim(_darknode, previousCycle);
2438     }
2439 
2440     
2441     
2442     
2443     
2444     function registerToken(address _token) external onlyOwner {
2445         require(
2446             registeredTokenIndex[_token] == 0,
2447             "DarknodePayment: token already registered"
2448         );
2449         require(
2450             !tokenPendingRegistration(_token),
2451             "DarknodePayment: token already pending registration"
2452         );
2453         pendingTokens.push(_token);
2454     }
2455 
2456     function tokenPendingRegistration(address _token)
2457         public
2458         view
2459         returns (bool)
2460     {
2461         uint256 arrayLength = pendingTokens.length;
2462         for (uint256 i = 0; i < arrayLength; i++) {
2463             if (pendingTokens[i] == _token) {
2464                 return true;
2465             }
2466         }
2467         return false;
2468     }
2469 
2470     
2471     
2472     
2473     
2474     function deregisterToken(address _token) external onlyOwner {
2475         require(
2476             registeredTokenIndex[_token] > 0,
2477             "DarknodePayment: token not registered"
2478         );
2479         _deregisterToken(_token);
2480     }
2481 
2482     
2483     
2484     
2485     function updateCycleChanger(address _addr) external onlyOwner {
2486         require(
2487             _addr != address(0),
2488             "DarknodePayment: invalid contract address"
2489         );
2490         emit LogCycleChangerChanged(_addr, cycleChanger);
2491         cycleChanger = _addr;
2492     }
2493 
2494     
2495     
2496     
2497     function updatePayoutPercentage(uint256 _percent)
2498         external
2499         onlyOwner
2500         validPercent(_percent)
2501     {
2502         uint256 oldPayoutPercent = nextCyclePayoutPercent;
2503         nextCyclePayoutPercent = _percent;
2504         emit LogPayoutPercentChanged(nextCyclePayoutPercent, oldPayoutPercent);
2505     }
2506 
2507     
2508     
2509     
2510     
2511     function transferStoreOwnership(DarknodePayment _newOwner)
2512         external
2513         onlyOwner
2514     {
2515         store.transferOwnership(address(_newOwner));
2516         _newOwner.claimStoreOwnership();
2517     }
2518 
2519     
2520     
2521     
2522     function claimStoreOwnership() external {
2523         store.claimOwnership();
2524     }
2525 
2526     
2527     
2528     
2529     
2530     
2531     function _claimDarknodeReward(address _darknode) private {
2532         require(
2533             !rewardClaimed[_darknode][previousCycle],
2534             "DarknodePayment: reward already claimed"
2535         );
2536         rewardClaimed[_darknode][previousCycle] = true;
2537         uint256 arrayLength = registeredTokens.length;
2538         for (uint256 i = 0; i < arrayLength; i++) {
2539             address token = registeredTokens[i];
2540 
2541             
2542             if (previousCycleRewardShare[token] > 0) {
2543                 unclaimedRewards[token] = unclaimedRewards[token].sub(
2544                     previousCycleRewardShare[token],
2545                     "DarknodePayment: share exceeds unclaimed rewards"
2546                 );
2547                 store.incrementDarknodeBalance(
2548                     _darknode,
2549                     token,
2550                     previousCycleRewardShare[token]
2551                 );
2552             }
2553         }
2554     }
2555 
2556     
2557     
2558     
2559     
2560     function _snapshotBalance(address _token) private {
2561         uint256 shareCount = darknodeRegistry.numDarknodesPreviousEpoch();
2562         if (shareCount == 0) {
2563             unclaimedRewards[_token] = 0;
2564             previousCycleRewardShare[_token] = 0;
2565         } else {
2566             
2567             uint256 total = store.availableBalance(_token);
2568             unclaimedRewards[_token] = total.div(100).mul(
2569                 currentCyclePayoutPercent
2570             );
2571             previousCycleRewardShare[_token] = unclaimedRewards[_token].div(
2572                 shareCount
2573             );
2574         }
2575     }
2576 
2577     
2578     
2579     
2580     
2581     function _deregisterToken(address _token) private {
2582         address lastToken = registeredTokens[registeredTokens.length.sub(
2583             1,
2584             "DarknodePayment: no tokens registered"
2585         )];
2586         uint256 deletedTokenIndex = registeredTokenIndex[_token].sub(1);
2587         
2588         registeredTokens[deletedTokenIndex] = lastToken;
2589         registeredTokenIndex[lastToken] = registeredTokenIndex[_token];
2590         
2591         
2592         registeredTokens.pop();
2593         registeredTokenIndex[_token] = 0;
2594 
2595         emit LogTokenDeregistered(_token);
2596     }
2597 
2598     
2599     
2600     function _updateTokenList() private {
2601         
2602         uint256 arrayLength = pendingTokens.length;
2603         for (uint256 i = 0; i < arrayLength; i++) {
2604             address token = pendingTokens[i];
2605             registeredTokens.push(token);
2606             registeredTokenIndex[token] = registeredTokens.length;
2607             emit LogTokenRegistered(token);
2608         }
2609         pendingTokens.length = 0;
2610     }
2611 
2612 }