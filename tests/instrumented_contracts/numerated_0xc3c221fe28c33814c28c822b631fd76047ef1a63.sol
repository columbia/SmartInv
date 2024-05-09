1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-04
3 */
4 
5 pragma solidity ^0.5.4;
6 
7 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint256);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39     * @dev Multiplies two unsigned integers, reverts on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69     */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Adds two unsigned integers, reverts on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89     * reverts when dividing by zero.
90     */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) internal _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121     * @dev Total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param owner The address to query the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147     * @dev Transfer token for a specified address
148     * @param to The address to transfer to.
149     * @param value The amount to be transferred.
150     */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         require(spender != address(0));
167 
168         _allowed[msg.sender][spender] = value;
169         emit Approval(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183         _transfer(from, to, value);
184         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
185         return true;
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * Emits an Approval event.
195      * @param spender The address which will spend the funds.
196      * @param addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199         require(spender != address(0));
200 
201         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
202         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      * approve should be called when allowed_[_spender] == 0. To decrement
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
220         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Transfer token for a specified addresses
226     * @param from The address to transfer from.
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that mints an amount of the token and assigns it to
240      * an account. This encapsulates the modification of balances such that the
241      * proper events are emitted.
242      * @param account The account that will receive the created tokens.
243      * @param value The amount that will be created.
244      */
245     function _mint(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.add(value);
249         _balances[account] = _balances[account].add(value);
250         emit Transfer(address(0), account, value);
251     }
252 
253     /**
254      * @dev Internal function that burns an amount of the token of a given
255      * account.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burn(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.sub(value);
263         _balances[account] = _balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
277         _burn(account, value);
278         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
279     }
280 }
281 
282 // File: contracts\MilliMeter.sol
283 
284 contract MilliMeter is ERC20 {
285     string public constant name = "MilliMeter"; // solium-disable-line uppercase
286     string public constant symbol = "MM"; // solium-disable-line uppercase
287     uint8 public constant decimals = 18; // solium-disable-line uppercase
288     uint256 public constant initialSupply = 2000000000 * (10 ** uint256(decimals));
289     
290     constructor() public {
291         super._mint(msg.sender, initialSupply);
292         owner = msg.sender;
293     }
294 
295     //ownership
296     address public owner;
297 
298     event OwnershipRenounced(address indexed previousOwner);
299     event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302     );
303 
304     modifier onlyOwner() {
305         require(msg.sender == owner, "Not owner");
306         _;
307     }
308 
309   /**
310    * @dev Allows the current owner to relinquish control of the contract.
311    * @notice Renouncing to ownership will leave the contract without an owner.
312    * It will not be possible to call the functions with the `onlyOwner`
313    * modifier anymore.
314    */
315     function renounceOwnership() public onlyOwner {
316         emit OwnershipRenounced(owner);
317         owner = address(0);
318     }
319 
320   /**
321    * @dev Allows the current owner to transfer control of the contract to a newOwner.
322    * @param _newOwner The address to transfer ownership to.
323    */
324     function transferOwnership(address _newOwner) public onlyOwner {
325         _transferOwnership(_newOwner);
326     }
327 
328   /**
329    * @dev Transfers control of the contract to a newOwner.
330    * @param _newOwner The address to transfer ownership to.
331    */
332     function _transferOwnership(address _newOwner) internal {
333         require(_newOwner != address(0), "Already owner");
334         emit OwnershipTransferred(owner, _newOwner);
335         owner = _newOwner;
336     }
337 
338     //pausable
339     event Pause();
340     event Unpause();
341 
342     bool public paused = false;
343     
344     /**
345     * @dev Modifier to make a function callable only when the contract is not paused.
346     */
347     modifier whenNotPaused() {
348         require(!paused, "Paused by owner");
349         _;
350     }
351 
352     /**
353     * @dev Modifier to make a function callable only when the contract is paused.
354     */
355     modifier whenPaused() {
356         require(paused, "Not paused now");
357         _;
358     }
359 
360     /**
361     * @dev called by the owner to pause, triggers stopped state
362     */
363     function pause() public onlyOwner whenNotPaused {
364         paused = true;
365         emit Pause();
366     }
367 
368     /**
369     * @dev called by the owner to unpause, returns to normal state
370     */
371     function unpause() public onlyOwner whenPaused {
372         paused = false;
373         emit Unpause();
374     }
375 
376     //freezable
377     event Frozen(address target);
378     event Unfrozen(address target);
379 
380     mapping(address => bool) internal freezes;
381 
382     modifier whenNotFrozen() {
383         require(!freezes[msg.sender], "Sender account is locked.");
384         _;
385     }
386 
387     function freeze(address _target) public onlyOwner {
388         freezes[_target] = true;
389         emit Frozen(_target);
390     }
391 
392     function unfreeze(address _target) public onlyOwner {
393         freezes[_target] = false;
394         emit Unfrozen(_target);
395     }
396 
397     function isFrozen(address _target) public view returns (bool) {
398         return freezes[_target];
399     }
400 
401     function transfer(
402         address _to,
403         uint256 _value
404     )
405       public
406       whenNotFrozen
407       whenNotPaused
408       returns (bool)
409     {
410         releaseLock(msg.sender);
411         return super.transfer(_to, _value);
412     }
413 
414     function transferFrom(
415         address _from,
416         address _to,
417         uint256 _value
418     )
419       public
420       whenNotPaused
421       returns (bool)
422     {
423         require(!freezes[_from], "From account is locked.");
424         releaseLock(_from);
425         return super.transferFrom(_from, _to, _value);
426     }
427 
428     //mintable
429     event Mint(address indexed to, uint256 amount);
430 
431     function mint(
432         address _to,
433         uint256 _amount
434     )
435       public
436       onlyOwner
437       returns (bool)
438     {
439         super._mint(_to, _amount);
440         emit Mint(_to, _amount);
441         return true;
442     }
443 
444     //burnable
445     event Burn(address indexed burner, uint256 value);
446 
447     function burn(address _who, uint256 _value) public onlyOwner {
448         require(_value <= super.balanceOf(_who), "Balance is too small.");
449 
450         _burn(_who, _value);
451         emit Burn(_who, _value);
452     }
453 
454     //lockable
455     struct LockInfo {
456         uint256 releaseTime;
457         uint256 balance;
458     }
459     mapping(address => LockInfo[]) internal lockInfo;
460 
461     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
462     event Unlock(address indexed holder, uint256 value);
463 
464     function balanceOf(address _holder) public view returns (uint256 balance) {
465         uint256 lockedBalance = 0;
466         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
467             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
468         }
469         return super.balanceOf(_holder).add(lockedBalance);
470     }
471 
472     function releaseLock(address _holder) internal {
473 
474         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
475             if (lockInfo[_holder][i].releaseTime <= now) {
476                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
477                 emit Unlock(_holder, lockInfo[_holder][i].balance);
478                 lockInfo[_holder][i].balance = 0;
479 
480                 if (i != lockInfo[_holder].length - 1) {
481                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
482                     i--;
483                 }
484                 lockInfo[_holder].length--;
485 
486             }
487         }
488     }
489     function lockCount(address _holder) public view returns (uint256) {
490         return lockInfo[_holder].length;
491     }
492     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
493         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
494     }
495 
496     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
497         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
498         _balances[_holder] = _balances[_holder].sub(_amount);
499         lockInfo[_holder].push(
500             LockInfo(_releaseTime, _amount)
501         );
502         emit Lock(_holder, _amount, _releaseTime);
503     }
504 
505     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
506         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
507         _balances[_holder] = _balances[_holder].sub(_amount);
508         lockInfo[_holder].push(
509             LockInfo(now + _afterTime, _amount)
510         );
511         emit Lock(_holder, _amount, now + _afterTime);
512     }
513 
514     function unlock(address _holder, uint256 i) public onlyOwner {
515         require(i < lockInfo[_holder].length, "No lock information.");
516 
517         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
518         emit Unlock(_holder, lockInfo[_holder][i].balance);
519         lockInfo[_holder][i].balance = 0;
520 
521         if (i != lockInfo[_holder].length - 1) {
522             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
523         }
524         lockInfo[_holder].length--;
525     }
526 
527     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
528         require(_to != address(0), "wrong address");
529         require(_value <= super.balanceOf(owner), "Not enough balance");
530 
531         _balances[owner] = _balances[owner].sub(_value);
532         lockInfo[_to].push(
533             LockInfo(_releaseTime, _value)
534         );
535         emit Transfer(owner, _to, _value);
536         emit Lock(_to, _value, _releaseTime);
537 
538         return true;
539     }
540 
541     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
542         require(_to != address(0), "wrong address");
543         require(_value <= super.balanceOf(owner), "Not enough balance");
544 
545         _balances[owner] = _balances[owner].sub(_value);
546         lockInfo[_to].push(
547             LockInfo(now + _afterTime, _value)
548         );
549         emit Transfer(owner, _to, _value);
550         emit Lock(_to, _value, now + _afterTime);
551 
552         return true;
553     }
554 
555     function currentTime() public view returns (uint256) {
556         return now;
557     }
558 
559     function afterTime(uint256 _value) public view returns (uint256) {
560         return now + _value;
561     }
562 }