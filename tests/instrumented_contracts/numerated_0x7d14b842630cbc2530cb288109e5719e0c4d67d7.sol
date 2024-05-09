1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-13
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 library Roles {
68     struct Role {
69         mapping (address => bool) bearer;
70     }
71 
72     /**
73      * @dev give an account access to this role
74      */
75     function add(Role storage role, address account) internal {
76         require(account != address(0));
77         require(!has(role, account));
78 
79         role.bearer[account] = true;
80     }
81 
82     /**
83      * @dev remove an account's access to this role
84      */
85     function remove(Role storage role, address account) internal {
86         require(account != address(0));
87         require(has(role, account));
88 
89         role.bearer[account] = false;
90     }
91 
92     /**
93      * @dev check if an account has this role
94      * @return bool
95      */
96     function has(Role storage role, address account) internal view returns (bool) {
97         require(account != address(0));
98         return role.bearer[account];
99     }
100 }
101 
102 contract Ownable {
103     address public owner;
104     address public newOwner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     constructor() public {
109         owner = msg.sender;
110         newOwner = address(0);
111     }
112 
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     modifier onlyNewOwner() {
118         require(msg.sender != address(0));
119         require(msg.sender == newOwner);
120         _;
121     }
122     
123     function isOwner(address account) public view returns (bool) {
124         if( account == owner ){
125             return true;
126         }
127         else {
128             return false;
129         }
130     }
131 
132     function transferOwnership(address _newOwner) public onlyOwner {
133         require(_newOwner != address(0));
134         newOwner = _newOwner;
135     }
136 
137     function acceptOwnership() public onlyNewOwner returns(bool) {
138         emit OwnershipTransferred(owner, newOwner);        
139         owner = newOwner;
140         newOwner = address(0);
141     }
142 }
143 
144 contract PauserRole is Ownable{
145     using Roles for Roles.Role;
146 
147     event PauserAdded(address indexed account);
148     event PauserRemoved(address indexed account);
149 
150     Roles.Role private _pausers;
151 
152     constructor () internal {
153         _addPauser(msg.sender);
154     }
155 
156     modifier onlyPauser() {
157         require(isPauser(msg.sender)|| isOwner(msg.sender));
158         _;
159     }
160 
161     function isPauser(address account) public view returns (bool) {
162         return _pausers.has(account);
163     }
164 
165     function addPauser(address account) public onlyPauser {
166         _addPauser(account);
167     }
168     
169     function removePauser(address account) public onlyOwner {
170         _removePauser(account);
171     }
172 
173     function renouncePauser() public {
174         _removePauser(msg.sender);
175     }
176 
177     function _addPauser(address account) internal {
178         _pausers.add(account);
179         emit PauserAdded(account);
180     }
181 
182     function _removePauser(address account) internal {
183         _pausers.remove(account);
184         emit PauserRemoved(account);
185     }
186 }
187 
188 contract Pausable is PauserRole {
189     event Paused(address account);
190     event Unpaused(address account);
191 
192     bool private _paused;
193 
194     constructor () internal {
195         _paused = false;
196     }
197 
198     /**
199      * @return true if the contract is paused, false otherwise.
200      */
201     function paused() public view returns (bool) {
202         return _paused;
203     }
204 
205     /**
206      * @dev Modifier to make a function callable only when the contract is not paused.
207      */
208     modifier whenNotPaused() {
209         require(!_paused);
210         _;
211     }
212 
213     /**
214      * @dev Modifier to make a function callable only when the contract is paused.
215      */
216     modifier whenPaused() {
217         require(_paused);
218         _;
219     }
220 
221     /**
222      * @dev called by the owner to pause, triggers stopped state
223      */
224     function pause() public onlyPauser whenNotPaused {
225         _paused = true;
226         emit Paused(msg.sender);
227     }
228 
229     /**
230      * @dev called by the owner to unpause, returns to normal state
231      */
232     function unpause() public onlyPauser whenPaused {
233         _paused = false;
234         emit Unpaused(msg.sender);
235     }
236 }
237 
238 interface IERC20 {
239     function transfer(address to, uint256 value) external returns (bool);
240 
241     function approve(address spender, uint256 value) external returns (bool);
242 
243     function transferFrom(address from, address to, uint256 value) external returns (bool);
244 
245     function totalSupply() external view returns (uint256);
246 
247     function balanceOf(address who) external view returns (uint256);
248 
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 contract ERC20 is IERC20 {
257     using SafeMath for uint256;
258 
259     mapping (address => uint256) internal _balances;
260 
261     mapping (address => mapping (address => uint256)) internal _allowed;
262 
263     uint256 private _totalSupply;
264 
265     /**
266     * @dev Total number of tokens in existence
267     */
268     function totalSupply() public view returns (uint256) {
269         return _totalSupply;
270     }
271 
272     /**
273     * @dev Gets the balance of the specified address.
274     * @param owner The address to query the balance of.
275     * @return An uint256 representing the amount owned by the passed address.
276     */
277     function balanceOf(address owner) public view returns (uint256) {
278         return _balances[owner];
279     }
280 
281     /**
282      * @dev Function to check the amount of tokens that an owner allowed to a spender.
283      * @param owner address The address which owns the funds.
284      * @param spender address The address which will spend the funds.
285      * @return A uint256 specifying the amount of tokens still available for the spender.
286      */
287     function allowance(address owner, address spender) public view returns (uint256) {
288         return _allowed[owner][spender];
289     }
290 
291     /**
292     * @dev Transfer token for a specified address
293     * @param to The address to transfer to.
294     * @param value The amount to be transferred.
295     */
296     function transfer(address to, uint256 value) public returns (bool) {
297         _transfer(msg.sender, to, value);
298         return true;
299     }
300 
301     /**
302      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
303      * Beware that changing an allowance with this method brings the risk that someone may use both the old
304      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
305      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      * @param spender The address which will spend the funds.
308      * @param value The amount of tokens to be spent.
309      */
310     function approve(address spender, uint256 value) public returns (bool) {
311         require(spender != address(0));
312 
313         _allowed[msg.sender][spender] = value;
314         emit Approval(msg.sender, spender, value);
315         return true;
316     }
317 
318     /**
319      * @dev Transfer tokens from one address to another.
320      * Note that while this function emits an Approval event, this is not required as per the specification,
321      * and other compliant implementations may not emit the event.
322      * @param from address The address which you want to send tokens from
323      * @param to address The address which you want to transfer to
324      * @param value uint256 the amount of tokens to be transferred
325      */
326     function transferFrom(address from, address to, uint256 value) public returns (bool) {
327         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
328         _transfer(from, to, value);
329         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
330         return true;
331     }
332 
333     /**
334      * @dev Increase the amount of tokens that an owner allowed to a spender.
335      * approve should be called when allowed_[_spender] == 0. To increment
336      * allowed value is better to use this function to avoid 2 calls (and wait until
337      * the first transaction is mined)
338      * From MonolithDAO Token.sol
339      * Emits an Approval event.
340      * @param spender The address which will spend the funds.
341      * @param addedValue The amount of tokens to increase the allowance by.
342      */
343     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
344         require(spender != address(0));
345 
346         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
347         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
348         return true;
349     }
350 
351     /**
352      * @dev Decrease the amount of tokens that an owner allowed to a spender.
353      * approve should be called when allowed_[_spender] == 0. To decrement
354      * allowed value is better to use this function to avoid 2 calls (and wait until
355      * the first transaction is mined)
356      * From MonolithDAO Token.sol
357      * Emits an Approval event.
358      * @param spender The address which will spend the funds.
359      * @param subtractedValue The amount of tokens to decrease the allowance by.
360      */
361     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
362         require(spender != address(0));
363 
364         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
365         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
366         return true;
367     }
368 
369     /**
370     * @dev Transfer token for a specified addresses
371     * @param from The address to transfer from.
372     * @param to The address to transfer to.
373     * @param value The amount to be transferred.
374     */
375     function _transfer(address from, address to, uint256 value) internal {
376         require(to != address(0));
377 
378         _balances[from] = _balances[from].sub(value);
379         _balances[to] = _balances[to].add(value);
380         emit Transfer(from, to, value);
381     }
382 
383     /**
384      * @dev Internal function that mints an amount of the token and assigns it to
385      * an account. This encapsulates the modification of balances such that the
386      * proper events are emitted.
387      * @param account The account that will receive the created tokens.
388      * @param value The amount that will be created.
389      */
390     function _mint(address account, uint256 value) internal {
391         require(account != address(0));
392 
393         _totalSupply = _totalSupply.add(value);
394         _balances[account] = _balances[account].add(value);
395         emit Transfer(address(0), account, value);
396     }
397 
398     /**
399      * @dev Internal function that burns an amount of the token of a given
400      * account.
401      * @param account The account whose tokens will be burnt.
402      * @param value The amount that will be burnt.
403      */
404     function _burn(address account, uint256 value) internal {
405         require(account != address(0));
406 
407         _totalSupply = _totalSupply.sub(value);
408         _balances[account] = _balances[account].sub(value);
409         emit Transfer(account, address(0), value);
410     }
411 
412     /**
413      * @dev Internal function that burns an amount of the token of a given
414      * account, deducting from the sender's allowance for said account. Uses the
415      * internal burn function.
416      * Emits an Approval event (reflecting the reduced allowance).
417      * @param account The account whose tokens will be burnt.
418      * @param value The amount that will be burnt.
419      */
420     function _burnFrom(address account, uint256 value) internal {
421         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
422         _burn(account, value);
423         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
424     }
425 }
426 
427 contract ERC20Pausable is ERC20, Pausable {
428     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
429         return super.transfer(to, value);
430     }
431 
432     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
433         return super.transferFrom(from, to, value);
434     }
435     
436     /*
437      * approve/increaseApprove/decreaseApprove can be set when Paused state
438      */
439      
440     /*
441      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
442      *     return super.approve(spender, value);
443      * }
444      *
445      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
446      *     return super.increaseAllowance(spender, addedValue);
447      * }
448      *
449      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
450      *     return super.decreaseAllowance(spender, subtractedValue);
451      * }
452      */
453 }
454 
455 contract ERC20Detailed is IERC20 {
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     constructor (string memory name, string memory symbol, uint8 decimals) public {
461         _name = name;
462         _symbol = symbol;
463         _decimals = decimals;
464     }
465 
466     /**
467      * @return the name of the token.
468      */
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     /**
474      * @return the symbol of the token.
475      */
476     function symbol() public view returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @return the number of decimals of the token.
482      */
483     function decimals() public view returns (uint8) {
484         return _decimals;
485     }
486 }
487 
488 contract IBP is ERC20Detailed, ERC20Pausable {
489     
490     struct LockInfo {
491         uint256 _releaseTime;
492         uint256 _amount;
493     }
494     
495     address public implementation;
496 
497     mapping (address => LockInfo[]) public timelockList;
498 	mapping (address => bool) public frozenAccount;
499     
500     event Freeze(address indexed holder);
501     event Unfreeze(address indexed holder);
502     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
503     event Unlock(address indexed holder, uint256 value);
504 
505     modifier notFrozen(address _holder) {
506         require(!frozenAccount[_holder]);
507         _;
508     }
509     
510     constructor() ERC20Detailed("IBP Token", "IBP", 18) public  {
511         
512         _mint(msg.sender, 2000000000 * (10 ** 18));
513     }
514     
515     function balanceOf(address owner) public view returns (uint256) {
516         
517         uint256 totalBalance = super.balanceOf(owner);
518         if( timelockList[owner].length >0 ){
519             for(uint i=0; i<timelockList[owner].length;i++){
520                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
521             }
522         }
523         
524         return totalBalance;
525     }
526     
527     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
528         if (timelockList[msg.sender].length > 0 ) {
529             _autoUnlock(msg.sender);            
530         }
531         return super.transfer(to, value);
532     }
533 
534     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
535         if (timelockList[from].length > 0) {
536             _autoUnlock(from);            
537         }
538         return super.transferFrom(from, to, value);
539     }
540     
541     function freezeAccount(address holder) public onlyPauser returns (bool) {
542         require(!frozenAccount[holder]);
543         frozenAccount[holder] = true;
544         emit Freeze(holder);
545         return true;
546     }
547 
548     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
549         require(frozenAccount[holder]);
550         frozenAccount[holder] = false;
551         emit Unfreeze(holder);
552         return true;
553     }
554     
555     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
556         require(_balances[holder] >= value,"There is not enough balances of holder.");
557         _lock(holder,value,releaseTime);
558         
559         
560         return true;
561     }
562     
563     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
564         _transfer(msg.sender, holder, value);
565         _lock(holder,value,releaseTime);
566         return true;
567     }
568     
569     /**
570      * @dev Upgrades the implementation address
571      * @param _newImplementation address of the new implementation
572      */
573     function upgradeTo(address _newImplementation) public onlyOwner {
574         require(implementation != _newImplementation);
575         _setImplementation(_newImplementation);
576     }
577     
578     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
579         _balances[holder] = _balances[holder].sub(value);
580         timelockList[holder].push( LockInfo(releaseTime, value) );
581         
582         emit Lock(holder, value, releaseTime);
583         return true;
584     }
585     
586     function _unlock(address holder, uint256 idx) internal returns(bool) {
587         LockInfo storage lockinfo = timelockList[holder][idx];
588         uint256 releaseAmount = lockinfo._amount;
589 
590         delete timelockList[holder][idx];
591         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
592         timelockList[holder].length -=1;
593         
594         emit Unlock(holder, releaseAmount);
595         _balances[holder] = _balances[holder].add(releaseAmount);
596         
597         return true;
598     }
599     
600     function _autoUnlock(address holder) internal returns(bool) {
601         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
602             if (timelockList[holder][idx]._releaseTime <= now) {
603                 // If lockupinfo was deleted, loop restart at same position.
604                 if( _unlock(holder, idx) ) {
605                     idx -=1;
606                 }
607             }
608         }
609         return true;
610     }
611     
612     /**
613      * @dev Sets the address of the current implementation
614      * @param _newImp address of the new implementation
615      */
616     function _setImplementation(address _newImp) internal {
617         implementation = _newImp;
618     }
619     
620     /**
621      * @dev Fallback function allowing to perform a delegatecall 
622      * to the given implementation. This function will return 
623      * whatever the implementation call returns
624      */
625     function () payable external {
626         address impl = implementation;
627         require(impl != address(0));
628         assembly {
629             let ptr := mload(0x40)
630             calldatacopy(ptr, 0, calldatasize)
631             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
632             let size := returndatasize
633             returndatacopy(ptr, 0, size)
634             
635             switch result
636             case 0 { revert(ptr, size) }
637             default { return(ptr, size) }
638         }
639     }
640 }