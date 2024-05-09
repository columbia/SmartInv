1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-16
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8   * @title ERC20Basic
9   * @dev Simpler version of ERC20 interface
10   * @dev see https://github.com/ethereum/EIPs/issues/179
11   */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint);
14   function balanceOf(address who) public view returns (uint);
15   function transfer(address to, uint value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint value);
17 }
18 
19 
20 /**
21   * @title ERC20 interface
22   * @dev see https://github.com/ethereum/EIPs/issues/20
23   */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint);
26   function transferFrom(address from, address to, uint value) public returns (bool);
27   function approve(address spender, uint value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint value);
29 }
30 
31 /**
32   * @title Ownable
33   * @dev Owner validator
34   */
35 contract Ownable {
36   address private _owner;
37   address private _operator;
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40   event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
41 
42   /**
43     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44     * account.
45     */
46   constructor() public {
47     _owner = msg.sender;
48     _operator = msg.sender;
49     emit OwnershipTransferred(address(0), _owner);
50     emit OperatorTransferred(address(0), _operator);
51   }
52 
53   /**
54     * @return the address of the owner.
55     */
56   function owner() public view returns (address) {
57     return _owner;
58   }
59 
60   /**
61     * @return the address of the operator.
62     */
63   function operator() public view returns (address) {
64     return _operator;
65   }
66 
67   /**
68     * @dev Throws if called by any account other than the owner.
69     */
70   modifier onlyOwner() {
71     require(isOwner());
72     _;
73   }
74 
75   /**
76     * @dev Throws if called by any account other than the owner or operator.
77     */
78   modifier onlyOwnerOrOperator() {
79     require(isOwner() || isOperator());
80     _;
81   }
82 
83 
84   /**
85     * @return true if `msg.sender` is the owner of the contract.
86     */
87   function isOwner() public view returns (bool) {
88     return msg.sender == _owner;
89   }
90 
91   /**
92     * @return true if `msg.sender` is the operator of the contract.
93     */
94   function isOperator() public view returns (bool) {
95     return msg.sender == _operator;
96   }
97 
98   /**
99     * @dev Allows the current owner to transfer control of the contract to a newOwner.
100     * @param newOwner The address to transfer ownership to.
101     */
102   function transferOwnership(address newOwner) public onlyOwner {
103     require(newOwner != address(0));
104 
105     emit OwnershipTransferred(_owner, newOwner);
106     _owner = newOwner;
107   }
108 
109   /**
110     * @dev Allows the current operator to transfer control of the contract to a newOperator.
111     * @param newOperator The address to transfer ownership to.
112     */
113   function transferOperator(address newOperator) public onlyOwner {
114     require(newOperator != address(0));
115 
116     emit OperatorTransferred(_operator, newOperator);
117     _operator = newOperator;
118   }
119 
120 
121 }
122 
123 
124 /**
125   * @title Pausable
126   * @dev Base contract which allows children to implement an emergency stop mechanism.
127   */
128 contract Pausable is Ownable {
129   event Paused(address account);
130   event Unpaused(address account);
131 
132   bool private _paused;
133 
134   constructor () internal {
135     _paused = false;
136   }
137 
138   /**
139     * @return True if the contract is paused, false otherwise.
140     */
141   function paused() public view returns (bool) {
142     return _paused;
143   }
144 
145   /**
146     * @dev Modifier to make a function callable only when the contract is not paused.
147     */
148   modifier whenNotPaused() {
149     require(!_paused);
150     _;
151   }
152 
153   /**
154     * @dev Modifier to make a function callable only when the contract is paused.
155     */
156   modifier whenPaused() {
157     require(_paused);
158     _;
159   }
160 
161   /**
162     * @dev Called by a pauser to pause, triggers stopped state.
163     */
164   function pause() public onlyOwnerOrOperator whenNotPaused {
165     _paused = true;
166     emit Paused(msg.sender);
167   }
168 
169   /**
170     * @dev Called by a pauser to unpause, returns to normal state.
171     */
172   function unpause() public onlyOwnerOrOperator whenPaused {
173     _paused = false;
174     emit Unpaused(msg.sender);
175   }
176 }
177 
178 /**
179   * @title SafeMath
180   * @dev Unsigned math operations with safety checks that revert on error.
181   */
182 library SafeMath {
183 
184   /**
185     * @dev Multiplies two unsigned integers, reverts on overflow.
186     */
187   function mul(uint a, uint b) internal pure returns (uint) {
188     if (a == 0) {
189       return 0;
190     }
191 
192     uint c = a * b;
193     require(c / a == b);
194 
195     return c;
196   }
197 
198   /**
199     * @dev Integer division of two numbers, truncating the quotient.
200     */
201   function div(uint a, uint b) internal pure returns (uint) {
202     // Solidity only automatically asserts when dividing by 0
203     require(b > 0);
204     uint c = a / b;
205     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207     return c;
208   }
209 
210   /**
211     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
212     */
213   function sub(uint a, uint b) internal pure returns (uint) {
214     require(b <= a);
215     uint c = a - b;
216 
217     return c;
218   }
219 
220   /**
221     * @dev Adds two numbers, throws on overflow.
222     */
223   function add(uint a, uint b) internal pure returns (uint) {
224     uint c = a + b;
225     require(c >= a);
226 
227     return c;
228   }
229 
230   /**
231     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
232     * reverts when dividing by zero.
233     */
234   function mod(uint a, uint b) internal pure returns (uint) {
235     require(b != 0);
236     return a % b;
237   }
238 
239 }
240 
241 
242 /**
243   * @title StandardToken
244   * @dev Base Of token
245   */
246 contract StandardToken is ERC20, Pausable {
247   using SafeMath for uint;
248 
249   mapping (address => uint) private _balances;
250 
251   mapping (address => mapping (address => uint)) private _allowed;
252 
253   uint private _totalSupply;
254 
255   /**
256     * @dev Total number of tokens in existence.
257     */
258   function totalSupply() public view returns (uint) {
259     return _totalSupply;
260   }
261 
262   /**
263     * @dev Gets the balance of the specified address.
264     * @param owner The address to query the balance of.
265     * @return A uint representing the amount owned by the passed address.
266     */
267   function balanceOf(address owner) public view returns (uint) {
268     return _balances[owner];
269   }
270 
271   /**
272     * @dev Function to check the amount of tokens that an owner allowed to a spender.
273     * @param owner address The address which owns the funds.
274     * @param spender address The address which will spend the funds.
275     * @return A uint specifying the amount of tokens still available for the spender.
276     */
277   function allowance(address owner, address spender) public view returns (uint) {
278     return _allowed[owner][spender];
279   }
280 
281   /**
282     * @dev Transfer token to a specified address.
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286   function transfer(address to, uint value) public whenNotPaused returns (bool) {
287     _transfer(msg.sender, to, value);
288     return true;
289   }
290 
291   /**
292     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293     * Beware that changing an allowance with this method brings the risk that someone may use both the old
294     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297     * @param spender The address which will spend the funds.
298     * @param value The amount of tokens to be spent.
299     */
300   function approve(address spender, uint value) public whenNotPaused returns (bool) {
301     _approve(msg.sender, spender, value);
302     return true;
303   }
304 
305   /**
306     * @dev Transfer tokens from one address to another.
307     * Note that while this function emits an Approval event, this is not required as per the specification,
308     * and other compliant implementations may not emit the event.
309     * @param from address The address which you want to send tokens from
310     * @param to address The address which you want to transfer to
311     * @param value uint the amount of tokens to be transferred
312     */
313   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
314     _transferFrom(from, to, value);
315     return true;
316   }
317 
318   /**
319     * @dev Increase the amount of tokens that an owner allowed to a spender.
320     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
321     * allowed value is better to use this function to avoid 2 calls (and wait until
322     * the first transaction is mined)
323     * From MonolithDAO Token.sol
324     * Emits an Approval event.
325     * @param spender The address which will spend the funds.
326     * @param addedValue The amount of tokens to increase the allowance by.
327     */
328   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
329     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
330     return true;
331   }
332 
333   /**
334     * @dev Decrease the amount of tokens that an owner allowed to a spender.
335     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
336     * allowed value is better to use this function to avoid 2 calls (and wait until
337     * the first transaction is mined)
338     * From MonolithDAO Token.sol
339     * Emits an Approval event.
340     * @param spender The address which will spend the funds.
341     * @param subtractedValue The amount of tokens to decrease the allowance by.
342     */
343   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
344     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
345     return true;
346   }
347 
348   /**
349     * @dev Transfer token for a specified addresses.
350     * @param from The address to transfer from.
351     * @param to The address to transfer to.
352     * @param value The amount to be transferred.
353     */
354   function _transfer(address from, address to, uint value) internal {
355     require(to != address(0));
356 
357     _balances[from] = _balances[from].sub(value);
358     _balances[to] = _balances[to].add(value);
359     emit Transfer(from, to, value);
360   }
361 
362   /**
363     * @dev Transfer tokens from one address to another.
364     * Note that while this function emits an Approval event, this is not required as per the specification,
365     * and other compliant implementations may not emit the event.
366     * @param from address The address which you want to send tokens from
367     * @param to address The address which you want to transfer to
368     * @param value uint the amount of tokens to be transferred
369     */
370   function _transferFrom(address from, address to, uint value) internal {
371     _transfer(from, to, value);
372     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
373   }
374 
375   /**
376     * @dev Internal function that mints an amount of the token and assigns it to
377     * an account. This encapsulates the modification of balances such that the
378     * proper events are emitted.
379     * @param account The account that will receive the created tokens.
380     * @param value The amount that will be created.
381     */
382   function _mint(address account, uint value) internal {
383     require(account != address(0));
384 
385     _totalSupply = _totalSupply.add(value);
386     _balances[account] = _balances[account].add(value);
387     emit Transfer(address(0), account, value);
388   }
389 
390   /**
391     * @dev Internal function that burns an amount of the token of the owner
392     * account.
393     * @param value The amount that will be burnt.
394     */
395   function _burn(uint value) internal {
396     _totalSupply = _totalSupply.sub(value);
397     _balances[msg.sender] = _balances[msg.sender].sub(value);
398     emit Transfer(msg.sender, address(0), value);
399   }
400 
401   /**
402     * @dev Approve an address to spend another addresses' tokens.
403     * @param owner The address that owns the tokens.
404     * @param spender The address that will spend the tokens.
405     * @param value The number of tokens that can be spent.
406     */
407   function _approve(address owner, address spender, uint value) internal {
408     require(spender != address(0));
409     require(owner != address(0));
410 
411     _allowed[owner][spender] = value;
412     emit Approval(owner, spender, value);
413   }
414 }
415 
416 /**
417   * @title MintableToken
418   * @dev Minting of total balance
419   */
420 contract MintableToken is StandardToken {
421   event MintFinished();
422 
423   bool public mintingFinished = false;
424 
425   modifier canMint() {
426     require(!mintingFinished);
427     _;
428   }
429 
430   /**
431     * @dev Function to mint tokens
432     * @param to The address that will receive the minted tokens.
433     * @param amount The amount of tokens to mint
434     * @return A boolean that indicated if the operation was successful.
435     */
436   function mint(address to, uint amount) public whenNotPaused onlyOwner canMint returns (bool) {
437     _mint(to, amount);
438     return true;
439   }
440 
441   /**
442     * @dev Function to stop minting new tokens.
443     * @return True if the operation was successful.
444     */
445   function finishMinting() public whenNotPaused onlyOwner canMint returns (bool) {
446     mintingFinished = true;
447     emit MintFinished();
448     return true;
449   }
450 }
451 
452 /**
453   * @title Burnable Token
454   * @dev Token that can be irreversibly burned (destroyed).
455   */
456 contract BurnableToken is MintableToken {
457   /**
458     * @dev Burns a specific amount of tokens.
459     * @param value The amount of token to be burned.
460     */
461   function burn(uint value) public whenNotPaused onlyOwner returns (bool) {
462     _burn(value);
463     return true;
464   }
465 }
466 
467 
468 
469 /**
470   * @title LockableToken
471   * @dev locking of granted balance
472   */
473 contract LockableToken is BurnableToken {
474 
475   using SafeMath for uint;
476 
477   /**
478     * @dev Lock defines a lock of token
479     */
480   struct Lock {
481     uint amount;
482     uint expiresAt;
483   }
484 
485   mapping (address => Lock[]) public grantedLocks;
486 
487   /**
488     * @dev Transfer tokens to another
489     * @param to address the address which you want to transfer to
490     * @param value uint the amount of tokens to be transferred
491     */
492   function transfer(address to, uint value) public whenNotPaused returns (bool) {
493     _verifyTransferLock(msg.sender, value);
494     _transfer(msg.sender, to, value);
495     return true;
496   }
497 
498   /**
499     * @dev Transfer tokens from one address to another
500     * @param from address The address which you want to send tokens from
501     * @param to address the address which you want to transfer to
502     * @param value uint the amount of tokens to be transferred
503     */
504   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
505     _verifyTransferLock(from, value);
506     _transferFrom(from, to, value);
507     return true;
508   }
509 
510   /**
511     * @dev Function to add lock
512     * @param granted The address that will be locked.
513     * @param amount The amount of tokens to be locked
514     * @param expiresAt The expired date as unix timestamp
515     */
516   function addLock(address granted, uint amount, uint expiresAt) public whenNotPaused onlyOwnerOrOperator {
517     require(amount > 0);
518     require(expiresAt > now);
519 
520     grantedLocks[granted].push(Lock(amount, expiresAt));
521   }
522 
523   /**
524     * @dev Function to delete lock
525     * @param granted The address that was locked
526     * @param index The index of lock
527     */
528   function deleteLock(address granted, uint8 index) public whenNotPaused onlyOwnerOrOperator {
529     require(grantedLocks[granted].length > index);
530 
531     uint len = grantedLocks[granted].length;
532     if (len == 1) {
533       delete grantedLocks[granted];
534     } else {
535       if (len - 1 != index) {
536         grantedLocks[granted][index] = grantedLocks[granted][len - 1];
537       }
538       delete grantedLocks[granted][len - 1];
539     }
540   }
541 
542   /**
543     * @dev Verify transfer is possible
544     * @param from - granted
545     * @param value - amount of transfer
546     */
547   function _verifyTransferLock(address from, uint value) internal view {
548     uint lockedAmount = getLockedAmount(from);
549     uint balanceAmount = balanceOf(from);
550 
551     require(balanceAmount.sub(lockedAmount) >= value);
552   }
553 
554   /**
555     * @dev get locked amount of address
556     * @param granted The address want to know the lock state.
557     * @return locked amount
558     */
559   function getLockedAmount(address granted) public view returns(uint) {
560     uint lockedAmount = 0;
561 
562     uint len = grantedLocks[granted].length;
563     for (uint i = 0; i < len; i++) {
564       if (now < grantedLocks[granted][i].expiresAt) {
565         lockedAmount = lockedAmount.add(grantedLocks[granted][i].amount);
566       }
567     }
568     return lockedAmount;
569   }
570 }
571 
572 /**
573   * @title IzeToken
574   * @dev ERC20 Token
575   */
576 contract IzeToken is LockableToken {
577 
578   string public constant name = "IZE Fintech Blockchain";
579   string public constant symbol = "IZE";
580   uint32 public constant decimals = 18;
581 
582   uint public constant INITIAL_SUPPLY = 10000000000e18;
583 
584   /**
585     * @dev Constructor that gives msg.sender all of existing tokens.
586     */
587   constructor() public {
588     _mint(msg.sender, INITIAL_SUPPLY);
589     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
590   }
591 }