1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.4;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) internal _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: contracts\tibota.sol
285 
286 pragma solidity 0.5.4;
287 
288 
289 contract tibota is ERC20 {
290     string public constant name = "TIBOT-A"; // solium-disable-line uppercase
291     string public constant symbol = "TBA"; // solium-disable-line uppercase
292     uint8 public constant decimals = 18; // solium-disable-line uppercase
293     uint256 public constant initialSupply = 1000000000 * (10 ** uint256(decimals));
294     
295     constructor() public {
296         super._mint(msg.sender, initialSupply);
297         owner = msg.sender;
298     }
299 
300     //ownership
301     address public owner;
302 
303     event OwnershipRenounced(address indexed previousOwner);
304     event OwnershipTransferred(
305     address indexed previousOwner,
306     address indexed newOwner
307     );
308 
309     modifier onlyOwner() {
310         require(msg.sender == owner, "Not owner");
311         _;
312     }
313 
314  /**
315    * @dev Allows the current owner to relinquish control of the contract.
316    * @notice Renouncing to ownership will leave the contract without an owner.
317    * It will not be possible to call the functions with the `onlyOwner`
318    * modifier anymore.
319    */
320     function renounceOwnership() public onlyOwner {
321         emit OwnershipRenounced(owner);
322         owner = address(0);
323     }
324 
325   /**
326    * @dev Allows the current owner to transfer control of the contract to a newOwner.
327    * @param _newOwner The address to transfer ownership to.
328    */
329     function transferOwnership(address _newOwner) public onlyOwner {
330         _transferOwnership(_newOwner);
331     }
332 
333   /**
334    * @dev Transfers control of the contract to a newOwner.
335    * @param _newOwner The address to transfer ownership to.
336    */
337     function _transferOwnership(address _newOwner) internal {
338         require(_newOwner != address(0), "Already owner");
339         emit OwnershipTransferred(owner, _newOwner);
340         owner = _newOwner;
341     }
342 
343     //pausable
344     event Pause();
345     event Unpause();
346 
347     bool public paused = false;
348     
349     /**
350     * @dev Modifier to make a function callable only when the contract is not paused.
351     */
352     modifier whenNotPaused() {
353         require(!paused, "Paused by owner");
354         _;
355     }
356 
357     /**
358     * @dev Modifier to make a function callable only when the contract is paused.
359     */
360     modifier whenPaused() {
361         require(paused, "Not paused now");
362         _;
363     }
364 
365     /**
366     * @dev called by the owner to pause, triggers stopped state
367     */
368     function pause() public onlyOwner whenNotPaused {
369         paused = true;
370         emit Pause();
371     }
372 
373     /**
374     * @dev called by the owner to unpause, returns to normal state
375     */
376     function unpause() public onlyOwner whenPaused {
377         paused = false;
378         emit Unpause();
379     }
380 
381     //freezable
382     event Frozen(address target);
383     event Unfrozen(address target);
384 
385     mapping(address => bool) internal freezes;
386 
387     modifier whenNotFrozen() {
388         require(!freezes[msg.sender], "Sender account is locked.");
389         _;
390     }
391 
392     function freeze(address _target) public onlyOwner {
393         freezes[_target] = true;
394         emit Frozen(_target);
395     }
396 
397     function unfreeze(address _target) public onlyOwner {
398         freezes[_target] = false;
399         emit Unfrozen(_target);
400     }
401 
402     function isFrozen(address _target) public view returns (bool) {
403         return freezes[_target];
404     }
405 
406     function transfer(
407         address _to,
408         uint256 _value
409     )
410       public
411       whenNotFrozen
412       whenNotPaused
413       returns (bool)
414     {
415         releaseLock(msg.sender);
416         return super.transfer(_to, _value);
417     }
418 
419     function transferFrom(
420         address _from,
421         address _to,
422         uint256 _value
423     )
424       public
425       whenNotPaused
426       returns (bool)
427     {
428         require(!freezes[_from], "From account is locked.");
429         releaseLock(_from);
430         return super.transferFrom(_from, _to, _value);
431     }
432 
433     //mintable
434     event Mint(address indexed to, uint256 amount);
435 
436     function mint(
437         address _to,
438         uint256 _amount
439     )
440       public
441       onlyOwner
442       returns (bool)
443     {
444         super._mint(_to, _amount);
445         emit Mint(_to, _amount);
446         return true;
447     }
448 
449     //burnable
450     event Burn(address indexed burner, uint256 value);
451 
452     function burn(address _who, uint256 _value) public onlyOwner {
453         require(_value <= super.balanceOf(_who), "Balance is too small.");
454 
455         _burn(_who, _value);
456         emit Burn(_who, _value);
457     }
458 
459     //lockable
460     struct LockInfo {
461         uint256 releaseTime;
462         uint256 balance;
463     }
464     mapping(address => LockInfo[]) internal lockInfo;
465 
466     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
467     event Unlock(address indexed holder, uint256 value);
468 
469     function balanceOf(address _holder) public view returns (uint256 balance) {
470         uint256 lockedBalance = 0;
471         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
472             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
473         }
474         return super.balanceOf(_holder).add(lockedBalance);
475     }
476 
477     function releaseLock(address _holder) internal {
478 
479         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
480             if (lockInfo[_holder][i].releaseTime <= now) {
481                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
482                 emit Unlock(_holder, lockInfo[_holder][i].balance);
483                 lockInfo[_holder][i].balance = 0;
484 
485                 if (i != lockInfo[_holder].length - 1) {
486                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
487                     i--;
488                 }
489                 lockInfo[_holder].length--;
490 
491             }
492         }
493     }
494     function lockCount(address _holder) public view returns (uint256) {
495         return lockInfo[_holder].length;
496     }
497     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
498         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
499     }
500 
501     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
502         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
503         _balances[_holder] = _balances[_holder].sub(_amount);
504         lockInfo[_holder].push(
505             LockInfo(_releaseTime, _amount)
506         );
507         emit Lock(_holder, _amount, _releaseTime);
508     }
509 
510     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
511         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
512         _balances[_holder] = _balances[_holder].sub(_amount);
513         lockInfo[_holder].push(
514             LockInfo(now + _afterTime, _amount)
515         );
516         emit Lock(_holder, _amount, now + _afterTime);
517     }
518 
519     function unlock(address _holder, uint256 i) public onlyOwner {
520         require(i < lockInfo[_holder].length, "No lock information.");
521 
522         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
523         emit Unlock(_holder, lockInfo[_holder][i].balance);
524         lockInfo[_holder][i].balance = 0;
525 
526         if (i != lockInfo[_holder].length - 1) {
527             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
528         }
529         lockInfo[_holder].length--;
530     }
531 
532     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
533         require(_to != address(0), "wrong address");
534         require(_value <= super.balanceOf(owner), "Not enough balance");
535 
536         _balances[owner] = _balances[owner].sub(_value);
537         lockInfo[_to].push(
538             LockInfo(_releaseTime, _value)
539         );
540         emit Transfer(owner, _to, _value);
541         emit Lock(_to, _value, _releaseTime);
542 
543         return true;
544     }
545 
546     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
547         require(_to != address(0), "wrong address");
548         require(_value <= super.balanceOf(owner), "Not enough balance");
549 
550         _balances[owner] = _balances[owner].sub(_value);
551         lockInfo[_to].push(
552             LockInfo(now + _afterTime, _value)
553         );
554         emit Transfer(owner, _to, _value);
555         emit Lock(_to, _value, now + _afterTime);
556 
557         return true;
558     }
559 
560     function currentTime() public view returns (uint256) {
561         return now;
562     }
563 
564     function afterTime(uint256 _value) public view returns (uint256) {
565         return now + _value;
566     }
567 }