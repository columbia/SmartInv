1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-17
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 library SafeMath {
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two unsigned integers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev give an account access to this role
78      */
79     function add(Role storage role, address account) internal {
80         require(account != address(0));
81         require(!has(role, account));
82 
83         role.bearer[account] = true;
84     }
85 
86     /**
87      * @dev remove an account's access to this role
88      */
89     function remove(Role storage role, address account) internal {
90         require(account != address(0));
91         require(has(role, account));
92 
93         role.bearer[account] = false;
94     }
95 
96     /**
97      * @dev check if an account has this role
98      * @return bool
99      */
100     function has(Role storage role, address account) internal view returns (bool) {
101         require(account != address(0));
102         return role.bearer[account];
103     }
104 }
105 
106 contract Ownable {
107     address public owner;
108     address public newOwner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     constructor() public {
113         owner = msg.sender;
114         newOwner = address(0);
115     }
116 
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121     modifier onlyNewOwner() {
122         require(msg.sender != address(0));
123         require(msg.sender == newOwner);
124         _;
125     }
126     
127     function isOwner(address account) public view returns (bool) {
128         if( account == owner ){
129             return true;
130         }
131         else {
132             return false;
133         }
134     }
135 
136     function transferOwnership(address _newOwner) public onlyOwner {
137         require(_newOwner != address(0));
138         newOwner = _newOwner;
139     }
140 
141     function acceptOwnership() public onlyNewOwner returns(bool) {
142         emit OwnershipTransferred(owner, newOwner);        
143         owner = newOwner;
144         newOwner = address(0);
145     }
146 }
147 
148 contract PauserRole is Ownable{
149     using Roles for Roles.Role;
150 
151     event PauserAdded(address indexed account);
152     event PauserRemoved(address indexed account);
153 
154     Roles.Role private _pausers;
155 
156     constructor () internal {
157         _addPauser(msg.sender);
158     }
159 
160     modifier onlyPauser() {
161         require(isPauser(msg.sender)|| isOwner(msg.sender));
162         _;
163     }
164 
165     function isPauser(address account) public view returns (bool) {
166         return _pausers.has(account);
167     }
168 
169     function addPauser(address account) public onlyPauser {
170         _addPauser(account);
171     }
172     
173     function removePauser(address account) public onlyOwner {
174         _removePauser(account);
175     }
176 
177     function renouncePauser() public {
178         _removePauser(msg.sender);
179     }
180 
181     function _addPauser(address account) internal {
182         _pausers.add(account);
183         emit PauserAdded(account);
184     }
185 
186     function _removePauser(address account) internal {
187         _pausers.remove(account);
188         emit PauserRemoved(account);
189     }
190 }
191 
192 contract Pausable is PauserRole {
193     event Paused(address account);
194     event Unpaused(address account);
195 
196     bool private _paused;
197 
198     constructor () internal {
199         _paused = false;
200     }
201 
202     /**
203      * @return true if the contract is paused, false otherwise.
204      */
205     function paused() public view returns (bool) {
206         return _paused;
207     }
208 
209     /**
210      * @dev Modifier to make a function callable only when the contract is not paused.
211      */
212     modifier whenNotPaused() {
213         require(!_paused);
214         _;
215     }
216 
217     /**
218      * @dev Modifier to make a function callable only when the contract is paused.
219      */
220     modifier whenPaused() {
221         require(_paused);
222         _;
223     }
224 
225     /**
226      * @dev called by the owner to pause, triggers stopped state
227      */
228     function pause() public onlyPauser whenNotPaused {
229         _paused = true;
230         emit Paused(msg.sender);
231     }
232 
233     /**
234      * @dev called by the owner to unpause, returns to normal state
235      */
236     function unpause() public onlyPauser whenPaused {
237         _paused = false;
238         emit Unpaused(msg.sender);
239     }
240 }
241 
242 interface IERC20 {
243     function transfer(address to, uint256 value) external returns (bool);
244 
245     function approve(address spender, uint256 value) external returns (bool);
246 
247     function transferFrom(address from, address to, uint256 value) external returns (bool);
248 
249     function totalSupply() external view returns (uint256);
250 
251     function balanceOf(address who) external view returns (uint256);
252 
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 contract ERC20 is IERC20 {
261     using SafeMath for uint256;
262 
263     mapping (address => uint256) internal _balances;
264 
265     mapping (address => mapping (address => uint256)) internal _allowed;
266 
267     uint256 private _totalSupply;
268 
269     /**
270     * @dev Total number of tokens in existence
271     */
272     function totalSupply() public view returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277     * @dev Gets the balance of the specified address.
278     * @param owner The address to query the balance of.
279     * @return An uint256 representing the amount owned by the passed address.
280     */
281     function balanceOf(address owner) public view returns (uint256) {
282         return _balances[owner];
283     }
284 
285     /**
286      * @dev Function to check the amount of tokens that an owner allowed to a spender.
287      * @param owner address The address which owns the funds.
288      * @param spender address The address which will spend the funds.
289      * @return A uint256 specifying the amount of tokens still available for the spender.
290      */
291     function allowance(address owner, address spender) public view returns (uint256) {
292         return _allowed[owner][spender];
293     }
294 
295     /**
296     * @dev Transfer token for a specified address
297     * @param to The address to transfer to.
298     * @param value The amount to be transferred.
299     */
300     function transfer(address to, uint256 value) public returns (bool) {
301         _transfer(msg.sender, to, value);
302         return true;
303     }
304 
305     /**
306      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
307      * Beware that changing an allowance with this method brings the risk that someone may use both the old
308      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      * @param spender The address which will spend the funds.
312      * @param value The amount of tokens to be spent.
313      */
314     function approve(address spender, uint256 value) public returns (bool) {
315         require(spender != address(0));
316 
317         _allowed[msg.sender][spender] = value;
318         emit Approval(msg.sender, spender, value);
319         return true;
320     }
321 
322     /**
323      * @dev Transfer tokens from one address to another.
324      * Note that while this function emits an Approval event, this is not required as per the specification,
325      * and other compliant implementations may not emit the event.
326      * @param from address The address which you want to send tokens from
327      * @param to address The address which you want to transfer to
328      * @param value uint256 the amount of tokens to be transferred
329      */
330     function transferFrom(address from, address to, uint256 value) public returns (bool) {
331         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
332         _transfer(from, to, value);
333         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
334         return true;
335     }
336 
337     /**
338      * @dev Increase the amount of tokens that an owner allowed to a spender.
339      * approve should be called when allowed_[_spender] == 0. To increment
340      * allowed value is better to use this function to avoid 2 calls (and wait until
341      * the first transaction is mined)
342      * From MonolithDAO Token.sol
343      * Emits an Approval event.
344      * @param spender The address which will spend the funds.
345      * @param addedValue The amount of tokens to increase the allowance by.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
348         require(spender != address(0));
349 
350         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
351         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
352         return true;
353     }
354 
355     /**
356      * @dev Decrease the amount of tokens that an owner allowed to a spender.
357      * approve should be called when allowed_[_spender] == 0. To decrement
358      * allowed value is better to use this function to avoid 2 calls (and wait until
359      * the first transaction is mined)
360      * From MonolithDAO Token.sol
361      * Emits an Approval event.
362      * @param spender The address which will spend the funds.
363      * @param subtractedValue The amount of tokens to decrease the allowance by.
364      */
365     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
366         require(spender != address(0));
367 
368         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
369         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
370         return true;
371     }
372 
373     /**
374     * @dev Transfer token for a specified addresses
375     * @param from The address to transfer from.
376     * @param to The address to transfer to.
377     * @param value The amount to be transferred.
378     */
379     function _transfer(address from, address to, uint256 value) internal {
380         require(to != address(0));
381 
382         _balances[from] = _balances[from].sub(value);
383         _balances[to] = _balances[to].add(value);
384         emit Transfer(from, to, value);
385     }
386 
387     /**
388      * @dev Internal function that mints an amount of the token and assigns it to
389      * an account. This encapsulates the modification of balances such that the
390      * proper events are emitted.
391      * @param account The account that will receive the created tokens.
392      * @param value The amount that will be created.
393      */
394     function _mint(address account, uint256 value) internal {
395         require(account != address(0));
396 
397         _totalSupply = _totalSupply.add(value);
398         _balances[account] = _balances[account].add(value);
399         emit Transfer(address(0), account, value);
400     }
401 
402     /**
403      * @dev Internal function that burns an amount of the token of a given
404      * account.
405      * @param account The account whose tokens will be burnt.
406      * @param value The amount that will be burnt.
407      */
408     function _burn(address account, uint256 value) internal {
409         require(account != address(0));
410 
411         _totalSupply = _totalSupply.sub(value);
412         _balances[account] = _balances[account].sub(value);
413         emit Transfer(account, address(0), value);
414     }
415 
416     /**
417      * @dev Internal function that burns an amount of the token of a given
418      * account, deducting from the sender's allowance for said account. Uses the
419      * internal burn function.
420      * Emits an Approval event (reflecting the reduced allowance).
421      * @param account The account whose tokens will be burnt.
422      * @param value The amount that will be burnt.
423      */
424     function _burnFrom(address account, uint256 value) internal {
425         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
426         _burn(account, value);
427         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
428     }
429 }
430 
431 
432 
433 contract ERC20Pausable is ERC20, Pausable {
434     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
435         return super.transfer(to, value);
436     }
437 
438     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
439         return super.transferFrom(from, to, value);
440     }
441     
442     /*
443      * approve/increaseApprove/decreaseApprove can be set when Paused state
444      */
445      
446     /*
447      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
448      *     return super.approve(spender, value);
449      * }
450      *
451      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
452      *     return super.increaseAllowance(spender, addedValue);
453      * }
454      *
455      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
456      *     return super.decreaseAllowance(spender, subtractedValue);
457      * }
458      */
459 }
460 
461 contract ERC20Detailed is IERC20 {
462     string private _name;
463     string private _symbol;
464     uint8 private _decimals;
465 
466     constructor (string memory name, string memory symbol, uint8 decimals) public {
467         _name = name;
468         _symbol = symbol;
469         _decimals = decimals;
470     }
471 
472     /**
473      * @return the name of the token.
474      */
475     function name() public view returns (string memory) {
476         return _name;
477     }
478 
479     /**
480      * @return the symbol of the token.
481      */
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     /**
487      * @return the number of decimals of the token.
488      */
489     function decimals() public view returns (uint8) {
490         return _decimals;
491     }
492 }
493 
494 contract NEWTON is ERC20Detailed, ERC20Pausable {
495     
496     struct LockInfo {
497         uint256 _releaseTime;
498         uint256 _amount;
499     }
500     
501     address public implementation;
502 
503     mapping (address => LockInfo[]) public timelockList;
504 	mapping (address => bool) public frozenAccount;
505     
506     event Freeze(address indexed holder);
507     event Unfreeze(address indexed holder);
508     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
509     event Unlock(address indexed holder, uint256 value);
510 
511     modifier notFrozen(address _holder) {
512         require(!frozenAccount[_holder]);
513         _;
514     }
515     
516     constructor() ERC20Detailed("ONBUFF INNO Newton Token", "NEWTON",18) public  {
517         
518         _mint(msg.sender, 1000000000 * (10 ** 18));
519     }
520     
521     function balanceOf(address owner) public view returns (uint256) {
522         
523         uint256 totalBalance = super.balanceOf(owner);
524         if( timelockList[owner].length >0 ){
525             for(uint i=0; i<timelockList[owner].length;i++){
526                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
527             }
528         }
529         
530         return totalBalance;
531     }
532     
533     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
534         if (timelockList[msg.sender].length > 0 ) {
535             _autoUnlock(msg.sender);            
536         }
537         return super.transfer(to, value);
538     }
539 
540     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
541         if (timelockList[from].length > 0) {
542             _autoUnlock(from);            
543         }
544         return super.transferFrom(from, to, value);
545     }
546     
547     function freezeAccount(address holder) public onlyPauser returns (bool) {
548         require(!frozenAccount[holder]);
549         frozenAccount[holder] = true;
550         emit Freeze(holder);
551         return true;
552     }
553 
554     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
555         require(frozenAccount[holder]);
556         frozenAccount[holder] = false;
557         emit Unfreeze(holder);
558         return true;
559     }
560     
561     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
562         require(_balances[holder] >= value,"There is not enough balances of holder.");
563         _lock(holder,value,releaseTime);
564         
565         
566         return true;
567     }
568     
569     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
570         _transfer(msg.sender, holder, value);
571         _lock(holder,value,releaseTime);
572         return true;
573     }
574     
575     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
576         require( timelockList[holder].length > idx, "There is not lock info.");
577         _unlock(holder,idx);
578         return true;
579     }
580     
581     /**
582      * @dev Upgrades the implementation address
583      * @param _newImplementation address of the new implementation
584      */
585     function upgradeTo(address _newImplementation) public onlyOwner {
586         require(implementation != _newImplementation);
587         _setImplementation(_newImplementation);
588     }
589     
590     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
591         _balances[holder] = _balances[holder].sub(value);
592         timelockList[holder].push( LockInfo(releaseTime, value) );
593         
594         emit Lock(holder, value, releaseTime);
595         return true;
596     }
597     
598     function _unlock(address holder, uint256 idx) internal returns(bool) {
599         LockInfo storage lockinfo = timelockList[holder][idx];
600         uint256 releaseAmount = lockinfo._amount;
601 
602         delete timelockList[holder][idx];
603         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
604         timelockList[holder].length -=1;
605         
606         emit Unlock(holder, releaseAmount);
607         _balances[holder] = _balances[holder].add(releaseAmount);
608         
609         return true;
610     }
611     
612     function _autoUnlock(address holder) internal returns(bool) {
613         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
614             if (timelockList[holder][idx]._releaseTime <= now) {
615                 // If lockupinfo was deleted, loop restart at same position.
616                 if( _unlock(holder, idx) ) {
617                     idx -=1;
618                 }
619             }
620         }
621         return true;
622     }
623 
624     function mint(uint256 value) public onlyOwner returns(bool) {
625         _mint(msg.sender, value);
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