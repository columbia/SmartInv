1 pragma solidity ^0.5.0;
2 
3 // File: contracts/NIA.sol
4 
5 library SafeMath {
6     /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46     * @dev Adds two unsigned integers, reverts on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57     * reverts when dividing by zero.
58     */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 library Roles {
66     struct Role {
67         mapping (address => bool) bearer;
68     }
69 
70     /**
71      * @dev give an account access to this role
72      */
73     function add(Role storage role, address account) internal {
74         require(account != address(0));
75         require(!has(role, account));
76 
77         role.bearer[account] = true;
78     }
79 
80     /**
81      * @dev remove an account's access to this role
82      */
83     function remove(Role storage role, address account) internal {
84         require(account != address(0));
85         require(has(role, account));
86 
87         role.bearer[account] = false;
88     }
89 
90     /**
91      * @dev check if an account has this role
92      * @return bool
93      */
94     function has(Role storage role, address account) internal view returns (bool) {
95         require(account != address(0));
96         return role.bearer[account];
97     }
98 }
99 
100 contract Ownable {
101     address public owner;
102     address public newOwner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor() public {
107         owner = msg.sender;
108         newOwner = address(0);
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115     modifier onlyNewOwner() {
116         require(msg.sender != address(0));
117         require(msg.sender == newOwner);
118         _;
119     }
120     
121     function isOwner(address account) public view returns (bool) {
122         if( account == owner ){
123             return true;
124         }
125         else {
126             return false;
127         }
128     }
129 
130     function transferOwnership(address _newOwner) public onlyOwner {
131         require(_newOwner != address(0));
132         newOwner = _newOwner;
133     }
134 
135     function acceptOwnership() public onlyNewOwner returns(bool) {
136         emit OwnershipTransferred(owner, newOwner);        
137         owner = newOwner;
138         newOwner = address(0);
139     }
140 }
141 
142 contract MinterRole is Ownable{
143     using Roles for Roles.Role;
144 
145     event MinterAdded(address indexed account);
146     event MinterRemoved(address indexed account);
147 
148     Roles.Role private _minters;
149 
150     constructor () internal {
151         _addMinter(msg.sender);
152     }
153 
154     modifier onlyMinter() {
155         require(isMinter(msg.sender) || isOwner(msg.sender));
156         _;
157     }
158 
159     function isMinter(address account) public view returns (bool) {
160         return _minters.has(account);
161     }
162 
163     function addMinter(address account) public onlyMinter {
164         _addMinter(account);
165     }
166     
167     function removeMinter(address account) public onlyOwner {
168         _removeMinter(account);
169     }
170 
171     function renounceMinter() public {
172         _removeMinter(msg.sender);
173     }
174 
175     function _addMinter(address account) internal {
176         _minters.add(account);
177         emit MinterAdded(account);
178     }
179 
180     function _removeMinter(address account) internal {
181         _minters.remove(account);
182         emit MinterRemoved(account);
183     }
184 }
185 
186 contract PauserRole is Ownable{
187     using Roles for Roles.Role;
188 
189     event PauserAdded(address indexed account);
190     event PauserRemoved(address indexed account);
191 
192     Roles.Role private _pausers;
193 
194     constructor () internal {
195         _addPauser(msg.sender);
196     }
197 
198     modifier onlyPauser() {
199         require(isPauser(msg.sender)|| isOwner(msg.sender));
200         _;
201     }
202 
203     function isPauser(address account) public view returns (bool) {
204         return _pausers.has(account);
205     }
206 
207     function addPauser(address account) public onlyPauser {
208         _addPauser(account);
209     }
210     
211     function removePauser(address account) public onlyOwner {
212         _removePauser(account);
213     }
214 
215     function renouncePauser() public {
216         _removePauser(msg.sender);
217     }
218 
219     function _addPauser(address account) internal {
220         _pausers.add(account);
221         emit PauserAdded(account);
222     }
223 
224     function _removePauser(address account) internal {
225         _pausers.remove(account);
226         emit PauserRemoved(account);
227     }
228 }
229 
230 
231 contract Pausable is PauserRole {
232     event Paused(address account);
233     event Unpaused(address account);
234 
235     bool private _paused;
236 
237     constructor () internal {
238         _paused = false;
239     }
240 
241     /**
242      * @return true if the contract is paused, false otherwise.
243      */
244     function paused() public view returns (bool) {
245         return _paused;
246     }
247 
248     /**
249      * @dev Modifier to make a function callable only when the contract is not paused.
250      */
251     modifier whenNotPaused() {
252         require(!_paused);
253         _;
254     }
255 
256     /**
257      * @dev Modifier to make a function callable only when the contract is paused.
258      */
259     modifier whenPaused() {
260         require(_paused);
261         _;
262     }
263 
264     /**
265      * @dev called by the owner to pause, triggers stopped state
266      */
267     function pause() public onlyPauser whenNotPaused {
268         _paused = true;
269         emit Paused(msg.sender);
270     }
271 
272     /**
273      * @dev called by the owner to unpause, returns to normal state
274      */
275     function unpause() public onlyPauser whenPaused {
276         _paused = false;
277         emit Unpaused(msg.sender);
278     }
279 }
280 
281 interface IERC20 {
282     function transfer(address to, uint256 value) external returns (bool);
283 
284     function approve(address spender, uint256 value) external returns (bool);
285 
286     function transferFrom(address from, address to, uint256 value) external returns (bool);
287 
288     function totalSupply() external view returns (uint256);
289 
290     function balanceOf(address who) external view returns (uint256);
291 
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     event Transfer(address indexed from, address indexed to, uint256 value);
295 
296     event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 contract ERC20 is IERC20 {
300     using SafeMath for uint256;
301 
302     mapping (address => uint256) internal _balances;
303 
304     mapping (address => mapping (address => uint256)) internal _allowed;
305 
306     uint256 private _totalSupply;
307 
308     /**
309     * @dev Total number of tokens in existence
310     */
311     function totalSupply() public view returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316     * @dev Gets the balance of the specified address.
317     * @param owner The address to query the balance of.
318     * @return An uint256 representing the amount owned by the passed address.
319     */
320     function balanceOf(address owner) public view returns (uint256) {
321         return _balances[owner];
322     }
323 
324     /**
325      * @dev Function to check the amount of tokens that an owner allowed to a spender.
326      * @param owner address The address which owns the funds.
327      * @param spender address The address which will spend the funds.
328      * @return A uint256 specifying the amount of tokens still available for the spender.
329      */
330     function allowance(address owner, address spender) public view returns (uint256) {
331         return _allowed[owner][spender];
332     }
333 
334     /**
335     * @dev Transfer token for a specified address
336     * @param to The address to transfer to.
337     * @param value The amount to be transferred.
338     */
339     function transfer(address to, uint256 value) public returns (bool) {
340         _transfer(msg.sender, to, value);
341         return true;
342     }
343 
344     /**
345      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
346      * Beware that changing an allowance with this method brings the risk that someone may use both the old
347      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
348      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
349      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350      * @param spender The address which will spend the funds.
351      * @param value The amount of tokens to be spent.
352      */
353     function approve(address spender, uint256 value) public returns (bool) {
354         require(spender != address(0));
355 
356         _allowed[msg.sender][spender] = value;
357         emit Approval(msg.sender, spender, value);
358         return true;
359     }
360 
361     /**
362      * @dev Transfer tokens from one address to another.
363      * Note that while this function emits an Approval event, this is not required as per the specification,
364      * and other compliant implementations may not emit the event.
365      * @param from address The address which you want to send tokens from
366      * @param to address The address which you want to transfer to
367      * @param value uint256 the amount of tokens to be transferred
368      */
369     function transferFrom(address from, address to, uint256 value) public returns (bool) {
370         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
371         _transfer(from, to, value);
372         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
373         return true;
374     }
375 
376     /**
377      * @dev Increase the amount of tokens that an owner allowed to a spender.
378      * approve should be called when allowed_[_spender] == 0. To increment
379      * allowed value is better to use this function to avoid 2 calls (and wait until
380      * the first transaction is mined)
381      * From MonolithDAO Token.sol
382      * Emits an Approval event.
383      * @param spender The address which will spend the funds.
384      * @param addedValue The amount of tokens to increase the allowance by.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
387         require(spender != address(0));
388 
389         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
390         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
391         return true;
392     }
393 
394     /**
395      * @dev Decrease the amount of tokens that an owner allowed to a spender.
396      * approve should be called when allowed_[_spender] == 0. To decrement
397      * allowed value is better to use this function to avoid 2 calls (and wait until
398      * the first transaction is mined)
399      * From MonolithDAO Token.sol
400      * Emits an Approval event.
401      * @param spender The address which will spend the funds.
402      * @param subtractedValue The amount of tokens to decrease the allowance by.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         require(spender != address(0));
406 
407         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
408         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
409         return true;
410     }
411 
412     /**
413     * @dev Transfer token for a specified addresses
414     * @param from The address to transfer from.
415     * @param to The address to transfer to.
416     * @param value The amount to be transferred.
417     */
418     function _transfer(address from, address to, uint256 value) internal {
419         require(to != address(0));
420 
421         _balances[from] = _balances[from].sub(value);
422         _balances[to] = _balances[to].add(value);
423         emit Transfer(from, to, value);
424     }
425 
426     /**
427      * @dev Internal function that mints an amount of the token and assigns it to
428      * an account. This encapsulates the modification of balances such that the
429      * proper events are emitted.
430      * @param account The account that will receive the created tokens.
431      * @param value The amount that will be created.
432      */
433     function _mint(address account, uint256 value) internal {
434         require(account != address(0));
435 
436         _totalSupply = _totalSupply.add(value);
437         _balances[account] = _balances[account].add(value);
438         emit Transfer(address(0), account, value);
439     }
440 
441     /**
442      * @dev Internal function that burns an amount of the token of a given
443      * account.
444      * @param account The account whose tokens will be burnt.
445      * @param value The amount that will be burnt.
446      */
447     function _burn(address account, uint256 value) internal {
448         require(account != address(0));
449 
450         _totalSupply = _totalSupply.sub(value);
451         _balances[account] = _balances[account].sub(value);
452         emit Transfer(account, address(0), value);
453     }
454 
455     /**
456      * @dev Internal function that burns an amount of the token of a given
457      * account, deducting from the sender's allowance for said account. Uses the
458      * internal burn function.
459      * Emits an Approval event (reflecting the reduced allowance).
460      * @param account The account whose tokens will be burnt.
461      * @param value The amount that will be burnt.
462      */
463     function _burnFrom(address account, uint256 value) internal {
464         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
465         _burn(account, value);
466         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
467     }
468 }
469 
470 contract ERC20Mintable is ERC20, MinterRole {
471     /**
472      * @dev Function to mint tokens
473      * @param to The address that will receive the minted tokens.
474      * @param value The amount of tokens to mint.
475      * @return A boolean that indicates if the operation was successful.
476      */
477     function mint(address to, uint256 value) public onlyMinter returns (bool) {
478         _mint(to, value);
479         return true;
480     }
481 }
482 
483 contract ERC20Capped is ERC20Mintable {
484     uint256 internal _cap;
485 
486     constructor (uint256 cap) public {
487         require(cap > 0);
488         _cap = cap;
489     }
490 
491     /**
492      * @return the cap for the token minting.
493      */
494     function cap() public view returns (uint256) {
495         return _cap;
496     }
497 
498     function _mint(address account, uint256 value) internal {
499         require(totalSupply().add(value) <= _cap);
500         super._mint(account, value);
501     }
502 }
503 
504 contract ERC20Burnable is ERC20 {
505     /**
506      * @dev Burns a specific amount of tokens.
507      * @param value The amount of token to be burned.
508      */
509     function burn(uint256 value) public {
510         _burn(msg.sender, value);
511     }
512 
513     /**
514      * @dev Burns a specific amount of tokens from the target address and decrements allowance
515      * @param from address The address which you want to send tokens from
516      * @param value uint256 The amount of token to be burned
517      */
518     function burnFrom(address from, uint256 value) public {
519         _burnFrom(from, value);
520     }
521 }
522 
523 contract ERC20Pausable is ERC20, Pausable {
524     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
525         return super.transfer(to, value);
526     }
527 
528     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
529         return super.transferFrom(from, to, value);
530     }
531 
532     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
533         return super.approve(spender, value);
534     }
535 
536     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
537         return super.increaseAllowance(spender, addedValue);
538     }
539 
540     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
541         return super.decreaseAllowance(spender, subtractedValue);
542     }
543 }
544 
545 contract ERC20Detailed is IERC20 {
546     string private _name;
547     string private _symbol;
548     uint8 private _decimals;
549 
550     constructor (string memory name, string memory symbol, uint8 decimals) public {
551         _name = name;
552         _symbol = symbol;
553         _decimals = decimals;
554     }
555 
556     /**
557      * @return the name of the token.
558      */
559     function name() public view returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @return the symbol of the token.
565      */
566     function symbol() public view returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @return the number of decimals of the token.
572      */
573     function decimals() public view returns (uint8) {
574         return _decimals;
575     }
576 }
577 
578 contract NIA is ERC20Detailed, ERC20Pausable, ERC20Capped, ERC20Burnable {
579     
580     struct LockInfo {
581         uint256 _releaseTime;
582         uint256 _amount;
583     }
584     
585     address public implementation;
586 
587     mapping (address => LockInfo[]) public timelockList;
588     mapping (address => bool) public frozenAccount;
589     
590     event Freeze(address indexed holder);
591     event Unfreeze(address indexed holder);
592     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
593     event Unlock(address indexed holder, uint256 value);
594 
595     modifier notFrozen(address _holder) {
596         require(!frozenAccount[_holder]);
597         _;
598     }
599     
600     constructor() ERC20Detailed("NIAToken", "NIA", 18) ERC20Capped(800000000 * 10 ** 18) public  {
601         
602         _mint(msg.sender, 320000000 * (10 ** 18));
603     }
604     
605     function balanceOf(address owner) public view returns (uint256) {
606         
607         uint256 totalBalance = super.balanceOf(owner);
608         if( timelockList[owner].length >0 ){
609             for(uint i=0; i<timelockList[owner].length;i++){
610                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
611             }
612         }
613         
614         return totalBalance;
615     }
616     
617     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
618         if (timelockList[msg.sender].length > 0 ) {
619             _autoUnlock(msg.sender);            
620         }
621         return super.transfer(to, value);
622     }
623 
624     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
625         if (timelockList[from].length > 0) {
626             _autoUnlock(msg.sender);            
627         }
628         return super.transferFrom(from, to, value);
629     }
630     
631     function freezeAccount(address holder) public onlyPauser returns (bool) {
632         require(!frozenAccount[holder]);
633         frozenAccount[holder] = true;
634         emit Freeze(holder);
635         return true;
636     }
637 
638     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
639         require(frozenAccount[holder]);
640         frozenAccount[holder] = false;
641         emit Unfreeze(holder);
642         return true;
643     }
644     
645     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
646         require(_balances[holder] >= value,"There is not enough balances of holder.");
647         _lock(holder,value,releaseTime);
648         
649         
650         return true;
651     }
652     
653     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
654         _transfer(msg.sender, holder, value);
655         _lock(holder,value,releaseTime);
656         return true;
657     }
658     
659     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
660         require( timelockList[holder].length > idx, "There is not lock info.");
661         _unlock(holder,idx);
662         return true;
663     }
664     
665     /**
666      * @dev Upgrades the implementation address
667      * @param _newImplementation address of the new implementation
668      */
669     function upgradeTo(address _newImplementation) public onlyOwner {
670         require(implementation != _newImplementation);
671         _setImplementation(_newImplementation);
672     }
673     
674     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
675         _balances[holder] = _balances[holder].sub(value);
676         timelockList[holder].push( LockInfo(releaseTime, value) );
677         
678         emit Lock(holder, value, releaseTime);
679         return true;
680     }
681     
682     function _unlock(address holder, uint256 idx) internal returns(bool) {
683         LockInfo storage lockinfo = timelockList[holder][idx];
684         uint256 releaseAmount = lockinfo._amount;
685 
686         delete timelockList[holder][idx];
687         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
688         timelockList[holder].length -=1;
689         
690         emit Unlock(holder, releaseAmount);
691         _balances[holder] = _balances[holder].add(releaseAmount);
692         
693         return true;
694     }
695     
696     function _autoUnlock(address holder) internal returns(bool) {
697         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
698             if (timelockList[holder][idx]._releaseTime <= now) {
699                 // If lockupinfo was deleted, loop restart at same position.
700                 if( _unlock(holder, idx) ) {
701                     idx -=1;
702                 }
703             }
704         }
705         return true;
706     }
707     
708     /**
709      * @dev Sets the address of the current implementation
710      * @param _newImp address of the new implementation
711      */
712     function _setImplementation(address _newImp) internal {
713         implementation = _newImp;
714     }
715     
716     /**
717      * @dev Fallback function allowing to perform a delegatecall 
718      * to the given implementation. This function will return 
719      * whatever the implementation call returns
720      */
721     function () payable external {
722         address impl = implementation;
723         require(impl != address(0));
724         assembly {
725             let ptr := mload(0x40)
726             calldatacopy(ptr, 0, calldatasize)
727             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
728             let size := returndatasize
729             returndatacopy(ptr, 0, size)
730             
731             switch result
732             case 0 { revert(ptr, size) }
733             default { return(ptr, size) }
734         }
735     }
736 }