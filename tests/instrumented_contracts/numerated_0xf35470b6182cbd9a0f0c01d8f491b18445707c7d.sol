1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title Pausable
64  * @dev Base contract which allows children to implement an emergency stop mechanism.
65  */
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     emit Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     emit Unpause();
103   }
104 }
105 
106 /**
107  * @title Claimable
108  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
109  * This allows the new owner to accept the transfer.
110  */
111 contract Claimable is Ownable {
112   address public pendingOwner;
113 
114   /**
115    * @dev Modifier throws if called by any account other than the pendingOwner.
116    */
117   modifier onlyPendingOwner() {
118     require(msg.sender == pendingOwner);
119     _;
120   }
121 
122   /**
123    * @dev Allows the current owner to set the pendingOwner address.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) onlyOwner public {
127     pendingOwner = newOwner;
128   }
129 
130   /**
131    * @dev Allows the pendingOwner address to finalize the transfer.
132    */
133   function claimOwnership() onlyPendingOwner public {
134     emit OwnershipTransferred(owner, pendingOwner);
135     owner = pendingOwner;
136     pendingOwner = address(0);
137   }
138 }
139 
140 contract AccessByGame is Pausable, Claimable {
141   mapping(address => bool) internal contractAccess;
142 
143   modifier onlyAccessByGame {
144     require(!paused && (msg.sender == owner || contractAccess[msg.sender] == true));
145     _;
146   }
147 
148   function grantAccess(address _address)
149     onlyOwner
150     public
151   {
152     contractAccess[_address] = true;
153   }
154 
155   function revokeAccess(address _address)
156     onlyOwner
157     public
158   {
159     contractAccess[_address] = false;
160   }
161 }
162 
163 /**
164  * @title ERC20Basic
165  * @dev Simpler version of ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/179
167  */
168 contract ERC20Basic {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address who) public view returns (uint256);
171   function transfer(address to, uint256 value) public returns (bool);
172   event Transfer(address indexed from, address indexed to, uint256 value);
173 }
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender)
181     public view returns (uint256);
182 
183   function transferFrom(address from, address to, uint256 value)
184     public returns (bool);
185 
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(
188     address indexed owner,
189     address indexed spender,
190     uint256 value
191   );
192 }
193 
194 /**
195  * @title ERC827 interface, an extension of ERC20 token standard
196  *
197  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
198  * @dev methods to transfer value and data and execute calls in transfers and
199  * @dev approvals.
200  */
201 contract ERC827 is ERC20 {
202   function approveAndCall(
203     address _spender,
204     uint256 _value,
205     bytes _data
206   )
207     public
208     payable
209     returns (bool);
210 
211   function transferAndCall(
212     address _to,
213     uint256 _value,
214     bytes _data
215   )
216     public
217     payable
218     returns (bool);
219 
220   function transferFromAndCall(
221     address _from,
222     address _to,
223     uint256 _value,
224     bytes _data
225   )
226     public
227     payable
228     returns (bool);
229 }
230 
231 /**
232  * @title SafeMath
233  * @dev Math operations with safety checks that throw on error
234  */
235 library SafeMath {
236 
237   /**
238   * @dev Multiplies two numbers, throws on overflow.
239   */
240   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
241     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
242     // benefit is lost if 'b' is also tested.
243     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
244     if (a == 0) {
245       return 0;
246     }
247 
248     c = a * b;
249     assert(c / a == b);
250     return c;
251   }
252 
253   /**
254   * @dev Integer division of two numbers, truncating the quotient.
255   */
256   function div(uint256 a, uint256 b) internal pure returns (uint256) {
257     // assert(b > 0); // Solidity automatically throws when dividing by 0
258     // uint256 c = a / b;
259     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260     return a / b;
261   }
262 
263   /**
264   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
265   */
266   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267     assert(b <= a);
268     return a - b;
269   }
270 
271   /**
272   * @dev Adds two numbers, throws on overflow.
273   */
274   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
275     c = a + b;
276     assert(c >= a);
277     return c;
278   }
279 }
280 
281 /**
282  * @title Basic token
283  * @dev Basic version of StandardToken, with no allowances.
284  */
285 contract BasicToken is ERC20Basic {
286   using SafeMath for uint256;
287 
288   mapping(address => uint256) balances;
289 
290   uint256 totalSupply_;
291 
292   /**
293   * @dev total number of tokens in existence
294   */
295   function totalSupply() public view returns (uint256) {
296     return totalSupply_;
297   }
298 
299   /**
300   * @dev transfer token for a specified address
301   * @param _to The address to transfer to.
302   * @param _value The amount to be transferred.
303   */
304   function transfer(address _to, uint256 _value) public returns (bool) {
305     require(_to != address(0));
306     require(_value <= balances[msg.sender]);
307 
308     balances[msg.sender] = balances[msg.sender].sub(_value);
309     balances[_to] = balances[_to].add(_value);
310     emit Transfer(msg.sender, _to, _value);
311     return true;
312   }
313 
314   /**
315   * @dev Gets the balance of the specified address.
316   * @param _owner The address to query the the balance of.
317   * @return An uint256 representing the amount owned by the passed address.
318   */
319   function balanceOf(address _owner) public view returns (uint256) {
320     return balances[_owner];
321   }
322 
323 }
324 
325 /**
326  * @title Standard ERC20 token
327  *
328  * @dev Implementation of the basic standard token.
329  * @dev https://github.com/ethereum/EIPs/issues/20
330  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
331  */
332 contract StandardToken is ERC20, BasicToken {
333 
334   mapping (address => mapping (address => uint256)) internal allowed;
335 
336 
337   /**
338    * @dev Transfer tokens from one address to another
339    * @param _from address The address which you want to send tokens from
340    * @param _to address The address which you want to transfer to
341    * @param _value uint256 the amount of tokens to be transferred
342    */
343   function transferFrom(
344     address _from,
345     address _to,
346     uint256 _value
347   )
348     public
349     returns (bool)
350   {
351     require(_to != address(0));
352     require(_value <= balances[_from]);
353     require(_value <= allowed[_from][msg.sender]);
354 
355     balances[_from] = balances[_from].sub(_value);
356     balances[_to] = balances[_to].add(_value);
357     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
358     emit Transfer(_from, _to, _value);
359     return true;
360   }
361 
362   /**
363    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364    *
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param _spender The address which will spend the funds.
370    * @param _value The amount of tokens to be spent.
371    */
372   function approve(address _spender, uint256 _value) public returns (bool) {
373     allowed[msg.sender][_spender] = _value;
374     emit Approval(msg.sender, _spender, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Function to check the amount of tokens that an owner allowed to a spender.
380    * @param _owner address The address which owns the funds.
381    * @param _spender address The address which will spend the funds.
382    * @return A uint256 specifying the amount of tokens still available for the spender.
383    */
384   function allowance(
385     address _owner,
386     address _spender
387    )
388     public
389     view
390     returns (uint256)
391   {
392     return allowed[_owner][_spender];
393   }
394 
395   /**
396    * @dev Increase the amount of tokens that an owner allowed to a spender.
397    *
398    * approve should be called when allowed[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param _spender The address which will spend the funds.
403    * @param _addedValue The amount of tokens to increase the allowance by.
404    */
405   function increaseApproval(
406     address _spender,
407     uint _addedValue
408   )
409     public
410     returns (bool)
411   {
412     allowed[msg.sender][_spender] = (
413       allowed[msg.sender][_spender].add(_addedValue));
414     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418   /**
419    * @dev Decrease the amount of tokens that an owner allowed to a spender.
420    *
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    */
428   function decreaseApproval(
429     address _spender,
430     uint _subtractedValue
431   )
432     public
433     returns (bool)
434   {
435     uint oldValue = allowed[msg.sender][_spender];
436     if (_subtractedValue > oldValue) {
437       allowed[msg.sender][_spender] = 0;
438     } else {
439       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
440     }
441     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
442     return true;
443   }
444 
445 }
446 
447 contract ERC827Caller {
448   function makeCall(address _target, bytes _data) external payable returns (bool) {
449     // solium-disable-next-line security/no-call-value
450     return _target.call.value(msg.value)(_data);
451   }
452 }
453 
454 /**
455  * @title ERC827, an extension of ERC20 token standard
456  *
457  * @dev Implementation the ERC827, following the ERC20 standard with extra
458  * @dev methods to transfer value and data and execute calls in transfers and
459  * @dev approvals.
460  *
461  * @dev Uses OpenZeppelin StandardToken.
462  */
463 contract ERC827Token is ERC827, StandardToken {
464   ERC827Caller internal caller_;
465 
466   constructor() public {
467     caller_ = new ERC827Caller();
468   }
469 
470   /**
471    * @dev Addition to ERC20 token methods. It allows to
472    * @dev approve the transfer of value and execute a call with the sent data.
473    *
474    * @dev Beware that changing an allowance with this method brings the risk that
475    * @dev someone may use both the old and the new allowance by unfortunate
476    * @dev transaction ordering. One possible solution to mitigate this race condition
477    * @dev is to first reduce the spender's allowance to 0 and set the desired value
478    * @dev afterwards:
479    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
480    *
481    * @param _spender The address that will spend the funds.
482    * @param _value The amount of tokens to be spent.
483    * @param _data ABI-encoded contract call to call `_to` address.
484    *
485    * @return true if the call function was executed successfully
486    */
487   function approveAndCall(
488     address _spender,
489     uint256 _value,
490     bytes _data
491   )
492     public
493     payable
494     returns (bool)
495   {
496     require(_spender != address(this));
497 
498     super.approve(_spender, _value);
499 
500     // solium-disable-next-line security/no-call-value
501     require(caller_.makeCall.value(msg.value)(_spender, _data));
502 
503     return true;
504   }
505 
506   /**
507    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
508    * @dev address and execute a call with the sent data on the same transaction
509    *
510    * @param _to address The address which you want to transfer to
511    * @param _value uint256 the amout of tokens to be transfered
512    * @param _data ABI-encoded contract call to call `_to` address.
513    *
514    * @return true if the call function was executed successfully
515    */
516   function transferAndCall(
517     address _to,
518     uint256 _value,
519     bytes _data
520   )
521     public
522     payable
523     returns (bool)
524   {
525     require(_to != address(this));
526 
527     super.transfer(_to, _value);
528 
529     // solium-disable-next-line security/no-call-value
530     require(caller_.makeCall.value(msg.value)(_to, _data));
531     return true;
532   }
533 
534   /**
535    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
536    * @dev another and make a contract call on the same transaction
537    *
538    * @param _from The address which you want to send tokens from
539    * @param _to The address which you want to transfer to
540    * @param _value The amout of tokens to be transferred
541    * @param _data ABI-encoded contract call to call `_to` address.
542    *
543    * @return true if the call function was executed successfully
544    */
545   function transferFromAndCall(
546     address _from,
547     address _to,
548     uint256 _value,
549     bytes _data
550   )
551     public payable returns (bool)
552   {
553     require(_to != address(this));
554 
555     super.transferFrom(_from, _to, _value);
556 
557     // solium-disable-next-line security/no-call-value
558     require(caller_.makeCall.value(msg.value)(_to, _data));
559     return true;
560   }
561 
562   /**
563    * @dev Addition to StandardToken methods. Increase the amount of tokens that
564    * @dev an owner allowed to a spender and execute a call with the sent data.
565    *
566    * @dev approve should be called when allowed[_spender] == 0. To increment
567    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
568    * @dev the first transaction is mined)
569    * @dev From MonolithDAO Token.sol
570    *
571    * @param _spender The address which will spend the funds.
572    * @param _addedValue The amount of tokens to increase the allowance by.
573    * @param _data ABI-encoded contract call to call `_spender` address.
574    */
575   function increaseApprovalAndCall(
576     address _spender,
577     uint _addedValue,
578     bytes _data
579   )
580     public
581     payable
582     returns (bool)
583   {
584     require(_spender != address(this));
585 
586     super.increaseApproval(_spender, _addedValue);
587 
588     // solium-disable-next-line security/no-call-value
589     require(caller_.makeCall.value(msg.value)(_spender, _data));
590 
591     return true;
592   }
593 
594   /**
595    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
596    * @dev an owner allowed to a spender and execute a call with the sent data.
597    *
598    * @dev approve should be called when allowed[_spender] == 0. To decrement
599    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
600    * @dev the first transaction is mined)
601    * @dev From MonolithDAO Token.sol
602    *
603    * @param _spender The address which will spend the funds.
604    * @param _subtractedValue The amount of tokens to decrease the allowance by.
605    * @param _data ABI-encoded contract call to call `_spender` address.
606    */
607   function decreaseApprovalAndCall(
608     address _spender,
609     uint _subtractedValue,
610     bytes _data
611   )
612     public
613     payable
614     returns (bool)
615   {
616     require(_spender != address(this));
617 
618     super.decreaseApproval(_spender, _subtractedValue);
619 
620     // solium-disable-next-line security/no-call-value
621     require(caller_.makeCall.value(msg.value)(_spender, _data));
622 
623     return true;
624   }
625 
626 }
627 
628 /**
629  * @title Mintable token
630  * @dev Simple ERC20 Token example, with mintable token creation
631  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
632  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
633  */
634 contract MintableToken is StandardToken, Ownable {
635   event Mint(address indexed to, uint256 amount);
636   event MintFinished();
637 
638   bool public mintingFinished = false;
639 
640 
641   modifier canMint() {
642     require(!mintingFinished);
643     _;
644   }
645 
646   modifier hasMintPermission() {
647     require(msg.sender == owner);
648     _;
649   }
650 
651   /**
652    * @dev Function to mint tokens
653    * @param _to The address that will receive the minted tokens.
654    * @param _amount The amount of tokens to mint.
655    * @return A boolean that indicates if the operation was successful.
656    */
657   function mint(
658     address _to,
659     uint256 _amount
660   )
661     hasMintPermission
662     canMint
663     public
664     returns (bool)
665   {
666     totalSupply_ = totalSupply_.add(_amount);
667     balances[_to] = balances[_to].add(_amount);
668     emit Mint(_to, _amount);
669     emit Transfer(address(0), _to, _amount);
670     return true;
671   }
672 
673   /**
674    * @dev Function to stop minting new tokens.
675    * @return True if the operation was successful.
676    */
677   function finishMinting() onlyOwner canMint public returns (bool) {
678     mintingFinished = true;
679     emit MintFinished();
680     return true;
681   }
682 }
683 
684 contract EverGold is ERC827Token, MintableToken, AccessByGame {
685   string public constant name = "Ever Gold";
686   string public constant symbol = "EG";
687   uint8 public constant decimals = 0;
688 
689   function mint(
690     address _to,
691     uint256 _amount
692   )
693     onlyAccessByGame
694     canMint
695     public
696     returns (bool)
697   {
698     totalSupply_ = totalSupply_.add(_amount);
699     balances[_to] = balances[_to].add(_amount);
700     emit Mint(_to, _amount);
701     emit Transfer(address(0), _to, _amount);
702     return true;
703   }
704   function transfer(address _to, uint256 _value)
705     public
706     whenNotPaused
707     returns (bool)
708   {
709     return super.transfer(_to, _value);
710   }
711 
712   function transferFrom(address _from, address _to, uint256 _value)
713     public
714     whenNotPaused
715     returns (bool)
716   {
717     return super.transferFrom(_from, _to, _value);
718   }
719 
720   function approve(address _spender, uint256 _value)
721     public
722     whenNotPaused
723     returns (bool)
724   {
725     return super.approve(_spender, _value);
726   }
727 
728   function approveAndCall(
729     address _spender,
730     uint256 _value,
731     bytes _data
732   )
733     public
734     payable
735     whenNotPaused
736     returns (bool)
737   {
738     return super.approveAndCall(_spender, _value, _data);
739   }
740 
741   function transferAndCall(
742     address _to,
743     uint256 _value,
744     bytes _data
745   )
746     public
747     payable
748     whenNotPaused
749     returns (bool)
750   {
751     return super.transferAndCall(_to, _value, _data);
752   }
753 
754   function transferFromAndCall(
755     address _from,
756     address _to,
757     uint256 _value,
758     bytes _data
759   )
760     public
761     payable
762     whenNotPaused
763     returns (bool)
764   {
765     return super.transferFromAndCall(_from, _to, _value, _data);
766   }
767 
768   function increaseApprovalAndCall(
769     address _spender,
770     uint _addedValue,
771     bytes _data
772   )
773     public
774     payable
775     whenNotPaused
776     returns (bool)
777   {
778     return super.increaseApprovalAndCall(_spender, _addedValue, _data);
779   }
780 
781   function decreaseApprovalAndCall(
782     address _spender,
783     uint _subtractedValue,
784     bytes _data
785   )
786     public
787     payable
788     whenNotPaused
789     returns (bool)
790   {
791     return super.decreaseApprovalAndCall(_spender, _subtractedValue, _data);
792   }
793 }
794 
795 contract UserToken is AccessByGame {
796   struct User {
797     string name;
798     uint32 registeredDate;
799   }
800 
801   string constant public DEFAULT_NAME = "NONAME";
802 
803   User[] private users;
804 
805   uint256 public userCount = 0;
806 
807   mapping (address => uint256) private ownerToUser;
808 
809   /// @dev Constructor
810   constructor()
811     public
812   {
813     mint(msg.sender, "OWNER");
814   }
815 
816   function mint(address _beneficiary, string _name)
817     public
818     onlyAccessByGame
819     whenNotPaused()
820     returns (bool)
821   {
822     require(_beneficiary != address(0));
823     require(ownerToUser[_beneficiary] == 0);
824 
825     User memory user = User({
826       name: _name,
827       registeredDate: uint32(now)
828     });
829 
830     uint256 id = users.push(user) - 1;
831 
832     ownerToUser[_beneficiary] = id;
833 
834     userCount++;
835 
836     return true;
837   }
838 
839   function setName(string _name)
840     public
841     whenNotPaused()
842     returns (bool)
843   {
844     require(bytes(_name).length > 1);
845     require(ownerToUser[msg.sender] != 0);
846 
847     uint256 userid = ownerToUser[msg.sender];
848     users[userid].name = _name;
849 
850     return true;
851   }
852 
853   function getUserid(address _owner)
854     external
855     view
856     onlyAccessByGame
857     returns(uint256 result)
858   {
859     if (ownerToUser[_owner] == 0) {
860       return 0;
861     }
862     return ownerToUser[_owner];
863   }
864 
865   function getUserInfo()
866     public
867     view
868     returns (uint256, string, uint32)
869   {
870     uint256 userid = ownerToUser[msg.sender];
871     return getUserInfoById(userid);
872   }
873 
874   function getUserInfoById(uint256 _userid)
875     public
876     view
877     returns (uint256, string, uint32)
878   {
879     User storage user = users[_userid];
880     return (_userid, user.name, user.registeredDate);
881   }
882 }