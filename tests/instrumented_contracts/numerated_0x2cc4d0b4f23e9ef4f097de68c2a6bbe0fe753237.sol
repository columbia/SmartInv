1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, reverts on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (a == 0) {
52       return 0;
53     }
54 
55     uint256 c = a * b;
56     require(c / a == b);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b > 0); // Solidity only automatically asserts when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69     return c;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     require(b <= a);
77     uint256 c = a - b;
78 
79     return c;
80   }
81 
82   /**
83   * @dev Adds two numbers, reverts on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     require(c >= a);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
94   * reverts when dividing by zero.
95   */
96   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b != 0);
98     return a % b;
99   }
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     _transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param spender The address which will spend the funds.
168    * @param value The amount of tokens to be spent.
169    */
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = value;
174     emit Approval(msg.sender, spender, value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param from address The address which you want to send tokens from
181    * @param to address The address which you want to transfer to
182    * @param value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address from,
186     address to,
187     uint256 value
188   )
189     public
190     returns (bool)
191   {
192     require(value <= _allowed[from][msg.sender]);
193 
194     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195     _transfer(from, to, value);
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212     public
213     returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218       _allowed[msg.sender][spender].add(addedValue));
219     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseAllowance(
233     address spender,
234     uint256 subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].sub(subtractedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248   * @dev Transfer token for a specified addresses
249   * @param from The address to transfer from.
250   * @param to The address to transfer to.
251   * @param value The amount to be transferred.
252   */
253   function _transfer(address from, address to, uint256 value) internal {
254     require(value <= _balances[from]);
255     require(to != address(0));
256 
257     _balances[from] = _balances[from].sub(value);
258     _balances[to] = _balances[to].add(value);
259     emit Transfer(from, to, value);
260   }
261 
262   /**
263    * @dev Internal function that mints an amount of the token and assigns it to
264    * an account. This encapsulates the modification of balances such that the
265    * proper events are emitted.
266    * @param account The account that will receive the created tokens.
267    * @param value The amount that will be created.
268    */
269   function _mint(address account, uint256 value) internal {
270     require(account != 0);
271     _totalSupply = _totalSupply.add(value);
272     _balances[account] = _balances[account].add(value);
273     emit Transfer(address(0), account, value);
274   }
275 
276   /**
277    * @dev Internal function that burns an amount of the token of a given
278    * account.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burn(address account, uint256 value) internal {
283     require(account != 0);
284     require(value <= _balances[account]);
285 
286     _totalSupply = _totalSupply.sub(value);
287     _balances[account] = _balances[account].sub(value);
288     emit Transfer(account, address(0), value);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal burn function.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burnFrom(address account, uint256 value) internal {
299     require(value <= _allowed[account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
304       value);
305     _burn(account, value);
306   }
307 }
308 
309 
310 /**
311  * @title ERC20Detailed token
312  * @dev The decimals are only for visualization purposes.
313  * All the operations are done using the smallest and indivisible token unit,
314  * just as on Ethereum all the operations are done in wei.
315  */
316 contract ERC20Detailed is IERC20 {
317   string private _name;
318   string private _symbol;
319   uint8 private _decimals;
320 
321   constructor(string name, string symbol, uint8 decimals) public {
322     _name = name;
323     _symbol = symbol;
324     _decimals = decimals;
325   }
326 
327   /**
328    * @return the name of the token.
329    */
330   function name() public view returns(string) {
331     return _name;
332   }
333 
334   /**
335    * @return the symbol of the token.
336    */
337   function symbol() public view returns(string) {
338     return _symbol;
339   }
340 
341   /**
342    * @return the number of decimals of the token.
343    */
344   function decimals() public view returns(uint8) {
345     return _decimals;
346   }
347 }
348 
349 
350 
351 /**
352  * @title Roles
353  * @dev Library for managing addresses assigned to a Role.
354  */
355 library Roles {
356   struct Role {
357     mapping (address => bool) bearer;
358   }
359 
360   /**
361    * @dev give an account access to this role
362    */
363   function add(Role storage role, address account) internal {
364     require(account != address(0));
365     require(!has(role, account));
366 
367     role.bearer[account] = true;
368   }
369 
370   /**
371    * @dev remove an account's access to this role
372    */
373   function remove(Role storage role, address account) internal {
374     require(account != address(0));
375     require(has(role, account));
376 
377     role.bearer[account] = false;
378   }
379 
380   /**
381    * @dev check if an account has this role
382    * @return bool
383    */
384   function has(Role storage role, address account)
385     internal
386     view
387     returns (bool)
388   {
389     require(account != address(0));
390     return role.bearer[account];
391   }
392 }
393 
394 contract MinterRole {
395   using Roles for Roles.Role;
396 
397   event MinterAdded(address indexed account);
398   event MinterRemoved(address indexed account);
399 
400   Roles.Role private minters;
401 
402   constructor() internal {
403     _addMinter(msg.sender);
404   }
405 
406   modifier onlyMinter() {
407     require(isMinter(msg.sender));
408     _;
409   }
410 
411   function isMinter(address account) public view returns (bool) {
412     return minters.has(account);
413   }
414 
415   function addMinter(address account) public onlyMinter {
416     _addMinter(account);
417   }
418 
419   function renounceMinter() public {
420     _removeMinter(msg.sender);
421   }
422 
423   function _addMinter(address account) internal {
424     minters.add(account);
425     emit MinterAdded(account);
426   }
427 
428   function _removeMinter(address account) internal {
429     minters.remove(account);
430     emit MinterRemoved(account);
431   }
432 }
433 
434 /**
435  * @title ERC20Mintable
436  * @dev ERC20 minting logic
437  */
438 contract ERC20Mintable is ERC20, MinterRole {
439   /**
440    * @dev Function to mint tokens
441    * @param to The address that will receive the minted tokens.
442    * @param value The amount of tokens to mint.
443    * @return A boolean that indicates if the operation was successful.
444    */
445   function mint(
446     address to,
447     uint256 value
448   )
449     public
450     onlyMinter
451     returns (bool)
452   {
453     _mint(to, value);
454     return true;
455   }
456 }
457 
458 
459 /**
460  * @title Burnable Token
461  * @dev Token that can be irreversibly burned (destroyed).
462  */
463 contract ERC20Burnable is ERC20 {
464 
465   /**
466    * @dev Burns a specific amount of tokens.
467    * @param value The amount of token to be burned.
468    */
469   function burn(uint256 value) public {
470     _burn(msg.sender, value);
471   }
472 
473   /**
474    * @dev Burns a specific amount of tokens from the target address and decrements allowance
475    * @param from address The address which you want to send tokens from
476    * @param value uint256 The amount of token to be burned
477    */
478   function burnFrom(address from, uint256 value) public {
479     _burnFrom(from, value);
480   }
481 }
482 
483 
484 
485 
486 contract PauserRole {
487   using Roles for Roles.Role;
488 
489   event PauserAdded(address indexed account);
490   event PauserRemoved(address indexed account);
491 
492   Roles.Role private pausers;
493 
494   constructor() internal {
495     _addPauser(msg.sender);
496   }
497 
498   modifier onlyPauser() {
499     require(isPauser(msg.sender));
500     _;
501   }
502 
503   function isPauser(address account) public view returns (bool) {
504     return pausers.has(account);
505   }
506 
507   function addPauser(address account) public onlyPauser {
508     _addPauser(account);
509   }
510 
511   function renouncePauser() public {
512     _removePauser(msg.sender);
513   }
514 
515   function _addPauser(address account) internal {
516     pausers.add(account);
517     emit PauserAdded(account);
518   }
519 
520   function _removePauser(address account) internal {
521     pausers.remove(account);
522     emit PauserRemoved(account);
523   }
524 }
525 
526 /**
527  * @title Pausable
528  * @dev Base contract which allows children to implement an emergency stop mechanism.
529  */
530 contract Pausable is PauserRole {
531   event Paused(address account);
532   event Unpaused(address account);
533 
534   bool private _paused;
535 
536   constructor() internal {
537     _paused = false;
538   }
539 
540   /**
541    * @return true if the contract is paused, false otherwise.
542    */
543   function paused() public view returns(bool) {
544     return _paused;
545   }
546 
547   /**
548    * @dev Modifier to make a function callable only when the contract is not paused.
549    */
550   modifier whenNotPaused() {
551     require(!_paused);
552     _;
553   }
554 
555   /**
556    * @dev Modifier to make a function callable only when the contract is paused.
557    */
558   modifier whenPaused() {
559     require(_paused);
560     _;
561   }
562 
563   /**
564    * @dev called by the owner to pause, triggers stopped state
565    */
566   function pause() public onlyPauser whenNotPaused {
567     _paused = true;
568     emit Paused(msg.sender);
569   }
570 
571   /**
572    * @dev called by the owner to unpause, returns to normal state
573    */
574   function unpause() public onlyPauser whenPaused {
575     _paused = false;
576     emit Unpaused(msg.sender);
577   }
578 }
579 
580 /**
581  * @title Pausable token
582  * @dev ERC20 modified with pausable transfers.
583  **/
584 contract ERC20Pausable is ERC20, Pausable {
585 
586   function transfer(
587     address to,
588     uint256 value
589   )
590     public
591     whenNotPaused
592     returns (bool)
593   {
594     return super.transfer(to, value);
595   }
596 
597   function transferFrom(
598     address from,
599     address to,
600     uint256 value
601   )
602     public
603     whenNotPaused
604     returns (bool)
605   {
606     return super.transferFrom(from, to, value);
607   }
608 
609   function approve(
610     address spender,
611     uint256 value
612   )
613     public
614     whenNotPaused
615     returns (bool)
616   {
617     return super.approve(spender, value);
618   }
619 
620   function increaseAllowance(
621     address spender,
622     uint addedValue
623   )
624     public
625     whenNotPaused
626     returns (bool success)
627   {
628     return super.increaseAllowance(spender, addedValue);
629   }
630 
631   function decreaseAllowance(
632     address spender,
633     uint subtractedValue
634   )
635     public
636     whenNotPaused
637     returns (bool success)
638   {
639     return super.decreaseAllowance(spender, subtractedValue);
640   }
641 }
642 
643 
644 contract PayUSD is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, ERC20Pausable {
645 
646     address public staker;
647     uint256 public transferFee = 0; // 1 % if feeDenominator = 10000
648     uint256 public mintFee = 100; // 1 % if feeDenominator = 10000
649     uint256 public burnFee = 100; // 1 % if feeDenominator = 10000
650     uint256 public feeDenominator = 10000;
651     uint256 public burnMin = 5000 * 10 ** 18;
652     uint256 public burnMax = 10000 * 10 ** 18;
653     address public owner = 0x0;
654     address public burnAddress;
655 
656     event ChangeStaker(address indexed addr);
657     event ChangeBurnAddress(address indexed addr);
658     event ChangeStakingFees (uint256 transferFee, uint256 mintFee, uint256 burnFee, uint256 feeDenominator);
659 
660     constructor(address _staker)
661         ERC20Burnable()
662         ERC20Mintable()
663         ERC20Pausable()
664         ERC20Detailed("PayUSD", "PUSD", 18)
665         ERC20()
666         public {
667         staker = _staker;
668     }
669 
670     function mint(address to, uint256 value) public onlyMinter returns (bool) {
671         bool result = super.mint(to, value);
672         payStakingFee(to, value, mintFee);
673         return result;
674     }
675 
676     function burn(uint256 value) public {
677         require(value >= burnMin && value <= burnMax);
678 
679         uint256 fees = payStakingFee(msg.sender, value, burnFee);
680         super.burn(value.sub(fees));
681     }
682 
683     function transfer(address to, uint256 value) public returns (bool) {
684         bool result = super.transfer(to, value);
685         payStakingFee(to, value, transferFee);
686         return result;   
687     }
688 
689     function transferFrom(address from, address to, uint256 value) public returns (bool) {
690         bool result = super.transferFrom(from, to, value);
691         payStakingFee(to, value, transferFee);
692         return result;
693     }
694 
695 
696     function payStakingFee(address _payer, uint256 _value, uint256 _fees) internal returns(uint256) {
697         uint256 stakingFee = _value.mul(_fees).div(feeDenominator);
698         if(stakingFee > 0) {
699             _transfer(_payer, staker, stakingFee);
700         } 
701         return stakingFee;
702     }
703 
704     function changeStakingFees(uint256 _transferFee, uint256 _mintFee, uint256 _burnFee, uint256 _feeDenominator) public onlyMinter {        
705         require(_transferFee < _feeDenominator, "_feeDenominator must be greater than _transferFee");
706         require(_mintFee < _feeDenominator, "_feeDenominator must be greater than _mintFee");
707         require(_burnFee < _feeDenominator, "_feeDenominator must be greater than _burnFee");
708 
709         transferFee = _transferFee; 
710         mintFee = _mintFee; 
711         burnFee = _burnFee;
712         feeDenominator = _feeDenominator;
713         
714         emit ChangeStakingFees(
715             transferFee,
716             mintFee,
717             burnFee,
718             feeDenominator
719         );
720     }
721 
722     function changeBurnBound(uint256 _burnMin, uint256 _burnMax) public onlyMinter {
723         require(_burnMin > 0);
724         require(_burnMax > _burnMin);
725         burnMin = _burnMin;
726         burnMax = _burnMax;
727     }
728 
729     function changeStaker(address _newStaker) public onlyMinter {
730         require(_newStaker != address(0), "new staker cannot be 0x0");
731         staker = _newStaker;
732         emit ChangeStaker(_newStaker);
733     }
734 
735     function changeBurnAddress(address _add) public onlyMinter {
736         burnAddress = _add;
737         emit ChangeBurnAddress(_add);
738     }
739 }