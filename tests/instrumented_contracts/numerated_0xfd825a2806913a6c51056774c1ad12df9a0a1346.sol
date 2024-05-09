1 pragma solidity 0.5.7;
2 
3 
4 
5 
6 // ERC20 declare
7 contract IERC20 {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16   event Burn(address indexed burner, uint256 value);
17 }
18 
19 
20 
21 
22 // SafeERC20
23 library SafeERC20 {
24   function safeTransfer(
25     IERC20 _token,
26     address _to,
27     uint256 _value
28   )
29     internal
30   {
31     require(_token.transfer(_to, _value));
32   }
33 
34   function safeTransferFrom(
35     ERC20 _token,
36     address _from,
37     address _to,
38     uint256 _value
39   )
40     internal
41   {
42     require(_token.transferFrom(_from, _to, _value));
43   }
44 
45   function safeApprove(
46     ERC20 _token,
47     address _spender,
48     uint256 _value
49   )
50     internal
51   {
52     require(_token.approve(_spender, _value));
53   }
54 }
55 
56 
57 
58 
59 // Ownable
60 contract Ownable {
61   address public owner;
62   address public admin;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   constructor() public {
68     owner = msg.sender;
69   }
70 
71 
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   modifier onlyOwnerOrAdmin() {
78     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
79     _;
80   }
81 
82 
83   function transferOwnership(address newOwner) onlyOwner public {
84     require(newOwner != address(0));
85     require(newOwner != owner);
86     require(newOwner != admin);
87 
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   function setAdmin(address newAdmin) onlyOwner public {
93     require(admin != newAdmin);
94     require(owner != newAdmin);
95 
96     admin = newAdmin;
97   }
98 }
99 
100 
101 
102 
103 // ERC20 functions
104 contract ERC20 is IERC20, Ownable {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108     mapping(address => bool) internal locks;
109     mapping (address => mapping (address => uint256)) private _allowed;
110     
111     uint256 public Max_supply = 10000000000 * (10 **18);
112     uint256 private _totalSupply;
113 
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118 
119     function balanceOf(address owner) public view returns (uint256) {
120         return _balances[owner];
121     }
122 
123 
124     function allowance(address owner, address spender) public view returns (uint256) {
125         return _allowed[owner][spender];
126     }
127 
128 
129     function transfer(address to, uint256 value) public returns (bool) {
130         _transfer(msg.sender, to, value);
131         return true;
132     }
133     
134     function _transfer(address from, address to, uint256 value) internal {
135         require(to != address(0));
136         require(locks[msg.sender] == false);
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141     
142 
143     function approve(address spender, uint256 value) public returns (bool) {
144         _approve(msg.sender, spender, value);
145         return true;
146     }
147     
148     function _approve(address owner, address spender, uint256 value) internal {
149         require(spender != address(0));
150         require(owner != address(0));
151 
152         _allowed[owner][spender] = value;
153         emit Approval(owner, spender, value);
154     }
155 
156     function transferFrom(address from, address to, uint256 value) public returns (bool) {
157         _transfer(from, to, value);
158         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
159         return true;
160     }
161 
162 
163     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
164         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
165         return true;
166     }
167 
168 
169     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
170         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
171         return true;
172     }
173 
174 
175     function _mint(address account, uint256 value) internal {
176         require(account != address(0));
177         require(Max_supply > _totalSupply);
178         _totalSupply = _totalSupply.add(value);
179         _balances[account] = _balances[account].add(value);
180         emit Transfer(address(0), account, value);
181     }
182     
183     
184     function burn(address from, uint256 value) public {
185         _burn(from, value);
186     }
187     
188 
189     function _burn(address account, uint256 value) internal {
190         require(account != address(0));
191         
192         _totalSupply = _totalSupply.sub(value);
193         _balances[account] = _balances[account].sub(value);
194         emit Transfer(account, address(0), value);
195     }
196     
197 
198     function lock(address _owner) public onlyOwner returns (bool) {
199         require(locks[_owner] == false);
200         locks[_owner] = true;
201         return true;
202     }
203 
204     function unlock(address _owner) public onlyOwner returns (bool) {
205         require(locks[_owner] == true);
206         locks[_owner] = false;
207         return true;
208     }
209 
210     function showLockState(address _owner) public view returns (bool) {
211         return locks[_owner];
212     }
213 
214 }
215 
216 
217 // Pause, Mint base
218 library Roles {
219     struct Role {
220         mapping (address => bool) bearer;
221     }
222 
223 
224     function add(Role storage role, address account) internal {
225         require(account != address(0));
226         require(!has(role, account));
227 
228         role.bearer[account] = true;
229     }
230 
231 
232     function remove(Role storage role, address account) internal {
233         require(account != address(0));
234         require(has(role, account));
235 
236         role.bearer[account] = false;
237     }
238 
239 
240     function has(Role storage role, address account) internal view returns (bool) {
241         require(account != address(0));
242         return role.bearer[account];
243     }
244 }
245 
246 
247 
248 // ERC20Detailed
249 contract ERC20Detailed is IERC20 {
250     string private _name;
251     string private _symbol;
252     uint8 private _decimals;
253 
254     constructor (string memory name, string memory symbol, uint8 decimals) public {
255         _name = name;
256         _symbol = symbol;
257         _decimals = decimals;
258     }
259 }
260 
261 
262 
263 
264 // Math
265 library Math {
266 
267     function max(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a >= b ? a : b;
269     }
270 
271 
272     function min(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a < b ? a : b;
274     }
275 
276 
277     function average(uint256 a, uint256 b) internal pure returns (uint256) {
278         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
279     }
280 }
281 
282 
283 
284 
285 // SafeMath
286 library SafeMath {
287   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288     if (a == 0 || b == 0) {
289       return 0;
290     }
291 
292     uint256 c = a * b;
293     assert(c / a == b);
294     return c;
295   }
296 
297   function div(uint256 a, uint256 b) internal pure returns (uint256) {
298     // assert(b > 0); // Solidity automatically throws when dividing by 0
299     uint256 c = a / b;
300     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301     return c;
302   }
303 
304   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305     assert(b <= a);
306     return a - b;
307   }
308 
309   function add(uint256 a, uint256 b) internal pure returns (uint256) {
310     uint256 c = a + b;
311     assert(c >= a); // overflow check
312     return c;
313   }
314 }
315 
316 
317 
318 
319 // Pause part
320 contract PauserRole {
321     using Roles for Roles.Role;
322 
323     event PauserAdded(address indexed account);
324     event PauserRemoved(address indexed account);
325 
326     Roles.Role private _pausers;
327 
328     constructor () internal {
329         _addPauser(msg.sender);
330     }
331 
332     modifier onlyPauser() {
333         require(isPauser(msg.sender));
334         _;
335     }
336 
337     function isPauser(address account) public view returns (bool) {
338         return _pausers.has(account);
339     }
340 
341     function addPauser(address account) public onlyPauser {
342         _addPauser(account);
343     }
344 
345     function renouncePauser() public {
346         _removePauser(msg.sender);
347     }
348 
349     function _addPauser(address account) internal {
350         _pausers.add(account);
351         emit PauserAdded(account);
352     }
353 
354     function _removePauser(address account) internal {
355         _pausers.remove(account);
356         emit PauserRemoved(account);
357     }
358 }
359 
360 
361 
362 
363 
364 contract Pausable is PauserRole {
365     event Paused(address account);
366     event Unpaused(address account);
367 
368     bool private _paused;
369 
370     constructor () internal {
371         _paused = false;
372     }
373 
374     function paused() public view returns (bool) {
375         return _paused;
376     }
377 
378 
379     modifier whenNotPaused() {
380         require(!_paused);
381         _;
382     }
383 
384 
385     modifier whenPaused() {
386         require(_paused);
387         _;
388     }
389 
390 
391     function pause() public onlyPauser whenNotPaused {
392         _paused = true;
393         emit Paused(msg.sender);
394     }
395 
396 
397     function unpause() public onlyPauser whenPaused {
398         _paused = false;
399         emit Unpaused(msg.sender);
400     }
401 }
402 
403 
404 
405 
406 contract ERC20Pausable is ERC20, Pausable {
407     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
408         return super.transfer(to, value);
409     }
410 
411     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
412         return super.transferFrom(from, to, value);
413     }
414 
415     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
416         return super.approve(spender, value);
417     }
418 
419     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
420         return super.increaseAllowance(spender, addedValue);
421     }
422 
423     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
424         return super.decreaseAllowance(spender, subtractedValue);
425     }
426 }
427 
428 
429 
430 // Snapshot part
431 library Arrays {
432 
433     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
434         if (array.length == 0) {
435             return 0;
436         }
437 
438         uint256 low = 0;
439         uint256 high = array.length;
440 
441         while (low < high) {
442             uint256 mid = Math.average(low, high);
443 
444             if (array[mid] > element) {
445                 high = mid;
446             } else {
447                 low = mid + 1;
448             }
449         }
450 
451 
452         if (low > 0 && array[low - 1] == element) {
453             return low - 1;
454         } else {
455             return low;
456         }
457     }
458 }
459 
460 
461 
462 
463 library Counters {
464     using SafeMath for uint256;
465 
466     struct Counter {
467 
468         uint256 _value; 
469     }
470 
471     function current(Counter storage counter) internal view returns (uint256) {
472         return counter._value;
473     }
474 
475     function increment(Counter storage counter) internal {
476         counter._value += 1;
477     }
478 
479     function decrement(Counter storage counter) internal {
480         counter._value = counter._value.sub(1);
481     }
482 }
483 
484 
485 
486 
487 contract ERC20Snapshot is ERC20 {
488     using SafeMath for uint256;
489     using Arrays for uint256[];
490     using Counters for Counters.Counter;
491 
492 
493     struct Snapshots {
494         uint256[] ids;
495         uint256[] values;
496     }
497 
498     mapping (address => Snapshots) private _accountBalanceSnapshots;
499     Snapshots private _totalSupplySnaphots;
500 
501 
502     Counters.Counter private _currentSnapshotId;
503 
504     event Snapshot(uint256 id);
505 
506 
507     function snapshot() public returns (uint256) {
508         _currentSnapshotId.increment();
509 
510         uint256 currentId = _currentSnapshotId.current();
511         emit Snapshot(currentId);
512         return currentId;
513     }
514 
515     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
516         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
517 
518         return snapshotted ? value : balanceOf(account);
519     }
520 
521     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
522         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnaphots);
523 
524         return snapshotted ? value : totalSupply();
525     }
526 
527 
528     function _transfer(address from, address to, uint256 value) internal {
529         _updateAccountSnapshot(from);
530         _updateAccountSnapshot(to);
531 
532         super._transfer(from, to, value);
533     }
534 
535     function _mint(address account, uint256 value) internal {
536         _updateAccountSnapshot(account);
537         _updateTotalSupplySnapshot();
538 
539         super._mint(account, value);
540     }
541 
542     function _burn(address account, uint256 value) internal {
543         _updateAccountSnapshot(account);
544         _updateTotalSupplySnapshot();
545 
546         super._burn(account, value);
547     }
548 
549 
550     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
551         private view returns (bool, uint256)
552     {
553         require(snapshotId > 0);
554         require(snapshotId <= _currentSnapshotId.current());
555 
556         uint256 index = snapshots.ids.findUpperBound(snapshotId);
557 
558         if (index == snapshots.ids.length) {
559             return (false, 0);
560         } else {
561             return (true, snapshots.values[index]);
562         }
563     }
564 
565     function _updateAccountSnapshot(address account) private {
566         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
567     }
568 
569     function _updateTotalSupplySnapshot() private {
570         _updateSnapshot(_totalSupplySnaphots, totalSupply());
571     }
572 
573     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
574         uint256 currentId = _currentSnapshotId.current();
575         if (_lastSnapshotId(snapshots.ids) < currentId) {
576             snapshots.ids.push(currentId);
577             snapshots.values.push(currentValue);
578         }
579     }
580 
581     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
582         if (ids.length == 0) {
583             return 0;
584         } else {
585             return ids[ids.length - 1];
586         }
587     }
588 }
589 
590 
591 
592 // Mintable part
593 contract MinterRole {
594     using Roles for Roles.Role;
595 
596     event MinterAdded(address indexed account);
597     event MinterRemoved(address indexed account);
598 
599     Roles.Role private _minters;
600 
601     constructor () internal {
602         _addMinter(msg.sender);
603     }
604 
605     modifier onlyMinter() {
606         require(isMinter(msg.sender));
607         _;
608     }
609 
610     function isMinter(address account) public view returns (bool) {
611         return _minters.has(account);
612     }
613 
614     function addMinter(address account) public onlyMinter {
615         _addMinter(account);
616     }
617 
618     function renounceMinter() public {
619         _removeMinter(msg.sender);
620     }
621 
622     function _addMinter(address account) internal {
623         _minters.add(account);
624         emit MinterAdded(account);
625     }
626 
627     function _removeMinter(address account) internal {
628         _minters.remove(account);
629         emit MinterRemoved(account);
630     }
631 }
632 
633 
634 
635 
636 contract ERC20Mintable is ERC20, MinterRole {
637     function mint(address to, uint256 value) public onlyMinter returns (bool) {
638         _mint(to, value);
639         return true;
640     }
641 }
642 
643 
644 
645 
646 contract test is ERC20, ERC20Detailed, ERC20Snapshot, ERC20Pausable, ERC20Mintable {
647     
648     uint8 public constant DECIMALS = 18;
649     uint256 public constant INITIAL_SUPPLY = 0 * (10 ** uint256(DECIMALS));
650 
651     constructor () public ERC20Detailed("test", "test", DECIMALS) {
652         _mint(msg.sender, INITIAL_SUPPLY);
653     }
654   
655 }