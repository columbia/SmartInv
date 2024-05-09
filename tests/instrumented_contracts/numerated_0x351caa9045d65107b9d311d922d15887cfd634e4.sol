1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19         
20         uint256 c = a * b;
21         require(c / a == b);
22         
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     
34     return c;
35     }
36     
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43     
44         return c;
45     }
46     
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53     
54         return c;
55     }
56     
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
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
72     function add(Role storage role, address account) internal {
73         require(account != address(0));
74         require(!has(role, account));
75         role.bearer[account] = true;
76     }
77     function remove(Role storage role, address account) internal {
78         require(account != address(0));
79         require(has(role, account));
80         role.bearer[account] = false;
81     }
82     function has(Role storage role, address account) internal view returns (bool) {
83         require(account != address(0));
84         return role.bearer[account];
85     }
86 }
87 
88 contract Ownable {
89     address public owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor() public {
94         owner = msg.sender;
95     }
96 
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function isOwner(address account) public view returns (bool) {
103         if( account == owner ){
104             return true;
105         }
106         else {
107             return false;
108         }
109     }
110     function transferOwnership(address newOwner) public onlyOwner {
111         require(newOwner != address(0));
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115 }
116 
117 contract AdminRole is Ownable{
118     using Roles for Roles.Role;
119 
120     event AdminAdded(address indexed account);
121     event AdminRemoved(address indexed account);
122 
123     Roles.Role private _admin_list;
124 
125     constructor () internal {
126         _addAdmin(msg.sender);
127     }
128 
129     modifier onlyAdmin() {
130         require(isAdmin(msg.sender)|| isOwner(msg.sender));
131         _;
132     }
133 
134     function isAdmin(address account) public view returns (bool) {
135         return _admin_list.has(account);
136     }
137     function addAdmin(address account) public onlyAdmin {
138         _addAdmin(account);
139     }
140     function removeAdmin(address account) public onlyOwner {
141         _removeAdmin(account);
142     }
143     function renounceAdmin() public {
144         _removeAdmin(msg.sender);
145     }
146     function _addAdmin(address account) internal {
147         _admin_list.add(account);
148         emit AdminAdded(account);
149     }
150     function _removeAdmin(address account) internal {
151         _admin_list.remove(account);
152         emit AdminRemoved(account);
153     }
154 }
155 
156 
157 contract Pausable is AdminRole {
158     event Paused(address account);
159     event Unpaused(address account);
160 
161     bool private _paused;
162 
163     constructor () internal {
164         _paused = false;
165     }
166 
167     /**
168      * @return true if the contract is paused, false otherwise.
169      */
170     function paused() public view returns (bool) {
171         return _paused;
172     }
173 
174     /**
175      * @dev Modifier to make a function callable only when the contract is not paused.
176      */
177     modifier whenNotPaused() {
178         require(!_paused);
179         _;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is paused.
184      */
185     modifier whenPaused() {
186         require(_paused);
187         _;
188     }
189 
190     /**
191      * @dev called by the owner to pause, triggers stopped state
192      */
193     function pause() public onlyAdmin whenNotPaused {
194         _paused = true;
195         emit Paused(msg.sender);
196     }
197 
198     /**
199      * @dev called by the owner to unpause, returns to normal state
200      */
201     function unpause() public onlyAdmin whenPaused {
202         _paused = false;
203         emit Unpaused(msg.sender);
204     }
205 }
206 
207 interface IERC20 {
208     function transfer(address to, uint256 value) external returns (bool);
209     function approve(address spender, uint256 value) external returns (bool);
210     function transferFrom(address from, address to, uint256 value) external returns (bool);
211     function totalSupply() external view returns (uint256);
212     function balanceOf(address who) external view returns (uint256);
213     function allowance(address owner, address spender) external view returns (uint256);
214 
215     event Transfer(address indexed from, address indexed to, uint256 value);
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) internal _balances;
223     mapping (address => mapping (address => uint256)) internal _allowed;
224 
225     uint256 private _totalSupply;
226 
227     /**
228     * @dev Total number of tokens in existence
229     */
230     function totalSupply() public view returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235     * @dev Gets the balance of the specified address.
236     * @param owner The address to query the balance of.
237     * @return An uint256 representing the amount owned by the passed address.
238     */
239     function balanceOf(address owner) public view returns (uint256) {
240         return _balances[owner];
241     }
242 
243     /**
244      * @dev Function to check the amount of tokens that an owner allowed to a spender.
245      * @param owner address The address which owns the funds.
246      * @param spender address The address which will spend the funds.
247      * @return A uint256 specifying the amount of tokens still available for the spender.
248      */
249     function allowance(address owner, address spender) public view returns (uint256) {
250         return _allowed[owner][spender];
251     }
252 
253     /**
254     * @dev Transfer token for a specified address
255     * @param to The address to transfer to.
256     * @param value The amount to be transferred.
257     */
258     function transfer(address to, uint256 value) public returns (bool) {
259         _transfer(msg.sender, to, value);
260         return true;
261     }
262 
263     /**
264      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265      * Beware that changing an allowance with this method brings the risk that someone may use both the old
266      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      * @param spender The address which will spend the funds.
270      * @param value The amount of tokens to be spent.
271      */
272     function approve(address spender, uint256 value) public returns (bool) {
273         require(spender != address(0));
274 
275         _allowed[msg.sender][spender] = value;
276         emit Approval(msg.sender, spender, value);
277         return true;
278     }
279 
280     /**
281      * @dev Transfer tokens from one address to another.
282      * Note that while this function emits an Approval event, this is not required as per the specification,
283      * and other compliant implementations may not emit the event.
284      * @param from address The address which you want to send tokens from
285      * @param to address The address which you want to transfer to
286      * @param value uint256 the amount of tokens to be transferred
287      */
288     function transferFrom(address from, address to, uint256 value) public returns (bool) {
289         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
290         _transfer(from, to, value);
291         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
292         return true;
293     }
294 
295     /**
296      * @dev Increase the amount of tokens that an owner allowed to a spender.
297      * approve should be called when allowed_[_spender] == 0. To increment
298      * allowed value is better to use this function to avoid 2 calls (and wait until
299      * the first transaction is mined)
300      * From MonolithDAO Token.sol
301      * Emits an Approval event.
302      * @param spender The address which will spend the funds.
303      * @param addedValue The amount of tokens to increase the allowance by.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
306         require(spender != address(0));
307 
308         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
309         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
310         return true;
311     }
312 
313     /**
314      * @dev Decrease the amount of tokens that an owner allowed to a spender.
315      * approve should be called when allowed_[_spender] == 0. To decrement
316      * allowed value is better to use this function to avoid 2 calls (and wait until
317      * the first transaction is mined)
318      * From MonolithDAO Token.sol
319      * Emits an Approval event.
320      * @param spender The address which will spend the funds.
321      * @param subtractedValue The amount of tokens to decrease the allowance by.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         require(spender != address(0));
325 
326         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
327         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
328         return true;
329     }
330 
331     /**
332     * @dev Transfer token for a specified addresses
333     * @param from The address to transfer from.
334     * @param to The address to transfer to.
335     * @param value The amount to be transferred.
336     */
337     function _transfer(address from, address to, uint256 value) internal {
338         require(to != address(0));
339 
340         _balances[from] = _balances[from].sub(value);
341         _balances[to] = _balances[to].add(value);
342         emit Transfer(from, to, value);
343     }
344 
345     /**
346      * @dev Internal function that mints an amount of the token and assigns it to
347      * an account. This encapsulates the modification of balances such that the
348      * proper events are emitted.
349      * @param account The account that will receive the created tokens.
350      * @param value The amount that will be created.
351      */
352     function _mint(address account, uint256 value) internal {
353         require(account != address(0));
354 
355         _totalSupply = _totalSupply.add(value);
356         _balances[account] = _balances[account].add(value);
357         emit Transfer(address(0), account, value);
358     }
359 
360     /**
361      * @dev Internal function that burns an amount of the token of a given
362      * account.
363      * @param account The account whose tokens will be burnt.
364      * @param value The amount that will be burnt.
365      */
366     function _burn(address account, uint256 value) internal {
367         require(account != address(0));
368 
369         _totalSupply = _totalSupply.sub(value);
370         _balances[account] = _balances[account].sub(value);
371         emit Transfer(account, address(0), value);
372     }
373 
374     /**
375      * @dev Internal function that burns an amount of the token of a given
376      * account, deducting from the sender's allowance for said account. Uses the
377      * internal burn function.
378      * Emits an Approval event (reflecting the reduced allowance).
379      * @param account The account whose tokens will be burnt.
380      * @param value The amount that will be burnt.
381      */
382     function _burnFrom(address account, uint256 value) internal {
383         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
384         _burn(account, value);
385         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
386     }
387 }
388 
389 contract ERC20Burnable is ERC20 {
390     /**
391      * @dev Burns a specific amount of tokens.
392      * @param value The amount of token to be burned.
393      */
394     function burn(uint256 value) public {
395         _burn(msg.sender, value);
396     }
397 
398     /**
399      * @dev Burns a specific amount of tokens from the target address and decrements allowance
400      * @param from address The address which you want to send tokens from
401      * @param value uint256 The amount of token to be burned
402      */
403     function burnFrom(address from, uint256 value) public {
404         _burnFrom(from, value);
405     }
406 }
407 
408 contract ERC20Pausable is ERC20, Pausable {
409     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
410         return super.transfer(to, value);
411     }
412 
413     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
414         return super.transferFrom(from, to, value);
415     }
416 
417     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
418         return super.approve(spender, value);
419     }
420 
421     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
422         return super.increaseAllowance(spender, addedValue);
423     }
424 
425     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
426         return super.decreaseAllowance(spender, subtractedValue);
427     }
428 }
429 
430 contract ERC20Detailed is IERC20 {
431     string private _name;
432     string private _symbol;
433     uint8 private _decimals;
434 
435     constructor (string memory name, string memory symbol, uint8 decimals) public {
436         _name = name;
437         _symbol = symbol;
438         _decimals = decimals;
439     }
440 
441     /**
442      * @return the name of the token.
443      */
444     function name() public view returns (string memory) {
445         return _name;
446     }
447 
448     /**
449      * @return the symbol of the token.
450      */
451     function symbol() public view returns (string memory) {
452         return _symbol;
453     }
454 
455     /**
456      * @return the number of decimals of the token.
457      */
458     function decimals() public view returns (uint8) {
459         return _decimals;
460     }
461 }
462 
463 contract ARW is ERC20Detailed, ERC20Pausable, ERC20Burnable {
464     
465     struct LockInfo {
466         uint256 _releaseTime;
467         uint256 _amount;
468     }
469     
470     address public implementation;
471 
472     mapping (address => LockInfo[]) public timelockList;
473 	mapping (address => bool) public frozenAccount;
474     
475     event Freeze(address indexed holder);
476     event Unfreeze(address indexed holder);
477     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
478     event Unlock(address indexed holder, uint256 value);
479 
480     modifier notFrozen(address _holder) {
481         require(!frozenAccount[_holder]);
482         _;
483     }
484     
485     constructor() ERC20Detailed("Arowana Token", "ARW", 18) public  {
486         
487         _mint(msg.sender, 500000000 * (10 ** 18));
488     }
489     
490     function balanceOf(address owner) public view returns (uint256) {
491         
492         uint256 totalBalance = super.balanceOf(owner);
493         if( timelockList[owner].length >0 ){
494             for(uint i=0; i<timelockList[owner].length;i++){
495                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
496             }
497         }
498         
499         return totalBalance;
500     }
501     
502     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
503         if (timelockList[msg.sender].length > 0 ) {
504             _autoUnlock(msg.sender);            
505         }
506         return super.transfer(to, value);
507     }
508 
509     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
510         if (timelockList[from].length > 0) {
511             _autoUnlock(from);            
512         }
513         return super.transferFrom(from, to, value);
514     }
515     
516     function freezeAccount(address holder) public onlyAdmin returns (bool) {
517         require(!frozenAccount[holder]);
518         frozenAccount[holder] = true;
519         emit Freeze(holder);
520         return true;
521     }
522 
523     function unfreezeAccount(address holder) public onlyAdmin returns (bool) {
524         require(frozenAccount[holder]);
525         frozenAccount[holder] = false;
526         emit Unfreeze(holder);
527         return true;
528     }
529     
530     function lock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
531         require(_balances[holder] >= value,"There is not enough balance of holder.");
532         _lock(holder,value,releaseTime);
533         
534         return true;
535     }
536     
537     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
538         _transfer(msg.sender, holder, value);
539         _lock(holder,value,releaseTime);
540         return true;
541     }
542     
543     function unlock(address holder, uint256 idx) public onlyAdmin returns (bool) {
544         require( timelockList[holder].length > idx, "There is not lock info.");
545         _unlock(holder,idx);
546         return true;
547     }
548     
549     /**
550      * @dev Upgrades the implementation address
551      * @param _newImplementation address of the new implementation
552      */
553     function upgradeTo(address _newImplementation) public onlyOwner {
554         require(implementation != _newImplementation);
555         _setImplementation(_newImplementation);
556     }
557     
558     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
559         _balances[holder] = _balances[holder].sub(value);
560         timelockList[holder].push( LockInfo(releaseTime, value) );
561         
562         emit Lock(holder, value, releaseTime);
563         return true;
564     }
565     
566     function _unlock(address holder, uint256 idx) internal returns(bool) {
567         LockInfo storage lockinfo = timelockList[holder][idx];
568         uint256 releaseAmount = lockinfo._amount;
569 
570         delete timelockList[holder][idx];
571         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
572         timelockList[holder].length -=1;
573         
574         emit Unlock(holder, releaseAmount);
575         _balances[holder] = _balances[holder].add(releaseAmount);
576         
577         return true;
578     }
579     
580     function _autoUnlock(address holder) internal returns(bool) {
581         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
582             if (timelockList[holder][idx]._releaseTime <= now) {
583                 // If lockupinfo was deleted, loop restart at same position.
584                 if( _unlock(holder, idx) ) {
585                     idx -=1;
586                 }
587             }
588         }
589         return true;
590     }
591     
592     /**
593      * @dev Sets the address of the current implementation
594      * @param _newImp address of the new implementation
595      */
596     function _setImplementation(address _newImp) internal {
597         implementation = _newImp;
598     }
599     
600     /**
601      * @dev Fallback function allowing to perform a delegatecall 
602      * to the given implementation. This function will return 
603      * whatever the implementation call returns
604      */
605     function () payable external {
606         address impl = implementation;
607         require(impl != address(0));
608         assembly {
609             /*
610                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
611                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
612                 memory. It's needed because we're going to write the return data of delegatecall to the
613                 free memory slot.
614             */
615             let ptr := mload(0x40)
616             /*
617                 `calldatacopy` is copy calldatasize bytes from calldata
618                 First argument is the destination to which data is copied(ptr)
619                 Second argument specifies the start position of the copied data.
620                     Since calldata is sort of its own unique location in memory,
621                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
622                     That's always going to be the zeroth byte of the function selector.
623                 Third argument, calldatasize, specifies how much data will be copied.
624                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
625             */
626             calldatacopy(ptr, 0, calldatasize)
627             /*
628                 delegatecall params explained:
629                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
630                     us the amount of gas still available to execution
631                 _impl: address of the contract to delegate to
632                 ptr: to pass copied data
633                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
634                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
635                         these are set to 0, 0 so the output data will not be written to memory. The output
636                         data will be read using `returndatasize` and `returdatacopy` instead.
637                 result: This will be 0 if the call fails and 1 if it succeeds
638             */
639             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
640             let size := returndatasize
641             /*
642                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
643                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
644                     the amount of data to copy.
645                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
646             */
647             returndatacopy(ptr, 0, size)
648             
649             /*
650                 if `result` is 0, revert.
651                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
652                 copied to `ptr` from the delegatecall return data
653             */
654             switch result
655             case 0 { revert(ptr, size) }
656             default { return(ptr, size) }
657         }
658     }
659 }