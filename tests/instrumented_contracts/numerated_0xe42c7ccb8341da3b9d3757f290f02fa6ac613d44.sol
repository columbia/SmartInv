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
101     address public crowdOwner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     constructor() public {
106         owner = msg.sender;
107         newOwner = address(0);
108     }
109 
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114     modifier onlyNewOwner() {
115         require(msg.sender != address(0));
116         require(msg.sender == newOwner);
117         _;
118     }
119     
120     modifier onlyCrowdOwner()
121     {
122         require(msg.sender == crowdOwner);
123         _;
124     }
125     
126     function isOwner(address account) public view returns (bool) {
127         if( account == owner ){
128             return true;
129         }
130         else {
131             return false;
132         }
133     }
134 
135     function transferOwnership(address _newOwner) public onlyOwner {
136         require(_newOwner != address(0));
137         newOwner = _newOwner;
138     }
139 
140     function acceptOwnership() public onlyNewOwner returns(bool) {
141         emit OwnershipTransferred(owner, newOwner);        
142         owner = newOwner;
143         newOwner = address(0);
144     }
145     
146     function transferCrowdOwner(address _newCrowdOwner) onlyOwner public {
147         require(_newCrowdOwner != address(0));
148         crowdOwner = _newCrowdOwner;
149     }
150 }
151 
152 
153 
154 contract PauserRole is Ownable{
155     using Roles for Roles.Role;
156 
157     event PauserAdded(address indexed account);
158     event PauserRemoved(address indexed account);
159 
160     Roles.Role private _pausers;
161 
162     constructor () internal {
163         _addPauser(msg.sender);
164     }
165 
166     modifier onlyPauser() {
167         require(isPauser(msg.sender)|| isOwner(msg.sender));
168         _;
169     }
170 
171     function isPauser(address account) public view returns (bool) {
172         return _pausers.has(account);
173     }
174 
175     function addPauser(address account) public onlyPauser {
176         _addPauser(account);
177     }
178     
179     function removePauser(address account) public onlyOwner {
180         _removePauser(account);
181     }
182 
183     function renouncePauser() public {
184         _removePauser(msg.sender);
185     }
186 
187     function _addPauser(address account) internal {
188         _pausers.add(account);
189         emit PauserAdded(account);
190     }
191 
192     function _removePauser(address account) internal {
193         _pausers.remove(account);
194         emit PauserRemoved(account);
195     }
196 }
197 
198 
199 contract Pausable is PauserRole {
200     event Paused(address account);
201     event Unpaused(address account);
202 
203     bool private _paused;
204 
205     constructor () internal {
206         _paused = false;
207     }
208 
209     /**
210      * @return true if the contract is paused, false otherwise.
211      */
212     function paused() public view returns (bool) {
213         return _paused;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is not paused.
218      */
219     modifier whenNotPaused() {
220         require(!_paused);
221         _;
222     }
223 
224     /**
225      * @dev Modifier to make a function callable only when the contract is paused.
226      */
227     modifier whenPaused() {
228         require(_paused);
229         _;
230     }
231 
232     /**
233      * @dev called by the owner to pause, triggers stopped state
234      */
235     function pause() public onlyPauser whenNotPaused {
236         _paused = true;
237         emit Paused(msg.sender);
238     }
239 
240     /**
241      * @dev called by the owner to unpause, returns to normal state
242      */
243     function unpause() public onlyPauser whenPaused {
244         _paused = false;
245         emit Unpaused(msg.sender);
246     }
247 }
248 
249 interface IERC20 {
250     function transfer(address to, uint256 value) external returns (bool);
251 
252     function approve(address spender, uint256 value) external returns (bool);
253 
254     function transferFrom(address from, address to, uint256 value) external returns (bool);
255 
256     function totalSupply() external view returns (uint256);
257 
258     function balanceOf(address who) external view returns (uint256);
259 
260     function allowance(address owner, address spender) external view returns (uint256);
261 
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 contract ERC20 is IERC20 {
268     using SafeMath for uint256;
269 
270     mapping (address => uint256) internal _balances;
271 
272     mapping (address => mapping (address => uint256)) internal _allowed;
273 
274     uint256 private _totalSupply;
275 
276     /**
277     * @dev Total number of tokens in existence
278     */
279     function totalSupply() public view returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284     * @dev Gets the balance of the specified address.
285     * @param owner The address to query the balance of.
286     * @return An uint256 representing the amount owned by the passed address.
287     */
288     function balanceOf(address owner) public view returns (uint256) {
289         return _balances[owner];
290     }
291 
292     /**
293      * @dev Function to check the amount of tokens that an owner allowed to a spender.
294      * @param owner address The address which owns the funds.
295      * @param spender address The address which will spend the funds.
296      * @return A uint256 specifying the amount of tokens still available for the spender.
297      */
298     function allowance(address owner, address spender) public view returns (uint256) {
299         return _allowed[owner][spender];
300     }
301 
302     /**
303     * @dev Transfer token for a specified address
304     * @param to The address to transfer to.
305     * @param value The amount to be transferred.
306     */
307     function transfer(address to, uint256 value) public returns (bool) {
308         _transfer(msg.sender, to, value);
309         return true;
310     }
311 
312     /**
313      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
314      * Beware that changing an allowance with this method brings the risk that someone may use both the old
315      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
316      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
317      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
318      * @param spender The address which will spend the funds.
319      * @param value The amount of tokens to be spent.
320      */
321     function approve(address spender, uint256 value) public returns (bool) {
322         require(spender != address(0));
323 
324         _allowed[msg.sender][spender] = value;
325         emit Approval(msg.sender, spender, value);
326         return true;
327     }
328 
329     /**
330      * @dev Transfer tokens from one address to another.
331      * Note that while this function emits an Approval event, this is not required as per the specification,
332      * and other compliant implementations may not emit the event.
333      * @param from address The address which you want to send tokens from
334      * @param to address The address which you want to transfer to
335      * @param value uint256 the amount of tokens to be transferred
336      */
337     function transferFrom(address from, address to, uint256 value) public returns (bool) {
338         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
339         _transfer(from, to, value);
340         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
341         return true;
342     }
343 
344     /**
345      * @dev Increase the amount of tokens that an owner allowed to a spender.
346      * approve should be called when allowed_[_spender] == 0. To increment
347      * allowed value is better to use this function to avoid 2 calls (and wait until
348      * the first transaction is mined)
349      * From MonolithDAO Token.sol
350      * Emits an Approval event.
351      * @param spender The address which will spend the funds.
352      * @param addedValue The amount of tokens to increase the allowance by.
353      */
354     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
355         require(spender != address(0));
356 
357         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
358         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
359         return true;
360     }
361 
362     /**
363      * @dev Decrease the amount of tokens that an owner allowed to a spender.
364      * approve should be called when allowed_[_spender] == 0. To decrement
365      * allowed value is better to use this function to avoid 2 calls (and wait until
366      * the first transaction is mined)
367      * From MonolithDAO Token.sol
368      * Emits an Approval event.
369      * @param spender The address which will spend the funds.
370      * @param subtractedValue The amount of tokens to decrease the allowance by.
371      */
372     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
373         require(spender != address(0));
374 
375         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
376         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
377         return true;
378     }
379 
380     /**
381     * @dev Transfer token for a specified addresses
382     * @param from The address to transfer from.
383     * @param to The address to transfer to.
384     * @param value The amount to be transferred.
385     */
386     function _transfer(address from, address to, uint256 value) internal {
387         require(to != address(0));
388 
389         _balances[from] = _balances[from].sub(value);
390         _balances[to] = _balances[to].add(value);
391         emit Transfer(from, to, value);
392     }
393 
394     /**
395      * @dev Internal function that mints an amount of the token and assigns it to
396      * an account. This encapsulates the modification of balances such that the
397      * proper events are emitted.
398      * @param account The account that will receive the created tokens.
399      * @param value The amount that will be created.
400      */
401     function _mint(address account, uint256 value) internal {
402         require(account != address(0));
403 
404         _totalSupply = _totalSupply.add(value);
405         _balances[account] = _balances[account].add(value);
406         emit Transfer(address(0), account, value);
407     }
408 
409     /**
410      * @dev Internal function that burns an amount of the token of a given
411      * account.
412      * @param account The account whose tokens will be burnt.
413      * @param value The amount that will be burnt.
414      */
415     function _burn(address account, uint256 value) internal {
416         require(account != address(0));
417 
418         _totalSupply = _totalSupply.sub(value);
419         _balances[account] = _balances[account].sub(value);
420         emit Transfer(account, address(0), value);
421     }
422 
423     /**
424      * @dev Internal function that burns an amount of the token of a given
425      * account, deducting from the sender's allowance for said account. Uses the
426      * internal burn function.
427      * Emits an Approval event (reflecting the reduced allowance).
428      * @param account The account whose tokens will be burnt.
429      * @param value The amount that will be burnt.
430      */
431     function _burnFrom(address account, uint256 value) internal {
432         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
433         _burn(account, value);
434         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
435     }
436 }
437 
438 
439 
440 contract ERC20Pausable is ERC20, Pausable {
441     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
442         return super.transfer(to, value);
443     }
444 
445     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
446         return super.transferFrom(from, to, value);
447     }
448 
449     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
450         return super.approve(spender, value);
451     }
452     
453     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {
454         return super.increaseAllowance(spender, addedValue);
455     }
456     
457     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {
458         return super.decreaseAllowance(spender, subtractedValue);
459     }
460 }
461 
462 contract ERC20Detailed is IERC20 {
463     string private _name;
464     string private _symbol;
465     uint8 private _decimals;
466 
467     constructor (string memory name, string memory symbol, uint8 decimals) public {
468         _name = name;
469         _symbol = symbol;
470         _decimals = decimals;
471     }
472 
473     /**
474      * @return the name of the token.
475      */
476     function name() public view returns (string memory) {
477         return _name;
478     }
479 
480     /**
481      * @return the symbol of the token.
482      */
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     /**
488      * @return the number of decimals of the token.
489      */
490     function decimals() public view returns (uint8) {
491         return _decimals;
492     }
493 }
494 
495 contract MinterRole is Ownable{
496     using Roles for Roles.Role;
497 
498     event MinterAdded(address indexed account);
499     event MinterRemoved(address indexed account);
500 
501     Roles.Role private _minters;
502 
503     constructor () internal {
504         _addMinter(msg.sender);
505     }
506 
507     modifier onlyMinter() {
508         require(isMinter(msg.sender) || isOwner(msg.sender));
509         _;
510     }
511 
512     function isMinter(address account) public view returns (bool) {
513         return _minters.has(account);
514     }
515 
516     function addMinter(address account) public onlyMinter {
517         _addMinter(account);
518     }
519     
520     function removeMinter(address account) public onlyOwner {
521         _removeMinter(account);
522     }
523 
524     function renounceMinter() public {
525         _removeMinter(msg.sender);
526     }
527 
528     function _addMinter(address account) internal {
529         _minters.add(account);
530         emit MinterAdded(account);
531     }
532 
533     function _removeMinter(address account) internal {
534         _minters.remove(account);
535         emit MinterRemoved(account);
536     }
537 }
538 
539 contract ERC20Mintable is ERC20, MinterRole {
540     /**
541      * @dev Function to mint tokens
542      * @param to The address that will receive the minted tokens.
543      * @param value The amount of tokens to mint.
544      * @return A boolean that indicates if the operation was successful.
545      */
546     function mint(address to, uint256 value) public onlyMinter returns (bool) {
547         _mint(to, value);
548         return true;
549     }
550 }
551 
552 contract ERC20Burnable is ERC20 {
553     /**
554      * @dev Burns a specific amount of tokens.
555      * @param value The amount of token to be burned.
556      */
557     function burn(uint256 value) public {
558         _burn(msg.sender, value);
559     }
560 
561     /**
562      * @dev Burns a specific amount of tokens from the target address and decrements allowance
563      * @param from address The address which you want to send tokens from
564      * @param value uint256 The amount of token to be burned
565      */
566     function burnFrom(address from, uint256 value) public {
567         _burnFrom(from, value);
568     }
569 }
570 
571 
572 contract TWOPercent is ERC20Detailed, ERC20Pausable, ERC20Mintable, ERC20Burnable  {
573     uint256 public INITIAL_SUPPLY = 2500000000;
574 
575     mapping(address => bool) public frozenAccount;
576 
577     event FrozenFunds(address target, bool frozen);
578     event FrozenAll(bool stop);
579     event Burn(address indexed from, uint256 value);
580     event LockEvent(address from, address to, uint256 startLock, uint256 endLock, uint256 value);
581     event Aborted();
582     
583     struct lockForAddr {
584         uint256 startLock;
585         uint256 endLock;
586     }
587 
588     mapping(address => uint256) balances_locked;
589     mapping(address => lockForAddr) lockForAddrs;
590     
591     
592     function setLockForAddr(address _address, uint256 _startLock, uint256 _endLock) onlyOwner public {
593         lockForAddrs[_address] = lockForAddr(_startLock, _endLock);
594     }
595     
596     function getLockForAddr(address _address)  public view returns (uint, uint) {
597         lockForAddr storage _lockForAddr = lockForAddrs[_address];
598         return (_lockForAddr.startLock, _lockForAddr.endLock);
599     }
600     
601     function getLockStartForAddr(address _address)  public view returns (uint) {
602         lockForAddr storage _lockForAddr = lockForAddrs[_address];
603         return _lockForAddr.startLock;
604     }
605     
606     function getLockEndForAddr(address _address)  public view returns (uint) {
607         lockForAddr storage _lockForAddr = lockForAddrs[_address];
608         return _lockForAddr.endLock;
609     }
610     
611     
612 
613     constructor() ERC20Detailed("TWOPercent", "TPCT", 18) public  {
614         
615         _mint(msg.sender, 2500000000 * (10 ** 18));
616     }
617     
618 
619     function _transfer(address _from, address _to, uint256 _value) internal {
620         require(_to != address(0x0),"Receive address is 0x0"); // Prevent transfer to 0x0 address. Use burn() instead
621         require(balanceOf(_from) >= _value,"Not enaugh balance"); 
622         require(!frozenAccount[_from],"_from addresss is frozen"); 
623         require(!frozenAccount[_to],"_to addresss is frozen"); 
624 
625 
626         if(_balances[_from] >= _value) { // 잔액이 충분한 경우
627             _balances[_from] = _balances[_from].sub(_value);    
628         } else if (getLockStartForAddr(_from) > 0) {  // 락업이 걸려있다면//
629             
630             uint256 kstNow = now + 32400;
631 
632             require( kstNow < getLockStartForAddr(_from) || getLockEndForAddr(_from) < kstNow, "Token is locked");
633 
634         	uint256 shortfall = _value.sub(_balances[_from]);
635             
636             balances_locked[_from] = balances_locked[_from].sub(shortfall);
637             _balances[_from] = 0;
638                 
639         } else {
640             //revert("Not enough balance");
641             require(false,"Not enough balance");
642         }
643         
644         if(msg.sender == crowdOwner)  balances_locked[_to] = balances_locked[_to].add(_value);
645         else _balances[_to] = _balances[_to].add(_value);
646         
647         
648         emit Transfer(_from, _to, _value);
649     }
650 
651     function freezeAccount(address target, bool freeze) onlyOwner public {
652         frozenAccount[target] = freeze;
653         emit FrozenFunds(target, freeze);
654     }
655     
656     function balanceOfDef(address _owner) public view returns(uint256 balance) {
657         return _balances[_owner];
658     }
659      
660     function balanceOf(address _owner) public view returns(uint256 balance) {
661         return _balances[_owner].add(balances_locked[_owner]);
662     }
663     
664     function balanceOfCrowd(address _owner) public view returns(uint256 balance) {
665         return balances_locked[_owner];
666     }
667 }