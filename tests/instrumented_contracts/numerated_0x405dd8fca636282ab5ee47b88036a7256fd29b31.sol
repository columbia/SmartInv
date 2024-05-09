1 library SafeMath {
2     /**
3     * @dev Multiplies two unsigned integers, reverts on overflow.
4     */
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
7         // benefit is lost if 'b' is also tested.
8         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9         if (a == 0) {
10             return 0;
11         }
12 
13         uint256 c = a * b;
14         require(c / a == b);
15 
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // Solidity only automatically asserts when dividing by 0
24         require(b > 0);
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a);
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41     /**
42     * @dev Adds two unsigned integers, reverts on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
53     * reverts when dividing by zero.
54     */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0);
57         return a % b;
58     }
59 }
60 
61 library Roles {
62     struct Role {
63         mapping (address => bool) bearer;
64     }
65 
66     /**
67      * @dev give an account access to this role
68      */
69     function add(Role storage role, address account) internal {
70         require(account != address(0));
71         require(!has(role, account));
72 
73         role.bearer[account] = true;
74     }
75 
76     /**
77      * @dev remove an account's access to this role
78      */
79     function remove(Role storage role, address account) internal {
80         require(account != address(0));
81         require(has(role, account));
82 
83         role.bearer[account] = false;
84     }
85 
86     /**
87      * @dev check if an account has this role
88      * @return bool
89      */
90     function has(Role storage role, address account) internal view returns (bool) {
91         require(account != address(0));
92         return role.bearer[account];
93     }
94 }
95 
96 contract Ownable {
97     address public owner;
98     address public newOwner;
99 
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor() public {
103         owner = msg.sender;
104         newOwner = address(0);
105     }
106 
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111     modifier onlyNewOwner() {
112         require(msg.sender != address(0));
113         require(msg.sender == newOwner);
114         _;
115     }
116     
117     function isOwner(address account) public view returns (bool) {
118         if( account == owner ){
119             return true;
120         }
121         else {
122             return false;
123         }
124     }
125 
126     function transferOwnership(address _newOwner) public onlyOwner {
127         require(_newOwner != address(0));
128         newOwner = _newOwner;
129     }
130 
131     function acceptOwnership() public onlyNewOwner returns(bool) {
132         emit OwnershipTransferred(owner, newOwner);        
133         owner = newOwner;
134         newOwner = address(0);
135     }
136 }
137 
138 
139 
140 contract PauserRole is Ownable{
141     using Roles for Roles.Role;
142 
143     event PauserAdded(address indexed account);
144     event PauserRemoved(address indexed account);
145 
146     Roles.Role private _pausers;
147 
148     constructor () internal {
149         _addPauser(msg.sender);
150     }
151 
152     modifier onlyPauser() {
153         require(isPauser(msg.sender)|| isOwner(msg.sender));
154         _;
155     }
156 
157     function isPauser(address account) public view returns (bool) {
158         return _pausers.has(account);
159     }
160 
161     function addPauser(address account) public onlyPauser {
162         _addPauser(account);
163     }
164     
165     function removePauser(address account) public onlyOwner {
166         _removePauser(account);
167     }
168 
169     function renouncePauser() public {
170         _removePauser(msg.sender);
171     }
172 
173     function _addPauser(address account) internal {
174         _pausers.add(account);
175         emit PauserAdded(account);
176     }
177 
178     function _removePauser(address account) internal {
179         _pausers.remove(account);
180         emit PauserRemoved(account);
181     }
182 }
183 
184 
185 contract Pausable is PauserRole {
186     event Paused(address account);
187     event Unpaused(address account);
188 
189     bool private _paused;
190 
191     constructor () internal {
192         _paused = false;
193     }
194 
195     /**
196      * @return true if the contract is paused, false otherwise.
197      */
198     function paused() public view returns (bool) {
199         return _paused;
200     }
201 
202     /**
203      * @dev Modifier to make a function callable only when the contract is not paused.
204      */
205     modifier whenNotPaused() {
206         require(!_paused);
207         _;
208     }
209 
210     /**
211      * @dev Modifier to make a function callable only when the contract is paused.
212      */
213     modifier whenPaused() {
214         require(_paused);
215         _;
216     }
217 
218     /**
219      * @dev called by the owner to pause, triggers stopped state
220      */
221     function pause() public onlyPauser whenNotPaused {
222         _paused = true;
223         emit Paused(msg.sender);
224     }
225 
226     /**
227      * @dev called by the owner to unpause, returns to normal state
228      */
229     function unpause() public onlyPauser whenPaused {
230         _paused = false;
231         emit Unpaused(msg.sender);
232     }
233 }
234 
235 interface IERC20 {
236     function transfer(address to, uint256 value) external returns (bool);
237 
238     function approve(address spender, uint256 value) external returns (bool);
239 
240     function transferFrom(address from, address to, uint256 value) external returns (bool);
241 
242     function totalSupply() external view returns (uint256);
243 
244     function balanceOf(address who) external view returns (uint256);
245 
246     function allowance(address owner, address spender) external view returns (uint256);
247 
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 contract ERC20 is IERC20 {
254     using SafeMath for uint256;
255 
256     mapping (address => uint256) internal _balances;
257 
258     mapping (address => mapping (address => uint256)) internal _allowed;
259 
260     uint256 private _totalSupply;
261 
262     /**
263     * @dev Total number of tokens in existence
264     */
265     function totalSupply() public view returns (uint256) {
266         return _totalSupply;
267     }
268 
269     /**
270     * @dev Gets the balance of the specified address.
271     * @param owner The address to query the balance of.
272     * @return An uint256 representing the amount owned by the passed address.
273     */
274     function balanceOf(address owner) public view returns (uint256) {
275         return _balances[owner];
276     }
277 
278     /**
279      * @dev Function to check the amount of tokens that an owner allowed to a spender.
280      * @param owner address The address which owns the funds.
281      * @param spender address The address which will spend the funds.
282      * @return A uint256 specifying the amount of tokens still available for the spender.
283      */
284     function allowance(address owner, address spender) public view returns (uint256) {
285         return _allowed[owner][spender];
286     }
287 
288     /**
289     * @dev Transfer token for a specified address
290     * @param to The address to transfer to.
291     * @param value The amount to be transferred.
292     */
293     function transfer(address to, uint256 value) public returns (bool) {
294         _transfer(msg.sender, to, value);
295         return true;
296     }
297 
298     /**
299      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
300      * Beware that changing an allowance with this method brings the risk that someone may use both the old
301      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
302      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      * @param spender The address which will spend the funds.
305      * @param value The amount of tokens to be spent.
306      */
307     function approve(address spender, uint256 value) public returns (bool) {
308         require(spender != address(0));
309 
310         _allowed[msg.sender][spender] = value;
311         emit Approval(msg.sender, spender, value);
312         return true;
313     }
314 
315     /**
316      * @dev Transfer tokens from one address to another.
317      * Note that while this function emits an Approval event, this is not required as per the specification,
318      * and other compliant implementations may not emit the event.
319      * @param from address The address which you want to send tokens from
320      * @param to address The address which you want to transfer to
321      * @param value uint256 the amount of tokens to be transferred
322      */
323     function transferFrom(address from, address to, uint256 value) public returns (bool) {
324         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
325         _transfer(from, to, value);
326         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
327         return true;
328     }
329 
330     /**
331      * @dev Increase the amount of tokens that an owner allowed to a spender.
332      * approve should be called when allowed_[_spender] == 0. To increment
333      * allowed value is better to use this function to avoid 2 calls (and wait until
334      * the first transaction is mined)
335      * From MonolithDAO Token.sol
336      * Emits an Approval event.
337      * @param spender The address which will spend the funds.
338      * @param addedValue The amount of tokens to increase the allowance by.
339      */
340     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
341         require(spender != address(0));
342 
343         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
344         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
345         return true;
346     }
347 
348     /**
349      * @dev Decrease the amount of tokens that an owner allowed to a spender.
350      * approve should be called when allowed_[_spender] == 0. To decrement
351      * allowed value is better to use this function to avoid 2 calls (and wait until
352      * the first transaction is mined)
353      * From MonolithDAO Token.sol
354      * Emits an Approval event.
355      * @param spender The address which will spend the funds.
356      * @param subtractedValue The amount of tokens to decrease the allowance by.
357      */
358     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
359         require(spender != address(0));
360 
361         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
362         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
363         return true;
364     }
365 
366     /**
367     * @dev Transfer token for a specified addresses
368     * @param from The address to transfer from.
369     * @param to The address to transfer to.
370     * @param value The amount to be transferred.
371     */
372     function _transfer(address from, address to, uint256 value) internal {
373         require(to != address(0));
374 
375         _balances[from] = _balances[from].sub(value);
376         _balances[to] = _balances[to].add(value);
377         emit Transfer(from, to, value);
378     }
379 
380     /**
381      * @dev Internal function that mints an amount of the token and assigns it to
382      * an account. This encapsulates the modification of balances such that the
383      * proper events are emitted.
384      * @param account The account that will receive the created tokens.
385      * @param value The amount that will be created.
386      */
387     function _mint(address account, uint256 value) internal {
388         require(account != address(0));
389 
390         _totalSupply = _totalSupply.add(value);
391         _balances[account] = _balances[account].add(value);
392         emit Transfer(address(0), account, value);
393     }
394 
395     /**
396      * @dev Internal function that burns an amount of the token of a given
397      * account.
398      * @param account The account whose tokens will be burnt.
399      * @param value The amount that will be burnt.
400      */
401     function _burn(address account, uint256 value) internal {
402         require(account != address(0));
403 
404         _totalSupply = _totalSupply.sub(value);
405         _balances[account] = _balances[account].sub(value);
406         emit Transfer(account, address(0), value);
407     }
408 
409     /**
410      * @dev Internal function that burns an amount of the token of a given
411      * account, deducting from the sender's allowance for said account. Uses the
412      * internal burn function.
413      * Emits an Approval event (reflecting the reduced allowance).
414      * @param account The account whose tokens will be burnt.
415      * @param value The amount that will be burnt.
416      */
417     function _burnFrom(address account, uint256 value) internal {
418         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
419         _burn(account, value);
420         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
421     }
422 }
423 
424 
425 contract ERC20Burnable is ERC20 {
426     /**
427      * @dev Burns a specific amount of tokens.
428      * @param value The amount of token to be burned.
429      */
430     function burn(uint256 value) public {
431         _burn(msg.sender, value);
432     }
433 
434     /**
435      * @dev Burns a specific amount of tokens from the target address and decrements allowance
436      * @param from address The address which you want to send tokens from
437      * @param value uint256 The amount of token to be burned
438      */
439     function burnFrom(address from, uint256 value) public {
440         _burnFrom(from, value);
441     }
442 }
443 
444 contract ERC20Pausable is ERC20, Pausable {
445     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
446         return super.transfer(to, value);
447     }
448 
449     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
450         return super.transferFrom(from, to, value);
451     }
452 
453     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
454         return super.approve(spender, value);
455     }
456 
457     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
458         return super.increaseAllowance(spender, addedValue);
459     }
460 
461     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
462         return super.decreaseAllowance(spender, subtractedValue);
463     }
464 }
465 
466 contract ERC20Detailed is IERC20 {
467     string private _name;
468     string private _symbol;
469     uint8 private _decimals;
470 
471     constructor (string memory name, string memory symbol, uint8 decimals) public {
472         _name = name;
473         _symbol = symbol;
474         _decimals = decimals;
475     }
476 
477     /**
478      * @return the name of the token.
479      */
480     function name() public view returns (string memory) {
481         return _name;
482     }
483 
484     /**
485      * @return the symbol of the token.
486      */
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     /**
492      * @return the number of decimals of the token.
493      */
494     function decimals() public view returns (uint8) {
495         return _decimals;
496     }
497 }
498 
499 contract NDIO is ERC20Detailed, ERC20Pausable, ERC20Burnable {
500     
501     struct LockInfo {
502         uint256 _releaseTime;
503         uint256 _amount;
504     }
505     
506     address public implementation;
507 
508     mapping (address => LockInfo[]) public timelockList;
509 	mapping (address => bool) public frozenAccount;
510     
511     event Freeze(address indexed holder);
512     event Unfreeze(address indexed holder);
513     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
514     event Unlock(address indexed holder, uint256 value);
515 
516     modifier notFrozen(address _holder) {
517         require(!frozenAccount[_holder]);
518         _;
519     }
520     
521     constructor() ERC20Detailed("NDIO", "NDIO", 18) public  {
522         
523         _mint(msg.sender, 1250000000 * (10 ** 18));
524     }
525     
526     function balanceOf(address owner) public view returns (uint256) {
527         
528         uint256 totalBalance = super.balanceOf(owner);
529         if( timelockList[owner].length >0 ){
530             for(uint i=0; i<timelockList[owner].length;i++){
531                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
532             }
533         }
534         
535         return totalBalance;
536     }
537     
538     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
539         if (timelockList[msg.sender].length > 0 ) {
540             _autoUnlock(msg.sender);            
541         }
542         return super.transfer(to, value);
543     }
544 
545     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
546         if (timelockList[from].length > 0) {
547             _autoUnlock(msg.sender);            
548         }
549         return super.transferFrom(from, to, value);
550     }
551     
552     function freezeAccount(address holder) public onlyPauser returns (bool) {
553         require(!frozenAccount[holder]);
554         frozenAccount[holder] = true;
555         emit Freeze(holder);
556         return true;
557     }
558 
559     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
560         require(frozenAccount[holder]);
561         frozenAccount[holder] = false;
562         emit Unfreeze(holder);
563         return true;
564     }
565     
566     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
567         require(_balances[holder] >= value,"There is not enough balances of holder.");
568         _lock(holder,value,releaseTime);
569         
570         
571         return true;
572     }
573     
574     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
575         _transfer(msg.sender, holder, value);
576         _lock(holder,value,releaseTime);
577         return true;
578     }
579     
580     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
581         require( timelockList[holder].length > idx, "There is not lock info.");
582         _unlock(holder,idx);
583         return true;
584     }
585     
586     /**
587      * @dev Upgrades the implementation address
588      * @param _newImplementation address of the new implementation
589      */
590     function upgradeTo(address _newImplementation) public onlyOwner {
591         require(implementation != _newImplementation);
592         _setImplementation(_newImplementation);
593     }
594     
595     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
596         _balances[holder] = _balances[holder].sub(value);
597         timelockList[holder].push( LockInfo(releaseTime, value) );
598         
599         emit Lock(holder, value, releaseTime);
600         return true;
601     }
602     
603     function _unlock(address holder, uint256 idx) internal returns(bool) {
604         LockInfo storage lockinfo = timelockList[holder][idx];
605         uint256 releaseAmount = lockinfo._amount;
606 
607         delete timelockList[holder][idx];
608         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
609         timelockList[holder].length -=1;
610         
611         emit Unlock(holder, releaseAmount);
612         _balances[holder] = _balances[holder].add(releaseAmount);
613         
614         return true;
615     }
616     
617     function _autoUnlock(address holder) internal returns(bool) {
618         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
619             if (timelockList[holder][idx]._releaseTime <= now) {
620                 // If lockupinfo was deleted, loop restart at same position.
621                 if( _unlock(holder, idx) ) {
622                     idx -=1;
623                 }
624             }
625         }
626         return true;
627     }
628     
629     /**
630      * @dev Sets the address of the current implementation
631      * @param _newImp address of the new implementation
632      */
633     function _setImplementation(address _newImp) internal {
634         implementation = _newImp;
635     }
636     
637     /**
638      * @dev Fallback function allowing to perform a delegatecall 
639      * to the given implementation. This function will return 
640      * whatever the implementation call returns
641      */
642     function () payable external {
643         address impl = implementation;
644         require(impl != address(0));
645         assembly {
646             let ptr := mload(0x40)
647             calldatacopy(ptr, 0, calldatasize)
648             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
649             let size := returndatasize
650             returndatacopy(ptr, 0, size)
651             
652             switch result
653             case 0 { revert(ptr, size) }
654             default { return(ptr, size) }
655         }
656     }
657 }