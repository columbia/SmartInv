1 pragma solidity ^0.4.24;
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
684 /// @title EverGold
685 /// @dev ERC827 Token for games.
686 contract EverGold is ERC827Token, MintableToken, AccessByGame {
687   string public constant name = "Ever Gold";
688   string public constant symbol = "EG";
689   uint8 public constant decimals = 0;
690 
691 /**
692    * @dev Function to mint tokens
693    * @param _to The address that will receive the minted tokens.
694    * @param _amount The amount of tokens to mint.
695    * @return A boolean that indicates if the operation was successful.
696    */
697   function mint(
698     address _to,
699     uint256 _amount
700   )
701     onlyAccessByGame
702     canMint
703     public
704     returns (bool)
705   {
706     totalSupply_ = totalSupply_.add(_amount);
707     balances[_to] = balances[_to].add(_amount);
708     emit Mint(_to, _amount);
709     emit Transfer(address(0), _to, _amount);
710     return true;
711   }
712   function transfer(address _to, uint256 _value)
713     public
714     whenNotPaused
715     returns (bool)
716   {
717     return super.transfer(_to, _value);
718   }
719 
720   function transferFrom(address _from, address _to, uint256 _value)
721     public
722     whenNotPaused
723     returns (bool)
724   {
725     return super.transferFrom(_from, _to, _value);
726   }
727 
728   function approve(address _spender, uint256 _value)
729     public
730     whenNotPaused
731     returns (bool)
732   {
733     return super.approve(_spender, _value);
734   }
735 
736   function approveAndCall(
737     address _spender,
738     uint256 _value,
739     bytes _data
740   )
741     public
742     payable
743     whenNotPaused
744     returns (bool)
745   {
746     return super.approveAndCall(_spender, _value, _data);
747   }
748 
749   function transferAndCall(
750     address _to,
751     uint256 _value,
752     bytes _data
753   )
754     public
755     payable
756     whenNotPaused
757     returns (bool)
758   {
759     return super.transferAndCall(_to, _value, _data);
760   }
761 
762   function transferFromAndCall(
763     address _from,
764     address _to,
765     uint256 _value,
766     bytes _data
767   )
768     public
769     payable
770     whenNotPaused
771     returns (bool)
772   {
773     return super.transferFromAndCall(_from, _to, _value, _data);
774   }
775 
776   function increaseApprovalAndCall(
777     address _spender,
778     uint _addedValue,
779     bytes _data
780   )
781     public
782     payable
783     whenNotPaused
784     returns (bool)
785   {
786     return super.increaseApprovalAndCall(_spender, _addedValue, _data);
787   }
788 
789   function decreaseApprovalAndCall(
790     address _spender,
791     uint _subtractedValue,
792     bytes _data
793   )
794     public
795     payable
796     whenNotPaused
797     returns (bool)
798   {
799     return super.decreaseApprovalAndCall(_spender, _subtractedValue, _data);
800   }
801 }
802 
803 library StringLib {
804   function generateName(bytes16 _s, uint256 _len, uint256 _n)
805     public
806     pure
807     returns (bytes16 ret)
808   {
809     uint256 v = _n;
810     bytes16 num = 0;
811     while (v > 0) {
812       num = bytes16(uint(num) / (2 ** 8));
813       num |= bytes16(((v % 10) + 48) * 2 ** (8 * 15));
814       v /= 10;
815     }
816     ret = _s | bytes16(uint(num) / (2 ** (8 * _len)));
817     return ret;
818   }
819 }
820 
821 /**
822  * @title ERC721 Non-Fungible Token Standard basic interface
823  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
824  */
825 contract ERC721Basic {
826   event Transfer(
827     address indexed _from,
828     address indexed _to,
829     uint256 _tokenId
830   );
831   event Approval(
832     address indexed _owner,
833     address indexed _approved,
834     uint256 _tokenId
835   );
836   event ApprovalForAll(
837     address indexed _owner,
838     address indexed _operator,
839     bool _approved
840   );
841 
842   function balanceOf(address _owner) public view returns (uint256 _balance);
843   function ownerOf(uint256 _tokenId) public view returns (address _owner);
844   function exists(uint256 _tokenId) public view returns (bool _exists);
845 
846   function approve(address _to, uint256 _tokenId) public;
847   function getApproved(uint256 _tokenId)
848     public view returns (address _operator);
849 
850   function setApprovalForAll(address _operator, bool _approved) public;
851   function isApprovedForAll(address _owner, address _operator)
852     public view returns (bool);
853 
854   function transferFrom(address _from, address _to, uint256 _tokenId) public;
855   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
856     public;
857 
858   function safeTransferFrom(
859     address _from,
860     address _to,
861     uint256 _tokenId,
862     bytes _data
863   )
864     public;
865 }
866 
867 /**
868  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
869  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
870  */
871 contract ERC721Enumerable is ERC721Basic {
872   function totalSupply() public view returns (uint256);
873   function tokenOfOwnerByIndex(
874     address _owner,
875     uint256 _index
876   )
877     public
878     view
879     returns (uint256 _tokenId);
880 
881   function tokenByIndex(uint256 _index) public view returns (uint256);
882 }
883 
884 
885 /**
886  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
887  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
888  */
889 contract ERC721Metadata is ERC721Basic {
890   function name() public view returns (string _name);
891   function symbol() public view returns (string _symbol);
892   function tokenURI(uint256 _tokenId) public view returns (string);
893 }
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
898  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
899  */
900 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
901 }
902 
903 /**
904  * Utility library of inline functions on addresses
905  */
906 library AddressUtils {
907 
908   /**
909    * Returns whether the target address is a contract
910    * @dev This function will return false if invoked during the constructor of a contract,
911    *  as the code is not actually created until after the constructor finishes.
912    * @param addr address to check
913    * @return whether the target address is a contract
914    */
915   function isContract(address addr) internal view returns (bool) {
916     uint256 size;
917     // XXX Currently there is no better way to check if there is a contract in an address
918     // than to check the size of the code at that address.
919     // See https://ethereum.stackexchange.com/a/14016/36603
920     // for more details about how this works.
921     // TODO Check this again before the Serenity release, because all addresses will be
922     // contracts then.
923     // solium-disable-next-line security/no-inline-assembly
924     assembly { size := extcodesize(addr) }
925     return size > 0;
926   }
927 
928 }
929 
930 /**
931  * @title ERC721 token receiver interface
932  * @dev Interface for any contract that wants to support safeTransfers
933  *  from ERC721 asset contracts.
934  */
935 contract ERC721Receiver {
936   /**
937    * @dev Magic value to be returned upon successful reception of an NFT
938    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
939    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
940    */
941   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
942 
943   /**
944    * @notice Handle the receipt of an NFT
945    * @dev The ERC721 smart contract calls this function on the recipient
946    *  after a `safetransfer`. This function MAY throw to revert and reject the
947    *  transfer. This function MUST use 50,000 gas or less. Return of other
948    *  than the magic value MUST result in the transaction being reverted.
949    *  Note: the contract address is always the message sender.
950    * @param _from The sending address
951    * @param _tokenId The NFT identifier which is being transfered
952    * @param _data Additional data with no specified format
953    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
954    */
955   function onERC721Received(
956     address _from,
957     uint256 _tokenId,
958     bytes _data
959   )
960     public
961     returns(bytes4);
962 }
963 
964 /**
965  * @title ERC721 Non-Fungible Token Standard basic implementation
966  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
967  */
968 contract ERC721BasicToken is ERC721Basic {
969   using SafeMath for uint256;
970   using AddressUtils for address;
971 
972   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
973   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
974   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
975 
976   // Mapping from token ID to owner
977   mapping (uint256 => address) internal tokenOwner;
978 
979   // Mapping from token ID to approved address
980   mapping (uint256 => address) internal tokenApprovals;
981 
982   // Mapping from owner to number of owned token
983   mapping (address => uint256) internal ownedTokensCount;
984 
985   // Mapping from owner to operator approvals
986   mapping (address => mapping (address => bool)) internal operatorApprovals;
987 
988   /**
989    * @dev Guarantees msg.sender is owner of the given token
990    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
991    */
992   modifier onlyOwnerOf(uint256 _tokenId) {
993     require(ownerOf(_tokenId) == msg.sender);
994     _;
995   }
996 
997   /**
998    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
999    * @param _tokenId uint256 ID of the token to validate
1000    */
1001   modifier canTransfer(uint256 _tokenId) {
1002     require(isApprovedOrOwner(msg.sender, _tokenId));
1003     _;
1004   }
1005 
1006   /**
1007    * @dev Gets the balance of the specified address
1008    * @param _owner address to query the balance of
1009    * @return uint256 representing the amount owned by the passed address
1010    */
1011   function balanceOf(address _owner) public view returns (uint256) {
1012     require(_owner != address(0));
1013     return ownedTokensCount[_owner];
1014   }
1015 
1016   /**
1017    * @dev Gets the owner of the specified token ID
1018    * @param _tokenId uint256 ID of the token to query the owner of
1019    * @return owner address currently marked as the owner of the given token ID
1020    */
1021   function ownerOf(uint256 _tokenId) public view returns (address) {
1022     address owner = tokenOwner[_tokenId];
1023     require(owner != address(0));
1024     return owner;
1025   }
1026 
1027   /**
1028    * @dev Returns whether the specified token exists
1029    * @param _tokenId uint256 ID of the token to query the existence of
1030    * @return whether the token exists
1031    */
1032   function exists(uint256 _tokenId) public view returns (bool) {
1033     address owner = tokenOwner[_tokenId];
1034     return owner != address(0);
1035   }
1036 
1037   /**
1038    * @dev Approves another address to transfer the given token ID
1039    * @dev The zero address indicates there is no approved address.
1040    * @dev There can only be one approved address per token at a given time.
1041    * @dev Can only be called by the token owner or an approved operator.
1042    * @param _to address to be approved for the given token ID
1043    * @param _tokenId uint256 ID of the token to be approved
1044    */
1045   function approve(address _to, uint256 _tokenId) public {
1046     address owner = ownerOf(_tokenId);
1047     require(_to != owner);
1048     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1049 
1050     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
1051       tokenApprovals[_tokenId] = _to;
1052       emit Approval(owner, _to, _tokenId);
1053     }
1054   }
1055 
1056   /**
1057    * @dev Gets the approved address for a token ID, or zero if no address set
1058    * @param _tokenId uint256 ID of the token to query the approval of
1059    * @return address currently approved for the given token ID
1060    */
1061   function getApproved(uint256 _tokenId) public view returns (address) {
1062     return tokenApprovals[_tokenId];
1063   }
1064 
1065   /**
1066    * @dev Sets or unsets the approval of a given operator
1067    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
1068    * @param _to operator address to set the approval
1069    * @param _approved representing the status of the approval to be set
1070    */
1071   function setApprovalForAll(address _to, bool _approved) public {
1072     require(_to != msg.sender);
1073     operatorApprovals[msg.sender][_to] = _approved;
1074     emit ApprovalForAll(msg.sender, _to, _approved);
1075   }
1076 
1077   /**
1078    * @dev Tells whether an operator is approved by a given owner
1079    * @param _owner owner address which you want to query the approval of
1080    * @param _operator operator address which you want to query the approval of
1081    * @return bool whether the given operator is approved by the given owner
1082    */
1083   function isApprovedForAll(
1084     address _owner,
1085     address _operator
1086   )
1087     public
1088     view
1089     returns (bool)
1090   {
1091     return operatorApprovals[_owner][_operator];
1092   }
1093 
1094   /**
1095    * @dev Transfers the ownership of a given token ID to another address
1096    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1097    * @dev Requires the msg sender to be the owner, approved, or operator
1098    * @param _from current owner of the token
1099    * @param _to address to receive the ownership of the given token ID
1100    * @param _tokenId uint256 ID of the token to be transferred
1101   */
1102   function transferFrom(
1103     address _from,
1104     address _to,
1105     uint256 _tokenId
1106   )
1107     public
1108     canTransfer(_tokenId)
1109   {
1110     require(_from != address(0));
1111     require(_to != address(0));
1112 
1113     clearApproval(_from, _tokenId);
1114     removeTokenFrom(_from, _tokenId);
1115     addTokenTo(_to, _tokenId);
1116 
1117     emit Transfer(_from, _to, _tokenId);
1118   }
1119 
1120   /**
1121    * @dev Safely transfers the ownership of a given token ID to another address
1122    * @dev If the target address is a contract, it must implement `onERC721Received`,
1123    *  which is called upon a safe transfer, and return the magic value
1124    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1125    *  the transfer is reverted.
1126    * @dev Requires the msg sender to be the owner, approved, or operator
1127    * @param _from current owner of the token
1128    * @param _to address to receive the ownership of the given token ID
1129    * @param _tokenId uint256 ID of the token to be transferred
1130   */
1131   function safeTransferFrom(
1132     address _from,
1133     address _to,
1134     uint256 _tokenId
1135   )
1136     public
1137     canTransfer(_tokenId)
1138   {
1139     // solium-disable-next-line arg-overflow
1140     safeTransferFrom(_from, _to, _tokenId, "");
1141   }
1142 
1143   /**
1144    * @dev Safely transfers the ownership of a given token ID to another address
1145    * @dev If the target address is a contract, it must implement `onERC721Received`,
1146    *  which is called upon a safe transfer, and return the magic value
1147    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1148    *  the transfer is reverted.
1149    * @dev Requires the msg sender to be the owner, approved, or operator
1150    * @param _from current owner of the token
1151    * @param _to address to receive the ownership of the given token ID
1152    * @param _tokenId uint256 ID of the token to be transferred
1153    * @param _data bytes data to send along with a safe transfer check
1154    */
1155   function safeTransferFrom(
1156     address _from,
1157     address _to,
1158     uint256 _tokenId,
1159     bytes _data
1160   )
1161     public
1162     canTransfer(_tokenId)
1163   {
1164     transferFrom(_from, _to, _tokenId);
1165     // solium-disable-next-line arg-overflow
1166     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1167   }
1168 
1169   /**
1170    * @dev Returns whether the given spender can transfer a given token ID
1171    * @param _spender address of the spender to query
1172    * @param _tokenId uint256 ID of the token to be transferred
1173    * @return bool whether the msg.sender is approved for the given token ID,
1174    *  is an operator of the owner, or is the owner of the token
1175    */
1176   function isApprovedOrOwner(
1177     address _spender,
1178     uint256 _tokenId
1179   )
1180     internal
1181     view
1182     returns (bool)
1183   {
1184     address owner = ownerOf(_tokenId);
1185     // Disable solium check because of
1186     // https://github.com/duaraghav8/Solium/issues/175
1187     // solium-disable-next-line operator-whitespace
1188     return (
1189       _spender == owner ||
1190       getApproved(_tokenId) == _spender ||
1191       isApprovedForAll(owner, _spender)
1192     );
1193   }
1194 
1195   /**
1196    * @dev Internal function to mint a new token
1197    * @dev Reverts if the given token ID already exists
1198    * @param _to The address that will own the minted token
1199    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1200    */
1201   function _mint(address _to, uint256 _tokenId) internal {
1202     require(_to != address(0));
1203     addTokenTo(_to, _tokenId);
1204     emit Transfer(address(0), _to, _tokenId);
1205   }
1206 
1207   /**
1208    * @dev Internal function to burn a specific token
1209    * @dev Reverts if the token does not exist
1210    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1211    */
1212   function _burn(address _owner, uint256 _tokenId) internal {
1213     clearApproval(_owner, _tokenId);
1214     removeTokenFrom(_owner, _tokenId);
1215     emit Transfer(_owner, address(0), _tokenId);
1216   }
1217 
1218   /**
1219    * @dev Internal function to clear current approval of a given token ID
1220    * @dev Reverts if the given address is not indeed the owner of the token
1221    * @param _owner owner of the token
1222    * @param _tokenId uint256 ID of the token to be transferred
1223    */
1224   function clearApproval(address _owner, uint256 _tokenId) internal {
1225     require(ownerOf(_tokenId) == _owner);
1226     if (tokenApprovals[_tokenId] != address(0)) {
1227       tokenApprovals[_tokenId] = address(0);
1228       emit Approval(_owner, address(0), _tokenId);
1229     }
1230   }
1231 
1232   /**
1233    * @dev Internal function to add a token ID to the list of a given address
1234    * @param _to address representing the new owner of the given token ID
1235    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1236    */
1237   function addTokenTo(address _to, uint256 _tokenId) internal {
1238     require(tokenOwner[_tokenId] == address(0));
1239     tokenOwner[_tokenId] = _to;
1240     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1241   }
1242 
1243   /**
1244    * @dev Internal function to remove a token ID from the list of a given address
1245    * @param _from address representing the previous owner of the given token ID
1246    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1247    */
1248   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1249     require(ownerOf(_tokenId) == _from);
1250     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1251     tokenOwner[_tokenId] = address(0);
1252   }
1253 
1254   /**
1255    * @dev Internal function to invoke `onERC721Received` on a target address
1256    * @dev The call is not executed if the target address is not a contract
1257    * @param _from address representing the previous owner of the given token ID
1258    * @param _to target address that will receive the tokens
1259    * @param _tokenId uint256 ID of the token to be transferred
1260    * @param _data bytes optional data to send along with the call
1261    * @return whether the call correctly returned the expected magic value
1262    */
1263   function checkAndCallSafeTransfer(
1264     address _from,
1265     address _to,
1266     uint256 _tokenId,
1267     bytes _data
1268   )
1269     internal
1270     returns (bool)
1271   {
1272     if (!_to.isContract()) {
1273       return true;
1274     }
1275     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1276       _from, _tokenId, _data);
1277     return (retval == ERC721_RECEIVED);
1278   }
1279 }
1280 
1281 /**
1282  * @title Full ERC721 Token
1283  * This implementation includes all the required and some optional functionality of the ERC721 standard
1284  * Moreover, it includes approve all functionality using operator terminology
1285  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1286  */
1287 contract ERC721Token is ERC721, ERC721BasicToken {
1288   // Token name
1289   string internal name_;
1290 
1291   // Token symbol
1292   string internal symbol_;
1293 
1294   // Mapping from owner to list of owned token IDs
1295   mapping(address => uint256[]) internal ownedTokens;
1296 
1297   // Mapping from token ID to index of the owner tokens list
1298   mapping(uint256 => uint256) internal ownedTokensIndex;
1299 
1300   // Array with all token ids, used for enumeration
1301   uint256[] internal allTokens;
1302 
1303   // Mapping from token id to position in the allTokens array
1304   mapping(uint256 => uint256) internal allTokensIndex;
1305 
1306   // Optional mapping for token URIs
1307   mapping(uint256 => string) internal tokenURIs;
1308 
1309   /**
1310    * @dev Constructor function
1311    */
1312   constructor(string _name, string _symbol) public {
1313     name_ = _name;
1314     symbol_ = _symbol;
1315   }
1316 
1317   /**
1318    * @dev Gets the token name
1319    * @return string representing the token name
1320    */
1321   function name() public view returns (string) {
1322     return name_;
1323   }
1324 
1325   /**
1326    * @dev Gets the token symbol
1327    * @return string representing the token symbol
1328    */
1329   function symbol() public view returns (string) {
1330     return symbol_;
1331   }
1332 
1333   /**
1334    * @dev Returns an URI for a given token ID
1335    * @dev Throws if the token ID does not exist. May return an empty string.
1336    * @param _tokenId uint256 ID of the token to query
1337    */
1338   function tokenURI(uint256 _tokenId) public view returns (string) {
1339     require(exists(_tokenId));
1340     return tokenURIs[_tokenId];
1341   }
1342 
1343   /**
1344    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1345    * @param _owner address owning the tokens list to be accessed
1346    * @param _index uint256 representing the index to be accessed of the requested tokens list
1347    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1348    */
1349   function tokenOfOwnerByIndex(
1350     address _owner,
1351     uint256 _index
1352   )
1353     public
1354     view
1355     returns (uint256)
1356   {
1357     require(_index < balanceOf(_owner));
1358     return ownedTokens[_owner][_index];
1359   }
1360 
1361   /**
1362    * @dev Gets the total amount of tokens stored by the contract
1363    * @return uint256 representing the total amount of tokens
1364    */
1365   function totalSupply() public view returns (uint256) {
1366     return allTokens.length;
1367   }
1368 
1369   /**
1370    * @dev Gets the token ID at a given index of all the tokens in this contract
1371    * @dev Reverts if the index is greater or equal to the total number of tokens
1372    * @param _index uint256 representing the index to be accessed of the tokens list
1373    * @return uint256 token ID at the given index of the tokens list
1374    */
1375   function tokenByIndex(uint256 _index) public view returns (uint256) {
1376     require(_index < totalSupply());
1377     return allTokens[_index];
1378   }
1379 
1380   /**
1381    * @dev Internal function to set the token URI for a given token
1382    * @dev Reverts if the token ID does not exist
1383    * @param _tokenId uint256 ID of the token to set its URI
1384    * @param _uri string URI to assign
1385    */
1386   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1387     require(exists(_tokenId));
1388     tokenURIs[_tokenId] = _uri;
1389   }
1390 
1391   /**
1392    * @dev Internal function to add a token ID to the list of a given address
1393    * @param _to address representing the new owner of the given token ID
1394    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1395    */
1396   function addTokenTo(address _to, uint256 _tokenId) internal {
1397     super.addTokenTo(_to, _tokenId);
1398     uint256 length = ownedTokens[_to].length;
1399     ownedTokens[_to].push(_tokenId);
1400     ownedTokensIndex[_tokenId] = length;
1401   }
1402 
1403   /**
1404    * @dev Internal function to remove a token ID from the list of a given address
1405    * @param _from address representing the previous owner of the given token ID
1406    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1407    */
1408   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1409     super.removeTokenFrom(_from, _tokenId);
1410 
1411     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1412     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1413     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1414 
1415     ownedTokens[_from][tokenIndex] = lastToken;
1416     ownedTokens[_from][lastTokenIndex] = 0;
1417     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1418     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1419     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1420 
1421     ownedTokens[_from].length--;
1422     ownedTokensIndex[_tokenId] = 0;
1423     ownedTokensIndex[lastToken] = tokenIndex;
1424   }
1425 
1426   /**
1427    * @dev Internal function to mint a new token
1428    * @dev Reverts if the given token ID already exists
1429    * @param _to address the beneficiary that will own the minted token
1430    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1431    */
1432   function _mint(address _to, uint256 _tokenId) internal {
1433     super._mint(_to, _tokenId);
1434 
1435     allTokensIndex[_tokenId] = allTokens.length;
1436     allTokens.push(_tokenId);
1437   }
1438 
1439   /**
1440    * @dev Internal function to burn a specific token
1441    * @dev Reverts if the token does not exist
1442    * @param _owner owner of the token to burn
1443    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1444    */
1445   function _burn(address _owner, uint256 _tokenId) internal {
1446     super._burn(_owner, _tokenId);
1447 
1448     // Clear metadata (if any)
1449     if (bytes(tokenURIs[_tokenId]).length != 0) {
1450       delete tokenURIs[_tokenId];
1451     }
1452 
1453     // Reorg all tokens array
1454     uint256 tokenIndex = allTokensIndex[_tokenId];
1455     uint256 lastTokenIndex = allTokens.length.sub(1);
1456     uint256 lastToken = allTokens[lastTokenIndex];
1457 
1458     allTokens[tokenIndex] = lastToken;
1459     allTokens[lastTokenIndex] = 0;
1460 
1461     allTokens.length--;
1462     allTokensIndex[_tokenId] = 0;
1463     allTokensIndex[lastToken] = tokenIndex;
1464   }
1465 
1466 }
1467 
1468 contract NinjaToken is ERC721Token, AccessByGame {
1469   string public constant NAME = "Crypto Ninja Game Ninja";
1470   string public constant SYMBOL = "CNN";
1471 
1472   event NewNinja(uint256 ninjaid, bytes16 name, bytes32 pattern);
1473 
1474   struct Ninja {
1475     bytes32 pattern;
1476     bytes16 name;
1477     uint16 level;
1478     uint32 exp;
1479     uint8 dna1;
1480     uint8 dna2;
1481     uint32 readyTime;
1482     uint16 winCount;
1483     uint8 levelPoint;
1484     uint16 lossCount;
1485     uint16 reward;
1486     uint256 lastAttackedCastleid;
1487   }
1488 
1489   mapping (uint256 => bytes) private paths;
1490 
1491   mapping (uint256 => bytes) private steps;
1492 
1493   EverGold internal goldToken;
1494 
1495   uint8 internal expOnSuccess = 3;
1496   uint8 internal expOnFault = 1;
1497   uint8 internal leveupExp = 10;
1498 
1499   uint256 internal cooldownTime = 5 minutes;
1500 
1501   uint256 internal maxCoordinate = 12;
1502 
1503   Ninja[] internal ninjas;
1504 
1505   uint256 private randNonce = 0;
1506 
1507   uint8 public kindCount = 2;
1508   uint32[] public COLORS = [
1509     0xD7003A00,
1510     0xF3980000,
1511     0x00552E00,
1512     0x19448E00,
1513     0x543F3200,
1514     0xE7609E00,
1515     0xFFEC4700,
1516     0x68BE8D00,
1517     0x0095D900,
1518     0xE9DFE500,
1519     0xEE836F00,
1520     0xF2F2B000,
1521     0xAACF5300,
1522     0x0A3AF00,
1523     0xF8FBF800,
1524     0xF4B3C200,
1525     0x928C3600,
1526     0xA59ACA00,
1527     0xABCED800,
1528     0x30283300,
1529     0xFDEFF200,
1530     0xDDBB9900,
1531     0x74539900,
1532     0xAA4C8F00
1533   ];
1534 
1535   uint256 public price = 1000;
1536 
1537   /// @dev Constructor
1538   constructor()
1539       public
1540       ERC721Token(NAME, SYMBOL)
1541   {
1542     ninjas.push(Ninja({
1543       pattern: 0, name: "DUMMY", level: 0, exp: 0,
1544       dna1: 0, dna2: 0,
1545       readyTime: 0,
1546       winCount: 0, lossCount: 0,
1547       levelPoint:0, reward: 0,
1548       lastAttackedCastleid: 0 }));
1549   }
1550 
1551   function mint(address _beneficiary)
1552     public
1553     whenNotPaused
1554     onlyAccessByGame
1555     returns (bool)
1556   {
1557     require(_beneficiary != address(0));
1558     return _create(_beneficiary, 0, 0);
1559   }
1560 
1561   function burn(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
1562     super._burn(msg.sender, _tokenId);
1563   }
1564 
1565   function setPath(
1566     uint256 _ninjaid,
1567     uint256 _castleid,
1568     bytes _path,
1569     bytes _steps)
1570     public
1571     onlyAccessByGame
1572   {
1573     Ninja storage ninja = ninjas[_ninjaid];
1574     ninja.lastAttackedCastleid = _castleid;
1575     paths[_ninjaid] = _path;
1576     steps[_ninjaid] = _steps;
1577   }
1578 
1579   function win(uint256 _ninjaid)
1580     public
1581     onlyAccessByGame
1582     returns (bool)
1583   {
1584     Ninja storage ninja = ninjas[_ninjaid];
1585     ninja.winCount++;
1586     ninja.exp += expOnSuccess;
1587     ninja.levelPoint += expOnSuccess;
1588     _levelUp(ninja);
1589 
1590     _triggerCooldown(_ninjaid);
1591 
1592     return true;
1593   }
1594 
1595   function lost(uint256 _ninjaid)
1596     public
1597     onlyAccessByGame
1598     returns (bool)
1599   {
1600     Ninja storage ninja = ninjas[_ninjaid];
1601     ninja.lossCount++;
1602     ninja.exp += expOnFault;
1603     ninja.levelPoint += expOnFault;
1604     _levelUp(ninja);
1605 
1606     _triggerCooldown(_ninjaid);
1607 
1608     return true;
1609   }
1610 
1611   function setName(uint256 _ninjaid, bytes16 _newName)
1612     external
1613     onlyOwnerOf(_ninjaid)
1614   {
1615     ninjas[_ninjaid].name = _newName;
1616   }
1617 
1618   function setGoldContract(address _goldTokenAddress)
1619     public
1620     onlyOwner
1621   {
1622     require(_goldTokenAddress != address(0));
1623 
1624     goldToken = EverGold(_goldTokenAddress);
1625   }
1626 
1627   function setNinjaKindCount(uint8 _kindCount)
1628     public
1629     onlyOwner
1630   {
1631     kindCount = _kindCount;
1632   }
1633 
1634   function setPrice(uint16 _price)
1635     public
1636     onlyOwner
1637   {
1638     price = _price;
1639   }
1640 
1641   function setMaxCoordinate(uint16 _maxCoordinate)
1642     public
1643     onlyOwner
1644   {
1645     maxCoordinate = _maxCoordinate;
1646   }
1647 
1648   function setMaxCoordinate(uint256 _cooldownTime)
1649     public
1650     onlyOwner
1651   {
1652     cooldownTime = _cooldownTime;
1653   }
1654 
1655   function _create(address _beneficiary, uint8 _dna1, uint8 _dna2)
1656     private
1657     returns (bool)
1658   {
1659     bytes32 pattern = _generateInitialPattern();
1660     uint256 tokenid = ninjas.length;
1661     bytes16 name = StringLib.generateName("NINJA#", 6, tokenid);
1662 
1663     uint256 id = ninjas.push(Ninja({
1664       pattern: pattern, name: name, level: 1, exp: 0,
1665       dna1: _dna1, dna2: _dna2,
1666       readyTime: uint32(now + cooldownTime),
1667       winCount: 0, lossCount: 0,
1668       levelPoint:0, reward: 0,
1669       lastAttackedCastleid: 0})) - 1;
1670     super._mint(_beneficiary, id);
1671 
1672     emit NewNinja(id, name, pattern);
1673 
1674     return true;
1675   }
1676 
1677   function _triggerCooldown(uint256 _ninjaid)
1678     internal
1679     onlyAccessByGame
1680   {
1681     Ninja storage ninja = ninjas[_ninjaid];
1682     ninja.readyTime = uint32(now + cooldownTime);
1683   }
1684 
1685   function _levelUp(Ninja storage _ninja)
1686     internal
1687     onlyAccessByGame
1688   {
1689     if (_ninja.levelPoint >= leveupExp) {
1690       _ninja.levelPoint -= leveupExp;
1691       _ninja.level++;
1692       if (_ninja.level == 2) {
1693         _ninja.dna1 = uint8(_getRandom(6));
1694       } else if (_ninja.level == 5) {
1695         _ninja.dna2 = uint8(_getRandom(6));
1696       }
1697     }
1698   }
1699 
1700   function getByOwner(address _owner)
1701     external
1702     view
1703     returns(uint256[] result)
1704   {
1705     return ownedTokens[_owner];
1706   }
1707 
1708   function getInfo(uint256 _ninjaid)
1709     external
1710     view
1711     returns (bytes16, uint32, uint16, uint16, bytes32, uint8, uint8)
1712   {
1713     Ninja storage ninja = ninjas[_ninjaid];
1714     return (ninja.name, ninja.level, ninja.winCount, ninja.lossCount, ninja.pattern,
1715       ninja.dna1, ninja.dna2);
1716   }
1717 
1718   function getHp(uint256 _ninjaid)
1719     public
1720     view
1721     returns (uint32)
1722   {
1723     Ninja storage ninja = ninjas[_ninjaid];
1724     return uint32(100 + (ninja.level - 1) * 10);
1725   }
1726 
1727   function getDna1(uint256 _ninjaid)
1728     public
1729     view
1730     returns (uint8)
1731   {
1732     Ninja storage ninja = ninjas[_ninjaid];
1733     return ninja.dna1;
1734   }
1735 
1736   function getDna2(uint256 _ninjaid)
1737     public
1738     view
1739     returns (uint8)
1740   {
1741     Ninja storage ninja = ninjas[_ninjaid];
1742     return ninja.dna2;
1743   }
1744 
1745   function isReady(uint256 _ninjaid)
1746     public
1747     view
1748     returns (bool)
1749   {
1750     Ninja storage ninja = ninjas[_ninjaid];
1751     return (ninja.readyTime <= now);
1752   }
1753 
1754   function getReward(uint256 _ninjaid)
1755     public
1756     view
1757     onlyOwnerOf(_ninjaid)
1758     returns (uint16)
1759   {
1760     Ninja storage ninja = ninjas[_ninjaid];
1761     return ninja.reward;
1762   }
1763 
1764   function getPath(uint256 _ninjaid)
1765     public
1766     view
1767     onlyOwnerOf(_ninjaid)
1768     returns (bytes path)
1769   {
1770     return paths[_ninjaid];
1771   }
1772 
1773   function getLastAttack(uint256 _ninjaid)
1774     public
1775     view
1776     onlyOwnerOf(_ninjaid)
1777     returns (uint256 castleid, bytes path)
1778   {
1779     Ninja storage ninja = ninjas[_ninjaid];
1780     return (ninja.lastAttackedCastleid, paths[_ninjaid]);
1781   }
1782 
1783   function getAttr(bytes32 _pattern, uint256 _n)
1784     internal
1785     pure
1786     returns (bytes4)
1787   {
1788     require(_n < 8);
1789     uint32 mask = 0xffffffff;
1790     return bytes4(uint256(_pattern) / (2 ** ((7 - _n) * 8)) & mask);
1791   }
1792 
1793   function _getRandom(uint256 _modulus)
1794     internal
1795     onlyAccessByGame
1796     returns(uint32)
1797   {
1798     randNonce = randNonce.add(1);
1799     return uint32(uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus);
1800   }
1801 
1802   function _generateInitialPattern()
1803     internal
1804     onlyAccessByGame
1805     returns (bytes32)
1806   {
1807     uint256 pattern = 0;
1808 
1809     uint32 color = COLORS[(_getRandom(COLORS.length))];
1810     for (uint256 i = 0; i < 8; i++) {
1811       uint32 temp = color;
1812       if (i == 1) {
1813         temp |= _getRandom(2);
1814       } else {
1815         temp |= _getRandom(maxCoordinate);
1816       }
1817       pattern = pattern | (temp * 2 ** (8 * 4 * (7 - i)));
1818     }
1819     return bytes32(pattern);
1820   }
1821 
1822   function getPrice()
1823     public
1824     view
1825     returns (uint256)
1826   {
1827     return price;
1828   }
1829 }