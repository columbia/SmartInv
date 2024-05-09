1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 interface IERC20 {
74   function totalSupply() external view returns (uint256);
75 
76   function balanceOf(address who) external view returns (uint256);
77 
78   function allowance(address owner, address spender)
79   external view returns (uint256);
80 
81   function transfer(address to, uint256 value) external returns (bool);
82 
83   function approve(address spender, uint256 value)
84   external returns (bool);
85 
86   function transferFrom(address from, address to, uint256 value)
87   external returns (bool);
88 
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint256 value
94   );
95 
96   event TransferWithData(address indexed from, address indexed to, uint value, bytes data);
97 
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
112  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract ERC20 is IERC20 {
115   using SafeMath for uint256;
116 
117   mapping (address => uint256) private _balances;
118 
119   mapping (address => mapping (address => uint256)) private _allowed;
120 
121   uint256 private _totalSupply;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return _totalSupply;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param owner The address to query the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address owner) public view returns (uint256) {
136     return _balances[owner];
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param owner address The address which owns the funds.
142    * @param spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(
146     address owner,
147     address spender
148   )
149   public
150   view
151   returns (uint256)
152   {
153     return _allowed[owner][spender];
154   }
155 
156 
157   /**
158    * @dev Transfer the specified amount of tokens to the specified address.
159    *      Invokes the `tokenFallback` function if the recipient is a contract.
160    *      The token transfer fails if the recipient is a contract
161    *      but does not implement the `tokenFallback` function
162    *      or the fallback function to receive funds.
163    *
164    * @param _to    Receiver address.
165    * @param _value Amount of tokens that will be transferred.
166    * @param _data  Transaction metadata.
167    */
168 
169   function transfer(address _to, uint _value, bytes _data) external returns (bool) {
170     // Standard function transfer similar to ERC20 transfer with no _data .
171     // Added due to backwards compatibility reasons .
172     uint codeLength;
173 
174     require(_value / 1000000000000000000 >= 1);
175 
176     assembly {
177     // Retrieve the size of the code on target address, this needs assembly .
178       codeLength := extcodesize(_to)
179     }
180 
181     _balances[msg.sender] = _balances[msg.sender].sub(_value);
182     _balances[_to] = _balances[_to].add(_value);
183     if (codeLength > 0) {
184       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
185 
186       receiver.tokenFallback(msg.sender, _value, _to);
187     }
188     emit TransferWithData(msg.sender, _to, _value, _data);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Transfer the specified amount of tokens to the specified address.
195    *      This function works the same with the previous one
196    *      but doesn't contain `_data` param.
197    *      Added due to backwards compatibility reasons.
198    *
199    * @param _to    Receiver address.
200    * @param _value Amount of tokens that will be transferred.
201    */
202   function transfer(address _to, uint _value) external returns (bool) {
203     uint codeLength;
204     bytes memory empty;
205 
206     require(_value / 1000000000000000000 >= 1);
207 
208     assembly {
209     // Retrieve the size of the code on target address, this needs assembly .
210       codeLength := extcodesize(_to)
211     }
212 
213     _balances[msg.sender] = _balances[msg.sender].sub(_value);
214     _balances[_to] = _balances[_to].add(_value);
215     if (codeLength > 0) {
216       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
217       receiver.tokenFallback(msg.sender, _value, address(this));
218     }
219 
220     emit Transfer(msg.sender, _to, _value);
221     emit TransferWithData(msg.sender, _to, _value, empty);
222     return true;
223   }
224 
225 
226   /**
227    * @dev Transfer the specified amount of tokens to the specified address.
228    *      This function works the same with the previous one
229    *      but doesn't contain `_data` param.
230    *      Added due to backwards compatibility reasons.
231    *
232    * @param _to    Receiver address.
233    * @param _value Amount of tokens that will be transferred.
234    */
235   function transferByCrowdSale(address _to, uint _value) external returns (bool) {
236     bytes memory empty;
237 
238     require(_value / 1000000000000000000 >= 1);
239 
240     _balances[msg.sender] = _balances[msg.sender].sub(_value);
241     _balances[_to] = _balances[_to].add(_value);
242 
243     emit Transfer(msg.sender, _to, _value);
244     emit TransferWithData(msg.sender, _to, _value, empty);
245     return true;
246   }
247 
248   function _transferGasByOwner(address _from, address _to, uint256 _value) internal {
249     _balances[_from] = _balances[_from].sub(_value);
250     _balances[_to] = _balances[_to].add(_value);
251     emit Transfer(_from, _to, _value);
252   }
253 
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param spender The address which will spend the funds.
262    * @param value The amount of tokens to be spent.
263    */
264   function approve(address spender, uint256 value) public returns (bool) {
265     require(spender != address(0));
266 
267     _allowed[msg.sender][spender] = value;
268     emit Approval(msg.sender, spender, value);
269     return true;
270   }
271 
272   /**
273    * @dev Transfer tokens from one address to another
274    * @param from address The address which you want to send tokens from
275    * @param to address The address which you want to transfer to
276    * @param value uint256 the amount of tokens to be transferred
277    */
278   function transferFrom(
279     address from,
280     address to,
281     uint256 value
282   )
283   public
284   returns (bool)
285   {
286     require(value <= _allowed[from][msg.sender]);
287 
288     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
289     _transfer(from, to, value);
290     return true;
291   }
292 
293   /**
294    * @dev Increase the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed_[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param spender The address which will spend the funds.
300    * @param addedValue The amount of tokens to increase the allowance by.
301    */
302   function increaseAllowance(
303     address spender,
304     uint256 addedValue
305   )
306   public
307   returns (bool)
308   {
309     require(spender != address(0));
310 
311     _allowed[msg.sender][spender] = (
312     _allowed[msg.sender][spender].add(addedValue));
313     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
314     return true;
315   }
316 
317   /**
318    * @dev Decrease the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed_[_spender] == 0. To decrement
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param spender The address which will spend the funds.
324    * @param subtractedValue The amount of tokens to decrease the allowance by.
325    */
326   function decreaseAllowance(
327     address spender,
328     uint256 subtractedValue
329   )
330   public
331   returns (bool)
332   {
333     require(spender != address(0));
334 
335     _allowed[msg.sender][spender] = (
336     _allowed[msg.sender][spender].sub(subtractedValue));
337     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
338     return true;
339   }
340 
341   /**
342   * @dev Transfer token for a specified addresses
343   * @param from The address to transfer from.
344   * @param to The address to transfer to.
345   * @param value The amount to be transferred.
346   */
347   function _transfer(address from, address to, uint256 value) internal {
348     require(value <= _balances[from]);
349     require(to != address(0));
350 
351     _balances[from] = _balances[from].sub(value);
352     _balances[to] = _balances[to].add(value);
353     emit TransferWithData(from, to, value, '');
354     emit Transfer(from, to, value);
355   }
356 
357   /**
358    * @dev Internal function that mints an amount of the token and assigns it to
359    * an account. This encapsulates the modification of balances such that the
360    * proper events are emitted.
361    * @param account The account that will receive the created tokens.
362    * @param value The amount that will be created.
363    */
364   function _mint(address account, uint256 value) internal {
365     require(account != 0);
366     _totalSupply = _totalSupply.add(value);
367     _balances[account] = _balances[account].add(value);
368     emit TransferWithData(address(0), account, value, '');
369     emit Transfer(address(0), account, value);
370   }
371 
372   /**
373    * @dev Internal function that burns an amount of the token of a given
374    * account.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burn(address account, uint256 value) internal {
379     require(account != 0);
380     require(value <= _balances[account]);
381 
382     _totalSupply = _totalSupply.sub(value);
383     _balances[account] = _balances[account].sub(value);
384     emit TransferWithData(account, address(0), value, '');
385     emit Transfer(account, address(0), value);
386   }
387 
388   /**
389    * @dev Internal function that burns an amount of the token of a given
390    * account, deducting from the sender's allowance for said account. Uses the
391    * internal burn function.
392    * @param account The account whose tokens will be burnt.
393    * @param value The amount that will be burnt.
394    */
395   function _burnFrom(address account, uint256 value) internal {
396     require(value <= _allowed[account][msg.sender]);
397 
398     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
399     // this function needs to emit an event with the updated approval.
400     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
401       value);
402     _burn(account, value);
403   }
404 }
405 
406 
407 /**
408  * @title Roles
409  * @dev Library for managing addresses assigned to a Role.
410  */
411 library Roles {
412   struct Role {
413     mapping (address => bool) bearer;
414   }
415 
416   /**
417    * @dev give an account access to this role
418    */
419   function add(Role storage role, address account) internal {
420     require(account != address(0));
421     role.bearer[account] = true;
422   }
423 
424   /**
425    * @dev remove an account's access to this role
426    */
427   function remove(Role storage role, address account) internal {
428     require(account != address(0));
429     role.bearer[account] = false;
430   }
431 
432   /**
433    * @dev check if an account has this role
434    * @return bool
435    */
436   function has(Role storage role, address account)
437   internal
438   view
439   returns (bool)
440   {
441     require(account != address(0));
442     return role.bearer[account];
443   }
444 }
445 
446 
447 contract MinterRole {
448   using Roles for Roles.Role;
449 
450   event MinterAdded(address indexed account);
451   event MinterRemoved(address indexed account);
452 
453   Roles.Role private minters;
454 
455   constructor() public {
456     _addMinter(msg.sender);
457   }
458 
459   modifier onlyMinter() {
460     require(isMinter(msg.sender));
461     _;
462   }
463 
464   function isMinter(address account) public view returns (bool) {
465     return minters.has(account);
466   }
467 
468   function addMinter(address account) public onlyMinter {
469     _addMinter(account);
470   }
471 
472   function renounceMinter() public {
473     _removeMinter(msg.sender);
474   }
475 
476   function _addMinter(address account) internal {
477     minters.add(account);
478     emit MinterAdded(account);
479   }
480 
481   function _removeMinter(address account) internal {
482     minters.remove(account);
483     emit MinterRemoved(account);
484   }
485 }
486 
487 
488 /**
489  * @title ERC20Mintable
490  * @dev ERC20 minting logic
491  */
492 contract ERC20Mintable is ERC20, MinterRole {
493   /**
494    * @dev Function to mint tokens
495    * @param to The address that will receive the minted tokens.
496    * @param value The amount of tokens to mint.
497    * @return A boolean that indicates if the operation was successful.
498    */
499   function mint(
500     address to,
501     uint256 value
502   )
503   public
504   onlyMinter
505   returns (bool)
506   {
507     _mint(to, value);
508     return true;
509   }
510 
511   function transferGasByOwner(address _from, address _to, uint256 _value) public onlyMinter returns (bool) {
512     super._transferGasByOwner(_from, _to, _value);
513     return true;
514   }
515 }
516 
517 
518 /**
519  * @title SimpleToken
520  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
521  * Note they can later distribute these tokens as they wish using `transfer` and other
522  * `ERC20` functions.
523  */
524 contract CryptoMusEstate is ERC20Mintable {
525 
526   string public constant name = "Mus#1";
527   string public constant symbol = "MUS#1";
528   uint8 public constant decimals = 18;
529 
530   uint256 public constant INITIAL_SUPPLY = 1000 * (10 ** uint256(decimals));
531 
532   /**
533    * @dev Constructor that gives msg.sender all of existing tokens.
534    */
535   constructor() public {
536     mint(msg.sender, INITIAL_SUPPLY);
537   }
538 
539 }
540 
541 
542 /**
543  * @title SimpleToken
544  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
545  * Note they can later distribute these tokens as they wish using `transfer` and other
546  * `ERC20` functions.
547  */
548 contract CryptoMusKRW is ERC20Mintable {
549 
550   string public constant name = "CryptoMus KRW Stable Token";
551   string public constant symbol = "KRWMus";
552   uint8 public constant decimals = 18;
553 
554   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
555 
556   /**
557    * @dev Constructor that gives msg.sender all of existing tokens.
558    */
559   constructor() public {
560     mint(msg.sender, INITIAL_SUPPLY);
561   }
562 
563 }
564 
565 
566 
567 /**
568  * @title Ownable
569  * @dev The Ownable contract has an owner address, and provides basic authorization control
570  * functions, this simplifies the implementation of "user permissions".
571  */
572 contract Ownable {
573   address private _owner;
574 
575   event OwnershipRenounced(address indexed previousOwner);
576   event OwnershipTransferred(
577     address indexed previousOwner,
578     address indexed newOwner
579   );
580 
581   /**
582    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
583    * account.
584    */
585   constructor() public {
586     _owner = msg.sender;
587   }
588 
589   /**
590    * @return the address of the owner.
591    */
592   function owner() public view returns (address) {
593     return _owner;
594   }
595 
596   /**
597    * @dev Throws if called by any account other than the owner.
598    */
599   modifier onlyOwner() {
600     require(isOwner());
601     _;
602   }
603 
604   /**
605    * @return true if `msg.sender` is the owner of the contract.
606    */
607   function isOwner() public view returns (bool) {
608     return msg.sender == _owner;
609   }
610 
611   /**
612    * @dev Allows the current owner to relinquish control of the contract.
613    * @notice Renouncing to ownership will leave the contract without an owner.
614    * It will not be possible to call the functions with the `onlyOwner`
615    * modifier anymore.
616    */
617   function renounceOwnership() public onlyOwner {
618     emit OwnershipRenounced(_owner);
619     _owner = address(0);
620   }
621 
622   /**
623    * @dev Allows the current owner to transfer control of the contract to a newOwner.
624    * @param newOwner The address to transfer ownership to.
625    */
626   function transferOwnership(address newOwner) public onlyOwner {
627     _transferOwnership(newOwner);
628   }
629 
630   /**
631    * @dev Transfers control of the contract to a newOwner.
632    * @param newOwner The address to transfer ownership to.
633    */
634   function _transferOwnership(address newOwner) internal {
635     require(newOwner != address(0));
636     emit OwnershipTransferred(_owner, newOwner);
637     _owner = newOwner;
638   }
639 }
640 
641 /**
642  * @title Crowdsale
643  * @dev Crowdsale is a base contract for managing a token crowdsale,
644  * allowing investors to purchase tokens with ether. This contract implements
645  * such functionality in its most fundamental form and can be extended to provide additional
646  * functionality and/or custom behavior.
647  * The external interface represents the basic interface for purchasing tokens, and conform
648  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
649  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
650  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
651  * behavior.
652  */
653 contract ERC223ReceivingContract is Ownable {
654   using SafeMath for uint256;
655 
656   // The token being sold
657   CryptoMusEstate private _token;
658   // The token being sold
659   CryptoMusKRW private _krwToken;
660 
661   // Address where funds are collected
662   address private _wallet;
663   address private _krwTokenAddress;
664 
665   // How many token units a buyer gets per wei.
666   // The rate is the conversion between wei and the smallest and indivisible token unit.
667   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
668   // 1 wei will give you 1 unit, or 0.001 TOK.
669   uint256 private _rate;
670 
671   // Amount of wei raised
672   uint256 private _weiRaised;
673 
674   /**
675    * Event for token purchase logging
676    * @param purchaser who paid for the tokens
677    * @param beneficiary who got the tokens
678    * @param value weis paid for purchase
679    * @param amount amount of tokens purchased
680    */
681   event TokensPurchased(
682     address indexed purchaser,
683     address indexed beneficiary,
684     uint256 value,
685     uint256 amount
686   );
687 
688   /**
689    * @param rate Number of token units a buyer gets per wei
690    * @dev The rate is the conversion between wei and the smallest and indivisible
691    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
692    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
693    * @param token Address of the token being sold
694    */
695   constructor(uint256 rate, CryptoMusEstate token, CryptoMusKRW krwToken) public {
696     require(rate > 0);
697 
698     require(token != address(0));
699 
700     _rate = rate;
701     _wallet = msg.sender;
702     _token = token;
703     _krwToken = krwToken;
704     _krwTokenAddress = krwToken;
705   }
706 
707   // -----------------------------------------
708   // Crowdsale external interface
709   // -----------------------------------------
710 
711 
712   function tokenFallback(address _from, uint _value, address _to) public {
713 
714     if(_krwTokenAddress != _to) {
715     } else {
716       buyTokens(_from, _value);
717     }
718   }
719 
720   /**
721    * @return the token being sold.
722    */
723   function token() public view returns (CryptoMusEstate) {
724     return _token;
725   }
726 
727   /**
728    * @return the address where funds are collected.
729    */
730   function wallet() public view returns (address) {
731     return _wallet;
732   }
733 
734   /**
735    * @return the number of token units a buyer gets per wei.
736    */
737   function rate() public view returns (uint256) {
738     return _rate;
739   }
740 
741   function setRate(uint256 setRate) public onlyOwner returns (uint256)
742   {
743     _rate = setRate;
744     return _rate;
745   }
746 
747   /**
748    * @return the mount of wei raised.
749    */
750   function weiRaised() public view returns (uint256) {
751     return _weiRaised;
752   }
753 
754   /**
755    * @dev low level token purchase ***DO NOT OVERRIDE***
756    * @param beneficiary Address performing the token purchase
757    */
758   function buyTokens(address beneficiary, uint _value) public {
759 
760     uint256 weiAmount = _value;
761     _preValidatePurchase(beneficiary, weiAmount);
762 
763     // calculate token amount to be created
764     uint256 tokens = _getTokenAmount(weiAmount);
765 
766     // update state
767     _weiRaised = _weiRaised.add(weiAmount);
768 
769     _processPurchase(beneficiary, tokens);
770     emit TokensPurchased(
771       msg.sender,
772       beneficiary,
773       weiAmount,
774       tokens
775     );
776 
777     _updatePurchasingState(beneficiary, weiAmount);
778 
779     _forwardFunds(_value);
780     _postValidatePurchase(beneficiary, weiAmount);
781   }
782 
783   // -----------------------------------------
784   // Internal interface (extensible)
785   // -----------------------------------------
786 
787   /**
788    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
789    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
790    *   super._preValidatePurchase(beneficiary, weiAmount);
791    *   require(weiRaised().add(weiAmount) <= cap);
792    * @param beneficiary Address performing the token purchase
793    * @param weiAmount Value in wei involved in the purchase
794    */
795   function _preValidatePurchase(
796     address beneficiary,
797     uint256 weiAmount
798   )
799   internal
800   {
801     require(beneficiary != address(0));
802     require(weiAmount != 0);
803   }
804 
805   /**
806    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
807    * @param beneficiary Address performing the token purchase
808    * @param weiAmount Value in wei involved in the purchase
809    */
810   function _postValidatePurchase(
811     address beneficiary,
812     uint256 weiAmount
813   )
814   internal
815   {
816     // optional override
817   }
818 
819   /**
820    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
821    * @param beneficiary Address performing the token purchase
822    * @param tokenAmount Number of tokens to be emitted
823    */
824   function _deliverTokens(
825     address beneficiary,
826     uint256 tokenAmount
827   )
828   internal
829   {
830     _token.transferByCrowdSale(beneficiary, tokenAmount);
831   }
832 
833   /**
834    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
835    * @param beneficiary Address receiving the tokens
836    * @param tokenAmount Number of tokens to be purchased
837    */
838   function _processPurchase(
839     address beneficiary,
840     uint256 tokenAmount
841   )
842   internal
843   {
844     _deliverTokens(beneficiary, tokenAmount);
845   }
846 
847   /**
848    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
849    * @param beneficiary Address receiving the tokens
850    * @param weiAmount Value in wei involved in the purchase
851    */
852   function _updatePurchasingState(
853     address beneficiary,
854     uint256 weiAmount
855   )
856   internal
857   {
858     // optional override
859   }
860 
861   /**
862    * @dev Override to extend the way in which ether is converted to tokens.
863    * @param weiAmount Value in wei to be converted into tokens
864    * @return Number of tokens that can be purchased with the specified _weiAmount
865    */
866   function _getTokenAmount(uint256 weiAmount)
867   internal view returns (uint256)
868   {
869     return weiAmount.mul(_rate);
870   }
871 
872   /**
873    * @dev Determines how ETH is stored/forwarded on purchases.
874    */
875   function _forwardFunds(uint _value) internal {
876 
877     _krwToken.transferByCrowdSale(_wallet, _value);
878   }
879 }