1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 library Roles {
64     struct Role {
65         mapping (address => bool) bearer;
66     }
67 
68     /**
69      * @dev give an account access to this role
70      */
71     function add(Role storage role, address account) internal {
72         require(account != address(0));
73         require(!has(role, account));
74 
75         role.bearer[account] = true;
76     }
77 
78     /**
79      * @dev remove an account's access to this role
80      */
81     function remove(Role storage role, address account) internal {
82         require(account != address(0));
83         require(has(role, account));
84 
85         role.bearer[account] = false;
86     }
87 
88     /**
89      * @dev check if an account has this role
90      * @return bool
91      */
92     function has(Role storage role, address account) internal view returns (bool) {
93         require(account != address(0));
94         return role.bearer[account];
95     }
96 }
97 
98 contract Ownable {
99     address public owner;
100     address public newOwner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     constructor() public {
105         owner = msg.sender;
106         newOwner = address(0);
107     }
108 
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113     modifier onlyNewOwner() {
114         require(msg.sender != address(0));
115         require(msg.sender == newOwner);
116         _;
117     }
118     
119     function isOwner(address account) public view returns (bool) {
120         if( account == owner ){
121             return true;
122         }
123         else {
124             return false;
125         }
126     }
127 
128     function transferOwnership(address _newOwner) public onlyOwner {
129         require(_newOwner != address(0));
130         newOwner = _newOwner;
131     }
132 
133     function acceptOwnership() public onlyNewOwner returns(bool) {
134         emit OwnershipTransferred(owner, newOwner);        
135         owner = newOwner;
136         newOwner = address(0);
137     }
138 }
139 
140 
141 
142 contract PauserRole is Ownable{
143     using Roles for Roles.Role;
144 
145     event PauserAdded(address indexed account);
146     event PauserRemoved(address indexed account);
147 
148     Roles.Role private _pausers;
149 
150     constructor () internal {
151         _addPauser(msg.sender);
152     }
153 
154     modifier onlyPauser() {
155         require(isPauser(msg.sender)|| isOwner(msg.sender));
156         _;
157     }
158 
159     function isPauser(address account) public view returns (bool) {
160         return _pausers.has(account);
161     }
162 
163     function addPauser(address account) public onlyPauser {
164         _addPauser(account);
165     }
166     
167     function removePauser(address account) public onlyOwner {
168         _removePauser(account);
169     }
170 
171     function renouncePauser() public {
172         _removePauser(msg.sender);
173     }
174 
175     function _addPauser(address account) internal {
176         _pausers.add(account);
177         emit PauserAdded(account);
178     }
179 
180     function _removePauser(address account) internal {
181         _pausers.remove(account);
182         emit PauserRemoved(account);
183     }
184 }
185 
186 
187 contract Pausable is PauserRole {
188     event Paused(address account);
189     event Unpaused(address account);
190 
191     bool private _paused;
192 
193     constructor () internal {
194         _paused = false;
195     }
196 
197     /**
198      * @return true if the contract is paused, false otherwise.
199      */
200     function paused() public view returns (bool) {
201         return _paused;
202     }
203 
204     /**
205      * @dev Modifier to make a function callable only when the contract is not paused.
206      */
207     modifier whenNotPaused() {
208         require(!_paused);
209         _;
210     }
211 
212     /**
213      * @dev Modifier to make a function callable only when the contract is paused.
214      */
215     modifier whenPaused() {
216         require(_paused);
217         _;
218     }
219 
220     /**
221      * @dev called by the owner to pause, triggers stopped state
222      */
223     function pause() public onlyPauser whenNotPaused {
224         _paused = true;
225         emit Paused(msg.sender);
226     }
227 
228     /**
229      * @dev called by the owner to unpause, returns to normal state
230      */
231     function unpause() public onlyPauser whenPaused {
232         _paused = false;
233         emit Unpaused(msg.sender);
234     }
235 }
236 
237 interface IERC20 {
238     function transfer(address to, uint256 value) external returns (bool);
239 
240     function approve(address spender, uint256 value) external returns (bool);
241 
242     function transferFrom(address from, address to, uint256 value) external returns (bool);
243 
244     function totalSupply() external view returns (uint256);
245 
246     function balanceOf(address who) external view returns (uint256);
247 
248     function allowance(address owner, address spender) external view returns (uint256);
249 
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     event Approval(address indexed owner, address indexed spender, uint256 value);
253 }
254 
255 contract ERC20 is IERC20 {
256     using SafeMath for uint256;
257 
258     mapping (address => uint256) internal _balances;
259 
260     mapping (address => mapping (address => uint256)) internal _allowed;
261 
262     uint256 private _totalSupply;
263 
264     /**
265     * @dev Total number of tokens in existence
266     */
267     function totalSupply() public view returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272     * @dev Gets the balance of the specified address.
273     * @param owner The address to query the balance of.
274     * @return An uint256 representing the amount owned by the passed address.
275     */
276     function balanceOf(address owner) public view returns (uint256) {
277         return _balances[owner];
278     }
279 
280     /**
281      * @dev Function to check the amount of tokens that an owner allowed to a spender.
282      * @param owner address The address which owns the funds.
283      * @param spender address The address which will spend the funds.
284      * @return A uint256 specifying the amount of tokens still available for the spender.
285      */
286     function allowance(address owner, address spender) public view returns (uint256) {
287         return _allowed[owner][spender];
288     }
289 
290     /**
291     * @dev Transfer token for a specified address
292     * @param to The address to transfer to.
293     * @param value The amount to be transferred.
294     */
295     function transfer(address to, uint256 value) public returns (bool) {
296         _transfer(msg.sender, to, value);
297         return true;
298     }
299 
300     /**
301      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
302      * Beware that changing an allowance with this method brings the risk that someone may use both the old
303      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
304      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306      * @param spender The address which will spend the funds.
307      * @param value The amount of tokens to be spent.
308      */
309     function approve(address spender, uint256 value) public returns (bool) {
310         require(spender != address(0));
311 
312         _allowed[msg.sender][spender] = value;
313         emit Approval(msg.sender, spender, value);
314         return true;
315     }
316 
317     /**
318      * @dev Transfer tokens from one address to another.
319      * Note that while this function emits an Approval event, this is not required as per the specification,
320      * and other compliant implementations may not emit the event.
321      * @param from address The address which you want to send tokens from
322      * @param to address The address which you want to transfer to
323      * @param value uint256 the amount of tokens to be transferred
324      */
325     function transferFrom(address from, address to, uint256 value) public returns (bool) {
326         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
327         _transfer(from, to, value);
328         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
329         return true;
330     }
331 
332     /**
333      * @dev Increase the amount of tokens that an owner allowed to a spender.
334      * approve should be called when allowed_[_spender] == 0. To increment
335      * allowed value is better to use this function to avoid 2 calls (and wait until
336      * the first transaction is mined)
337      * From MonolithDAO Token.sol
338      * Emits an Approval event.
339      * @param spender The address which will spend the funds.
340      * @param addedValue The amount of tokens to increase the allowance by.
341      */
342     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
343         require(spender != address(0));
344 
345         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
346         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
347         return true;
348     }
349 
350     /**
351      * @dev Decrease the amount of tokens that an owner allowed to a spender.
352      * approve should be called when allowed_[_spender] == 0. To decrement
353      * allowed value is better to use this function to avoid 2 calls (and wait until
354      * the first transaction is mined)
355      * From MonolithDAO Token.sol
356      * Emits an Approval event.
357      * @param spender The address which will spend the funds.
358      * @param subtractedValue The amount of tokens to decrease the allowance by.
359      */
360     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
361         require(spender != address(0));
362 
363         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
364         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
365         return true;
366     }
367 
368     /**
369     * @dev Transfer token for a specified addresses
370     * @param from The address to transfer from.
371     * @param to The address to transfer to.
372     * @param value The amount to be transferred.
373     */
374     function _transfer(address from, address to, uint256 value) internal {
375         require(to != address(0));
376 
377         _balances[from] = _balances[from].sub(value);
378         _balances[to] = _balances[to].add(value);
379         emit Transfer(from, to, value);
380     }
381 
382     /**
383      * @dev Internal function that mints an amount of the token and assigns it to
384      * an account. This encapsulates the modification of balances such that the
385      * proper events are emitted.
386      * @param account The account that will receive the created tokens.
387      * @param value The amount that will be created.
388      */
389     function _mint(address account, uint256 value) internal {
390         require(account != address(0));
391 
392         _totalSupply = _totalSupply.add(value);
393         _balances[account] = _balances[account].add(value);
394         emit Transfer(address(0), account, value);
395     }
396 
397     /**
398      * @dev Internal function that burns an amount of the token of a given
399      * account.
400      * @param account The account whose tokens will be burnt.
401      * @param value The amount that will be burnt.
402      */
403     function _burn(address account, uint256 value) internal {
404         require(account != address(0));
405 
406         _totalSupply = _totalSupply.sub(value);
407         _balances[account] = _balances[account].sub(value);
408         emit Transfer(account, address(0), value);
409     }
410 
411     /**
412      * @dev Internal function that burns an amount of the token of a given
413      * account, deducting from the sender's allowance for said account. Uses the
414      * internal burn function.
415      * Emits an Approval event (reflecting the reduced allowance).
416      * @param account The account whose tokens will be burnt.
417      * @param value The amount that will be burnt.
418      */
419     function _burnFrom(address account, uint256 value) internal {
420         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
421         _burn(account, value);
422         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
423     }
424 }
425 
426 
427 
428 contract ERC20Pausable is ERC20, Pausable {
429     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
430         return super.transfer(to, value);
431     }
432 
433     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
434         return super.transferFrom(from, to, value);
435     }
436     
437     /*
438      * approve/increaseApprove/decreaseApprove can be set when Paused state
439      */
440      
441     /*
442      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
443      *     return super.approve(spender, value);
444      * }
445      *
446      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
447      *     return super.increaseAllowance(spender, addedValue);
448      * }
449      *
450      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
451      *     return super.decreaseAllowance(spender, subtractedValue);
452      * }
453      */
454 }
455 
456 contract ERC20Detailed is IERC20 {
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460 
461     constructor (string memory name, string memory symbol, uint8 decimals) public {
462         _name = name;
463         _symbol = symbol;
464         _decimals = decimals;
465     }
466 
467     /**
468      * @return the name of the token.
469      */
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     /**
475      * @return the symbol of the token.
476      */
477     function symbol() public view returns (string memory) {
478         return _symbol;
479     }
480 
481     /**
482      * @return the number of decimals of the token.
483      */
484     function decimals() public view returns (uint8) {
485         return _decimals;
486     }
487 }
488 
489 contract MinterRole is Ownable{
490     using Roles for Roles.Role;
491 
492     event MinterAdded(address indexed account);
493     event MinterRemoved(address indexed account);
494 
495     Roles.Role private _minters;
496 
497     constructor () internal {
498         _addMinter(msg.sender);
499     }
500 
501     modifier onlyMinter() {
502         require(isMinter(msg.sender) || isOwner(msg.sender));
503         _;
504     }
505 
506     function isMinter(address account) public view returns (bool) {
507         return _minters.has(account);
508     }
509 
510     function addMinter(address account) public onlyMinter {
511         _addMinter(account);
512     }
513     
514     function removeMinter(address account) public onlyOwner {
515         _removeMinter(account);
516     }
517 
518     function renounceMinter() public {
519         _removeMinter(msg.sender);
520     }
521 
522     function _addMinter(address account) internal {
523         _minters.add(account);
524         emit MinterAdded(account);
525     }
526 
527     function _removeMinter(address account) internal {
528         _minters.remove(account);
529         emit MinterRemoved(account);
530     }
531 }
532 
533 contract ERC20Mintable is ERC20, MinterRole {
534     /**
535      * @dev Function to mint tokens
536      * @param to The address that will receive the minted tokens.
537      * @param value The amount of tokens to mint.
538      * @return A boolean that indicates if the operation was successful.
539      */
540     function mint(address to, uint256 value) public onlyMinter returns (bool) {
541         _mint(to, value);
542         return true;
543     }
544 }
545 
546 contract ERC20Capped is ERC20Mintable {
547     uint256 internal _cap;
548 
549     constructor (uint256 cap) public {
550         require(cap > 0);
551         _cap = cap;
552     }
553 
554     /**
555      * @return the cap for the token minting.
556      */
557     function cap() public view returns (uint256) {
558         return _cap;
559     }
560 
561     function _mint(address account, uint256 value) internal {
562         require(totalSupply().add(value) <= _cap);
563         super._mint(account, value);
564     }
565 }
566 
567 contract ERC20Burnable is ERC20 {
568     /**
569      * @dev Burns a specific amount of tokens.
570      * @param value The amount of token to be burned.
571      */
572     function burn(uint256 value) public {
573         _burn(msg.sender, value);
574     }
575 
576     /**
577      * @dev Burns a specific amount of tokens from the target address and decrements allowance
578      * @param from address The address which you want to send tokens from
579      * @param value uint256 The amount of token to be burned
580      */
581     function burnFrom(address from, uint256 value) public {
582         _burnFrom(from, value);
583     }
584 }
585 
586 contract BSC is ERC20Detailed, ERC20Pausable {
587     
588     struct LockInfo {
589         uint256 _releaseTime;
590         uint256 _amount;
591     }
592     
593     address public implementation;
594 
595     mapping (address => LockInfo[]) public timelockList;
596     mapping (address => bool) public frozenAccount;
597     
598     event Freeze(address indexed holder);
599     event Unfreeze(address indexed holder);
600     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
601     event Unlock(address indexed holder, uint256 value);
602 
603     modifier notFrozen(address _holder) {
604         require(!frozenAccount[_holder]);
605         _;
606     }
607     
608     constructor() ERC20Detailed("BSC", "BSC", 18) public  {
609         
610         _mint(msg.sender, 1000000000 * (10 ** 18));
611     }
612     
613     /*
614     constructor() ERC20Detailed("", "", 0) public  {
615     }
616     */
617     
618     
619     function balanceOf(address owner) public view returns (uint256) {
620         
621         uint256 totalBalance = super.balanceOf(owner);
622         if( timelockList[owner].length >0 ){
623             for(uint i=0; i<timelockList[owner].length;i++){
624                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
625             }
626         }
627         
628         return totalBalance;
629     }
630     
631     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
632         if (timelockList[msg.sender].length > 0 ) {
633             _autoUnlock(msg.sender);            
634         }
635         return super.transfer(to, value);
636     }
637 
638     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
639         if (timelockList[from].length > 0) {
640             _autoUnlock(from);            
641         }
642         return super.transferFrom(from, to, value);
643     }
644     
645     function freezeAccount(address holder) public onlyPauser returns (bool) {
646         require(!frozenAccount[holder]);
647         frozenAccount[holder] = true;
648         emit Freeze(holder);
649         return true;
650     }
651 
652     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
653         require(frozenAccount[holder]);
654         frozenAccount[holder] = false;
655         emit Unfreeze(holder);
656         return true;
657     }
658     
659     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
660         require(_balances[holder] >= value,"There is not enough balances of holder.");
661         _lock(holder,value,releaseTime);
662         
663         
664         return true;
665     }
666     
667     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
668         _transfer(msg.sender, holder, value);
669         _lock(holder,value,releaseTime);
670         return true;
671     }
672     
673     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
674         require( timelockList[holder].length > idx, "There is not lock info.");
675         _unlock(holder,idx);
676         return true;
677     }
678     
679     /**
680      * @dev Upgrades the implementation address
681      * @param _newImplementation address of the new implementation
682      */
683     function upgradeTo(address _newImplementation) public onlyOwner {
684         require(implementation != _newImplementation);
685         _setImplementation(_newImplementation);
686     }
687     
688     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
689         _balances[holder] = _balances[holder].sub(value);
690         timelockList[holder].push( LockInfo(releaseTime, value) );
691         
692         emit Lock(holder, value, releaseTime);
693         return true;
694     }
695     
696     function _unlock(address holder, uint256 idx) internal returns(bool) {
697         LockInfo storage lockinfo = timelockList[holder][idx];
698         uint256 releaseAmount = lockinfo._amount;
699 
700         delete timelockList[holder][idx];
701         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
702         timelockList[holder].length -=1;
703         
704         emit Unlock(holder, releaseAmount);
705         _balances[holder] = _balances[holder].add(releaseAmount);
706         
707         return true;
708     }
709     
710     function _autoUnlock(address holder) internal returns(bool) {
711         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
712             if (timelockList[holder][idx]._releaseTime <= now) {
713                 // If lockupinfo was deleted, loop restart at same position.
714                 if( _unlock(holder, idx) ) {
715                     idx -=1;
716                 }
717             }
718         }
719         return true;
720     }
721     
722     /**
723      * @dev Sets the address of the current implementation
724      * @param _newImp address of the new implementation
725      */
726     function _setImplementation(address _newImp) internal {
727         implementation = _newImp;
728     }
729     
730     /**
731      * @dev Fallback function allowing to perform a delegatecall 
732      * to the given implementation. This function will return 
733      * whatever the implementation call returns
734      */
735     function () payable external {
736         address impl = implementation;
737         require(impl != address(0));
738         assembly {
739             let ptr := mload(0x40)
740             calldatacopy(ptr, 0, calldatasize)
741             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
742             let size := returndatasize
743             returndatacopy(ptr, 0, size)
744             
745             switch result
746             case 0 { revert(ptr, size) }
747             default { return(ptr, size) }
748         }
749     }
750 }
751 
752 contract BSCimplementation is BSC, ERC20Burnable{
753     function claimToken(ERC20 token, address to, uint256 value ) public onlyOwner returns(bool){
754         token.transfer(to, value);
755         return true;
756     }
757 }