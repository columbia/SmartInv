1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-03-22
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, reverts on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24         if (a == 0) {
25             return 0;
26         }
27         
28         uint256 c = a * b;
29         require(c / a == b);
30         
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     
42     return c;
43     }
44     
45     /**
46     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47     */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a);
50         uint256 c = a - b;
51     
52         return c;
53     }
54     
55     /**
56     * @dev Adds two numbers, reverts on overflow.
57     */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61     
62         return c;
63     }
64     
65     /**
66     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67     * reverts when dividing by zero.
68     */
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b != 0);
71         return a % b;
72     }
73 }
74 
75 library Roles {
76     struct Role {
77         mapping (address => bool) bearer;
78     }
79 
80     function add(Role storage role, address account) internal {
81         require(account != address(0));
82         require(!has(role, account));
83         role.bearer[account] = true;
84     }
85     function remove(Role storage role, address account) internal {
86         require(account != address(0));
87         require(has(role, account));
88         role.bearer[account] = false;
89     }
90     function has(Role storage role, address account) internal view returns (bool) {
91         require(account != address(0));
92         return role.bearer[account];
93     }
94 }
95 
96 contract Ownable {
97     address public owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     constructor() public {
102         owner = msg.sender;
103     }
104 
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     function isOwner(address account) public view returns (bool) {
111         if( account == owner ){
112             return true;
113         }
114         else {
115             return false;
116         }
117     }
118     function transferOwnership(address newOwner) public onlyOwner {
119         require(newOwner != address(0));
120         emit OwnershipTransferred(owner, newOwner);
121         owner = newOwner;
122     }
123 }
124 
125 contract AdminRole is Ownable{
126     using Roles for Roles.Role;
127 
128     event AdminAdded(address indexed account);
129     event AdminRemoved(address indexed account);
130 
131     Roles.Role private _admin_list;
132 
133     constructor () internal {
134         _addAdmin(msg.sender);
135     }
136 
137     modifier onlyAdmin() {
138         require(isAdmin(msg.sender)|| isOwner(msg.sender));
139         _;
140     }
141 
142     function isAdmin(address account) public view returns (bool) {
143         return _admin_list.has(account);
144     }
145     function addAdmin(address account) public onlyAdmin {
146         _addAdmin(account);
147     }
148     function removeAdmin(address account) public onlyOwner {
149         _removeAdmin(account);
150     }
151     function renounceAdmin() public {
152         _removeAdmin(msg.sender);
153     }
154     function _addAdmin(address account) internal {
155         _admin_list.add(account);
156         emit AdminAdded(account);
157     }
158     function _removeAdmin(address account) internal {
159         _admin_list.remove(account);
160         emit AdminRemoved(account);
161     }
162 }
163 
164 
165 contract Pausable is AdminRole {
166     event Paused(address account);
167     event Unpaused(address account);
168 
169     bool private _paused;
170 
171     constructor () internal {
172         _paused = false;
173     }
174 
175     /**
176      * @return true if the contract is paused, false otherwise.
177      */
178     function paused() public view returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is not paused.
184      */
185     modifier whenNotPaused() {
186         require(!_paused);
187         _;
188     }
189 
190     /**
191      * @dev Modifier to make a function callable only when the contract is paused.
192      */
193     modifier whenPaused() {
194         require(_paused);
195         _;
196     }
197 
198     /**
199      * @dev called by the owner to pause, triggers stopped state
200      */
201     function pause() public onlyAdmin whenNotPaused {
202         _paused = true;
203         emit Paused(msg.sender);
204     }
205 
206     /**
207      * @dev called by the owner to unpause, returns to normal state
208      */
209     function unpause() public onlyAdmin whenPaused {
210         _paused = false;
211         emit Unpaused(msg.sender);
212     }
213 }
214 
215 interface IERC20 {
216     function transfer(address to, uint256 value) external returns (bool);
217     function approve(address spender, uint256 value) external returns (bool);
218     function transferFrom(address from, address to, uint256 value) external returns (bool);
219     function totalSupply() external view returns (uint256);
220     function balanceOf(address who) external view returns (uint256);
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     event Transfer(address indexed from, address indexed to, uint256 value);
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 contract ERC20 is IERC20 {
228     using SafeMath for uint256;
229 
230     mapping (address => uint256) internal _balances;
231     mapping (address => mapping (address => uint256)) internal _allowed;
232 
233     uint256 private _totalSupply;
234 
235     /**
236     * @dev Total number of tokens in existence
237     */
238     function totalSupply() public view returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243     * @dev Gets the balance of the specified address.
244     * @param owner The address to query the balance of.
245     * @return An uint256 representing the amount owned by the passed address.
246     */
247     function balanceOf(address owner) public view returns (uint256) {
248         return _balances[owner];
249     }
250 
251     /**
252      * @dev Function to check the amount of tokens that an owner allowed to a spender.
253      * @param owner address The address which owns the funds.
254      * @param spender address The address which will spend the funds.
255      * @return A uint256 specifying the amount of tokens still available for the spender.
256      */
257     function allowance(address owner, address spender) public view returns (uint256) {
258         return _allowed[owner][spender];
259     }
260 
261     /**
262     * @dev Transfer token for a specified address
263     * @param to The address to transfer to.
264     * @param value The amount to be transferred.
265     */
266     function transfer(address to, uint256 value) public returns (bool) {
267         _transfer(msg.sender, to, value);
268         return true;
269     }
270 
271     /**
272      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273      * Beware that changing an allowance with this method brings the risk that someone may use both the old
274      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      * @param spender The address which will spend the funds.
278      * @param value The amount of tokens to be spent.
279      */
280     function approve(address spender, uint256 value) public returns (bool) {
281         require(spender != address(0));
282 
283         _allowed[msg.sender][spender] = value;
284         emit Approval(msg.sender, spender, value);
285         return true;
286     }
287 
288     /**
289      * @dev Transfer tokens from one address to another.
290      * Note that while this function emits an Approval event, this is not required as per the specification,
291      * and other compliant implementations may not emit the event.
292      * @param from address The address which you want to send tokens from
293      * @param to address The address which you want to transfer to
294      * @param value uint256 the amount of tokens to be transferred
295      */
296     function transferFrom(address from, address to, uint256 value) public returns (bool) {
297         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
298         _transfer(from, to, value);
299         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
300         return true;
301     }
302 
303     /**
304      * @dev Increase the amount of tokens that an owner allowed to a spender.
305      * approve should be called when allowed_[_spender] == 0. To increment
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * Emits an Approval event.
310      * @param spender The address which will spend the funds.
311      * @param addedValue The amount of tokens to increase the allowance by.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
314         require(spender != address(0));
315 
316         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
317         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
318         return true;
319     }
320 
321     /**
322      * @dev Decrease the amount of tokens that an owner allowed to a spender.
323      * approve should be called when allowed_[_spender] == 0. To decrement
324      * allowed value is better to use this function to avoid 2 calls (and wait until
325      * the first transaction is mined)
326      * From MonolithDAO Token.sol
327      * Emits an Approval event.
328      * @param spender The address which will spend the funds.
329      * @param subtractedValue The amount of tokens to decrease the allowance by.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
332         require(spender != address(0));
333 
334         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
335         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
336         return true;
337     }
338 
339     /**
340     * @dev Transfer token for a specified addresses
341     * @param from The address to transfer from.
342     * @param to The address to transfer to.
343     * @param value The amount to be transferred.
344     */
345     function _transfer(address from, address to, uint256 value) internal {
346         require(to != address(0));
347 
348         _balances[from] = _balances[from].sub(value);
349         _balances[to] = _balances[to].add(value);
350         emit Transfer(from, to, value);
351     }
352 
353     /**
354      * @dev Internal function that mints an amount of the token and assigns it to
355      * an account. This encapsulates the modification of balances such that the
356      * proper events are emitted.
357      * @param account The account that will receive the created tokens.
358      * @param value The amount that will be created.
359      */
360     function _mint(address account, uint256 value) internal {
361         require(account != address(0));
362 
363         _totalSupply = _totalSupply.add(value);
364         _balances[account] = _balances[account].add(value);
365         emit Transfer(address(0), account, value);
366     }
367 
368     /**
369      * @dev Internal function that burns an amount of the token of a given
370      * account.
371      * @param account The account whose tokens will be burnt.
372      * @param value The amount that will be burnt.
373      */
374     function _burn(address account, uint256 value) internal {
375         require(account != address(0));
376 
377         _totalSupply = _totalSupply.sub(value);
378         _balances[account] = _balances[account].sub(value);
379         emit Transfer(account, address(0), value);
380     }
381 
382     /**
383      * @dev Internal function that burns an amount of the token of a given
384      * account, deducting from the sender's allowance for said account. Uses the
385      * internal burn function.
386      * Emits an Approval event (reflecting the reduced allowance).
387      * @param account The account whose tokens will be burnt.
388      * @param value The amount that will be burnt.
389      */
390     function _burnFrom(address account, uint256 value) internal {
391         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
392         _burn(account, value);
393         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
394     }
395 }
396 
397 contract ERC20Burnable is ERC20 {
398     /**
399      * @dev Burns a specific amount of tokens.
400      * @param value The amount of token to be burned.
401      */
402     function burn(uint256 value) public {
403         _burn(msg.sender, value);
404     }
405 
406     /**
407      * @dev Burns a specific amount of tokens from the target address and decrements allowance
408      * @param from address The address which you want to send tokens from
409      * @param value uint256 The amount of token to be burned
410      */
411     function burnFrom(address from, uint256 value) public {
412         _burnFrom(from, value);
413     }
414 }
415 
416 contract ERC20Pausable is ERC20, Pausable {
417     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
418         return super.transfer(to, value);
419     }
420 
421     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
422         return super.transferFrom(from, to, value);
423     }
424 
425     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
426         return super.approve(spender, value);
427     }
428 
429     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
430         return super.increaseAllowance(spender, addedValue);
431     }
432 
433     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
434         return super.decreaseAllowance(spender, subtractedValue);
435     }
436 }
437 
438 contract ERC20Detailed is IERC20 {
439     string private _name;
440     string private _symbol;
441     uint8 private _decimals;
442 
443     constructor (string memory name, string memory symbol, uint8 decimals) public {
444         _name = name;
445         _symbol = symbol;
446         _decimals = decimals;
447     }
448 
449     /**
450      * @return the name of the token.
451      */
452     function name() public view returns (string memory) {
453         return _name;
454     }
455 
456     /**
457      * @return the symbol of the token.
458      */
459     function symbol() public view returns (string memory) {
460         return _symbol;
461     }
462 
463     /**
464      * @return the number of decimals of the token.
465      */
466     function decimals() public view returns (uint8) {
467         return _decimals;
468     }
469 }
470 
471 contract WLL is ERC20Detailed, ERC20Pausable, ERC20Burnable {
472     
473     struct LockInfo {
474         uint256 _releaseTime;
475         uint256 _amount;
476     }
477     
478     address public implementation;
479 
480     mapping (address => LockInfo[]) public timelockList;
481 	mapping (address => bool) public frozenAccount;
482     
483     event Freeze(address indexed holder);
484     event Unfreeze(address indexed holder);
485     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
486     event Unlock(address indexed holder, uint256 value);
487 
488     modifier notFrozen(address _holder) {
489         require(!frozenAccount[_holder]);
490         _;
491     }
492     
493     constructor() ERC20Detailed("Wellda Token", "WLL", 18) public  {
494         
495         _mint(msg.sender, 1000000000 * (10 ** 18));
496     }
497     
498     function balanceOf(address owner) public view returns (uint256) {
499         
500         uint256 totalBalance = super.balanceOf(owner);
501         if( timelockList[owner].length >0 ){
502             for(uint i=0; i<timelockList[owner].length;i++){
503                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
504             }
505         }
506         
507         return totalBalance;
508     }
509     
510     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
511         if (timelockList[msg.sender].length > 0 ) {
512             _autoUnlock(msg.sender);            
513         }
514         return super.transfer(to, value);
515     }
516 
517     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
518         if (timelockList[from].length > 0) {
519             _autoUnlock(from);            
520         }
521         return super.transferFrom(from, to, value);
522     }
523     
524     function freezeAccount(address holder) public onlyAdmin returns (bool) {
525         require(!frozenAccount[holder]);
526         frozenAccount[holder] = true;
527         emit Freeze(holder);
528         return true;
529     }
530 
531     function unfreezeAccount(address holder) public onlyAdmin returns (bool) {
532         require(frozenAccount[holder]);
533         frozenAccount[holder] = false;
534         emit Unfreeze(holder);
535         return true;
536     }
537     
538     function lock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
539         require(_balances[holder] >= value,"There is not enough balance of holder.");
540         _lock(holder,value,releaseTime);
541         
542         return true;
543     }
544     
545     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
546         _transfer(msg.sender, holder, value);
547         _lock(holder,value,releaseTime);
548         return true;
549     }
550     
551     function unlock(address holder, uint256 idx) public onlyAdmin returns (bool) {
552         require( timelockList[holder].length > idx, "There is not lock info.");
553         _unlock(holder,idx);
554         return true;
555     }
556     
557     /**
558      * @dev Upgrades the implementation address
559      * @param _newImplementation address of the new implementation
560      */
561     function upgradeTo(address _newImplementation) public onlyOwner {
562         require(implementation != _newImplementation);
563         _setImplementation(_newImplementation);
564     }
565     
566     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
567         _balances[holder] = _balances[holder].sub(value);
568         timelockList[holder].push( LockInfo(releaseTime, value) );
569         
570         emit Lock(holder, value, releaseTime);
571         return true;
572     }
573     
574     function _unlock(address holder, uint256 idx) internal returns(bool) {
575         LockInfo storage lockinfo = timelockList[holder][idx];
576         uint256 releaseAmount = lockinfo._amount;
577 
578         delete timelockList[holder][idx];
579         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
580         timelockList[holder].length -=1;
581         
582         emit Unlock(holder, releaseAmount);
583         _balances[holder] = _balances[holder].add(releaseAmount);
584         
585         return true;
586     }
587     
588     function _autoUnlock(address holder) internal returns(bool) {
589         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
590             if (timelockList[holder][idx]._releaseTime <= now) {
591                 // If lockupinfo was deleted, loop restart at same position.
592                 if( _unlock(holder, idx) ) {
593                     idx -=1;
594                 }
595             }
596         }
597         return true;
598     }
599     
600     /**
601      * @dev Sets the address of the current implementation
602      * @param _newImp address of the new implementation
603      */
604     function _setImplementation(address _newImp) internal {
605         implementation = _newImp;
606     }
607     
608     /**
609      * @dev Fallback function allowing to perform a delegatecall 
610      * to the given implementation. This function will return 
611      * whatever the implementation call returns
612      */
613     function () payable external {
614         address impl = implementation;
615         require(impl != address(0));
616         assembly {
617             /*
618                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
619                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
620                 memory. It's needed because we're going to write the return data of delegatecall to the
621                 free memory slot.
622             */
623             let ptr := mload(0x40)
624             /*
625                 `calldatacopy` is copy calldatasize bytes from calldata
626                 First argument is the destination to which data is copied(ptr)
627                 Second argument specifies the start position of the copied data.
628                     Since calldata is sort of its own unique location in memory,
629                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
630                     That's always going to be the zeroth byte of the function selector.
631                 Third argument, calldatasize, specifies how much data will be copied.
632                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
633             */
634             calldatacopy(ptr, 0, calldatasize)
635             /*
636                 delegatecall params explained:
637                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
638                     us the amount of gas still available to execution
639                 _impl: address of the contract to delegate to
640                 ptr: to pass copied data
641                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
642                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
643                         these are set to 0, 0 so the output data will not be written to memory. The output
644                         data will be read using `returndatasize` and `returdatacopy` instead.
645                 result: This will be 0 if the call fails and 1 if it succeeds
646             */
647             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
648             let size := returndatasize
649             /*
650                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
651                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
652                     the amount of data to copy.
653                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
654             */
655             returndatacopy(ptr, 0, size)
656             
657             /*
658                 if `result` is 0, revert.
659                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
660                 copied to `ptr` from the delegatecall return data
661             */
662             switch result
663             case 0 { revert(ptr, size) }
664             default { return(ptr, size) }
665         }
666     }
667 }