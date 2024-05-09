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
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: contracts/controller/Reputation.sol
117 
118 /**
119  * @title Reputation system
120  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
121  * A reputation is use to assign influence measure to a DAO'S peers.
122  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
123  * The Reputation contract maintain a map of address to reputation value.
124  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
125  */
126 
127 contract Reputation is Ownable {
128     using SafeMath for uint;
129 
130     mapping (address => uint256) public balances;
131     uint256 public totalSupply;
132     uint public decimals = 18;
133 
134     // Event indicating minting of reputation to an address.
135     event Mint(address indexed _to, uint256 _amount);
136     // Event indicating burning of reputation for an address.
137     event Burn(address indexed _from, uint256 _amount);
138 
139     /**
140     * @dev return the reputation amount of a given owner
141     * @param _owner an address of the owner which we want to get his reputation
142     */
143     function reputationOf(address _owner) public view returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147     /**
148     * @dev Generates `_amount` of reputation that are assigned to `_to`
149     * @param _to The address that will be assigned the new reputation
150     * @param _amount The quantity of reputation to be generated
151     * @return True if the reputation are generated correctly
152     */
153     function mint(address _to, uint _amount)
154     public
155     onlyOwner
156     returns (bool)
157     {
158         totalSupply = totalSupply.add(_amount);
159         balances[_to] = balances[_to].add(_amount);
160         emit Mint(_to, _amount);
161         return true;
162     }
163 
164     /**
165     * @dev Burns `_amount` of reputation from `_from`
166     * if _amount tokens to burn > balances[_from] the balance of _from will turn to zero.
167     * @param _from The address that will lose the reputation
168     * @param _amount The quantity of reputation to burn
169     * @return True if the reputation are burned correctly
170     */
171     function burn(address _from, uint _amount)
172     public
173     onlyOwner
174     returns (bool)
175     {
176         uint amountMinted = _amount;
177         if (balances[_from] < _amount) {
178             amountMinted = balances[_from];
179         }
180         totalSupply = totalSupply.sub(amountMinted);
181         balances[_from] = balances[_from].sub(amountMinted);
182         emit Burn(_from, amountMinted);
183         return true;
184     }
185 }
186 
187 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
188 
189 /**
190  * @title ERC20Basic
191  * @dev Simpler version of ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/179
193  */
194 contract ERC20Basic {
195   function totalSupply() public view returns (uint256);
196   function balanceOf(address who) public view returns (uint256);
197   function transfer(address to, uint256 value) public returns (bool);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199 }
200 
201 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
202 
203 /**
204  * @title Basic token
205  * @dev Basic version of StandardToken, with no allowances.
206  */
207 contract BasicToken is ERC20Basic {
208   using SafeMath for uint256;
209 
210   mapping(address => uint256) balances;
211 
212   uint256 totalSupply_;
213 
214   /**
215   * @dev total number of tokens in existence
216   */
217   function totalSupply() public view returns (uint256) {
218     return totalSupply_;
219   }
220 
221   /**
222   * @dev transfer token for a specified address
223   * @param _to The address to transfer to.
224   * @param _value The amount to be transferred.
225   */
226   function transfer(address _to, uint256 _value) public returns (bool) {
227     require(_to != address(0));
228     require(_value <= balances[msg.sender]);
229 
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param _owner The address to query the the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address _owner) public view returns (uint256) {
242     return balances[_owner];
243   }
244 
245 }
246 
247 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
248 
249 /**
250  * @title ERC20 interface
251  * @dev see https://github.com/ethereum/EIPs/issues/20
252  */
253 contract ERC20 is ERC20Basic {
254   function allowance(address owner, address spender)
255     public view returns (uint256);
256 
257   function transferFrom(address from, address to, uint256 value)
258     public returns (bool);
259 
260   function approve(address spender, uint256 value) public returns (bool);
261   event Approval(
262     address indexed owner,
263     address indexed spender,
264     uint256 value
265   );
266 }
267 
268 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
269 
270 /**
271  * @title Standard ERC20 token
272  *
273  * @dev Implementation of the basic standard token.
274  * @dev https://github.com/ethereum/EIPs/issues/20
275  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
276  */
277 contract StandardToken is ERC20, BasicToken {
278 
279   mapping (address => mapping (address => uint256)) internal allowed;
280 
281 
282   /**
283    * @dev Transfer tokens from one address to another
284    * @param _from address The address which you want to send tokens from
285    * @param _to address The address which you want to transfer to
286    * @param _value uint256 the amount of tokens to be transferred
287    */
288   function transferFrom(
289     address _from,
290     address _to,
291     uint256 _value
292   )
293     public
294     returns (bool)
295   {
296     require(_to != address(0));
297     require(_value <= balances[_from]);
298     require(_value <= allowed[_from][msg.sender]);
299 
300     balances[_from] = balances[_from].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
303     emit Transfer(_from, _to, _value);
304     return true;
305   }
306 
307   /**
308    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
309    *
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     emit Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(
330     address _owner,
331     address _spender
332    )
333     public
334     view
335     returns (uint256)
336   {
337     return allowed[_owner][_spender];
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    *
343    * approve should be called when allowed[_spender] == 0. To increment
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _addedValue The amount of tokens to increase the allowance by.
349    */
350   function increaseApproval(
351     address _spender,
352     uint _addedValue
353   )
354     public
355     returns (bool)
356   {
357     allowed[msg.sender][_spender] = (
358       allowed[msg.sender][_spender].add(_addedValue));
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363   /**
364    * @dev Decrease the amount of tokens that an owner allowed to a spender.
365    *
366    * approve should be called when allowed[_spender] == 0. To decrement
367    * allowed value is better to use this function to avoid 2 calls (and wait until
368    * the first transaction is mined)
369    * From MonolithDAO Token.sol
370    * @param _spender The address which will spend the funds.
371    * @param _subtractedValue The amount of tokens to decrease the allowance by.
372    */
373   function decreaseApproval(
374     address _spender,
375     uint _subtractedValue
376   )
377     public
378     returns (bool)
379   {
380     uint oldValue = allowed[msg.sender][_spender];
381     if (_subtractedValue > oldValue) {
382       allowed[msg.sender][_spender] = 0;
383     } else {
384       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
385     }
386     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
387     return true;
388   }
389 
390 }
391 
392 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
393 
394 /**
395  * @title Mintable token
396  * @dev Simple ERC20 Token example, with mintable token creation
397  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
398  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
399  */
400 contract MintableToken is StandardToken, Ownable {
401   event Mint(address indexed to, uint256 amount);
402   event MintFinished();
403 
404   bool public mintingFinished = false;
405 
406 
407   modifier canMint() {
408     require(!mintingFinished);
409     _;
410   }
411 
412   modifier hasMintPermission() {
413     require(msg.sender == owner);
414     _;
415   }
416 
417   /**
418    * @dev Function to mint tokens
419    * @param _to The address that will receive the minted tokens.
420    * @param _amount The amount of tokens to mint.
421    * @return A boolean that indicates if the operation was successful.
422    */
423   function mint(
424     address _to,
425     uint256 _amount
426   )
427     hasMintPermission
428     canMint
429     public
430     returns (bool)
431   {
432     totalSupply_ = totalSupply_.add(_amount);
433     balances[_to] = balances[_to].add(_amount);
434     emit Mint(_to, _amount);
435     emit Transfer(address(0), _to, _amount);
436     return true;
437   }
438 
439   /**
440    * @dev Function to stop minting new tokens.
441    * @return True if the operation was successful.
442    */
443   function finishMinting() onlyOwner canMint public returns (bool) {
444     mintingFinished = true;
445     emit MintFinished();
446     return true;
447   }
448 }
449 
450 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
451 
452 /**
453  * @title Burnable Token
454  * @dev Token that can be irreversibly burned (destroyed).
455  */
456 contract BurnableToken is BasicToken {
457 
458   event Burn(address indexed burner, uint256 value);
459 
460   /**
461    * @dev Burns a specific amount of tokens.
462    * @param _value The amount of token to be burned.
463    */
464   function burn(uint256 _value) public {
465     _burn(msg.sender, _value);
466   }
467 
468   function _burn(address _who, uint256 _value) internal {
469     require(_value <= balances[_who]);
470     // no need to require value <= totalSupply, since that would imply the
471     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
472 
473     balances[_who] = balances[_who].sub(_value);
474     totalSupply_ = totalSupply_.sub(_value);
475     emit Burn(_who, _value);
476     emit Transfer(_who, address(0), _value);
477   }
478 }
479 
480 // File: openzeppelin-solidity/contracts/token/ERC827/ERC827.sol
481 
482 /**
483  * @title ERC827 interface, an extension of ERC20 token standard
484  *
485  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
486  * @dev methods to transfer value and data and execute calls in transfers and
487  * @dev approvals.
488  */
489 contract ERC827 is ERC20 {
490   function approveAndCall(
491     address _spender,
492     uint256 _value,
493     bytes _data
494   )
495     public
496     payable
497     returns (bool);
498 
499   function transferAndCall(
500     address _to,
501     uint256 _value,
502     bytes _data
503   )
504     public
505     payable
506     returns (bool);
507 
508   function transferFromAndCall(
509     address _from,
510     address _to,
511     uint256 _value,
512     bytes _data
513   )
514     public
515     payable
516     returns (bool);
517 }
518 
519 // File: openzeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
520 
521 /* solium-disable security/no-low-level-calls */
522 
523 pragma solidity ^0.4.23;
524 
525 
526 
527 
528 /**
529  * @title ERC827, an extension of ERC20 token standard
530  *
531  * @dev Implementation the ERC827, following the ERC20 standard with extra
532  * @dev methods to transfer value and data and execute calls in transfers and
533  * @dev approvals.
534  *
535  * @dev Uses OpenZeppelin StandardToken.
536  */
537 contract ERC827Token is ERC827, StandardToken {
538 
539   /**
540    * @dev Addition to ERC20 token methods. It allows to
541    * @dev approve the transfer of value and execute a call with the sent data.
542    *
543    * @dev Beware that changing an allowance with this method brings the risk that
544    * @dev someone may use both the old and the new allowance by unfortunate
545    * @dev transaction ordering. One possible solution to mitigate this race condition
546    * @dev is to first reduce the spender's allowance to 0 and set the desired value
547    * @dev afterwards:
548    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
549    *
550    * @param _spender The address that will spend the funds.
551    * @param _value The amount of tokens to be spent.
552    * @param _data ABI-encoded contract call to call `_to` address.
553    *
554    * @return true if the call function was executed successfully
555    */
556   function approveAndCall(
557     address _spender,
558     uint256 _value,
559     bytes _data
560   )
561     public
562     payable
563     returns (bool)
564   {
565     require(_spender != address(this));
566 
567     super.approve(_spender, _value);
568 
569     // solium-disable-next-line security/no-call-value
570     require(_spender.call.value(msg.value)(_data));
571 
572     return true;
573   }
574 
575   /**
576    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
577    * @dev address and execute a call with the sent data on the same transaction
578    *
579    * @param _to address The address which you want to transfer to
580    * @param _value uint256 the amout of tokens to be transfered
581    * @param _data ABI-encoded contract call to call `_to` address.
582    *
583    * @return true if the call function was executed successfully
584    */
585   function transferAndCall(
586     address _to,
587     uint256 _value,
588     bytes _data
589   )
590     public
591     payable
592     returns (bool)
593   {
594     require(_to != address(this));
595 
596     super.transfer(_to, _value);
597 
598     // solium-disable-next-line security/no-call-value
599     require(_to.call.value(msg.value)(_data));
600     return true;
601   }
602 
603   /**
604    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
605    * @dev another and make a contract call on the same transaction
606    *
607    * @param _from The address which you want to send tokens from
608    * @param _to The address which you want to transfer to
609    * @param _value The amout of tokens to be transferred
610    * @param _data ABI-encoded contract call to call `_to` address.
611    *
612    * @return true if the call function was executed successfully
613    */
614   function transferFromAndCall(
615     address _from,
616     address _to,
617     uint256 _value,
618     bytes _data
619   )
620     public payable returns (bool)
621   {
622     require(_to != address(this));
623 
624     super.transferFrom(_from, _to, _value);
625 
626     // solium-disable-next-line security/no-call-value
627     require(_to.call.value(msg.value)(_data));
628     return true;
629   }
630 
631   /**
632    * @dev Addition to StandardToken methods. Increase the amount of tokens that
633    * @dev an owner allowed to a spender and execute a call with the sent data.
634    *
635    * @dev approve should be called when allowed[_spender] == 0. To increment
636    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
637    * @dev the first transaction is mined)
638    * @dev From MonolithDAO Token.sol
639    *
640    * @param _spender The address which will spend the funds.
641    * @param _addedValue The amount of tokens to increase the allowance by.
642    * @param _data ABI-encoded contract call to call `_spender` address.
643    */
644   function increaseApprovalAndCall(
645     address _spender,
646     uint _addedValue,
647     bytes _data
648   )
649     public
650     payable
651     returns (bool)
652   {
653     require(_spender != address(this));
654 
655     super.increaseApproval(_spender, _addedValue);
656 
657     // solium-disable-next-line security/no-call-value
658     require(_spender.call.value(msg.value)(_data));
659 
660     return true;
661   }
662 
663   /**
664    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
665    * @dev an owner allowed to a spender and execute a call with the sent data.
666    *
667    * @dev approve should be called when allowed[_spender] == 0. To decrement
668    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
669    * @dev the first transaction is mined)
670    * @dev From MonolithDAO Token.sol
671    *
672    * @param _spender The address which will spend the funds.
673    * @param _subtractedValue The amount of tokens to decrease the allowance by.
674    * @param _data ABI-encoded contract call to call `_spender` address.
675    */
676   function decreaseApprovalAndCall(
677     address _spender,
678     uint _subtractedValue,
679     bytes _data
680   )
681     public
682     payable
683     returns (bool)
684   {
685     require(_spender != address(this));
686 
687     super.decreaseApproval(_spender, _subtractedValue);
688 
689     // solium-disable-next-line security/no-call-value
690     require(_spender.call.value(msg.value)(_data));
691 
692     return true;
693   }
694 
695 }
696 
697 // File: contracts/controller/DAOToken.sol
698 
699 /**
700  * @title DAOToken, base on zeppelin contract.
701  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
702  */
703 
704 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
705 
706     string public name;
707     string public symbol;
708     // solium-disable-next-line uppercase
709     uint8 public constant decimals = 18;
710     uint public cap;
711 
712     /**
713     * @dev Constructor
714     * @param _name - token name
715     * @param _symbol - token symbol
716     * @param _cap - token cap - 0 value means no cap
717     */
718     constructor(string _name, string _symbol,uint _cap) public {
719         name = _name;
720         symbol = _symbol;
721         cap = _cap;
722     }
723 
724     /**
725      * @dev Function to mint tokens
726      * @param _to The address that will receive the minted tokens.
727      * @param _amount The amount of tokens to mint.
728      * @return A boolean that indicates if the operation was successful.
729      */
730     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
731         if (cap > 0)
732             require(totalSupply_.add(_amount) <= cap);
733         return super.mint(_to, _amount);
734     }
735 }
736 
737 // File: contracts/controller/Avatar.sol
738 
739 /**
740  * @title An Avatar holds tokens, reputation and ether for a controller
741  */
742 contract Avatar is Ownable {
743     bytes32 public orgName;
744     DAOToken public nativeToken;
745     Reputation public nativeReputation;
746 
747     event GenericAction(address indexed _action, bytes32[] _params);
748     event SendEther(uint _amountInWei, address indexed _to);
749     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
750     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
751     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
752     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
753     event ReceiveEther(address indexed _sender, uint _value);
754 
755     /**
756     * @dev the constructor takes organization name, native token and reputation system
757     and creates an avatar for a controller
758     */
759     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
760         orgName = _orgName;
761         nativeToken = _nativeToken;
762         nativeReputation = _nativeReputation;
763     }
764 
765     /**
766     * @dev enables an avatar to receive ethers
767     */
768     function() public payable {
769         emit ReceiveEther(msg.sender, msg.value);
770     }
771 
772     /**
773     * @dev perform a generic call to an arbitrary contract
774     * @param _contract  the contract's address to call
775     * @param _data ABI-encoded contract call to call `_contract` address.
776     * @return the return bytes of the called contract's function.
777     */
778     function genericCall(address _contract,bytes _data) public onlyOwner {
779         // solium-disable-next-line security/no-low-level-calls
780         bool result = _contract.call(_data);
781         // solium-disable-next-line security/no-inline-assembly
782         assembly {
783         // Copy the returned data.
784         returndatacopy(0, 0, returndatasize)
785 
786         switch result
787         // call returns 0 on error.
788         case 0 { revert(0, returndatasize) }
789         default { return(0, returndatasize) }
790         }
791     }
792 
793     /**
794     * @dev send ethers from the avatar's wallet
795     * @param _amountInWei amount to send in Wei units
796     * @param _to send the ethers to this address
797     * @return bool which represents success
798     */
799     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
800         _to.transfer(_amountInWei);
801         emit SendEther(_amountInWei, _to);
802         return true;
803     }
804 
805     /**
806     * @dev external token transfer
807     * @param _externalToken the token contract
808     * @param _to the destination address
809     * @param _value the amount of tokens to transfer
810     * @return bool which represents success
811     */
812     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
813     public onlyOwner returns(bool)
814     {
815         _externalToken.transfer(_to, _value);
816         emit ExternalTokenTransfer(_externalToken, _to, _value);
817         return true;
818     }
819 
820     /**
821     * @dev external token transfer from a specific account
822     * @param _externalToken the token contract
823     * @param _from the account to spend token from
824     * @param _to the destination address
825     * @param _value the amount of tokens to transfer
826     * @return bool which represents success
827     */
828     function externalTokenTransferFrom(
829         StandardToken _externalToken,
830         address _from,
831         address _to,
832         uint _value
833     )
834     public onlyOwner returns(bool)
835     {
836         _externalToken.transferFrom(_from, _to, _value);
837         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
838         return true;
839     }
840 
841     /**
842     * @dev increase approval for the spender address to spend a specified amount of tokens
843     *      on behalf of msg.sender.
844     * @param _externalToken the address of the Token Contract
845     * @param _spender address
846     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
847     * @return bool which represents a success
848     */
849     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
850     public onlyOwner returns(bool)
851     {
852         _externalToken.increaseApproval(_spender, _addedValue);
853         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
854         return true;
855     }
856 
857     /**
858     * @dev decrease approval for the spender address to spend a specified amount of tokens
859     *      on behalf of msg.sender.
860     * @param _externalToken the address of the Token Contract
861     * @param _spender address
862     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
863     * @return bool which represents a success
864     */
865     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
866     public onlyOwner returns(bool)
867     {
868         _externalToken.decreaseApproval(_spender, _subtractedValue);
869         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
870         return true;
871     }
872 
873 }
874 
875 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
876 
877 contract GlobalConstraintInterface {
878 
879     enum CallPhase { Pre, Post,PreAndPost }
880 
881     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
882     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
883     /**
884      * @dev when return if this globalConstraints is pre, post or both.
885      * @return CallPhase enum indication  Pre, Post or PreAndPost.
886      */
887     function when() public returns(CallPhase);
888 }
889 
890 // File: contracts/controller/ControllerInterface.sol
891 
892 /**
893  * @title Controller contract
894  * @dev A controller controls the organizations tokens ,reputation and avatar.
895  * It is subject to a set of schemes and constraints that determine its behavior.
896  * Each scheme has it own parameters and operation permissions.
897  */
898 interface ControllerInterface {
899 
900     /**
901      * @dev Mint `_amount` of reputation that are assigned to `_to` .
902      * @param  _amount amount of reputation to mint
903      * @param _to beneficiary address
904      * @return bool which represents a success
905     */
906     function mintReputation(uint256 _amount, address _to,address _avatar)
907     external
908     returns(bool);
909 
910     /**
911      * @dev Burns `_amount` of reputation from `_from`
912      * @param _amount amount of reputation to burn
913      * @param _from The address that will lose the reputation
914      * @return bool which represents a success
915      */
916     function burnReputation(uint256 _amount, address _from,address _avatar)
917     external
918     returns(bool);
919 
920     /**
921      * @dev mint tokens .
922      * @param  _amount amount of token to mint
923      * @param _beneficiary beneficiary address
924      * @param _avatar address
925      * @return bool which represents a success
926      */
927     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
928     external
929     returns(bool);
930 
931   /**
932    * @dev register or update a scheme
933    * @param _scheme the address of the scheme
934    * @param _paramsHash a hashed configuration of the usage of the scheme
935    * @param _permissions the permissions the new scheme will have
936    * @param _avatar address
937    * @return bool which represents a success
938    */
939     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
940     external
941     returns(bool);
942 
943     /**
944      * @dev unregister a scheme
945      * @param _avatar address
946      * @param _scheme the address of the scheme
947      * @return bool which represents a success
948      */
949     function unregisterScheme(address _scheme,address _avatar)
950     external
951     returns(bool);
952     /**
953      * @dev unregister the caller's scheme
954      * @param _avatar address
955      * @return bool which represents a success
956      */
957     function unregisterSelf(address _avatar) external returns(bool);
958 
959     function isSchemeRegistered( address _scheme,address _avatar) external view returns(bool);
960 
961     function getSchemeParameters(address _scheme,address _avatar) external view returns(bytes32);
962 
963     function getGlobalConstraintParameters(address _globalConstraint,address _avatar) external view returns(bytes32);
964 
965     function getSchemePermissions(address _scheme,address _avatar) external view returns(bytes4);
966 
967     /**
968      * @dev globalConstraintsCount return the global constraint pre and post count
969      * @return uint globalConstraintsPre count.
970      * @return uint globalConstraintsPost count.
971      */
972     function globalConstraintsCount(address _avatar) external view returns(uint,uint);
973 
974     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar) external view returns(bool);
975 
976     /**
977      * @dev add or update Global Constraint
978      * @param _globalConstraint the address of the global constraint to be added.
979      * @param _params the constraint parameters hash.
980      * @param _avatar the avatar of the organization
981      * @return bool which represents a success
982      */
983     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
984     external returns(bool);
985 
986     /**
987      * @dev remove Global Constraint
988      * @param _globalConstraint the address of the global constraint to be remove.
989      * @param _avatar the organization avatar.
990      * @return bool which represents a success
991      */
992     function removeGlobalConstraint (address _globalConstraint,address _avatar)
993     external  returns(bool);
994 
995   /**
996     * @dev upgrade the Controller
997     *      The function will trigger an event 'UpgradeController'.
998     * @param  _newController the address of the new controller.
999     * @param _avatar address
1000     * @return bool which represents a success
1001     */
1002     function upgradeController(address _newController,address _avatar)
1003     external returns(bool);
1004 
1005     /**
1006     * @dev perform a generic call to an arbitrary contract
1007     * @param _contract  the contract's address to call
1008     * @param _data ABI-encoded contract call to call `_contract` address.
1009     * @param _avatar the controller's avatar address
1010     * @return bytes32  - the return value of the called _contract's function.
1011     */
1012     function genericCall(address _contract,bytes _data,address _avatar)
1013     external
1014     returns(bytes32);
1015 
1016   /**
1017    * @dev send some ether
1018    * @param _amountInWei the amount of ether (in Wei) to send
1019    * @param _to address of the beneficiary
1020    * @param _avatar address
1021    * @return bool which represents a success
1022    */
1023     function sendEther(uint _amountInWei, address _to,address _avatar)
1024     external returns(bool);
1025 
1026     /**
1027     * @dev send some amount of arbitrary ERC20 Tokens
1028     * @param _externalToken the address of the Token Contract
1029     * @param _to address of the beneficiary
1030     * @param _value the amount of ether (in Wei) to send
1031     * @param _avatar address
1032     * @return bool which represents a success
1033     */
1034     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1035     external
1036     returns(bool);
1037 
1038     /**
1039     * @dev transfer token "from" address "to" address
1040     *      One must to approve the amount of tokens which can be spend from the
1041     *      "from" account.This can be done using externalTokenApprove.
1042     * @param _externalToken the address of the Token Contract
1043     * @param _from address of the account to send from
1044     * @param _to address of the beneficiary
1045     * @param _value the amount of ether (in Wei) to send
1046     * @param _avatar address
1047     * @return bool which represents a success
1048     */
1049     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1050     external
1051     returns(bool);
1052 
1053     /**
1054     * @dev increase approval for the spender address to spend a specified amount of tokens
1055     *      on behalf of msg.sender.
1056     * @param _externalToken the address of the Token Contract
1057     * @param _spender address
1058     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1059     * @param _avatar address
1060     * @return bool which represents a success
1061     */
1062     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1063     external
1064     returns(bool);
1065 
1066     /**
1067     * @dev decrease approval for the spender address to spend a specified amount of tokens
1068     *      on behalf of msg.sender.
1069     * @param _externalToken the address of the Token Contract
1070     * @param _spender address
1071     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1072     * @param _avatar address
1073     * @return bool which represents a success
1074     */
1075     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1076     external
1077     returns(bool);
1078 
1079     /**
1080      * @dev getNativeReputation
1081      * @param _avatar the organization avatar.
1082      * @return organization native reputation
1083      */
1084     function getNativeReputation(address _avatar)
1085     external
1086     view
1087     returns(address);
1088 }
1089 
1090 // File: contracts/controller/Controller.sol
1091 
1092 /**
1093  * @title Controller contract
1094  * @dev A controller controls the organizations tokens,reputation and avatar.
1095  * It is subject to a set of schemes and constraints that determine its behavior.
1096  * Each scheme has it own parameters and operation permissions.
1097  */
1098 contract Controller is ControllerInterface {
1099 
1100     struct Scheme {
1101         bytes32 paramsHash;  // a hash "configuration" of the scheme
1102         bytes4  permissions; // A bitwise flags of permissions,
1103                              // All 0: Not registered,
1104                              // 1st bit: Flag if the scheme is registered,
1105                              // 2nd bit: Scheme can register other schemes
1106                              // 3rd bit: Scheme can add/remove global constraints
1107                              // 4th bit: Scheme can upgrade the controller
1108                              // 5th bit: Scheme can call genericCall on behalf of
1109                              //          the organization avatar
1110     }
1111 
1112     struct GlobalConstraint {
1113         address gcAddress;
1114         bytes32 params;
1115     }
1116 
1117     struct GlobalConstraintRegister {
1118         bool isRegistered; //is registered
1119         uint index;    //index at globalConstraints
1120     }
1121 
1122     mapping(address=>Scheme) public schemes;
1123 
1124     Avatar public avatar;
1125     DAOToken public nativeToken;
1126     Reputation public nativeReputation;
1127   // newController will point to the new controller after the present controller is upgraded
1128     address public newController;
1129   // globalConstraintsPre that determine pre conditions for all actions on the controller
1130 
1131     GlobalConstraint[] public globalConstraintsPre;
1132   // globalConstraintsPost that determine post conditions for all actions on the controller
1133     GlobalConstraint[] public globalConstraintsPost;
1134   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1135     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1136   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1137     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1138 
1139     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1140     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1141     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1142     event RegisterScheme (address indexed _sender, address indexed _scheme);
1143     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1144     event GenericAction (address indexed _sender, bytes32[] _params);
1145     event SendEther (address indexed _sender, uint _amountInWei, address indexed _to);
1146     event ExternalTokenTransfer (address indexed _sender, address indexed _externalToken, address indexed _to, uint _value);
1147     event ExternalTokenTransferFrom (address indexed _sender, address indexed _externalToken, address _from, address _to, uint _value);
1148     event ExternalTokenIncreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1149     event ExternalTokenDecreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1150     event UpgradeController(address indexed _oldController,address _newController);
1151     event AddGlobalConstraint(address indexed _globalConstraint, bytes32 _params,GlobalConstraintInterface.CallPhase _when);
1152     event RemoveGlobalConstraint(address indexed _globalConstraint ,uint256 _index,bool _isPre);
1153     event GenericCall(address indexed _contract,bytes _data);
1154 
1155     constructor( Avatar _avatar) public
1156     {
1157         avatar = _avatar;
1158         nativeToken = avatar.nativeToken();
1159         nativeReputation = avatar.nativeReputation();
1160         schemes[msg.sender] = Scheme({paramsHash: bytes32(0),permissions: bytes4(0x1F)});
1161     }
1162 
1163   // Do not allow mistaken calls:
1164     function() external {
1165         revert();
1166     }
1167 
1168   // Modifiers:
1169     modifier onlyRegisteredScheme() {
1170         require(schemes[msg.sender].permissions&bytes4(1) == bytes4(1));
1171         _;
1172     }
1173 
1174     modifier onlyRegisteringSchemes() {
1175         require(schemes[msg.sender].permissions&bytes4(2) == bytes4(2));
1176         _;
1177     }
1178 
1179     modifier onlyGlobalConstraintsScheme() {
1180         require(schemes[msg.sender].permissions&bytes4(4) == bytes4(4));
1181         _;
1182     }
1183 
1184     modifier onlyUpgradingScheme() {
1185         require(schemes[msg.sender].permissions&bytes4(8) == bytes4(8));
1186         _;
1187     }
1188 
1189     modifier onlyGenericCallScheme() {
1190         require(schemes[msg.sender].permissions&bytes4(16) == bytes4(16));
1191         _;
1192     }
1193 
1194     modifier onlySubjectToConstraint(bytes32 func) {
1195         uint idx;
1196         for (idx = 0;idx<globalConstraintsPre.length;idx++) {
1197             require((GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress)).pre(msg.sender,globalConstraintsPre[idx].params,func));
1198         }
1199         _;
1200         for (idx = 0;idx<globalConstraintsPost.length;idx++) {
1201             require((GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress)).post(msg.sender,globalConstraintsPost[idx].params,func));
1202         }
1203     }
1204 
1205     modifier isAvatarValid(address _avatar) {
1206         require(_avatar == address(avatar));
1207         _;
1208     }
1209 
1210     /**
1211      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1212      * @param  _amount amount of reputation to mint
1213      * @param _to beneficiary address
1214      * @return bool which represents a success
1215      */
1216     function mintReputation(uint256 _amount, address _to,address _avatar)
1217     external
1218     onlyRegisteredScheme
1219     onlySubjectToConstraint("mintReputation")
1220     isAvatarValid(_avatar)
1221     returns(bool)
1222     {
1223         emit MintReputation(msg.sender, _to, _amount);
1224         return nativeReputation.mint(_to, _amount);
1225     }
1226 
1227     /**
1228      * @dev Burns `_amount` of reputation from `_from`
1229      * @param _amount amount of reputation to burn
1230      * @param _from The address that will lose the reputation
1231      * @return bool which represents a success
1232      */
1233     function burnReputation(uint256 _amount, address _from,address _avatar)
1234     external
1235     onlyRegisteredScheme
1236     onlySubjectToConstraint("burnReputation")
1237     isAvatarValid(_avatar)
1238     returns(bool)
1239     {
1240         emit BurnReputation(msg.sender, _from, _amount);
1241         return nativeReputation.burn(_from, _amount);
1242     }
1243 
1244     /**
1245      * @dev mint tokens .
1246      * @param  _amount amount of token to mint
1247      * @param _beneficiary beneficiary address
1248      * @return bool which represents a success
1249      */
1250     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
1251     external
1252     onlyRegisteredScheme
1253     onlySubjectToConstraint("mintTokens")
1254     isAvatarValid(_avatar)
1255     returns(bool)
1256     {
1257         emit MintTokens(msg.sender, _beneficiary, _amount);
1258         return nativeToken.mint(_beneficiary, _amount);
1259     }
1260 
1261   /**
1262    * @dev register a scheme
1263    * @param _scheme the address of the scheme
1264    * @param _paramsHash a hashed configuration of the usage of the scheme
1265    * @param _permissions the permissions the new scheme will have
1266    * @return bool which represents a success
1267    */
1268     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
1269     external
1270     onlyRegisteringSchemes
1271     onlySubjectToConstraint("registerScheme")
1272     isAvatarValid(_avatar)
1273     returns(bool)
1274     {
1275 
1276         Scheme memory scheme = schemes[_scheme];
1277 
1278     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1279     // Implementation is a bit messy. One must recall logic-circuits ^^
1280 
1281     // produces non-zero if sender does not have all of the perms that are changing between old and new
1282         require(bytes4(0x1F)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1283 
1284     // produces non-zero if sender does not have all of the perms in the old scheme
1285         require(bytes4(0x1F)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1286 
1287     // Add or change the scheme:
1288         schemes[_scheme].paramsHash = _paramsHash;
1289         schemes[_scheme].permissions = _permissions|bytes4(1);
1290         emit RegisterScheme(msg.sender, _scheme);
1291         return true;
1292     }
1293 
1294     /**
1295      * @dev unregister a scheme
1296      * @param _scheme the address of the scheme
1297      * @return bool which represents a success
1298      */
1299     function unregisterScheme( address _scheme,address _avatar)
1300     external
1301     onlyRegisteringSchemes
1302     onlySubjectToConstraint("unregisterScheme")
1303     isAvatarValid(_avatar)
1304     returns(bool)
1305     {
1306     //check if the scheme is registered
1307         if (schemes[_scheme].permissions&bytes4(1) == bytes4(0)) {
1308             return false;
1309           }
1310     // Check the unregistering scheme has enough permissions:
1311         require(bytes4(0x1F)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1312 
1313     // Unregister:
1314         emit UnregisterScheme(msg.sender, _scheme);
1315         delete schemes[_scheme];
1316         return true;
1317     }
1318 
1319     /**
1320      * @dev unregister the caller's scheme
1321      * @return bool which represents a success
1322      */
1323     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1324         if (_isSchemeRegistered(msg.sender,_avatar) == false) {
1325             return false;
1326         }
1327         delete schemes[msg.sender];
1328         emit UnregisterScheme(msg.sender, msg.sender);
1329         return true;
1330     }
1331 
1332     function isSchemeRegistered(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bool) {
1333         return _isSchemeRegistered(_scheme,_avatar);
1334     }
1335 
1336     function getSchemeParameters(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes32) {
1337         return schemes[_scheme].paramsHash;
1338     }
1339 
1340     function getSchemePermissions(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes4) {
1341         return schemes[_scheme].permissions;
1342     }
1343 
1344     function getGlobalConstraintParameters(address _globalConstraint,address) external view returns(bytes32) {
1345 
1346         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
1347 
1348         if (register.isRegistered) {
1349             return globalConstraintsPre[register.index].params;
1350         }
1351 
1352         register = globalConstraintsRegisterPost[_globalConstraint];
1353 
1354         if (register.isRegistered) {
1355             return globalConstraintsPost[register.index].params;
1356         }
1357     }
1358 
1359    /**
1360     * @dev globalConstraintsCount return the global constraint pre and post count
1361     * @return uint globalConstraintsPre count.
1362     * @return uint globalConstraintsPost count.
1363     */
1364     function globalConstraintsCount(address _avatar)
1365         external
1366         isAvatarValid(_avatar)
1367         view
1368         returns(uint,uint)
1369         {
1370         return (globalConstraintsPre.length,globalConstraintsPost.length);
1371     }
1372 
1373     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar)
1374         external
1375         isAvatarValid(_avatar)
1376         view
1377         returns(bool)
1378         {
1379         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered || globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1380     }
1381 
1382     /**
1383      * @dev add or update Global Constraint
1384      * @param _globalConstraint the address of the global constraint to be added.
1385      * @param _params the constraint parameters hash.
1386      * @return bool which represents a success
1387      */
1388     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
1389     external
1390     onlyGlobalConstraintsScheme
1391     isAvatarValid(_avatar)
1392     returns(bool)
1393     {
1394         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1395         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1396             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1397                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint,_params));
1398                 globalConstraintsRegisterPre[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPre.length-1);
1399             }else {
1400                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1401             }
1402         }
1403         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1404             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1405                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint,_params));
1406                 globalConstraintsRegisterPost[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPost.length-1);
1407             }else {
1408                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1409             }
1410         }
1411         emit AddGlobalConstraint(_globalConstraint, _params,when);
1412         return true;
1413     }
1414 
1415     /**
1416      * @dev remove Global Constraint
1417      * @param _globalConstraint the address of the global constraint to be remove.
1418      * @return bool which represents a success
1419      */
1420     function removeGlobalConstraint (address _globalConstraint,address _avatar)
1421     external
1422     onlyGlobalConstraintsScheme
1423     isAvatarValid(_avatar)
1424     returns(bool)
1425     {
1426         GlobalConstraintRegister memory globalConstraintRegister;
1427         GlobalConstraint memory globalConstraint;
1428         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1429         bool retVal = false;
1430 
1431         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1432             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
1433             if (globalConstraintRegister.isRegistered) {
1434                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
1435                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
1436                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
1437                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1438                 }
1439                 globalConstraintsPre.length--;
1440                 delete globalConstraintsRegisterPre[_globalConstraint];
1441                 retVal = true;
1442             }
1443         }
1444         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1445             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
1446             if (globalConstraintRegister.isRegistered) {
1447                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
1448                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
1449                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
1450                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1451                 }
1452                 globalConstraintsPost.length--;
1453                 delete globalConstraintsRegisterPost[_globalConstraint];
1454                 retVal = true;
1455             }
1456         }
1457         if (retVal) {
1458             emit RemoveGlobalConstraint(_globalConstraint,globalConstraintRegister.index,when == GlobalConstraintInterface.CallPhase.Pre);
1459         }
1460         return retVal;
1461     }
1462 
1463   /**
1464     * @dev upgrade the Controller
1465     *      The function will trigger an event 'UpgradeController'.
1466     * @param  _newController the address of the new controller.
1467     * @return bool which represents a success
1468     */
1469     function upgradeController(address _newController,address _avatar)
1470     external
1471     onlyUpgradingScheme
1472     isAvatarValid(_avatar)
1473     returns(bool)
1474     {
1475         require(newController == address(0));   // so the upgrade could be done once for a contract.
1476         require(_newController != address(0));
1477         newController = _newController;
1478         avatar.transferOwnership(_newController);
1479         require(avatar.owner()==_newController);
1480         if (nativeToken.owner() == address(this)) {
1481             nativeToken.transferOwnership(_newController);
1482             require(nativeToken.owner()==_newController);
1483         }
1484         if (nativeReputation.owner() == address(this)) {
1485             nativeReputation.transferOwnership(_newController);
1486             require(nativeReputation.owner()==_newController);
1487         }
1488         emit UpgradeController(this,newController);
1489         return true;
1490     }
1491 
1492     /**
1493     * @dev perform a generic call to an arbitrary contract
1494     * @param _contract  the contract's address to call
1495     * @param _data ABI-encoded contract call to call `_contract` address.
1496     * @param _avatar the controller's avatar address
1497     * @return bytes32  - the return value of the called _contract's function.
1498     */
1499     function genericCall(address _contract,bytes _data,address _avatar)
1500     external
1501     onlyGenericCallScheme
1502     onlySubjectToConstraint("genericCall")
1503     isAvatarValid(_avatar)
1504     returns (bytes32)
1505     {
1506         emit GenericCall(_contract, _data);
1507         avatar.genericCall(_contract, _data);
1508         // solium-disable-next-line security/no-inline-assembly
1509         assembly {
1510         // Copy the returned data.
1511         returndatacopy(0, 0, returndatasize)
1512         return(0, returndatasize)
1513         }
1514     }
1515 
1516   /**
1517    * @dev send some ether
1518    * @param _amountInWei the amount of ether (in Wei) to send
1519    * @param _to address of the beneficiary
1520    * @return bool which represents a success
1521    */
1522     function sendEther(uint _amountInWei, address _to,address _avatar)
1523     external
1524     onlyRegisteredScheme
1525     onlySubjectToConstraint("sendEther")
1526     isAvatarValid(_avatar)
1527     returns(bool)
1528     {
1529         emit SendEther(msg.sender, _amountInWei, _to);
1530         return avatar.sendEther(_amountInWei, _to);
1531     }
1532 
1533     /**
1534     * @dev send some amount of arbitrary ERC20 Tokens
1535     * @param _externalToken the address of the Token Contract
1536     * @param _to address of the beneficiary
1537     * @param _value the amount of ether (in Wei) to send
1538     * @return bool which represents a success
1539     */
1540     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1541     external
1542     onlyRegisteredScheme
1543     onlySubjectToConstraint("externalTokenTransfer")
1544     isAvatarValid(_avatar)
1545     returns(bool)
1546     {
1547         emit ExternalTokenTransfer(msg.sender, _externalToken, _to, _value);
1548         return avatar.externalTokenTransfer(_externalToken, _to, _value);
1549     }
1550 
1551     /**
1552     * @dev transfer token "from" address "to" address
1553     *      One must to approve the amount of tokens which can be spend from the
1554     *      "from" account.This can be done using externalTokenApprove.
1555     * @param _externalToken the address of the Token Contract
1556     * @param _from address of the account to send from
1557     * @param _to address of the beneficiary
1558     * @param _value the amount of ether (in Wei) to send
1559     * @return bool which represents a success
1560     */
1561     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1562     external
1563     onlyRegisteredScheme
1564     onlySubjectToConstraint("externalTokenTransferFrom")
1565     isAvatarValid(_avatar)
1566     returns(bool)
1567     {
1568         emit ExternalTokenTransferFrom(msg.sender, _externalToken, _from, _to, _value);
1569         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1570     }
1571 
1572     /**
1573     * @dev increase approval for the spender address to spend a specified amount of tokens
1574     *      on behalf of msg.sender.
1575     * @param _externalToken the address of the Token Contract
1576     * @param _spender address
1577     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1578     * @return bool which represents a success
1579     */
1580     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1581     external
1582     onlyRegisteredScheme
1583     onlySubjectToConstraint("externalTokenIncreaseApproval")
1584     isAvatarValid(_avatar)
1585     returns(bool)
1586     {
1587         emit ExternalTokenIncreaseApproval(msg.sender,_externalToken,_spender,_addedValue);
1588         return avatar.externalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
1589     }
1590 
1591     /**
1592     * @dev decrease approval for the spender address to spend a specified amount of tokens
1593     *      on behalf of msg.sender.
1594     * @param _externalToken the address of the Token Contract
1595     * @param _spender address
1596     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1597     * @return bool which represents a success
1598     */
1599     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1600     external
1601     onlyRegisteredScheme
1602     onlySubjectToConstraint("externalTokenDecreaseApproval")
1603     isAvatarValid(_avatar)
1604     returns(bool)
1605     {
1606         emit ExternalTokenDecreaseApproval(msg.sender,_externalToken,_spender,_subtractedValue);
1607         return avatar.externalTokenDecreaseApproval(_externalToken, _spender, _subtractedValue);
1608     }
1609 
1610     /**
1611      * @dev getNativeReputation
1612      * @param _avatar the organization avatar.
1613      * @return organization native reputation
1614      */
1615     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
1616         return address(nativeReputation);
1617     }
1618 
1619     function _isSchemeRegistered(address _scheme,address _avatar) private isAvatarValid(_avatar) view returns(bool) {
1620         return (schemes[_scheme].permissions&bytes4(1) != bytes4(0));
1621     }
1622 }
1623 
1624 // File: contracts/universalSchemes/ExecutableInterface.sol
1625 
1626 contract ExecutableInterface {
1627     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool);
1628 }
1629 
1630 // File: contracts/VotingMachines/IntVoteInterface.sol
1631 
1632 interface IntVoteInterface {
1633     //When implementing this interface please do not only override function and modifier,
1634     //but also to keep the modifiers on the overridden functions.
1635     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
1636     modifier votable(bytes32 _proposalId) {revert(); _;}
1637 
1638     event NewProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _numOfChoices, address _proposer, bytes32 _paramsHash);
1639     event ExecuteProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _decision, uint _totalReputation);
1640     event VoteProposal(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter, uint _vote, uint _reputation);
1641     event CancelProposal(bytes32 indexed _proposalId, address indexed _avatar );
1642     event CancelVoting(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter);
1643 
1644     /**
1645      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1646      * generated by calculating keccak256 of a incremented counter.
1647      * @param _numOfChoices number of voting choices
1648      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
1649      * @param _avatar an address to be sent as the payload to the _executable contract.
1650      * @param _executable This contract will be executed when vote is over.
1651      * @param _proposer address
1652      * @return proposal's id.
1653      */
1654     function propose(
1655         uint _numOfChoices,
1656         bytes32 _proposalParameters,
1657         address _avatar,
1658         ExecutableInterface _executable,
1659         address _proposer
1660         ) external returns(bytes32);
1661 
1662     // Only owned proposals and only the owner:
1663     function cancelProposal(bytes32 _proposalId) external onlyProposalOwner(_proposalId) votable(_proposalId) returns(bool);
1664 
1665     // Only owned proposals and only the owner:
1666     function ownerVote(bytes32 _proposalId, uint _vote, address _voter) external onlyProposalOwner(_proposalId) returns(bool);
1667 
1668     function vote(bytes32 _proposalId, uint _vote) external votable(_proposalId) returns(bool);
1669 
1670     function voteWithSpecifiedAmounts(
1671         bytes32 _proposalId,
1672         uint _vote,
1673         uint _rep,
1674         uint _token) external votable(_proposalId) returns(bool);
1675 
1676     function cancelVote(bytes32 _proposalId) external votable(_proposalId);
1677 
1678     //@dev execute check if the proposal has been decided, and if so, execute the proposal
1679     //@param _proposalId the id of the proposal
1680     //@return bool true - the proposal has been executed
1681     //             false - otherwise.
1682     function execute(bytes32 _proposalId) public votable(_proposalId) returns(bool);
1683 
1684     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint);
1685 
1686     function isVotable(bytes32 _proposalId) external view returns(bool);
1687 
1688     /**
1689      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1690      * @param _proposalId the ID of the proposal
1691      * @param _choice the index in the
1692      * @return voted reputation for the given choice
1693      */
1694     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint);
1695 
1696     /**
1697      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1698      * @return bool true or false
1699      */
1700     function isAbstainAllow() external pure returns(bool);
1701 
1702     /**
1703      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1704      * @return min - minimum number of choices
1705                max - maximum number of choices
1706      */
1707     function getAllowedRangeOfChoices() external pure returns(uint min,uint max);
1708 }
1709 
1710 // File: contracts/VotingMachines/AbsoluteVote.sol
1711 
1712 contract AbsoluteVote is IntVoteInterface {
1713     using SafeMath for uint;
1714 
1715 
1716     struct Parameters {
1717         Reputation reputationSystem; // the reputation system that is being used
1718         uint precReq; // how many percentages required for the proposal to be passed
1719         bool allowOwner; // does this proposal has an owner who has owner rights?
1720     }
1721 
1722     struct Voter {
1723         uint vote; // 0 - 'abstain'
1724         uint reputation; // amount of voter's reputation
1725     }
1726 
1727     struct Proposal {
1728         address owner; // the proposal's owner
1729         address avatar; // the avatar of the organization that owns the proposal
1730         uint numOfChoices;
1731         ExecutableInterface executable; // will be executed if the proposal will pass
1732         bytes32 paramsHash; // the hash of the parameters of the proposal
1733         uint totalVotes;
1734         mapping(uint=>uint) votes;
1735         mapping(address=>Voter) voters;
1736         bool open; // voting open flag
1737     }
1738 
1739     event AVVoteProposal(bytes32 indexed _proposalId, bool _isOwnerVote);
1740     event RefreshReputation(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter,uint _reputation);
1741 
1742 
1743     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
1744     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
1745 
1746     uint public constant MAX_NUM_OF_CHOICES = 10;
1747     uint public proposalsCnt; // Total amount of proposals
1748 
1749   /**
1750    * @dev Check that there is owner for the proposal and he sent the transaction
1751    */
1752     modifier onlyProposalOwner(bytes32 _proposalId) {
1753         require(msg.sender == proposals[_proposalId].owner);
1754         _;
1755     }
1756 
1757   /**
1758    * @dev Check that the proposal is votable (open and not executed yet)
1759    */
1760     modifier votable(bytes32 _proposalId) {
1761         require(proposals[_proposalId].open);
1762         _;
1763     }
1764 
1765     /**
1766      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1767      * generated by calculating keccak256 of a incremented counter.
1768      * @param _numOfChoices number of voting choices
1769      * @param _paramsHash defined the parameters of the voting machine used for this proposal
1770      * @param _avatar an address to be sent as the payload to the _executable contract.
1771      * @param _executable This contract will be executed when vote is over.
1772      * @return proposal's id.
1773      */
1774     function propose(uint _numOfChoices, bytes32 _paramsHash, address _avatar, ExecutableInterface _executable,address)
1775         external
1776         returns(bytes32)
1777     {
1778         // Check valid params and number of choices:
1779         require(parameters[_paramsHash].reputationSystem != address(0));
1780         require(_numOfChoices > 0 && _numOfChoices <= MAX_NUM_OF_CHOICES);
1781         // Generate a unique ID:
1782         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
1783         proposalsCnt++;
1784         // Open proposal:
1785         Proposal memory proposal;
1786         proposal.numOfChoices = _numOfChoices;
1787         proposal.paramsHash = _paramsHash;
1788         proposal.avatar = _avatar;
1789         proposal.executable = _executable;
1790         proposal.owner = msg.sender;
1791         proposal.open = true;
1792         proposals[proposalId] = proposal;
1793         emit NewProposal(proposalId, _avatar, _numOfChoices, msg.sender, _paramsHash);
1794         return proposalId;
1795     }
1796 
1797   /**
1798    * @dev Cancel a proposal, only the owner can call this function and only if allowOwner flag is true.
1799    * @param _proposalId the proposal ID
1800    */
1801     function cancelProposal(bytes32 _proposalId) external onlyProposalOwner(_proposalId) votable(_proposalId) returns(bool) {
1802         if (! parameters[proposals[_proposalId].paramsHash].allowOwner) {
1803             return false;
1804         }
1805         address avatar = proposals[_proposalId].avatar;
1806         deleteProposal(_proposalId);
1807         emit CancelProposal(_proposalId, avatar);
1808         return true;
1809     }
1810 
1811   /**
1812    * @dev voting function
1813    * @param _proposalId id of the proposal
1814    * @param _vote a value between 0 to and the proposal number of choices.
1815    * @return bool true - the proposal has been executed
1816    *              false - otherwise.
1817    */
1818     function vote(bytes32 _proposalId, uint _vote) external votable(_proposalId) returns(bool) {
1819         return internalVote(_proposalId, msg.sender, _vote, 0);
1820     }
1821 
1822   /**
1823    * @dev voting function with owner functionality (can vote on behalf of someone else)
1824    * @param _proposalId id of the proposal
1825    * @param _vote a value between 0 to and the proposal number of choices.
1826    * @param _voter will be voted with that voter's address
1827    * @return bool true - the proposal has been executed
1828    *              false - otherwise.
1829    */
1830     function ownerVote(bytes32 _proposalId, uint _vote, address _voter)
1831         external
1832         onlyProposalOwner(_proposalId)
1833         votable(_proposalId)
1834         returns(bool)
1835     {
1836         if (! parameters[proposals[_proposalId].paramsHash].allowOwner) {
1837             return false;
1838         }
1839         return  internalVote(_proposalId, _voter, _vote, 0);
1840     }
1841 
1842     function voteWithSpecifiedAmounts(bytes32 _proposalId,uint _vote,uint _rep,uint) external votable(_proposalId) returns(bool) {
1843         return internalVote(_proposalId,msg.sender,_vote,_rep);
1844     }
1845 
1846   /**
1847    * @dev Cancel the vote of the msg.sender: subtract the reputation amount from the votes
1848    * and delete the voter from the proposal struct
1849    * @param _proposalId id of the proposal
1850    */
1851     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
1852         cancelVoteInternal(_proposalId, msg.sender);
1853     }
1854 
1855   /**
1856    * @dev getNumberOfChoices returns the number of choices possible in this proposal
1857    * @param _proposalId the ID of the proposal
1858    * @return uint that contains number of choices
1859    */
1860     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint) {
1861         return proposals[_proposalId].numOfChoices;
1862     }
1863 
1864   /**
1865    * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
1866    * @param _proposalId the ID of the proposal
1867    * @param _voter the address of the voter
1868    * @return uint vote - the voters vote
1869    *        uint reputation - amount of reputation committed by _voter to _proposalId
1870    */
1871     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
1872         Voter memory voter = proposals[_proposalId].voters[_voter];
1873         return (voter.vote, voter.reputation);
1874     }
1875 
1876     /**
1877      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1878      * @param _proposalId the ID of the proposal
1879      * @param _choice the index in the
1880      * @return voted reputation for the given choice
1881      */
1882     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint) {
1883         return proposals[_proposalId].votes[_choice];
1884     }
1885 
1886     /**
1887       * @dev isVotable check if the proposal is votable
1888       * @param _proposalId the ID of the proposal
1889       * @return bool true or false
1890     */
1891     function isVotable(bytes32 _proposalId) external view returns(bool) {
1892         return  proposals[_proposalId].open;
1893     }
1894 
1895     /**
1896      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1897      * @return bool true or false
1898      */
1899     function isAbstainAllow() external pure returns(bool) {
1900         return true;
1901     }
1902 
1903     /**
1904      * @dev refreshReputation refresh the reputation for a given voters list
1905      * @param _proposalId the ID of the proposal
1906      * @param _voters list to be refreshed
1907      * @return bool true or false
1908      */
1909     function refreshReputation(bytes32 _proposalId, address[] _voters) external returns(bool) {
1910         Proposal storage proposal = proposals[_proposalId];
1911         Parameters memory params = parameters[proposal.paramsHash];
1912 
1913         for (uint i = 0; i < _voters.length; i++) {
1914             Voter storage voter = proposal.voters[_voters[i]];
1915              //check that the voters already votes.
1916             if (voter.reputation > 0) {
1917                 //update only if there is a mismatch between the voter's system reputation
1918                 //and the reputation stored in the voting machine for the voter.
1919                 uint rep = params.reputationSystem.reputationOf(_voters[i]);
1920                 if (rep > voter.reputation) {
1921                     proposal.votes[voter.vote] = proposal.votes[voter.vote].add(rep - voter.reputation);
1922                     proposal.totalVotes = (proposal.totalVotes).add(rep - voter.reputation);
1923                   } else if (rep < voter.reputation) {
1924                     proposal.votes[voter.vote] = proposal.votes[voter.vote].sub(voter.reputation - rep);
1925                     proposal.totalVotes = (proposal.totalVotes).sub(voter.reputation - rep);
1926                   }
1927                 if (rep != voter.reputation) {
1928                     voter.reputation = rep;
1929                     emit RefreshReputation(_proposalId, proposal.avatar, _voters[i],rep);
1930                 }
1931              }
1932         }
1933         return true;
1934     }
1935 
1936     /**
1937      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1938      * @return min - minimum number of choices
1939                max - maximum number of choices
1940      */
1941     function getAllowedRangeOfChoices() external pure returns(uint min,uint max) {
1942         return (1,MAX_NUM_OF_CHOICES);
1943     }
1944 
1945     /**
1946       * @dev execute check if the proposal has been decided, and if so, execute the proposal
1947       * @param _proposalId the id of the proposal
1948       * @return bool true - the proposal has been executed
1949       *              false - otherwise.
1950      */
1951     function execute(bytes32 _proposalId) public votable(_proposalId) returns(bool) {
1952         Proposal storage proposal = proposals[_proposalId];
1953         Reputation reputation = parameters[proposal.paramsHash].reputationSystem;
1954         require(reputation != address(0));
1955         uint totalReputation = reputation.totalSupply();
1956         uint precReq = parameters[proposal.paramsHash].precReq;
1957         // Check if someone crossed the bar:
1958         for (uint cnt = 0; cnt <= proposal.numOfChoices; cnt++) {
1959             if (proposal.votes[cnt] > totalReputation*precReq/100) {
1960                 Proposal memory tmpProposal = proposal;
1961                 deleteProposal(_proposalId);
1962                 emit ExecuteProposal(_proposalId, tmpProposal.avatar, cnt, totalReputation);
1963                 (tmpProposal.executable).execute(_proposalId, tmpProposal.avatar, int(cnt));
1964                 return true;
1965             }
1966         }
1967         return false;
1968     }
1969 
1970     /**
1971      * @dev hash the parameters, save them if necessary, and return the hash value
1972     */
1973     function setParameters(Reputation _reputationSystem, uint _precReq, bool _allowOwner) public returns(bytes32) {
1974         require(_precReq <= 100 && _precReq > 0);
1975         bytes32 hashedParameters = getParametersHash(_reputationSystem, _precReq, _allowOwner);
1976         parameters[hashedParameters] = Parameters({
1977             reputationSystem: _reputationSystem,
1978             precReq: _precReq,
1979             allowOwner: _allowOwner
1980         });
1981         return hashedParameters;
1982     }
1983 
1984     /**
1985      * @dev hashParameters returns a hash of the given parameters
1986      */
1987     function getParametersHash(Reputation _reputationSystem, uint _precReq, bool _allowOwner) public pure returns(bytes32) {
1988         return keccak256(abi.encodePacked(_reputationSystem, _precReq, _allowOwner));
1989     }
1990 
1991     function cancelVoteInternal(bytes32 _proposalId, address _voter) internal {
1992         Proposal storage proposal = proposals[_proposalId];
1993         Voter memory voter = proposal.voters[_voter];
1994         proposal.votes[voter.vote] = (proposal.votes[voter.vote]).sub(voter.reputation);
1995         proposal.totalVotes = (proposal.totalVotes).sub(voter.reputation);
1996         delete proposal.voters[_voter];
1997         emit CancelVoting(_proposalId, proposal.avatar, _voter);
1998     }
1999 
2000     function deleteProposal(bytes32 _proposalId) internal {
2001         Proposal storage proposal = proposals[_proposalId];
2002         for (uint cnt = 0; cnt <= proposal.numOfChoices; cnt++) {
2003             delete proposal.votes[cnt];
2004         }
2005         delete proposals[_proposalId];
2006     }
2007 
2008     /**
2009      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
2010      * @param _proposalId id of the proposal
2011      * @param _voter used in case the vote is cast for someone else
2012      * @param _vote a value between 0 to and the proposal's number of choices.
2013      * @return true in case of proposal execution otherwise false
2014      * throws if proposal is not open or if it has been executed
2015      * NB: executes the proposal if a decision has been reached
2016      */
2017     function internalVote(bytes32 _proposalId, address _voter, uint _vote, uint _rep) private returns(bool) {
2018         Proposal storage proposal = proposals[_proposalId];
2019         Parameters memory params = parameters[proposal.paramsHash];
2020         // Check valid vote:
2021         require(_vote <= proposal.numOfChoices);
2022         // Check voter has enough reputation:
2023         uint reputation = params.reputationSystem.reputationOf(_voter);
2024         require(reputation >= _rep);
2025         uint rep = _rep;
2026         if (rep == 0) {
2027             rep = reputation;
2028         }
2029         // If this voter has already voted, first cancel the vote:
2030         if (proposal.voters[_voter].reputation != 0) {
2031             cancelVoteInternal(_proposalId, _voter);
2032         }
2033         // The voting itself:
2034         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
2035         proposal.totalVotes = rep.add(proposal.totalVotes);
2036         proposal.voters[_voter] = Voter({
2037             reputation: rep,
2038             vote: _vote
2039         });
2040         // Event:
2041         emit VoteProposal(_proposalId, proposal.avatar, _voter, _vote, reputation);
2042         emit AVVoteProposal(_proposalId, (_voter != msg.sender));
2043         // execute the proposal if this vote was decisive:
2044         return execute(_proposalId);
2045     }
2046 }