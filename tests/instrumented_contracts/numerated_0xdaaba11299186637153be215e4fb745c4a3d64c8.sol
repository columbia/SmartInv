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
184 contract Pausable is PauserRole {
185     event Paused(address account);
186     event Unpaused(address account);
187 
188     bool private _paused;
189 
190     constructor () internal {
191         _paused = false;
192     }
193 
194     /**
195      * @return true if the contract is paused, false otherwise.
196      */
197     function paused() public view returns (bool) {
198         return _paused;
199     }
200 
201     /**
202      * @dev Modifier to make a function callable only when the contract is not paused.
203      */
204     modifier whenNotPaused() {
205         require(!_paused);
206         _;
207     }
208 
209     /**
210      * @dev Modifier to make a function callable only when the contract is paused.
211      */
212     modifier whenPaused() {
213         require(_paused);
214         _;
215     }
216 
217     /**
218      * @dev called by the owner to pause, triggers stopped state
219      */
220     function pause() public onlyPauser whenNotPaused {
221         _paused = true;
222         emit Paused(msg.sender);
223     }
224 
225     /**
226      * @dev called by the owner to unpause, returns to normal state
227      */
228     function unpause() public onlyPauser whenPaused {
229         _paused = false;
230         emit Unpaused(msg.sender);
231     }
232 }
233 
234 interface IERC20 {
235     function transfer(address to, uint256 value) external returns (bool);
236 
237     function approve(address spender, uint256 value) external returns (bool);
238 
239     function transferFrom(address from, address to, uint256 value) external returns (bool);
240 
241     function totalSupply() external view returns (uint256);
242 
243     function balanceOf(address who) external view returns (uint256);
244 
245     function allowance(address owner, address spender) external view returns (uint256);
246 
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 
249     event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 contract ERC20 is IERC20 {
253     using SafeMath for uint256;
254 
255     mapping (address => uint256) internal _balances;
256 
257     mapping (address => mapping (address => uint256)) internal _allowed;
258 
259     uint256 private _totalSupply;
260 
261     /**
262     * @dev Total number of tokens in existence
263     */
264     function totalSupply() public view returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269     * @dev Gets the balance of the specified address.
270     * @param owner The address to query the balance of.
271     * @return An uint256 representing the amount owned by the passed address.
272     */
273     function balanceOf(address owner) public view returns (uint256) {
274         return _balances[owner];
275     }
276 
277     /**
278      * @dev Function to check the amount of tokens that an owner allowed to a spender.
279      * @param owner address The address which owns the funds.
280      * @param spender address The address which will spend the funds.
281      * @return A uint256 specifying the amount of tokens still available for the spender.
282      */
283     function allowance(address owner, address spender) public view returns (uint256) {
284         return _allowed[owner][spender];
285     }
286 
287     /**
288     * @dev Transfer token for a specified address
289     * @param to The address to transfer to.
290     * @param value The amount to be transferred.
291     */
292     function transfer(address to, uint256 value) public returns (bool) {
293         _transfer(msg.sender, to, value);
294         return true;
295     }
296 
297     /**
298      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
299      * Beware that changing an allowance with this method brings the risk that someone may use both the old
300      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
301      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
302      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303      * @param spender The address which will spend the funds.
304      * @param value The amount of tokens to be spent.
305      */
306     function approve(address spender, uint256 value) public returns (bool) {
307         require(spender != address(0));
308 
309         _allowed[msg.sender][spender] = value;
310         emit Approval(msg.sender, spender, value);
311         return true;
312     }
313 
314     /**
315      * @dev Transfer tokens from one address to another.
316      * Note that while this function emits an Approval event, this is not required as per the specification,
317      * and other compliant implementations may not emit the event.
318      * @param from address The address which you want to send tokens from
319      * @param to address The address which you want to transfer to
320      * @param value uint256 the amount of tokens to be transferred
321      */
322     function transferFrom(address from, address to, uint256 value) public returns (bool) {
323         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
324         _transfer(from, to, value);
325         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
326         return true;
327     }
328 
329     /**
330      * @dev Increase the amount of tokens that an owner allowed to a spender.
331      * approve should be called when allowed_[_spender] == 0. To increment
332      * allowed value is better to use this function to avoid 2 calls (and wait until
333      * the first transaction is mined)
334      * From MonolithDAO Token.sol
335      * Emits an Approval event.
336      * @param spender The address which will spend the funds.
337      * @param addedValue The amount of tokens to increase the allowance by.
338      */
339     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
340         require(spender != address(0));
341 
342         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
343         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
344         return true;
345     }
346 
347     /**
348      * @dev Decrease the amount of tokens that an owner allowed to a spender.
349      * approve should be called when allowed_[_spender] == 0. To decrement
350      * allowed value is better to use this function to avoid 2 calls (and wait until
351      * the first transaction is mined)
352      * From MonolithDAO Token.sol
353      * Emits an Approval event.
354      * @param spender The address which will spend the funds.
355      * @param subtractedValue The amount of tokens to decrease the allowance by.
356      */
357     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
358         require(spender != address(0));
359 
360         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
361         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
362         return true;
363     }
364 
365     /**
366     * @dev Transfer token for a specified addresses
367     * @param from The address to transfer from.
368     * @param to The address to transfer to.
369     * @param value The amount to be transferred.
370     */
371     function _transfer(address from, address to, uint256 value) internal {
372         require(to != address(0));
373 
374         _balances[from] = _balances[from].sub(value);
375         _balances[to] = _balances[to].add(value);
376         emit Transfer(from, to, value);
377     }
378 
379     /**
380      * @dev Internal function that mints an amount of the token and assigns it to
381      * an account. This encapsulates the modification of balances such that the
382      * proper events are emitted.
383      * @param account The account that will receive the created tokens.
384      * @param value The amount that will be created.
385      */
386     function _mint(address account, uint256 value) internal {
387         require(account != address(0));
388 
389         _totalSupply = _totalSupply.add(value);
390         _balances[account] = _balances[account].add(value);
391         emit Transfer(address(0), account, value);
392     }
393 
394     /**
395      * @dev Internal function that burns an amount of the token of a given
396      * account.
397      * @param account The account whose tokens will be burnt.
398      * @param value The amount that will be burnt.
399      */
400     function _burn(address account, uint256 value) internal {
401         require(account != address(0));
402 
403         _totalSupply = _totalSupply.sub(value);
404         _balances[account] = _balances[account].sub(value);
405         emit Transfer(account, address(0), value);
406     }
407 
408     /**
409      * @dev Internal function that burns an amount of the token of a given
410      * account, deducting from the sender's allowance for said account. Uses the
411      * internal burn function.
412      * Emits an Approval event (reflecting the reduced allowance).
413      * @param account The account whose tokens will be burnt.
414      * @param value The amount that will be burnt.
415      */
416     function _burnFrom(address account, uint256 value) internal {
417         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
418         _burn(account, value);
419         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
420     }
421 }
422 
423 
424 
425 contract ERC20Pausable is ERC20, Pausable {
426     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
427         return super.transfer(to, value);
428     }
429 
430     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
431         return super.transferFrom(from, to, value);
432     }
433     
434     /*
435      * approve/increaseApprove/decreaseApprove can be set when Paused state
436      */
437      
438     /*
439      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
440      *     return super.approve(spender, value);
441      * }
442      *
443      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
444      *     return super.increaseAllowance(spender, addedValue);
445      * }
446      *
447      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
448      *     return super.decreaseAllowance(spender, subtractedValue);
449      * }
450      */
451 }
452 
453 contract ERC20Detailed is IERC20 {
454     string private _name;
455     string private _symbol;
456     uint8 private _decimals;
457 
458     constructor (string memory name, string memory symbol, uint8 decimals) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = decimals;
462     }
463 
464     /**
465      * @return the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @return the symbol of the token.
473      */
474     function symbol() public view returns (string memory) {
475         return _symbol;
476     }
477 
478     /**
479      * @return the number of decimals of the token.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 }
485 
486 contract CUST is ERC20Detailed, ERC20Pausable {
487     
488     struct LockInfo {
489         uint256 _releaseTime;
490         uint256 _amount;
491     }
492     
493     address public implementation;
494 
495     mapping (address => LockInfo[]) public timelockList;
496 	mapping (address => bool) public frozenAccount;
497     
498     event Freeze(address indexed holder);
499     event Unfreeze(address indexed holder);
500     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
501     event Unlock(address indexed holder, uint256 value);
502 
503     modifier notFrozen(address _holder) {
504         require(!frozenAccount[_holder]);
505         _;
506     }
507     
508     constructor() ERC20Detailed("Custody Token", "CUST",18) public  {
509         
510         _mint(msg.sender, 10000000000 * (10 ** 18));
511     }
512     
513     function balanceOf(address owner) public view returns (uint256) {
514         
515         uint256 totalBalance = super.balanceOf(owner);
516         if( timelockList[owner].length >0 ){
517             for(uint i=0; i<timelockList[owner].length;i++){
518                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
519             }
520         }
521         
522         return totalBalance;
523     }
524     
525     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
526         if (timelockList[msg.sender].length > 0 ) {
527             _autoUnlock(msg.sender);            
528         }
529         return super.transfer(to, value);
530     }
531 
532     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
533         if (timelockList[from].length > 0) {
534             _autoUnlock(from);            
535         }
536         return super.transferFrom(from, to, value);
537     }
538     
539     function freezeAccount(address holder) public onlyPauser returns (bool) {
540         require(!frozenAccount[holder]);
541         frozenAccount[holder] = true;
542         emit Freeze(holder);
543         return true;
544     }
545 
546     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
547         require(frozenAccount[holder]);
548         frozenAccount[holder] = false;
549         emit Unfreeze(holder);
550         return true;
551     }
552     
553     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
554         require(_balances[holder] >= value,"There is not enough balances of holder.");
555         _lock(holder,value,releaseTime);
556         
557         
558         return true;
559     }
560     
561     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
562         _transfer(msg.sender, holder, value);
563         _lock(holder,value,releaseTime);
564         return true;
565     }
566     
567     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
568         require( timelockList[holder].length > idx, "There is not lock info.");
569         _unlock(holder,idx);
570         return true;
571     }
572     
573     /**
574      * @dev Upgrades the implementation address
575      * @param _newImplementation address of the new implementation
576      */
577     function upgradeTo(address _newImplementation) public onlyOwner {
578         require(implementation != _newImplementation);
579         _setImplementation(_newImplementation);
580     }
581     
582     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
583         _balances[holder] = _balances[holder].sub(value);
584         timelockList[holder].push( LockInfo(releaseTime, value) );
585         
586         emit Lock(holder, value, releaseTime);
587         return true;
588     }
589     
590     function _unlock(address holder, uint256 idx) internal returns(bool) {
591         LockInfo storage lockinfo = timelockList[holder][idx];
592         uint256 releaseAmount = lockinfo._amount;
593 
594         delete timelockList[holder][idx];
595         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
596         timelockList[holder].length -=1;
597         
598         emit Unlock(holder, releaseAmount);
599         _balances[holder] = _balances[holder].add(releaseAmount);
600         
601         return true;
602     }
603     
604     function _autoUnlock(address holder) internal returns(bool) {
605         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
606             if (timelockList[holder][idx]._releaseTime <= now) {
607                 // If lockupinfo was deleted, loop restart at same position.
608                 if( _unlock(holder, idx) ) {
609                     idx -=1;
610                 }
611             }
612         }
613         return true;
614     }
615     
616     /**
617      * @dev Sets the address of the current implementation
618      * @param _newImp address of the new implementation
619      */
620     function _setImplementation(address _newImp) internal {
621         implementation = _newImp;
622     }
623     
624     /**
625      * @dev Fallback function allowing to perform a delegatecall 
626      * to the given implementation. This function will return 
627      * whatever the implementation call returns
628      */
629     function () payable external {
630         address impl = implementation;
631         require(impl != address(0));
632         assembly {
633             let ptr := mload(0x40)
634             calldatacopy(ptr, 0, calldatasize)
635             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
636             let size := returndatasize
637             returndatacopy(ptr, 0, size)
638             
639             switch result
640             case 0 { revert(ptr, size) }
641             default { return(ptr, size) }
642         }
643     }
644 }