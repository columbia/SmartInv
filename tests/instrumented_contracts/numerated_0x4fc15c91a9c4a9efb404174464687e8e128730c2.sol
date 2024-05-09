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
156 contract Pausable is AdminRole {
157     event Paused(address account);
158     event Unpaused(address account);
159 
160     bool private _paused;
161 
162     constructor () internal {
163         _paused = false;
164     }
165 
166     /**
167      * @return true if the contract is paused, false otherwise.
168      */
169     function paused() public view returns (bool) {
170         return _paused;
171     }
172 
173     /**
174      * @dev Modifier to make a function callable only when the contract is not paused.
175      */
176     modifier whenNotPaused() {
177         require(!_paused);
178         _;
179     }
180 
181     /**
182      * @dev Modifier to make a function callable only when the contract is paused.
183      */
184     modifier whenPaused() {
185         require(_paused);
186         _;
187     }
188 
189     /**
190      * @dev called by the owner to pause, triggers stopped state
191      */
192     function pause() public onlyAdmin whenNotPaused {
193         _paused = true;
194         emit Paused(msg.sender);
195     }
196 
197     /**
198      * @dev called by the owner to unpause, returns to normal state
199      */
200     function unpause() public onlyAdmin whenPaused {
201         _paused = false;
202         emit Unpaused(msg.sender);
203     }
204 }
205 
206 interface IERC20 {
207     function transfer(address to, uint256 value) external returns (bool);
208     function approve(address spender, uint256 value) external returns (bool);
209     function transferFrom(address from, address to, uint256 value) external returns (bool);
210     function totalSupply() external view returns (uint256);
211     function balanceOf(address who) external view returns (uint256);
212     function allowance(address owner, address spender) external view returns (uint256);
213 
214     event Transfer(address indexed from, address indexed to, uint256 value);
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 contract ERC20 is IERC20 {
219     using SafeMath for uint256;
220 
221     mapping (address => uint256) internal _balances;
222     mapping (address => mapping (address => uint256)) internal _allowed;
223 
224     uint256 private _totalSupply;
225 
226     /**
227     * @dev Total number of tokens in existence
228     */
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234     * @dev Gets the balance of the specified address.
235     * @param owner The address to query the balance of.
236     * @return An uint256 representing the amount owned by the passed address.
237     */
238     function balanceOf(address owner) public view returns (uint256) {
239         return _balances[owner];
240     }
241 
242     /**
243      * @dev Function to check the amount of tokens that an owner allowed to a spender.
244      * @param owner address The address which owns the funds.
245      * @param spender address The address which will spend the funds.
246      * @return A uint256 specifying the amount of tokens still available for the spender.
247      */
248     function allowance(address owner, address spender) public view returns (uint256) {
249         return _allowed[owner][spender];
250     }
251 
252     /**
253     * @dev Transfer token for a specified address
254     * @param to The address to transfer to.
255     * @param value The amount to be transferred.
256     */
257     function transfer(address to, uint256 value) public returns (bool) {
258         _transfer(msg.sender, to, value);
259         return true;
260     }
261 
262     /**
263      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264      * Beware that changing an allowance with this method brings the risk that someone may use both the old
265      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268      * @param spender The address which will spend the funds.
269      * @param value The amount of tokens to be spent.
270      */
271     function approve(address spender, uint256 value) public returns (bool) {
272         require(spender != address(0));
273 
274         _allowed[msg.sender][spender] = value;
275         emit Approval(msg.sender, spender, value);
276         return true;
277     }
278 
279     /**
280      * @dev Transfer tokens from one address to another.
281      * Note that while this function emits an Approval event, this is not required as per the specification,
282      * and other compliant implementations may not emit the event.
283      * @param from address The address which you want to send tokens from
284      * @param to address The address which you want to transfer to
285      * @param value uint256 the amount of tokens to be transferred
286      */
287     function transferFrom(address from, address to, uint256 value) public returns (bool) {
288         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
289         _transfer(from, to, value);
290         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
291         return true;
292     }
293 
294     /**
295      * @dev Increase the amount of tokens that an owner allowed to a spender.
296      * approve should be called when allowed_[_spender] == 0. To increment
297      * allowed value is better to use this function to avoid 2 calls (and wait until
298      * the first transaction is mined)
299      * From MonolithDAO Token.sol
300      * Emits an Approval event.
301      * @param spender The address which will spend the funds.
302      * @param addedValue The amount of tokens to increase the allowance by.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         require(spender != address(0));
306 
307         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
308         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
309         return true;
310     }
311 
312     /**
313      * @dev Decrease the amount of tokens that an owner allowed to a spender.
314      * approve should be called when allowed_[_spender] == 0. To decrement
315      * allowed value is better to use this function to avoid 2 calls (and wait until
316      * the first transaction is mined)
317      * From MonolithDAO Token.sol
318      * Emits an Approval event.
319      * @param spender The address which will spend the funds.
320      * @param subtractedValue The amount of tokens to decrease the allowance by.
321      */
322     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
323         require(spender != address(0));
324 
325         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
326         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
327         return true;
328     }
329 
330     /**
331     * @dev Transfer token for a specified addresses
332     * @param from The address to transfer from.
333     * @param to The address to transfer to.
334     * @param value The amount to be transferred.
335     */
336     function _transfer(address from, address to, uint256 value) internal {
337         require(to != address(0));
338 
339         _balances[from] = _balances[from].sub(value);
340         _balances[to] = _balances[to].add(value);
341         emit Transfer(from, to, value);
342     }
343 
344     /**
345      * @dev Internal function that mints an amount of the token and assigns it to
346      * an account. This encapsulates the modification of balances such that the
347      * proper events are emitted.
348      * @param account The account that will receive the created tokens.
349      * @param value The amount that will be created.
350      */
351     function _mint(address account, uint256 value) internal {
352         require(account != address(0));
353 
354         _totalSupply = _totalSupply.add(value);
355         _balances[account] = _balances[account].add(value);
356         emit Transfer(address(0), account, value);
357     }
358 
359     /**
360      * @dev Internal function that burns an amount of the token of a given
361      * account.
362      * @param account The account whose tokens will be burnt.
363      * @param value The amount that will be burnt.
364      */
365     function _burn(address account, uint256 value) internal {
366         require(account != address(0));
367 
368         _totalSupply = _totalSupply.sub(value);
369         _balances[account] = _balances[account].sub(value);
370         emit Transfer(account, address(0), value);
371     }
372 
373     /**
374      * @dev Internal function that burns an amount of the token of a given
375      * account, deducting from the sender's allowance for said account. Uses the
376      * internal burn function.
377      * Emits an Approval event (reflecting the reduced allowance).
378      * @param account The account whose tokens will be burnt.
379      * @param value The amount that will be burnt.
380      */
381     function _burnFrom(address account, uint256 value) internal {
382         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
383         _burn(account, value);
384         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
385     }
386 }
387 
388 contract ERC20Burnable is ERC20 {
389     /**
390      * @dev Burns a specific amount of tokens.
391      * @param value The amount of token to be burned.
392      */
393     function burn(uint256 value) public {
394         _burn(msg.sender, value);
395     }
396 
397     /**
398      * @dev Burns a specific amount of tokens from the target address and decrements allowance
399      * @param from address The address which you want to send tokens from
400      * @param value uint256 The amount of token to be burned
401      */
402     function burnFrom(address from, uint256 value) public {
403         _burnFrom(from, value);
404     }
405 }
406 
407 contract ERC20Pausable is ERC20, Pausable {
408     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
409         return super.transfer(to, value);
410     }
411 
412     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
413         return super.transferFrom(from, to, value);
414     }
415 
416     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
417         return super.approve(spender, value);
418     }
419 
420     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
421         return super.increaseAllowance(spender, addedValue);
422     }
423 
424     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
425         return super.decreaseAllowance(spender, subtractedValue);
426     }
427 }
428 
429 contract ERC20Detailed is IERC20 {
430     string private _name;
431     string private _symbol;
432     uint8 private _decimals;
433 
434     constructor (string memory name, string memory symbol, uint8 decimals) public {
435         _name = name;
436         _symbol = symbol;
437         _decimals = decimals;
438     }
439 
440     /**
441      * @return the name of the token.
442      */
443     function name() public view returns (string memory) {
444         return _name;
445     }
446 
447     /**
448      * @return the symbol of the token.
449      */
450     function symbol() public view returns (string memory) {
451         return _symbol;
452     }
453 
454     /**
455      * @return the number of decimals of the token.
456      */
457     function decimals() public view returns (uint8) {
458         return _decimals;
459     }
460 }
461 
462 contract STAT is ERC20Detailed, ERC20Pausable, ERC20Burnable {
463     
464     struct LockInfo {
465         uint256 _releaseTime;
466         uint256 _amount;
467     }
468     
469     address public implementation;
470 
471     mapping (address => LockInfo[]) public timelockList;
472 	mapping (address => bool) public frozenAccount;
473     
474     event Freeze(address indexed holder);
475     event Unfreeze(address indexed holder);
476     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
477     event Unlock(address indexed holder, uint256 value);
478 
479     modifier notFrozen(address _holder) {
480         require(!frozenAccount[_holder]);
481         _;
482     }
483     
484     constructor() ERC20Detailed("STAT", "STAT", 18) public  {
485         
486         _mint(msg.sender, 100000000 * (10 ** 18));
487     }
488     
489     function balanceOf(address owner) public view returns (uint256) {
490         
491         uint256 totalBalance = super.balanceOf(owner);
492         if( timelockList[owner].length >0 ){
493             for(uint i=0; i<timelockList[owner].length;i++){
494                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
495             }
496         }
497         
498         return totalBalance;
499     }
500     
501     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
502         if (timelockList[msg.sender].length > 0 ) {
503             _autoUnlock(msg.sender);            
504         }
505         return super.transfer(to, value);
506     }
507 
508     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
509         if (timelockList[from].length > 0) {
510             _autoUnlock(from);            
511         }
512         return super.transferFrom(from, to, value);
513     }
514     
515     function freezeAccount(address holder) public onlyAdmin returns (bool) {
516         require(!frozenAccount[holder]);
517         frozenAccount[holder] = true;
518         emit Freeze(holder);
519         return true;
520     }
521 
522     function unfreezeAccount(address holder) public onlyAdmin returns (bool) {
523         require(frozenAccount[holder]);
524         frozenAccount[holder] = false;
525         emit Unfreeze(holder);
526         return true;
527     }
528     
529     function lock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
530         require(_balances[holder] >= value,"There is not enough balance of holder.");
531         _lock(holder,value,releaseTime);
532         
533         return true;
534     }
535     
536     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyAdmin returns (bool) {
537         _transfer(msg.sender, holder, value);
538         _lock(holder,value,releaseTime);
539         return true;
540     }
541     
542     function unlock(address holder, uint256 idx) public onlyAdmin returns (bool) {
543         require( timelockList[holder].length > idx, "There is not lock info.");
544         _unlock(holder,idx);
545         return true;
546     }
547     
548     
549     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
550         _balances[holder] = _balances[holder].sub(value);
551         timelockList[holder].push( LockInfo(releaseTime, value) );
552         
553         emit Lock(holder, value, releaseTime);
554         return true;
555     }
556     
557     function _unlock(address holder, uint256 idx) internal returns(bool) {
558         LockInfo storage lockinfo = timelockList[holder][idx];
559         uint256 releaseAmount = lockinfo._amount;
560 
561         delete timelockList[holder][idx];
562         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
563         timelockList[holder].length -=1;
564         
565         emit Unlock(holder, releaseAmount);
566         _balances[holder] = _balances[holder].add(releaseAmount);
567         
568         return true;
569     }
570     
571     function _autoUnlock(address holder) internal returns(bool) {
572         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
573             if (timelockList[holder][idx]._releaseTime <= now) {
574                 // If lockupinfo was deleted, loop restart at same position.
575                 if( _unlock(holder, idx) ) {
576                     idx -=1;
577                 }
578             }
579         }
580         return true;
581     }
582     
583     
584     /**
585      * @dev Fallback function allowing to perform a delegatecall 
586      * to the given implementation. This function will return 
587      * whatever the implementation call returns
588      */
589     function () payable external {
590         address impl = implementation;
591         require(impl != address(0));
592         assembly {
593             /*
594                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
595                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
596                 memory. It's needed because we're going to write the return data of delegatecall to the
597                 free memory slot.
598             */
599             let ptr := mload(0x40)
600             /*
601                 `calldatacopy` is copy calldatasize bytes from calldata
602                 First argument is the destination to which data is copied(ptr)
603                 Second argument specifies the start position of the copied data.
604                     Since calldata is sort of its own unique location in memory,
605                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
606                     That's always going to be the zeroth byte of the function selector.
607                 Third argument, calldatasize, specifies how much data will be copied.
608                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
609             */
610             calldatacopy(ptr, 0, calldatasize)
611             /*
612                 delegatecall params explained:
613                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
614                     us the amount of gas still available to execution
615                 _impl: address of the contract to delegate to
616                 ptr: to pass copied data
617                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
618                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
619                         these are set to 0, 0 so the output data will not be written to memory. The output
620                         data will be read using `returndatasize` and `returdatacopy` instead.
621                 result: This will be 0 if the call fails and 1 if it succeeds
622             */
623             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
624             let size := returndatasize
625             /*
626                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
627                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
628                     the amount of data to copy.
629                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
630             */
631             returndatacopy(ptr, 0, size)
632             
633             /*
634                 if `result` is 0, revert.
635                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
636                 copied to `ptr` from the delegatecall return data
637             */
638             switch result
639             case 0 { revert(ptr, size) }
640             default { return(ptr, size) }
641         }
642     }
643 }