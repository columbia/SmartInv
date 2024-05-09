1 pragma solidity ^0.4.24;
2 
3 library HxSafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14 
15     /**
16     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
17     */
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // Solidity only automatically asserts when dividing by 0
20         require(b > 0);
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23 
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a);
32         uint256 c = a - b;
33 
34         return c;
35     }
36 
37     /**
38     * @dev Adds two unsigned integers, reverts on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
49     * reverts when dividing by zero.
50     */
51     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b != 0);
53         return a % b;
54     }
55 }
56 
57 library Roles {
58     struct Role {
59         mapping (address => bool) bearer;
60     }
61 
62     /**
63      * @dev give an account access to this role
64      */
65     function add(Role storage role, address account) internal {
66         require(account != address(0));
67         require(!has(role, account));
68 
69         role.bearer[account] = true;
70     }
71 
72     /**
73      * @dev remove an account's access to this role
74      */
75     function remove(Role storage role, address account) internal {
76         require(account != address(0));
77         require(has(role, account));
78 
79         role.bearer[account] = false;
80     }
81 
82     /**
83      * @dev check if an account has this role
84      * @return bool
85      */
86     function has(Role storage role, address account) internal view returns (bool) {
87         require(account != address(0));
88         return role.bearer[account];
89     }
90 }
91 
92 contract HxOwnable {  //중요:자식에서 compile문제로 Ownable -> HxOwnable
93     address public owner;
94     address public newOwner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor() public {
99         owner = msg.sender;
100         newOwner = address(0);
101     }
102 
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     modifier onlyNewOwner() {
108         require(msg.sender != address(0));
109         require(msg.sender == newOwner);
110         _;
111     }
112 
113     function isOwner(address account) public view returns (bool) {
114         if( account == owner ){
115             return true;
116         }
117         else {
118             return false;
119         }
120     }
121 
122     function transferOwnership(address _newOwner) public onlyOwner {
123         require(_newOwner != address(0));
124         newOwner = _newOwner;
125     }
126 
127     function acceptOwnership() public onlyNewOwner returns(bool) {
128         emit OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130         newOwner = address(0);
131     }
132 }
133 
134 contract PauserRole is HxOwnable{
135     using Roles for Roles.Role;
136 
137     event PauserAdded(address indexed account);
138     event PauserRemoved(address indexed account);
139 
140     Roles.Role private _pausers;
141 
142     constructor () internal {
143         _addPauser(msg.sender);
144     }
145 
146     modifier onlyPauser() {
147         require(isPauser(msg.sender)|| isOwner(msg.sender));
148         _;
149     }
150 
151     function isPauser(address account) public view returns (bool) {
152         return _pausers.has(account);
153     }
154 
155     function addPauser(address account) public onlyPauser {
156         _addPauser(account);
157     }
158 
159     function removePauser(address account) public onlyOwner {
160         _removePauser(account);
161     }
162 
163     function renouncePauser() public {
164         _removePauser(msg.sender);
165     }
166 
167     function _addPauser(address account) internal {
168         _pausers.add(account);
169         emit PauserAdded(account);
170     }
171 
172     function _removePauser(address account) internal {
173         _pausers.remove(account);
174         emit PauserRemoved(account);
175     }
176 }
177 
178 contract Pausable is PauserRole {
179     event Paused(address account);
180     event Unpaused(address account);
181 
182     bool private _paused;
183 
184     constructor () internal {
185         _paused = false;
186     }
187 
188     /**
189      * @return true if the contract is paused, false otherwise.
190      */
191     function paused() public view returns (bool) {
192         return _paused;
193     }
194 
195     /**
196      * @dev Modifier to make a function callable only when the contract is not paused.
197      */
198     modifier whenNotPaused() {
199         require(!_paused);
200         _;
201     }
202 
203     /**
204      * @dev Modifier to make a function callable only when the contract is paused.
205      */
206     modifier whenPaused() {
207         require(_paused);
208         _;
209     }
210 
211     /**
212      * @dev called by the owner to pause, triggers stopped state
213      */
214     function pause() public onlyPauser whenNotPaused {
215         _paused = true;
216         emit Paused(msg.sender);
217     }
218 
219     /**
220      * @dev called by the owner to unpause, returns to normal state
221      */
222     function unpause() public onlyPauser whenPaused {
223         _paused = false;
224         emit Unpaused(msg.sender);
225     }
226 }
227 
228 interface IERC20 {
229     function transfer(address to, uint256 value) external returns (bool);
230 
231     function approve(address spender, uint256 value) external returns (bool);
232 
233     function transferFrom(address from, address to, uint256 value) external returns (bool);
234 
235     function totalSupply() external view returns (uint256);
236 
237     function balanceOf(address who) external view returns (uint256);
238 
239     function allowance(address owner, address spender) external view returns (uint256);
240 
241     event Transfer(address indexed from, address indexed to, uint256 value);
242 
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 contract HxERC20 is IERC20 { //중요:자식에서 compile문제로 ERC20 -> HxERC20
247     using HxSafeMath for uint256;
248 
249     mapping (address => uint256) internal _balances;
250 
251     mapping (address => mapping (address => uint256)) internal _allowed;
252 
253     uint256 private _totalSupply;
254 
255     /**
256     * @dev Total number of tokens in existence
257     */
258     function totalSupply() public view returns (uint256) {
259         return _totalSupply;
260     }
261 
262     /**
263     * @dev Gets the balance of the specified address.
264     * @param owner The address to query the balance of.
265     * @return An uint256 representing the amount owned by the passed address.
266     */
267     function balanceOf(address owner) public view returns (uint256) {
268         return _balances[owner];
269     }
270 
271     /**
272      * @dev Function to check the amount of tokens that an owner allowed to a spender.
273      * @param owner address The address which owns the funds.
274      * @param spender address The address which will spend the funds.
275      * @return A uint256 specifying the amount of tokens still available for the spender.
276      */
277     function allowance(address owner, address spender) public view returns (uint256) {
278         return _allowed[owner][spender];
279     }
280 
281     /**
282     * @dev Transfer token for a specified address
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286     function transfer(address to, uint256 value) public returns (bool) {
287         _transfer(msg.sender, to, value);
288         return true;
289     }
290 
291     /**
292      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293      * Beware that changing an allowance with this method brings the risk that someone may use both the old
294      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297      * @param spender The address which will spend the funds.
298      * @param value The amount of tokens to be spent.
299      */
300     function approve(address spender, uint256 value) public returns (bool) {
301         require(spender != address(0));
302 
303         _allowed[msg.sender][spender] = value;
304         emit Approval(msg.sender, spender, value);
305         return true;
306     }
307 
308     /**
309      * @dev Transfer tokens from one address to another.
310      * Note that while this function emits an Approval event, this is not required as per the specification,
311      * and other compliant implementations may not emit the event.
312      * @param from address The address which you want to send tokens from
313      * @param to address The address which you want to transfer to
314      * @param value uint256 the amount of tokens to be transferred
315      */
316     function transferFrom(address from, address to, uint256 value) public returns (bool) {
317         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
318         _transfer(from, to, value);
319         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
320         return true;
321     }
322 
323     /**
324      * @dev Increase the amount of tokens that an owner allowed to a spender.
325      * approve should be called when allowed_[_spender] == 0. To increment
326      * allowed value is better to use this function to avoid 2 calls (and wait until
327      * the first transaction is mined)
328      * From MonolithDAO Token.sol
329      * Emits an Approval event.
330      * @param spender The address which will spend the funds.
331      * @param addedValue The amount of tokens to increase the allowance by.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
334         require(spender != address(0));
335 
336         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
337         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
338         return true;
339     }
340 
341     /**
342      * @dev Decrease the amount of tokens that an owner allowed to a spender.
343      * approve should be called when allowed_[_spender] == 0. To decrement
344      * allowed value is better to use this function to avoid 2 calls (and wait until
345      * the first transaction is mined)
346      * From MonolithDAO Token.sol
347      * Emits an Approval event.
348      * @param spender The address which will spend the funds.
349      * @param subtractedValue The amount of tokens to decrease the allowance by.
350      */
351     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
352         require(spender != address(0));
353 
354         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
355         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
356         return true;
357     }
358 
359     /**
360     * @dev Transfer token for a specified addresses
361     * @param from The address to transfer from.
362     * @param to The address to transfer to.
363     * @param value The amount to be transferred.
364     */
365     function _transfer(address from, address to, uint256 value) internal {
366         require(to != address(0));
367 
368         _balances[from] = _balances[from].sub(value);
369         _balances[to] = _balances[to].add(value);
370         emit Transfer(from, to, value);
371     }
372 
373     /**
374      * @dev Internal function that mints an amount of the token and assigns it to
375      * an account. This encapsulates the modification of balances such that the
376      * proper events are emitted.
377      * @param account The account that will receive the created tokens.
378      * @param value The amount that will be created.
379      */
380     function _mint(address account, uint256 value) internal {
381         require(account != address(0));
382 
383         _totalSupply = _totalSupply.add(value);
384         _balances[account] = _balances[account].add(value);
385         emit Transfer(address(0), account, value);
386     }
387 
388     /**
389      * @dev Internal function that burns an amount of the token of a given
390      * account.
391      * @param account The account whose tokens will be burnt.
392      * @param value The amount that will be burnt.
393      */
394     function _burn(address account, uint256 value) internal {
395         require(account != address(0));
396 
397         _totalSupply = _totalSupply.sub(value);
398         _balances[account] = _balances[account].sub(value);
399         emit Transfer(account, address(0), value);
400     }
401 
402     /**
403      * @dev Internal function that burns an amount of the token of a given
404      * account, deducting from the sender's allowance for said account. Uses the
405      * internal burn function.
406      * Emits an Approval event (reflecting the reduced allowance).
407      * @param account The account whose tokens will be burnt.
408      * @param value The amount that will be burnt.
409      */
410     function _burnFrom(address account, uint256 value) internal {
411         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
412         _burn(account, value);
413         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
414     }
415 }
416 
417 contract ERC20Pausable is HxERC20, Pausable {
418     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
419         return super.transfer(to, value);
420     }
421 
422     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
423         return super.transferFrom(from, to, value);
424     }
425 
426     /*
427      * approve/increaseApprove/decreaseApprove can be set when Paused state
428      */
429 
430     /*
431      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
432      *     return super.approve(spender, value);
433      * }
434      *
435      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
436      *     return super.increaseAllowance(spender, addedValue);
437      * }
438      *
439      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
440      *     return super.decreaseAllowance(spender, subtractedValue);
441      * }
442      */
443 }
444 
445 contract ERC20Detailed is IERC20 {
446     string private _name;
447     string private _symbol;
448     uint8 private _decimals;
449 
450     constructor (string memory name, string memory symbol, uint8 decimals) public {
451         _name = name;
452         _symbol = symbol;
453         _decimals = decimals;
454     }
455 
456     /**
457      * @return the name of the token.
458      */
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @return the symbol of the token.
465      */
466     function symbol() public view returns (string memory) {
467         return _symbol;
468     }
469 
470     /**
471      * @return the number of decimals of the token.
472      */
473     function decimals() public view returns (uint8) {
474         return _decimals;
475     }
476 }
477 
478 contract WITCH is ERC20Detailed, ERC20Pausable {
479 
480     struct LockInfo {
481         uint256 _releaseTime;
482         uint256 _amount;
483     }
484 
485     address public implementation;
486 
487     mapping (address => LockInfo[]) public timelockList;
488     mapping (address => bool) public frozenAccount;
489 
490     event Freeze(address indexed holder);
491     event Unfreeze(address indexed holder);
492     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
493     event Unlock(address indexed holder, uint256 value);
494 
495     modifier notFrozen(address _holder) {
496         require(!frozenAccount[_holder]);
497         _;
498     }
499 
500     constructor() ERC20Detailed("Witch Token", "WITCH", 18) payable public  {
501 
502         _mint(msg.sender, 100000000 * (10 ** 18));
503     }
504 
505     function balanceOf(address owner) public view returns (uint256) {
506 
507         uint256 totalBalance = super.balanceOf(owner);
508         if( timelockList[owner].length >0 ){
509             for(uint i=0; i<timelockList[owner].length;i++){
510                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
511             }
512         }
513 
514         return totalBalance;
515     }
516 
517     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
518         if (timelockList[msg.sender].length > 0 ) {
519             _autoUnlock(msg.sender);
520         }
521         return super.transfer(to, value);
522     }
523 
524     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
525         if (timelockList[from].length > 0) {
526             _autoUnlock(from);
527         }
528         return super.transferFrom(from, to, value);
529     }
530 
531     function freezeAccount(address holder) public onlyPauser returns (bool) {
532         require(!frozenAccount[holder]);
533         frozenAccount[holder] = true;
534         emit Freeze(holder);
535         return true;
536     }
537 
538     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
539         require(frozenAccount[holder]);
540         frozenAccount[holder] = false;
541         emit Unfreeze(holder);
542         return true;
543     }
544 
545     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
546         require(_balances[holder] >= value,"There is not enough balances of holder.");
547         _lock(holder,value,releaseTime);
548 
549 
550         return true;
551     }
552 
553     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
554         _transfer(msg.sender, holder, value);
555         _lock(holder,value,releaseTime);
556         return true;
557     }
558 
559     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
560         require( timelockList[holder].length > idx, "There is not lock info.");
561         _unlock(holder,idx);
562         return true;
563     }
564 
565     /**
566      * @dev Upgrades the implementation address
567      * @param _newImplementation address of the new implementation
568      */
569     function upgradeTo(address _newImplementation) public onlyOwner {
570         require(implementation != _newImplementation);
571         _setImplementation(_newImplementation);
572     }
573 
574     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
575         _balances[holder] = _balances[holder].sub(value);
576         timelockList[holder].push( LockInfo(releaseTime, value) );
577 
578         emit Lock(holder, value, releaseTime);
579         return true;
580     }
581 
582     function _unlock(address holder, uint256 idx) internal returns(bool) {
583         LockInfo storage lockinfo = timelockList[holder][idx];
584         uint256 releaseAmount = lockinfo._amount;
585 
586         delete timelockList[holder][idx];
587         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
588         timelockList[holder].length -=1;
589 
590         emit Unlock(holder, releaseAmount);
591         _balances[holder] = _balances[holder].add(releaseAmount);
592 
593         return true;
594     }
595 
596     function _autoUnlock(address holder) internal returns(bool) {
597         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
598             if (timelockList[holder][idx]._releaseTime <= now) {
599                 // If lockupinfo was deleted, loop restart at same position.
600                 if( _unlock(holder, idx) ) {
601                     idx -=1;
602                 }
603             }
604         }
605         return true;
606     }
607 
608     /**
609      * @dev Sets the address of the current implementation
610      * @param _newImp address of the new implementation
611      */
612     function _setImplementation(address _newImp) internal {
613         implementation = _newImp;
614     }
615 
616     /**
617      * @dev Fallback function allowing to perform a delegatecall
618      * to the given implementation. This function will return
619      * whatever the implementation call returns
620      */
621     function () payable external {
622         address impl = implementation;
623         require(impl != address(0));
624         assembly {
625             let ptr := mload(0x40)
626             calldatacopy(ptr, 0, calldatasize)
627             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
628             let size := returndatasize
629             returndatacopy(ptr, 0, size)
630 
631             switch result
632             case 0 { revert(ptr, size) }
633             default { return(ptr, size) }
634         }
635     }
636 }