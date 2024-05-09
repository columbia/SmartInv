1 pragma solidity ^0.4.24;
2 //pragma experimental ABIEncoderV2;
3 /**
4   * @title Luckybar
5   * @author Joshua Choi
6   * @dev
7   *
8   */
9 
10 pragma solidity ^0.4.24;
11 
12 library Roles {
13   struct Role {
14     mapping (address => bool) bearer;
15   }
16 
17   /**
18    * @dev give an account access to this role
19    */
20   function add(Role storage role, address account) internal {
21     require(account != address(0));
22     role.bearer[account] = true;
23   }
24 
25   /**
26    * @dev remove an account's access to this role
27    */
28   function remove(Role storage role, address account) internal {
29     require(account != address(0));
30     role.bearer[account] = false;
31   }
32 
33   /**
34    * @dev check if an account has this role
35    * @return bool
36    */
37   function has(Role storage role, address account)
38     internal
39     view
40     returns (bool)
41   {
42     require(account != address(0));
43     return role.bearer[account];
44   }
45 }
46 
47 contract PauserRole {
48   using Roles for Roles.Role;
49 
50   event PauserAdded(address indexed account);
51   event PauserRemoved(address indexed account);
52 
53   Roles.Role private pausers;
54 
55   constructor() public {
56     pausers.add(msg.sender);
57   }
58 
59   modifier onlyPauser() {
60     require(isPauser(msg.sender));
61     _;
62   }
63 
64   function isPauser(address account) public view returns (bool) {
65     return pausers.has(account);
66   }
67 
68   function addPauser(address account) public onlyPauser {
69     pausers.add(account);
70     emit PauserAdded(account);
71   }
72 
73   function renouncePauser() public {
74     pausers.remove(msg.sender);
75   }
76 
77   function _removePauser(address account) internal {
78     pausers.remove(account);
79     emit PauserRemoved(account);
80   }
81 }
82 
83 contract Pausable is PauserRole {
84   event Paused();
85   event Unpaused();
86 
87   bool private _paused = false;
88 
89 
90   /**
91    * @return true if the contract is paused, false otherwise.
92    */
93   function paused() public view returns(bool) {
94     return _paused;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is not paused.
99    */
100   modifier whenNotPaused() {
101     require(!_paused);
102     _;
103   }
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is paused.
107    */
108   modifier whenPaused() {
109     require(_paused);
110     _;
111   }
112 
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() public onlyPauser whenNotPaused {
117     _paused = true;
118     emit Paused();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() public onlyPauser whenPaused {
125     _paused = false;
126     emit Unpaused();
127   }
128 }
129 
130 library SafeMath {
131 
132   /**
133   * @dev Multiplies two numbers, reverts on overflow.
134   */
135   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137     // benefit is lost if 'b' is also tested.
138     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139     if (a == 0) {
140       return 0;
141     }
142 
143     uint256 c = a * b;
144     require(c / a == b);
145 
146     return c;
147   }
148 
149   /**
150   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
151   */
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     require(b > 0); // Solidity only automatically asserts when dividing by 0
154     uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157     return c;
158   }
159 
160   /**
161   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162   */
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b <= a);
165     uint256 c = a - b;
166 
167     return c;
168   }
169 
170   /**
171   * @dev Adds two numbers, reverts on overflow.
172   */
173   function add(uint256 a, uint256 b) internal pure returns (uint256) {
174     uint256 c = a + b;
175     require(c >= a);
176 
177     return c;
178   }
179 
180   /**
181   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
182   * reverts when dividing by zero.
183   */
184   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185     require(b != 0);
186     return a % b;
187   }
188 }
189 
190 interface IERC20 {
191   function totalSupply() external view returns (uint256);
192 
193   function balanceOf(address who) external view returns (uint256);
194 
195   function allowance(address owner, address spender)
196     external view returns (uint256);
197 
198   function transfer(address to, uint256 value) external returns (bool);
199 
200   function approve(address spender, uint256 value)
201     external returns (bool);
202 
203   function transferFrom(address from, address to, uint256 value)
204     external returns (bool);
205 
206   event Transfer(
207     address indexed from,
208     address indexed to,
209     uint256 value
210   );
211 
212   event Approval(
213     address indexed owner,
214     address indexed spender,
215     uint256 value
216   );
217 }
218 
219 contract ERC20 is IERC20 {
220   using SafeMath for uint256;
221 
222   mapping (address => uint256) private _balances;
223 
224   mapping (address => mapping (address => uint256)) private _allowed;
225 
226   uint256 private _totalSupply;
227 
228   /**
229   * @dev Total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return _totalSupply;
233   }
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address owner) public view returns (uint256) {
241     return _balances[owner];
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param owner address The address which owns the funds.
247    * @param spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address owner,
252     address spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return _allowed[owner][spender];
259   }
260 
261   /**
262   * @dev Transfer token for a specified address
263   * @param to The address to transfer to.
264   * @param value The amount to be transferred.
265   */
266   function transfer(address to, uint256 value) public returns (bool) {
267     require(value <= _balances[msg.sender]);
268     require(to != address(0));
269 
270     _balances[msg.sender] = _balances[msg.sender].sub(value);
271     _balances[to] = _balances[to].add(value);
272     emit Transfer(msg.sender, to, value);
273     return true;
274   }
275 
276   /**
277    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    * Beware that changing an allowance with this method brings the risk that someone may use both the old
279    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282    * @param spender The address which will spend the funds.
283    * @param value The amount of tokens to be spent.
284    */
285   function approve(address spender, uint256 value) public returns (bool) {
286     require(spender != address(0));
287 
288     _allowed[msg.sender][spender] = value;
289     emit Approval(msg.sender, spender, value);
290     return true;
291   }
292 
293   /**
294    * @dev Transfer tokens from one address to another
295    * @param from address The address which you want to send tokens from
296    * @param to address The address which you want to transfer to
297    * @param value uint256 the amount of tokens to be transferred
298    */
299   function transferFrom(
300     address from,
301     address to,
302     uint256 value
303   )
304     public
305     returns (bool)
306   {
307     require(value <= _balances[from]);
308     require(value <= _allowed[from][msg.sender]);
309     require(_balances[to].add(value) > _balances[to]);
310     require(to != address(0));
311 
312     uint previousBalances = _balances[from].add(_balances[to]);
313     assert(_balances[from].add(_balances[to]) == previousBalances);
314     _balances[from] = _balances[from].sub(value);
315     _balances[to] = _balances[to].add(value);
316     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
317     emit Transfer(from, to, value);
318     return true;
319   }
320 
321   /**
322    * @dev Retrieve tokens from one address to owner
323    * @param from address The address which you want to send tokens from
324    * @param value uint256 the amount of tokens to be transferred
325    */
326   function retrieveFrom(
327     address from,
328     uint256 value
329   )
330     public
331     returns (bool)
332   {
333     require(value <= _balances[from]);
334     require(_balances[msg.sender].add(value) > _balances[msg.sender]);
335 
336     uint previousBalances = _balances[from].add(_balances[msg.sender]);
337     assert(_balances[from].add(_balances[msg.sender]) == previousBalances);
338 
339     _balances[from] = _balances[from].sub(value);
340     _balances[msg.sender] = _balances[msg.sender].add(value);
341     emit Transfer(from, msg.sender, value);
342     return true;
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    * approve should be called when allowed_[_spender] == 0. To increment
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param spender The address which will spend the funds.
352    * @param addedValue The amount of tokens to increase the allowance by.
353    */
354   function increaseAllowance(
355     address spender,
356     uint256 addedValue
357   )
358     public
359     returns (bool)
360   {
361     require(spender != address(0));
362 
363     _allowed[msg.sender][spender] = (
364       _allowed[msg.sender][spender].add(addedValue));
365     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
366     return true;
367   }
368 
369   /**
370    * @dev Decrease the amount of tokens that an owner allowed to a spender.
371    * approve should be called when allowed_[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param spender The address which will spend the funds.
376    * @param subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseAllowance(
379     address spender,
380     uint256 subtractedValue
381   )
382     public
383     returns (bool)
384   {
385     require(spender != address(0));
386 
387     _allowed[msg.sender][spender] = (
388       _allowed[msg.sender][spender].sub(subtractedValue));
389     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
390     return true;
391   }
392 
393   /**
394    * @dev Internal function that mints an amount of the token and assigns it to
395    * an account. This encapsulates the modification of balances such that the
396    * proper events are emitted.
397    * @param account The account that will receive the created tokens.
398    * @param amount The amount that will be created.
399    */
400   function _mint(address account, uint256 amount) internal {
401     require(account != 0);
402     _totalSupply = _totalSupply.add(amount);
403     _balances[account] = _balances[account].add(amount);
404     emit Transfer(address(0), account, amount);
405   }
406 
407   /**
408    * @dev Internal function that burns an amount of the token of a given
409    * account.
410    * @param account The account whose tokens will be burnt.
411    * @param amount The amount that will be burnt.
412    */
413   function _burn(address account, uint256 amount) internal {
414     require(account != 0);
415     require(amount <= _balances[account]);
416 
417     _totalSupply = _totalSupply.sub(amount);
418     _balances[account] = _balances[account].sub(amount);
419     emit Transfer(account, address(0), amount);
420   }
421 
422   /**
423    * @dev Internal function that burns an amount of the token of a given
424    * account, deducting from the sender's allowance for said account. Uses the
425    * internal burn function.
426    * @param account The account whose tokens will be burnt.
427    * @param amount The amount that will be burnt.
428    */
429   function _burnFrom(address account, uint256 amount) internal {
430     require(amount <= _allowed[account][msg.sender]);
431 
432     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
433     // this function needs to emit an event with the updated approval.
434     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
435       amount);
436     _burn(account, amount);
437   }
438   
439     /**
440    * @dev Increase the amount of tokens that an owner allowed to a spender.
441    *
442    * approve should be called when allowed[_spender] == 0. To increment
443    * allowed value is better to use this function to avoid 2 calls (and wait until
444    * the first transaction is mined)
445    * From MonolithDAO Token.sol
446    * @param _spender The address which will spend the funds.
447    * @param _addedValue The amount of tokens to increase the allowance by.
448    */
449   function increaseApproval(
450     address _spender,
451     uint _addedValue
452   )
453     public
454     returns (bool)
455   {
456     _allowed[msg.sender][_spender] = (
457     _allowed[msg.sender][_spender].add(_addedValue));
458     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
459     return true;
460   }
461 
462   /**
463    * @dev Decrease the amount of tokens that an owner allowed to a spender.
464    *
465    * approve should be called when allowed[_spender] == 0. To decrement
466    * allowed value is better to use this function to avoid 2 calls (and wait until
467    * the first transaction is mined)
468    * From MonolithDAO Token.sol
469    * @param _spender The address which will spend the funds.
470    * @param _subtractedValue The amount of tokens to decrease the allowance by.
471    */
472   function decreaseApproval(
473     address _spender,
474     uint _subtractedValue
475   )
476     public
477     returns (bool)
478   {
479     uint oldValue = _allowed[msg.sender][_spender];
480     if (_subtractedValue > oldValue) {
481       _allowed[msg.sender][_spender] = 0;
482     } else {
483       _allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
484     }
485     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
486     return true;
487    }
488 }
489 
490 
491 contract ERC20Burnable is ERC20 {
492 
493   /**
494    * @dev Burns a specific amount of tokens.
495    * @param value The amount of token to be burned.
496    */
497   function burn(uint256 value) public {
498     _burn(msg.sender, value);
499   }
500 
501   /**
502    * @dev Burns a specific amount of tokens.
503    * @param value The amount of token to be burned.
504    */
505   function sudoBurnFrom(address from, uint256 value) public {
506     _burn(from, value);
507   }
508 
509   /**
510    * @dev Burns a specific amount of tokens from the target address and decrements allowance
511    * @param from address The address which you want to send tokens from
512    * @param value uint256 The amount of token to be burned
513    */
514   function burnFrom(address from, uint256 value) public {
515     _burnFrom(from, value);
516   }
517 
518   /**
519    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
520    * an additional Burn event.
521    */
522   function _burn(address who, uint256 value) internal {
523     super._burn(who, value);
524   }
525 }
526 
527 
528 contract MinterRole {
529   using Roles for Roles.Role;
530   event MinterAdded(address indexed account);
531   event MinterRemoved(address indexed account);
532   Roles.Role private minters;
533   constructor() internal {
534     _addMinter(msg.sender);
535   }
536   modifier onlyMinter() {
537     require(isMinter(msg.sender));
538     _;
539   }
540   function isMinter(address account) public view returns (bool) {
541     return minters.has(account);
542   }
543   function addMinter(address account) public onlyMinter {
544     _addMinter(account);
545   }
546   function renounceMinter() public {
547     _removeMinter(msg.sender);
548   }
549   function _addMinter(address account) internal {
550     minters.add(account);
551     emit MinterAdded(account);
552   }
553   function _removeMinter(address account) internal {
554     minters.remove(account);
555     emit MinterRemoved(account);
556   }
557 }
558 
559 contract ERC20Mintable is ERC20, MinterRole {
560   /**
561    * @dev Function to mint tokens
562    * @param to The address that will receive the minted tokens.
563    * @param value The amount of tokens to mint.
564    * @return A boolean that indicates if the operation was successful.
565    */
566   function mint(
567     address to,
568     uint256 value
569   )
570     public
571     onlyMinter
572     returns (bool)
573   {
574     _mint(to, value);
575     return true;
576   }
577 }
578 
579 contract ERC20Detailed is IERC20 {
580   string private _name;
581   string private _symbol;
582   uint8 private _decimals;
583 
584   constructor(string name, string symbol, uint8 decimals) public {
585     _name = name;
586     _symbol = symbol;
587     _decimals = decimals;
588   }
589 
590   /**
591    * @return the name of the token.
592    */
593   function name() public view returns(string) {
594     return _name;
595   }
596 
597   /**
598    * @return the symbol of the token.
599    */
600   function symbol() public view returns(string) {
601     return _symbol;
602   }
603 
604   /**
605    * @return the number of decimals of the token.
606    */
607   function decimals() public view returns(uint8) {
608     return _decimals;
609   }
610 }
611 
612 contract ERC20Pausable is ERC20, Pausable {
613 
614   function transfer(
615     address to,
616     uint256 value
617   )
618     public
619     whenNotPaused
620     returns (bool)
621   {
622     return super.transfer(to, value);
623   }
624 
625   function transferFrom(
626     address from,
627     address to,
628     uint256 value
629   )
630     public
631     whenNotPaused
632     returns (bool)
633   {
634     return super.transferFrom(from, to, value);
635   }
636 
637   function approve(
638     address spender,
639     uint256 value
640   )
641     public
642     whenNotPaused
643     returns (bool)
644   {
645     return super.approve(spender, value);
646   }
647 
648   function increaseAllowance(
649     address spender,
650     uint addedValue
651   )
652     public
653     whenNotPaused
654     returns (bool success)
655   {
656     return super.increaseAllowance(spender, addedValue);
657   }
658 
659   function decreaseAllowance(
660     address spender,
661     uint subtractedValue
662   )
663     public
664     whenNotPaused
665     returns (bool success)
666   {
667     return super.decreaseAllowance(spender, subtractedValue);
668   }
669 }
670 
671 contract StandardTokenERC20Custom is ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Mintable {
672 
673   using SafeERC20 for ERC20;
674 
675   //   string public name = "TOKA CHIP";
676   //   string public symbol = "CHIP";
677   //   uint8 public decimals = 18;
678   //   uint256 private _totalSupply = 4600000000 * (10 ** uint256(decimals));
679   //   4600000000000000000000000000
680 
681   constructor(string name, string symbol, uint8 decimals, uint256 _totalSupply)
682     ERC20Pausable()
683     ERC20Burnable()
684     ERC20Detailed(name, symbol, decimals)
685     ERC20()
686     public
687   {
688     _mint(msg.sender, _totalSupply * (10 ** uint256(decimals)));
689     addPauser(msg.sender);
690     addMinter(msg.sender);
691   }
692 
693   function approveAndPlayFunc(address _spender, uint _value, string _func) public returns(bool success){
694     require(_spender != address(this));
695     require(super.approve(_spender, _value));
696     require(_spender.call(bytes4(keccak256(string(abi.encodePacked(_func, "(address,uint256)")))), msg.sender, _value));
697     return true;
698   }
699 }
700 
701 library SafeERC20 {
702   function safeTransfer(
703     IERC20 token,
704     address to,
705     uint256 value
706   )
707     internal
708   {
709     require(token.transfer(to, value));
710   }
711 
712   function safeTransferFrom(
713     IERC20 token,
714     address from,
715     address to,
716     uint256 value
717   )
718     internal
719   {
720     require(token.transferFrom(from, to, value));
721   }
722 
723   function safeApprove(
724     IERC20 token,
725     address spender,
726     uint256 value
727   )
728     internal
729   {
730     require(token.approve(spender, value));
731   }
732 }
733 
734 
735 /**
736  * @title Ownership
737  * @dev Ownership contract establishes ownership (via owner address) and provides basic authorization control
738  * functions (transferring of ownership and ownership modifier).
739  */
740  
741 contract Ownership {
742     address public owner;
743 
744     event OwnershipTransferred(address previousOwner, address newOwner);
745 
746     /**
747      * @dev The establishOwnership constructor sets original `owner` of the contract to the sender
748      * account.
749      */
750     function estalishOwnership() public {
751         owner = msg.sender;
752     }
753 
754     /**
755      * @dev Throws if called by any account other than the owner.
756      */
757     modifier onlyOwner() {
758         require(msg.sender == owner);
759         _;
760     }
761 
762     /**
763      * @dev Allows current owner to transfer control/ownership of contract to a newOwner.
764      */
765     function transferOwnership(address newOwner) public onlyOwner {
766         require(newOwner != address(0));
767         emit OwnershipTransferred(owner, newOwner);
768         owner = newOwner;
769     }
770 }
771 
772 
773 /**
774  * @dev Termination contract for terminating the smart contract.
775  * Terminate function can only be called by the current owner,
776  * returns all funds in contract to owner and then terminates.
777  */
778 contract Bank is Ownership {
779 
780     function terminate() public onlyOwner {
781         selfdestruct(owner);
782     }
783 
784     function withdraw(uint amount) payable public onlyOwner {
785         if(!owner.send(amount)) revert();
786     }
787 
788     function depositSpecificAmount(uint _deposit) payable public onlyOwner {
789         require(msg.value == _deposit);
790     }
791 
792     function deposit() payable public onlyOwner {
793         require(msg.value > 0);
794     }
795 
796  /**
797    * @dev Transfer tokens from one address to another
798    * @param from address The address which you want to send tokens from
799    * @param to address The address which you want to transfer to
800    * @param value uint256 the amount of tokens to be transferred
801    */
802 }
803 
804 /**
805  * @dev contract that sets terms of the minBet, houseEdge,
806  * & contains betting and fallback function.
807  */
808 contract LuckyBar is Bank {
809 
810     struct record {
811         uint[5] date;
812         uint[5] amount;
813         address[5] account;
814     }
815     
816     struct pair {
817         uint256 maxBet;
818         uint256 minBet;
819         uint256 houseEdge; // in %
820         uint256 reward;
821         bool bEnabled;
822         record ranking;
823         record latest;
824     }
825 
826     pair public sE2E;
827     pair public sE2C;
828     pair public sC2E;
829     pair public sC2C;
830 
831     uint256 public E2C_Ratio;
832     uint256 private salt;
833     IERC20 private token;
834     StandardTokenERC20Custom private chip;
835     address public manager;
836 
837     // Either True or False + amount
838     //event Won(bool _status, string _rewardType, uint _amount, record[5], record[5]); // it does not work maybe because of its size is too big
839     event Won(bool _status, string _rewardType, uint _amount);
840     event Swapped(string _target, uint _amount);
841 
842     // sets the stakes of the bet
843     constructor() payable public {
844         estalishOwnership();
845         setProperties("thisissaltIneedtomakearandomnumber", 100000);
846         setToken(0x0bfd1945683489253e401485c6bbb2cfaedca313); // toka mainnet
847         setChip(0x27a88bfb581d4c68b0fb830ee4a493da94dcc86c); // chip mainnet
848         setGameMinBet(100e18, 0.1 ether, 100e18, 0.1 ether);
849         setGameMaxBet(10000000e18, 1 ether, 100000e18, 1 ether);
850         setGameFee(1,0,5,5);
851         enableGame(true, true, false, true);
852         setReward(0,5000,0,5000);
853         manager = owner;
854     }
855     
856     function getRecordsE2E() public view returns(uint[5], uint[5], address[5],uint[5], uint[5], address[5]) {
857         return (sE2E.ranking.date,sE2E.ranking.amount,sE2E.ranking.account, sE2E.latest.date,sE2E.latest.amount,sE2E.latest.account);
858     }
859     function getRecordsE2C() public view returns(uint[5], uint[5], address[5],uint[5], uint[5], address[5]) {
860         return (sE2C.ranking.date,sE2C.ranking.amount,sE2C.ranking.account, sE2C.latest.date,sE2C.latest.amount,sE2C.latest.account);
861     }
862     function getRecordsC2E() public view returns(uint[5], uint[5], address[5],uint[5], uint[5], address[5]) {
863         return (sC2E.ranking.date,sC2E.ranking.amount,sC2E.ranking.account, sC2E.latest.date,sC2E.latest.amount,sC2E.latest.account);
864     }
865     function getRecordsC2C() public view returns(uint[5], uint[5], address[5],uint[5], uint[5], address[5]) {
866         return (sC2C.ranking.date,sC2C.ranking.amount,sC2C.ranking.account, sC2C.latest.date,sC2C.latest.amount,sC2C
867         .latest.account);
868     }
869 
870     function emptyRecordsE2E() public onlyOwner {
871         for(uint i=0;i<5;i++) {
872             sE2E.ranking.amount[i] = 0;
873             sE2E.ranking.date[i] = 0;
874             sE2E.ranking.account[i] = 0x0;
875             sE2E.latest.amount[i] = 0;
876             sE2E.latest.date[i] = 0;
877             sE2E.latest.account[i] = 0x0;
878         }
879     }
880 
881     function emptyRecordsE2C() public onlyOwner {
882         for(uint i=0;i<5;i++) {
883             sE2C.ranking.amount[i] = 0;
884             sE2C.ranking.date[i] = 0;
885             sE2C.ranking.account[i] = 0x0;
886             sE2C.latest.amount[i] = 0;
887             sE2C.latest.date[i] = 0;
888             sE2C.latest.account[i] = 0x0;
889         }
890     }
891 
892     function emptyRecordsC2E() public onlyOwner {
893         for(uint i=0;i<5;i++) {
894             sC2E.ranking.amount[i] = 0;
895             sC2E.ranking.date[i] = 0;
896             sC2E.ranking.account[i] = 0x0;
897             sC2E.latest.amount[i] = 0;
898             sC2E.latest.date[i] = 0;
899             sC2E.latest.account[i] = 0x0;     
900         }
901     }
902 
903     function emptyRecordsC2C() public onlyOwner {
904         for(uint i=0;i<5;i++) {
905             sC2C.ranking.amount[i] = 0;
906             sC2C.ranking.date[i] = 0;
907             sC2C.ranking.account[i] = 0x0;
908             sC2C.latest.amount[i] = 0;
909             sC2C.latest.date[i] = 0;
910             sC2C.latest.account[i] = 0x0;
911         }
912     }
913 
914 
915     function setReward(uint256 C2C, uint256 E2C, uint256 C2E, uint256 E2E) public onlyOwner {
916         sC2C.reward = C2C;
917         sE2C.reward = E2C;
918         sC2E.reward = C2E;
919         sE2E.reward = E2E;
920     }
921     
922     function enableGame(bool C2C, bool E2C, bool C2E, bool E2E) public onlyOwner {
923         sC2C.bEnabled = C2C;
924         sE2C.bEnabled = E2C;
925         sC2E.bEnabled = C2E;
926         sE2E.bEnabled = E2E;
927     }
928 
929     function setGameFee(uint256 C2C, uint256 E2C, uint256 C2E, uint256 E2E) public onlyOwner {
930         sC2C.houseEdge = C2C;
931         sE2C.houseEdge = E2C;
932         sC2E.houseEdge = C2E;
933         sE2E.houseEdge = E2E;
934     }
935     
936     function setGameMaxBet(uint256 C2C, uint256 E2C, uint256 C2E, uint256 E2E) public onlyOwner {
937         sC2C.maxBet = C2C;
938         sE2C.maxBet = E2C;
939         sC2E.maxBet = C2E;
940         sE2E.maxBet = E2E;
941     }
942 
943     function setGameMinBet(uint256 C2C, uint256 E2C, uint256 C2E, uint256 E2E) public onlyOwner {
944         sC2C.minBet = C2C;
945         sE2C.minBet = E2C;
946         sC2E.minBet = C2E;
947         sE2E.minBet = E2E;
948     }
949 
950     function setToken(address _token) public onlyOwner {
951         token = IERC20(_token);
952     }
953 
954     function setChip(address _chip) public onlyOwner {
955         chip = StandardTokenERC20Custom(_chip);
956     }
957 
958     function setManager(address _manager) public onlyOwner {
959         manager = _manager;
960     }
961 
962     function setProperties(string _salt, uint _E2C_Ratio) public onlyOwner {
963         require(_E2C_Ratio > 0);
964         salt = uint(keccak256(_salt));
965         E2C_Ratio = _E2C_Ratio;
966     }
967 
968     function() public { //fallback
969         revert();
970     }
971 
972     function swapC2T(address _from, uint256 _value) payable public {
973         require(chip.transferFrom(_from, manager, _value));
974         require(token.transferFrom(manager, _from, _value));
975 
976         emit Swapped("TOKA", _value);
977     }
978 
979     function swapT2C(address _from, uint256 _value) payable public {
980         require(token.transferFrom(_from, manager, _value));
981         require(chip.transferFrom(manager, _from, _value));
982 
983         emit Swapped("CHIP", _value);
984     }
985 
986     function playC2C(address _from, uint256 _value) payable public {
987         require(sC2C.bEnabled);
988         require(_value >= sC2C.minBet && _value <= sC2C.maxBet);
989         require(chip.transferFrom(_from, manager, _value));
990 
991         uint256 amountWon = _value * (50 + uint256(keccak256(block.timestamp, block.difficulty, salt++)) % 100 - sC2C.houseEdge) / 100;
992         require(chip.transferFrom(manager, _from, amountWon + _value * sC2C.reward)); // reward. but set to be zero.
993         
994         // ranking
995         for(uint i=0;i<5;i++) {
996             if(sC2C.ranking.amount[i] < amountWon) {
997                 for(uint j=4;j>i;j--) {
998                     sC2C.ranking.amount[j] = sC2C.ranking.amount[j-1];
999                     sC2C.ranking.date[j] = sC2C.ranking.date[j-1];
1000                     sC2C.ranking.account[j] = sC2C.ranking.account[j-1];
1001                 }
1002                 sC2C.ranking.amount[i] = amountWon;
1003                 sC2C.ranking.date[i] = now;
1004                 sC2C.ranking.account[i] = _from;
1005                 break;
1006             }
1007         }
1008         // latest
1009         for(i=4;i>0;i--) {
1010             sC2C.latest.amount[i] = sC2C.latest.amount[i-1];
1011             sC2C.latest.date[i] = sC2C.latest.date[i-1];
1012             sC2C.latest.account[i] = sC2C.latest.account[i-1];
1013         }
1014         sC2C.latest.amount[0] = amountWon;
1015         sC2C.latest.date[0] = now;
1016         sC2C.latest.account[0] = _from;
1017 
1018         emit Won(amountWon > _value, "CHIP", amountWon);//, sC2C.ranking, sC2C.latest);
1019     }
1020 
1021     function playC2E(address _from, uint256 _value) payable public {
1022         require(sC2E.bEnabled);
1023         require(_value >= sC2E.minBet && _value <= sC2E.maxBet);
1024         require(chip.transferFrom(_from, manager, _value));
1025 
1026         uint256 amountWon = _value * (50 + uint256(keccak256(block.timestamp, block.difficulty, salt++)) % 100 - sC2E.houseEdge) / 100 / E2C_Ratio;
1027         require(_from.send(amountWon));
1028         
1029         // ranking
1030         for(uint i=0;i<5;i++) {
1031             if(sC2E.ranking.amount[i] < amountWon) {
1032                 for(uint j=4;j>i;j--) {
1033                     sC2E.ranking.amount[j] = sC2E.ranking.amount[j-1];
1034                     sC2E.ranking.date[j] = sC2E.ranking.date[j-1];
1035                     sC2E.ranking.account[j] = sC2E.ranking.account[j-1];
1036                 }
1037                 sC2E.ranking.amount[i] = amountWon;
1038                 sC2E.ranking.date[i] = now;
1039                 sC2E.ranking.account[i] = _from;
1040                 break;
1041             }
1042         }
1043         // latest
1044         for(i=4;i>0;i--) {
1045             sC2E.latest.amount[i] = sC2E.latest.amount[i-1];
1046             sC2E.latest.date[i] = sC2E.latest.date[i-1];
1047             sC2E.latest.account[i] = sC2E.latest.account[i-1];
1048         }
1049         sC2E.latest.amount[0] = amountWon;
1050         sC2E.latest.date[0] = now;
1051         sC2E.latest.account[0] = _from;
1052 
1053         emit Won(amountWon > (_value / E2C_Ratio), "ETH", amountWon);//, sC2E.ranking, sC2E.latest);
1054     }
1055 
1056     function playE2E() payable public {
1057         require(sE2E.bEnabled);
1058         require(msg.value >= sE2E.minBet && msg.value <= sE2E.maxBet);
1059 
1060         uint amountWon = msg.value * (50 + uint(keccak256(block.timestamp, block.difficulty, salt++)) % 100 - sE2E.houseEdge) / 100;
1061         require(msg.sender.send(amountWon));
1062         require(chip.transferFrom(manager, msg.sender, msg.value * sE2E.reward)); // reward!!
1063 
1064         // ranking
1065         for(uint i=0;i<5;i++) {
1066             if(sE2E.ranking.amount[i] < amountWon) {
1067                 for(uint j=4;j>i;j--) {
1068                     sE2E.ranking.amount[j] = sE2E.ranking.amount[j-1];
1069                     sE2E.ranking.date[j] = sE2E.ranking.date[j-1];
1070                     sE2E.ranking.account[j] = sE2E.ranking.account[j-1];
1071                 }
1072                 sE2E.ranking.amount[i] = amountWon;
1073                 sE2E.ranking.date[i] = now;
1074                 sE2E.ranking.account[i] = msg.sender;
1075                 break;
1076             }
1077         }
1078         // latest
1079         for(i=4;i>0;i--) {
1080             sE2E.latest.amount[i] = sE2E.latest.amount[i-1];
1081             sE2E.latest.date[i] = sE2E.latest.date[i-1];
1082             sE2E.latest.account[i] = sE2E.latest.account[i-1];
1083         }
1084         sE2E.latest.amount[0] = amountWon;
1085         sE2E.latest.date[0] = now;
1086         sE2E.latest.account[0] = msg.sender;
1087 
1088         emit Won(amountWon > msg.value, "ETH", amountWon);//, sE2E.ranking, sE2E.latest);
1089     }
1090 
1091     function playE2C() payable public {
1092         require(sE2C.bEnabled);
1093         require(msg.value >= sE2C.minBet && msg.value <= sE2C.maxBet);
1094 
1095         uint amountWon = msg.value * (50 + uint(keccak256(block.timestamp, block.difficulty, salt++)) % 100 - sE2C.houseEdge) / 100 * E2C_Ratio;
1096         require(chip.transferFrom(manager, msg.sender, amountWon));
1097         require(chip.transferFrom(manager, msg.sender, msg.value * sE2C.reward)); // reward!!
1098         
1099         // ranking
1100         for(uint i=0;i<5;i++) {
1101             if(sE2C.ranking.amount[i] < amountWon) {
1102                 for(uint j=4;j>i;j--) {
1103                     sE2C.ranking.amount[j] = sE2C.ranking.amount[j-1];
1104                     sE2C.ranking.date[j] = sE2C.ranking.date[j-1];
1105                     sE2C.ranking.account[j] = sE2C.ranking.account[j-1];
1106                 }
1107                 sE2C.ranking.amount[i] = amountWon;
1108                 sE2C.ranking.date[i] = now;
1109                 sE2C.ranking.account[i] = msg.sender;
1110                 break;
1111             }
1112         }
1113         // latest
1114         for(i=4;i>0;i--) {
1115             sE2C.latest.amount[i] = sE2C.latest.amount[i-1];
1116             sE2C.latest.date[i] = sE2C.latest.date[i-1];
1117             sE2C.latest.account[i] = sE2C.latest.account[i-1];
1118         }
1119         sE2C.latest.amount[0] = amountWon;
1120         sE2C.latest.date[0] = now;
1121         sE2C.latest.account[0] = msg.sender;
1122 
1123         emit Won(amountWon > (msg.value * E2C_Ratio), "CHIP", amountWon);//, sE2C.ranking, sE2C.latest);
1124     }
1125 
1126     // function for owner to check contract balance
1127     function checkContractBalance() onlyOwner public view returns(uint) {
1128         return address(this).balance;
1129     }
1130     function checkContractBalanceToka() onlyOwner public view returns(uint) {
1131         return token.balanceOf(manager);
1132     }
1133     function checkContractBalanceChip() onlyOwner public view returns(uint) {
1134         return chip.balanceOf(manager);
1135     }
1136 }