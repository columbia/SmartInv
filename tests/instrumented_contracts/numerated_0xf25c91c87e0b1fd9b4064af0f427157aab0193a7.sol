1 pragma solidity ^0.5.0;
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
424 contract ERC20Burnable is ERC20 {
425     /**
426      * @dev Burns a specific amount of tokens.
427      * @param value The amount of token to be burned.
428      */
429     function burn(uint256 value) public {
430         _burn(msg.sender, value);
431     }
432 
433     /**
434      * @dev Burns a specific amount of tokens from the target address and decrements allowance
435      * @param from address The address which you want to send tokens from
436      * @param value uint256 The amount of token to be burned
437      */
438     function burnFrom(address from, uint256 value) public {
439         _burnFrom(from, value);
440     }
441 }
442 
443 contract ERC20Pausable is ERC20, Pausable {
444     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
445         return super.transfer(to, value);
446     }
447 
448     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
449         return super.transferFrom(from, to, value);
450     }
451 
452     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
453         return super.approve(spender, value);
454     }
455 
456     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
457         return super.increaseAllowance(spender, addedValue);
458     }
459 
460     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
461         return super.decreaseAllowance(spender, subtractedValue);
462     }
463 }
464 
465 contract ERC20Detailed is IERC20 {
466     string private _name;
467     string private _symbol;
468     uint8 private _decimals;
469 
470     constructor (string memory name, string memory symbol, uint8 decimals) public {
471         _name = name;
472         _symbol = symbol;
473         _decimals = decimals;
474     }
475 
476     /**
477      * @return the name of the token.
478      */
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     /**
484      * @return the symbol of the token.
485      */
486     function symbol() public view returns (string memory) {
487         return _symbol;
488     }
489 
490     /**
491      * @return the number of decimals of the token.
492      */
493     function decimals() public view returns (uint8) {
494         return _decimals;
495     }
496 }
497 
498 contract BASIC is ERC20Detailed, ERC20Pausable, ERC20Burnable {
499     
500     struct LockInfo {
501         uint256 _releaseTime;
502         uint256 _amount;
503     }
504     
505     address public implementation;
506 
507     mapping (address => LockInfo[]) public timelockList;
508 	mapping (address => bool) public frozenAccount;
509     
510     event Freeze(address indexed holder);
511     event Unfreeze(address indexed holder);
512     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
513     event Unlock(address indexed holder, uint256 value);
514 
515     modifier notFrozen(address _holder) {
516         require(!frozenAccount[_holder]);
517         _;
518     }
519     
520     constructor() ERC20Detailed("BASIC Token", "BASIC", 18) public  {
521         
522         _mint(msg.sender, 10000000000 * (10 ** 18));
523     }
524     
525     function balanceOf(address owner) public view returns (uint256) {
526         
527         uint256 totalBalance = super.balanceOf(owner);
528         if( timelockList[owner].length >0 ){
529             for(uint i=0; i<timelockList[owner].length;i++){
530                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
531             }
532         }
533         
534         return totalBalance;
535     }
536     
537     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
538         if (timelockList[msg.sender].length > 0 ) {
539             _autoUnlock(msg.sender);            
540         }
541         return super.transfer(to, value);
542     }
543 
544     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
545         if (timelockList[from].length > 0) {
546             _autoUnlock(msg.sender);            
547         }
548         return super.transferFrom(from, to, value);
549     }
550     
551     function freezeAccount(address holder) public onlyPauser returns (bool) {
552         require(!frozenAccount[holder]);
553         frozenAccount[holder] = true;
554         emit Freeze(holder);
555         return true;
556     }
557 
558     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
559         require(frozenAccount[holder]);
560         frozenAccount[holder] = false;
561         emit Unfreeze(holder);
562         return true;
563     }
564     
565     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
566         require(_balances[holder] >= value,"There is not enough balances of holder.");
567         _lock(holder,value,releaseTime);
568         
569         
570         return true;
571     }
572     
573     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
574         _transfer(msg.sender, holder, value);
575         _lock(holder,value,releaseTime);
576         return true;
577     }
578     
579     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
580         require( timelockList[holder].length > idx, "There is not lock info.");
581         _unlock(holder,idx);
582         return true;
583     }
584     
585     /**
586      * @dev Upgrades the implementation address
587      * @param _newImplementation address of the new implementation
588      */
589     function upgradeTo(address _newImplementation) public onlyOwner {
590         require(implementation != _newImplementation);
591         _setImplementation(_newImplementation);
592     }
593     
594     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
595         _balances[holder] = _balances[holder].sub(value);
596         timelockList[holder].push( LockInfo(releaseTime, value) );
597         
598         emit Lock(holder, value, releaseTime);
599         return true;
600     }
601     
602     function _unlock(address holder, uint256 idx) internal returns(bool) {
603         LockInfo storage lockinfo = timelockList[holder][idx];
604         uint256 releaseAmount = lockinfo._amount;
605 
606         delete timelockList[holder][idx];
607         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
608         timelockList[holder].length -=1;
609         
610         emit Unlock(holder, releaseAmount);
611         _balances[holder] = _balances[holder].add(releaseAmount);
612         
613         return true;
614     }
615     
616     function _autoUnlock(address holder) internal returns(bool) {
617         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
618             if (timelockList[holder][idx]._releaseTime <= now) {
619                 // If lockupinfo was deleted, loop restart at same position.
620                 if( _unlock(holder, idx) ) {
621                     idx -=1;
622                 }
623             }
624         }
625         return true;
626     }
627     
628     /**
629      * @dev Sets the address of the current implementation
630      * @param _newImp address of the new implementation
631      */
632     function _setImplementation(address _newImp) internal {
633         implementation = _newImp;
634     }
635     
636     /**
637      * @dev Fallback function allowing to perform a delegatecall 
638      * to the given implementation. This function will return 
639      * whatever the implementation call returns
640      */
641     function () payable external {
642         address impl = implementation;
643         require(impl != address(0));
644         assembly {
645             let ptr := mload(0x40)
646             calldatacopy(ptr, 0, calldatasize)
647             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
648             let size := returndatasize
649             returndatacopy(ptr, 0, size)
650             
651             switch result
652             case 0 { revert(ptr, size) }
653             default { return(ptr, size) }
654         }
655     }
656 }