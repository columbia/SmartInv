1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address _owner, address _spender)
30     public view returns (uint256);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 
49 
50 /**
51  * @title SafeERC20
52  * @dev Wrappers around ERC20 operations that throw on failure.
53  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
54  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
55  */
56 library SafeERC20 {
57   function safeTransfer(
58     ERC20Basic _token,
59     address _to,
60     uint256 _value
61   )
62     internal
63   {
64     require(_token.transfer(_to, _value));
65   }
66 
67   function safeTransferFrom(
68     ERC20 _token,
69     address _from,
70     address _to,
71     uint256 _value
72   )
73     internal
74   {
75     require(_token.transferFrom(_from, _to, _value));
76   }
77 
78   function safeApprove(
79     ERC20 _token,
80     address _spender,
81     uint256 _value
82   )
83     internal
84   {
85     require(_token.approve(_spender, _value));
86   }
87 }
88 
89 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
90 
91 pragma solidity ^0.4.24;
92 
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100   /**
101   * @dev Multiplies two numbers, throws on overflow.
102   */
103   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
105     // benefit is lost if 'b' is also tested.
106     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107     if (_a == 0) {
108       return 0;
109     }
110 
111     c = _a * _b;
112     assert(c / _a == _b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
120     // assert(_b > 0); // Solidity automatically throws when dividing by 0
121     // uint256 c = _a / _b;
122     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
123     return _a / _b;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
130     assert(_b <= _a);
131     return _a - _b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
138     c = _a + _b;
139     assert(c >= _a);
140     return c;
141   }
142 }
143 
144 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
145 
146 pragma solidity ^0.4.24;
147 
148 
149 
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) internal balances;
159 
160   uint256 internal totalSupply_;
161 
162   /**
163   * @dev Total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev Transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_value <= balances[msg.sender]);
176     require(_to != address(0));
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
196 
197 pragma solidity ^0.4.24;
198 
199 
200 
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/Burnable.sol
322 
323 pragma solidity ^0.4.24;
324 
325 
326 /**
327  * @title Burnable Token
328  * @dev Token that can be irreversibly burned (destroyed).
329  */
330 contract Burnable is StandardToken {
331 
332   event Burn(address indexed burner, uint256 value);
333 
334   /**
335    * @dev Burns a specific amount of tokens.
336    * @param _value The amount of token to be burned.
337    */
338   function burn(uint256 _value) public {
339     _burn(msg.sender, _value);
340   }
341 
342   function _burn(address _who, uint256 _value) internal {
343     require(_value <= balances[_who]);
344     // no need to require value <= totalSupply, since that would imply the
345     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
346 
347     balances[_who] = balances[_who].sub(_value);
348     totalSupply_ = totalSupply_.sub(_value);
349     emit Burn(_who, _value);
350     emit Transfer(_who, address(0), _value);
351   }
352 
353 }
354 
355 // File: contracts/Ownable.sol
356 
357 pragma solidity ^0.4.24;
358 
359 
360 /**
361  * @title Ownable
362  * @dev The Ownable contract has an owner address, and provides basic authorization control
363  * functions, this simplifies the implementation of "user permissions".
364  */
365 contract Ownable is Burnable {
366 
367   address public owner;
368   address public ownerCandidate;
369 
370   /**
371    * @dev Fired whenever ownership is successfully transferred.
372    */
373   event OwnershipTransferred(
374     address indexed previousOwner,
375     address indexed newOwner
376   );
377 
378   /**
379    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
380    * account.
381    */
382   constructor() public {
383     owner = msg.sender;
384   }
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Allows the current owner to transfer control of the contract to a new owner.
396    * @param _newOwner The address to transfer ownership to.
397    */
398   function transferOwnership(address _newOwner) public onlyOwner {
399     _transferOwnership(_newOwner);
400   }
401 
402   /**
403    * @dev Transfers control of the contract to a new owner.
404    * @param _newOwner The address to transfer ownership to.
405    */
406   function _transferOwnership(address _newOwner) internal {
407     require(_newOwner != address(0));
408     ownerCandidate = _newOwner;
409   }
410 
411   /**
412    * @dev New ownerschip Confirmation.
413    */
414   function acceptOwnership() public {
415     _acceptOwnership();
416   }
417 
418   /**
419    * @dev New ownerschip confirmation internal.
420    */
421   function _acceptOwnership() internal {
422     require(msg.sender == ownerCandidate);
423     emit OwnershipTransferred(owner, ownerCandidate);
424     owner = ownerCandidate;
425     ownerCandidate = address(0);
426   }
427 
428   /**
429    * @dev Transfers the current balance to the owner and terminates the contract.
430    * In case stuff goes bad.
431    */
432   function destroy() public onlyOwner {
433     selfdestruct(owner);
434   }
435 
436   function destroyAndSend(address _recipient) public onlyOwner {
437     selfdestruct(_recipient);
438   }
439 
440 }
441 
442 // File: contracts/Administrable.sol
443 
444 pragma solidity ^0.4.24;
445 
446 
447 
448 /**
449  * @title Ownable
450  * @dev The authentication manager details user accounts that have access to certain priviledges.
451  */
452 contract Administrable is Ownable {
453 
454   using SafeERC20 for ERC20Basic;
455   
456   /**
457    * @dev Map addresses to admins.
458    */
459   mapping (address => bool) admins;
460 
461   /**
462    * @dev All admins that have ever existed.
463    */
464   address[] adminAudit;
465 
466   /**
467    * @dev Globally enable or disable admin access.
468    */
469   bool allowAdmins = true;
470 
471    /**
472    * @dev Fired whenever an admin is added to the contract.
473    */
474   event AdminAdded(address addedBy, address admin);
475 
476   /**
477    * @dev Fired whenever an admin is removed from the contracts.
478    */
479   event AdminRemoved(address removedBy, address admin);
480 
481   /**
482    * @dev Throws if called by any account other than the active admin or owner.
483    */
484   modifier onlyAdmin {
485     require(isCurrentAciveAdmin(msg.sender));
486     _;
487   }
488 
489   /**
490    * @dev Turn on admin role
491    */
492   function enableAdmins() public onlyOwner {
493     require(allowAdmins == false);
494     allowAdmins = true;
495   }
496 
497   /**
498    * @dev Turn off admin role
499    */
500   function disableAdmins() public onlyOwner {
501     require(allowAdmins);
502     allowAdmins = false;
503   }
504 
505   /**
506    * @dev Gets whether or not the specified address is currently an admin.
507    */
508   function isCurrentAdmin(address _address) public view returns (bool) {
509     if(_address == owner)
510       return true;
511     else
512       return admins[_address];
513   }
514 
515   /**
516    * @dev Gets whether or not the specified address is currently an active admin.
517    */
518   function isCurrentAciveAdmin(address _address) public view returns (bool) {
519     if(_address == owner)
520       return true;
521     else
522       return allowAdmins && admins[_address];
523   }
524 
525   /**
526    * @dev Gets whether or not the specified address has ever been an admin.
527    */
528   function isCurrentOrPastAdmin(address _address) public view returns (bool) {
529     for (uint256 i = 0; i < adminAudit.length; i++)
530       if (adminAudit[i] == _address)
531         return true;
532     return false;
533   }
534 
535   /**
536    * @dev Adds a user to our list of admins.
537    */
538   function addAdmin(address _address) public onlyOwner {
539     require(admins[_address] == false);
540     admins[_address] = true;
541     emit AdminAdded(msg.sender, _address);
542     adminAudit.length++;
543     adminAudit[adminAudit.length - 1] = _address;
544   }
545 
546   /**
547    * @dev Removes a user from our list of admins but keeps them in the history.
548    */
549   function removeAdmin(address _address) public onlyOwner {
550     require(_address != msg.sender);
551     require(admins[_address]);
552     admins[_address] = false;
553     emit AdminRemoved(msg.sender, _address);
554   }
555 
556   /**
557    * @dev Reclaim all ERC20Basic compatible tokens
558    * @param _token ERC20Basic The address of the token contract
559    */
560   function reclaimToken(ERC20Basic _token) external onlyAdmin {
561     uint256 balance = _token.balanceOf(this);
562     _token.safeTransfer(msg.sender, balance);
563   }
564 
565 }
566 
567 // File: contracts/Pausable.sol
568 
569 pragma solidity ^0.4.24;
570 
571 
572 /**
573  * @title Pausable
574  * @dev Base contract which allows children to implement an emergency stop mechanism.
575  */
576 contract Pausable is Administrable {
577   event Pause();
578   event Unpause();
579 
580   bool public paused = false;
581 
582   /**
583    * @dev Modifier to make a function callable only when the contract is not paused.
584    */
585   modifier whenNotPaused() {
586     require(!paused);
587     _;
588   }
589 
590   /**
591    * @dev Modifier to make a function callable only when the contract is paused.
592    */
593   modifier whenPaused() {
594     require(paused);
595     _;
596   }
597 
598   /**
599    * @dev called by the owner to pause, triggers stopped state
600    */
601   function pause() public onlyAdmin whenNotPaused {
602     paused = true;
603     emit Pause();
604   }
605 
606   /**
607    * @dev called by the owner to unpause, returns to normal state
608    */
609   function unpause() public onlyAdmin whenPaused {
610     paused = false;
611     emit Unpause();
612   }
613 
614 }
615 
616 // File: contracts/Rento.sol
617 
618 pragma solidity ^0.4.24;
619 
620 
621 contract Rento is Pausable {
622 
623   using SafeMath for uint256;
624 
625   string public name = "Rento";
626   string public symbol = "RTO";
627   uint8 public decimals = 8;
628 
629   /**
630    * @dev representing 1.0.
631    */
632   uint256 public constant UNIT      = 100000000;
633 
634   uint256 constant INITIAL_SUPPLY   = 600000000 * UNIT;
635 
636   uint256 constant SALE_SUPPLY      = 264000000 * UNIT;
637   uint256 internal SALE_SENT        = 0;
638 
639   uint256 constant OWNER_SUPPLY     = 305000000 * UNIT;
640   uint256 internal OWNER_SENT       = 0;
641 
642   uint256 constant BOUNTY_SUPPLY    = 6000000 * UNIT;
643   uint256 internal BOUNTY_SENT      = 0;
644 
645   uint256 constant ADVISORS_SUPPLY  = 25000000 * UNIT;
646   uint256 internal ADVISORS_SENT    = 0;
647 
648   struct Stage {
649      uint8 cents;
650      uint256 limit;
651   } 
652 
653   Stage[] stages;
654 
655   /**
656    * @dev Stages prices in cents
657    */
658   mapping(uint => uint256) rates;
659 
660   constructor() public {
661     totalSupply_ = INITIAL_SUPPLY;
662     stages.push(Stage( 2, 0));
663     stages.push(Stage( 6, 26400000 * UNIT));
664     stages.push(Stage( 6, 52800000 * UNIT));
665     stages.push(Stage(12, 158400000 * UNIT));
666     stages.push(Stage(12, SALE_SUPPLY));
667   }
668 
669 
670   /**
671    * @dev Sell tokens to address based on USD cents value.
672    * @param _to Buyer address.
673    * @param _value USC cents value.
674    */
675   function sellWithCents(address _to, uint256 _value) public
676     onlyAdmin whenNotPaused
677     returns (bool success) {
678       return _sellWithCents(_to, _value);
679   }
680 
681   /**
682    * @dev Sell tokens to address array based on USD cents array values.
683    */
684   function sellWithCentsArray(address[] _dests, uint256[] _values) public
685     onlyAdmin whenNotPaused
686     returns (bool success) {
687       require(_dests.length == _values.length);
688       for (uint32 i = 0; i < _dests.length; i++)
689         if(!_sellWithCents(_dests[i], _values[i])) {
690           revert();
691           return false;
692         }
693       return true;
694   }
695 
696   /**
697    * @dev Sell tokens to address based on USD cents value.
698    * @param _to Buyer address.
699    * @param _value USC cents value.
700    */
701   function _sellWithCents(address _to, uint256 _value) internal
702     onlyAdmin whenNotPaused
703     returns (bool) {
704       require(_to != address(0) && _value > 0);
705       uint256 tokens_left = 0;
706       uint256 tokens_right = 0;
707       uint256 price_left = 0;
708       uint256 price_right = 0;
709       uint256 tokens;
710       uint256 i_r = 0;
711       uint256 i = 0;
712       while (i < stages.length) {
713         if(SALE_SENT >= stages[i].limit) {
714           if(i == stages.length-1) {
715             i_r = i;
716           } else {
717             i_r = i + 1;
718           }
719           price_left = uint(stages[i].cents);
720           price_right = uint(stages[i_r].cents);
721         }
722         i += 1;
723       }
724       if(price_left <= 0) {
725         revert();
726         return false;
727       }
728       tokens_left = _value.mul(UNIT).div(price_left);
729       if(SALE_SENT.add(tokens_left) <= stages[i_r].limit) {
730         tokens = tokens_left;
731       } else {
732         tokens_left = stages[i_r].limit.sub(SALE_SENT);
733         tokens_right = UNIT.mul(_value.sub((tokens_left.mul(price_left)).div(UNIT))).div(price_right);
734       }
735       tokens = tokens_left.add(tokens_right);
736       if(SALE_SENT.add(tokens) > SALE_SUPPLY) {
737         revert();
738         return false;
739       }
740       balances[_to] = balances[_to].add(tokens);
741       SALE_SENT = SALE_SENT.add(tokens);
742       emit Transfer(this, _to, tokens);
743       return true;
744   }
745 
746   /**
747    * @dev Transfer tokens from contract directy to address.
748    * @param _to Buyer address.
749    * @param _value Tokens value.
750    */
751   function sellDirect(address _to, uint256 _value) public
752     onlyAdmin whenNotPaused
753       returns (bool success) {
754         require(_to != address(0) && _value > 0 && SALE_SENT.add(_value) <= SALE_SUPPLY);
755         balances[_to] = balances[_to].add(_value);
756         SALE_SENT = SALE_SENT.add(_value);
757         emit Transfer(this, _to, _value);
758         return true;
759   }
760 
761   /**
762    * @dev Sell tokens to address array based on USD cents array values.
763    */
764   function sellDirectArray(address[] _dests, uint256[] _values) public
765     onlyAdmin whenNotPaused returns (bool success) {
766       require(_dests.length == _values.length);
767       for (uint32 i = 0; i < _dests.length; i++) {
768          if(_values[i] <= 0 || !sellDirect(_dests[i], _values[i])) {
769             revert();
770             return false;
771          }
772       }
773       return true;
774   }
775 
776 
777   /**
778    * @dev Transfer tokens from contract directy to owner.
779    * @param _value Tokens value.
780    */
781   function transferOwnerTokens(uint256 _value) public
782     onlyAdmin whenNotPaused returns (bool success) {
783       require(_value > 0 && OWNER_SENT.add(_value) <= OWNER_SUPPLY);
784       balances[owner] = balances[owner].add(_value);
785       OWNER_SENT = OWNER_SENT.add(_value);
786       emit Transfer(this, owner, _value);
787       return true;
788   }
789 
790   /**
791    * @dev Transfer Bounty Tokens from contract.
792    * @param _to Bounty recipient address.
793    * @param _value Tokens value.
794    */
795   function transferBountyTokens(address _to, uint256 _value) public
796     onlyAdmin whenNotPaused returns (bool success) {
797       require(_to != address(0) && _value > 0 && BOUNTY_SENT.add(_value) <= BOUNTY_SUPPLY);
798       balances[_to] = balances[_to].add(_value);
799       BOUNTY_SENT = BOUNTY_SENT.add(_value);
800       emit Transfer(this, _to, _value);
801       return true;
802   }
803 
804   /**
805    * @dev Transfer Bounty Tokens from contract to multiple recipients ant once.
806    * @param _to Bounty recipient addresses.
807    * @param _values Tokens values.
808    */
809   function transferBountyTokensArray(address[] _to, uint256[] _values) public
810     onlyAdmin whenNotPaused returns (bool success) {
811       require(_to.length == _values.length);
812       for (uint32 i = 0; i < _to.length; i++)
813         if(!transferBountyTokens(_to[i], _values[i])) {
814           revert();
815           return false;
816         }
817       return true;
818   }
819     
820   /**
821    * @dev Transfer Advisors Tokens from contract.
822    * @param _to Advisors recipient address.
823    * @param _value Tokens value.
824    */
825   function transferAdvisorsTokens(address _to, uint256 _value) public
826     onlyAdmin whenNotPaused returns (bool success) {
827       require(_to != address(0) && _value > 0 && ADVISORS_SENT.add(_value) <= ADVISORS_SUPPLY);
828       balances[_to] = balances[_to].add(_value);
829       ADVISORS_SENT = ADVISORS_SENT.add(_value);
830       emit Transfer(this, _to, _value);
831       return true;
832   }
833     
834   /**
835    * @dev Transfer Advisors Tokens from contract for multiple advisors.
836    * @param _to Advisors recipient addresses.
837    * @param _values Tokens valuees.
838    */
839   function transferAdvisorsTokensArray(address[] _to, uint256[] _values) public
840     onlyAdmin whenNotPaused returns (bool success) {
841       require(_to.length == _values.length);
842       for (uint32 i = 0; i < _to.length; i++)
843         if(!transferAdvisorsTokens(_to[i], _values[i])) {
844           revert();
845           return false;
846         }
847       return true;
848   }
849 
850   /**
851    * @dev Current Sale states methods.
852    */
853   function soldTokensSent() external view returns (uint256) {
854     return SALE_SENT;
855   }
856   function soldTokensAvailable() external view returns (uint256) {
857     return SALE_SUPPLY.sub(SALE_SENT);
858   }
859 
860   function ownerTokensSent() external view returns (uint256) {
861     return OWNER_SENT;
862   }
863   function ownerTokensAvailable() external view returns (uint256) {
864     return OWNER_SUPPLY.sub(OWNER_SENT);
865   }
866 
867   function bountyTokensSent() external view returns (uint256) {
868     return BOUNTY_SENT;
869   }
870   function bountyTokensAvailable() external view returns (uint256) {
871     return BOUNTY_SUPPLY.sub(BOUNTY_SENT);
872   }
873 
874   function advisorsTokensSent() external view returns (uint256) {
875     return ADVISORS_SENT;
876   }
877   function advisorsTokensAvailable() external view returns (uint256) {
878     return ADVISORS_SUPPLY.sub(ADVISORS_SENT);
879   }
880 
881   /**
882    * @dev Transfer tokens from msg.sender account directy to address array with values array.
883    * param _dests  recipients.
884    * @param _values Tokens values.
885    */
886   function transferArray(address[] _dests, uint256[] _values) public returns (bool success) {
887       require(_dests.length == _values.length);
888       for (uint32 i = 0; i < _dests.length; i++) {
889         if(_values[i] > balances[msg.sender] || msg.sender == _dests[i] || _dests[i] == address(0)) {
890           revert();
891           return false;
892         }
893         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
894         balances[_dests[i]] = balances[_dests[i]].add(_values[i]);
895         emit Transfer(msg.sender, _dests[i], _values[i]);
896       }
897       return true;
898   }
899 
900 }