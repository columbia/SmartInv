1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 interface IERC20 {
86   function totalSupply() external view returns (uint256);
87 
88   function balanceOf(address who) external view returns (uint256);
89 
90   function allowance(address owner, address spender)
91     external view returns (uint256);
92 
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   function approve(address spender, uint256 value)
96     external returns (bool);
97 
98   function transferFrom(address from, address to, uint256 value)
99     external returns (bool);
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 value
105   );
106 
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract ERC20 is IERC20 {
190   using SafeMath for uint256;
191 
192   mapping (address => uint256) private _balances;
193 
194   mapping (address => mapping (address => uint256)) private _allowed;
195 
196   uint256 private _totalSupply;
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address owner,
222     address spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return _allowed[owner][spender];
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function transfer(address to, uint256 value) public returns (bool) {
237     _transfer(msg.sender, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param spender The address which will spend the funds.
248    * @param value The amount of tokens to be spent.
249    */
250   function approve(address spender, uint256 value) public returns (bool) {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = value;
254     emit Approval(msg.sender, spender, value);
255     return true;
256   }
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param from address The address which you want to send tokens from
261    * @param to address The address which you want to transfer to
262    * @param value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(
289     address spender,
290     uint256 addedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].add(addedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param spender The address which will spend the funds.
310    * @param subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseAllowance(
313     address spender,
314     uint256 subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     require(spender != address(0));
320 
321     _allowed[msg.sender][spender] = (
322       _allowed[msg.sender][spender].sub(subtractedValue));
323     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324     return true;
325   }
326 
327   /**
328   * @dev Transfer token for a specified addresses
329   * @param from The address to transfer from.
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function _transfer(address from, address to, uint256 value) internal {
334     require(value <= _balances[from]);
335     require(to != address(0));
336 
337     _balances[from] = _balances[from].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(from, to, value);
340   }
341 
342   /**
343    * @dev Internal function that mints an amount of the token and assigns it to
344    * an account. This encapsulates the modification of balances such that the
345    * proper events are emitted.
346    * @param account The account that will receive the created tokens.
347    * @param value The amount that will be created.
348    */
349   function _mint(address account, uint256 value) internal {
350     require(account != 0);
351     _totalSupply = _totalSupply.add(value);
352     _balances[account] = _balances[account].add(value);
353     emit Transfer(address(0), account, value);
354   }
355 
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burn(address account, uint256 value) internal {
363     require(account != 0);
364     require(value <= _balances[account]);
365 
366     _totalSupply = _totalSupply.sub(value);
367     _balances[account] = _balances[account].sub(value);
368     emit Transfer(account, address(0), value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account, deducting from the sender's allowance for said account. Uses the
374    * internal burn function.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burnFrom(address account, uint256 value) internal {
379     require(value <= _allowed[account][msg.sender]);
380 
381     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
382     // this function needs to emit an event with the updated approval.
383     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
384       value);
385     _burn(account, value);
386   }
387 }
388 
389 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
390 
391 /**
392  * @title ERC20Detailed token
393  * @dev The decimals are only for visualization purposes.
394  * All the operations are done using the smallest and indivisible token unit,
395  * just as on Ethereum all the operations are done in wei.
396  */
397 contract ERC20Detailed is IERC20 {
398   string private _name;
399   string private _symbol;
400   uint8 private _decimals;
401 
402   constructor(string name, string symbol, uint8 decimals) public {
403     _name = name;
404     _symbol = symbol;
405     _decimals = decimals;
406   }
407 
408   /**
409    * @return the name of the token.
410    */
411   function name() public view returns(string) {
412     return _name;
413   }
414 
415   /**
416    * @return the symbol of the token.
417    */
418   function symbol() public view returns(string) {
419     return _symbol;
420   }
421 
422   /**
423    * @return the number of decimals of the token.
424    */
425   function decimals() public view returns(uint8) {
426     return _decimals;
427   }
428 }
429 
430 // File: openzeppelin-solidity/contracts/access/Roles.sol
431 
432 /**
433  * @title Roles
434  * @dev Library for managing addresses assigned to a Role.
435  */
436 library Roles {
437   struct Role {
438     mapping (address => bool) bearer;
439   }
440 
441   /**
442    * @dev give an account access to this role
443    */
444   function add(Role storage role, address account) internal {
445     require(account != address(0));
446     require(!has(role, account));
447 
448     role.bearer[account] = true;
449   }
450 
451   /**
452    * @dev remove an account's access to this role
453    */
454   function remove(Role storage role, address account) internal {
455     require(account != address(0));
456     require(has(role, account));
457 
458     role.bearer[account] = false;
459   }
460 
461   /**
462    * @dev check if an account has this role
463    * @return bool
464    */
465   function has(Role storage role, address account)
466     internal
467     view
468     returns (bool)
469   {
470     require(account != address(0));
471     return role.bearer[account];
472   }
473 }
474 
475 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
476 
477 contract MinterRole {
478   using Roles for Roles.Role;
479 
480   event MinterAdded(address indexed account);
481   event MinterRemoved(address indexed account);
482 
483   Roles.Role private minters;
484 
485   constructor() internal {
486     _addMinter(msg.sender);
487   }
488 
489   modifier onlyMinter() {
490     require(isMinter(msg.sender));
491     _;
492   }
493 
494   function isMinter(address account) public view returns (bool) {
495     return minters.has(account);
496   }
497 
498   function addMinter(address account) public onlyMinter {
499     _addMinter(account);
500   }
501 
502   function renounceMinter() public {
503     _removeMinter(msg.sender);
504   }
505 
506   function _addMinter(address account) internal {
507     minters.add(account);
508     emit MinterAdded(account);
509   }
510 
511   function _removeMinter(address account) internal {
512     minters.remove(account);
513     emit MinterRemoved(account);
514   }
515 }
516 
517 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
518 
519 /**
520  * @title ERC20Mintable
521  * @dev ERC20 minting logic
522  */
523 contract ERC20Mintable is ERC20, MinterRole {
524   /**
525    * @dev Function to mint tokens
526    * @param to The address that will receive the minted tokens.
527    * @param value The amount of tokens to mint.
528    * @return A boolean that indicates if the operation was successful.
529    */
530   function mint(
531     address to,
532     uint256 value
533   )
534     public
535     onlyMinter
536     returns (bool)
537   {
538     _mint(to, value);
539     return true;
540   }
541 }
542 
543 // File: contracts/KDO.sol
544 
545 contract KDO is Ownable, ERC20Detailed, ERC20Mintable {
546   struct Ticket {
547     // Type of the ticket
548     string tType;
549 
550     // Creation date and expiration date
551     uint createdAt;
552     uint expireAt;
553 
554     address contractor;
555 
556     // The ticket has published a review
557     bool hasReviewed;
558   }
559 
560   // A contractor is someone that will be credited by tickets (clients)
561   struct Contractor {
562     // Its reviews
563     mapping (uint => uint) reviews;
564 
565     // Total of tickets
566     uint256 nbCredittedTickets;
567 
568     // Total of debitted tokens
569     uint256 debittedBalance;
570   }
571 
572   // Commission regarding the review average, the index is about the rating value
573   // the value is the commission in %
574   uint8[5] public commissions;
575 
576   mapping (address => Ticket) public tickets;
577 
578   // A contractor is a person who can consume ticketTypes and be credited for
579   mapping (address => Contractor) public contractors;
580 
581   event CreditEvt(address ticket, address contractor, string tType, uint256 date);
582   event DebitEvt(address contractor, uint256 amount, uint256 commission, uint256 date);
583   event ReviewEvt(address reviewer, address contractor, uint rate, uint256 date);
584   event CommissionsChangeEvt(uint8[5] commissions, uint256 date);
585 
586   mapping (uint256 => string) public ticketTypes;
587 
588   // Minimum base value for tickets 150000 Gwei
589   uint256 constant public MIN_TICKET_BASE_VALUE = 150000000000000;
590 
591   // Min and Max commission in %
592   uint256 constant public MIN_COMMISSION = 8;
593   uint256 constant public MAX_COMMISSION = 30;
594 
595   // Value to transfer to tickets when allocated
596   uint256 public ticketBaseValue;
597 
598   // .0% of 10e18 (1 = 0.1%, 10 = 1%)
599   uint256 public ticketCostBase;
600 
601   address private _businessOwner;
602 
603   constructor(uint8[5] _commissions, address __businessOwner)
604     ERC20Detailed("KDO Coin", "KDO", 0)
605     public
606   {
607     ticketBaseValue = MIN_TICKET_BASE_VALUE;
608     ticketCostBase = 3;
609 
610     updateCommissions(_commissions);
611 
612     _businessOwner = __businessOwner;
613   }
614 
615   // Only listed tickets
616   modifier onlyExistingTicketAmount(uint256 _amount) {
617     require(bytes(ticketTypes[_amount]).length > 0, '{error: UNKNOWN_TICKET}');
618     _;
619   }
620 
621   // Update the ticket base cost for following market value in case of crash or
622   // pump
623   // @param _value new ticket base cost
624   function updateTicketCostBase(uint256 _value) public
625     onlyOwner()
626   {
627     require(_value > 0 && _value <= 500, '{error: BAD_VALUE, message: "Should be > 0 and <= 500"}');
628     ticketCostBase = _value;
629   }
630 
631   // Update the ticket base value
632   // a ticket value is the amount of ether allowed to the ticket in order to
633   // be used
634   // @param _value is the base value change, in wei
635   function updateTicketBaseValue(uint256 _value) public
636     onlyOwner()
637   {
638     // Cant put a value below the minimal value
639     require(_value >= MIN_TICKET_BASE_VALUE, '{error: BAD_VALUE, message: "Value too low"}');
640     ticketBaseValue = _value;
641   }
642 
643   // Update the commissions
644   // @param _c are the new commissions
645   function updateCommissions(uint8[5] _c) public
646     onlyOwner()
647   {
648     for (uint i = 0; i <= 4; i++) {
649         require(_c[i] <= MAX_COMMISSION && _c[i] >= MIN_COMMISSION, '{error: BAD_VALUE, message: "A commission it too low or too high"}');
650     }
651     commissions = _c;
652     emit CommissionsChangeEvt(_c, now);
653   }
654 
655   // Add a new ticket type
656   // Can update an old ticket type, for instance :
657   // ticketTypes[99] = "bronze"
658   // addTicketType(99, "wood")
659   // ticketTypes[99] = "wood"
660   // ticket 99 has been updated from "bronze" to "wood"
661   // @param _amount is the ticket amount to update
662   // @param _key is the key to attribute to the amount
663   function addTicketType(uint256 _amount, string _key) public
664     onlyOwner()
665   {
666     ticketTypes[_amount] = _key;
667   }
668 
669   // Create a ticket using KDO tokens
670   // @param _to ticket to create
671   // @param _KDOAmount amount to allocate to the ticket
672   function allocateNewTicketWithKDO(address _to, uint256 _KDOAmount)
673     public
674     payable
675     onlyExistingTicketAmount(_KDOAmount)
676     returns (bool success)
677   {
678       require(msg.value >= ticketBaseValue, '{error: BAD_VALUE, message: "Value too low"}');
679 
680       _to.transfer(ticketBaseValue);
681 
682       super.transfer(_to, _KDOAmount);
683 
684       _createTicket(_to, _KDOAmount);
685 
686       return true;
687   }
688 
689   // Allocates a ticket to an address and create tokens (accordingly to the value of the allocated ticket)
690   // @param _to ticket to create
691   // @param _amount amount to allocate to the ticket
692   function allocateNewTicket(address _to, uint256 _amount)
693     public
694     payable
695     onlyExistingTicketAmount(_amount)
696     returns (bool success)
697   {
698     uint256 costInWei = costOfTicket(_amount);
699     require(msg.value == costInWei, '{error: BAD_VALUE, message: "Value should be equal to the cost of the ticket"}');
700 
701     // Give minimal WEI value to a ticket
702     _to.transfer(ticketBaseValue);
703 
704     // Price of the ticket transfered to the business owner address
705     _businessOwner.transfer(costInWei - ticketBaseValue);
706 
707     super.mint(_to, _amount);
708 
709     _createTicket(_to, _amount);
710 
711     return true;
712   }
713 
714   // Checks if an address can handle the ticket type
715   // @param _ticketAddr tocket to check
716   function isTicketValid(address _ticketAddr)
717     public
718     view
719     returns (bool valid)
720   {
721     if (tickets[_ticketAddr].contractor == 0x0 && now < tickets[_ticketAddr].expireAt) {
722       return true;
723     }
724     return false;
725   }
726 
727   // A ticket credit the contractor balance
728   // It triggers Consume event for logs
729   // @param _contractor contractor to credit
730   // @param _amount amount that will be creditted
731   function creditContractor(address _contractor, uint256 amount)
732     public
733     onlyExistingTicketAmount(amount)
734     returns (bool success)
735   {
736     require(isTicketValid(msg.sender), '{error: INVALID_TICKET}');
737 
738     super.transfer(_contractor, amount);
739 
740     contractors[_contractor].nbCredittedTickets += 1;
741 
742     tickets[msg.sender].contractor = _contractor;
743 
744     emit CreditEvt(msg.sender, _contractor, tickets[msg.sender].tType, now);
745 
746     return true;
747   }
748 
749   // Publish a review and rate the ticket's contractor (only consumed tickets can
750   // perform this action)
751   // @param _reviewRate rating of the review
752   function publishReview(uint _reviewRate) public {
753     // Only ticket that hasn't published any review and that has been consumed
754     require(!tickets[msg.sender].hasReviewed && tickets[msg.sender].contractor != 0x0, '{error: INVALID_TICKET}');
755 
756     // Only between 0 and 5
757     require(_reviewRate >= 0 && _reviewRate <= 5, '{error: INVALID_RATE, message: "A rate should be between 0 and 5 included"}');
758 
759     // Add the review to the contractor of the ticket
760     contractors[tickets[msg.sender].contractor].reviews[_reviewRate] += 1;
761 
762     tickets[msg.sender].hasReviewed = true;
763 
764     emit ReviewEvt(msg.sender, tickets[msg.sender].contractor, _reviewRate, now);
765   }
766 
767   // Calculate the average rating of a contractor
768   // @param _address contractor address
769   function reviewAverageOfContractor(address _address) public view returns (uint avg) {
770     // Percentage threshold
771     uint decreaseThreshold = 60;
772 
773     // Apply a penalty of -1 for reviews = 0
774     int totReviews = int(contractors[_address].reviews[0]) * -1;
775 
776     uint nbReviews = contractors[_address].reviews[0];
777 
778     for (uint i = 1; i <= 5; i++) {
779       totReviews += int(contractors[_address].reviews[i] * i);
780       nbReviews += contractors[_address].reviews[i];
781     }
782 
783     if (nbReviews == 0) {
784       return 250;
785     }
786 
787     // Too much penalties leads to 0, then force it to be 0, the average
788     // can't be negative
789     if (totReviews < 0) {
790       totReviews = 0;
791     }
792 
793     uint percReviewsTickets = (nbReviews * 100 / contractors[_address].nbCredittedTickets);
794 
795     avg = (uint(totReviews) * 100) / nbReviews;
796 
797     if (percReviewsTickets >= decreaseThreshold) {
798       return avg;
799     }
800 
801     // A rate < 60% on the number of reviews will decrease the rating average of
802     // the difference between the threshold and the % of reviews
803     // for instance a percent reviews of 50% will decrease the rating average
804     // of 10% (60% - 50%)
805     // This is to avoid abuse of the system, without this mecanism a contractor
806     // could stay with a average of 500 (the max) regardless of the number
807     // of ticket he used.
808     uint decreasePercent = decreaseThreshold - percReviewsTickets;
809 
810     return avg - (avg / decreasePercent);
811   }
812 
813   // Returns the commission for the contractor
814   // @param _address contractor address
815   function commissionForContractor(address _address) public view returns (uint8 c) {
816     return commissionForReviewAverageOf(reviewAverageOfContractor(_address));
817   }
818 
819   // Returns the info of a ticket
820   // @param _address ticket address
821   function infoOfTicket(address _address) public view returns (uint256 balance, string tType, bool isValid, uint createdAt, uint expireAt, address contractor, bool hasReviewed) {
822     return (super.balanceOf(_address), tickets[_address].tType, isTicketValid(_address), tickets[_address].createdAt, tickets[_address].expireAt, tickets[_address].contractor, tickets[_address].hasReviewed);
823   }
824 
825   // Returns the contractor info
826   // @param _address contractor address
827   function infoOfContractor(address _address) public view returns(uint256 balance, uint256 debittedBalance, uint256 nbReviews, uint256 nbCredittedTickets, uint256 avg) {
828     for (uint i = 0; i <= 5; i++) {
829       nbReviews += contractors[_address].reviews[i];
830     }
831 
832     return (super.balanceOf(_address), contractors[_address].debittedBalance, nbReviews, contractors[_address].nbCredittedTickets, reviewAverageOfContractor(_address));
833   }
834 
835   // Transfers contractors tokens to the owner
836   // It triggers Debit event
837   // @param _amount amount to debit
838   function debit(uint256 _amount) public {
839     super.transfer(super.owner(), _amount);
840 
841     emit DebitEvt(msg.sender, _amount, commissionForContractor(msg.sender), now);
842   }
843 
844   // Returns the cost of a ticket regarding its amount
845   // Returned value is represented in Wei
846   // @param _amount amount of the ticket
847   function costOfTicket(uint256 _amount) public view returns(uint256 cost) {
848     return (_amount * (ticketCostBase * 1000000000000000)) + ticketBaseValue;
849   }
850 
851   // Calculate the commission regarding the rating (review average)
852   // Example with a commissions = [30, 30, 30, 25, 20]
853   // [0,3[ = 30% (DefaultCommission)
854   // [3,4[ = 25%
855   // [4,5[ = 20%
856   // A rating average of 3.8 = 25% of commission
857   // @param _avg commission average
858   function commissionForReviewAverageOf(uint _avg) public view returns (uint8 c) {
859     if (_avg >= 500) {
860       return commissions[4];
861     }
862 
863     for (uint i = 0; i < 5; i++) {
864       if (_avg <= i * 100 || _avg < (i + 1) * 100) {
865         return commissions[i];
866       }
867     }
868 
869     // Default commission when there is something wrong
870     return commissions[0];
871   }
872 
873   function _createTicket(address _address, uint256 _amount) private {
874     tickets[_address] = Ticket({
875       tType: ticketTypes[_amount],
876       createdAt: now,
877       expireAt: now + 2 * 365 days,
878       contractor: 0x0,
879       hasReviewed: false
880     });
881   }
882 }