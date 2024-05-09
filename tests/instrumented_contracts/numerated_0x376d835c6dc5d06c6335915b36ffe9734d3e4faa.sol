1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: b6c3d07
6 Repository: https://github.com/renproject/darknode-sol
7 Issues: https://github.com/renproject/darknode-sol/issues
8 
9 Licenses
10 openzeppelin-solidity: (MIT) https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
11 darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity ^0.5.12;
16 
17 
18 contract Context {
19     
20     
21     constructor () internal { }
22     
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view returns (bytes memory) {
29         this; 
30         return msg.data;
31     }
32 }
33 
34 contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     
40     constructor () internal {
41         _owner = _msgSender();
42         emit OwnershipTransferred(address(0), _owner);
43     }
44 
45     
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     
51     modifier onlyOwner() {
52         require(isOwner(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     
57     function isOwner() public view returns (bool) {
58         return _msgSender() == _owner;
59     }
60 
61     
62     function renounceOwnership() public onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     
68     function transferOwnership(address newOwner) public onlyOwner {
69         _transferOwnership(newOwner);
70     }
71 
72     
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 library SafeMath {
81     
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85 
86         return c;
87     }
88 
89     
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93 
94     
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         
105         
106         
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         
128 
129         return c;
130     }
131 
132     
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     
138     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b != 0, errorMessage);
140         return a % b;
141     }
142 }
143 
144 interface IERC20 {
145     
146     function totalSupply() external view returns (uint256);
147 
148     
149     function balanceOf(address account) external view returns (uint256);
150 
151     
152     function transfer(address recipient, uint256 amount) external returns (bool);
153 
154     
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 contract ERC20 is Context, IERC20 {
171     using SafeMath for uint256;
172 
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     
180     function totalSupply() public view returns (uint256) {
181         return _totalSupply;
182     }
183 
184     
185     function balanceOf(address account) public view returns (uint256) {
186         return _balances[account];
187     }
188 
189     
190     function transfer(address recipient, uint256 amount) public returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     
196     function allowance(address owner, address spender) public view returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     
201     function approve(address spender, uint256 amount) public returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     
207     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     
214     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
216         return true;
217     }
218 
219     
220     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
222         return true;
223     }
224 
225     
226     function _transfer(address sender, address recipient, uint256 amount) internal {
227         require(sender != address(0), "ERC20: transfer from the zero address");
228         require(recipient != address(0), "ERC20: transfer to the zero address");
229 
230         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
231         _balances[recipient] = _balances[recipient].add(amount);
232         emit Transfer(sender, recipient, amount);
233     }
234 
235     
236     function _mint(address account, uint256 amount) internal {
237         require(account != address(0), "ERC20: mint to the zero address");
238 
239         _totalSupply = _totalSupply.add(amount);
240         _balances[account] = _balances[account].add(amount);
241         emit Transfer(address(0), account, amount);
242     }
243 
244      
245     function _burn(address account, uint256 amount) internal {
246         require(account != address(0), "ERC20: burn from the zero address");
247 
248         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
249         _totalSupply = _totalSupply.sub(amount);
250         emit Transfer(account, address(0), amount);
251     }
252 
253     
254     function _approve(address owner, address spender, uint256 amount) internal {
255         require(owner != address(0), "ERC20: approve from the zero address");
256         require(spender != address(0), "ERC20: approve to the zero address");
257 
258         _allowances[owner][spender] = amount;
259         emit Approval(owner, spender, amount);
260     }
261 
262     
263     function _burnFrom(address account, uint256 amount) internal {
264         _burn(account, amount);
265         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
266     }
267 }
268 
269 library Address {
270     
271     function isContract(address account) internal view returns (bool) {
272         
273         
274         
275 
276         
277         
278         
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         
282         assembly { codehash := extcodehash(account) }
283         return (codehash != 0x0 && codehash != accountHash);
284     }
285 
286     
287     function toPayable(address account) internal pure returns (address payable) {
288         return address(uint160(account));
289     }
290 
291     
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         
296         (bool success, ) = recipient.call.value(amount)("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 }
300 
301 library SafeERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     function safeTransfer(IERC20 token, address to, uint256 value) internal {
306         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
307     }
308 
309     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
310         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
311     }
312 
313     function safeApprove(IERC20 token, address spender, uint256 value) internal {
314         
315         
316         
317         
318         require((value == 0) || (token.allowance(address(this), spender) == 0),
319             "SafeERC20: approve from non-zero to non-zero allowance"
320         );
321         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
331         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     
335     function callOptionalReturn(IERC20 token, bytes memory data) private {
336         
337         
338 
339         
340         
341         
342         
343         
344         require(address(token).isContract(), "SafeERC20: call to non-contract");
345 
346         
347         (bool success, bytes memory returndata) = address(token).call(data);
348         require(success, "SafeERC20: low-level call failed");
349 
350         if (returndata.length > 0) { 
351             
352             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
353         }
354     }
355 }
356 
357 library Math {
358     
359     function max(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a >= b ? a : b;
361     }
362 
363     
364     function min(uint256 a, uint256 b) internal pure returns (uint256) {
365         return a < b ? a : b;
366     }
367 
368     
369     function average(uint256 a, uint256 b) internal pure returns (uint256) {
370         
371         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
372     }
373 }
374 
375 library ERC20WithFees {
376     using SafeMath for uint256;
377     using SafeERC20 for IERC20;
378 
379     
380     
381     function safeTransferFromWithFees(IERC20 token, address from, address to, uint256 value) internal returns (uint256) {
382         uint256 balancesBefore = token.balanceOf(to);
383         token.safeTransferFrom(from, to, value);
384         uint256 balancesAfter = token.balanceOf(to);
385         return Math.min(value, balancesAfter.sub(balancesBefore));
386     }
387 }
388 
389 contract ERC20Detailed is IERC20 {
390     string private _name;
391     string private _symbol;
392     uint8 private _decimals;
393 
394     
395     constructor (string memory name, string memory symbol, uint8 decimals) public {
396         _name = name;
397         _symbol = symbol;
398         _decimals = decimals;
399     }
400 
401     
402     function name() public view returns (string memory) {
403         return _name;
404     }
405 
406     
407     function symbol() public view returns (string memory) {
408         return _symbol;
409     }
410 
411     
412     function decimals() public view returns (uint8) {
413         return _decimals;
414     }
415 }
416 
417 library Roles {
418     struct Role {
419         mapping (address => bool) bearer;
420     }
421 
422     
423     function add(Role storage role, address account) internal {
424         require(!has(role, account), "Roles: account already has role");
425         role.bearer[account] = true;
426     }
427 
428     
429     function remove(Role storage role, address account) internal {
430         require(has(role, account), "Roles: account does not have role");
431         role.bearer[account] = false;
432     }
433 
434     
435     function has(Role storage role, address account) internal view returns (bool) {
436         require(account != address(0), "Roles: account is the zero address");
437         return role.bearer[account];
438     }
439 }
440 
441 contract PauserRole is Context {
442     using Roles for Roles.Role;
443 
444     event PauserAdded(address indexed account);
445     event PauserRemoved(address indexed account);
446 
447     Roles.Role private _pausers;
448 
449     constructor () internal {
450         _addPauser(_msgSender());
451     }
452 
453     modifier onlyPauser() {
454         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
455         _;
456     }
457 
458     function isPauser(address account) public view returns (bool) {
459         return _pausers.has(account);
460     }
461 
462     function addPauser(address account) public onlyPauser {
463         _addPauser(account);
464     }
465 
466     function renouncePauser() public {
467         _removePauser(_msgSender());
468     }
469 
470     function _addPauser(address account) internal {
471         _pausers.add(account);
472         emit PauserAdded(account);
473     }
474 
475     function _removePauser(address account) internal {
476         _pausers.remove(account);
477         emit PauserRemoved(account);
478     }
479 }
480 
481 contract Pausable is Context, PauserRole {
482     
483     event Paused(address account);
484 
485     
486     event Unpaused(address account);
487 
488     bool private _paused;
489 
490     
491     constructor () internal {
492         _paused = false;
493     }
494 
495     
496     function paused() public view returns (bool) {
497         return _paused;
498     }
499 
500     
501     modifier whenNotPaused() {
502         require(!_paused, "Pausable: paused");
503         _;
504     }
505 
506     
507     modifier whenPaused() {
508         require(_paused, "Pausable: not paused");
509         _;
510     }
511 
512     
513     function pause() public onlyPauser whenNotPaused {
514         _paused = true;
515         emit Paused(_msgSender());
516     }
517 
518     
519     function unpause() public onlyPauser whenPaused {
520         _paused = false;
521         emit Unpaused(_msgSender());
522     }
523 }
524 
525 contract ERC20Pausable is ERC20, Pausable {
526     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
527         return super.transfer(to, value);
528     }
529 
530     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
531         return super.transferFrom(from, to, value);
532     }
533 
534     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
535         return super.approve(spender, value);
536     }
537 
538     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
539         return super.increaseAllowance(spender, addedValue);
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
543         return super.decreaseAllowance(spender, subtractedValue);
544     }
545 }
546 
547 contract ERC20Burnable is Context, ERC20 {
548     
549     function burn(uint256 amount) public {
550         _burn(_msgSender(), amount);
551     }
552 
553     
554     function burnFrom(address account, uint256 amount) public {
555         _burnFrom(account, amount);
556     }
557 }
558 
559 contract RenToken is Ownable, ERC20Detailed, ERC20Pausable, ERC20Burnable {
560 
561     string private constant _name = "Republic Token";
562     string private constant _symbol = "REN";
563     uint8 private constant _decimals = 18;
564 
565     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(_decimals);
566 
567     
568     constructor() ERC20Burnable() ERC20Pausable() ERC20Detailed(_name, _symbol, _decimals) public {
569         _mint(msg.sender, INITIAL_SUPPLY);
570     }
571 
572     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
573         
574         
575         require(amount > 0);
576 
577         _transfer(msg.sender, beneficiary, amount);
578         emit Transfer(msg.sender, beneficiary, amount);
579 
580         return true;
581     }
582 }
583 
584 contract Claimable {
585     address private _pendingOwner;
586     address private _owner;
587 
588     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
589 
590     
591     constructor () internal {
592         _owner = msg.sender;
593         emit OwnershipTransferred(address(0), _owner);
594     }
595 
596     
597     function owner() public view returns (address) {
598         return _owner;
599     }
600 
601     
602     modifier onlyOwner() {
603         require(isOwner(), "Claimable: caller is not the owner");
604         _;
605     }
606 
607     
608     modifier onlyPendingOwner() {
609       require(msg.sender == _pendingOwner, "Claimable: caller is not the pending owner");
610       _;
611     }
612 
613     
614     function isOwner() public view returns (bool) {
615         return msg.sender == _owner;
616     }
617 
618     
619     function renounceOwnership() public onlyOwner {
620         emit OwnershipTransferred(_owner, address(0));
621         _owner = address(0);
622     }
623 
624     
625     function transferOwnership(address newOwner) public onlyOwner {
626       _pendingOwner = newOwner;
627     }
628 
629     
630     function claimOwnership() public onlyPendingOwner {
631       emit OwnershipTransferred(_owner, _pendingOwner);
632       _owner = _pendingOwner;
633       _pendingOwner = address(0);
634     }
635 }
636 
637 library LinkedList {
638 
639     
640     address public constant NULL = address(0);
641 
642     
643     struct Node {
644         bool inList;
645         address previous;
646         address next;
647     }
648 
649     
650     struct List {
651         mapping (address => Node) list;
652     }
653 
654     
655     function insertBefore(List storage self, address target, address newNode) internal {
656         require(!isInList(self, newNode), "LinkedList: already in list");
657         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
658 
659         
660         address prev = self.list[target].previous;
661 
662         self.list[newNode].next = target;
663         self.list[newNode].previous = prev;
664         self.list[target].previous = newNode;
665         self.list[prev].next = newNode;
666 
667         self.list[newNode].inList = true;
668     }
669 
670     
671     function insertAfter(List storage self, address target, address newNode) internal {
672         require(!isInList(self, newNode), "LinkedList: already in list");
673         require(isInList(self, target) || target == NULL, "LinkedList: not in list");
674 
675         
676         address n = self.list[target].next;
677 
678         self.list[newNode].previous = target;
679         self.list[newNode].next = n;
680         self.list[target].next = newNode;
681         self.list[n].previous = newNode;
682 
683         self.list[newNode].inList = true;
684     }
685 
686     
687     function remove(List storage self, address node) internal {
688         require(isInList(self, node), "LinkedList: not in list");
689         if (node == NULL) {
690             return;
691         }
692         address p = self.list[node].previous;
693         address n = self.list[node].next;
694 
695         self.list[p].next = n;
696         self.list[n].previous = p;
697 
698         
699         
700         self.list[node].inList = false;
701         delete self.list[node];
702     }
703 
704     
705     function prepend(List storage self, address node) internal {
706         
707 
708         insertBefore(self, begin(self), node);
709     }
710 
711     
712     function append(List storage self, address node) internal {
713         
714 
715         insertAfter(self, end(self), node);
716     }
717 
718     function swap(List storage self, address left, address right) internal {
719         
720 
721         address previousRight = self.list[right].previous;
722         remove(self, right);
723         insertAfter(self, left, right);
724         remove(self, left);
725         insertAfter(self, previousRight, left);
726     }
727 
728     function isInList(List storage self, address node) internal view returns (bool) {
729         return self.list[node].inList;
730     }
731 
732     
733     function begin(List storage self) internal view returns (address) {
734         return self.list[NULL].next;
735     }
736 
737     
738     function end(List storage self) internal view returns (address) {
739         return self.list[NULL].previous;
740     }
741 
742     function next(List storage self, address node) internal view returns (address) {
743         require(isInList(self, node), "LinkedList: not in list");
744         return self.list[node].next;
745     }
746 
747     function previous(List storage self, address node) internal view returns (address) {
748         require(isInList(self, node), "LinkedList: not in list");
749         return self.list[node].previous;
750     }
751 
752 }
753 
754 contract DarknodeRegistryStore is Claimable {
755     using SafeMath for uint256;
756 
757     string public VERSION; 
758 
759     
760     
761     
762     
763     
764     struct Darknode {
765         
766         
767         
768         
769         address payable owner;
770 
771         
772         
773         
774         uint256 bond;
775 
776         
777         uint256 registeredAt;
778 
779         
780         uint256 deregisteredAt;
781 
782         
783         
784         
785         
786         bytes publicKey;
787     }
788 
789     
790     mapping(address => Darknode) private darknodeRegistry;
791     LinkedList.List private darknodes;
792 
793     
794     RenToken public ren;
795 
796     
797     
798     
799     
800     constructor(
801         string memory _VERSION,
802         RenToken _ren
803     ) public {
804         VERSION = _VERSION;
805         ren = _ren;
806     }
807 
808     
809     
810     
811     
812     function recoverTokens(address _token) external onlyOwner {
813         require(_token != address(ren), "DarknodeRegistryStore: not allowed to recover REN");
814 
815         if (_token == address(0x0)) {
816             msg.sender.transfer(address(this).balance);
817         } else {
818             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
819         }
820     }
821 
822     
823     
824     
825     
826     
827     
828     
829     
830     
831     function appendDarknode(
832         address _darknodeID,
833         address payable _darknodeOwner,
834         uint256 _bond,
835         bytes calldata _publicKey,
836         uint256 _registeredAt,
837         uint256 _deregisteredAt
838     ) external onlyOwner {
839         Darknode memory darknode = Darknode({
840             owner: _darknodeOwner,
841             bond: _bond,
842             publicKey: _publicKey,
843             registeredAt: _registeredAt,
844             deregisteredAt: _deregisteredAt
845         });
846         darknodeRegistry[_darknodeID] = darknode;
847         LinkedList.append(darknodes, _darknodeID);
848     }
849 
850     
851     function begin() external view onlyOwner returns(address) {
852         return LinkedList.begin(darknodes);
853     }
854 
855     
856     
857     function next(address darknodeID) external view onlyOwner returns(address) {
858         return LinkedList.next(darknodes, darknodeID);
859     }
860 
861     
862     
863     function removeDarknode(address darknodeID) external onlyOwner {
864         uint256 bond = darknodeRegistry[darknodeID].bond;
865         delete darknodeRegistry[darknodeID];
866         LinkedList.remove(darknodes, darknodeID);
867         require(ren.transfer(owner(), bond), "DarknodeRegistryStore: bond transfer failed");
868     }
869 
870     
871     
872     function updateDarknodeBond(address darknodeID, uint256 decreasedBond) external onlyOwner {
873         uint256 previousBond = darknodeRegistry[darknodeID].bond;
874         require(decreasedBond < previousBond, "DarknodeRegistryStore: bond not decreased");
875         darknodeRegistry[darknodeID].bond = decreasedBond;
876         require(ren.transfer(owner(), previousBond.sub(decreasedBond)), "DarknodeRegistryStore: bond transfer failed");
877     }
878 
879     
880     function updateDarknodeDeregisteredAt(address darknodeID, uint256 deregisteredAt) external onlyOwner {
881         darknodeRegistry[darknodeID].deregisteredAt = deregisteredAt;
882     }
883 
884     
885     function darknodeOwner(address darknodeID) external view onlyOwner returns (address payable) {
886         return darknodeRegistry[darknodeID].owner;
887     }
888 
889     
890     function darknodeBond(address darknodeID) external view onlyOwner returns (uint256) {
891         return darknodeRegistry[darknodeID].bond;
892     }
893 
894     
895     function darknodeRegisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
896         return darknodeRegistry[darknodeID].registeredAt;
897     }
898 
899     
900     function darknodeDeregisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
901         return darknodeRegistry[darknodeID].deregisteredAt;
902     }
903 
904     
905     function darknodePublicKey(address darknodeID) external view onlyOwner returns (bytes memory) {
906         return darknodeRegistry[darknodeID].publicKey;
907     }
908 }
909 
910 interface IDarknodePaymentStore {
911 }
912 
913 interface IDarknodePayment {
914     function changeCycle() external returns (uint256);
915     function store() external returns (IDarknodePaymentStore);
916 }
917 
918 interface IDarknodeSlasher {
919 }
920 
921 contract DarknodeRegistry is Claimable {
922     using SafeMath for uint256;
923 
924     string public VERSION; 
925 
926     
927     
928     
929     struct Epoch {
930         uint256 epochhash;
931         uint256 blocktime;
932     }
933 
934     uint256 public numDarknodes;
935     uint256 public numDarknodesNextEpoch;
936     uint256 public numDarknodesPreviousEpoch;
937 
938     
939     uint256 public minimumBond;
940     uint256 public minimumPodSize;
941     uint256 public minimumEpochInterval;
942 
943     
944     
945     uint256 public nextMinimumBond;
946     uint256 public nextMinimumPodSize;
947     uint256 public nextMinimumEpochInterval;
948 
949     
950     Epoch public currentEpoch;
951     Epoch public previousEpoch;
952 
953     
954     RenToken public ren;
955 
956     
957     DarknodeRegistryStore public store;
958 
959     
960     IDarknodePayment public darknodePayment;
961 
962     
963     IDarknodeSlasher public slasher;
964     IDarknodeSlasher public nextSlasher;
965 
966     
967     
968     
969     
970     event LogDarknodeRegistered(address indexed _operator, address indexed _darknodeID, uint256 _bond);
971 
972     
973     
974     
975     event LogDarknodeDeregistered(address indexed _operator, address indexed _darknodeID);
976 
977     
978     
979     
980     event LogDarknodeOwnerRefunded(address indexed _operator, uint256 _amount);
981 
982     
983     
984     
985     
986     
987     event LogDarknodeSlashed(address indexed _operator, address indexed _darknodeID, address indexed _challenger, uint256 _percentage);
988 
989     
990     event LogNewEpoch(uint256 indexed epochhash);
991 
992     
993     event LogMinimumBondUpdated(uint256 _previousMinimumBond, uint256 _nextMinimumBond);
994     event LogMinimumPodSizeUpdated(uint256 _previousMinimumPodSize, uint256 _nextMinimumPodSize);
995     event LogMinimumEpochIntervalUpdated(uint256 _previousMinimumEpochInterval, uint256 _nextMinimumEpochInterval);
996     event LogSlasherUpdated(address _previousSlasher, address _nextSlasher);
997     event LogDarknodePaymentUpdated(IDarknodePayment _previousDarknodePayment, IDarknodePayment _nextDarknodePayment);
998 
999     
1000     modifier onlyDarknodeOwner(address _darknodeID) {
1001         require(store.darknodeOwner(_darknodeID) == msg.sender, "DarknodeRegistry: must be darknode owner");
1002         _;
1003     }
1004 
1005     
1006     modifier onlyRefunded(address _darknodeID) {
1007         require(isRefunded(_darknodeID), "DarknodeRegistry: must be refunded or never registered");
1008         _;
1009     }
1010 
1011     
1012     modifier onlyRefundable(address _darknodeID) {
1013         require(isRefundable(_darknodeID), "DarknodeRegistry: must be deregistered for at least one epoch");
1014         _;
1015     }
1016 
1017     
1018     
1019     modifier onlyDeregisterable(address _darknodeID) {
1020         require(isDeregisterable(_darknodeID), "DarknodeRegistry: must be deregisterable");
1021         _;
1022     }
1023 
1024     
1025     modifier onlySlasher() {
1026         require(address(slasher) == msg.sender, "DarknodeRegistry: must be slasher");
1027         _;
1028     }
1029 
1030     
1031     
1032     
1033     
1034     
1035     
1036     
1037     
1038     
1039     constructor(
1040         string memory _VERSION,
1041         RenToken _renAddress,
1042         DarknodeRegistryStore _storeAddress,
1043         uint256 _minimumBond,
1044         uint256 _minimumPodSize,
1045         uint256 _minimumEpochIntervalSeconds
1046     ) public {
1047         VERSION = _VERSION;
1048 
1049         store = _storeAddress;
1050         ren = _renAddress;
1051 
1052         minimumBond = _minimumBond;
1053         nextMinimumBond = minimumBond;
1054 
1055         minimumPodSize = _minimumPodSize;
1056         nextMinimumPodSize = minimumPodSize;
1057 
1058         minimumEpochInterval = _minimumEpochIntervalSeconds;
1059         nextMinimumEpochInterval = minimumEpochInterval;
1060 
1061         currentEpoch = Epoch({
1062             epochhash: uint256(blockhash(block.number - 1)),
1063             blocktime: block.timestamp
1064         });
1065         numDarknodes = 0;
1066         numDarknodesNextEpoch = 0;
1067         numDarknodesPreviousEpoch = 0;
1068     }
1069 
1070     
1071     
1072     function recoverTokens(address _token) external onlyOwner {
1073         if (_token == address(0x0)) {
1074             msg.sender.transfer(address(this).balance);
1075         } else {
1076             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
1077         }
1078     }
1079 
1080     
1081     
1082     
1083     
1084     
1085     
1086     
1087     
1088     
1089     
1090     function register(address _darknodeID, bytes calldata _publicKey) external onlyRefunded(_darknodeID) {
1091         
1092         uint256 bond = minimumBond;
1093 
1094         
1095         require(ren.transferFrom(msg.sender, address(store), bond), "DarknodeRegistry: bond transfer failed");
1096 
1097         
1098         store.appendDarknode(
1099             _darknodeID,
1100             msg.sender,
1101             bond,
1102             _publicKey,
1103             currentEpoch.blocktime.add(minimumEpochInterval),
1104             0
1105         );
1106 
1107         numDarknodesNextEpoch = numDarknodesNextEpoch.add(1);
1108 
1109         
1110         emit LogDarknodeRegistered(msg.sender, _darknodeID, bond);
1111     }
1112 
1113     
1114     
1115     
1116     
1117     
1118     
1119     function deregister(address _darknodeID) external onlyDeregisterable(_darknodeID) onlyDarknodeOwner(_darknodeID) {
1120         deregisterDarknode(_darknodeID);
1121     }
1122 
1123     
1124     
1125     
1126     function epoch() external {
1127         if (previousEpoch.blocktime == 0) {
1128             
1129             require(msg.sender == owner(), "DarknodeRegistry: not authorized (first epochs)");
1130         }
1131 
1132         
1133         require(block.timestamp >= currentEpoch.blocktime.add(minimumEpochInterval), "DarknodeRegistry: epoch interval has not passed");
1134         uint256 epochhash = uint256(blockhash(block.number - 1));
1135 
1136         
1137         previousEpoch = currentEpoch;
1138         currentEpoch = Epoch({
1139             epochhash: epochhash,
1140             blocktime: block.timestamp
1141         });
1142 
1143         
1144         numDarknodesPreviousEpoch = numDarknodes;
1145         numDarknodes = numDarknodesNextEpoch;
1146 
1147         
1148         if (nextMinimumBond != minimumBond) {
1149             minimumBond = nextMinimumBond;
1150             emit LogMinimumBondUpdated(minimumBond, nextMinimumBond);
1151         }
1152         if (nextMinimumPodSize != minimumPodSize) {
1153             minimumPodSize = nextMinimumPodSize;
1154             emit LogMinimumPodSizeUpdated(minimumPodSize, nextMinimumPodSize);
1155         }
1156         if (nextMinimumEpochInterval != minimumEpochInterval) {
1157             minimumEpochInterval = nextMinimumEpochInterval;
1158             emit LogMinimumEpochIntervalUpdated(minimumEpochInterval, nextMinimumEpochInterval);
1159         }
1160         if (nextSlasher != slasher) {
1161             slasher = nextSlasher;
1162             emit LogSlasherUpdated(address(slasher), address(nextSlasher));
1163         }
1164         if (address(darknodePayment) != address(0x0)) {
1165             darknodePayment.changeCycle();
1166         }
1167 
1168         
1169         emit LogNewEpoch(epochhash);
1170     }
1171 
1172     
1173     
1174     
1175     function transferStoreOwnership(DarknodeRegistry _newOwner) external onlyOwner {
1176         store.transferOwnership(address(_newOwner));
1177         _newOwner.claimStoreOwnership();
1178     }
1179 
1180     
1181     
1182     
1183     function claimStoreOwnership() external {
1184         store.claimOwnership();
1185     }
1186 
1187     
1188     
1189     
1190     
1191     function updateDarknodePayment(IDarknodePayment _darknodePayment) external onlyOwner {
1192         require(address(_darknodePayment) != address(0x0), "DarknodeRegistry: invalid Darknode Payment address");
1193         IDarknodePayment previousDarknodePayment = darknodePayment;
1194         darknodePayment = _darknodePayment;
1195         emit LogDarknodePaymentUpdated(previousDarknodePayment, darknodePayment);
1196     }
1197 
1198     
1199     
1200     
1201     function updateMinimumBond(uint256 _nextMinimumBond) external onlyOwner {
1202         
1203         nextMinimumBond = _nextMinimumBond;
1204     }
1205 
1206     
1207     
1208     function updateMinimumPodSize(uint256 _nextMinimumPodSize) external onlyOwner {
1209         
1210         nextMinimumPodSize = _nextMinimumPodSize;
1211     }
1212 
1213     
1214     
1215     function updateMinimumEpochInterval(uint256 _nextMinimumEpochInterval) external onlyOwner {
1216         
1217         nextMinimumEpochInterval = _nextMinimumEpochInterval;
1218     }
1219 
1220     
1221     
1222     
1223     function updateSlasher(IDarknodeSlasher _slasher) external onlyOwner {
1224         require(address(_slasher) != address(0), "DarknodeRegistry: invalid slasher address");
1225         nextSlasher = _slasher;
1226     }
1227 
1228     
1229     
1230     
1231     
1232     
1233     function slash(address _guilty, address _challenger, uint256 _percentage)
1234         external
1235         onlySlasher
1236     {
1237         require(_percentage <= 100, "DarknodeRegistry: invalid percent");
1238 
1239         
1240         if (isDeregisterable(_guilty)) {
1241             deregisterDarknode(_guilty);
1242         }
1243 
1244         uint256 totalBond = store.darknodeBond(_guilty);
1245         uint256 penalty = totalBond.div(100).mul(_percentage);
1246         uint256 reward = penalty.div(2);
1247         if (reward > 0) {
1248             
1249             store.updateDarknodeBond(_guilty, totalBond.sub(penalty));
1250 
1251             
1252             require(address(darknodePayment) != address(0x0), "DarknodeRegistry: invalid payment address");
1253             require(ren.transfer(address(darknodePayment.store()), reward), "DarknodeRegistry: reward transfer failed");
1254             require(ren.transfer(_challenger, reward), "DarknodeRegistry: reward transfer failed");
1255         }
1256 
1257         emit LogDarknodeSlashed(store.darknodeOwner(_guilty), _guilty, _challenger, _percentage);
1258     }
1259 
1260     
1261     
1262     
1263     
1264     
1265     
1266     function refund(address _darknodeID) external onlyRefundable(_darknodeID) {
1267         address darknodeOwner = store.darknodeOwner(_darknodeID);
1268 
1269         
1270         uint256 amount = store.darknodeBond(_darknodeID);
1271 
1272         
1273         store.removeDarknode(_darknodeID);
1274 
1275         
1276         require(ren.transfer(darknodeOwner, amount), "DarknodeRegistry: bond transfer failed");
1277 
1278         
1279         emit LogDarknodeOwnerRefunded(darknodeOwner, amount);
1280     }
1281 
1282     
1283     
1284     function getDarknodeOwner(address _darknodeID) external view returns (address payable) {
1285         return store.darknodeOwner(_darknodeID);
1286     }
1287 
1288     
1289     
1290     function getDarknodeBond(address _darknodeID) external view returns (uint256) {
1291         return store.darknodeBond(_darknodeID);
1292     }
1293 
1294     
1295     
1296     function getDarknodePublicKey(address _darknodeID) external view returns (bytes memory) {
1297         return store.darknodePublicKey(_darknodeID);
1298     }
1299 
1300     
1301     
1302     
1303     
1304     
1305     
1306     
1307     
1308     
1309     
1310     function getDarknodes(address _start, uint256 _count) external view returns (address[] memory) {
1311         uint256 count = _count;
1312         if (count == 0) {
1313             count = numDarknodes;
1314         }
1315         return getDarknodesFromEpochs(_start, count, false);
1316     }
1317 
1318     
1319     
1320     function getPreviousDarknodes(address _start, uint256 _count) external view returns (address[] memory) {
1321         uint256 count = _count;
1322         if (count == 0) {
1323             count = numDarknodesPreviousEpoch;
1324         }
1325         return getDarknodesFromEpochs(_start, count, true);
1326     }
1327 
1328     
1329     
1330     
1331     function isPendingRegistration(address _darknodeID) external view returns (bool) {
1332         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1333         return registeredAt != 0 && registeredAt > currentEpoch.blocktime;
1334     }
1335 
1336     
1337     
1338     function isPendingDeregistration(address _darknodeID) external view returns (bool) {
1339         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1340         return deregisteredAt != 0 && deregisteredAt > currentEpoch.blocktime;
1341     }
1342 
1343     
1344     function isDeregistered(address _darknodeID) public view returns (bool) {
1345         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1346         return deregisteredAt != 0 && deregisteredAt <= currentEpoch.blocktime;
1347     }
1348 
1349     
1350     
1351     
1352     function isDeregisterable(address _darknodeID) public view returns (bool) {
1353         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1354         
1355         
1356         return isRegistered(_darknodeID) && deregisteredAt == 0;
1357     }
1358 
1359     
1360     
1361     
1362     function isRefunded(address _darknodeID) public view returns (bool) {
1363         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1364         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1365         return registeredAt == 0 && deregisteredAt == 0;
1366     }
1367 
1368     
1369     
1370     function isRefundable(address _darknodeID) public view returns (bool) {
1371         return isDeregistered(_darknodeID) && store.darknodeDeregisteredAt(_darknodeID) <= previousEpoch.blocktime;
1372     }
1373 
1374     
1375     function isRegistered(address _darknodeID) public view returns (bool) {
1376         return isRegisteredInEpoch(_darknodeID, currentEpoch);
1377     }
1378 
1379     
1380     function isRegisteredInPreviousEpoch(address _darknodeID) public view returns (bool) {
1381         return isRegisteredInEpoch(_darknodeID, previousEpoch);
1382     }
1383 
1384     
1385     
1386     
1387     
1388     function isRegisteredInEpoch(address _darknodeID, Epoch memory _epoch) private view returns (bool) {
1389         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1390         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1391         bool registered = registeredAt != 0 && registeredAt <= _epoch.blocktime;
1392         bool notDeregistered = deregisteredAt == 0 || deregisteredAt > _epoch.blocktime;
1393         
1394         
1395         return registered && notDeregistered;
1396     }
1397 
1398     
1399     
1400     
1401     
1402     
1403     function getDarknodesFromEpochs(address _start, uint256 _count, bool _usePreviousEpoch) private view returns (address[] memory) {
1404         uint256 count = _count;
1405         if (count == 0) {
1406             count = numDarknodes;
1407         }
1408 
1409         address[] memory nodes = new address[](count);
1410 
1411         
1412         uint256 n = 0;
1413         address next = _start;
1414         if (next == address(0)) {
1415             next = store.begin();
1416         }
1417 
1418         
1419         while (n < count) {
1420             if (next == address(0)) {
1421                 break;
1422             }
1423             
1424             bool includeNext;
1425             if (_usePreviousEpoch) {
1426                 includeNext = isRegisteredInPreviousEpoch(next);
1427             } else {
1428                 includeNext = isRegistered(next);
1429             }
1430             if (!includeNext) {
1431                 next = store.next(next);
1432                 continue;
1433             }
1434             nodes[n] = next;
1435             next = store.next(next);
1436             n += 1;
1437         }
1438         return nodes;
1439     }
1440 
1441     
1442     function deregisterDarknode(address _darknodeID) private {
1443         
1444         store.updateDarknodeDeregisteredAt(_darknodeID, currentEpoch.blocktime.add(minimumEpochInterval));
1445         numDarknodesNextEpoch = numDarknodesNextEpoch.sub(1);
1446 
1447         
1448         emit LogDarknodeDeregistered(msg.sender, _darknodeID);
1449     }
1450 }
1451 
1452 contract DarknodePaymentStore is Claimable {
1453     using SafeMath for uint256;
1454     using SafeERC20 for ERC20;
1455     using ERC20WithFees for ERC20;
1456 
1457     string public VERSION; 
1458 
1459     
1460     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1461 
1462     
1463     mapping(address => mapping(address => uint256)) public darknodeBalances;
1464 
1465     
1466     mapping(address => uint256) public lockedBalances;
1467 
1468     
1469     
1470     
1471     constructor(
1472         string memory _VERSION
1473     ) public {
1474         VERSION = _VERSION;
1475     }
1476 
1477     
1478     function () external payable {
1479     }
1480 
1481     
1482     
1483     
1484     
1485     function totalBalance(address _token) public view returns (uint256) {
1486         if (_token == ETHEREUM) {
1487             return address(this).balance;
1488         } else {
1489             return ERC20(_token).balanceOf(address(this));
1490         }
1491     }
1492 
1493     
1494     
1495     
1496     
1497     
1498     
1499     function availableBalance(address _token) public view returns (uint256) {
1500         return totalBalance(_token).sub(lockedBalances[_token]);
1501     }
1502 
1503     
1504     
1505     
1506     
1507     
1508     
1509     function incrementDarknodeBalance(address _darknode, address _token, uint256 _amount) external onlyOwner {
1510         require(_amount > 0, "DarknodePaymentStore: invalid amount");
1511         require(availableBalance(_token) >= _amount, "DarknodePaymentStore: insufficient contract balance");
1512 
1513         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].add(_amount);
1514         lockedBalances[_token] = lockedBalances[_token].add(_amount);
1515     }
1516 
1517     
1518     
1519     
1520     
1521     
1522     
1523     function transfer(address _darknode, address _token, uint256 _amount, address payable _recipient) external onlyOwner {
1524         require(darknodeBalances[_darknode][_token] >= _amount, "DarknodePaymentStore: insufficient darknode balance");
1525         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].sub(_amount);
1526         lockedBalances[_token] = lockedBalances[_token].sub(_amount);
1527 
1528         if (_token == ETHEREUM) {
1529             _recipient.transfer(_amount);
1530         } else {
1531             ERC20(_token).safeTransfer(_recipient, _amount);
1532         }
1533     }
1534 
1535 }
1536 
1537 contract DarknodePayment is Claimable {
1538     using SafeMath for uint256;
1539     using SafeERC20 for ERC20;
1540     using ERC20WithFees for ERC20;
1541 
1542     string public VERSION; 
1543 
1544     
1545     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1546 
1547     DarknodeRegistry public darknodeRegistry; 
1548 
1549     
1550     
1551     DarknodePaymentStore public store; 
1552 
1553     
1554     
1555     address public cycleChanger;
1556 
1557     uint256 public currentCycle;
1558     uint256 public previousCycle;
1559 
1560     
1561     
1562     
1563     address[] public pendingTokens;
1564 
1565     
1566     
1567     address[] public registeredTokens;
1568 
1569     
1570     
1571     mapping(address => uint256) public registeredTokenIndex;
1572 
1573     
1574     
1575     
1576     mapping(address => uint256) public unclaimedRewards;
1577 
1578     
1579     
1580     mapping(address => uint256) public previousCycleRewardShare;
1581 
1582     
1583     uint256 public cycleStartTime;
1584 
1585     
1586     uint256 public nextCyclePayoutPercent;
1587 
1588     
1589     uint256 public currentCyclePayoutPercent;
1590 
1591     
1592     
1593     
1594     mapping(address => mapping(uint256 => bool)) public rewardClaimed;
1595 
1596     
1597     
1598     
1599     event LogDarknodeClaim(address indexed _darknode, uint256 _cycle);
1600 
1601     
1602     
1603     
1604     
1605     event LogPaymentReceived(address indexed _payer, uint256 _amount, address indexed _token);
1606 
1607     
1608     
1609     
1610     
1611     event LogDarknodeWithdrew(address indexed _payee, uint256 _value, address indexed _token);
1612 
1613     
1614     
1615     
1616     event LogPayoutPercentChanged(uint256 _newPercent, uint256 _oldPercent);
1617 
1618     
1619     
1620     
1621     event LogCycleChangerChanged(address _newCycleChanger, address _oldCycleChanger);
1622 
1623     
1624     
1625     event LogTokenRegistered(address _token);
1626 
1627     
1628     
1629     event LogTokenDeregistered(address _token);
1630 
1631     
1632     
1633     
1634     event LogDarknodeRegistryUpdated(DarknodeRegistry _previousDarknodeRegistry, DarknodeRegistry _nextDarknodeRegistry);
1635 
1636     
1637     modifier onlyDarknode(address _darknode) {
1638         require(darknodeRegistry.isRegistered(_darknode), "DarknodePayment: darknode is not registered");
1639         _;
1640     }
1641 
1642     
1643     modifier validPercent(uint256 _percent) {
1644         require(_percent <= 100, "DarknodePayment: invalid percentage");
1645         _;
1646     }
1647 
1648     
1649     
1650     
1651     
1652     
1653     
1654     
1655     constructor(
1656         string memory _VERSION,
1657         DarknodeRegistry _darknodeRegistry,
1658         DarknodePaymentStore _darknodePaymentStore,
1659         uint256 _cyclePayoutPercent
1660     ) public validPercent(_cyclePayoutPercent) {
1661         VERSION = _VERSION;
1662         darknodeRegistry = _darknodeRegistry;
1663         store = _darknodePaymentStore;
1664         nextCyclePayoutPercent = _cyclePayoutPercent;
1665         
1666         cycleChanger = msg.sender;
1667 
1668         
1669         (currentCycle, cycleStartTime) = darknodeRegistry.currentEpoch();
1670         currentCyclePayoutPercent = nextCyclePayoutPercent;
1671     }
1672 
1673     
1674     
1675     
1676     
1677     function updateDarknodeRegistry(DarknodeRegistry _darknodeRegistry) external onlyOwner {
1678         require(address(_darknodeRegistry) != address(0x0), "DarknodePayment: invalid Darknode Registry address");
1679         DarknodeRegistry previousDarknodeRegistry = darknodeRegistry;
1680         darknodeRegistry = _darknodeRegistry;
1681         emit LogDarknodeRegistryUpdated(previousDarknodeRegistry, darknodeRegistry);
1682     }
1683 
1684     
1685     
1686     
1687     
1688     
1689     function withdraw(address _darknode, address _token) public {
1690         address payable darknodeOwner = darknodeRegistry.getDarknodeOwner(_darknode);
1691         require(darknodeOwner != address(0x0), "DarknodePayment: invalid darknode owner");
1692 
1693         uint256 amount = store.darknodeBalances(_darknode, _token);
1694         require(amount > 0, "DarknodePayment: nothing to withdraw");
1695 
1696         store.transfer(_darknode, _token, amount, darknodeOwner);
1697         emit LogDarknodeWithdrew(_darknode, amount, _token);
1698     }
1699 
1700     function withdrawMultiple(address _darknode, address[] calldata _tokens) external {
1701         for (uint i = 0; i < _tokens.length; i++) {
1702             withdraw(_darknode, _tokens[i]);
1703         }
1704     }
1705 
1706     
1707     function () external payable {
1708         address(store).transfer(msg.value);
1709         emit LogPaymentReceived(msg.sender, msg.value, ETHEREUM);
1710     }
1711 
1712     
1713     
1714     function currentCycleRewardPool(address _token) external view returns (uint256) {
1715         uint256 total = store.availableBalance(_token).sub(unclaimedRewards[_token]);
1716         return total.div(100).mul(currentCyclePayoutPercent);
1717     }
1718 
1719     function darknodeBalances(address _darknodeID, address _token) external view returns (uint256) {
1720         return store.darknodeBalances(_darknodeID, _token);
1721     }
1722 
1723     
1724     function changeCycle() external returns (uint256) {
1725         require(msg.sender == cycleChanger, "DarknodePayment: not cycle changer");
1726 
1727         
1728         uint arrayLength = registeredTokens.length;
1729         for (uint i = 0; i < arrayLength; i++) {
1730             _snapshotBalance(registeredTokens[i]);
1731         }
1732 
1733         
1734         previousCycle = currentCycle;
1735         (currentCycle, cycleStartTime) = darknodeRegistry.currentEpoch();
1736         currentCyclePayoutPercent = nextCyclePayoutPercent;
1737 
1738         
1739         _updateTokenList();
1740         return currentCycle;
1741     }
1742 
1743     
1744     
1745     
1746     
1747     function deposit(uint256 _value, address _token) external payable {
1748         uint256 receivedValue;
1749         if (_token == ETHEREUM) {
1750             require(_value == msg.value, "DarknodePayment: mismatched deposit value");
1751             receivedValue = msg.value;
1752             address(store).transfer(msg.value);
1753         } else {
1754             require(msg.value == 0, "DarknodePayment: unexpected ether transfer");
1755             
1756             receivedValue = ERC20(_token).safeTransferFromWithFees(msg.sender, address(store), _value);
1757         }
1758         emit LogPaymentReceived(msg.sender, receivedValue, _token);
1759     }
1760 
1761     
1762     
1763     
1764     
1765     function forward(address _token) external {
1766         if (_token == ETHEREUM) {
1767             
1768             
1769             
1770             
1771             address(store).transfer(address(this).balance);
1772         } else {
1773             ERC20(_token).safeTransfer(address(store), ERC20(_token).balanceOf(address(this)));
1774         }
1775     }
1776 
1777     
1778     
1779     function claim(address _darknode) external onlyDarknode(_darknode) {
1780         require(darknodeRegistry.isRegisteredInPreviousEpoch(_darknode), "DarknodePayment: cannot claim for this epoch");
1781         
1782         _claimDarknodeReward(_darknode);
1783         emit LogDarknodeClaim(_darknode, previousCycle);
1784     }
1785 
1786     
1787     
1788     
1789     
1790     function registerToken(address _token) external onlyOwner {
1791         require(registeredTokenIndex[_token] == 0, "DarknodePayment: token already registered");
1792         require(!tokenPendingRegistration(_token), "DarknodePayment: token already pending registration");
1793         pendingTokens.push(_token);
1794     }
1795 
1796     function tokenPendingRegistration(address _token) public view returns (bool) {
1797         uint arrayLength = pendingTokens.length;
1798         for (uint i = 0; i < arrayLength; i++) {
1799             if (pendingTokens[i] == _token) {
1800                 return true;
1801             }
1802         }
1803         return false;
1804     }
1805 
1806     
1807     
1808     
1809     
1810     function deregisterToken(address _token) external onlyOwner {
1811         require(registeredTokenIndex[_token] > 0, "DarknodePayment: token not registered");
1812         _deregisterToken(_token);
1813     }
1814 
1815     
1816     
1817     
1818     function updateCycleChanger(address _addr) external onlyOwner {
1819         require(_addr != address(0), "DarknodePayment: invalid contract address");
1820         emit LogCycleChangerChanged(_addr, cycleChanger);
1821         cycleChanger = _addr;
1822     }
1823 
1824     
1825     
1826     
1827     function updatePayoutPercentage(uint256 _percent) external onlyOwner validPercent(_percent) {
1828         uint256 oldPayoutPercent = nextCyclePayoutPercent;
1829         nextCyclePayoutPercent = _percent;
1830         emit LogPayoutPercentChanged(nextCyclePayoutPercent, oldPayoutPercent);
1831     }
1832 
1833     
1834     
1835     
1836     
1837     function transferStoreOwnership(DarknodePayment _newOwner) external onlyOwner {
1838         store.transferOwnership(address(_newOwner));
1839         _newOwner.claimStoreOwnership();
1840     }
1841 
1842     
1843     
1844     
1845     function claimStoreOwnership() external {
1846         store.claimOwnership();
1847     }
1848 
1849     
1850     
1851     
1852     
1853     
1854     function _claimDarknodeReward(address _darknode) private {
1855         require(!rewardClaimed[_darknode][previousCycle], "DarknodePayment: reward already claimed");
1856         rewardClaimed[_darknode][previousCycle] = true;
1857         uint arrayLength = registeredTokens.length;
1858         for (uint i = 0; i < arrayLength; i++) {
1859             address token = registeredTokens[i];
1860 
1861             
1862             if (previousCycleRewardShare[token] > 0) {
1863                 unclaimedRewards[token] = unclaimedRewards[token].sub(previousCycleRewardShare[token]);
1864                 store.incrementDarknodeBalance(_darknode, token, previousCycleRewardShare[token]);
1865             }
1866         }
1867     }
1868 
1869     
1870     
1871     
1872     
1873     function _snapshotBalance(address _token) private {
1874         uint256 shareCount = darknodeRegistry.numDarknodesPreviousEpoch();
1875         if (shareCount == 0) {
1876             unclaimedRewards[_token] = 0;
1877             previousCycleRewardShare[_token] = 0;
1878         } else {
1879             
1880             uint256 total = store.availableBalance(_token);
1881             unclaimedRewards[_token] = total.div(100).mul(currentCyclePayoutPercent);
1882             previousCycleRewardShare[_token] = unclaimedRewards[_token].div(shareCount);
1883         }
1884     }
1885 
1886     
1887     
1888     
1889     
1890     function _deregisterToken(address _token) private {
1891         address lastToken = registeredTokens[registeredTokens.length.sub(1)];
1892         uint256 deletedTokenIndex = registeredTokenIndex[_token].sub(1);
1893         
1894         registeredTokens[deletedTokenIndex] = lastToken;
1895         registeredTokenIndex[lastToken] = registeredTokenIndex[_token];
1896         
1897         
1898         registeredTokens.length = registeredTokens.length.sub(1);
1899         registeredTokenIndex[_token] = 0;
1900 
1901         emit LogTokenDeregistered(_token);
1902     }
1903 
1904     
1905     
1906     function _updateTokenList() private {
1907         
1908         uint arrayLength = pendingTokens.length;
1909         for (uint i = 0; i < arrayLength; i++) {
1910             address token = pendingTokens[i];
1911             registeredTokens.push(token);
1912             registeredTokenIndex[token] = registeredTokens.length;
1913             emit LogTokenRegistered(token);
1914         }
1915         pendingTokens.length = 0;
1916     }
1917 
1918 }