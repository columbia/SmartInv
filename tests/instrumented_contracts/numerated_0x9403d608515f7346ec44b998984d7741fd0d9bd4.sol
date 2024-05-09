1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-22
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23         
24         uint256 c = a * b;
25         require(c / a == b);
26         
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b > 0); // Solidity only automatically asserts when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     
38     return c;
39     }
40     
41     /**
42     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47     
48         return c;
49     }
50     
51     /**
52     * @dev Adds two numbers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57     
58         return c;
59     }
60     
61     /**
62     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
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
76     function add(Role storage role, address account) internal {
77         require(account != address(0));
78         require(!has(role, account));
79         role.bearer[account] = true;
80     }
81     function remove(Role storage role, address account) internal {
82         require(account != address(0));
83         require(has(role, account));
84         role.bearer[account] = false;
85     }
86     function has(Role storage role, address account) internal view returns (bool) {
87         require(account != address(0));
88         return role.bearer[account];
89     }
90 }
91 
92 contract Ownable {
93     address public owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     constructor() public {
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     function isOwner(address account) public view returns (bool) {
107         if( account == owner ){
108             return true;
109         }
110         else {
111             return false;
112         }
113     }
114     function transferOwnership(address newOwner) public onlyOwner {
115         require(newOwner != address(0));
116         emit OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119 }
120 
121 contract AdminRole is Ownable{
122     using Roles for Roles.Role;
123 
124     event AdminAdded(address indexed account);
125     event AdminRemoved(address indexed account);
126 
127     Roles.Role private _admin_list;
128 
129     constructor () internal {
130         _addAdmin(msg.sender);
131     }
132 
133     modifier onlyAdmin() {
134         require(isAdmin(msg.sender)|| isOwner(msg.sender));
135         _;
136     }
137 
138     function isAdmin(address account) public view returns (bool) {
139         return _admin_list.has(account);
140     }
141     function addAdmin(address account) public onlyAdmin {
142         _addAdmin(account);
143     }
144     function removeAdmin(address account) public onlyOwner {
145         _removeAdmin(account);
146     }
147     function renounceAdmin() public {
148         _removeAdmin(msg.sender);
149     }
150     function _addAdmin(address account) internal {
151         _admin_list.add(account);
152         emit AdminAdded(account);
153     }
154     function _removeAdmin(address account) internal {
155         _admin_list.remove(account);
156         emit AdminRemoved(account);
157     }
158 }
159 
160 
161 contract Pausable is AdminRole {
162     event Paused(address account);
163     event Unpaused(address account);
164 
165     bool private _paused;
166 
167     constructor () internal {
168         _paused = false;
169     }
170 
171     /**
172      * @return true if the contract is paused, false otherwise.
173      */
174     function paused() public view returns (bool) {
175         return _paused;
176     }
177 
178     /**
179      * @dev Modifier to make a function callable only when the contract is not paused.
180      */
181     modifier whenNotPaused() {
182         require(!_paused);
183         _;
184     }
185 
186     /**
187      * @dev Modifier to make a function callable only when the contract is paused.
188      */
189     modifier whenPaused() {
190         require(_paused);
191         _;
192     }
193 
194     /**
195      * @dev called by the owner to pause, triggers stopped state
196      */
197     function pause() public onlyAdmin whenNotPaused {
198         _paused = true;
199         emit Paused(msg.sender);
200     }
201 
202     /**
203      * @dev called by the owner to unpause, returns to normal state
204      */
205     function unpause() public onlyAdmin whenPaused {
206         _paused = false;
207         emit Unpaused(msg.sender);
208     }
209 }
210 
211 interface IERC20 {
212     function transfer(address to, uint256 value) external returns (bool);
213     function approve(address spender, uint256 value) external returns (bool);
214     function transferFrom(address from, address to, uint256 value) external returns (bool);
215     function totalSupply() external view returns (uint256);
216     function balanceOf(address who) external view returns (uint256);
217     function allowance(address owner, address spender) external view returns (uint256);
218 
219     event Transfer(address indexed from, address indexed to, uint256 value);
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 contract ERC20 is IERC20 {
224     using SafeMath for uint256;
225 
226     mapping (address => uint256) internal _balances;
227     mapping (address => mapping (address => uint256)) internal _allowed;
228 
229     uint256 private _totalSupply;
230 
231     /**
232     * @dev Total number of tokens in existence
233     */
234     function totalSupply() public view returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239     * @dev Gets the balance of the specified address.
240     * @param owner The address to query the balance of.
241     * @return An uint256 representing the amount owned by the passed address.
242     */
243     function balanceOf(address owner) public view returns (uint256) {
244         return _balances[owner];
245     }
246 
247     /**
248      * @dev Function to check the amount of tokens that an owner allowed to a spender.
249      * @param owner address The address which owns the funds.
250      * @param spender address The address which will spend the funds.
251      * @return A uint256 specifying the amount of tokens still available for the spender.
252      */
253     function allowance(address owner, address spender) public view returns (uint256) {
254         return _allowed[owner][spender];
255     }
256 
257     /**
258     * @dev Transfer token for a specified address
259     * @param to The address to transfer to.
260     * @param value The amount to be transferred.
261     */
262     function transfer(address to, uint256 value) public returns (bool) {
263         _transfer(msg.sender, to, value);
264         return true;
265     }
266 
267     /**
268      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
269      * Beware that changing an allowance with this method brings the risk that someone may use both the old
270      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273      * @param spender The address which will spend the funds.
274      * @param value The amount of tokens to be spent.
275      */
276     function approve(address spender, uint256 value) public returns (bool) {
277         require(spender != address(0));
278 
279         _allowed[msg.sender][spender] = value;
280         emit Approval(msg.sender, spender, value);
281         return true;
282     }
283 
284     /**
285      * @dev Transfer tokens from one address to another.
286      * Note that while this function emits an Approval event, this is not required as per the specification,
287      * and other compliant implementations may not emit the event.
288      * @param from address The address which you want to send tokens from
289      * @param to address The address which you want to transfer to
290      * @param value uint256 the amount of tokens to be transferred
291      */
292     function transferFrom(address from, address to, uint256 value) public returns (bool) {
293         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
294         _transfer(from, to, value);
295         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
296         return true;
297     }
298 
299     /**
300      * @dev Increase the amount of tokens that an owner allowed to a spender.
301      * approve should be called when allowed_[_spender] == 0. To increment
302      * allowed value is better to use this function to avoid 2 calls (and wait until
303      * the first transaction is mined)
304      * From MonolithDAO Token.sol
305      * Emits an Approval event.
306      * @param spender The address which will spend the funds.
307      * @param addedValue The amount of tokens to increase the allowance by.
308      */
309     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
310         require(spender != address(0));
311 
312         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
313         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
314         return true;
315     }
316 
317     /**
318      * @dev Decrease the amount of tokens that an owner allowed to a spender.
319      * approve should be called when allowed_[_spender] == 0. To decrement
320      * allowed value is better to use this function to avoid 2 calls (and wait until
321      * the first transaction is mined)
322      * From MonolithDAO Token.sol
323      * Emits an Approval event.
324      * @param spender The address which will spend the funds.
325      * @param subtractedValue The amount of tokens to decrease the allowance by.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
328         require(spender != address(0));
329 
330         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
331         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332         return true;
333     }
334 
335     /**
336     * @dev Transfer token for a specified addresses
337     * @param from The address to transfer from.
338     * @param to The address to transfer to.
339     * @param value The amount to be transferred.
340     */
341     function _transfer(address from, address to, uint256 value) internal {
342         require(to != address(0));
343 
344         _balances[from] = _balances[from].sub(value);
345         _balances[to] = _balances[to].add(value);
346         emit Transfer(from, to, value);
347     }
348 
349     /**
350      * @dev Internal function that mints an amount of the token and assigns it to
351      * an account. This encapsulates the modification of balances such that the
352      * proper events are emitted.
353      * @param account The account that will receive the created tokens.
354      * @param value The amount that will be created.
355      */
356     function _mint(address account, uint256 value) internal {
357         require(account != address(0));
358 
359         _totalSupply = _totalSupply.add(value);
360         _balances[account] = _balances[account].add(value);
361         emit Transfer(address(0), account, value);
362     }
363 
364     /**
365      * @dev Internal function that burns an amount of the token of a given
366      * account.
367      * @param account The account whose tokens will be burnt.
368      * @param value The amount that will be burnt.
369      */
370     function _burn(address account, uint256 value) internal {
371         require(account != address(0));
372 
373         _totalSupply = _totalSupply.sub(value);
374         _balances[account] = _balances[account].sub(value);
375         emit Transfer(account, address(0), value);
376     }
377 
378     /**
379      * @dev Internal function that burns an amount of the token of a given
380      * account, deducting from the sender's allowance for said account. Uses the
381      * internal burn function.
382      * Emits an Approval event (reflecting the reduced allowance).
383      * @param account The account whose tokens will be burnt.
384      * @param value The amount that will be burnt.
385      */
386     function _burnFrom(address account, uint256 value) internal {
387         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
388         _burn(account, value);
389         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
390     }
391 }
392 
393 contract ERC20Burnable is ERC20 {
394     /**
395      * @dev Burns a specific amount of tokens.
396      * @param value The amount of token to be burned.
397      */
398     function burn(uint256 value) public {
399         _burn(msg.sender, value);
400     }
401 
402     /**
403      * @dev Burns a specific amount of tokens from the target address and decrements allowance
404      * @param from address The address which you want to send tokens from
405      * @param value uint256 The amount of token to be burned
406      */
407     function burnFrom(address from, uint256 value) public {
408         _burnFrom(from, value);
409     }
410 }
411 
412 contract ERC20Pausable is ERC20, Pausable {
413     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
414         return super.transfer(to, value);
415     }
416 
417     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
418         return super.transferFrom(from, to, value);
419     }
420 
421     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
422         return super.approve(spender, value);
423     }
424 
425     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
426         return super.increaseAllowance(spender, addedValue);
427     }
428 
429     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
430         return super.decreaseAllowance(spender, subtractedValue);
431     }
432 }
433 
434 contract ERC20Detailed is IERC20 {
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438 
439     constructor (string memory name, string memory symbol, uint8 decimals) public {
440         _name = name;
441         _symbol = symbol;
442         _decimals = decimals;
443     }
444 
445     /**
446      * @return the name of the token.
447      */
448     function name() public view returns (string memory) {
449         return _name;
450     }
451 
452     /**
453      * @return the symbol of the token.
454      */
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @return the number of decimals of the token.
461      */
462     function decimals() public view returns (uint8) {
463         return _decimals;
464     }
465 }
466 
467 contract QTBK is ERC20Detailed, ERC20Pausable, ERC20Burnable {
468     
469     struct LockInfo {
470         uint256 _releaseTime;
471         uint256 _amount;
472     }
473     
474     address public implementation;
475 
476     mapping (address => LockInfo[]) public timelockList;
477 	mapping (address => bool) public frozenAccount;
478     
479     event Freeze(address indexed holder);
480     event Unfreeze(address indexed holder);
481     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
482     event Unlock(address indexed holder, uint256 value);
483 
484     modifier notFrozen(address _holder) {
485         require(!frozenAccount[_holder]);
486         _;
487     }
488     
489     constructor() ERC20Detailed("Quantbook Token", "QTBK", 18) public  {
490         
491         _mint(msg.sender, 1000000000 * (10 ** 18));
492     }
493     
494     function balanceOf(address owner) public view returns (uint256) {
495         
496         uint256 totalBalance = super.balanceOf(owner);
497         if( timelockList[owner].length >0 ){
498             for(uint i=0; i<timelockList[owner].length;i++){
499                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
500             }
501         }
502         
503         return totalBalance;
504     }
505     
506     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
507         if (timelockList[msg.sender].length > 0 ) {
508             _autoUnlock(msg.sender);            
509         }
510         return super.transfer(to, value);
511     }
512 
513     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
514         if (timelockList[from].length > 0) {
515             _autoUnlock(msg.sender);            
516         }
517         return super.transferFrom(from, to, value);
518     }
519     
520     function freezeAccount(address holder) public onlyAdmin returns (bool) {
521         require(!frozenAccount[holder]);
522         frozenAccount[holder] = true;
523         emit Freeze(holder);
524         return true;
525     }
526 
527     function unfreezeAccount(address holder) public onlyAdmin returns (bool) {
528         require(frozenAccount[holder]);
529         frozenAccount[holder] = false;
530         emit Unfreeze(holder);
531         return true;
532     }
533     
534     function lock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
535         require(_balances[holder] >= value,"There is not enough balance of holder.");
536         _lock(holder,value,releaseTime);
537         
538         return true;
539     }
540     
541     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
542         _transfer(msg.sender, holder, value);
543         _lock(holder,value,releaseTime);
544         return true;
545     }
546     
547     function unlock(address holder, uint256 idx) public onlyAdmin returns (bool) {
548         require( timelockList[holder].length > idx, "There is not lock info.");
549         _unlock(holder,idx);
550         return true;
551     }
552     
553     /**
554      * @dev Upgrades the implementation address
555      * @param _newImplementation address of the new implementation
556      */
557     function upgradeTo(address _newImplementation) public onlyOwner {
558         require(implementation != _newImplementation);
559         _setImplementation(_newImplementation);
560     }
561     
562     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
563         _balances[holder] = _balances[holder].sub(value);
564         timelockList[holder].push( LockInfo(releaseTime, value) );
565         
566         emit Lock(holder, value, releaseTime);
567         return true;
568     }
569     
570     function _unlock(address holder, uint256 idx) internal returns(bool) {
571         LockInfo storage lockinfo = timelockList[holder][idx];
572         uint256 releaseAmount = lockinfo._amount;
573 
574         delete timelockList[holder][idx];
575         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
576         timelockList[holder].length -=1;
577         
578         emit Unlock(holder, releaseAmount);
579         _balances[holder] = _balances[holder].add(releaseAmount);
580         
581         return true;
582     }
583     
584     function _autoUnlock(address holder) internal returns(bool) {
585         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
586             if (timelockList[holder][idx]._releaseTime <= now) {
587                 // If lockupinfo was deleted, loop restart at same position.
588                 if( _unlock(holder, idx) ) {
589                     idx -=1;
590                 }
591             }
592         }
593         return true;
594     }
595     
596     /**
597      * @dev Sets the address of the current implementation
598      * @param _newImp address of the new implementation
599      */
600     function _setImplementation(address _newImp) internal {
601         implementation = _newImp;
602     }
603     
604     /**
605      * @dev Fallback function allowing to perform a delegatecall 
606      * to the given implementation. This function will return 
607      * whatever the implementation call returns
608      */
609     function () payable external {
610         address impl = implementation;
611         require(impl != address(0));
612         assembly {
613             /*
614                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
615                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
616                 memory. It's needed because we're going to write the return data of delegatecall to the
617                 free memory slot.
618             */
619             let ptr := mload(0x40)
620             /*
621                 `calldatacopy` is copy calldatasize bytes from calldata
622                 First argument is the destination to which data is copied(ptr)
623                 Second argument specifies the start position of the copied data.
624                     Since calldata is sort of its own unique location in memory,
625                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
626                     That's always going to be the zeroth byte of the function selector.
627                 Third argument, calldatasize, specifies how much data will be copied.
628                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
629             */
630             calldatacopy(ptr, 0, calldatasize)
631             /*
632                 delegatecall params explained:
633                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
634                     us the amount of gas still available to execution
635                 _impl: address of the contract to delegate to
636                 ptr: to pass copied data
637                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
638                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
639                         these are set to 0, 0 so the output data will not be written to memory. The output
640                         data will be read using `returndatasize` and `returdatacopy` instead.
641                 result: This will be 0 if the call fails and 1 if it succeeds
642             */
643             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
644             let size := returndatasize
645             /*
646                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
647                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
648                     the amount of data to copy.
649                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
650             */
651             returndatacopy(ptr, 0, size)
652             
653             /*
654                 if `result` is 0, revert.
655                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
656                 copied to `ptr` from the delegatecall return data
657             */
658             switch result
659             case 0 { revert(ptr, size) }
660             default { return(ptr, size) }
661         }
662     }
663 }