1 pragma solidity 0.5.0;
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
33   address private _operator;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36   event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
37 
38   /**
39     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40     * account.
41     */
42   constructor() public {
43     _owner = msg.sender;
44     _operator = msg.sender;
45     emit OwnershipTransferred(address(0), _owner);
46     emit OperatorTransferred(address(0), _operator);
47   }
48 
49   /**
50     * @return the address of the owner.
51     */
52   function owner() public view returns (address) {
53     return _owner;
54   }
55 
56   /**
57     * @return the address of the operator.
58     */
59   function operator() public view returns (address) {
60     return _operator;
61   }
62 
63   /**
64     * @dev Throws if called by any account other than the owner.
65     */
66   modifier onlyOwner() {
67     require(isOwner());
68     _;
69   }
70 
71   /**
72     * @dev Throws if called by any account other than the owner or operator.
73     */
74   modifier onlyOwnerOrOperator() {
75     require(isOwner() || isOperator());
76     _;
77   }
78 
79 
80   /**
81     * @return true if `msg.sender` is the owner of the contract.
82     */
83   function isOwner() public view returns (bool) {
84     return msg.sender == _owner;
85   }
86 
87   /**
88     * @return true if `msg.sender` is the operator of the contract.
89     */
90   function isOperator() public view returns (bool) {
91     return msg.sender == _operator;
92   }
93 
94   /**
95     * @dev Allows the current owner to transfer control of the contract to a newOwner.
96     * @param newOwner The address to transfer ownership to.
97     */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100 
101     emit OwnershipTransferred(_owner, newOwner);
102     _owner = newOwner;
103   }
104 
105   /**
106     * @dev Allows the current operator to transfer control of the contract to a newOperator.
107     * @param newOperator The address to transfer ownership to.
108     */
109   function transferOperator(address newOperator) public onlyOwner {
110     require(newOperator != address(0));
111 
112     emit OperatorTransferred(_operator, newOperator);
113     _operator = newOperator;
114   }
115 
116 
117 }
118 
119 
120 /**
121   * @title Pausable
122   * @dev Base contract which allows children to implement an emergency stop mechanism.
123   */
124 contract Pausable is Ownable {
125   event Paused(address account);
126   event Unpaused(address account);
127 
128   bool private _paused;
129 
130   constructor () internal {
131     _paused = false;
132   }
133 
134   /**
135     * @return True if the contract is paused, false otherwise.
136     */
137   function paused() public view returns (bool) {
138     return _paused;
139   }
140 
141   /**
142     * @dev Modifier to make a function callable only when the contract is not paused.
143     */
144   modifier whenNotPaused() {
145     require(!_paused);
146     _;
147   }
148 
149   /**
150     * @dev Modifier to make a function callable only when the contract is paused.
151     */
152   modifier whenPaused() {
153     require(_paused);
154     _;
155   }
156 
157   /**
158     * @dev Called by a pauser to pause, triggers stopped state.
159     */
160   function pause() public onlyOwnerOrOperator whenNotPaused {
161     _paused = true;
162     emit Paused(msg.sender);
163   }
164 
165   /**
166     * @dev Called by a pauser to unpause, returns to normal state.
167     */
168   function unpause() public onlyOwnerOrOperator whenPaused {
169     _paused = false;
170     emit Unpaused(msg.sender);
171   }
172 }
173 
174 /**
175   * @title SafeMath
176   * @dev Unsigned math operations with safety checks that revert on error.
177   */
178 library SafeMath {
179 
180   /**
181     * @dev Multiplies two unsigned integers, reverts on overflow.
182     */
183   function mul(uint a, uint b) internal pure returns (uint) {
184     if (a == 0) {
185       return 0;
186     }
187 
188     uint c = a * b;
189     require(c / a == b);
190 
191     return c;
192   }
193 
194   /**
195     * @dev Integer division of two numbers, truncating the quotient.
196     */
197   function div(uint a, uint b) internal pure returns (uint) {
198     // Solidity only automatically asserts when dividing by 0
199     require(b > 0);
200     uint c = a / b;
201     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203     return c;
204   }
205 
206   /**
207     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
208     */
209   function sub(uint a, uint b) internal pure returns (uint) {
210     require(b <= a);
211     uint c = a - b;
212 
213     return c;
214   }
215 
216   /**
217     * @dev Adds two numbers, throws on overflow.
218     */
219   function add(uint a, uint b) internal pure returns (uint) {
220     uint c = a + b;
221     require(c >= a);
222 
223     return c;
224   }
225 
226   /**
227     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
228     * reverts when dividing by zero.
229     */
230   function mod(uint a, uint b) internal pure returns (uint) {
231     require(b != 0);
232     return a % b;
233   }
234 
235 }
236 
237 
238 /**
239   * @title StandardToken
240   * @dev Base Of token
241   */
242 contract StandardToken is ERC20, Pausable {
243   using SafeMath for uint;
244 
245   mapping (address => uint) private _balances;
246 
247   mapping (address => mapping (address => uint)) private _allowed;
248 
249   uint private _totalSupply;
250 
251   /**
252     * @dev Total number of tokens in existence.
253     */
254   function totalSupply() public view returns (uint) {
255     return _totalSupply;
256   }
257 
258   /**
259     * @dev Gets the balance of the specified address.
260     * @param owner The address to query the balance of.
261     * @return A uint representing the amount owned by the passed address.
262     */
263   function balanceOf(address owner) public view returns (uint) {
264     return _balances[owner];
265   }
266 
267   /**
268     * @dev Function to check the amount of tokens that an owner allowed to a spender.
269     * @param owner address The address which owns the funds.
270     * @param spender address The address which will spend the funds.
271     * @return A uint specifying the amount of tokens still available for the spender.
272     */
273   function allowance(address owner, address spender) public view returns (uint) {
274     return _allowed[owner][spender];
275   }
276 
277   /**
278     * @dev Transfer token to a specified address.
279     * @param to The address to transfer to.
280     * @param value The amount to be transferred.
281     */
282   function transfer(address to, uint value) public whenNotPaused returns (bool) {
283     _transfer(msg.sender, to, value);
284     return true;
285   }
286 
287   /**
288     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
289     * Beware that changing an allowance with this method brings the risk that someone may use both the old
290     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
291     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
292     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
293     * @param spender The address which will spend the funds.
294     * @param value The amount of tokens to be spent.
295     */
296   function approve(address spender, uint value) public whenNotPaused returns (bool) {
297     _approve(msg.sender, spender, value);
298     return true;
299   }
300 
301   /**
302     * @dev Transfer tokens from one address to another.
303     * Note that while this function emits an Approval event, this is not required as per the specification,
304     * and other compliant implementations may not emit the event.
305     * @param from address The address which you want to send tokens from
306     * @param to address The address which you want to transfer to
307     * @param value uint the amount of tokens to be transferred
308     */
309   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
310     _transferFrom(from, to, value);
311     return true;
312   }
313 
314   /**
315     * @dev Increase the amount of tokens that an owner allowed to a spender.
316     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
317     * allowed value is better to use this function to avoid 2 calls (and wait until
318     * the first transaction is mined)
319     * From MonolithDAO Token.sol
320     * Emits an Approval event.
321     * @param spender The address which will spend the funds.
322     * @param addedValue The amount of tokens to increase the allowance by.
323     */
324   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
325     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
326     return true;
327   }
328 
329   /**
330     * @dev Decrease the amount of tokens that an owner allowed to a spender.
331     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
332     * allowed value is better to use this function to avoid 2 calls (and wait until
333     * the first transaction is mined)
334     * From MonolithDAO Token.sol
335     * Emits an Approval event.
336     * @param spender The address which will spend the funds.
337     * @param subtractedValue The amount of tokens to decrease the allowance by.
338     */
339   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
340     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
341     return true;
342   }
343 
344   /**
345     * @dev Transfer token for a specified addresses.
346     * @param from The address to transfer from.
347     * @param to The address to transfer to.
348     * @param value The amount to be transferred.
349     */
350   function _transfer(address from, address to, uint value) internal {
351     require(to != address(0));
352 
353     _balances[from] = _balances[from].sub(value);
354     _balances[to] = _balances[to].add(value);
355     emit Transfer(from, to, value);
356   }
357 
358   /**
359     * @dev Transfer tokens from one address to another.
360     * Note that while this function emits an Approval event, this is not required as per the specification,
361     * and other compliant implementations may not emit the event.
362     * @param from address The address which you want to send tokens from
363     * @param to address The address which you want to transfer to
364     * @param value uint the amount of tokens to be transferred
365     */
366   function _transferFrom(address from, address to, uint value) internal {
367     _transfer(from, to, value);
368     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
369   }
370 
371   /**
372     * @dev Internal function that mints an amount of the token and assigns it to
373     * an account. This encapsulates the modification of balances such that the
374     * proper events are emitted.
375     * @param account The account that will receive the created tokens.
376     * @param value The amount that will be created.
377     */
378   function _mint(address account, uint value) internal {
379     require(account != address(0));
380 
381     _totalSupply = _totalSupply.add(value);
382     _balances[account] = _balances[account].add(value);
383     emit Transfer(address(0), account, value);
384   }
385 
386   /**
387     * @dev Internal function that burns an amount of the token of the owner
388     * account.
389     * @param value The amount that will be burnt.
390     */
391   function _burn(uint value) internal {
392     _totalSupply = _totalSupply.sub(value);
393     _balances[msg.sender] = _balances[msg.sender].sub(value);
394     emit Transfer(msg.sender, address(0), value);
395   }
396 
397   /**
398     * @dev Approve an address to spend another addresses' tokens.
399     * @param owner The address that owns the tokens.
400     * @param spender The address that will spend the tokens.
401     * @param value The number of tokens that can be spent.
402     */
403   function _approve(address owner, address spender, uint value) internal {
404     require(spender != address(0));
405     require(owner != address(0));
406 
407     _allowed[owner][spender] = value;
408     emit Approval(owner, spender, value);
409   }
410 }
411 
412 /**
413   * @title MintableToken
414   * @dev Minting of total balance
415   */
416 contract MintableToken is StandardToken {
417   event MintFinished();
418 
419   bool public mintingFinished = false;
420 
421   modifier canMint() {
422     require(!mintingFinished);
423     _;
424   }
425 
426   /**
427     * @dev Function to mint tokens
428     * @param to The address that will receive the minted tokens.
429     * @param amount The amount of tokens to mint
430     * @return A boolean that indicated if the operation was successful.
431     */
432   function mint(address to, uint amount) public whenNotPaused onlyOwner canMint returns (bool) {
433     _mint(to, amount);
434     return true;
435   }
436 
437   /**
438     * @dev Function to stop minting new tokens.
439     * @return True if the operation was successful.
440     */
441   function finishMinting() public whenNotPaused onlyOwner canMint returns (bool) {
442     mintingFinished = true;
443     emit MintFinished();
444     return true;
445   }
446 }
447 
448 /**
449   * @title Burnable Token
450   * @dev Token that can be irreversibly burned (destroyed).
451   */
452 contract BurnableToken is MintableToken {
453   /**
454     * @dev Burns a specific amount of tokens.
455     * @param value The amount of token to be burned.
456     */
457   function burn(uint value) public whenNotPaused onlyOwner returns (bool) {
458     _burn(value);
459     return true;
460   }
461 }
462 
463 
464 
465 /**
466   * @title LockableToken
467   * @dev locking of granted balance
468   */
469 contract LockableToken is BurnableToken {
470 
471   using SafeMath for uint;
472 
473   /**
474     * @dev Lock defines a lock of token
475     */
476   struct Lock {
477     uint amount;
478     uint expiresAt;
479   }
480 
481   mapping (address => Lock[]) public grantedLocks;
482 
483   /**
484     * @dev Transfer tokens to another
485     * @param to address the address which you want to transfer to
486     * @param value uint the amount of tokens to be transferred
487     */
488   function transfer(address to, uint value) public whenNotPaused returns (bool) {
489     _verifyTransferLock(msg.sender, value);
490     _transfer(msg.sender, to, value);
491     return true;
492   }
493 
494   /**
495     * @dev Transfer tokens from one address to another
496     * @param from address The address which you want to send tokens from
497     * @param to address the address which you want to transfer to
498     * @param value uint the amount of tokens to be transferred
499     */
500   function transferFrom(address from, address to, uint value) public whenNotPaused returns (bool) {
501     _verifyTransferLock(from, value);
502     _transferFrom(from, to, value);
503     return true;
504   }
505 
506   /**
507     * @dev Function to add lock
508     * @param granted The address that will be locked.
509     * @param amount The amount of tokens to be locked
510     * @param expiresAt The expired date as unix timestamp
511     */
512   function addLock(address granted, uint amount, uint expiresAt) public whenNotPaused onlyOwnerOrOperator {
513     require(amount > 0);
514     require(expiresAt > now);
515 
516     grantedLocks[granted].push(Lock(amount, expiresAt));
517   }
518 
519   /**
520     * @dev Function to delete lock
521     * @param granted The address that was locked
522     * @param index The index of lock
523     */
524   function deleteLock(address granted, uint8 index) public whenNotPaused onlyOwnerOrOperator {
525     require(grantedLocks[granted].length > index);
526 
527     uint len = grantedLocks[granted].length;
528     if (len == 1) {
529       delete grantedLocks[granted];
530     } else {
531       if (len - 1 != index) {
532         grantedLocks[granted][index] = grantedLocks[granted][len - 1];
533       }
534       delete grantedLocks[granted][len - 1];
535     }
536   }
537 
538   /**
539     * @dev Verify transfer is possible
540     * @param from - granted
541     * @param value - amount of transfer
542     */
543   function _verifyTransferLock(address from, uint value) internal view {
544     uint lockedAmount = getLockedAmount(from);
545     uint balanceAmount = balanceOf(from);
546 
547     require(balanceAmount.sub(lockedAmount) >= value);
548   }
549 
550   /**
551     * @dev get locked amount of address
552     * @param granted The address want to know the lock state.
553     * @return locked amount
554     */
555   function getLockedAmount(address granted) public view returns(uint) {
556     uint lockedAmount = 0;
557 
558     uint len = grantedLocks[granted].length;
559     for (uint i = 0; i < len; i++) {
560       if (now < grantedLocks[granted][i].expiresAt) {
561         lockedAmount = lockedAmount.add(grantedLocks[granted][i].amount);
562       }
563     }
564     return lockedAmount;
565   }
566 }
567 
568 /**
569   * @title MzcToken
570   * @dev ERC20 Token
571   */
572 contract MzcToken is LockableToken {
573 
574   string public constant name = "Muze creative";
575   string public constant symbol = "MZC";
576   uint32 public constant decimals = 18;
577 
578   uint public constant INITIAL_SUPPLY = 5000000000e18;
579 
580   /**
581     * @dev Constructor that gives msg.sender all of existing tokens.
582     */
583   constructor() public {
584     _mint(msg.sender, INITIAL_SUPPLY);
585     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
586   }
587 }