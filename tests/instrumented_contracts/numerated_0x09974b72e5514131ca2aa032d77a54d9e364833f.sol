1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount)
11         external
12         returns (bool);
13 
14     function allowance(address owner, address spender)
15         external
16         view
17         returns (uint256);
18 
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33     
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal virtual view returns (address payable) {
38         return msg.sender;
39     }
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(
55         uint256 a,
56         uint256 b,
57         string memory errorMessage
58     ) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b != 0, errorMessage);
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Implementation of the {IERC20} interface.
111  */
112 contract ERC20 is Context, IERC20 {
113     using SafeMath for uint256;
114 
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     //mapping for tracking locked balance 
120     mapping(address => uint256) private _lockers;
121     //mapping for release time
122     mapping(address => uint256) private _timers;
123     //mapping for new Addresses and balance shift (teleportation)
124     mapping(address => mapping(string => uint256)) private _teleportScroll;
125 
126     uint256 private _totalSupply;
127     address private _owner;
128     string private _name;
129     string private _symbol;
130     uint8 private _decimals;
131     address private _lockerAccount;
132     address private _teleportSafe;
133     uint256 private _teleportTime;
134 
135     event ReleaseTime(address indexed account, uint256 value);
136 
137     event lockedBalance(address indexed account, uint256 value);
138     
139     event Released(address indexed account, uint256 value);
140 
141     event Globals(address indexed account, uint256 value);
142     
143     event teleportation(address indexed account, string newaccount, uint256 shiftBalance);
144     
145     /**
146      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
147      * a default value of 18.
148      *
149      * All three of these values are immutable: they can only be set once during
150      * construction.
151      */
152     constructor(string memory name_, string memory symbol_, uint256 initialSupply_) {
153         _name = name_;
154         _symbol = symbol_;
155         _decimals = 18;
156         _owner = _msgSender();
157         _mint(msg.sender, initialSupply_);
158 
159     }
160 
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     modifier locked() {
167         require(_lockerAccount == _msgSender(), "Locked: caller is not the lockerAccount");
168         _;
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function getOwner() public view returns (address) {
175         return _owner;
176     }
177 
178 
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() public view returns (string memory) {
183         return _name;
184     }
185 
186     /**
187      * @dev Returns the symbol of the token, usually a shorter version of the
188      * name.
189      */
190     function symbol() public view returns (string memory) {
191         return _symbol;
192     }
193 
194     /**
195      * @dev Returns the number of decimals used to get its user representation.
196      *
197      * Tokens usually opt for a value of 18, imitating the relationship between
198      * Ether and Wei. This is the value {ERC20} uses.
199      */
200     function decimals() public view returns (uint8) {
201         return _decimals;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public override view returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public override view returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount)
226         public
227         virtual
228         override
229         returns (bool)
230     {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender) 
239         public
240         virtual
241         override
242         view
243         returns (uint256)
244     {
245         return _allowances[owner][spender];
246     }
247 
248     /**
249      * @dev See {IERC20-approve}.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      */
255     function approve(address spender, uint256 amount)
256         public
257         virtual
258         override
259         returns (bool)
260     {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-transferFrom}.
267      *
268      * Emits an {Approval} event indicating the updated allowance. This is not
269      * required by the EIP.
270      *
271      * Requirements:
272      *
273      * - `sender` and `recipient` cannot be the zero address.
274      * - `sender` must have a balance of at least `amount`.
275      * - the caller must have allowance for ``sender``'s tokens of at least
276      * `amount`.
277      */
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public virtual override returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(
285             sender,
286             _msgSender(),
287             _allowances[sender][_msgSender()].sub(
288                 amount,
289                 "ERC20: transfer amount exceeds allowance"
290             )
291         );
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue)
305         public
306         virtual
307         returns (bool)
308     {
309         _approve(
310             _msgSender(),
311             spender,
312             _allowances[_msgSender()][spender].add(addedValue)
313         );
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue)
332         public
333         virtual
334         returns (bool)
335     {
336         _approve(
337             _msgSender(),
338             spender,
339             _allowances[_msgSender()][spender].sub(
340                 subtractedValue,
341                 "ERC20: decreased allowance below zero"
342             )
343         );
344         return true;
345     }
346 
347     /**
348      * @dev Moves tokens `amount` from `sender` to `recipient`.
349      *
350      * This is internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _balances[sender] = _balances[sender].sub(
370             amount,
371             "ERC20: transfer amount exceeds balance"
372         );
373         _balances[recipient] = _balances[recipient].add(amount);
374         emit Transfer(sender, recipient, amount);
375     }
376 
377     function burn(uint256 amount) public virtual {
378         _burn(_msgSender(), amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
396         _totalSupply = _totalSupply.sub(amount);
397         emit Transfer(account, address(0), amount);
398     }
399 
400 
401     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
402      * the total supply.
403      *
404      * Emits a {Transfer} event with `from` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `to` cannot be the zero address.
409      */
410     function _mint(address account, uint256 amount) internal virtual onlyOwner {
411         require(account != address(0), "ERC20: mint to the zero address");
412 
413 
414         _totalSupply = _totalSupply.add(amount * 10 ** _decimals);
415         _balances[account] = _balances[account].add(amount * 10 ** _decimals);
416         emit Transfer(address(0), account, amount * 10 ** _decimals);
417     }
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440     /** 
441      * Implementation for locking asset of account for given time aka Escrow
442      * starts 
443     */
444     /**
445      * @dev Owner can set the lockerAccount where balances are locked.
446      */   
447     function setLockerAccount(address _account) public onlyOwner returns (bool) {
448         require(_msgSender() != address(0), "setLockerAccount: Executor account cannot be zero address");
449         require(_account != address(0), "setLockerAccount: Locker Account cannot be zero address");
450         _lockerAccount = _account;
451         return true;
452     }
453     /**
454      * @dev Returns the lockerAccount(used to lock all balances) set by owner.
455      */   
456     function getLockerAccount() public view returns (address) {
457         return _lockerAccount;
458     }
459     /**
460      * @dev Set release time for locked balance of an account. Must be set before locking balance. 
461      */
462     function setReleaseTime(address _account, uint _timestamp) public onlyOwner returns (uint256) {
463         require(_msgSender() != address(0), "setTimeStamp: Executor account cannot be zero address");
464         require(_account != address(0), "setTimeStamp: Cannot set timestamp for zero address");
465         require(_timestamp > block.timestamp, "TokenTimelock: release time cannot be set in past");
466         _timers[_account] = _timestamp;
467         emit ReleaseTime(_account, _timestamp);
468         return _timers[_account];
469     }
470     
471     /**
472      * @dev Returns the releaseTime(for locked balance) of the given address.
473      */    
474     function getReleaseTime(address _account) public view returns (uint256) {
475         return _timers[_account];
476     }
477     /**
478      * @dev lock balance after owner has set the release timer
479      */     
480     function lockBalance(uint256 amount) public returns(bool){
481         require(_msgSender() != _lockerAccount, "lockBalance: Cannot lock Balance of self");
482         require(_lockerAccount != address(0), "lockBalance: Locker Account is not set by owner");
483         require(amount > 0, "lockBalance: Must lock positive amount");
484         require(_timers[_msgSender()] != 0, "lockBalance: Release Time is not set by owner. Release Time must be set before locking balance");
485         require(_lockers[_msgSender()] == 0, "lockBalance: Release previously locked balance first");
486         _transfer(_msgSender(), _lockerAccount, amount);
487         _lockers[_msgSender()] = amount;
488         emit lockedBalance(_msgSender(), amount);
489         return true;
490     }
491     
492     /**
493      * @dev Returns the releaseTime(for locked balance) of the current sender.
494      */    
495     function getLockedAmount() public view returns (uint256) {
496         return _lockers[_msgSender()];
497     }
498     
499     function release(address _account) public locked returns (bool) {
500         require(_lockerAccount != address(0), "release: Locker Account is not set by owner");
501         require(_account != address(0), "release: Cannot release balance for zero address");
502         require(block.timestamp >= _timers[_account], "Timelock: current time is before release time");
503         require(_lockers[_account] > 0, "release: No amount is locked against this account. +ve amount must be locked");
504         _transfer(_msgSender(), _account, _lockers[_account]);
505         _lockers[_account] = 0;
506         emit Released(_account, _lockers[_msgSender()]);
507         return true;
508     }
509     /** 
510      * Implementation for Escrow Ends
511      * 
512     */
513 
514     /** 
515      * Implementation for teleportation
516      * starts 
517     */
518 
519     /**
520      * @dev Set shifter globals. 
521      */    
522     function setGlobals(address _account, uint _timestamp) public onlyOwner returns (bool) {
523         require(_msgSender() != address(0), "Executor account cannot be zero address");
524         require(_account != address(0), "Zero address");
525         require(_timestamp > block.timestamp, "Timestamp cannot be set in past");
526         _setGlobsInternal(_account, _timestamp);
527         return true;
528     }    
529 
530     function _setGlobsInternal(address _account, uint _time) private returns (bool) {
531         require(_msgSender() != address(0), "Executor account cannot be zero address");
532         require(_account != address(0), "Zero Address");
533         require(_time > block.timestamp, "Reserruction time cannot be set in past");
534         _teleportSafe = _account;
535         _teleportTime = _time;
536         emit Globals(_account, _time);
537         return true;
538     }
539 
540 
541     function teleport(string memory _newAddress) public returns(bool) {
542         require(_msgSender() != _teleportSafe, "Teleport: TeleportSafe cannot transfer to self");
543         require(_teleportSafe != address(0), "Teleport: TeleportSafe Account is not set by owner");
544         require(_balances[_msgSender()] > 0, "Teleport: Must transfer +ve amount");
545         require(block.timestamp > _teleportTime , "Teleport: It is not time yet");
546         uint256 shiftAmount = _balances[_msgSender()]; //
547         _transfer(_msgSender(), _teleportSafe, _balances[_msgSender()]);
548         _teleportScroll[_msgSender()][_newAddress] = shiftAmount;
549         emit teleportation(_msgSender(), _newAddress, shiftAmount);//emit balance shiftAmount
550         return true;
551     }
552     /**
553      * @dev Returns the amount(also the balance) of the given address which will be shifted to newAddress after teleportation.
554      */    
555     function checkshiftAmount(string memory _newAddress) public view returns (uint256) {
556         return _teleportScroll[_msgSender()][_newAddress];
557     }
558     
559     // After teleportation completed
560     function resurrection(address payable _new) public onlyOwner { 
561     require(_teleportTime != 0 , "Teleportation time is not set");
562     require(block.timestamp > _teleportTime , "It is not time yet");
563     selfdestruct(_new);
564 }
565     /** 
566      * Implementation for teleportation
567      * Ends
568     */
569 }