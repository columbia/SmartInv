1 pragma solidity ^0.5.17;
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
16         require(c / a == b, "SafeMath: multiplication overflow");
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // Solidity only automatically asserts when dividing by 0
25         require(b > 0, "SafeMath: division by zero");
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b <= a, "SafeMath: subtraction overflow");
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     /**
43     * @dev Adds two unsigned integers, reverts on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     /**
52     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
53     * reverts when dividing by zero.
54     */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0, "SafeMath: modulo by zero");
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
70         require(account != address(0), "Roles: account is the zero address");
71         require(!has(role, account), "Roles: account already has role");
72 
73         role.bearer[account] = true;
74     }
75 
76     /**
77      * @dev remove an account's access to this role
78      */
79     function remove(Role storage role, address account) internal {
80         require(account != address(0), "Roles: account is the zero address");
81         require(has(role, account), "Roles: account does not have role");
82 
83         role.bearer[account] = false;
84     }
85 
86     /**
87      * @dev check if an account has this role
88      * @return bool
89      */
90     function has(Role storage role, address account) internal view returns (bool) {
91         require(account != address(0), "Roles: account is the zero address");
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
108         require(msg.sender == owner, "Ownable: caller is not the owner");
109         _;
110     }
111     modifier onlyNewOwner() {
112         require(msg.sender != address(0), "Ownable: account is the zero address");
113         require(msg.sender == newOwner, "Ownable: caller is not the new owner");
114         _;
115     }
116    
117     function isOwner(address account) public view returns (bool) {       
118             return account == owner;
119     }
120 
121     function transferOwnership(address _newOwner) public onlyOwner {
122         require(_newOwner != address(0), "Ownable: new owner is the zero address");
123         newOwner = _newOwner;
124     }
125 
126     function acceptOwnership() public onlyNewOwner returns(bool) {
127         emit OwnershipTransferred(owner, newOwner);        
128         owner = newOwner;
129         newOwner = address(0);
130         return true;
131     }
132 }
133 
134 contract PauserRole is Ownable{
135     using Roles for Roles.Role;
136 
137     event PauserAdded(address indexed account);
138     event PauserRemoved(address indexed account);
139 
140     Roles.Role private _pausers;
141     uint256 internal _pausersCount;
142 
143     constructor () internal {
144         _addPauser(msg.sender);
145     }
146 
147     modifier onlyPauser() {
148         require(isPauser(msg.sender)|| isOwner(msg.sender));
149         _;
150     }
151 
152     function isPauser(address account) public view returns (bool) {
153         return _pausers.has(account);
154     }
155 
156     function addPauser(address account) public onlyPauser {
157         _addPauser(account);
158     }
159    
160     function removePauser(address account) public onlyOwner {
161         _removePauser(account);
162     }
163 
164     function renouncePauser() public onlyOwner {
165         _removePauser(msg.sender);
166     }
167 
168     function _addPauser(address account) internal {
169         _pausers.add(account);
170         emit PauserAdded(account);
171     }
172 
173     function _removePauser(address account) internal {        
174         _pausers.remove(account);
175         emit PauserRemoved(account);
176     }
177 }
178 
179 contract Pausable is PauserRole {
180     event Paused(address account);
181     event Unpaused(address account);
182 
183     bool private _paused;
184 
185     constructor () internal {
186         _paused = false;
187     }
188 
189     /**
190      * @return true if the contract is paused, false otherwise.
191      */
192     function paused() public view returns (bool) {
193         return _paused;
194     }
195 
196     /**
197      * @dev Modifier to make a function callable only when the contract is not paused.
198      */
199     modifier whenNotPaused() {
200         require(!_paused, "Pausable: paused");
201         _;
202     }
203 
204     /**
205      * @dev Modifier to make a function callable only when the contract is paused.
206      */
207     modifier whenPaused() {
208         require(_paused, "Pausable: not paused");
209         _;
210     }
211 
212     /**
213      * @dev called by the owner to pause, triggers stopped state
214      */
215     function pause() public onlyPauser whenNotPaused {
216         _paused = true;
217         emit Paused(msg.sender);
218     }
219 
220     /**
221      * @dev called by the owner to unpause, returns to normal state
222      */
223     function unpause() public onlyPauser whenPaused {
224         _paused = false;
225         emit Unpaused(msg.sender);
226     }
227 }
228 
229 interface IERC20 {
230     function transfer(address to, uint256 value) external returns (bool);
231 
232     function approve(address spender, uint256 value) external returns (bool);
233 
234     function transferFrom(address from, address to, uint256 value) external returns (bool);
235 
236     function totalSupply() external view returns (uint256);
237 
238     function balanceOf(address who) external view returns (uint256);
239 
240     function allowance(address owner, address spender) external view returns (uint256);
241 
242     event Transfer(address indexed from, address indexed to, uint256 value);
243 
244     event Approval(address indexed owner, address indexed spender, uint256 value);
245 }
246 
247 contract ERC20 is IERC20 {
248     using SafeMath for uint256;
249 
250     mapping (address => uint256) internal _balances;
251 
252     mapping (address => mapping (address => uint256)) internal _allowed;
253 
254     uint256 private _totalSupply;
255 
256     /**
257     * @dev Total number of tokens in existence
258     */
259     function totalSupply() public view returns (uint256) {
260         return _totalSupply;
261     }
262 
263     /**
264     * @dev Gets the balance of the specified address.
265     * @param owner The address to query the balance of.
266     * @return An uint256 representing the amount owned by the passed address.
267     */
268     function balanceOf(address owner) public view returns (uint256) {
269         return _balances[owner];
270     }
271 
272     /**
273      * @dev Function to check the amount of tokens that an owner allowed to a spender.
274      * @param owner address The address which owns the funds.
275      * @param spender address The address which will spend the funds.
276      * @return A uint256 specifying the amount of tokens still available for the spender.
277      */
278     function allowance(address owner, address spender) public view returns (uint256) {
279         return _allowed[owner][spender];
280     }
281 
282     /**
283     * @dev Transfer token for a specified address
284     * @param to The address to transfer to.
285     * @param value The amount to be transferred.
286     */
287     function transfer(address to, uint256 value) public returns (bool) {
288         _transfer(msg.sender, to, value);
289         return true;
290     }
291 
292     /**
293      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
294      * Beware that changing an allowance with this method brings the risk that someone may use both the old
295      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
296      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
297      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
298      * @param spender The address which will spend the funds.
299      * @param value The amount of tokens to be spent.
300      */
301     function approve(address spender, uint256 value) public returns (bool) {
302         require(spender != address(0), "ERC20: approve from the zero address");
303 
304         _allowed[msg.sender][spender] = value;
305         emit Approval(msg.sender, spender, value);
306         return true;
307     }
308 
309     /**
310      * @dev Transfer tokens from one address to another.
311      * Note that while this function emits an Approval event, this is not required as per the specification,
312      * and other compliant implementations may not emit the event.
313      * @param from address The address which you want to send tokens from
314      * @param to address The address which you want to transfer to
315      * @param value uint256 the amount of tokens to be transferred
316      */
317     function transferFrom(address from, address to, uint256 value) public returns (bool) {
318         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
319         _transfer(from, to, value);
320         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
321         return true;
322     }
323 
324     /**
325      * @dev Increase the amount of tokens that an owner allowed to a spender.
326      * approve should be called when allowed_[_spender] == 0. To increment
327      * allowed value is better to use this function to avoid 2 calls (and wait until
328      * the first transaction is mined)
329      * From MonolithDAO Token.sol
330      * Emits an Approval event.
331      * @param spender The address which will spend the funds.
332      * @param addedValue The amount of tokens to increase the allowance by.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
335         require(spender != address(0), "ERC20: increaseAllowance from the zero address");
336 
337         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
338         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
339         return true;
340     }
341 
342     /**
343      * @dev Decrease the amount of tokens that an owner allowed to a spender.
344      * approve should be called when allowed_[_spender] == 0. To decrement
345      * allowed value is better to use this function to avoid 2 calls (and wait until
346      * the first transaction is mined)
347      * From MonolithDAO Token.sol
348      * Emits an Approval event.
349      * @param spender The address which will spend the funds.
350      * @param subtractedValue The amount of tokens to decrease the allowance by.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
353         require(spender != address(0), "ERC20: decreaseAllowance from the zero address");
354 
355         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
356         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
357         return true;
358     }
359 
360     /**
361     * @dev Transfer token for a specified addresses
362     * @param from The address to transfer from.
363     * @param to The address to transfer to.
364     * @param value The amount to be transferred.
365     */
366     function _transfer(address from, address to, uint256 value) internal {
367         require(to != address(0), "ERC20: account to the zero address");
368 
369         _balances[from] = _balances[from].sub(value);
370         _balances[to] = _balances[to].add(value);
371         emit Transfer(from, to, value);
372     }
373 
374     /**
375      * @dev Internal function that mints an amount of the token and assigns it to
376      * an account. This encapsulates the modification of balances such that the
377      * proper events are emitted.
378      * @param account The account that will receive the created tokens.
379      * @param value The amount that will be created.
380      */
381     function _mint(address account, uint256 value) internal {
382         require(account != address(0), "ERC20: account from the zero address");
383 
384         _totalSupply = _totalSupply.add(value);
385         _balances[account] = _balances[account].add(value);
386         emit Transfer(address(0), account, value);
387     }
388 
389     /**
390      * @dev Internal function that burns an amount of the token of a given
391      * account.
392      * @param account The account whose tokens will be burnt.
393      * @param value The amount that will be burnt.
394      */
395     function _burn(address account, uint256 value) internal {
396         require(account != address(0), "ERC20: account from the zero address");
397 
398         _totalSupply = _totalSupply.sub(value);
399         _balances[account] = _balances[account].sub(value);
400         emit Transfer(account, address(0), value);
401     }
402 
403     /**
404      * @dev Internal function that burns an amount of the token of a given
405      * account, deducting from the sender's allowance for said account. Uses the
406      * internal burn function.
407      * Emits an Approval event (reflecting the reduced allowance).
408      * @param account The account whose tokens will be burnt.
409      * @param value The amount that will be burnt.
410      */
411     function _burnFrom(address account, uint256 value) internal {
412         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
413         _burn(account, value);
414         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
415     }
416 }
417 
418 contract ERC20Burnable is ERC20 {
419     /**
420      * @dev Burns a specific amount of tokens.
421      * @param value The amount of token to be burned.
422      */
423     function burn(uint256 value) public {
424         _burn(msg.sender, value);
425     }
426 
427     /**
428      * @dev Burns a specific amount of tokens from the target address and decrements allowance
429      * @param from address The address which you want to send tokens from
430      * @param value uint256 The amount of token to be burned
431      */
432     function burnFrom(address from, uint256 value) public {
433         _burnFrom(from, value);
434     }
435 }
436 
437 contract ERC20Pausable is ERC20, Pausable {
438     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
439         return super.transfer(to, value);
440     }
441 
442     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
443         return super.transferFrom(from, to, value);
444     }
445 
446     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
447         return super.approve(spender, value);
448     }
449 
450     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
451         return super.increaseAllowance(spender, addedValue);
452     }
453 
454     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
455         return super.decreaseAllowance(spender, subtractedValue);
456     }
457 }
458 
459 contract ERC20Detailed is IERC20 {
460     string private _name;
461     string private _symbol;
462     uint8 private _decimals;
463 
464     constructor (string memory name, string memory symbol, uint8 decimals) public {
465         _name = name;
466         _symbol = symbol;
467         _decimals = decimals;
468     }
469 
470     /**
471      * @return the name of the token.
472      */
473     function name() public view returns (string memory) {
474         return _name;
475     }
476 
477     /**
478      * @return the symbol of the token.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @return the number of decimals of the token.
486      */
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 }
491 
492 
493 contract AQT is ERC20Detailed, ERC20Pausable, ERC20Burnable {
494    
495     struct LockInfo {
496         uint256 _releaseTime;
497         uint256 _amount;
498     }
499    
500     address public implementation;
501 
502     mapping (address => LockInfo[]) public timelockList;
503     mapping (address => bool) public frozenAccount;
504    
505     event Freeze(address indexed holder,bool status);    
506     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
507     event Unlock(address indexed holder, uint256 value);
508 
509     modifier notFrozen(address _holder) {
510         require(!frozenAccount[_holder], "ERC20: frozenAccount");
511         _;
512     }
513    
514     constructor() ERC20Detailed("Alpha Quark Token", "AQT", 18) public  {
515         _mint(msg.sender, 30000000 * (10 ** 18));
516     }
517    
518     function balanceOf(address owner) public view returns (uint256) {
519        
520         uint256 totalBalance = super.balanceOf(owner);
521         if( timelockList[owner].length >0 ){
522             for(uint i=0; i<timelockList[owner].length;i++){
523                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
524             }
525         }
526        
527         return totalBalance;
528     }
529    
530     function transfer(address to, uint256 value) public notFrozen(msg.sender) notFrozen(to) returns (bool) {
531         if (timelockList[msg.sender].length > 0 ) {
532             _autoUnlock(msg.sender);            
533         }
534         return super.transfer(to, value);
535     }
536    
537 
538     function freezeAccount(address holder, bool value) public onlyPauser returns (bool) {        
539         frozenAccount[holder] = value;
540         emit Freeze(holder,value);
541         return true;
542     }
543 
544     function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
545         require(_balances[holder] >= value,"There is not enough balances of holder.");
546         _lock(holder,value,releaseTime);
547        
548         return true;
549     }
550    
551     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
552         _transfer(msg.sender, holder, value);
553         _lock(holder,value,releaseTime);
554         return true;
555     }
556    
557     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
558         require( timelockList[holder].length > idx, "There is not lock info.");
559         _unlock(holder,idx);
560         return true;
561     }
562    
563     /**
564      * @dev Upgrades the implementation address
565      * @param _newImplementation address of the new implementation
566      */
567     function upgradeTo(address _newImplementation) public onlyOwner {
568         require(implementation != _newImplementation);
569         _setImplementation(_newImplementation);
570     }
571    
572     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
573         _balances[holder] = _balances[holder].sub(value);
574         timelockList[holder].push( LockInfo(releaseTime, value) );
575        
576         emit Lock(holder, value, releaseTime);
577         return true;
578     }
579    
580     function _unlock(address holder, uint256 idx) internal returns(bool) {
581         LockInfo storage lockinfo = timelockList[holder][idx];
582         uint256 releaseAmount = lockinfo._amount;
583         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
584         timelockList[holder].pop();
585        
586         emit Unlock(holder, releaseAmount);
587         _balances[holder] = _balances[holder].add(releaseAmount);
588        
589         return true;
590     }
591    
592     function _autoUnlock(address holder) internal returns(bool) {
593         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
594             if (timelockList[holder][idx]._releaseTime <= now) {
595                 // If lockupinfo was deleted, loop restart at same position.
596                 if( _unlock(holder, idx) ) {
597                     idx -=1;
598                 }
599             }
600         }
601         return true;
602     }
603    
604     /**
605      * @dev Sets the address of the current implementation
606      * @param _newImp address of the new implementation
607      */
608     function _setImplementation(address _newImp) internal {
609         implementation = _newImp;
610     }
611    
612     /**
613      * @dev Fallback function allowing to perform a delegatecall
614      * to the given implementation. This function will return
615      * whatever the implementation call returns
616      */
617     function () payable external {
618         address impl = implementation;
619         require(impl != address(0), "ERC20: account is the zero address");
620         assembly {
621             let ptr := mload(0x40)
622             calldatacopy(ptr, 0, calldatasize)
623             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
624             let size := returndatasize
625             returndatacopy(ptr, 0, size)
626            
627             switch result
628             case 0 { revert(ptr, size) }
629             default { return(ptr, size) }
630         }
631     }
632 }