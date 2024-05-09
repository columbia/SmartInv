1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /root/code/solidity/xixoio-contracts/flat/TokenSale.sol
6 // flattened :  Monday, 03-Dec-18 10:34:17 UTC
7 interface ITokenPool {
8     function balanceOf(uint128 id) public view returns (uint256);
9     function allocate(uint128 id, uint256 value) public;
10     function withdraw(uint128 id, address to, uint256 value) public;
11     function complete() public;
12 }
13 
14 contract Ownable {
15   address private _owner;
16 
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() internal {
27     _owner = msg.sender;
28     emit OwnershipTransferred(address(0), _owner);
29   }
30 
31   /**
32    * @return the address of the owner.
33    */
34   function owner() public view returns(address) {
35     return _owner;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(isOwner());
43     _;
44   }
45 
46   /**
47    * @return true if `msg.sender` is the owner of the contract.
48    */
49   function isOwner() public view returns(bool) {
50     return msg.sender == _owner;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    * @notice Renouncing to ownership will leave the contract without an owner.
56    * It will not be possible to call the functions with the `onlyOwner`
57    * modifier anymore.
58    */
59   function renounceOwnership() public onlyOwner {
60     emit OwnershipTransferred(_owner, address(0));
61     _owner = address(0);
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     _transferOwnership(newOwner);
70   }
71 
72   /**
73    * @dev Transfers control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function _transferOwnership(address newOwner) internal {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(_owner, newOwner);
79     _owner = newOwner;
80   }
81 }
82 
83 library Roles {
84   struct Role {
85     mapping (address => bool) bearer;
86   }
87 
88   /**
89    * @dev give an account access to this role
90    */
91   function add(Role storage role, address account) internal {
92     require(account != address(0));
93     require(!has(role, account));
94 
95     role.bearer[account] = true;
96   }
97 
98   /**
99    * @dev remove an account's access to this role
100    */
101   function remove(Role storage role, address account) internal {
102     require(account != address(0));
103     require(has(role, account));
104 
105     role.bearer[account] = false;
106   }
107 
108   /**
109    * @dev check if an account has this role
110    * @return bool
111    */
112   function has(Role storage role, address account)
113     internal
114     view
115     returns (bool)
116   {
117     require(account != address(0));
118     return role.bearer[account];
119   }
120 }
121 
122 interface IERC20 {
123   function totalSupply() external view returns (uint256);
124 
125   function balanceOf(address who) external view returns (uint256);
126 
127   function allowance(address owner, address spender)
128     external view returns (uint256);
129 
130   function transfer(address to, uint256 value) external returns (bool);
131 
132   function approve(address spender, uint256 value)
133     external returns (bool);
134 
135   function transferFrom(address from, address to, uint256 value)
136     external returns (bool);
137 
138   event Transfer(
139     address indexed from,
140     address indexed to,
141     uint256 value
142   );
143 
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 library SafeMath {
152 
153   /**
154   * @dev Multiplies two numbers, reverts on overflow.
155   */
156   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158     // benefit is lost if 'b' is also tested.
159     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
160     if (a == 0) {
161       return 0;
162     }
163 
164     uint256 c = a * b;
165     require(c / a == b);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
172   */
173   function div(uint256 a, uint256 b) internal pure returns (uint256) {
174     require(b > 0); // Solidity only automatically asserts when dividing by 0
175     uint256 c = a / b;
176     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178     return c;
179   }
180 
181   /**
182   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
183   */
184   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185     require(b <= a);
186     uint256 c = a - b;
187 
188     return c;
189   }
190 
191   /**
192   * @dev Adds two numbers, reverts on overflow.
193   */
194   function add(uint256 a, uint256 b) internal pure returns (uint256) {
195     uint256 c = a + b;
196     require(c >= a);
197 
198     return c;
199   }
200 
201   /**
202   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
203   * reverts when dividing by zero.
204   */
205   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206     require(b != 0);
207     return a % b;
208   }
209 }
210 
211 contract Pausable is Ownable {
212 
213     bool public paused = false;
214 
215     event Pause();
216     event Unpause();
217 
218     /**
219      * @dev Modifier to make a function callable only when the contract is not paused.
220      */
221     modifier whenNotPaused() {
222         require(!paused, "Has to be unpaused");
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      */
229     modifier whenPaused() {
230         require(paused, "Has to be paused");
231         _;
232     }
233 
234     /**
235      * @dev called by the owner to pause, triggers stopped state
236      */
237     function pause() public onlyOwner whenNotPaused {
238         paused = true;
239         emit Pause();
240     }
241 
242     /**
243      * @dev called by the owner to unpause, returns to normal state
244      */
245     function unpause() public onlyOwner whenPaused {
246         paused = false;
247         emit Unpause();
248     }
249 }
250 
251 contract OperatorRole {
252     using Roles for Roles.Role;
253 
254     event OperatorAdded(address indexed account);
255     event OperatorRemoved(address indexed account);
256 
257     Roles.Role private operators;
258 
259     modifier onlyOperator() {
260         require(isOperator(msg.sender), "Can be called only by contract operator");
261         _;
262     }
263 
264     function isOperator(address account) public view returns (bool) {
265         return operators.has(account);
266     }
267 
268     function _addOperator(address account) internal {
269         operators.add(account);
270         emit OperatorAdded(account);
271     }
272 
273     function _removeOperator(address account) internal {
274         operators.remove(account);
275         emit OperatorRemoved(account);
276     }
277 }
278 
279 contract ERC20Detailed is IERC20 {
280   string private _name;
281   string private _symbol;
282   uint8 private _decimals;
283 
284   constructor(string name, string symbol, uint8 decimals) public {
285     _name = name;
286     _symbol = symbol;
287     _decimals = decimals;
288   }
289 
290   /**
291    * @return the name of the token.
292    */
293   function name() public view returns(string) {
294     return _name;
295   }
296 
297   /**
298    * @return the symbol of the token.
299    */
300   function symbol() public view returns(string) {
301     return _symbol;
302   }
303 
304   /**
305    * @return the number of decimals of the token.
306    */
307   function decimals() public view returns(uint8) {
308     return _decimals;
309   }
310 }
311 
312 contract ERC20 is IERC20 {
313   using SafeMath for uint256;
314 
315   mapping (address => uint256) private _balances;
316 
317   mapping (address => mapping (address => uint256)) private _allowed;
318 
319   uint256 private _totalSupply;
320 
321   /**
322   * @dev Total number of tokens in existence
323   */
324   function totalSupply() public view returns (uint256) {
325     return _totalSupply;
326   }
327 
328   /**
329   * @dev Gets the balance of the specified address.
330   * @param owner The address to query the balance of.
331   * @return An uint256 representing the amount owned by the passed address.
332   */
333   function balanceOf(address owner) public view returns (uint256) {
334     return _balances[owner];
335   }
336 
337   /**
338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
339    * @param owner address The address which owns the funds.
340    * @param spender address The address which will spend the funds.
341    * @return A uint256 specifying the amount of tokens still available for the spender.
342    */
343   function allowance(
344     address owner,
345     address spender
346    )
347     public
348     view
349     returns (uint256)
350   {
351     return _allowed[owner][spender];
352   }
353 
354   /**
355   * @dev Transfer token for a specified address
356   * @param to The address to transfer to.
357   * @param value The amount to be transferred.
358   */
359   function transfer(address to, uint256 value) public returns (bool) {
360     _transfer(msg.sender, to, value);
361     return true;
362   }
363 
364   /**
365    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370    * @param spender The address which will spend the funds.
371    * @param value The amount of tokens to be spent.
372    */
373   function approve(address spender, uint256 value) public returns (bool) {
374     require(spender != address(0));
375 
376     _allowed[msg.sender][spender] = value;
377     emit Approval(msg.sender, spender, value);
378     return true;
379   }
380 
381   /**
382    * @dev Transfer tokens from one address to another
383    * @param from address The address which you want to send tokens from
384    * @param to address The address which you want to transfer to
385    * @param value uint256 the amount of tokens to be transferred
386    */
387   function transferFrom(
388     address from,
389     address to,
390     uint256 value
391   )
392     public
393     returns (bool)
394   {
395     require(value <= _allowed[from][msg.sender]);
396 
397     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
398     _transfer(from, to, value);
399     return true;
400   }
401 
402   /**
403    * @dev Increase the amount of tokens that an owner allowed to a spender.
404    * approve should be called when allowed_[_spender] == 0. To increment
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param spender The address which will spend the funds.
409    * @param addedValue The amount of tokens to increase the allowance by.
410    */
411   function increaseAllowance(
412     address spender,
413     uint256 addedValue
414   )
415     public
416     returns (bool)
417   {
418     require(spender != address(0));
419 
420     _allowed[msg.sender][spender] = (
421       _allowed[msg.sender][spender].add(addedValue));
422     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
423     return true;
424   }
425 
426   /**
427    * @dev Decrease the amount of tokens that an owner allowed to a spender.
428    * approve should be called when allowed_[_spender] == 0. To decrement
429    * allowed value is better to use this function to avoid 2 calls (and wait until
430    * the first transaction is mined)
431    * From MonolithDAO Token.sol
432    * @param spender The address which will spend the funds.
433    * @param subtractedValue The amount of tokens to decrease the allowance by.
434    */
435   function decreaseAllowance(
436     address spender,
437     uint256 subtractedValue
438   )
439     public
440     returns (bool)
441   {
442     require(spender != address(0));
443 
444     _allowed[msg.sender][spender] = (
445       _allowed[msg.sender][spender].sub(subtractedValue));
446     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
447     return true;
448   }
449 
450   /**
451   * @dev Transfer token for a specified addresses
452   * @param from The address to transfer from.
453   * @param to The address to transfer to.
454   * @param value The amount to be transferred.
455   */
456   function _transfer(address from, address to, uint256 value) internal {
457     require(value <= _balances[from]);
458     require(to != address(0));
459 
460     _balances[from] = _balances[from].sub(value);
461     _balances[to] = _balances[to].add(value);
462     emit Transfer(from, to, value);
463   }
464 
465   /**
466    * @dev Internal function that mints an amount of the token and assigns it to
467    * an account. This encapsulates the modification of balances such that the
468    * proper events are emitted.
469    * @param account The account that will receive the created tokens.
470    * @param value The amount that will be created.
471    */
472   function _mint(address account, uint256 value) internal {
473     require(account != 0);
474     _totalSupply = _totalSupply.add(value);
475     _balances[account] = _balances[account].add(value);
476     emit Transfer(address(0), account, value);
477   }
478 
479   /**
480    * @dev Internal function that burns an amount of the token of a given
481    * account.
482    * @param account The account whose tokens will be burnt.
483    * @param value The amount that will be burnt.
484    */
485   function _burn(address account, uint256 value) internal {
486     require(account != 0);
487     require(value <= _balances[account]);
488 
489     _totalSupply = _totalSupply.sub(value);
490     _balances[account] = _balances[account].sub(value);
491     emit Transfer(account, address(0), value);
492   }
493 
494   /**
495    * @dev Internal function that burns an amount of the token of a given
496    * account, deducting from the sender's allowance for said account. Uses the
497    * internal burn function.
498    * @param account The account whose tokens will be burnt.
499    * @param value The amount that will be burnt.
500    */
501   function _burnFrom(address account, uint256 value) internal {
502     require(value <= _allowed[account][msg.sender]);
503 
504     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
505     // this function needs to emit an event with the updated approval.
506     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
507       value);
508     _burn(account, value);
509   }
510 }
511 
512 contract PausableToken is ERC20, Pausable {
513 
514     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
515         return super.transfer(to, value);
516     }
517 
518     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
519         return super.transferFrom(from, to, value);
520     }
521 
522     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
523         return super.approve(spender, value);
524     }
525 
526     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
527         return super.increaseAllowance(spender, addedValue);
528     }
529 
530     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
531         return super.decreaseAllowance(spender, subtractedValue);
532     }
533 }
534 
535 contract IPCOToken is PausableToken, ERC20Detailed {
536     string public termsUrl = "http://xixoio.com/terms";
537     uint256 public hardCap;
538 
539     /**
540      * Token constructor, newly created token is paused
541      * @dev decimals are hardcoded to 18
542      */
543     constructor(string _name, string _symbol, uint256 _hardCap) ERC20Detailed(_name, _symbol, 18) public {
544         require(_hardCap > 0, "Hard cap can't be zero.");
545         require(bytes(_name).length > 0, "Name must be defined.");
546         require(bytes(_symbol).length > 0, "Symbol must be defined.");
547         hardCap = _hardCap;
548         pause();
549     }
550 
551     /**
552      * Minting function
553      * @dev doesn't allow minting of more tokens than hard cap
554      */
555     function mint(address to, uint256 value) public onlyOwner returns (bool) {
556         require(totalSupply().add(value) <= hardCap, "Mint of this amount would exceed the hard cap.");
557         _mint(to, value);
558         return true;
559     }
560 }
561 
562 
563 contract TokenSale is Ownable, OperatorRole {
564     using SafeMath for uint256;
565 
566     bool public finished = false;
567     uint256 public dailyLimit = 100000 ether;
568     mapping(uint256 => uint256) public dailyThroughput;
569 
570     IPCOToken public token;
571     ITokenPool public pool;
572 
573     event TransactionId(uint128 indexed id);
574 
575     /**
576      * Constructor
577      * @dev contract depends on IPCO Token and Token Pool
578      */
579     constructor(address tokenAddress, address poolAddress) public {
580         addOperator(msg.sender);
581         token = IPCOToken(tokenAddress);
582         pool = ITokenPool(poolAddress);
583     }
584 
585     /**
586      * @return Today's throughput of token, tracking both minted tokens and withdraws
587      */
588     function throughputToday() public view returns (uint256) {
589         return dailyThroughput[currentDay()];
590     }
591 
592     //
593     // Limited functions for operators
594     //
595 
596     function mint(address to, uint256 value, uint128 txId) public onlyOperator amountInLimit(value) {
597         _mint(to, value, txId);
598     }
599 
600     function mintToPool(uint128 account, uint256 value, uint128 txId) public onlyOperator amountInLimit(value) {
601         _mintToPool(account, value, txId);
602     }
603 
604     function withdraw(uint128 account, address to, uint256 value, uint128 txId) public onlyOperator amountInLimit(value) {
605         _withdraw(account, to, value, txId);
606     }
607 
608     function batchMint(address[] receivers, uint256[] values, uint128[] txIds) public onlyOperator amountsInLimit(values) {
609         require(receivers.length > 0, "Batch can't be empty");
610         require(receivers.length == values.length && receivers.length == txIds.length, "Invalid batch");
611         for (uint i; i < receivers.length; i++) {
612             _mint(receivers[i], values[i], txIds[i]);
613         }
614     }
615 
616     function batchMintToPool(uint128[] accounts, uint256[] values, uint128[] txIds) public onlyOperator amountsInLimit(values) {
617         require(accounts.length > 0, "Batch can't be empty");
618         require(accounts.length == values.length && accounts.length == txIds.length, "Invalid batch");
619         for (uint i; i < accounts.length; i++) {
620             _mintToPool(accounts[i], values[i], txIds[i]);
621         }
622     }
623 
624     function batchWithdraw(uint128[] accounts, address[] receivers, uint256[] values, uint128[] txIds) public onlyOperator amountsInLimit(values) {
625         require(accounts.length > 0, "Batch can't be empty.");
626         require(accounts.length == values.length && accounts.length == receivers.length && accounts.length == txIds.length, "Invalid batch");
627         for (uint i; i < accounts.length; i++) {
628             _withdraw(accounts[i], receivers[i], values[i], txIds[i]);
629         }
630     }
631 
632     //
633     // Unrestricted functions for the owner
634     //
635 
636     function unrestrictedMint(address to, uint256 value, uint128 txId) public onlyOwner {
637         _mint(to, value, txId);
638     }
639 
640     function unrestrictedMintToPool(uint128 account, uint256 value, uint128 txId) public onlyOwner {
641         _mintToPool(account, value, txId);
642     }
643 
644     function unrestrictedWithdraw(uint128 account, address to, uint256 value, uint128 txId) public onlyOwner {
645         _withdraw(account, to, value, txId);
646     }
647 
648     function addOperator(address operator) public onlyOwner {
649         _addOperator(operator);
650     }
651 
652     function removeOperator(address operator) public onlyOwner {
653         _removeOperator(operator);
654     }
655 
656     function replaceOperator(address operator, address newOperator) public onlyOwner {
657         _removeOperator(operator);
658         _addOperator(newOperator);
659     }
660 
661     function setDailyLimit(uint256 newDailyLimit) public onlyOwner {
662         dailyLimit = newDailyLimit;
663     }
664 
665     /**
666      * Concludes the sale - unpauses the token and renounces its ownership, effectively stopping minting indefinitely.
667      * @dev theoretically sale can be run with an unpaused token
668      */
669     function finish() public onlyOwner {
670         finished = true;
671         if (token.paused()) token.unpause();
672         pool.complete();
673         token.renounceOwnership();
674     }
675 
676     //
677     // Internal functions
678     //
679 
680     function _mint(address to, uint256 value, uint128 txId) internal {
681         token.mint(to, value);
682         emit TransactionId(txId);
683     }
684 
685     function _mintToPool(uint128 account, uint256 value, uint128 txId) internal {
686         token.mint(address(pool), value);
687         pool.allocate(account, value);
688         emit TransactionId(txId);
689     }
690 
691     function _withdraw(uint128 account, address to, uint256 value, uint128 txId) internal {
692         pool.withdraw(account, to, value);
693         emit TransactionId(txId);
694     }
695 
696     function _checkLimit(uint256 value) internal {
697         uint256 newValue = throughputToday().add(value);
698         require(newValue <= dailyLimit, "Amount to be minted exceeds day limit.");
699         dailyThroughput[currentDay()] = newValue;
700     }
701 
702     //
703     // Modifiers
704     //
705 
706     modifier amountInLimit(uint256 value) {
707         _checkLimit(value);
708         _;
709     }
710 
711     modifier amountsInLimit(uint256[] values) {
712         uint256 sum = 0;
713         for (uint i; i < values.length; i++) {
714             sum = sum.add(values[i]);
715         }
716         _checkLimit(sum);
717         _;
718     }
719 
720     //
721     // Private helpers
722     //
723 
724     function currentDay() private view returns (uint256) {
725         // solium-disable-next-line security/no-block-members, zeppelin/no-arithmetic-operations
726         return now / 1 days;
727     }
728 }