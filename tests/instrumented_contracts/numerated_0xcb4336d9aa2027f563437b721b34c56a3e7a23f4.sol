1 // File: solidity-common/contracts/interface/IERC20.sol
2 
3 pragma solidity >=0.5.0 <0.7.0;
4 
5 
6 /**
7  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8  */
9 interface IERC20 {
10     /**
11     * 可选方法
12     */
13     function name() external view returns (string memory);
14     function symbol() external view returns (string memory);
15     function decimals() external view returns (uint8);
16 
17     /**
18      * 必须方法
19      */
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * 事件类型
29      */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 // File: solidity-common/contracts/library/SafeMath.sol
35 
36 pragma solidity >=0.5.0 <0.7.0;
37 
38 
39 /**
40  * 算术操作
41  */
42 library SafeMath {
43     uint256 constant WAD = 10 ** 18;
44     uint256 constant RAY = 10 ** 27;
45 
46     function wad() public pure returns (uint256) {
47         return WAD;
48     }
49 
50     function ray() public pure returns (uint256) {
51         return RAY;
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74         // benefit is lost if 'b' is also tested.
75         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0, errorMessage);
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         return mod(a, b, "SafeMath: modulo by zero");
101     }
102 
103     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b != 0, errorMessage);
105         return a % b;
106     }
107 
108     function min(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a <= b ? a : b;
110     }
111 
112     function max(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a >= b ? a : b;
114     }
115 
116     function sqrt(uint256 a) internal pure returns (uint256 b) {
117         if (a > 3) {
118             b = a;
119             uint256 x = a / 2 + 1;
120             while (x < b) {
121                 b = x;
122                 x = (a / x + x) / 2;
123             }
124         } else if (a != 0) {
125             b = 1;
126         }
127     }
128 
129     function wmul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mul(a, b) / WAD;
131     }
132 
133     function wmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
134         return add(mul(a, b), WAD / 2) / WAD;
135     }
136 
137     function rmul(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mul(a, b) / RAY;
139     }
140 
141     function rmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
142         return add(mul(a, b), RAY / 2) / RAY;
143     }
144 
145     function wdiv(uint256 a, uint256 b) internal pure returns (uint256) {
146         return div(mul(a, WAD), b);
147     }
148 
149     function wdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
150         return add(mul(a, WAD), b / 2) / b;
151     }
152 
153     function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(mul(a, RAY), b);
155     }
156 
157     function rdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
158         return add(mul(a, RAY), b / 2) / b;
159     }
160 
161     function wpow(uint256 x, uint256 n) internal pure returns (uint256) {
162         uint256 result = WAD;
163         while (n > 0) {
164             if (n % 2 != 0) {
165                 result = wmul(result, x);
166             }
167             x = wmul(x, x);
168             n /= 2;
169         }
170         return result;
171     }
172 
173     function rpow(uint256 x, uint256 n) internal pure returns (uint256) {
174         uint256 result = RAY;
175         while (n > 0) {
176             if (n % 2 != 0) {
177                 result = rmul(result, x);
178             }
179             x = rmul(x, x);
180             n /= 2;
181         }
182         return result;
183     }
184 }
185 
186 // File: solidity-common/contracts/library/Array.sol
187 
188 pragma solidity >=0.5.0 <0.7.0;
189 
190 
191 /**
192  * 数组工具包
193  */
194 library Array {
195     // 从字节数组array中删除指定的bytes32
196     function remove(bytes32[] storage array, bytes32 element) internal returns (bool) {
197         for (uint256 index = 0; index < array.length; index++) {
198             if (array[index] == element) {
199                 delete array[index];
200                 array[index] = array[array.length - 1];
201                 array.length--;
202                 return true;
203             }
204         }
205         return false;
206     }
207 
208     // 从地址数组array中删除指定的address
209     function remove(address[] storage array, address element) internal returns (bool) {
210         for (uint256 index = 0; index < array.length; index++) {
211             if (array[index] == element) {
212                 delete array[index];
213                 array[index] = array[array.length - 1];
214                 array.length--;
215                 return true;
216             }
217         }
218         return false;
219     }
220 }
221 
222 // File: solidity-common/contracts/library/Roles.sol
223 
224 pragma solidity >=0.5.0 <0.7.0;
225 
226 
227 /**
228  * 多角色管理逻辑
229  */
230 library Roles {
231     // 存储角色授权数据
232     struct Role {
233         mapping(address => bool) bearer;
234     }
235 
236     // 增加一个不存在的地址
237     function add(Role storage role, address account) internal {
238         require(account != address(0), "Roles: account is the zero address");
239         require(!has(role, account), "Roles: account already has role");
240         role.bearer[account] = true;
241     }
242 
243     // 删除一个存在的地址
244     function remove(Role storage role, address account) internal {
245         require(has(role, account), "Roles: account does not have role");
246         role.bearer[account] = false;
247     }
248 
249     // 判断地址是否有权限
250     function has(Role storage role, address account) internal view returns (bool) {
251         require(account != address(0), "Roles: account is the zero address");
252         return role.bearer[account];
253     }
254 }
255 
256 // File: solidity-common/contracts/common/Ownable.sol
257 
258 pragma solidity >=0.5.0 <0.7.0;
259 
260 
261 /**
262  * 合约Owner机制
263  */
264 contract Ownable {
265     address private _owner;
266 
267     constructor () internal {
268         _owner = msg.sender;
269         emit OwnershipTransferred(address(0), _owner);
270     }
271 
272     function owner() public view returns (address) {
273         return _owner;
274     }
275 
276     function isOwner(address account) public view returns (bool) {
277         return account == _owner;
278     }
279 
280     function renounceOwnership() public onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     function _transferOwnership(address newOwner) internal {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 
291     function transferOwnership(address newOwner) public onlyOwner {
292         _transferOwnership(newOwner);
293     }
294 
295 
296     modifier onlyOwner() {
297         require(isOwner(msg.sender), "Ownable: caller is not the owner");
298         _;
299     }
300 
301 
302     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 }
304 
305 // File: solidity-common/contracts/access/BlacklistedRole.sol
306 
307 pragma solidity >=0.5.0 <0.7.0;
308 
309 
310 
311 
312 
313 /**
314  *  由owner控制，具备黑名单的合约
315  */
316 contract BlacklistedRole is Ownable {
317     using Roles for Roles.Role;
318     using Array for address[];
319 
320     Roles.Role private _blacklisteds;
321     address[] public blacklisteds;
322 
323     constructor () internal {}
324 
325     function _addBlacklisted(address account) internal {
326         _blacklisteds.add(account);
327         blacklisteds.push(account);
328         emit BlacklistedAdded(account);
329     }
330 
331     function addBlacklisted(address account) public onlyOwner {
332         _addBlacklisted(account);
333     }
334 
335     function addBlacklisted(address[] memory accounts) public onlyOwner {
336         for (uint256 index = 0; index < accounts.length; index++) {
337             _addBlacklisted(accounts[index]);
338         }
339     }
340 
341     function _delBlacklisted(address account) internal {
342         _blacklisteds.remove(account);
343 
344         if (blacklisteds.remove(account)) {
345             emit BlacklistedRemoved(account);
346         }
347     }
348 
349     function delBlacklisted(address account) public onlyOwner {
350         _delBlacklisted(account);
351     }
352 
353     function getBlacklistedsLength() public view returns (uint256) {
354         return blacklisteds.length;
355     }
356 
357     function isBlacklisted(address account) public view returns (bool) {
358         return _blacklisteds.has(account);
359     }
360 
361 
362     modifier onlyBlacklisted() {
363         require(isBlacklisted(msg.sender), "BlacklistedRole: caller does not have the blacklisted role");
364         _;
365     }
366 
367     modifier onlyNotBlacklisted(address account) {
368         require(!isBlacklisted(account), "BlacklistedRole: account has the blacklisted role");
369         _;
370     }
371 
372 
373     event BlacklistedAdded(address indexed account);
374     event BlacklistedRemoved(address indexed account);
375 }
376 
377 // File: solidity-common/contracts/common/DailyLimit.sol
378 
379 pragma solidity >=0.5.0 <0.7.0;
380 
381 
382 
383 
384 /**
385  * 代币每日转账额度控制机制
386  */
387 contract DailyLimit is Ownable {
388     using SafeMath for uint256;
389 
390     mapping(address => UserDailyLimit) public dailyLimits;      // 用户额度信息
391 
392     struct UserDailyLimit {
393         uint256 spent;                                          // 今日已用额度
394         uint256 today;                                          // 今日开始时间
395         uint256 limit;                                          // 今日总共额度
396     }
397 
398     constructor () internal {}
399 
400     /**
401      * 查询用户每日额度信息
402      */
403     function getDailyLimit(address account) public view returns (uint256, uint256, uint256){
404         UserDailyLimit memory dailyLimit = dailyLimits[account];
405         return (dailyLimit.spent, dailyLimit.today, dailyLimit.limit);
406     }
407 
408     /**
409      * 设置用户每日总共额度
410      */
411     function _setDailyLimit(address account, uint256 limit) internal {
412         require(account != address(0), "DailyLimit: account is the zero address");
413         require(limit != 0, "DailyLimit: limit can not be zero");
414 
415         dailyLimits[account].limit = limit;
416     }
417 
418     function setDailyLimit(address[] memory accounts, uint256[] memory limits) public onlyOwner {
419         require(accounts.length == limits.length, "DailyLimit: accounts and limits length mismatched");
420 
421         for (uint256 index = 0; index < accounts.length; index++) {
422             _setDailyLimit(accounts[index], limits[index]);
423         }
424     }
425 
426     /**
427      * 今日开始时间
428      */
429     function today() public view returns (uint256){
430         return now - (now % 1 days);
431     }
432 
433     /**
434      * 是否小于限制
435      */
436     function isUnderLimit(address account, uint256 amount) internal returns (bool){
437         UserDailyLimit storage dailyLimit = dailyLimits[account];
438 
439         if (today() > dailyLimit.today) {
440             dailyLimit.today = today();
441             dailyLimit.spent = 0;
442         }
443 
444         // A).limit为0，不用做限制 B).limit非0，需满足限制
445         return (dailyLimit.limit == 0 || dailyLimit.spent.add(amount) <= dailyLimit.limit);
446     }
447 
448 
449     modifier onlyUnderLimit(address account, uint256 amount){
450         require(isUnderLimit(account, amount), "DailyLimit: user's spent exceeds daily limit");
451         _;
452     }
453 }
454 
455 // File: solidity-common/contracts/access/PauserRole.sol
456 
457 pragma solidity >=0.5.0 <0.7.0;
458 
459 
460 
461 
462 
463 /**
464  * 由owner控制，具备可暂停的合约
465  */
466 contract PauserRole is Ownable {
467     using Roles for Roles.Role;
468     using Array for address[];
469 
470     Roles.Role private _pausers;
471     address[] public pausers;
472 
473     constructor () internal {}
474 
475     function _addPauser(address account) internal {
476         _pausers.add(account);
477         pausers.push(account);
478         emit PauserAdded(account);
479     }
480 
481     function addPauser(address account) public onlyOwner {
482         _addPauser(account);
483     }
484 
485     function addPauser(address[] memory accounts) public onlyOwner {
486         for (uint256 index = 0; index < accounts.length; index++) {
487             _addPauser(accounts[index]);
488         }
489     }
490 
491     function _delPauser(address account) internal {
492         _pausers.remove(account);
493 
494         if (pausers.remove(account)) {
495             emit PauserRemoved(account);
496         }
497     }
498 
499     function renouncePauser() public {
500         _delPauser(msg.sender);
501     }
502 
503     function delPauser(address account) public onlyOwner {
504         _delPauser(account);
505     }
506 
507     function getPausersLength() public view returns (uint256) {
508         return pausers.length;
509     }
510 
511     function isPauser(address account) public view returns (bool) {
512         return _pausers.has(account);
513     }
514 
515 
516     modifier onlyPauser() {
517         require(isPauser(msg.sender), "PauserRole: caller does not have the pauser role");
518         _;
519     }
520 
521 
522     event PauserAdded(address indexed account);
523     event PauserRemoved(address indexed account);
524 }
525 
526 // File: solidity-common/contracts/common/Pausable.sol
527 
528 pragma solidity >=0.5.0 <0.7.0;
529 
530 
531 
532 /**
533  * 紧急暂停机制
534  */
535 contract Pausable is PauserRole {
536     bool private _paused;               // 系统暂停标识
537 
538     constructor () internal {
539         _paused = false;
540     }
541 
542     // 暂停标识 true-禁用, false-启用
543     function paused() public view returns (bool) {
544         return _paused;
545     }
546 
547     // 授权的访客在系统启用时，变更系统为禁用
548     function pause() public onlyPauser whenNotPaused {
549         _paused = true;
550         emit Paused(msg.sender);
551     }
552 
553     // 授权的访客在系统禁用时，变更系统为启用
554     function unpause() public onlyPauser whenPaused {
555         _paused = false;
556         emit Unpaused(msg.sender);
557     }
558 
559 
560     modifier whenNotPaused() {
561         require(!_paused, "Pausable: paused");
562         _;
563     }
564 
565     modifier whenPaused() {
566         require(_paused, "Pausable: not paused");
567         _;
568     }
569 
570 
571     event Paused(address indexed pauser);
572     event Unpaused(address indexed pauser);
573 }
574 
575 // File: solidity-common/contracts/erc20/ERC20.sol
576 
577 pragma solidity >=0.5.0 <0.7.0;
578 
579 
580 
581 
582 
583 
584 
585 /**
586  * ERC20全实现合约
587  */
588 contract ERC20 is IERC20, BlacklistedRole, DailyLimit, Pausable {
589     using SafeMath for uint256;
590 
591     string private _name;
592     string private _symbol;
593     uint8 private _decimals;
594 
595     mapping(address => uint256) private _balances;
596     mapping(address => mapping(address => uint256)) private _allowances;
597     uint256 private _totalSupply;
598 
599     constructor (string memory name, string memory symbol, uint8 decimals) public {
600         _name = name;
601         _symbol = symbol;
602         _decimals = decimals;
603     }
604 
605     function name() public view returns (string memory) {
606         return _name;
607     }
608 
609     function symbol() public view returns (string memory) {
610         return _symbol;
611     }
612 
613     function decimals() public view returns (uint8) {
614         return _decimals;
615     }
616 
617     function totalSupply() public view returns (uint256) {
618         return _totalSupply;
619     }
620 
621     function balanceOf(address account) public view returns (uint256) {
622         return _balances[account];
623     }
624 
625     function allowance(address owner, address spender) public view returns (uint256) {
626         return _allowances[owner][spender];
627     }
628 
629     function _transfer(address sender, address recipient, uint256 amount) internal {
630         require(sender != address(0), "ERC20: transfer from the zero address");
631         require(recipient != address(0), "ERC20: transfer to the zero address");
632 
633         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
634         _balances[recipient] = _balances[recipient].add(amount);
635 
636         emit Transfer(sender, recipient, amount);
637     }
638 
639     function transfer(address recipient, uint256 amount) public whenNotPaused onlyNotBlacklisted(msg.sender) onlyNotBlacklisted(recipient) onlyUnderLimit(msg.sender, amount) returns (bool) {
640         dailyLimits[msg.sender].spent = dailyLimits[msg.sender].spent.add(amount);
641         _transfer(msg.sender, recipient, amount);
642         return true;
643     }
644 
645     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused onlyNotBlacklisted(msg.sender) onlyNotBlacklisted(sender) onlyNotBlacklisted(recipient) onlyUnderLimit(sender, amount) returns (bool) {
646         uint256 delta = _allowances[sender][msg.sender].sub(amount, "ERC20: decreased allowance below zero");
647         dailyLimits[sender].spent = dailyLimits[sender].spent.add(amount);
648         _transfer(sender, recipient, amount);
649         _approve(sender, msg.sender, delta);
650         return true;
651     }
652 
653     function _approve(address owner, address spender, uint256 amount) internal {
654         require(owner != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[owner][spender] = amount;
658         emit Approval(owner, spender, amount);
659     }
660 
661     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused onlyNotBlacklisted(msg.sender) onlyNotBlacklisted(spender) returns (bool) {
662         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
663         return true;
664     }
665 
666     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused onlyNotBlacklisted(msg.sender) onlyNotBlacklisted(spender) returns (bool) {
667         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
668         return true;
669     }
670 
671     function approve(address spender, uint256 amount) whenNotPaused onlyNotBlacklisted(msg.sender) onlyNotBlacklisted(spender) public returns (bool) {
672         _approve(msg.sender, spender, amount);
673         return true;
674     }
675 
676     function _mint(address account, uint256 amount) internal {
677         require(account != address(0), "ERC20: mint to the zero address");
678 
679         _totalSupply = _totalSupply.add(amount);
680         _balances[account] = _balances[account].add(amount);
681         emit Transfer(address(0), account, amount);
682     }
683 
684     function _burn(address account, uint256 amount) internal {
685         require(account != address(0), "ERC20: burn from the zero address");
686 
687         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
688         _totalSupply = _totalSupply.sub(amount);
689         emit Transfer(account, address(0), amount);
690     }
691 
692     function _burnFrom(address account, uint256 amount) internal {
693         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
694         _burn(account, amount);
695     }
696 }
697 
698 // File: solidity-common/contracts/access/WhitelistedRole.sol
699 
700 pragma solidity >=0.5.0 <0.7.0;
701 
702 
703 
704 
705 
706 /**
707  *  由owner控制，具备白名单的合约
708  */
709 contract WhitelistedRole is Ownable {
710     using Roles for Roles.Role;
711     using Array for address[];
712 
713     Roles.Role private _whitelisteds;
714     address[] public whitelisteds;
715 
716     constructor () internal {}
717 
718     function _addWhitelisted(address account) internal {
719         _whitelisteds.add(account);
720         whitelisteds.push(account);
721         emit WhitelistedAdded(account);
722     }
723 
724     function addWhitelisted(address account) public onlyOwner {
725         _addWhitelisted(account);
726     }
727 
728     function addWhitelisted(address[] memory accounts) public onlyOwner {
729         for (uint256 index = 0; index < accounts.length; index++) {
730             _addWhitelisted(accounts[index]);
731         }
732     }
733 
734     function _delWhitelisted(address account) internal {
735         _whitelisteds.remove(account);
736 
737         if (whitelisteds.remove(account)) {
738             emit WhitelistedRemoved(account);
739         }
740     }
741 
742     function renounceWhitelisted() public {
743         _delWhitelisted(msg.sender);
744     }
745 
746     function delWhitelisted(address account) public onlyOwner {
747         _delWhitelisted(account);
748     }
749 
750     function getWhitelistedsLength() public view returns (uint256) {
751         return whitelisteds.length;
752     }
753 
754     function isWhitelisted(address account) public view returns (bool) {
755         return _whitelisteds.has(account);
756     }
757 
758 
759     modifier onlyWhitelisted() {
760         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the whitelisted role");
761         _;
762     }
763 
764     modifier onlyWhitelisting(address account) {
765         require(isWhitelisted(account), "WhitelistedRole: caller does not have the whitelisted role");
766         _;
767     }
768 
769 
770     event WhitelistedAdded(address indexed account);
771     event WhitelistedRemoved(address indexed account);
772 }
773 
774 // File: solidity-common/contracts/access/MinterRole.sol
775 
776 pragma solidity >=0.5.0 <0.7.0;
777 
778 
779 
780 
781 
782 /**
783  *  由owner控制，具备动态矿工的合约
784  */
785 contract MinterRole is Ownable {
786     using Roles for Roles.Role;
787     using Array for address[];
788 
789     Roles.Role private _minters;
790     address[] public minters;
791 
792     constructor () internal {}
793 
794     function _addMinter(address account) internal {
795         _minters.add(account);
796         minters.push(account);
797         emit MinterAdded(account);
798     }
799 
800     function addMinter(address account) public onlyOwner {
801         _addMinter(account);
802     }
803 
804     function addMinter(address[] memory accounts) public onlyOwner {
805         for (uint256 index = 0; index < accounts.length; index++) {
806             _addMinter(accounts[index]);
807         }
808     }
809 
810     function _delMinter(address account) internal {
811         _minters.remove(account);
812 
813         if (minters.remove(account)) {
814             emit MinterRemoved(account);
815         }
816     }
817 
818     function renounceMinter() public {
819         _delMinter(msg.sender);
820     }
821 
822     function delMinter(address account) public onlyOwner {
823         _delMinter(account);
824     }
825 
826     function getMintersLength() public view returns (uint256) {
827         return minters.length;
828     }
829 
830     function isMinter(address account) public view returns (bool) {
831         return _minters.has(account);
832     }
833 
834 
835     modifier onlyMinter() {
836         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
837         _;
838     }
839 
840 
841     event MinterAdded(address indexed account);
842     event MinterRemoved(address indexed account);
843 }
844 
845 // File: contracts/interface/IBtswapFactory.sol
846 
847 pragma solidity >=0.5.0 <0.7.0;
848 
849 
850 interface IBtswapFactory {
851     function FEE_RATE_DENOMINATOR() external view returns (uint256);
852 
853     function feeTo() external view returns (address);
854 
855     function feeToSetter() external view returns (address);
856 
857     function feeRateNumerator() external view returns (uint256);
858 
859     function initCodeHash() external view returns (bytes32);
860 
861     function getPair(address tokenA, address tokenB) external view returns (address pair);
862 
863     function allPairs(uint256) external view returns (address pair);
864 
865     function allPairsLength() external view returns (uint256);
866 
867     function createPair(address tokenA, address tokenB) external returns (address pair);
868 
869     function setRouter(address) external;
870 
871     function setFeeTo(address) external;
872 
873     function setFeeToSetter(address) external;
874 
875     function setFeeRateNumerator(uint256) external;
876 
877     function setInitCodeHash(bytes32) external;
878 
879     function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);
880 
881     function pairFor(address factory, address tokenA, address tokenB) external view returns (address pair);
882 
883     function getReserves(address factory, address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);
884 
885     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
886 
887     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
888 
889     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
890 
891     function getAmountsOut(address factory, uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
892 
893     function getAmountsIn(address factory, uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
894 
895 
896     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
897 
898 }
899 
900 // File: contracts/interface/IBtswapPairToken.sol
901 
902 pragma solidity >=0.5.0 <0.7.0;
903 
904 
905 interface IBtswapPairToken {
906     function name() external pure returns (string memory);
907 
908     function symbol() external pure returns (string memory);
909 
910     function decimals() external pure returns (uint8);
911 
912     function totalSupply() external view returns (uint256);
913 
914     function balanceOf(address owner) external view returns (uint256);
915 
916     function allowance(address owner, address spender) external view returns (uint256);
917 
918     function approve(address spender, uint256 value) external returns (bool);
919 
920     function transfer(address to, uint256 value) external returns (bool);
921 
922     function transferFrom(address from, address to, uint256 value) external returns (bool);
923 
924     function DOMAIN_SEPARATOR() external view returns (bytes32);
925 
926     function PERMIT_TYPEHASH() external pure returns (bytes32);
927 
928     function nonces(address owner) external view returns (uint256);
929 
930     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
931 
932     function MINIMUM_LIQUIDITY() external pure returns (uint256);
933 
934     function router() external view returns (address);
935 
936     function factory() external view returns (address);
937 
938     function token0() external view returns (address);
939 
940     function token1() external view returns (address);
941 
942     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
943 
944     function price0CumulativeLast() external view returns (uint256);
945 
946     function price1CumulativeLast() external view returns (uint256);
947 
948     function kLast() external view returns (uint256);
949 
950     function mint(address to) external returns (uint256 liquidity);
951 
952     function burn(address to) external returns (uint256 amount0, uint256 amount1);
953 
954     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
955 
956     function skim(address to) external;
957 
958     function sync() external;
959 
960     function initialize(address, address, address) external;
961 
962     function price(address token) external view returns (uint256);
963 
964 
965     event Approval(address indexed owner, address indexed spender, uint256 value);
966     event Transfer(address indexed from, address indexed to, uint256 value);
967     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
968     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
969     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
970     event Sync(uint112 reserve0, uint112 reserve1);
971 
972 }
973 
974 // File: contracts/interface/IBtswapRouter02.sol
975 
976 pragma solidity >=0.5.0 <0.7.0;
977 
978 
979 interface IBtswapRouter02 {
980     function factory() external pure returns (address);
981 
982     function WETH() external pure returns (address);
983 
984     function BT() external pure returns (address);
985 
986     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
987 
988     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
989 
990     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);
991 
992     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);
993 
994     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);
995 
996     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);
997 
998     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
999 
1000     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
1001 
1002     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
1003 
1004     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
1005 
1006     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
1007 
1008     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
1009 
1010     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);
1011 
1012     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
1013 
1014     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
1015 
1016     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
1017 
1018     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
1019 
1020     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);
1021 
1022     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
1023 
1024     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
1025 
1026     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
1027 
1028     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
1029 
1030     function weth(address token) external view returns (uint256);
1031 
1032     function onTransfer(address sender, address recipient) external returns (bool);
1033 
1034 }
1035 
1036 // File: contracts/interface/IBtswapToken.sol
1037 
1038 pragma solidity >=0.5.0 <0.7.0;
1039 
1040 
1041 interface IBtswapToken {
1042     function swap(address account, address input, uint256 amount, address output) external returns (bool);
1043 
1044     function liquidity(address account, address pair) external returns (bool);
1045 
1046 }
1047 
1048 // File: contracts/interface/IBtswapWhitelistedRole.sol
1049 
1050 pragma solidity >=0.5.0 <0.7.0;
1051 
1052 
1053 interface IBtswapWhitelistedRole {
1054     function getWhitelistedsLength() external view returns (uint256);
1055 
1056     function isWhitelisted(address) external view returns (bool);
1057 
1058     function whitelisteds(uint256) external view returns (address);
1059 
1060 }
1061 
1062 // File: contracts/biz/BtswapToken.sol
1063 
1064 pragma solidity >=0.5.0 <0.7.0;
1065 
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 contract BtswapToken is IBtswapToken, WhitelistedRole, MinterRole, ERC20 {
1076     uint256 public constant MINT_DECAY_DURATION = 8409600;
1077     uint256 public INITIAL_BLOCK_REWARD = SafeMath.wad().mul(56);
1078     uint256 public PERCENTAGE_FOR_TAKER = SafeMath.wad().mul(60).div(100);
1079     uint256 public PERCENTAGE_FOR_MAKER = SafeMath.wad().mul(30).div(100);
1080     address public constant TAKER_ADDRESS = 0x0000000000000000000000000000000000000001;
1081     address public constant MAKER_ADDRESS = 0x0000000000000000000000000000000000000002;
1082     address public constant GROUP_ADDRESS = 0x0000000000000000000000000000000000000003;
1083 
1084     IBtswapRouter02 private _router;
1085 
1086     uint256 private _initMintBlock;
1087     uint256 private _lastMintBlock;
1088     mapping(address => uint256) private _weights;
1089 
1090     Pool public taker;
1091     Pool public maker;
1092 
1093     struct Pool {
1094         uint256 timestamp;
1095         uint256 quantity;
1096         uint256 deposit;
1097         mapping(address => User) users;
1098     }
1099 
1100     struct User {
1101         uint256 timestamp;
1102         uint256 quantity;
1103         uint256 deposit;
1104         mapping(address => uint256) deposits;
1105     }
1106 
1107     constructor () public ERC20("BTswap Token", "BT", 18) {
1108         _setInitMintBlock(block.number);
1109         _setLastMintBlock(block.number);
1110         _mint(msg.sender, 50000000 * 1e18);
1111     }
1112 
1113 
1114     /**
1115      * dao
1116      */
1117     function router() public view returns (IBtswapRouter02) {
1118         return _router;
1119     }
1120 
1121     function setRouter(IBtswapRouter02 newRouter) public onlyOwner {
1122         require(address(newRouter) != address(0), "BtswapToken: new router is the zero address");
1123         _router = newRouter;
1124     }
1125 
1126     function initMintBlock() public view returns (uint256) {
1127         return _initMintBlock;
1128     }
1129 
1130     function _setInitMintBlock(uint256 blockNumber) internal {
1131         _initMintBlock = blockNumber;
1132     }
1133 
1134     function lastMintBlock() public view returns (uint256) {
1135         return _lastMintBlock;
1136     }
1137 
1138     function _setLastMintBlock(uint256 blockNumber) internal {
1139         _lastMintBlock = blockNumber;
1140     }
1141 
1142     function weightOf(address token) public view returns (uint256) {
1143         uint256 _weight = _weights[token];
1144 
1145         if (_weight > 0) {
1146             return _weight;
1147         }
1148 
1149         return 1;
1150     }
1151 
1152     function setWeight(address newToken, uint256 newWeight) public onlyOwner {
1153         require(address(newToken) != address(0), "BtswapToken: new token is the zero address");
1154         _weights[newToken] = newWeight;
1155     }
1156 
1157 
1158     /**
1159      * miner
1160      */
1161     function phase(uint256 blockNumber) public view returns (uint256) {
1162         uint256 _phase = 0;
1163 
1164         if (blockNumber > initMintBlock()) {
1165             _phase = (blockNumber.sub(initMintBlock()).sub(1)).div(MINT_DECAY_DURATION);
1166         }
1167 
1168         return _phase;
1169     }
1170 
1171     function phase() public view returns (uint256) {
1172         return phase(block.number);
1173     }
1174 
1175     function reward(uint256 blockNumber) public view returns (uint256) {
1176         uint256 _phase = phase(blockNumber);
1177         if (_phase >= 10) {
1178             return 0;
1179         }
1180 
1181         return INITIAL_BLOCK_REWARD.div(2 ** _phase);
1182     }
1183 
1184     function reward() public view returns (uint256) {
1185         return reward(block.number);
1186     }
1187 
1188     function mintable(uint256 blockNumber) public view returns (uint256) {
1189         uint256 _mintable = 0;
1190         uint256 lastMintableBlock = lastMintBlock();
1191         uint256 n = phase(lastMintBlock());
1192         uint256 m = phase(blockNumber);
1193 
1194         while (n < m) {
1195             n++;
1196             uint256 r = n.mul(MINT_DECAY_DURATION).add(initMintBlock());
1197             _mintable = _mintable.add((r.sub(lastMintableBlock)).mul(reward(r)));
1198             lastMintableBlock = r;
1199         }
1200         _mintable = _mintable.add((blockNumber.sub(lastMintableBlock)).mul(reward(blockNumber)));
1201 
1202         return _mintable;
1203     }
1204 
1205     function mint() public returns (bool) {
1206         if (!isMintable()) {
1207             return false;
1208         }
1209 
1210         uint256 _mintable = mintable(block.number);
1211         if (_mintable <= 0) {
1212             return false;
1213         }
1214 
1215         _setLastMintBlock(block.number);
1216 
1217         uint256 takerMintable = _mintable.wmul(PERCENTAGE_FOR_TAKER);
1218         uint256 makerMintable = _mintable.wmul(PERCENTAGE_FOR_MAKER);
1219         uint256 groupMintable = _mintable.sub(takerMintable).sub(makerMintable);
1220 
1221         _mint(TAKER_ADDRESS, takerMintable);
1222         _mint(MAKER_ADDRESS, makerMintable);
1223         _mint(GROUP_ADDRESS, groupMintable);
1224 
1225         return true;
1226     }
1227 
1228 
1229     /**
1230      * oracle
1231      */
1232     function weth(address token, uint256 amount) public view returns (uint256) {
1233         uint256 _weth = router().weth(token);
1234         if (_weth <= 0) {
1235             return 0;
1236         }
1237 
1238         return _weth.wmul(amount);
1239     }
1240 
1241     function rebalance(address account, address pair) public view returns (uint256) {
1242         if (!isWhitelisted(IBtswapPairToken(pair).token0()) || !isWhitelisted(IBtswapPairToken(pair).token1())) {
1243             return 0;
1244         }
1245 
1246         uint256 m = IBtswapPairToken(pair).totalSupply();
1247         uint256 n = IBtswapPairToken(pair).balanceOf(account);
1248         if (n <= 0 || m <= 0) {
1249             return 0;
1250         }
1251 
1252         (uint112 reserve0, uint112 reserve1,) = IBtswapPairToken(pair).getReserves();
1253         uint256 _weth0 = weth(IBtswapPairToken(pair).token0(), uint256(reserve0));
1254         uint256 _weight0 = weightOf(IBtswapPairToken(pair).token0());
1255         uint256 _weth1 = weth(IBtswapPairToken(pair).token1(), uint256(reserve1));
1256         uint256 _weight1 = weightOf(IBtswapPairToken(pair).token1());
1257 
1258         uint256 _weth = _weth0.mul(_weight0).add(_weth1.mul(_weight1));
1259 
1260         return _weth.mul(n).div(m);
1261     }
1262 
1263 
1264     /**
1265      * taker
1266      */
1267     function shareOf(address account) public view returns (uint256, uint256) {
1268         uint256 m = takerQuantityOfPool();
1269         uint256 n = takerQuantityOf(account);
1270 
1271         return (m, n);
1272     }
1273 
1274     function takerQuantityOfPool() public view returns (uint256) {
1275         return taker.quantity;
1276     }
1277 
1278     function takerTimestampOfPool() public view returns (uint256) {
1279         return taker.timestamp;
1280     }
1281 
1282     function takerQuantityOf(address account) public view returns (uint256) {
1283         return taker.users[account].quantity;
1284     }
1285 
1286     function takerTimestampOf(address account) public view returns (uint256) {
1287         return taker.users[account].timestamp;
1288     }
1289 
1290     function takerBalanceOf() public view returns (uint256) {
1291         return balanceOf(TAKER_ADDRESS);
1292     }
1293 
1294     function takerBalanceOf(address account) public view returns (uint256) {
1295         (uint256 m, uint256 n) = shareOf(account);
1296         if (n <= 0 || m <= 0) {
1297             return 0;
1298         }
1299 
1300         if (n == m) {
1301             return takerBalanceOf();
1302         }
1303 
1304         return takerBalanceOf().mul(n).div(m);
1305     }
1306 
1307     function swap(address account, address input, uint256 amount, address output) public onlyMinter returns (bool) {
1308         require(account != address(0), "BtswapToken: taker swap account is the zero address");
1309         require(input != address(0), "BtswapToken: taker swap input is the zero address");
1310         require(output != address(0), "BtswapToken: taker swap output is the zero address");
1311 
1312         // if (!isWhitelisted(input) || !isWhitelisted(output)) {
1313         //     return false;
1314         // }
1315 
1316         uint256 quantity = weth(input, amount);
1317         if (quantity <= 0) {
1318             return false;
1319         }
1320 
1321         mint();
1322 
1323         taker.timestamp = block.timestamp;
1324         taker.quantity = takerQuantityOfPool().add(quantity);
1325 
1326         User storage user = taker.users[account];
1327         user.timestamp = block.timestamp;
1328         user.quantity = takerQuantityOf(account).add(quantity);
1329 
1330         return true;
1331     }
1332 
1333     function _takerWithdraw(uint256 quantity) internal returns (bool) {
1334         require(quantity > 0, "BtswapToken: taker withdraw quantity is the zero value");
1335         require(takerBalanceOf() >= quantity, "BtswapToken: taker withdraw quantity exceeds taker balance");
1336 
1337         uint256 delta = takerQuantityOfPool();
1338         if (takerBalanceOf() != quantity) {
1339             delta = takerQuantityOfPool().mul(quantity).div(takerBalanceOf());
1340         }
1341 
1342         taker.timestamp = block.timestamp;
1343         taker.quantity = takerQuantityOfPool().sub(delta);
1344 
1345         User storage user = taker.users[msg.sender];
1346         user.timestamp = block.timestamp;
1347         user.quantity = takerQuantityOf(msg.sender).sub(delta);
1348 
1349         _transfer(TAKER_ADDRESS, msg.sender, quantity);
1350 
1351         return true;
1352     }
1353 
1354     function takerWithdraw(uint256 quantity) public returns (bool) {
1355         mint();
1356 
1357         uint256 balance = takerBalanceOf(msg.sender);
1358         if (quantity <= balance) {
1359             return _takerWithdraw(quantity);
1360         }
1361 
1362         return _takerWithdraw(balance);
1363     }
1364 
1365     function takerWithdraw() public returns (bool) {
1366         mint();
1367 
1368         uint256 balance = takerBalanceOf(msg.sender);
1369 
1370         return _takerWithdraw(balance);
1371     }
1372 
1373 
1374     /**
1375      * maker
1376      */
1377     function liquidityOf(address account) public view returns (uint256, uint256) {
1378         uint256 m = makerQuantityOfPool().add(makerDepositOfPool().mul(block.number.sub(makerTimestampOfPool())));
1379         uint256 n = makerQuantityOf(account).add(makerDepositOf(account).mul(block.number.sub(makerTimestampOf(account))));
1380 
1381         return (m, n);
1382     }
1383 
1384     function makerQuantityOfPool() public view returns (uint256) {
1385         return maker.quantity;
1386     }
1387 
1388     function makerDepositOfPool() public view returns (uint256) {
1389         return maker.deposit;
1390     }
1391 
1392     function makerTimestampOfPool() public view returns (uint256) {
1393         return maker.timestamp;
1394     }
1395 
1396     function makerQuantityOf(address account) public view returns (uint256) {
1397         return maker.users[account].quantity;
1398     }
1399 
1400     function makerDepositOf(address account) public view returns (uint256) {
1401         return maker.users[account].deposit;
1402     }
1403 
1404     function makerLastDepositOf(address account, address pair) public view returns (uint256) {
1405         return maker.users[account].deposits[pair];
1406     }
1407 
1408     function makerTimestampOf(address account) public view returns (uint256) {
1409         return maker.users[account].timestamp;
1410     }
1411 
1412     function _makerBalanceAndLiquidityOf(address account) internal view returns (uint256, uint256, uint256) {
1413         (uint256 m, uint256 n) = liquidityOf(account);
1414         if (n <= 0 || m <= 0) {
1415             return (0, m, n);
1416         }
1417 
1418         if (n == m) {
1419             return (makerBalanceOf(), m, n);
1420         }
1421 
1422         return (makerBalanceOf().mul(n).div(m), m, n);
1423     }
1424 
1425     function makerBalanceOf() public view returns (uint256) {
1426         return balanceOf(MAKER_ADDRESS);
1427     }
1428 
1429     function makerBalanceOf(address account) public view returns (uint256) {
1430         (uint256 balance, ,) = _makerBalanceAndLiquidityOf(account);
1431         return balance;
1432     }
1433 
1434     function liquidity(address account, address pair) public onlyRouter returns (bool) {
1435         require(account != address(0), "BtswapToken: maker liquidity account is the zero address");
1436         require(pair != address(0), "BtswapToken: maker liquidity pair is the zero address");
1437 
1438         mint();
1439         
1440         User storage user = maker.users[account];
1441         uint256 deposit = rebalance(account, pair);
1442         uint256 previous = makerLastDepositOf(account, pair);
1443 
1444         (uint256 m, uint256 n) = liquidityOf(account);
1445         maker.quantity = m;
1446         maker.timestamp = block.number;
1447         maker.deposit = makerDepositOfPool().add(deposit).sub(previous);
1448 
1449         user.quantity = n;
1450         user.timestamp = block.number;
1451         user.deposit = makerDepositOf(account).add(deposit).sub(previous);
1452         user.deposits[pair] = deposit;
1453 
1454         return true;
1455     }
1456 
1457     function _makerWithdraw(address account) internal returns (bool) {
1458         require(account != address(0), "BtswapToken: maker withdraw account is the zero address");
1459 
1460         (uint256 withdrawn, uint256 m, uint256 n) = _makerBalanceAndLiquidityOf(account);
1461         if (withdrawn <= 0) {
1462             return false;
1463         }
1464 
1465         User storage user = maker.users[account];
1466         maker.timestamp = block.number;
1467         maker.quantity = m.sub(n);
1468         user.timestamp = block.number;
1469         user.quantity = 0;
1470 
1471         _transfer(MAKER_ADDRESS, account, withdrawn);
1472 
1473         return true;
1474     }
1475 
1476     function makerWithdraw() public returns (bool) {
1477         mint();
1478 
1479         return _makerWithdraw(msg.sender);
1480     }
1481 
1482 
1483     /**
1484      * group
1485      */
1486     function groupBalanceOf() public view returns (uint256) {
1487         return balanceOf(GROUP_ADDRESS);
1488     }
1489 
1490     function groupWithdraw(address account, uint256 amount) public onlyOwner returns (bool) {
1491         require(account != address(0), "BtswapToken: group withdraw account is the zero address");
1492         require(amount > 0, "BtswapToken: group withdraw amount is the zero value");
1493         require(groupBalanceOf() >= amount, "BtswapToken: group withdraw amount exceeds group balance");
1494 
1495         _transfer(GROUP_ADDRESS, account, amount);
1496 
1497         return true;
1498     }
1499 
1500 
1501     /**
1502      * modifier
1503      */
1504     function isMintable() public view returns (bool) {
1505         if (block.number.sub(lastMintBlock()) > 0 && reward(lastMintBlock()) > 0) {
1506             return true;
1507         }
1508         return false;
1509     }
1510 
1511     function isRouter(address account) public view returns (bool) {
1512         return account == address(router());
1513     }
1514 
1515     modifier onlyRouter() {
1516         require(isRouter(msg.sender), "BtswapToken: caller is not the router");
1517         _;
1518     }
1519 
1520 }