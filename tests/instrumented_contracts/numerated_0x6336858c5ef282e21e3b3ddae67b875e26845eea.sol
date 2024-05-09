1 pragma solidity ^0.5.0;
2 
3 /**
4   * @title ERC20Basic
5   * @dev Simpler version of ERC20 interface
6   * @dev see https://github.com/ethereum/EIPs/issues/179
7   */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint);
10   function balanceOf(address who) public view returns (uint);
11   function transfer(address to, uint value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 
15 
16 /**
17   * @title ERC20 interface
18   * @dev see https://github.com/ethereum/EIPs/issues/20
19   */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint);
22   function transferFrom(address from, address to, uint value) public returns (bool);
23   function approve(address spender, uint value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint value);
25 }
26 
27 /**
28   * @title Ownable
29   * @dev Owner validator
30   */
31 contract Ownable {
32   address private _owner;
33   address[] private _operator;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36   event OperatorAdded(address indexed newOperator);
37   event OperatorRemoved(address indexed previousOperator);
38 
39   /**
40     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41     * account.
42     */
43   constructor() public {
44     _owner = msg.sender;
45     _operator.push(msg.sender);
46 
47     emit OwnershipTransferred(address(0), _owner);
48     emit OperatorAdded(_owner);
49   }
50 
51   /**
52     * @return the address of the owner.
53     */
54   function owner() public view returns (address) {
55     return _owner;
56   }
57  
58   /**
59     *  @return the address of the operator matched index
60     */
61   function operator(uint index) public view returns (address) {
62     require(_operator.length > index);
63     return _operator[index];
64   }
65 
66   /**
67     * @dev Throws if called by any account other than the owner.
68     */
69   modifier onlyOwner() {
70     require(isOwner());
71     _;
72   }
73 
74   /**
75     * @dev Throws if called by any account other than the owner or operator.
76     */
77   modifier onlyOwnerOrOperator() {
78     require(isOwner() || isOperator());
79     _;
80   }
81 
82 
83   /**
84     * @return true if `msg.sender` is the owner of the contract.
85     */
86   function isOwner() public view returns (bool) {
87     return msg.sender == _owner;
88   }
89 
90   /**
91     * @return true if `msg.sender` is the operator of the contract.
92     */
93   function isOperator() public view returns (bool) {
94     return _isOperator(msg.sender);
95   }
96  
97   /**
98     * @return true if address `granted` is the operator of the contract.
99     */
100   function _isOperator(address granted) internal view returns (bool) {
101     for(uint i = 0; i < _operator.length; i++) {
102         if(_operator[i] == granted) {
103             return true;
104         }
105     }
106     return false;
107   }
108 
109   /**
110     * @dev Allows the current owner to transfer control of the contract to a newOwner.
111     * @param newOwner The address to transfer ownership to.
112     */
113   function transferOwnership(address newOwner) public onlyOwner {
114     require(newOwner != address(0));
115 
116     emit OwnershipTransferred(_owner, newOwner);
117     _owner = newOwner;
118   }
119 
120   /**
121     * @dev Add newOperator.
122     * @param newOperator The address to operate additonally.
123     */
124   function addOperator(address newOperator) public onlyOwner {
125     require(newOperator != address(0));
126     require(!_isOperator(newOperator));
127 
128     _operator.push(newOperator);
129     emit OperatorAdded(newOperator);
130   }
131 
132   /**
133     * @dev Remove Operator.
134     * @param noMoreOperator The address not to operate anymore.
135     */
136   function removeOperator(address noMoreOperator) public onlyOwner {
137     require(noMoreOperator != address(0));
138     require(_isOperator(noMoreOperator));
139 
140     uint len = _operator.length;
141     uint index = len;
142     for(uint i = 0; i < len; i++) {
143         if (_operator[i] == noMoreOperator) {
144             index = i;
145         }
146     }
147    
148     if(index != len){
149         if (len == 1) {
150           delete _operator[len - 1];
151         } else {
152           _operator[index] = _operator[len - 1];
153           delete _operator[len - 1];
154         }
155     }
156   }
157 }
158 
159 
160 /**
161   * @title Pausable
162   * @dev Base contract which allows children to implement an emergency stop mechanism.
163   */
164 contract Pausable is Ownable {
165   event Paused(address account);
166   event Unpaused(address account);
167 
168   bool private _paused;
169 
170   constructor () internal {
171     _paused = false;
172   }
173 
174   /**
175     * @return True if the contract is paused, false otherwise.
176     */
177   function paused() public view returns (bool) {
178     return _paused;
179   }
180 
181   /**
182     * @dev Modifier to make a function callable only when the contract is not paused.
183     */
184   modifier whenNotPaused() {
185     require(!_paused);
186     _;
187   }
188 
189   /**
190     * @dev Modifier to make a function callable only when the contract is paused.
191     */
192   modifier whenPaused() {
193     require(_paused);
194     _;
195   }
196 
197   /**
198     * @dev Called by a pauser to pause, triggers stopped state.
199     */
200   function pause() public onlyOwnerOrOperator whenNotPaused {
201     _paused = true;
202     emit Paused(msg.sender);
203   }
204 
205   /**
206     * @dev Called by a pauser to unpause, returns to normal state.
207     */
208   function unpause() public onlyOwnerOrOperator whenPaused {
209     _paused = false;
210     emit Unpaused(msg.sender);
211   }
212 }
213 
214 /**
215   * @title SafeMath
216   * @dev Unsigned math operations with safety checks that revert on error.
217   */
218 library SafeMath {
219 
220   /**
221     * @dev Multiplies two unsigned integers, reverts on overflow.
222     */
223   function mul(uint a, uint b) internal pure returns (uint) {
224     if (a == 0) {
225       return 0;
226     }
227 
228     uint c = a * b;
229     require(c / a == b);
230 
231     return c;
232   }
233 
234   /**
235     * @dev Integer division of two numbers, truncating the quotient.
236     */
237   function div(uint a, uint b) internal pure returns (uint) {
238     // Solidity only automatically asserts when dividing by 0
239     require(b > 0);
240     uint c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243     return c;
244   }
245 
246   /**
247     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
248     */
249   function sub(uint a, uint b) internal pure returns (uint) {
250     require(b <= a);
251     uint c = a - b;
252 
253     return c;
254   }
255 
256   /**
257     * @dev Adds two numbers, throws on overflow.
258     */
259   function add(uint a, uint b) internal pure returns (uint) {
260     uint c = a + b;
261     require(c >= a);
262 
263     return c;
264   }
265 
266   /**
267     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
268     * reverts when dividing by zero.
269     */
270   function mod(uint a, uint b) internal pure returns (uint) {
271     require(b != 0);
272     return a % b;
273   }
274 
275 }
276 
277 
278 /**
279   * @title StandardToken
280   * @dev Base Of token
281   */
282 contract StandardToken is ERC20, Pausable {
283   using SafeMath for uint;
284 
285   mapping (address => uint) private _balances;
286 
287   mapping (address => mapping (address => uint)) private _allowed;
288 
289   uint private _totalSupply;
290 
291   /**
292     * @dev Total number of tokens in existence.
293     */
294   function totalSupply() public view returns (uint) {
295     return _totalSupply;
296   }
297 
298   /**
299     * @dev Gets the balance of the specified address.
300     * @param owner The address to query the balance of.
301     * @return A uint representing the amount owned by the passed address.
302     */
303   function balanceOf(address owner) public view returns (uint) {
304     return _balances[owner];
305   }
306 
307   /**
308     * @dev Function to check the amount of tokens that an owner allowed to a spender.
309     * @param owner address The address which owns the funds.
310     * @param spender address The address which will spend the funds.
311     * @return A uint specifying the amount of tokens still available for the spender.
312     */
313   function allowance(address owner, address spender) public view returns (uint) {
314     return _allowed[owner][spender];
315   }
316 
317   /**
318     * @dev Transfer token to a specified address.
319     * @param to The address to transfer to.
320     * @param value The amount to be transferred.
321     */
322   function transfer(address to, uint value) public whenNotPaused returns (bool) {
323     _transfer(msg.sender, to, value);
324     return true;
325   }
326 
327   /**
328     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
329     * Beware that changing an allowance with this method brings the risk that someone may use both the old
330     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333     * @param spender The address which will spend the funds.
334     * @param value The amount of tokens to be spent.
335     */
336   function approve(address spender, uint value) public whenNotPaused returns (bool) {
337     _approve(msg.sender, spender, value);
338     return true;
339   }
340 
341   /**
342     * @dev Transfer tokens from one address to another.
343     * Note that while this function emits an Approval event, this is not required as per the specification,
344     * and other compliant implementations may not emit the event.
345     * @param from address The address which you want to send tokens from
346     * @param to address The address which you want to transfer to
347     * @param value uint the amount of tokens to be transferred
348     */
349   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
350     _transferFrom(from, to, value);
351     return true;
352   }
353 
354   /**
355     * @dev Increase the amount of tokens that an owner allowed to a spender.
356     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
357     * allowed value is better to use this function to avoid 2 calls (and wait until
358     * the first transaction is mined)
359     * From MonolithDAO Token.sol
360     * Emits an Approval event.
361     * @param spender The address which will spend the funds.
362     * @param addedValue The amount of tokens to increase the allowance by.
363     */
364   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
365     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
366     return true;
367   }
368 
369   /**
370     * @dev Decrease the amount of tokens that an owner allowed to a spender.
371     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
372     * allowed value is better to use this function to avoid 2 calls (and wait until
373     * the first transaction is mined)
374     * From MonolithDAO Token.sol
375     * Emits an Approval event.
376     * @param spender The address which will spend the funds.
377     * @param subtractedValue The amount of tokens to decrease the allowance by.
378     */
379   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
380     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
381     return true;
382   }
383 
384   /**
385     * @dev Transfer token for a specified addresses.
386     * @param from The address to transfer from.
387     * @param to The address to transfer to.
388     * @param value The amount to be transferred.
389     */
390   function _transfer(address from, address to, uint value) internal {
391     require(to != address(0));
392 
393     _balances[from] = _balances[from].sub(value);
394     _balances[to] = _balances[to].add(value);
395     emit Transfer(from, to, value);
396   }
397 
398   /**
399     * @dev Transfer tokens from one address to another.
400     * Note that while this function emits an Approval event, this is not required as per the specification,
401     * and other compliant implementations may not emit the event.
402     * @param from address The address which you want to send tokens from
403     * @param to address The address which you want to transfer to
404     * @param value uint the amount of tokens to be transferred
405     */
406   function _transferFrom(address from, address to, uint value) internal {
407     _transfer(from, to, value);
408     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
409   }
410 
411   /**
412     * @dev Internal function that mints an amount of the token and assigns it to
413     * an account. This encapsulates the modification of balances such that the
414     * proper events are emitted.
415     * @param account The account that will receive the created tokens.
416     * @param value The amount that will be created.
417     */
418   function _mint(address account, uint value) internal {
419     require(account != address(0));
420 
421     _totalSupply = _totalSupply.add(value);
422     _balances[account] = _balances[account].add(value);
423     emit Transfer(address(0), account, value);
424   }
425 
426   /**
427     * @dev Internal function that burns an amount of the token of the owner
428     * account.
429     * @param value The amount that will be burnt.
430     */
431   function _burn(uint value) internal {
432     _totalSupply = _totalSupply.sub(value);
433     _balances[msg.sender] = _balances[msg.sender].sub(value);
434     emit Transfer(msg.sender, address(0), value);
435   }
436 
437   /**
438     * @dev Approve an address to spend another addresses' tokens.
439     * @param owner The address that owns the tokens.
440     * @param spender The address that will spend the tokens.
441     * @param value The number of tokens that can be spent.
442     */
443   function _approve(address owner, address spender, uint value) internal {
444     require(spender != address(0));
445     require(owner != address(0));
446 
447     _allowed[owner][spender] = value;
448     emit Approval(owner, spender, value);
449   }
450 }
451 
452 /**
453   * @title MintableToken
454   * @dev Minting of total balance
455   */
456 contract MintableToken is StandardToken {
457   event MintFinished();
458 
459   bool public mintingFinished = false;
460 
461   modifier canMint() {
462     require(!mintingFinished);
463     _;
464   }
465 
466   /**
467     * @dev Function to mint tokens
468     * @param to The address that will receive the minted tokens.
469     * @param amount The amount of tokens to mint
470     * @return A boolean that indicated if the operation was successful.
471     */
472   function mint(address to, uint amount) public whenNotPaused onlyOwner canMint returns (bool) {
473     _mint(to, amount);
474     return true;
475   }
476 
477   /**
478     * @dev Function to stop minting new tokens.
479     * @return True if the operation was successful.
480     */
481   function finishMinting() public whenNotPaused onlyOwner canMint returns (bool) {
482     mintingFinished = true;
483     emit MintFinished();
484     return true;
485   }
486 }
487 
488 /**
489   * @title Burnable Token
490   * @dev Token that can be irreversibly burned (destroyed).
491   */
492 contract BurnableToken is MintableToken {
493   /**
494     * @dev Burns a specific amount of tokens.
495     * @param value The amount of token to be burned.
496     */
497   function burn(uint value) public whenNotPaused onlyOwner returns (bool) {
498     _burn(value);
499     return true;
500   }
501 }
502 
503 
504 
505 /**
506   * @title LockableToken
507   * @dev locking of granted balance
508   */
509 contract LockableToken is BurnableToken {
510 
511   using SafeMath for uint;
512 
513   /**
514     * @dev Lock defines a lock of token
515     */
516   struct Lock {
517     uint amount;
518     uint expiresAt;
519   }
520 
521   mapping (address => Lock[]) public grantedLocks;
522 
523   /**
524     * @dev Transfer tokens to another
525     * @param to address the address which you want to transfer to
526     * @param value uint the amount of tokens to be transferred
527     */
528   function transfer(address to, uint value) public whenNotPaused returns (bool) {
529     _verifyTransferLock(msg.sender, value);
530     _transfer(msg.sender, to, value);
531     return true;
532   }
533 
534   /**
535     * @dev Transfer tokens from one address to another
536     * @param from address The address which you want to send tokens from
537     * @param to address the address which you want to transfer to
538     * @param value uint the amount of tokens to be transferred
539     */
540   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
541     _verifyTransferLock(from, value);
542     _transferFrom(from, to, value);
543     return true;
544   }
545 
546   /**
547     * @dev Function to add lock
548     * @param granted The address that will be locked.
549     * @param amount The amount of tokens to be locked
550     * @param expiresAt The expired date as unix timestamp
551     */
552   function addLock(address granted, uint amount, uint expiresAt) public onlyOwnerOrOperator {
553     require(amount > 0);
554     require(expiresAt > now);
555 
556     grantedLocks[granted].push(Lock(amount, expiresAt));
557   }
558 
559   /**
560     * @dev Function to delete lock
561     * @param granted The address that was locked
562     * @param index The index of lock
563     */
564   function deleteLock(address granted, uint8 index) public onlyOwnerOrOperator {
565     require(grantedLocks[granted].length > index);
566 
567     uint len = grantedLocks[granted].length;
568     if (len == 1) {
569       delete grantedLocks[granted];
570     } else {
571       if (len - 1 != index) {
572         grantedLocks[granted][index] = grantedLocks[granted][len - 1];
573       }
574       delete grantedLocks[granted][len - 1];
575     }
576   }
577 
578   /**
579     * @dev Verify transfer is possible
580     * @param from - granted
581     * @param value - amount of transfer
582     */
583   function _verifyTransferLock(address from, uint value) internal view {
584     uint lockedAmount = getLockedAmount(from);
585     uint balanceAmount = balanceOf(from);
586 
587     require(balanceAmount.sub(lockedAmount) >= value);
588   }
589 
590   /**
591     * @dev get locked amount of address
592     * @param granted The address want to know the lock state.
593     * @return locked amount
594     */
595   function getLockedAmount(address granted) public view returns(uint) {
596     uint lockedAmount = 0;
597 
598     uint len = grantedLocks[granted].length;
599     for (uint i = 0; i < len; i++) {
600       if (now < grantedLocks[granted][i].expiresAt) {
601         lockedAmount = lockedAmount.add(grantedLocks[granted][i].amount);
602       }
603     }
604     return lockedAmount;
605   }
606 }
607 
608 /**
609   * @title Be Gaming Coin Token
610   * @dev ERC20 Token
611   */
612 contract BGCToken is LockableToken {
613 
614   string public constant name = "Be Gaming Coin";
615   string public constant symbol = "BGC";
616   uint32 public constant decimals = 18;
617 
618   uint public constant INITIAL_SUPPLY = 3000000000e18;
619 
620   /**
621     * @dev Constructor that gives msg.sender all of existing tokens.
622     */
623   constructor() public {
624     _mint(msg.sender, INITIAL_SUPPLY);
625     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
626   }
627  
628   function lockTransfer(address granted, uint value) public onlyOwnerOrOperator {
629       bool lock_flag = false;
630       uint unit_lock_amount = SafeMath.div(value, 10);
631       uint total_lock_amount = SafeMath.mul(unit_lock_amount, 4);
632       uint unlock_amount = SafeMath.sub(value, total_lock_amount);
633       require(value == total_lock_amount + unlock_amount);
634       uint moment = now;
635      
636       uint locktime = SafeMath.add(moment, 2 * 30 days);
637       addLock(granted, unit_lock_amount, locktime);   // + 2 momths
638       locktime = SafeMath.add(moment, 4 * 30 days);
639       addLock(granted, unit_lock_amount, locktime);   // + 2 momths
640       locktime = SafeMath.add(moment, 6 * 30 days);
641       addLock(granted, unit_lock_amount, locktime);   // + 2 momths
642       locktime = SafeMath.add(moment, 8 * 30 days);
643       addLock(granted, unit_lock_amount, locktime);   // + 2 momths
644       lock_flag = true;
645       if(lock_flag){
646         transfer(granted, value);
647       }
648   }
649 }