1 pragma solidity ^0.5.4;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
27 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) internal _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 // File: contracts\mine.sol
279 
280 contract MineBee is ERC20 {
281     string public constant name = "MineBee"; // solium-disable-line uppercase
282     string public constant symbol = "MB"; // solium-disable-line uppercase
283     uint8 public constant decimals = 18; // solium-disable-line uppercase
284     uint256 public constant initialSupply = 5000000000 * (10 ** uint256(decimals));
285     
286     constructor() public {
287         super._mint(msg.sender, initialSupply);
288         owner = msg.sender;
289     }
290 
291     //ownership
292     address public owner;
293 
294     event OwnershipRenounced(address indexed previousOwner);
295     event OwnershipTransferred(
296     address indexed previousOwner,
297     address indexed newOwner
298     );
299 
300     modifier onlyOwner() {
301         require(msg.sender == owner, "Not owner");
302         _;
303     }
304 
305   /**
306    * @dev Allows the current owner to relinquish control of the contract.
307    * @notice Renouncing to ownership will leave the contract without an owner.
308    * It will not be possible to call the functions with the `onlyOwner`
309    * modifier anymore.
310    */
311     function renounceOwnership() public onlyOwner {
312         emit OwnershipRenounced(owner);
313         owner = address(0);
314     }
315 
316   /**
317    * @dev Allows the current owner to transfer control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320     function transferOwnership(address _newOwner) public onlyOwner {
321         _transferOwnership(_newOwner);
322     }
323 
324   /**
325    * @dev Transfers control of the contract to a newOwner.
326    * @param _newOwner The address to transfer ownership to.
327    */
328     function _transferOwnership(address _newOwner) internal {
329         require(_newOwner != address(0), "Already owner");
330         emit OwnershipTransferred(owner, _newOwner);
331         owner = _newOwner;
332     }
333 
334     //pausable
335     event Pause();
336     event Unpause();
337 
338     bool public paused = false;
339     
340     /**
341     * @dev Modifier to make a function callable only when the contract is not paused.
342     */
343     modifier whenNotPaused() {
344         require(!paused, "Paused by owner");
345         _;
346     }
347 
348     /**
349     * @dev Modifier to make a function callable only when the contract is paused.
350     */
351     modifier whenPaused() {
352         require(paused, "Not paused now");
353         _;
354     }
355 
356     /**
357     * @dev called by the owner to pause, triggers stopped state
358     */
359     function pause() public onlyOwner whenNotPaused {
360         paused = true;
361         emit Pause();
362     }
363 
364     /**
365     * @dev called by the owner to unpause, returns to normal state
366     */
367     function unpause() public onlyOwner whenPaused {
368         paused = false;
369         emit Unpause();
370     }
371 
372     //freezable
373     event Frozen(address target);
374     event Unfrozen(address target);
375 
376     mapping(address => bool) internal freezes;
377 
378     modifier whenNotFrozen() {
379         require(!freezes[msg.sender], "Sender account is locked.");
380         _;
381     }
382 
383     function freeze(address _target) public onlyOwner {
384         freezes[_target] = true;
385         emit Frozen(_target);
386     }
387 
388     function unfreeze(address _target) public onlyOwner {
389         freezes[_target] = false;
390         emit Unfrozen(_target);
391     }
392 
393     function isFrozen(address _target) public view returns (bool) {
394         return freezes[_target];
395     }
396 
397     function transfer(
398         address _to,
399         uint256 _value
400     )
401       public
402       whenNotFrozen
403       whenNotPaused
404       returns (bool)
405     {
406         releaseLock(msg.sender);
407         return super.transfer(_to, _value);
408     }
409 
410     function transferFrom(
411         address _from,
412         address _to,
413         uint256 _value
414     )
415       public
416       whenNotPaused
417       returns (bool)
418     {
419         require(!freezes[_from], "From account is locked.");
420         releaseLock(_from);
421         return super.transferFrom(_from, _to, _value);
422     }
423 
424     //mintable
425     event Mint(address indexed to, uint256 amount);
426 
427     function mint(
428         address _to,
429         uint256 _amount
430     )
431       public
432       onlyOwner
433       returns (bool)
434     {
435         super._mint(_to, _amount);
436         emit Mint(_to, _amount);
437         return true;
438     }
439 
440     //burnable
441     event Burn(address indexed burner, uint256 value);
442 
443     function burn(address _who, uint256 _value) public onlyOwner {
444         require(_value <= super.balanceOf(_who), "Balance is too small.");
445 
446         _burn(_who, _value);
447         emit Burn(_who, _value);
448     }
449 
450     //lockable
451     struct LockInfo {
452         uint256 releaseTime;
453         uint256 balance;
454     }
455     mapping(address => LockInfo[]) internal lockInfo;
456 
457     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
458     event Unlock(address indexed holder, uint256 value);
459 
460     function balanceOf(address _holder) public view returns (uint256 balance) {
461         uint256 lockedBalance = 0;
462         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
463             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
464         }
465         return super.balanceOf(_holder).add(lockedBalance);
466     }
467 
468     function releaseLock(address _holder) internal {
469 
470         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
471             if (lockInfo[_holder][i].releaseTime <= now) {
472                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
473                 emit Unlock(_holder, lockInfo[_holder][i].balance);
474                 lockInfo[_holder][i].balance = 0;
475 
476                 if (i != lockInfo[_holder].length - 1) {
477                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
478                     i--;
479                 }
480                 lockInfo[_holder].length--;
481 
482             }
483         }
484     }
485     function lockCount(address _holder) public view returns (uint256) {
486         return lockInfo[_holder].length;
487     }
488     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
489         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
490     }
491 
492     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
493         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
494         _balances[_holder] = _balances[_holder].sub(_amount);
495         lockInfo[_holder].push(
496             LockInfo(_releaseTime, _amount)
497         );
498         emit Lock(_holder, _amount, _releaseTime);
499     }
500 
501     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
502         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
503         _balances[_holder] = _balances[_holder].sub(_amount);
504         lockInfo[_holder].push(
505             LockInfo(now + _afterTime, _amount)
506         );
507         emit Lock(_holder, _amount, now + _afterTime);
508     }
509 
510     function unlock(address _holder, uint256 i) public onlyOwner {
511         require(i < lockInfo[_holder].length, "No lock information.");
512 
513         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
514         emit Unlock(_holder, lockInfo[_holder][i].balance);
515         lockInfo[_holder][i].balance = 0;
516 
517         if (i != lockInfo[_holder].length - 1) {
518             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
519         }
520         lockInfo[_holder].length--;
521     }
522 
523     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
524         require(_to != address(0), "wrong address");
525         require(_value <= super.balanceOf(owner), "Not enough balance");
526 
527         _balances[owner] = _balances[owner].sub(_value);
528         lockInfo[_to].push(
529             LockInfo(_releaseTime, _value)
530         );
531         emit Transfer(owner, _to, _value);
532         emit Lock(_to, _value, _releaseTime);
533 
534         return true;
535     }
536 
537     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
538         require(_to != address(0), "wrong address");
539         require(_value <= super.balanceOf(owner), "Not enough balance");
540 
541         _balances[owner] = _balances[owner].sub(_value);
542         lockInfo[_to].push(
543             LockInfo(now + _afterTime, _value)
544         );
545         emit Transfer(owner, _to, _value);
546         emit Lock(_to, _value, now + _afterTime);
547 
548         return true;
549     }
550 
551     function currentTime() public view returns (uint256) {
552         return now;
553     }
554 
555     function afterTime(uint256 _value) public view returns (uint256) {
556         return now + _value;
557     }
558 }