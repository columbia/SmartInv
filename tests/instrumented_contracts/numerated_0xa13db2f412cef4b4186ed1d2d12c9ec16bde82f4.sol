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
140 /// @title AccessByGame
141 contract AccessByGame is Pausable, Claimable {
142   mapping(address => bool) internal contractAccess;
143 
144   modifier onlyAccessByGame {
145     require(!paused && (msg.sender == owner || contractAccess[msg.sender] == true));
146     _;
147   }
148 
149   function grantAccess(address _address)
150     onlyOwner
151     public
152   {
153     contractAccess[_address] = true;
154   }
155 
156   function revokeAccess(address _address)
157     onlyOwner
158     public
159   {
160     contractAccess[_address] = false;
161   }
162 }
163 
164 /**
165  * @title ERC20Basic
166  * @dev Simpler version of ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/179
168  */
169 contract ERC20Basic {
170   function totalSupply() public view returns (uint256);
171   function balanceOf(address who) public view returns (uint256);
172   function transfer(address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender)
182     public view returns (uint256);
183 
184   function transferFrom(address from, address to, uint256 value)
185     public returns (bool);
186 
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(
189     address indexed owner,
190     address indexed spender,
191     uint256 value
192   );
193 }
194 
195 /**
196  * @title ERC827 interface, an extension of ERC20 token standard
197  *
198  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
199  * @dev methods to transfer value and data and execute calls in transfers and
200  * @dev approvals.
201  */
202 contract ERC827 is ERC20 {
203   function approveAndCall(
204     address _spender,
205     uint256 _value,
206     bytes _data
207   )
208     public
209     payable
210     returns (bool);
211 
212   function transferAndCall(
213     address _to,
214     uint256 _value,
215     bytes _data
216   )
217     public
218     payable
219     returns (bool);
220 
221   function transferFromAndCall(
222     address _from,
223     address _to,
224     uint256 _value,
225     bytes _data
226   )
227     public
228     payable
229     returns (bool);
230 }
231 
232 /**
233  * @title SafeMath
234  * @dev Math operations with safety checks that throw on error
235  */
236 library SafeMath {
237 
238   /**
239   * @dev Multiplies two numbers, throws on overflow.
240   */
241   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
242     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
243     // benefit is lost if 'b' is also tested.
244     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
245     if (a == 0) {
246       return 0;
247     }
248 
249     c = a * b;
250     assert(c / a == b);
251     return c;
252   }
253 
254   /**
255   * @dev Integer division of two numbers, truncating the quotient.
256   */
257   function div(uint256 a, uint256 b) internal pure returns (uint256) {
258     // assert(b > 0); // Solidity automatically throws when dividing by 0
259     // uint256 c = a / b;
260     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261     return a / b;
262   }
263 
264   /**
265   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
266   */
267   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268     assert(b <= a);
269     return a - b;
270   }
271 
272   /**
273   * @dev Adds two numbers, throws on overflow.
274   */
275   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
276     c = a + b;
277     assert(c >= a);
278     return c;
279   }
280 }
281 
282 /**
283  * @title Basic token
284  * @dev Basic version of StandardToken, with no allowances.
285  */
286 contract BasicToken is ERC20Basic {
287   using SafeMath for uint256;
288 
289   mapping(address => uint256) balances;
290 
291   uint256 totalSupply_;
292 
293   /**
294   * @dev total number of tokens in existence
295   */
296   function totalSupply() public view returns (uint256) {
297     return totalSupply_;
298   }
299 
300   /**
301   * @dev transfer token for a specified address
302   * @param _to The address to transfer to.
303   * @param _value The amount to be transferred.
304   */
305   function transfer(address _to, uint256 _value) public returns (bool) {
306     require(_to != address(0));
307     require(_value <= balances[msg.sender]);
308 
309     balances[msg.sender] = balances[msg.sender].sub(_value);
310     balances[_to] = balances[_to].add(_value);
311     emit Transfer(msg.sender, _to, _value);
312     return true;
313   }
314 
315   /**
316   * @dev Gets the balance of the specified address.
317   * @param _owner The address to query the the balance of.
318   * @return An uint256 representing the amount owned by the passed address.
319   */
320   function balanceOf(address _owner) public view returns (uint256) {
321     return balances[_owner];
322   }
323 
324 }
325 
326 /**
327  * @title Standard ERC20 token
328  *
329  * @dev Implementation of the basic standard token.
330  * @dev https://github.com/ethereum/EIPs/issues/20
331  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
332  */
333 contract StandardToken is ERC20, BasicToken {
334 
335   mapping (address => mapping (address => uint256)) internal allowed;
336 
337 
338   /**
339    * @dev Transfer tokens from one address to another
340    * @param _from address The address which you want to send tokens from
341    * @param _to address The address which you want to transfer to
342    * @param _value uint256 the amount of tokens to be transferred
343    */
344   function transferFrom(
345     address _from,
346     address _to,
347     uint256 _value
348   )
349     public
350     returns (bool)
351   {
352     require(_to != address(0));
353     require(_value <= balances[_from]);
354     require(_value <= allowed[_from][msg.sender]);
355 
356     balances[_from] = balances[_from].sub(_value);
357     balances[_to] = balances[_to].add(_value);
358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
359     emit Transfer(_from, _to, _value);
360     return true;
361   }
362 
363   /**
364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
365    *
366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370    * @param _spender The address which will spend the funds.
371    * @param _value The amount of tokens to be spent.
372    */
373   function approve(address _spender, uint256 _value) public returns (bool) {
374     allowed[msg.sender][_spender] = _value;
375     emit Approval(msg.sender, _spender, _value);
376     return true;
377   }
378 
379   /**
380    * @dev Function to check the amount of tokens that an owner allowed to a spender.
381    * @param _owner address The address which owns the funds.
382    * @param _spender address The address which will spend the funds.
383    * @return A uint256 specifying the amount of tokens still available for the spender.
384    */
385   function allowance(
386     address _owner,
387     address _spender
388    )
389     public
390     view
391     returns (uint256)
392   {
393     return allowed[_owner][_spender];
394   }
395 
396   /**
397    * @dev Increase the amount of tokens that an owner allowed to a spender.
398    *
399    * approve should be called when allowed[_spender] == 0. To increment
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _addedValue The amount of tokens to increase the allowance by.
405    */
406   function increaseApproval(
407     address _spender,
408     uint _addedValue
409   )
410     public
411     returns (bool)
412   {
413     allowed[msg.sender][_spender] = (
414       allowed[msg.sender][_spender].add(_addedValue));
415     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416     return true;
417   }
418 
419   /**
420    * @dev Decrease the amount of tokens that an owner allowed to a spender.
421    *
422    * approve should be called when allowed[_spender] == 0. To decrement
423    * allowed value is better to use this function to avoid 2 calls (and wait until
424    * the first transaction is mined)
425    * From MonolithDAO Token.sol
426    * @param _spender The address which will spend the funds.
427    * @param _subtractedValue The amount of tokens to decrease the allowance by.
428    */
429   function decreaseApproval(
430     address _spender,
431     uint _subtractedValue
432   )
433     public
434     returns (bool)
435   {
436     uint oldValue = allowed[msg.sender][_spender];
437     if (_subtractedValue > oldValue) {
438       allowed[msg.sender][_spender] = 0;
439     } else {
440       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
441     }
442     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
443     return true;
444   }
445 
446 }
447 
448 contract ERC827Caller {
449   function makeCall(address _target, bytes _data) external payable returns (bool) {
450     // solium-disable-next-line security/no-call-value
451     return _target.call.value(msg.value)(_data);
452   }
453 }
454 
455 /**
456  * @title ERC827, an extension of ERC20 token standard
457  *
458  * @dev Implementation the ERC827, following the ERC20 standard with extra
459  * @dev methods to transfer value and data and execute calls in transfers and
460  * @dev approvals.
461  *
462  * @dev Uses OpenZeppelin StandardToken.
463  */
464 contract ERC827Token is ERC827, StandardToken {
465   ERC827Caller internal caller_;
466 
467   constructor() public {
468     caller_ = new ERC827Caller();
469   }
470 
471   /**
472    * @dev Addition to ERC20 token methods. It allows to
473    * @dev approve the transfer of value and execute a call with the sent data.
474    *
475    * @dev Beware that changing an allowance with this method brings the risk that
476    * @dev someone may use both the old and the new allowance by unfortunate
477    * @dev transaction ordering. One possible solution to mitigate this race condition
478    * @dev is to first reduce the spender's allowance to 0 and set the desired value
479    * @dev afterwards:
480    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
481    *
482    * @param _spender The address that will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    * @param _data ABI-encoded contract call to call `_to` address.
485    *
486    * @return true if the call function was executed successfully
487    */
488   function approveAndCall(
489     address _spender,
490     uint256 _value,
491     bytes _data
492   )
493     public
494     payable
495     returns (bool)
496   {
497     require(_spender != address(this));
498 
499     super.approve(_spender, _value);
500 
501     // solium-disable-next-line security/no-call-value
502     require(caller_.makeCall.value(msg.value)(_spender, _data));
503 
504     return true;
505   }
506 
507   /**
508    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
509    * @dev address and execute a call with the sent data on the same transaction
510    *
511    * @param _to address The address which you want to transfer to
512    * @param _value uint256 the amout of tokens to be transfered
513    * @param _data ABI-encoded contract call to call `_to` address.
514    *
515    * @return true if the call function was executed successfully
516    */
517   function transferAndCall(
518     address _to,
519     uint256 _value,
520     bytes _data
521   )
522     public
523     payable
524     returns (bool)
525   {
526     require(_to != address(this));
527 
528     super.transfer(_to, _value);
529 
530     // solium-disable-next-line security/no-call-value
531     require(caller_.makeCall.value(msg.value)(_to, _data));
532     return true;
533   }
534 
535   /**
536    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
537    * @dev another and make a contract call on the same transaction
538    *
539    * @param _from The address which you want to send tokens from
540    * @param _to The address which you want to transfer to
541    * @param _value The amout of tokens to be transferred
542    * @param _data ABI-encoded contract call to call `_to` address.
543    *
544    * @return true if the call function was executed successfully
545    */
546   function transferFromAndCall(
547     address _from,
548     address _to,
549     uint256 _value,
550     bytes _data
551   )
552     public payable returns (bool)
553   {
554     require(_to != address(this));
555 
556     super.transferFrom(_from, _to, _value);
557 
558     // solium-disable-next-line security/no-call-value
559     require(caller_.makeCall.value(msg.value)(_to, _data));
560     return true;
561   }
562 
563   /**
564    * @dev Addition to StandardToken methods. Increase the amount of tokens that
565    * @dev an owner allowed to a spender and execute a call with the sent data.
566    *
567    * @dev approve should be called when allowed[_spender] == 0. To increment
568    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
569    * @dev the first transaction is mined)
570    * @dev From MonolithDAO Token.sol
571    *
572    * @param _spender The address which will spend the funds.
573    * @param _addedValue The amount of tokens to increase the allowance by.
574    * @param _data ABI-encoded contract call to call `_spender` address.
575    */
576   function increaseApprovalAndCall(
577     address _spender,
578     uint _addedValue,
579     bytes _data
580   )
581     public
582     payable
583     returns (bool)
584   {
585     require(_spender != address(this));
586 
587     super.increaseApproval(_spender, _addedValue);
588 
589     // solium-disable-next-line security/no-call-value
590     require(caller_.makeCall.value(msg.value)(_spender, _data));
591 
592     return true;
593   }
594 
595   /**
596    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
597    * @dev an owner allowed to a spender and execute a call with the sent data.
598    *
599    * @dev approve should be called when allowed[_spender] == 0. To decrement
600    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
601    * @dev the first transaction is mined)
602    * @dev From MonolithDAO Token.sol
603    *
604    * @param _spender The address which will spend the funds.
605    * @param _subtractedValue The amount of tokens to decrease the allowance by.
606    * @param _data ABI-encoded contract call to call `_spender` address.
607    */
608   function decreaseApprovalAndCall(
609     address _spender,
610     uint _subtractedValue,
611     bytes _data
612   )
613     public
614     payable
615     returns (bool)
616   {
617     require(_spender != address(this));
618 
619     super.decreaseApproval(_spender, _subtractedValue);
620 
621     // solium-disable-next-line security/no-call-value
622     require(caller_.makeCall.value(msg.value)(_spender, _data));
623 
624     return true;
625   }
626 
627 }
628 
629 /**
630  * @title Mintable token
631  * @dev Simple ERC20 Token example, with mintable token creation
632  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
633  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
634  */
635 contract MintableToken is StandardToken, Ownable {
636   event Mint(address indexed to, uint256 amount);
637   event MintFinished();
638 
639   bool public mintingFinished = false;
640 
641 
642   modifier canMint() {
643     require(!mintingFinished);
644     _;
645   }
646 
647   modifier hasMintPermission() {
648     require(msg.sender == owner);
649     _;
650   }
651 
652   /**
653    * @dev Function to mint tokens
654    * @param _to The address that will receive the minted tokens.
655    * @param _amount The amount of tokens to mint.
656    * @return A boolean that indicates if the operation was successful.
657    */
658   function mint(
659     address _to,
660     uint256 _amount
661   )
662     hasMintPermission
663     canMint
664     public
665     returns (bool)
666   {
667     totalSupply_ = totalSupply_.add(_amount);
668     balances[_to] = balances[_to].add(_amount);
669     emit Mint(_to, _amount);
670     emit Transfer(address(0), _to, _amount);
671     return true;
672   }
673 
674   /**
675    * @dev Function to stop minting new tokens.
676    * @return True if the operation was successful.
677    */
678   function finishMinting() onlyOwner canMint public returns (bool) {
679     mintingFinished = true;
680     emit MintFinished();
681     return true;
682   }
683 }
684 
685 /// @title EverGold
686 /// @dev ERC827 Token for games.
687 contract EverGold is ERC827Token, MintableToken, AccessByGame {
688   string public constant name = "Ever Gold";
689   string public constant symbol = "EG";
690   uint8 public constant decimals = 0;
691 
692 /**
693    * @dev Function to mint tokens
694    * @param _to The address that will receive the minted tokens.
695    * @param _amount The amount of tokens to mint.
696    * @return A boolean that indicates if the operation was successful.
697    */
698   function mint(
699     address _to,
700     uint256 _amount
701   )
702     onlyAccessByGame
703     canMint
704     public
705     returns (bool)
706   {
707     totalSupply_ = totalSupply_.add(_amount);
708     balances[_to] = balances[_to].add(_amount);
709     emit Mint(_to, _amount);
710     emit Transfer(address(0), _to, _amount);
711     return true;
712   }
713   function transfer(address _to, uint256 _value)
714     public
715     whenNotPaused
716     returns (bool)
717   {
718     return super.transfer(_to, _value);
719   }
720 
721   function transferFrom(address _from, address _to, uint256 _value)
722     public
723     whenNotPaused
724     returns (bool)
725   {
726     return super.transferFrom(_from, _to, _value);
727   }
728 
729   function approve(address _spender, uint256 _value)
730     public
731     whenNotPaused
732     returns (bool)
733   {
734     return super.approve(_spender, _value);
735   }
736 
737   function approveAndCall(
738     address _spender,
739     uint256 _value,
740     bytes _data
741   )
742     public
743     payable
744     whenNotPaused
745     returns (bool)
746   {
747     return super.approveAndCall(_spender, _value, _data);
748   }
749 
750   function transferAndCall(
751     address _to,
752     uint256 _value,
753     bytes _data
754   )
755     public
756     payable
757     whenNotPaused
758     returns (bool)
759   {
760     return super.transferAndCall(_to, _value, _data);
761   }
762 
763   function transferFromAndCall(
764     address _from,
765     address _to,
766     uint256 _value,
767     bytes _data
768   )
769     public
770     payable
771     whenNotPaused
772     returns (bool)
773   {
774     return super.transferFromAndCall(_from, _to, _value, _data);
775   }
776 
777   function increaseApprovalAndCall(
778     address _spender,
779     uint _addedValue,
780     bytes _data
781   )
782     public
783     payable
784     whenNotPaused
785     returns (bool)
786   {
787     return super.increaseApprovalAndCall(_spender, _addedValue, _data);
788   }
789 
790   function decreaseApprovalAndCall(
791     address _spender,
792     uint _subtractedValue,
793     bytes _data
794   )
795     public
796     payable
797     whenNotPaused
798     returns (bool)
799   {
800     return super.decreaseApprovalAndCall(_spender, _subtractedValue, _data);
801   }
802 }
803 
804 library StringLib {
805   function generateName(bytes16 _s, uint256 _len, uint256 _n)
806     public
807     pure
808     returns (bytes16 ret)
809   {
810     uint256 v = _n;
811     bytes16 num = 0;
812     while (v > 0) {
813       num = bytes16(uint(num) / (2 ** 8));
814       num |= bytes16(((v % 10) + 48) * 2 ** (8 * 15));
815       v /= 10;
816     }
817     ret = _s | bytes16(uint(num) / (2 ** (8 * _len)));
818     return ret;
819   }
820 }
821 
822 /**
823  * @title ERC721 Non-Fungible Token Standard basic interface
824  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
825  */
826 contract ERC721Basic {
827   event Transfer(
828     address indexed _from,
829     address indexed _to,
830     uint256 _tokenId
831   );
832   event Approval(
833     address indexed _owner,
834     address indexed _approved,
835     uint256 _tokenId
836   );
837   event ApprovalForAll(
838     address indexed _owner,
839     address indexed _operator,
840     bool _approved
841   );
842 
843   function balanceOf(address _owner) public view returns (uint256 _balance);
844   function ownerOf(uint256 _tokenId) public view returns (address _owner);
845   function exists(uint256 _tokenId) public view returns (bool _exists);
846 
847   function approve(address _to, uint256 _tokenId) public;
848   function getApproved(uint256 _tokenId)
849     public view returns (address _operator);
850 
851   function setApprovalForAll(address _operator, bool _approved) public;
852   function isApprovedForAll(address _owner, address _operator)
853     public view returns (bool);
854 
855   function transferFrom(address _from, address _to, uint256 _tokenId) public;
856   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
857     public;
858 
859   function safeTransferFrom(
860     address _from,
861     address _to,
862     uint256 _tokenId,
863     bytes _data
864   )
865     public;
866 }
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
870  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
871  */
872 contract ERC721Enumerable is ERC721Basic {
873   function totalSupply() public view returns (uint256);
874   function tokenOfOwnerByIndex(
875     address _owner,
876     uint256 _index
877   )
878     public
879     view
880     returns (uint256 _tokenId);
881 
882   function tokenByIndex(uint256 _index) public view returns (uint256);
883 }
884 
885 
886 /**
887  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
888  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
889  */
890 contract ERC721Metadata is ERC721Basic {
891   function name() public view returns (string _name);
892   function symbol() public view returns (string _symbol);
893   function tokenURI(uint256 _tokenId) public view returns (string);
894 }
895 
896 
897 /**
898  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
899  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
900  */
901 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
902 }
903 
904 /**
905  * Utility library of inline functions on addresses
906  */
907 library AddressUtils {
908 
909   /**
910    * Returns whether the target address is a contract
911    * @dev This function will return false if invoked during the constructor of a contract,
912    *  as the code is not actually created until after the constructor finishes.
913    * @param addr address to check
914    * @return whether the target address is a contract
915    */
916   function isContract(address addr) internal view returns (bool) {
917     uint256 size;
918     // XXX Currently there is no better way to check if there is a contract in an address
919     // than to check the size of the code at that address.
920     // See https://ethereum.stackexchange.com/a/14016/36603
921     // for more details about how this works.
922     // TODO Check this again before the Serenity release, because all addresses will be
923     // contracts then.
924     // solium-disable-next-line security/no-inline-assembly
925     assembly { size := extcodesize(addr) }
926     return size > 0;
927   }
928 
929 }
930 
931 /**
932  * @title ERC721 token receiver interface
933  * @dev Interface for any contract that wants to support safeTransfers
934  *  from ERC721 asset contracts.
935  */
936 contract ERC721Receiver {
937   /**
938    * @dev Magic value to be returned upon successful reception of an NFT
939    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
940    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
941    */
942   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
943 
944   /**
945    * @notice Handle the receipt of an NFT
946    * @dev The ERC721 smart contract calls this function on the recipient
947    *  after a `safetransfer`. This function MAY throw to revert and reject the
948    *  transfer. This function MUST use 50,000 gas or less. Return of other
949    *  than the magic value MUST result in the transaction being reverted.
950    *  Note: the contract address is always the message sender.
951    * @param _from The sending address
952    * @param _tokenId The NFT identifier which is being transfered
953    * @param _data Additional data with no specified format
954    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
955    */
956   function onERC721Received(
957     address _from,
958     uint256 _tokenId,
959     bytes _data
960   )
961     public
962     returns(bytes4);
963 }
964 
965 /**
966  * @title ERC721 Non-Fungible Token Standard basic implementation
967  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
968  */
969 contract ERC721BasicToken is ERC721Basic {
970   using SafeMath for uint256;
971   using AddressUtils for address;
972 
973   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
974   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
975   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
976 
977   // Mapping from token ID to owner
978   mapping (uint256 => address) internal tokenOwner;
979 
980   // Mapping from token ID to approved address
981   mapping (uint256 => address) internal tokenApprovals;
982 
983   // Mapping from owner to number of owned token
984   mapping (address => uint256) internal ownedTokensCount;
985 
986   // Mapping from owner to operator approvals
987   mapping (address => mapping (address => bool)) internal operatorApprovals;
988 
989   /**
990    * @dev Guarantees msg.sender is owner of the given token
991    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
992    */
993   modifier onlyOwnerOf(uint256 _tokenId) {
994     require(ownerOf(_tokenId) == msg.sender);
995     _;
996   }
997 
998   /**
999    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
1000    * @param _tokenId uint256 ID of the token to validate
1001    */
1002   modifier canTransfer(uint256 _tokenId) {
1003     require(isApprovedOrOwner(msg.sender, _tokenId));
1004     _;
1005   }
1006 
1007   /**
1008    * @dev Gets the balance of the specified address
1009    * @param _owner address to query the balance of
1010    * @return uint256 representing the amount owned by the passed address
1011    */
1012   function balanceOf(address _owner) public view returns (uint256) {
1013     require(_owner != address(0));
1014     return ownedTokensCount[_owner];
1015   }
1016 
1017   /**
1018    * @dev Gets the owner of the specified token ID
1019    * @param _tokenId uint256 ID of the token to query the owner of
1020    * @return owner address currently marked as the owner of the given token ID
1021    */
1022   function ownerOf(uint256 _tokenId) public view returns (address) {
1023     address owner = tokenOwner[_tokenId];
1024     require(owner != address(0));
1025     return owner;
1026   }
1027 
1028   /**
1029    * @dev Returns whether the specified token exists
1030    * @param _tokenId uint256 ID of the token to query the existence of
1031    * @return whether the token exists
1032    */
1033   function exists(uint256 _tokenId) public view returns (bool) {
1034     address owner = tokenOwner[_tokenId];
1035     return owner != address(0);
1036   }
1037 
1038   /**
1039    * @dev Approves another address to transfer the given token ID
1040    * @dev The zero address indicates there is no approved address.
1041    * @dev There can only be one approved address per token at a given time.
1042    * @dev Can only be called by the token owner or an approved operator.
1043    * @param _to address to be approved for the given token ID
1044    * @param _tokenId uint256 ID of the token to be approved
1045    */
1046   function approve(address _to, uint256 _tokenId) public {
1047     address owner = ownerOf(_tokenId);
1048     require(_to != owner);
1049     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1050 
1051     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
1052       tokenApprovals[_tokenId] = _to;
1053       emit Approval(owner, _to, _tokenId);
1054     }
1055   }
1056 
1057   /**
1058    * @dev Gets the approved address for a token ID, or zero if no address set
1059    * @param _tokenId uint256 ID of the token to query the approval of
1060    * @return address currently approved for the given token ID
1061    */
1062   function getApproved(uint256 _tokenId) public view returns (address) {
1063     return tokenApprovals[_tokenId];
1064   }
1065 
1066   /**
1067    * @dev Sets or unsets the approval of a given operator
1068    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
1069    * @param _to operator address to set the approval
1070    * @param _approved representing the status of the approval to be set
1071    */
1072   function setApprovalForAll(address _to, bool _approved) public {
1073     require(_to != msg.sender);
1074     operatorApprovals[msg.sender][_to] = _approved;
1075     emit ApprovalForAll(msg.sender, _to, _approved);
1076   }
1077 
1078   /**
1079    * @dev Tells whether an operator is approved by a given owner
1080    * @param _owner owner address which you want to query the approval of
1081    * @param _operator operator address which you want to query the approval of
1082    * @return bool whether the given operator is approved by the given owner
1083    */
1084   function isApprovedForAll(
1085     address _owner,
1086     address _operator
1087   )
1088     public
1089     view
1090     returns (bool)
1091   {
1092     return operatorApprovals[_owner][_operator];
1093   }
1094 
1095   /**
1096    * @dev Transfers the ownership of a given token ID to another address
1097    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1098    * @dev Requires the msg sender to be the owner, approved, or operator
1099    * @param _from current owner of the token
1100    * @param _to address to receive the ownership of the given token ID
1101    * @param _tokenId uint256 ID of the token to be transferred
1102   */
1103   function transferFrom(
1104     address _from,
1105     address _to,
1106     uint256 _tokenId
1107   )
1108     public
1109     canTransfer(_tokenId)
1110   {
1111     require(_from != address(0));
1112     require(_to != address(0));
1113 
1114     clearApproval(_from, _tokenId);
1115     removeTokenFrom(_from, _tokenId);
1116     addTokenTo(_to, _tokenId);
1117 
1118     emit Transfer(_from, _to, _tokenId);
1119   }
1120 
1121   /**
1122    * @dev Safely transfers the ownership of a given token ID to another address
1123    * @dev If the target address is a contract, it must implement `onERC721Received`,
1124    *  which is called upon a safe transfer, and return the magic value
1125    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1126    *  the transfer is reverted.
1127    * @dev Requires the msg sender to be the owner, approved, or operator
1128    * @param _from current owner of the token
1129    * @param _to address to receive the ownership of the given token ID
1130    * @param _tokenId uint256 ID of the token to be transferred
1131   */
1132   function safeTransferFrom(
1133     address _from,
1134     address _to,
1135     uint256 _tokenId
1136   )
1137     public
1138     canTransfer(_tokenId)
1139   {
1140     // solium-disable-next-line arg-overflow
1141     safeTransferFrom(_from, _to, _tokenId, "");
1142   }
1143 
1144   /**
1145    * @dev Safely transfers the ownership of a given token ID to another address
1146    * @dev If the target address is a contract, it must implement `onERC721Received`,
1147    *  which is called upon a safe transfer, and return the magic value
1148    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1149    *  the transfer is reverted.
1150    * @dev Requires the msg sender to be the owner, approved, or operator
1151    * @param _from current owner of the token
1152    * @param _to address to receive the ownership of the given token ID
1153    * @param _tokenId uint256 ID of the token to be transferred
1154    * @param _data bytes data to send along with a safe transfer check
1155    */
1156   function safeTransferFrom(
1157     address _from,
1158     address _to,
1159     uint256 _tokenId,
1160     bytes _data
1161   )
1162     public
1163     canTransfer(_tokenId)
1164   {
1165     transferFrom(_from, _to, _tokenId);
1166     // solium-disable-next-line arg-overflow
1167     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1168   }
1169 
1170   /**
1171    * @dev Returns whether the given spender can transfer a given token ID
1172    * @param _spender address of the spender to query
1173    * @param _tokenId uint256 ID of the token to be transferred
1174    * @return bool whether the msg.sender is approved for the given token ID,
1175    *  is an operator of the owner, or is the owner of the token
1176    */
1177   function isApprovedOrOwner(
1178     address _spender,
1179     uint256 _tokenId
1180   )
1181     internal
1182     view
1183     returns (bool)
1184   {
1185     address owner = ownerOf(_tokenId);
1186     // Disable solium check because of
1187     // https://github.com/duaraghav8/Solium/issues/175
1188     // solium-disable-next-line operator-whitespace
1189     return (
1190       _spender == owner ||
1191       getApproved(_tokenId) == _spender ||
1192       isApprovedForAll(owner, _spender)
1193     );
1194   }
1195 
1196   /**
1197    * @dev Internal function to mint a new token
1198    * @dev Reverts if the given token ID already exists
1199    * @param _to The address that will own the minted token
1200    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1201    */
1202   function _mint(address _to, uint256 _tokenId) internal {
1203     require(_to != address(0));
1204     addTokenTo(_to, _tokenId);
1205     emit Transfer(address(0), _to, _tokenId);
1206   }
1207 
1208   /**
1209    * @dev Internal function to burn a specific token
1210    * @dev Reverts if the token does not exist
1211    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1212    */
1213   function _burn(address _owner, uint256 _tokenId) internal {
1214     clearApproval(_owner, _tokenId);
1215     removeTokenFrom(_owner, _tokenId);
1216     emit Transfer(_owner, address(0), _tokenId);
1217   }
1218 
1219   /**
1220    * @dev Internal function to clear current approval of a given token ID
1221    * @dev Reverts if the given address is not indeed the owner of the token
1222    * @param _owner owner of the token
1223    * @param _tokenId uint256 ID of the token to be transferred
1224    */
1225   function clearApproval(address _owner, uint256 _tokenId) internal {
1226     require(ownerOf(_tokenId) == _owner);
1227     if (tokenApprovals[_tokenId] != address(0)) {
1228       tokenApprovals[_tokenId] = address(0);
1229       emit Approval(_owner, address(0), _tokenId);
1230     }
1231   }
1232 
1233   /**
1234    * @dev Internal function to add a token ID to the list of a given address
1235    * @param _to address representing the new owner of the given token ID
1236    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1237    */
1238   function addTokenTo(address _to, uint256 _tokenId) internal {
1239     require(tokenOwner[_tokenId] == address(0));
1240     tokenOwner[_tokenId] = _to;
1241     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1242   }
1243 
1244   /**
1245    * @dev Internal function to remove a token ID from the list of a given address
1246    * @param _from address representing the previous owner of the given token ID
1247    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1248    */
1249   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1250     require(ownerOf(_tokenId) == _from);
1251     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1252     tokenOwner[_tokenId] = address(0);
1253   }
1254 
1255   /**
1256    * @dev Internal function to invoke `onERC721Received` on a target address
1257    * @dev The call is not executed if the target address is not a contract
1258    * @param _from address representing the previous owner of the given token ID
1259    * @param _to target address that will receive the tokens
1260    * @param _tokenId uint256 ID of the token to be transferred
1261    * @param _data bytes optional data to send along with the call
1262    * @return whether the call correctly returned the expected magic value
1263    */
1264   function checkAndCallSafeTransfer(
1265     address _from,
1266     address _to,
1267     uint256 _tokenId,
1268     bytes _data
1269   )
1270     internal
1271     returns (bool)
1272   {
1273     if (!_to.isContract()) {
1274       return true;
1275     }
1276     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1277       _from, _tokenId, _data);
1278     return (retval == ERC721_RECEIVED);
1279   }
1280 }
1281 
1282 /**
1283  * @title Full ERC721 Token
1284  * This implementation includes all the required and some optional functionality of the ERC721 standard
1285  * Moreover, it includes approve all functionality using operator terminology
1286  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1287  */
1288 contract ERC721Token is ERC721, ERC721BasicToken {
1289   // Token name
1290   string internal name_;
1291 
1292   // Token symbol
1293   string internal symbol_;
1294 
1295   // Mapping from owner to list of owned token IDs
1296   mapping(address => uint256[]) internal ownedTokens;
1297 
1298   // Mapping from token ID to index of the owner tokens list
1299   mapping(uint256 => uint256) internal ownedTokensIndex;
1300 
1301   // Array with all token ids, used for enumeration
1302   uint256[] internal allTokens;
1303 
1304   // Mapping from token id to position in the allTokens array
1305   mapping(uint256 => uint256) internal allTokensIndex;
1306 
1307   // Optional mapping for token URIs
1308   mapping(uint256 => string) internal tokenURIs;
1309 
1310   /**
1311    * @dev Constructor function
1312    */
1313   constructor(string _name, string _symbol) public {
1314     name_ = _name;
1315     symbol_ = _symbol;
1316   }
1317 
1318   /**
1319    * @dev Gets the token name
1320    * @return string representing the token name
1321    */
1322   function name() public view returns (string) {
1323     return name_;
1324   }
1325 
1326   /**
1327    * @dev Gets the token symbol
1328    * @return string representing the token symbol
1329    */
1330   function symbol() public view returns (string) {
1331     return symbol_;
1332   }
1333 
1334   /**
1335    * @dev Returns an URI for a given token ID
1336    * @dev Throws if the token ID does not exist. May return an empty string.
1337    * @param _tokenId uint256 ID of the token to query
1338    */
1339   function tokenURI(uint256 _tokenId) public view returns (string) {
1340     require(exists(_tokenId));
1341     return tokenURIs[_tokenId];
1342   }
1343 
1344   /**
1345    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1346    * @param _owner address owning the tokens list to be accessed
1347    * @param _index uint256 representing the index to be accessed of the requested tokens list
1348    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1349    */
1350   function tokenOfOwnerByIndex(
1351     address _owner,
1352     uint256 _index
1353   )
1354     public
1355     view
1356     returns (uint256)
1357   {
1358     require(_index < balanceOf(_owner));
1359     return ownedTokens[_owner][_index];
1360   }
1361 
1362   /**
1363    * @dev Gets the total amount of tokens stored by the contract
1364    * @return uint256 representing the total amount of tokens
1365    */
1366   function totalSupply() public view returns (uint256) {
1367     return allTokens.length;
1368   }
1369 
1370   /**
1371    * @dev Gets the token ID at a given index of all the tokens in this contract
1372    * @dev Reverts if the index is greater or equal to the total number of tokens
1373    * @param _index uint256 representing the index to be accessed of the tokens list
1374    * @return uint256 token ID at the given index of the tokens list
1375    */
1376   function tokenByIndex(uint256 _index) public view returns (uint256) {
1377     require(_index < totalSupply());
1378     return allTokens[_index];
1379   }
1380 
1381   /**
1382    * @dev Internal function to set the token URI for a given token
1383    * @dev Reverts if the token ID does not exist
1384    * @param _tokenId uint256 ID of the token to set its URI
1385    * @param _uri string URI to assign
1386    */
1387   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1388     require(exists(_tokenId));
1389     tokenURIs[_tokenId] = _uri;
1390   }
1391 
1392   /**
1393    * @dev Internal function to add a token ID to the list of a given address
1394    * @param _to address representing the new owner of the given token ID
1395    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1396    */
1397   function addTokenTo(address _to, uint256 _tokenId) internal {
1398     super.addTokenTo(_to, _tokenId);
1399     uint256 length = ownedTokens[_to].length;
1400     ownedTokens[_to].push(_tokenId);
1401     ownedTokensIndex[_tokenId] = length;
1402   }
1403 
1404   /**
1405    * @dev Internal function to remove a token ID from the list of a given address
1406    * @param _from address representing the previous owner of the given token ID
1407    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1408    */
1409   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1410     super.removeTokenFrom(_from, _tokenId);
1411 
1412     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1413     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1414     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1415 
1416     ownedTokens[_from][tokenIndex] = lastToken;
1417     ownedTokens[_from][lastTokenIndex] = 0;
1418     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1419     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1420     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1421 
1422     ownedTokens[_from].length--;
1423     ownedTokensIndex[_tokenId] = 0;
1424     ownedTokensIndex[lastToken] = tokenIndex;
1425   }
1426 
1427   /**
1428    * @dev Internal function to mint a new token
1429    * @dev Reverts if the given token ID already exists
1430    * @param _to address the beneficiary that will own the minted token
1431    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1432    */
1433   function _mint(address _to, uint256 _tokenId) internal {
1434     super._mint(_to, _tokenId);
1435 
1436     allTokensIndex[_tokenId] = allTokens.length;
1437     allTokens.push(_tokenId);
1438   }
1439 
1440   /**
1441    * @dev Internal function to burn a specific token
1442    * @dev Reverts if the token does not exist
1443    * @param _owner owner of the token to burn
1444    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1445    */
1446   function _burn(address _owner, uint256 _tokenId) internal {
1447     super._burn(_owner, _tokenId);
1448 
1449     // Clear metadata (if any)
1450     if (bytes(tokenURIs[_tokenId]).length != 0) {
1451       delete tokenURIs[_tokenId];
1452     }
1453 
1454     // Reorg all tokens array
1455     uint256 tokenIndex = allTokensIndex[_tokenId];
1456     uint256 lastTokenIndex = allTokens.length.sub(1);
1457     uint256 lastToken = allTokens[lastTokenIndex];
1458 
1459     allTokens[tokenIndex] = lastToken;
1460     allTokens[lastTokenIndex] = 0;
1461 
1462     allTokens.length--;
1463     allTokensIndex[_tokenId] = 0;
1464     allTokensIndex[lastToken] = tokenIndex;
1465   }
1466 
1467 }
1468 
1469 contract CastleToken is ERC721Token, AccessByGame {
1470   string constant NAME = "Crypto Ninja Game Castle";
1471   string constant SYMBOL = "CNC";
1472 
1473   uint256 constant MAX_WIDTH = 10;
1474 
1475   uint8 constant LOG_SET = 0;
1476   uint8 constant LOG_RESET = 1;
1477   uint8 constant LOG_WIN = 2;
1478   uint8 constant LOG_LOSS = 3;
1479 
1480   struct Castle {
1481     bytes16 name;
1482     uint16 level;
1483     uint32 exp;
1484     uint8 width;
1485     uint8 depth;
1486     uint32 readyTime;
1487     uint16 tryCount;
1488     uint16 winCount;
1489     uint16 lossCount;
1490     uint8 levelPoint;
1491     uint16 reward;
1492   }
1493 
1494   mapping (uint256 => bytes) internal traps;
1495   mapping (uint256 => bytes32[]) internal logs;
1496 
1497   EverGold internal goldToken;
1498 
1499   uint8 public initWidth = 5;
1500   uint8 public initDepth = 8;
1501 
1502   uint256 public itemsPerPage = 10;
1503 
1504   uint8 internal expOnSuccess = 3;
1505   uint8 internal expOnFault = 1;
1506   uint8 internal leveupExp = 10;
1507 
1508   uint256 internal cooldownTime = 5 minutes;
1509 
1510   Castle[] internal castles;
1511 
1512   uint16 public price = 1000;
1513 
1514   event NewCastle(uint256 castleid, uint256 width, uint256 depth);
1515   event SetTraps(uint256 castleid);
1516   event ResetTraps(uint256 castleid);
1517   event UseTrap(uint256 castleid, uint256 path, uint256 trapIndex, uint256 power);
1518 
1519   event AddLog(uint8 id, uint32 datetime, uint256 castleid, uint256 ninjaid, uint8 x, uint8 y, bool win);
1520 
1521   constructor()
1522     public
1523     ERC721Token(NAME, SYMBOL)
1524   {
1525     castles.push(Castle({
1526       name: "DUMMY", level: 0, exp: 0,
1527       width: 0, depth: 0,
1528       readyTime: 0,
1529       tryCount: 0, winCount: 0, lossCount: 0,
1530       levelPoint: 0,
1531       reward: 0}));
1532   }
1533 
1534   function mint(address _beneficiary)
1535     public
1536     whenNotPaused
1537     onlyAccessByGame
1538     returns (bool)
1539   {
1540     require(_beneficiary != address(0));
1541     return _create(_beneficiary, initWidth, initDepth);
1542   }
1543 
1544   function setTraps(
1545     uint256 _castleid,
1546     uint16 _reward,
1547     bytes _traps)
1548     public
1549     whenNotPaused()
1550     onlyAccessByGame
1551     returns (bool)
1552   {
1553     require((_castleid > 0) && (_castleid < castles.length));
1554     require(_reward > 0);
1555     Castle storage castle = castles[_castleid];
1556     castle.reward = _reward;
1557     traps[_castleid] = _traps;
1558 
1559     logs[_castleid].push(_generateLog(uint32(now), LOG_SET, 0, 0, 0, 0));
1560 
1561     emit SetTraps(_castleid);
1562 
1563     return true;
1564   }
1565 
1566   function resetTraps(uint256 _castleid)
1567     public
1568     onlyAccessByGame
1569     returns (bool)
1570   {
1571     require((_castleid > 0) && (_castleid < castles.length));
1572     Castle storage castle = castles[_castleid];
1573     for (uint256 i = 0; i < castle.width * castle.depth; i++) {
1574       traps[_castleid][i] = byte(0);
1575     }
1576     castle.reward = 0;
1577     logs[_castleid].push(_generateLog(uint32(now), LOG_RESET, 0, 0, 0, 0));
1578 
1579     emit ResetTraps(_castleid);
1580 
1581     return true;
1582   }
1583 
1584   function win(
1585     uint256 _castleid, uint256 _ninjaid, uint256 _path, bytes _steps, uint256 _count)
1586     public
1587     onlyAccessByGame
1588     returns (bool)
1589   {
1590     require((_castleid > 0) && (_castleid < castles.length));
1591     uint8 width = getWidth(_castleid);
1592     for (uint256 i = 0; i < _count; i++) {
1593       traps[_castleid][uint256(_steps[i])] = byte(0);
1594     }
1595     Castle storage castle = castles[_castleid];
1596     castle.winCount++;
1597     castle.exp += expOnSuccess;
1598     castle.levelPoint += expOnSuccess;
1599     _levelUp(castle);
1600     logs[_castleid].push(
1601       _generateLog(
1602         uint32(now), LOG_WIN, uint32(_ninjaid),
1603         uint8(_path % width), uint8(_path / width), 1
1604       )
1605     );
1606 
1607     _triggerCooldown(_castleid);
1608 
1609     return true;
1610   }
1611 
1612   function lost(uint256 _castleid, uint256 _ninjaid)
1613     public
1614     onlyAccessByGame
1615     returns (bool)
1616   {
1617     require((_castleid > 0) && (_castleid < castles.length));
1618     Castle storage castle = castles[_castleid];
1619     castle.reward = 0;
1620     castle.lossCount++;
1621     castle.exp += expOnFault;
1622     castle.levelPoint += expOnFault;
1623     _levelUp(castle);
1624 
1625     logs[_castleid].push(_generateLog(uint32(now), LOG_LOSS, uint32(_ninjaid), 0, 0, 0));
1626 
1627     resetTraps(_castleid);
1628 
1629     _triggerCooldown(_castleid);
1630 
1631     return true;
1632   }
1633 
1634   function setName(uint256 _castleid, bytes16 _newName)
1635     external
1636     onlyOwnerOf(_castleid)
1637   {
1638     castles[_castleid].name = _newName;
1639   }
1640 
1641   function setGoldContract(address _goldTokenAddress)
1642     public
1643     onlyOwner
1644   {
1645     require(_goldTokenAddress != address(0));
1646 
1647     goldToken = EverGold(_goldTokenAddress);
1648   }
1649 
1650   function setFee(uint16 _price)
1651     external
1652     onlyOwner
1653   {
1654     price = _price;
1655   }
1656 
1657   function setItemPerPage(uint16 _amount)
1658     external
1659     onlyOwner
1660   {
1661     itemsPerPage = _amount;
1662   }
1663 
1664   function setMaxCoordinate(uint256 _cooldownTime)
1665     public
1666     onlyOwner
1667   {
1668     cooldownTime = _cooldownTime;
1669   }
1670 
1671   function _create(address _beneficiary, uint8 _width, uint8 _depth)
1672     internal
1673     onlyAccessByGame
1674     returns (bool)
1675   {
1676     require(_beneficiary != address(0));
1677     require((_width > 0) && (_depth > 0));
1678     uint256 tokenid = castles.length;
1679     bytes16 name = StringLib.generateName("CASTLE#", 7, tokenid);
1680 
1681     uint256 id = castles.push(Castle({
1682       name: name, level: 1, exp: 0,
1683       width: _width, depth: _depth,
1684       readyTime: uint32(now + cooldownTime),
1685       tryCount: 0, winCount: 0, lossCount: 0,
1686       levelPoint: 0,
1687       reward: 0})) - 1;
1688 
1689     traps[id] = new bytes(_width * _depth);
1690     _mint(_beneficiary, id);
1691     emit NewCastle(id, _width, _depth);
1692 
1693     return true;
1694   }
1695 
1696   function _levelUp(Castle storage _castle)
1697     internal
1698     onlyAccessByGame
1699   {
1700     if (_castle.levelPoint >= leveupExp) {
1701       _castle.levelPoint -= leveupExp;
1702       _castle.level++;
1703     }
1704   }
1705 
1706   function _triggerCooldown(uint256 _castleid)
1707     internal
1708     onlyAccessByGame
1709   {
1710     require((_castleid > 0) && (_castleid < castles.length));
1711     Castle storage castle = castles[_castleid];
1712     castle.readyTime = uint32(now + cooldownTime);
1713   }
1714 
1715   function getAll()
1716     external
1717     view
1718     returns (uint256[] result)
1719   {
1720     return allTokens;
1721   }
1722 
1723   function getOpen(uint256 _startIndex)
1724     external
1725     view
1726     returns (uint256[] result)
1727   {
1728     uint256 n = 0;
1729     uint256 i = 0;
1730     for (i = _startIndex; i < castles.length; i++) {
1731       Castle storage castle = castles[i];
1732       if ((castle.reward > 0) &&
1733           (ownerOf(i) != msg.sender)) {
1734         n++;
1735         if (n >= _startIndex) {
1736           break;
1737         }
1738       }
1739     }
1740     uint256[] memory castleids = new uint256[](itemsPerPage + 1);
1741     n = 0;
1742     while (i < castles.length) {
1743       castle = castles[i];
1744       if ((castle.reward > 0) &&
1745           (ownerOf(i) != msg.sender)) {
1746         castleids[n++] = i;
1747         if (n > itemsPerPage) {
1748           break;
1749         }
1750       }
1751       i++;
1752     }
1753     return castleids;
1754   }
1755 
1756   function getByOwner(address _owner)
1757     external
1758     view
1759     returns (uint256[] result)
1760   {
1761     return ownedTokens[_owner];
1762   }
1763 
1764   function getInfo(uint256 _castleid)
1765     external
1766     view
1767     returns (bytes16, uint16, uint32,
1768       uint8, uint8, uint16, uint16,
1769       uint16)
1770   {
1771     require((_castleid > 0) && (_castleid < castles.length));
1772     Castle storage castle = castles[_castleid];
1773     return (
1774       castle.name,
1775       castle.level,
1776       castle.exp,
1777       castle.width,
1778       castle.depth,
1779       castle.winCount,
1780       castle.lossCount,
1781       castle.reward);
1782   }
1783 
1784   function getLevel(uint256 _castleid)
1785     external
1786     view
1787     returns (uint16)
1788   {
1789     Castle storage castle = castles[_castleid];
1790     return castle.level;
1791   }
1792 
1793   function getLogs(uint256 _castleid)
1794     external
1795     view
1796     returns (bytes32[])
1797   {
1798     require((_castleid > 0) && (_castleid < castles.length));
1799     return logs[_castleid];
1800   }
1801 
1802   function getTrapInfo(uint256 _castleid)
1803     external
1804     view
1805     returns (bytes)
1806   {
1807     require((ownerOf(_castleid) == msg.sender) || (contractAccess[msg.sender] == true));
1808     return traps[_castleid];
1809   }
1810 
1811   function isReady(uint256 _castleid)
1812     public
1813     view
1814     returns (bool)
1815   {
1816     require((_castleid > 0) && (_castleid < castles.length));
1817     Castle storage castle = castles[_castleid];
1818     return (castle.readyTime <= now);
1819   }
1820 
1821   function getReward(uint256 _castleid)
1822     public
1823     view
1824     returns (uint16)
1825   {
1826     require((_castleid > 0) && (_castleid < castles.length));
1827     Castle storage castle = castles[_castleid];
1828     return castle.reward;
1829   }
1830 
1831   function getWidth(uint256 _castleid)
1832     public
1833     view
1834     returns (uint8)
1835   {
1836     require((_castleid > 0) && (_castleid < castles.length));
1837     Castle storage castle = castles[_castleid];
1838     return castle.width;
1839   }
1840 
1841   function getTrapid(uint256 _castleid, uint8 _path)
1842     public
1843     onlyAccessByGame
1844     view
1845     returns (uint8)
1846   {
1847     return uint8(traps[_castleid][_path]);
1848   }
1849 
1850   function getPrice()
1851     public
1852     view
1853     returns (uint256)
1854   {
1855     return price;
1856   }
1857 
1858   function _generateLog(
1859     uint32 _datetime,
1860     uint8 _id,
1861     uint32 _ninjaid,
1862     uint8 _x,
1863     uint8 _y,
1864     uint8 _win)
1865     internal
1866     pure
1867     returns (bytes32)
1868   {
1869     return
1870       bytes32(
1871         (uint256(_datetime) * (2 ** (8 * 28))) |
1872         (uint256(_id) * (2 ** (8 * 24))) |
1873         (uint256(_ninjaid) * (2 ** (8 * 20))) |
1874         (uint256(_x) * (2 ** (8 * 16))) |
1875         (uint256(_y) * (2 ** (8 * 12))) |
1876         (uint256(_win) * (2 ** (8 * 8))));
1877   }
1878 }
1879 
1880 contract ItemToken is AccessByGame {
1881   struct Item {
1882     bytes16 name;
1883     uint16 price;
1884     uint16 power;
1885     bool enabled;
1886   }
1887 
1888   EverGold internal goldToken;
1889 
1890   Item[] private items;
1891 
1892   uint8 public itemKindCount = 0;
1893 
1894   mapping (address => mapping (uint256 => uint256)) private ownedItems;
1895 
1896   event NewItem(bytes32 name, uint16 price, uint16 power);
1897   event UseItem(uint256 itemid, uint256 amount);
1898 
1899   constructor()
1900     public
1901   {
1902     addItem("None", 0, 0, false);
1903     addItem("Arrow", 10, 10, true);
1904     addItem("Tiger", 30, 20, true);
1905     addItem("Spear", 50, 30, true);
1906     addItem("Wood", 50, 20, true);
1907     addItem("Fire", 50, 20, true);
1908     addItem("Earth", 50, 20, true);
1909     addItem("Metal", 50, 20, true);
1910     addItem("Water", 50, 20, true);
1911   }
1912 
1913   function setGoldContract(address _goldTokenAddress)
1914     public
1915     onlyOwner
1916   {
1917     require(_goldTokenAddress != address(0));
1918 
1919     goldToken = EverGold(_goldTokenAddress);
1920   }
1921 
1922   function buy(address _to, uint256 _itemid, uint256 _amount)
1923     public
1924     onlyAccessByGame
1925     whenNotPaused
1926     returns (bool)
1927   {
1928     require(_amount > 0);
1929     require(_itemid > 0 && _itemid < itemKindCount);
1930     ownedItems[_to][_itemid] += _amount;
1931 
1932     return true;
1933   }
1934 
1935   function useItem(address _owner, uint256 _itemid, uint256 _amount)
1936     public
1937     onlyAccessByGame
1938     whenNotPaused
1939     returns (bool)
1940   {
1941     require(_amount > 0);
1942     require((_itemid > 0) && (_itemid < itemKindCount));
1943     require(_amount <= ownedItems[_owner][_itemid]);
1944 
1945     ownedItems[_owner][_itemid] -= _amount;
1946 
1947     emit UseItem(_itemid, _amount);
1948 
1949     return true;
1950   }
1951 
1952   function addItem(bytes16 _name, uint16 _price, uint16 _power, bool _enabled)
1953     public
1954     onlyOwner()
1955     returns (bool)
1956   {
1957     require(_name != 0x0);
1958     items.push(Item({
1959       name:_name,
1960       price: _price,
1961       power: _power,
1962       enabled: _enabled
1963       }));
1964     itemKindCount++;
1965 
1966     emit NewItem(_name, _price, _power);
1967     return true;
1968   }
1969 
1970   function setItemAvailable(uint256 _itemid, bool _enabled)
1971     public
1972     onlyOwner()
1973   {
1974     require(_itemid > 0 && _itemid < itemKindCount);
1975 
1976     items[_itemid].enabled = _enabled;
1977   }
1978 
1979   function getItemCounts()
1980     public
1981     view
1982     returns (uint256[])
1983   {
1984     uint256[] memory itemCounts = new uint256[](itemKindCount);
1985     for (uint256 i = 0; i < itemKindCount; i++) {
1986       itemCounts[i] = ownedItems[msg.sender][i];
1987     }
1988     return itemCounts;
1989   }
1990 
1991   function getItemCount(uint256 _itemid)
1992     public
1993     view
1994     returns (uint256)
1995   {
1996     require(_itemid > 0 && _itemid < itemKindCount);
1997     return ownedItems[msg.sender][_itemid];
1998   }
1999 
2000   function getItemKindCount()
2001     public
2002     view
2003     returns (uint256)
2004   {
2005     return itemKindCount;
2006   }
2007 
2008   function getItem(uint256 _itemid)
2009     public
2010     view
2011     returns (bytes16 name, uint16 price, uint16 power, bool enabled)
2012   {
2013     require(_itemid < itemKindCount);
2014     return (items[_itemid].name, items[_itemid].price, items[_itemid].power, items[_itemid].enabled);
2015   }
2016 
2017   function getPower(uint256 _itemid)
2018     public
2019     view
2020     returns (uint16 power)
2021   {
2022     require(_itemid < itemKindCount);
2023     return items[_itemid].power;
2024   }
2025 
2026   function getPrice(uint256 _itemid)
2027     public
2028     view
2029     returns (uint16)
2030   {
2031     require(_itemid < itemKindCount);
2032     return items[_itemid].price;
2033   }
2034 }
2035 
2036 contract NinjaToken is ERC721Token, AccessByGame {
2037   string public constant NAME = "Crypto Ninja Game Ninja";
2038   string public constant SYMBOL = "CNN";
2039 
2040   event NewNinja(uint256 ninjaid, bytes16 name, bytes32 pattern);
2041 
2042   struct Ninja {
2043     bytes32 pattern;
2044     bytes16 name;
2045     uint16 level;
2046     uint32 exp;
2047     uint8 dna1;
2048     uint8 dna2;
2049     uint32 readyTime;
2050     uint16 winCount;
2051     uint8 levelPoint;
2052     uint16 lossCount;
2053     uint16 reward;
2054     uint256 lastAttackedCastleid;
2055   }
2056 
2057   mapping (uint256 => bytes) private paths;
2058 
2059   mapping (uint256 => bytes) private steps;
2060 
2061   EverGold internal goldToken;
2062 
2063   uint8 internal expOnSuccess = 3;
2064   uint8 internal expOnFault = 1;
2065   uint8 internal leveupExp = 10;
2066 
2067   uint256 internal cooldownTime = 5 minutes;
2068 
2069   uint256 internal maxCoordinate = 12;
2070 
2071   Ninja[] internal ninjas;
2072 
2073   uint256 private randNonce = 0;
2074 
2075   uint8 public kindCount = 2;
2076   uint32[] public COLORS = [
2077     0xD7003A00,
2078     0xF3980000,
2079     0x00552E00,
2080     0x19448E00,
2081     0x543F3200,
2082     0xE7609E00,
2083     0xFFEC4700,
2084     0x68BE8D00,
2085     0x0095D900,
2086     0xE9DFE500,
2087     0xEE836F00,
2088     0xF2F2B000,
2089     0xAACF5300,
2090     0x0A3AF00,
2091     0xF8FBF800,
2092     0xF4B3C200,
2093     0x928C3600,
2094     0xA59ACA00,
2095     0xABCED800,
2096     0x30283300,
2097     0xFDEFF200,
2098     0xDDBB9900,
2099     0x74539900,
2100     0xAA4C8F00
2101   ];
2102 
2103   uint256 public price = 1000;
2104 
2105   constructor()
2106       public
2107       ERC721Token(NAME, SYMBOL)
2108   {
2109     ninjas.push(Ninja({
2110       pattern: 0, name: "DUMMY", level: 0, exp: 0,
2111       dna1: 0, dna2: 0,
2112       readyTime: 0,
2113       winCount: 0, lossCount: 0,
2114       levelPoint:0, reward: 0,
2115       lastAttackedCastleid: 0 }));
2116   }
2117 
2118   function mint(address _beneficiary)
2119     public
2120     whenNotPaused
2121     onlyAccessByGame
2122     returns (bool)
2123   {
2124     require(_beneficiary != address(0));
2125     return _create(_beneficiary, 0, 0);
2126   }
2127 
2128   function burn(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
2129     super._burn(msg.sender, _tokenId);
2130   }
2131 
2132   function setPath(
2133     uint256 _ninjaid,
2134     uint256 _castleid,
2135     bytes _path,
2136     bytes _steps)
2137     public
2138     onlyAccessByGame
2139   {
2140     Ninja storage ninja = ninjas[_ninjaid];
2141     ninja.lastAttackedCastleid = _castleid;
2142     paths[_ninjaid] = _path;
2143     steps[_ninjaid] = _steps;
2144   }
2145 
2146   function win(uint256 _ninjaid)
2147     public
2148     onlyAccessByGame
2149     returns (bool)
2150   {
2151     Ninja storage ninja = ninjas[_ninjaid];
2152     ninja.winCount++;
2153     ninja.exp += expOnSuccess;
2154     ninja.levelPoint += expOnSuccess;
2155     _levelUp(ninja);
2156 
2157     _triggerCooldown(_ninjaid);
2158 
2159     return true;
2160   }
2161 
2162   function lost(uint256 _ninjaid)
2163     public
2164     onlyAccessByGame
2165     returns (bool)
2166   {
2167     Ninja storage ninja = ninjas[_ninjaid];
2168     ninja.lossCount++;
2169     ninja.exp += expOnFault;
2170     ninja.levelPoint += expOnFault;
2171     _levelUp(ninja);
2172 
2173     _triggerCooldown(_ninjaid);
2174 
2175     return true;
2176   }
2177 
2178   function setName(uint256 _ninjaid, bytes16 _newName)
2179     external
2180     onlyOwnerOf(_ninjaid)
2181   {
2182     ninjas[_ninjaid].name = _newName;
2183   }
2184 
2185   function setGoldContract(address _goldTokenAddress)
2186     public
2187     onlyOwner
2188   {
2189     require(_goldTokenAddress != address(0));
2190 
2191     goldToken = EverGold(_goldTokenAddress);
2192   }
2193 
2194   function setNinjaKindCount(uint8 _kindCount)
2195     public
2196     onlyOwner
2197   {
2198     kindCount = _kindCount;
2199   }
2200 
2201   function setPrice(uint16 _price)
2202     public
2203     onlyOwner
2204   {
2205     price = _price;
2206   }
2207 
2208   function setMaxCoordinate(uint16 _maxCoordinate)
2209     public
2210     onlyOwner
2211   {
2212     maxCoordinate = _maxCoordinate;
2213   }
2214 
2215   function setMaxCoordinate(uint256 _cooldownTime)
2216     public
2217     onlyOwner
2218   {
2219     cooldownTime = _cooldownTime;
2220   }
2221 
2222   function _create(address _beneficiary, uint8 _dna1, uint8 _dna2)
2223     private
2224     returns (bool)
2225   {
2226     bytes32 pattern = _generateInitialPattern();
2227     uint256 tokenid = ninjas.length;
2228     bytes16 name = StringLib.generateName("NINJA#", 6, tokenid);
2229 
2230     uint256 id = ninjas.push(Ninja({
2231       pattern: pattern, name: name, level: 1, exp: 0,
2232       dna1: _dna1, dna2: _dna2,
2233       readyTime: uint32(now + cooldownTime),
2234       winCount: 0, lossCount: 0,
2235       levelPoint:0, reward: 0,
2236       lastAttackedCastleid: 0})) - 1;
2237     super._mint(_beneficiary, id);
2238 
2239     emit NewNinja(id, name, pattern);
2240 
2241     return true;
2242   }
2243 
2244   function _triggerCooldown(uint256 _ninjaid)
2245     internal
2246     onlyAccessByGame
2247   {
2248     Ninja storage ninja = ninjas[_ninjaid];
2249     ninja.readyTime = uint32(now + cooldownTime);
2250   }
2251 
2252   function _levelUp(Ninja storage _ninja)
2253     internal
2254     onlyAccessByGame
2255   {
2256     if (_ninja.levelPoint >= leveupExp) {
2257       _ninja.levelPoint -= leveupExp;
2258       _ninja.level++;
2259       if (_ninja.level == 2) {
2260         _ninja.dna1 = uint8(_getRandom(6));
2261       } else if (_ninja.level == 5) {
2262         _ninja.dna2 = uint8(_getRandom(6));
2263       }
2264     }
2265   }
2266 
2267   function getByOwner(address _owner)
2268     external
2269     view
2270     returns(uint256[] result)
2271   {
2272     return ownedTokens[_owner];
2273   }
2274 
2275   function getInfo(uint256 _ninjaid)
2276     external
2277     view
2278     returns (bytes16, uint32, uint16, uint16, bytes32, uint8, uint8)
2279   {
2280     Ninja storage ninja = ninjas[_ninjaid];
2281     return (ninja.name, ninja.level, ninja.winCount, ninja.lossCount, ninja.pattern,
2282       ninja.dna1, ninja.dna2);
2283   }
2284 
2285   function getHp(uint256 _ninjaid)
2286     public
2287     view
2288     returns (uint32)
2289   {
2290     Ninja storage ninja = ninjas[_ninjaid];
2291     return uint32(100 + (ninja.level - 1) * 10);
2292   }
2293 
2294   function getDna1(uint256 _ninjaid)
2295     public
2296     view
2297     returns (uint8)
2298   {
2299     Ninja storage ninja = ninjas[_ninjaid];
2300     return ninja.dna1;
2301   }
2302 
2303   function getDna2(uint256 _ninjaid)
2304     public
2305     view
2306     returns (uint8)
2307   {
2308     Ninja storage ninja = ninjas[_ninjaid];
2309     return ninja.dna2;
2310   }
2311 
2312   function isReady(uint256 _ninjaid)
2313     public
2314     view
2315     returns (bool)
2316   {
2317     Ninja storage ninja = ninjas[_ninjaid];
2318     return (ninja.readyTime <= now);
2319   }
2320 
2321   function getReward(uint256 _ninjaid)
2322     public
2323     view
2324     onlyOwnerOf(_ninjaid)
2325     returns (uint16)
2326   {
2327     Ninja storage ninja = ninjas[_ninjaid];
2328     return ninja.reward;
2329   }
2330 
2331   function getPath(uint256 _ninjaid)
2332     public
2333     view
2334     onlyOwnerOf(_ninjaid)
2335     returns (bytes path)
2336   {
2337     return paths[_ninjaid];
2338   }
2339 
2340   function getLastAttack(uint256 _ninjaid)
2341     public
2342     view
2343     onlyOwnerOf(_ninjaid)
2344     returns (uint256 castleid, bytes path)
2345   {
2346     Ninja storage ninja = ninjas[_ninjaid];
2347     return (ninja.lastAttackedCastleid, paths[_ninjaid]);
2348   }
2349 
2350   function getAttr(bytes32 _pattern, uint256 _n)
2351     internal
2352     pure
2353     returns (bytes4)
2354   {
2355     require(_n < 8);
2356     uint32 mask = 0xffffffff;
2357     return bytes4(uint256(_pattern) / (2 ** ((7 - _n) * 8)) & mask);
2358   }
2359 
2360   function _getRandom(uint256 _modulus)
2361     internal
2362     onlyAccessByGame
2363     returns(uint32)
2364   {
2365     randNonce = randNonce.add(1);
2366     return uint32(uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus);
2367 //    return uint8(uint256(keccak256(block.timestamp, block.difficulty))%251);
2368   }
2369 
2370   function _generateInitialPattern()
2371     internal
2372     onlyAccessByGame
2373     returns (bytes32)
2374   {
2375     uint256 pattern = 0;
2376 
2377     uint32 color = COLORS[(_getRandom(COLORS.length))];
2378     for (uint256 i = 0; i < 8; i++) {
2379       uint32 temp = color;
2380       if (i == 1) {
2381         temp |= _getRandom(2);
2382       } else {
2383         temp |= _getRandom(maxCoordinate);
2384       }
2385       pattern = pattern | (temp * 2 ** (8 * 4 * (7 - i)));
2386     }
2387     return bytes32(pattern);
2388   }
2389 
2390   function getPrice()
2391     public
2392     view
2393     returns (uint256)
2394   {
2395     return price;
2396   }
2397 }
2398 
2399 contract UserToken is AccessByGame {
2400   struct User {
2401     string name;
2402     uint32 registeredDate;
2403   }
2404 
2405   string constant public DEFAULT_NAME = "NONAME";
2406 
2407   User[] private users;
2408 
2409   uint256 public userCount = 0;
2410 
2411   mapping (address => uint256) private ownerToUser;
2412 
2413   constructor()
2414     public
2415   {
2416     mint(msg.sender, "OWNER");
2417   }
2418 
2419   function mint(address _beneficiary, string _name)
2420     public
2421     onlyAccessByGame
2422     whenNotPaused()
2423     returns (bool)
2424   {
2425     require(_beneficiary != address(0));
2426     require(ownerToUser[_beneficiary] == 0);
2427 
2428     User memory user = User({
2429       name: _name,
2430       registeredDate: uint32(now)
2431     });
2432 
2433     uint256 id = users.push(user) - 1;
2434 
2435     ownerToUser[_beneficiary] = id;
2436 
2437     userCount++;
2438 
2439     return true;
2440   }
2441 
2442   function setName(string _name)
2443     public
2444     whenNotPaused()
2445     returns (bool)
2446   {
2447     require(bytes(_name).length > 1);
2448     require(ownerToUser[msg.sender] != 0);
2449 
2450     uint256 userid = ownerToUser[msg.sender];
2451     users[userid].name = _name;
2452 
2453     return true;
2454   }
2455 
2456   function getUserid(address _owner)
2457     external
2458     view
2459     onlyAccessByGame
2460     returns(uint256 result)
2461   {
2462     if (ownerToUser[_owner] == 0) {
2463       return 0;
2464     }
2465     return ownerToUser[_owner];
2466   }
2467 
2468   function getUserInfo()
2469     public
2470     view
2471     returns (uint256, string, uint32)
2472   {
2473     uint256 userid = ownerToUser[msg.sender];
2474     return getUserInfoById(userid);
2475   }
2476 
2477   function getUserInfoById(uint256 _userid)
2478     public
2479     view
2480     returns (uint256, string, uint32)
2481   {
2482     User storage user = users[_userid];
2483     return (_userid, user.name, user.registeredDate);
2484   }
2485 }
2486 
2487 /**
2488  * @title TokenDestructible:
2489  * @author Remco Bloemen <remco@2π.com>
2490  * @dev Base contract that can be destroyed by owner. All funds in contract including
2491  * listed tokens will be sent to the owner.
2492  */
2493 contract TokenDestructible is Ownable {
2494 
2495   constructor() public payable { }
2496 
2497   /**
2498    * @notice Terminate contract and refund to owner
2499    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
2500    refund.
2501    * @notice The called token contracts could try to re-enter this contract. Only
2502    supply token contracts you trust.
2503    */
2504   function destroy(address[] tokens) onlyOwner public {
2505 
2506     // Transfer tokens to owner
2507     for (uint256 i = 0; i < tokens.length; i++) {
2508       ERC20Basic token = ERC20Basic(tokens[i]);
2509       uint256 balance = token.balanceOf(this);
2510       token.transfer(owner, balance);
2511     }
2512 
2513     // Transfer Eth to owner and terminate contract
2514     selfdestruct(owner);
2515   }
2516 }
2517 
2518 contract GameV001 is AccessByGame, TokenDestructible {
2519   using SafeMath for uint256;
2520 
2521   uint8 constant INIT_WIDTH = 5;
2522   uint8 constant INIT_DEPTH = 8;
2523 
2524   UserToken private userToken;
2525   EverGold private goldToken;
2526   CastleToken private castleToken;
2527   NinjaToken private ninjaToken;
2528   ItemToken private itemToken;
2529 
2530   struct AttackLog {
2531     uint256 castleid;
2532     uint16 reward;
2533     uint32 hp;
2534     uint8 path;
2535     uint32 trapDamage;
2536     bool dead;
2537   }
2538 
2539   mapping (uint256 => AttackLog[]) private attackLogs;
2540   mapping (uint256 => uint256) private numAttackLogs;
2541 
2542   event Attack(uint256 ninjaid, uint256 castleid, uint32 hp, uint8 path, uint32 trapDamage, uint32 damage);
2543   event AttackStart(uint256 ninjaid, uint256 castleid, uint32 hp);
2544   event AttackEnd(uint256 ninjaid, uint256 castleid, bool result);
2545 
2546   constructor(
2547     address _goldTokenAddress,
2548     address _castleTokenAddress,
2549     address _ninjaTokenAddress,
2550     address _userTokenAddress,
2551     address _itemTokenAddress)
2552     public
2553   {
2554     require(_goldTokenAddress != address(0));
2555     require(_castleTokenAddress != address(0));
2556     require(_ninjaTokenAddress != address(0));
2557     require(_userTokenAddress != address(0));
2558     require(_itemTokenAddress != address(0));
2559 
2560     goldToken = EverGold(_goldTokenAddress);
2561     castleToken = CastleToken(_castleTokenAddress);
2562     ninjaToken = NinjaToken(_ninjaTokenAddress);
2563     userToken = UserToken(_userTokenAddress);
2564     itemToken = ItemToken(_itemTokenAddress);
2565   }
2566 
2567   function  registerUser(string _name)
2568     public
2569     returns (bool)
2570   {
2571     require(msg.sender != address(0));
2572     require(userToken.mint(msg.sender, _name));
2573 
2574     return true;
2575   }
2576 
2577   function  buyNinja(address _beneficiary)
2578     public
2579     payable
2580     returns (bool)
2581   {
2582     require(msg.sender != address(0));
2583     uint256 price = ninjaToken.getPrice();
2584     require(msg.value == price);
2585     require(ninjaToken.mint(_beneficiary));
2586 
2587     return true;
2588   }
2589 
2590   function buyCastle(address _beneficiary)
2591     public
2592     payable
2593     returns (bool)
2594   {
2595     require(msg.sender != address(0));
2596     uint256 price = castleToken.getPrice();
2597     require(msg.value == price);
2598     require(castleToken.mint(_beneficiary));
2599 
2600     return true;
2601   }
2602 
2603   function buyItem(address _beneficiary, uint8 _itemid, uint256 _amount)
2604     public
2605     payable
2606     returns (bool)
2607   {
2608     require(msg.sender != address(0));
2609     uint16 price = itemToken.getPrice(_itemid);
2610     uint256 totalPrice = price * _amount;
2611     require(msg.value == totalPrice);
2612     require(itemToken.buy(_beneficiary, _itemid, _amount));
2613 
2614     return true;
2615   }
2616 
2617   function defence(
2618     address _beneficiary,
2619     uint256 _castleid,
2620     uint16 _reward,
2621     bytes _traps,
2622     uint256[] _useTraps)
2623     public
2624     payable
2625     whenNotPaused
2626     returns (bool)
2627   {
2628     require(msg.value == _reward);
2629 
2630     for (uint256 i = 1; i < _useTraps.length; i++) {
2631       if (_useTraps[i] > 0) {
2632         require(itemToken.useItem(_beneficiary, i, _useTraps[i]));
2633       }
2634     }
2635     require(castleToken.setTraps(_castleid, _reward, _traps));
2636 
2637     return true;
2638   }
2639 
2640   function addTraps(
2641     uint256 _castleid,
2642     bytes _traps,
2643     uint256[] _useTraps)
2644     public
2645     whenNotPaused
2646     returns (bool)
2647   {
2648     require(castleToken.getReward(_castleid) > 0);
2649     bytes memory traps = castleToken.getTrapInfo(_castleid);
2650     for (uint256 i = 1; i < _useTraps.length; i++) {
2651       if ((traps[i]) == 0 &&
2652         (_useTraps[i] > 0)) {
2653         require(itemToken.useItem(msg.sender, i, _useTraps[i]));
2654       }
2655     }
2656     require(castleToken.setTraps(_castleid, castleToken.getReward(_castleid), _traps));
2657     return true;
2658   }
2659 
2660   function attack(
2661     uint256 _ninjaid,
2662     uint256 _castleid,
2663     bytes _path)
2664     public
2665     payable
2666     whenNotPaused
2667     returns (bool)
2668   {
2669     uint16 reward = castleToken.getReward(_castleid);
2670     require(msg.value == reward / 2);
2671 
2672     uint32 hp = ninjaToken.getHp(_ninjaid);
2673 
2674     _clearAttackLog(_ninjaid);
2675 
2676     bytes memory steps = new bytes(_path.length);
2677     uint256 count = 0;
2678     uint32 damage = 0;
2679     for (uint256 i = 0; i < _path.length; i++) {
2680       uint32 trapDamage = _computeDamage(_castleid, _ninjaid, uint8(_path[i]));
2681       if (trapDamage > 0) {
2682         steps[count++] = _path[i];
2683         damage = damage + trapDamage;
2684         if (hp <= damage) {
2685           _insertAttackLog(_ninjaid, _castleid, reward, hp, uint8(_path[i]), trapDamage, true);
2686           address castleOwner = castleToken.ownerOf(_castleid);
2687           goldToken.transfer(castleOwner, reward / 2);
2688           castleToken.win(_castleid, _ninjaid, uint256(_path[i]), steps, count);
2689           ninjaToken.lost(_ninjaid);
2690           ninjaToken.setPath(_ninjaid, _castleid, _path, steps);
2691           emit AttackEnd(_ninjaid, _castleid, false);
2692 
2693           return true;
2694         }
2695       }
2696       _insertAttackLog(_ninjaid, _castleid, reward, hp, uint8(_path[i]), trapDamage, false);
2697     }
2698     require(goldToken.transfer(ninjaToken.ownerOf(_ninjaid), reward + reward / 2));
2699     require(castleToken.lost(_castleid, _ninjaid));
2700     require(ninjaToken.win(_ninjaid));
2701     ninjaToken.setPath(_ninjaid, _castleid, _path, steps);
2702     emit AttackEnd(_ninjaid, _castleid, true);
2703     return true;
2704   }
2705 
2706   function _computeDamage(uint256 _castleid, uint256 _ninjaid, uint8 _itemid)
2707     internal
2708     view
2709     returns (uint32)
2710   {
2711     uint32 trapPower = itemToken.getPower(castleToken.getTrapid(_castleid, uint8(_itemid)));
2712     if (trapPower <= 0) {
2713       return 0;
2714     }
2715     uint32 trapDamage = trapPower + castleToken.getLevel(_castleid) - 1;
2716     uint8 dna1 = ninjaToken.getDna1(_ninjaid);
2717     uint8 dna2 = ninjaToken.getDna2(_ninjaid);
2718     if (_itemid == 1) {
2719       if (dna1 == 4) {
2720         trapDamage *= 2;
2721       }
2722       if (dna2 == 4) {
2723         trapDamage *= 2;
2724       }
2725       if (dna1 == 3) {
2726         trapDamage /= 2;
2727       }
2728       if (dna2 == 3) {
2729         trapDamage /= 2;
2730       }
2731     } else if (_itemid == 2) {
2732       if (dna1 == 5) {
2733         trapDamage *= 2;
2734       }
2735       if (dna2 == 5) {
2736         trapDamage *= 2;
2737       }
2738       if (dna1 == 4) {
2739         trapDamage /= 2;
2740       }
2741       if (dna2 == 4) {
2742         trapDamage /= 2;
2743       }
2744     } else if (_itemid == 3) {
2745       if (dna1 == 1) {
2746         trapDamage *= 2;
2747       }
2748       if (dna2 == 1) {
2749         trapDamage *= 2;
2750       }
2751       if (dna1 == 5) {
2752         trapDamage /= 2;
2753       }
2754       if (dna2 == 5) {
2755         trapDamage /= 2;
2756       }
2757     } else if (_itemid == 4) {
2758       if (dna1 == 2) {
2759         trapDamage *= 2;
2760       }
2761       if (dna2 == 2) {
2762         trapDamage *= 2;
2763       }
2764       if (dna1 == 1) {
2765         trapDamage /= 2;
2766       }
2767       if (dna2 == 1) {
2768         trapDamage /= 2;
2769       }
2770     } else if (_itemid == 5) {
2771       if (dna1 == 3) {
2772         trapDamage *= 2;
2773       }
2774       if (dna2 == 3) {
2775         trapDamage *= 2;
2776       }
2777       if (dna1 == 2) {
2778         trapDamage /= 2;
2779       }
2780       if (dna2 == 2) {
2781         trapDamage /= 2;
2782       }
2783     }
2784     return trapDamage;
2785   }
2786 
2787   function _insertAttackLog(
2788     uint256 _ninjaid,
2789     uint256 _castleid,
2790     uint16 _reward,
2791     uint32 _hp,
2792     uint8 _path,
2793     uint32 _trapDamage,
2794     bool _dead)
2795     private
2796   {
2797     if(numAttackLogs[_ninjaid] == attackLogs[_ninjaid].length) {
2798       attackLogs[_ninjaid].length += 1;
2799     }
2800     AttackLog memory log = AttackLog(_castleid, _reward, _hp, _path, _trapDamage, _dead);
2801     attackLogs[_ninjaid][numAttackLogs[_ninjaid]++] = log;
2802   }
2803 
2804   function _clearAttackLog(uint256 _ninjaid)
2805     private
2806   {
2807     numAttackLogs[_ninjaid] = 0;
2808   }
2809 
2810   function setGoldContract(address _goldTokenAddress)
2811     public
2812     onlyOwner
2813   {
2814     require(_goldTokenAddress != address(0));
2815 
2816     goldToken = EverGold(_goldTokenAddress);
2817   }
2818 
2819   function setCastleContract(address _castleTokenAddress)
2820     public
2821     onlyOwner
2822   {
2823     require(_castleTokenAddress != address(0));
2824 
2825     castleToken = CastleToken(_castleTokenAddress);
2826   }
2827 
2828   function setNinjaContract(address _ninjaTokenAddress)
2829     public
2830     onlyOwner
2831   {
2832     require(_ninjaTokenAddress != address(0));
2833 
2834     ninjaToken = NinjaToken(_ninjaTokenAddress);
2835   }
2836 
2837   function setItemContract(address _itemTokenAddress)
2838     public
2839     onlyOwner
2840   {
2841     require(_itemTokenAddress != address(0));
2842 
2843     itemToken = ItemToken(_itemTokenAddress);
2844   }
2845 
2846   function setUserContract(address _userTokenAddress)
2847     public
2848     onlyOwner
2849   {
2850     require(_userTokenAddress != address(0));
2851 
2852     userToken = UserToken(_userTokenAddress);
2853   }
2854 
2855   function getLastAttack(uint256 _ninjaid, uint256 _index)
2856     public
2857     view
2858     returns (uint256 castleid, uint16 reward, uint32 hp, uint8 path, uint32 trapDamage, bool dead)
2859   {
2860     require(ninjaToken.ownerOf(_ninjaid) == msg.sender);
2861     AttackLog memory log = attackLogs[_ninjaid][_index];
2862     return (log.castleid, log.reward, log.hp, log.path, log.trapDamage, log.dead);
2863   }
2864 
2865   function getLastAttackCount(uint256 _ninjaid)
2866     public
2867     view
2868     returns (uint256)
2869   {
2870     require(ninjaToken.ownerOf(_ninjaid) == msg.sender);
2871     return numAttackLogs[_ninjaid];
2872   }
2873 }