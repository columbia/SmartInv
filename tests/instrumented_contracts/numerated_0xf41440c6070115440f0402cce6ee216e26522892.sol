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
480 // File: contracts/token/ERC827/ERC827.sol
481 
482 /**
483  * @title ERC827 interface, an extension of ERC20 token standard
484  *
485  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
486  * methods to transfer value and data and execute calls in transfers and
487  * approvals.
488  */
489 contract ERC827 is ERC20 {
490 
491     function approveAndCall(address _spender,uint256 _value,bytes _data) public payable returns(bool);
492 
493     function transferAndCall(address _to,uint256 _value,bytes _data) public payable returns(bool);
494 
495     function transferFromAndCall(address _from,address _to,uint256 _value,bytes _data) public payable returns(bool);
496 
497 }
498 
499 // File: contracts/token/ERC827/ERC827Token.sol
500 
501 /* solium-disable security/no-low-level-calls */
502 
503 pragma solidity ^0.4.24;
504 
505 
506 
507 
508 /**
509  * @title ERC827, an extension of ERC20 token standard
510  *
511  * @dev Implementation the ERC827, following the ERC20 standard with extra
512  * methods to transfer value and data and execute calls in transfers and
513  * approvals. Uses OpenZeppelin StandardToken.
514  */
515 contract ERC827Token is ERC827, StandardToken {
516 
517   /**
518    * @dev Addition to ERC20 token methods. It allows to
519    * approve the transfer of value and execute a call with the sent data.
520    * Beware that changing an allowance with this method brings the risk that
521    * someone may use both the old and the new allowance by unfortunate
522    * transaction ordering. One possible solution to mitigate this race condition
523    * is to first reduce the spender's allowance to 0 and set the desired value
524    * afterwards:
525    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
526    * @param _spender The address that will spend the funds.
527    * @param _value The amount of tokens to be spent.
528    * @param _data ABI-encoded contract call to call `_spender` address.
529    * @return true if the call function was executed successfully
530    */
531     function approveAndCall(
532         address _spender,
533         uint256 _value,
534         bytes _data
535     )
536     public
537     payable
538     returns (bool)
539     {
540         require(_spender != address(this));
541 
542         super.approve(_spender, _value);
543 
544         // solium-disable-next-line security/no-call-value
545         require(_spender.call.value(msg.value)(_data));
546 
547         return true;
548     }
549 
550   /**
551    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
552    * address and execute a call with the sent data on the same transaction
553    * @param _to address The address which you want to transfer to
554    * @param _value uint256 the amout of tokens to be transfered
555    * @param _data ABI-encoded contract call to call `_to` address.
556    * @return true if the call function was executed successfully
557    */
558     function transferAndCall(
559         address _to,
560         uint256 _value,
561         bytes _data
562     )
563     public
564     payable
565     returns (bool)
566     {
567         require(_to != address(this));
568 
569         super.transfer(_to, _value);
570 
571         // solium-disable-next-line security/no-call-value
572         require(_to.call.value(msg.value)(_data));
573         return true;
574     }
575 
576   /**
577    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
578    * another and make a contract call on the same transaction
579    * @param _from The address which you want to send tokens from
580    * @param _to The address which you want to transfer to
581    * @param _value The amout of tokens to be transferred
582    * @param _data ABI-encoded contract call to call `_to` address.
583    * @return true if the call function was executed successfully
584    */
585     function transferFromAndCall(
586         address _from,
587         address _to,
588         uint256 _value,
589         bytes _data
590     )
591     public payable returns (bool)
592     {
593         require(_to != address(this));
594 
595         super.transferFrom(_from, _to, _value);
596 
597         // solium-disable-next-line security/no-call-value
598         require(_to.call.value(msg.value)(_data));
599         return true;
600     }
601 
602   /**
603    * @dev Addition to StandardToken methods. Increase the amount of tokens that
604    * an owner allowed to a spender and execute a call with the sent data.
605    * approve should be called when allowed[_spender] == 0. To increment
606    * allowed value is better to use this function to avoid 2 calls (and wait until
607    * the first transaction is mined)
608    * From MonolithDAO Token.sol
609    * @param _spender The address which will spend the funds.
610    * @param _addedValue The amount of tokens to increase the allowance by.
611    * @param _data ABI-encoded contract call to call `_spender` address.
612    */
613     function increaseApprovalAndCall(
614         address _spender,
615         uint _addedValue,
616         bytes _data
617     )
618     public
619     payable
620     returns (bool)
621     {
622         require(_spender != address(this));
623 
624         super.increaseApproval(_spender, _addedValue);
625 
626         // solium-disable-next-line security/no-call-value
627         require(_spender.call.value(msg.value)(_data));
628 
629         return true;
630     }
631 
632   /**
633    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
634    * an owner allowed to a spender and execute a call with the sent data.
635    * approve should be called when allowed[_spender] == 0. To decrement
636    * allowed value is better to use this function to avoid 2 calls (and wait until
637    * the first transaction is mined)
638    * From MonolithDAO Token.sol
639    * @param _spender The address which will spend the funds.
640    * @param _subtractedValue The amount of tokens to decrease the allowance by.
641    * @param _data ABI-encoded contract call to call `_spender` address.
642    */
643     function decreaseApprovalAndCall(
644         address _spender,
645         uint _subtractedValue,
646         bytes _data
647     )
648     public
649     payable
650     returns (bool)
651     {
652         require(_spender != address(this));
653 
654         super.decreaseApproval(_spender, _subtractedValue);
655 
656         // solium-disable-next-line security/no-call-value
657         require(_spender.call.value(msg.value)(_data));
658 
659         return true;
660     }
661 
662 }
663 
664 // File: contracts/controller/DAOToken.sol
665 
666 /**
667  * @title DAOToken, base on zeppelin contract.
668  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
669  */
670 
671 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
672 
673     string public name;
674     string public symbol;
675     // solium-disable-next-line uppercase
676     uint8 public constant decimals = 18;
677     uint public cap;
678 
679     /**
680     * @dev Constructor
681     * @param _name - token name
682     * @param _symbol - token symbol
683     * @param _cap - token cap - 0 value means no cap
684     */
685     constructor(string _name, string _symbol,uint _cap) public {
686         name = _name;
687         symbol = _symbol;
688         cap = _cap;
689     }
690 
691     /**
692      * @dev Function to mint tokens
693      * @param _to The address that will receive the minted tokens.
694      * @param _amount The amount of tokens to mint.
695      * @return A boolean that indicates if the operation was successful.
696      */
697     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
698         if (cap > 0)
699             require(totalSupply_.add(_amount) <= cap);
700         return super.mint(_to, _amount);
701     }
702 }
703 
704 // File: contracts/controller/Avatar.sol
705 
706 /**
707  * @title An Avatar holds tokens, reputation and ether for a controller
708  */
709 contract Avatar is Ownable {
710     bytes32 public orgName;
711     DAOToken public nativeToken;
712     Reputation public nativeReputation;
713 
714     event GenericAction(address indexed _action, bytes32[] _params);
715     event SendEther(uint _amountInWei, address indexed _to);
716     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
717     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
718     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
719     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
720     event ReceiveEther(address indexed _sender, uint _value);
721 
722     /**
723     * @dev the constructor takes organization name, native token and reputation system
724     and creates an avatar for a controller
725     */
726     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
727         orgName = _orgName;
728         nativeToken = _nativeToken;
729         nativeReputation = _nativeReputation;
730     }
731 
732     /**
733     * @dev enables an avatar to receive ethers
734     */
735     function() public payable {
736         emit ReceiveEther(msg.sender, msg.value);
737     }
738 
739     /**
740     * @dev perform a generic call to an arbitrary contract
741     * @param _contract  the contract's address to call
742     * @param _data ABI-encoded contract call to call `_contract` address.
743     * @return the return bytes of the called contract's function.
744     */
745     function genericCall(address _contract,bytes _data) public onlyOwner {
746         // solium-disable-next-line security/no-low-level-calls
747         bool result = _contract.call(_data);
748         // solium-disable-next-line security/no-inline-assembly
749         assembly {
750         // Copy the returned data.
751         returndatacopy(0, 0, returndatasize)
752 
753         switch result
754         // call returns 0 on error.
755         case 0 { revert(0, returndatasize) }
756         default { return(0, returndatasize) }
757         }
758     }
759 
760     /**
761     * @dev send ethers from the avatar's wallet
762     * @param _amountInWei amount to send in Wei units
763     * @param _to send the ethers to this address
764     * @return bool which represents success
765     */
766     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
767         _to.transfer(_amountInWei);
768         emit SendEther(_amountInWei, _to);
769         return true;
770     }
771 
772     /**
773     * @dev external token transfer
774     * @param _externalToken the token contract
775     * @param _to the destination address
776     * @param _value the amount of tokens to transfer
777     * @return bool which represents success
778     */
779     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
780     public onlyOwner returns(bool)
781     {
782         _externalToken.transfer(_to, _value);
783         emit ExternalTokenTransfer(_externalToken, _to, _value);
784         return true;
785     }
786 
787     /**
788     * @dev external token transfer from a specific account
789     * @param _externalToken the token contract
790     * @param _from the account to spend token from
791     * @param _to the destination address
792     * @param _value the amount of tokens to transfer
793     * @return bool which represents success
794     */
795     function externalTokenTransferFrom(
796         StandardToken _externalToken,
797         address _from,
798         address _to,
799         uint _value
800     )
801     public onlyOwner returns(bool)
802     {
803         _externalToken.transferFrom(_from, _to, _value);
804         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
805         return true;
806     }
807 
808     /**
809     * @dev increase approval for the spender address to spend a specified amount of tokens
810     *      on behalf of msg.sender.
811     * @param _externalToken the address of the Token Contract
812     * @param _spender address
813     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
814     * @return bool which represents a success
815     */
816     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
817     public onlyOwner returns(bool)
818     {
819         _externalToken.increaseApproval(_spender, _addedValue);
820         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
821         return true;
822     }
823 
824     /**
825     * @dev decrease approval for the spender address to spend a specified amount of tokens
826     *      on behalf of msg.sender.
827     * @param _externalToken the address of the Token Contract
828     * @param _spender address
829     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
830     * @return bool which represents a success
831     */
832     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
833     public onlyOwner returns(bool)
834     {
835         _externalToken.decreaseApproval(_spender, _subtractedValue);
836         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
837         return true;
838     }
839 
840 }
841 
842 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
843 
844 contract GlobalConstraintInterface {
845 
846     enum CallPhase { Pre, Post,PreAndPost }
847 
848     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
849     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
850     /**
851      * @dev when return if this globalConstraints is pre, post or both.
852      * @return CallPhase enum indication  Pre, Post or PreAndPost.
853      */
854     function when() public returns(CallPhase);
855 }
856 
857 // File: contracts/controller/ControllerInterface.sol
858 
859 /**
860  * @title Controller contract
861  * @dev A controller controls the organizations tokens ,reputation and avatar.
862  * It is subject to a set of schemes and constraints that determine its behavior.
863  * Each scheme has it own parameters and operation permissions.
864  */
865 interface ControllerInterface {
866 
867     /**
868      * @dev Mint `_amount` of reputation that are assigned to `_to` .
869      * @param  _amount amount of reputation to mint
870      * @param _to beneficiary address
871      * @return bool which represents a success
872     */
873     function mintReputation(uint256 _amount, address _to,address _avatar)
874     external
875     returns(bool);
876 
877     /**
878      * @dev Burns `_amount` of reputation from `_from`
879      * @param _amount amount of reputation to burn
880      * @param _from The address that will lose the reputation
881      * @return bool which represents a success
882      */
883     function burnReputation(uint256 _amount, address _from,address _avatar)
884     external
885     returns(bool);
886 
887     /**
888      * @dev mint tokens .
889      * @param  _amount amount of token to mint
890      * @param _beneficiary beneficiary address
891      * @param _avatar address
892      * @return bool which represents a success
893      */
894     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
895     external
896     returns(bool);
897 
898   /**
899    * @dev register or update a scheme
900    * @param _scheme the address of the scheme
901    * @param _paramsHash a hashed configuration of the usage of the scheme
902    * @param _permissions the permissions the new scheme will have
903    * @param _avatar address
904    * @return bool which represents a success
905    */
906     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
907     external
908     returns(bool);
909 
910     /**
911      * @dev unregister a scheme
912      * @param _avatar address
913      * @param _scheme the address of the scheme
914      * @return bool which represents a success
915      */
916     function unregisterScheme(address _scheme,address _avatar)
917     external
918     returns(bool);
919     /**
920      * @dev unregister the caller's scheme
921      * @param _avatar address
922      * @return bool which represents a success
923      */
924     function unregisterSelf(address _avatar) external returns(bool);
925 
926     function isSchemeRegistered( address _scheme,address _avatar) external view returns(bool);
927 
928     function getSchemeParameters(address _scheme,address _avatar) external view returns(bytes32);
929 
930     function getGlobalConstraintParameters(address _globalConstraint,address _avatar) external view returns(bytes32);
931 
932     function getSchemePermissions(address _scheme,address _avatar) external view returns(bytes4);
933 
934     /**
935      * @dev globalConstraintsCount return the global constraint pre and post count
936      * @return uint globalConstraintsPre count.
937      * @return uint globalConstraintsPost count.
938      */
939     function globalConstraintsCount(address _avatar) external view returns(uint,uint);
940 
941     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar) external view returns(bool);
942 
943     /**
944      * @dev add or update Global Constraint
945      * @param _globalConstraint the address of the global constraint to be added.
946      * @param _params the constraint parameters hash.
947      * @param _avatar the avatar of the organization
948      * @return bool which represents a success
949      */
950     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
951     external returns(bool);
952 
953     /**
954      * @dev remove Global Constraint
955      * @param _globalConstraint the address of the global constraint to be remove.
956      * @param _avatar the organization avatar.
957      * @return bool which represents a success
958      */
959     function removeGlobalConstraint (address _globalConstraint,address _avatar)
960     external  returns(bool);
961 
962   /**
963     * @dev upgrade the Controller
964     *      The function will trigger an event 'UpgradeController'.
965     * @param  _newController the address of the new controller.
966     * @param _avatar address
967     * @return bool which represents a success
968     */
969     function upgradeController(address _newController,address _avatar)
970     external returns(bool);
971 
972     /**
973     * @dev perform a generic call to an arbitrary contract
974     * @param _contract  the contract's address to call
975     * @param _data ABI-encoded contract call to call `_contract` address.
976     * @param _avatar the controller's avatar address
977     * @return bytes32  - the return value of the called _contract's function.
978     */
979     function genericCall(address _contract,bytes _data,address _avatar)
980     external
981     returns(bytes32);
982 
983   /**
984    * @dev send some ether
985    * @param _amountInWei the amount of ether (in Wei) to send
986    * @param _to address of the beneficiary
987    * @param _avatar address
988    * @return bool which represents a success
989    */
990     function sendEther(uint _amountInWei, address _to,address _avatar)
991     external returns(bool);
992 
993     /**
994     * @dev send some amount of arbitrary ERC20 Tokens
995     * @param _externalToken the address of the Token Contract
996     * @param _to address of the beneficiary
997     * @param _value the amount of ether (in Wei) to send
998     * @param _avatar address
999     * @return bool which represents a success
1000     */
1001     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1002     external
1003     returns(bool);
1004 
1005     /**
1006     * @dev transfer token "from" address "to" address
1007     *      One must to approve the amount of tokens which can be spend from the
1008     *      "from" account.This can be done using externalTokenApprove.
1009     * @param _externalToken the address of the Token Contract
1010     * @param _from address of the account to send from
1011     * @param _to address of the beneficiary
1012     * @param _value the amount of ether (in Wei) to send
1013     * @param _avatar address
1014     * @return bool which represents a success
1015     */
1016     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1017     external
1018     returns(bool);
1019 
1020     /**
1021     * @dev increase approval for the spender address to spend a specified amount of tokens
1022     *      on behalf of msg.sender.
1023     * @param _externalToken the address of the Token Contract
1024     * @param _spender address
1025     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1026     * @param _avatar address
1027     * @return bool which represents a success
1028     */
1029     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1030     external
1031     returns(bool);
1032 
1033     /**
1034     * @dev decrease approval for the spender address to spend a specified amount of tokens
1035     *      on behalf of msg.sender.
1036     * @param _externalToken the address of the Token Contract
1037     * @param _spender address
1038     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1039     * @param _avatar address
1040     * @return bool which represents a success
1041     */
1042     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1043     external
1044     returns(bool);
1045 
1046     /**
1047      * @dev getNativeReputation
1048      * @param _avatar the organization avatar.
1049      * @return organization native reputation
1050      */
1051     function getNativeReputation(address _avatar)
1052     external
1053     view
1054     returns(address);
1055 }
1056 
1057 // File: contracts/controller/Controller.sol
1058 
1059 /**
1060  * @title Controller contract
1061  * @dev A controller controls the organizations tokens,reputation and avatar.
1062  * It is subject to a set of schemes and constraints that determine its behavior.
1063  * Each scheme has it own parameters and operation permissions.
1064  */
1065 contract Controller is ControllerInterface {
1066 
1067     struct Scheme {
1068         bytes32 paramsHash;  // a hash "configuration" of the scheme
1069         bytes4  permissions; // A bitwise flags of permissions,
1070                              // All 0: Not registered,
1071                              // 1st bit: Flag if the scheme is registered,
1072                              // 2nd bit: Scheme can register other schemes
1073                              // 3rd bit: Scheme can add/remove global constraints
1074                              // 4th bit: Scheme can upgrade the controller
1075                              // 5th bit: Scheme can call genericCall on behalf of
1076                              //          the organization avatar
1077     }
1078 
1079     struct GlobalConstraint {
1080         address gcAddress;
1081         bytes32 params;
1082     }
1083 
1084     struct GlobalConstraintRegister {
1085         bool isRegistered; //is registered
1086         uint index;    //index at globalConstraints
1087     }
1088 
1089     mapping(address=>Scheme) public schemes;
1090 
1091     Avatar public avatar;
1092     DAOToken public nativeToken;
1093     Reputation public nativeReputation;
1094   // newController will point to the new controller after the present controller is upgraded
1095     address public newController;
1096   // globalConstraintsPre that determine pre conditions for all actions on the controller
1097 
1098     GlobalConstraint[] public globalConstraintsPre;
1099   // globalConstraintsPost that determine post conditions for all actions on the controller
1100     GlobalConstraint[] public globalConstraintsPost;
1101   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1102     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1103   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1104     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1105 
1106     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1107     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1108     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1109     event RegisterScheme (address indexed _sender, address indexed _scheme);
1110     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1111     event GenericAction (address indexed _sender, bytes32[] _params);
1112     event SendEther (address indexed _sender, uint _amountInWei, address indexed _to);
1113     event ExternalTokenTransfer (address indexed _sender, address indexed _externalToken, address indexed _to, uint _value);
1114     event ExternalTokenTransferFrom (address indexed _sender, address indexed _externalToken, address _from, address _to, uint _value);
1115     event ExternalTokenIncreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1116     event ExternalTokenDecreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1117     event UpgradeController(address indexed _oldController,address _newController);
1118     event AddGlobalConstraint(address indexed _globalConstraint, bytes32 _params,GlobalConstraintInterface.CallPhase _when);
1119     event RemoveGlobalConstraint(address indexed _globalConstraint ,uint256 _index,bool _isPre);
1120     event GenericCall(address indexed _contract,bytes _data);
1121 
1122     constructor( Avatar _avatar) public
1123     {
1124         avatar = _avatar;
1125         nativeToken = avatar.nativeToken();
1126         nativeReputation = avatar.nativeReputation();
1127         schemes[msg.sender] = Scheme({paramsHash: bytes32(0),permissions: bytes4(0x1F)});
1128     }
1129 
1130   // Do not allow mistaken calls:
1131     function() external {
1132         revert();
1133     }
1134 
1135   // Modifiers:
1136     modifier onlyRegisteredScheme() {
1137         require(schemes[msg.sender].permissions&bytes4(1) == bytes4(1));
1138         _;
1139     }
1140 
1141     modifier onlyRegisteringSchemes() {
1142         require(schemes[msg.sender].permissions&bytes4(2) == bytes4(2));
1143         _;
1144     }
1145 
1146     modifier onlyGlobalConstraintsScheme() {
1147         require(schemes[msg.sender].permissions&bytes4(4) == bytes4(4));
1148         _;
1149     }
1150 
1151     modifier onlyUpgradingScheme() {
1152         require(schemes[msg.sender].permissions&bytes4(8) == bytes4(8));
1153         _;
1154     }
1155 
1156     modifier onlyGenericCallScheme() {
1157         require(schemes[msg.sender].permissions&bytes4(16) == bytes4(16));
1158         _;
1159     }
1160 
1161     modifier onlySubjectToConstraint(bytes32 func) {
1162         uint idx;
1163         for (idx = 0;idx<globalConstraintsPre.length;idx++) {
1164             require((GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress)).pre(msg.sender,globalConstraintsPre[idx].params,func));
1165         }
1166         _;
1167         for (idx = 0;idx<globalConstraintsPost.length;idx++) {
1168             require((GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress)).post(msg.sender,globalConstraintsPost[idx].params,func));
1169         }
1170     }
1171 
1172     modifier isAvatarValid(address _avatar) {
1173         require(_avatar == address(avatar));
1174         _;
1175     }
1176 
1177     /**
1178      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1179      * @param  _amount amount of reputation to mint
1180      * @param _to beneficiary address
1181      * @return bool which represents a success
1182      */
1183     function mintReputation(uint256 _amount, address _to,address _avatar)
1184     external
1185     onlyRegisteredScheme
1186     onlySubjectToConstraint("mintReputation")
1187     isAvatarValid(_avatar)
1188     returns(bool)
1189     {
1190         emit MintReputation(msg.sender, _to, _amount);
1191         return nativeReputation.mint(_to, _amount);
1192     }
1193 
1194     /**
1195      * @dev Burns `_amount` of reputation from `_from`
1196      * @param _amount amount of reputation to burn
1197      * @param _from The address that will lose the reputation
1198      * @return bool which represents a success
1199      */
1200     function burnReputation(uint256 _amount, address _from,address _avatar)
1201     external
1202     onlyRegisteredScheme
1203     onlySubjectToConstraint("burnReputation")
1204     isAvatarValid(_avatar)
1205     returns(bool)
1206     {
1207         emit BurnReputation(msg.sender, _from, _amount);
1208         return nativeReputation.burn(_from, _amount);
1209     }
1210 
1211     /**
1212      * @dev mint tokens .
1213      * @param  _amount amount of token to mint
1214      * @param _beneficiary beneficiary address
1215      * @return bool which represents a success
1216      */
1217     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
1218     external
1219     onlyRegisteredScheme
1220     onlySubjectToConstraint("mintTokens")
1221     isAvatarValid(_avatar)
1222     returns(bool)
1223     {
1224         emit MintTokens(msg.sender, _beneficiary, _amount);
1225         return nativeToken.mint(_beneficiary, _amount);
1226     }
1227 
1228   /**
1229    * @dev register a scheme
1230    * @param _scheme the address of the scheme
1231    * @param _paramsHash a hashed configuration of the usage of the scheme
1232    * @param _permissions the permissions the new scheme will have
1233    * @return bool which represents a success
1234    */
1235     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
1236     external
1237     onlyRegisteringSchemes
1238     onlySubjectToConstraint("registerScheme")
1239     isAvatarValid(_avatar)
1240     returns(bool)
1241     {
1242 
1243         Scheme memory scheme = schemes[_scheme];
1244 
1245     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1246     // Implementation is a bit messy. One must recall logic-circuits ^^
1247 
1248     // produces non-zero if sender does not have all of the perms that are changing between old and new
1249         require(bytes4(0x1F)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1250 
1251     // produces non-zero if sender does not have all of the perms in the old scheme
1252         require(bytes4(0x1F)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1253 
1254     // Add or change the scheme:
1255         schemes[_scheme].paramsHash = _paramsHash;
1256         schemes[_scheme].permissions = _permissions|bytes4(1);
1257         emit RegisterScheme(msg.sender, _scheme);
1258         return true;
1259     }
1260 
1261     /**
1262      * @dev unregister a scheme
1263      * @param _scheme the address of the scheme
1264      * @return bool which represents a success
1265      */
1266     function unregisterScheme( address _scheme,address _avatar)
1267     external
1268     onlyRegisteringSchemes
1269     onlySubjectToConstraint("unregisterScheme")
1270     isAvatarValid(_avatar)
1271     returns(bool)
1272     {
1273     //check if the scheme is registered
1274         if (schemes[_scheme].permissions&bytes4(1) == bytes4(0)) {
1275             return false;
1276           }
1277     // Check the unregistering scheme has enough permissions:
1278         require(bytes4(0x1F)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1279 
1280     // Unregister:
1281         emit UnregisterScheme(msg.sender, _scheme);
1282         delete schemes[_scheme];
1283         return true;
1284     }
1285 
1286     /**
1287      * @dev unregister the caller's scheme
1288      * @return bool which represents a success
1289      */
1290     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1291         if (_isSchemeRegistered(msg.sender,_avatar) == false) {
1292             return false;
1293         }
1294         delete schemes[msg.sender];
1295         emit UnregisterScheme(msg.sender, msg.sender);
1296         return true;
1297     }
1298 
1299     function isSchemeRegistered(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bool) {
1300         return _isSchemeRegistered(_scheme,_avatar);
1301     }
1302 
1303     function getSchemeParameters(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes32) {
1304         return schemes[_scheme].paramsHash;
1305     }
1306 
1307     function getSchemePermissions(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes4) {
1308         return schemes[_scheme].permissions;
1309     }
1310 
1311     function getGlobalConstraintParameters(address _globalConstraint,address) external view returns(bytes32) {
1312 
1313         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
1314 
1315         if (register.isRegistered) {
1316             return globalConstraintsPre[register.index].params;
1317         }
1318 
1319         register = globalConstraintsRegisterPost[_globalConstraint];
1320 
1321         if (register.isRegistered) {
1322             return globalConstraintsPost[register.index].params;
1323         }
1324     }
1325 
1326    /**
1327     * @dev globalConstraintsCount return the global constraint pre and post count
1328     * @return uint globalConstraintsPre count.
1329     * @return uint globalConstraintsPost count.
1330     */
1331     function globalConstraintsCount(address _avatar)
1332         external
1333         isAvatarValid(_avatar)
1334         view
1335         returns(uint,uint)
1336         {
1337         return (globalConstraintsPre.length,globalConstraintsPost.length);
1338     }
1339 
1340     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar)
1341         external
1342         isAvatarValid(_avatar)
1343         view
1344         returns(bool)
1345         {
1346         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered || globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1347     }
1348 
1349     /**
1350      * @dev add or update Global Constraint
1351      * @param _globalConstraint the address of the global constraint to be added.
1352      * @param _params the constraint parameters hash.
1353      * @return bool which represents a success
1354      */
1355     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
1356     external
1357     onlyGlobalConstraintsScheme
1358     isAvatarValid(_avatar)
1359     returns(bool)
1360     {
1361         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1362         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1363             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1364                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint,_params));
1365                 globalConstraintsRegisterPre[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPre.length-1);
1366             }else {
1367                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1368             }
1369         }
1370         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1371             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1372                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint,_params));
1373                 globalConstraintsRegisterPost[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPost.length-1);
1374             }else {
1375                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1376             }
1377         }
1378         emit AddGlobalConstraint(_globalConstraint, _params,when);
1379         return true;
1380     }
1381 
1382     /**
1383      * @dev remove Global Constraint
1384      * @param _globalConstraint the address of the global constraint to be remove.
1385      * @return bool which represents a success
1386      */
1387     function removeGlobalConstraint (address _globalConstraint,address _avatar)
1388     external
1389     onlyGlobalConstraintsScheme
1390     isAvatarValid(_avatar)
1391     returns(bool)
1392     {
1393         GlobalConstraintRegister memory globalConstraintRegister;
1394         GlobalConstraint memory globalConstraint;
1395         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1396         bool retVal = false;
1397 
1398         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1399             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
1400             if (globalConstraintRegister.isRegistered) {
1401                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
1402                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
1403                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
1404                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1405                 }
1406                 globalConstraintsPre.length--;
1407                 delete globalConstraintsRegisterPre[_globalConstraint];
1408                 retVal = true;
1409             }
1410         }
1411         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1412             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
1413             if (globalConstraintRegister.isRegistered) {
1414                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
1415                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
1416                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
1417                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1418                 }
1419                 globalConstraintsPost.length--;
1420                 delete globalConstraintsRegisterPost[_globalConstraint];
1421                 retVal = true;
1422             }
1423         }
1424         if (retVal) {
1425             emit RemoveGlobalConstraint(_globalConstraint,globalConstraintRegister.index,when == GlobalConstraintInterface.CallPhase.Pre);
1426         }
1427         return retVal;
1428     }
1429 
1430   /**
1431     * @dev upgrade the Controller
1432     *      The function will trigger an event 'UpgradeController'.
1433     * @param  _newController the address of the new controller.
1434     * @return bool which represents a success
1435     */
1436     function upgradeController(address _newController,address _avatar)
1437     external
1438     onlyUpgradingScheme
1439     isAvatarValid(_avatar)
1440     returns(bool)
1441     {
1442         require(newController == address(0));   // so the upgrade could be done once for a contract.
1443         require(_newController != address(0));
1444         newController = _newController;
1445         avatar.transferOwnership(_newController);
1446         require(avatar.owner()==_newController);
1447         if (nativeToken.owner() == address(this)) {
1448             nativeToken.transferOwnership(_newController);
1449             require(nativeToken.owner()==_newController);
1450         }
1451         if (nativeReputation.owner() == address(this)) {
1452             nativeReputation.transferOwnership(_newController);
1453             require(nativeReputation.owner()==_newController);
1454         }
1455         emit UpgradeController(this,newController);
1456         return true;
1457     }
1458 
1459     /**
1460     * @dev perform a generic call to an arbitrary contract
1461     * @param _contract  the contract's address to call
1462     * @param _data ABI-encoded contract call to call `_contract` address.
1463     * @param _avatar the controller's avatar address
1464     * @return bytes32  - the return value of the called _contract's function.
1465     */
1466     function genericCall(address _contract,bytes _data,address _avatar)
1467     external
1468     onlyGenericCallScheme
1469     onlySubjectToConstraint("genericCall")
1470     isAvatarValid(_avatar)
1471     returns (bytes32)
1472     {
1473         emit GenericCall(_contract, _data);
1474         avatar.genericCall(_contract, _data);
1475         // solium-disable-next-line security/no-inline-assembly
1476         assembly {
1477         // Copy the returned data.
1478         returndatacopy(0, 0, returndatasize)
1479         return(0, returndatasize)
1480         }
1481     }
1482 
1483   /**
1484    * @dev send some ether
1485    * @param _amountInWei the amount of ether (in Wei) to send
1486    * @param _to address of the beneficiary
1487    * @return bool which represents a success
1488    */
1489     function sendEther(uint _amountInWei, address _to,address _avatar)
1490     external
1491     onlyRegisteredScheme
1492     onlySubjectToConstraint("sendEther")
1493     isAvatarValid(_avatar)
1494     returns(bool)
1495     {
1496         emit SendEther(msg.sender, _amountInWei, _to);
1497         return avatar.sendEther(_amountInWei, _to);
1498     }
1499 
1500     /**
1501     * @dev send some amount of arbitrary ERC20 Tokens
1502     * @param _externalToken the address of the Token Contract
1503     * @param _to address of the beneficiary
1504     * @param _value the amount of ether (in Wei) to send
1505     * @return bool which represents a success
1506     */
1507     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1508     external
1509     onlyRegisteredScheme
1510     onlySubjectToConstraint("externalTokenTransfer")
1511     isAvatarValid(_avatar)
1512     returns(bool)
1513     {
1514         emit ExternalTokenTransfer(msg.sender, _externalToken, _to, _value);
1515         return avatar.externalTokenTransfer(_externalToken, _to, _value);
1516     }
1517 
1518     /**
1519     * @dev transfer token "from" address "to" address
1520     *      One must to approve the amount of tokens which can be spend from the
1521     *      "from" account.This can be done using externalTokenApprove.
1522     * @param _externalToken the address of the Token Contract
1523     * @param _from address of the account to send from
1524     * @param _to address of the beneficiary
1525     * @param _value the amount of ether (in Wei) to send
1526     * @return bool which represents a success
1527     */
1528     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1529     external
1530     onlyRegisteredScheme
1531     onlySubjectToConstraint("externalTokenTransferFrom")
1532     isAvatarValid(_avatar)
1533     returns(bool)
1534     {
1535         emit ExternalTokenTransferFrom(msg.sender, _externalToken, _from, _to, _value);
1536         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1537     }
1538 
1539     /**
1540     * @dev increase approval for the spender address to spend a specified amount of tokens
1541     *      on behalf of msg.sender.
1542     * @param _externalToken the address of the Token Contract
1543     * @param _spender address
1544     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1545     * @return bool which represents a success
1546     */
1547     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1548     external
1549     onlyRegisteredScheme
1550     onlySubjectToConstraint("externalTokenIncreaseApproval")
1551     isAvatarValid(_avatar)
1552     returns(bool)
1553     {
1554         emit ExternalTokenIncreaseApproval(msg.sender,_externalToken,_spender,_addedValue);
1555         return avatar.externalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
1556     }
1557 
1558     /**
1559     * @dev decrease approval for the spender address to spend a specified amount of tokens
1560     *      on behalf of msg.sender.
1561     * @param _externalToken the address of the Token Contract
1562     * @param _spender address
1563     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1564     * @return bool which represents a success
1565     */
1566     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1567     external
1568     onlyRegisteredScheme
1569     onlySubjectToConstraint("externalTokenDecreaseApproval")
1570     isAvatarValid(_avatar)
1571     returns(bool)
1572     {
1573         emit ExternalTokenDecreaseApproval(msg.sender,_externalToken,_spender,_subtractedValue);
1574         return avatar.externalTokenDecreaseApproval(_externalToken, _spender, _subtractedValue);
1575     }
1576 
1577     /**
1578      * @dev getNativeReputation
1579      * @param _avatar the organization avatar.
1580      * @return organization native reputation
1581      */
1582     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
1583         return address(nativeReputation);
1584     }
1585 
1586     function _isSchemeRegistered(address _scheme,address _avatar) private isAvatarValid(_avatar) view returns(bool) {
1587         return (schemes[_scheme].permissions&bytes4(1) != bytes4(0));
1588     }
1589 }
1590 
1591 // File: contracts/universalSchemes/ExecutableInterface.sol
1592 
1593 contract ExecutableInterface {
1594     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool);
1595 }
1596 
1597 // File: contracts/VotingMachines/IntVoteInterface.sol
1598 
1599 interface IntVoteInterface {
1600     //When implementing this interface please do not only override function and modifier,
1601     //but also to keep the modifiers on the overridden functions.
1602     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
1603     modifier votable(bytes32 _proposalId) {revert(); _;}
1604 
1605     event NewProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _numOfChoices, address _proposer, bytes32 _paramsHash);
1606     event ExecuteProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _decision, uint _totalReputation);
1607     event VoteProposal(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter, uint _vote, uint _reputation);
1608     event CancelProposal(bytes32 indexed _proposalId, address indexed _avatar );
1609     event CancelVoting(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter);
1610 
1611     /**
1612      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1613      * generated by calculating keccak256 of a incremented counter.
1614      * @param _numOfChoices number of voting choices
1615      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
1616      * @param _avatar an address to be sent as the payload to the _executable contract.
1617      * @param _executable This contract will be executed when vote is over.
1618      * @param _proposer address
1619      * @return proposal's id.
1620      */
1621     function propose(
1622         uint _numOfChoices,
1623         bytes32 _proposalParameters,
1624         address _avatar,
1625         ExecutableInterface _executable,
1626         address _proposer
1627         ) external returns(bytes32);
1628 
1629     // Only owned proposals and only the owner:
1630     function cancelProposal(bytes32 _proposalId) external returns(bool);
1631 
1632     // Only owned proposals and only the owner:
1633     function ownerVote(bytes32 _proposalId, uint _vote, address _voter) external returns(bool);
1634 
1635     function vote(bytes32 _proposalId, uint _vote) external returns(bool);
1636 
1637     function voteWithSpecifiedAmounts(
1638         bytes32 _proposalId,
1639         uint _vote,
1640         uint _rep,
1641         uint _token) external returns(bool);
1642 
1643     function cancelVote(bytes32 _proposalId) external;
1644 
1645     //@dev execute check if the proposal has been decided, and if so, execute the proposal
1646     //@param _proposalId the id of the proposal
1647     //@return bool true - the proposal has been executed
1648     //             false - otherwise.
1649     function execute(bytes32 _proposalId) external returns(bool);
1650 
1651     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint);
1652 
1653     function isVotable(bytes32 _proposalId) external view returns(bool);
1654 
1655     /**
1656      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1657      * @param _proposalId the ID of the proposal
1658      * @param _choice the index in the
1659      * @return voted reputation for the given choice
1660      */
1661     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint);
1662 
1663     /**
1664      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1665      * @return bool true or false
1666      */
1667     function isAbstainAllow() external pure returns(bool);
1668 
1669     /**
1670      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1671      * @return min - minimum number of choices
1672                max - maximum number of choices
1673      */
1674     function getAllowedRangeOfChoices() external pure returns(uint min,uint max);
1675 }
1676 
1677 // File: contracts/universalSchemes/UniversalSchemeInterface.sol
1678 
1679 contract UniversalSchemeInterface {
1680 
1681     function updateParameters(bytes32 _hashedParameters) public;
1682 
1683     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
1684 }
1685 
1686 // File: contracts/universalSchemes/UniversalScheme.sol
1687 
1688 contract UniversalScheme is Ownable, UniversalSchemeInterface {
1689     bytes32 public hashedParameters; // For other parameters.
1690 
1691     function updateParameters(
1692         bytes32 _hashedParameters
1693     )
1694         public
1695         onlyOwner
1696     {
1697         hashedParameters = _hashedParameters;
1698     }
1699 
1700     /**
1701     *  @dev get the parameters for the current scheme from the controller
1702     */
1703     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1704         return ControllerInterface(_avatar.owner()).getSchemeParameters(this,address(_avatar));
1705     }
1706 }
1707 
1708 // File: contracts/libs/RealMath.sol
1709 
1710 /**
1711  * RealMath: fixed-point math library, based on fractional and integer parts.
1712  * Using int256 as real216x40, which isn't in Solidity yet.
1713  * 40 fractional bits gets us down to 1E-12 precision, while still letting us
1714  * go up to galaxy scale counting in meters.
1715  * Internally uses the wider int256 for some math.
1716  *
1717  * Note that for addition, subtraction, and mod (%), you should just use the
1718  * built-in Solidity operators. Functions for these operations are not provided.
1719  *
1720  * Note that the fancy functions like sqrt, atan2, etc. aren't as accurate as
1721  * they should be. They are (hopefully) Good Enough for doing orbital mechanics
1722  * on block timescales in a game context, but they may not be good enough for
1723  * other applications.
1724  */
1725 
1726 
1727 library RealMath {
1728 
1729     /**
1730      * How many total bits are there?
1731      */
1732     int256 constant REAL_BITS = 256;
1733 
1734     /**
1735      * How many fractional bits are there?
1736      */
1737     int256 constant REAL_FBITS = 40;
1738 
1739     /**
1740      * How many integer bits are there?
1741      */
1742     int256 constant REAL_IBITS = REAL_BITS - REAL_FBITS;
1743 
1744     /**
1745      * What's the first non-fractional bit
1746      */
1747     int256 constant REAL_ONE = int256(1) << REAL_FBITS;
1748 
1749     /**
1750      * What's the last fractional bit?
1751      */
1752     int256 constant REAL_HALF = REAL_ONE >> 1;
1753 
1754     /**
1755      * What's two? Two is pretty useful.
1756      */
1757     int256 constant REAL_TWO = REAL_ONE << 1;
1758 
1759     /**
1760      * And our logarithms are based on ln(2).
1761      */
1762     int256 constant REAL_LN_TWO = 762123384786;
1763 
1764     /**
1765      * It is also useful to have Pi around.
1766      */
1767     int256 constant REAL_PI = 3454217652358;
1768 
1769     /**
1770      * And half Pi, to save on divides.
1771      * TODO: That might not be how the compiler handles constants.
1772      */
1773     int256 constant REAL_HALF_PI = 1727108826179;
1774 
1775     /**
1776      * And two pi, which happens to be odd in its most accurate representation.
1777      */
1778     int256 constant REAL_TWO_PI = 6908435304715;
1779 
1780     /**
1781      * What's the sign bit?
1782      */
1783     int256 constant SIGN_MASK = int256(1) << 255;
1784 
1785 
1786     /**
1787      * Convert an integer to a real. Preserves sign.
1788      */
1789     function toReal(int216 ipart) internal pure returns (int256) {
1790         return int256(ipart) * REAL_ONE;
1791     }
1792 
1793     /**
1794      * Convert a real to an integer. Preserves sign.
1795      */
1796     function fromReal(int256 realValue) internal pure returns (int216) {
1797         return int216(realValue / REAL_ONE);
1798     }
1799 
1800     /**
1801      * Round a real to the nearest integral real value.
1802      */
1803     function round(int256 realValue) internal pure returns (int256) {
1804         // First, truncate.
1805         int216 ipart = fromReal(realValue);
1806         if ((fractionalBits(realValue) & (uint40(1) << (REAL_FBITS - 1))) > 0) {
1807             // High fractional bit is set. Round up.
1808             if (realValue < int256(0)) {
1809                 // Rounding up for a negative number is rounding down.
1810                 ipart -= 1;
1811             } else {
1812                 ipart += 1;
1813             }
1814         }
1815         return toReal(ipart);
1816     }
1817 
1818     /**
1819      * Get the absolute value of a real. Just the same as abs on a normal int256.
1820      */
1821     function abs(int256 realValue) internal pure returns (int256) {
1822         if (realValue > 0) {
1823             return realValue;
1824         } else {
1825             return -realValue;
1826         }
1827     }
1828 
1829     /**
1830      * Returns the fractional bits of a real. Ignores the sign of the real.
1831      */
1832     function fractionalBits(int256 realValue) internal pure returns (uint40) {
1833         return uint40(abs(realValue) % REAL_ONE);
1834     }
1835 
1836     /**
1837      * Get the fractional part of a real, as a real. Ignores sign (so fpart(-0.5) is 0.5).
1838      */
1839     function fpart(int256 realValue) internal pure returns (int256) {
1840         // This gets the fractional part but strips the sign
1841         return abs(realValue) % REAL_ONE;
1842     }
1843 
1844     /**
1845      * Get the fractional part of a real, as a real. Respects sign (so fpartSigned(-0.5) is -0.5).
1846      */
1847     function fpartSigned(int256 realValue) internal pure returns (int256) {
1848         // This gets the fractional part but strips the sign
1849         int256 fractional = fpart(realValue);
1850         if (realValue < 0) {
1851             // Add the negative sign back in.
1852             return -fractional;
1853         } else {
1854             return fractional;
1855         }
1856     }
1857 
1858     /**
1859      * Get the integer part of a fixed point value.
1860      */
1861     function ipart(int256 realValue) internal pure returns (int256) {
1862         // Subtract out the fractional part to get the real part.
1863         return realValue - fpartSigned(realValue);
1864     }
1865 
1866     /**
1867      * Multiply one real by another. Truncates overflows.
1868      */
1869     function mul(int256 realA, int256 realB) internal pure returns (int256) {
1870         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
1871         // So we just have to clip off the extra REAL_FBITS fractional bits.
1872         return int256((int256(realA) * int256(realB)) >> REAL_FBITS);
1873     }
1874 
1875     /**
1876      * Divide one real by another real. Truncates overflows.
1877      */
1878     function div(int256 realNumerator, int256 realDenominator) internal pure returns (int256) {
1879         // We use the reverse of the multiplication trick: convert numerator from
1880         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
1881         return int256((int256(realNumerator) * REAL_ONE) / int256(realDenominator));
1882     }
1883 
1884     /**
1885      * Create a real from a rational fraction.
1886      */
1887     function fraction(int216 numerator, int216 denominator) internal pure returns (int256) {
1888         return div(toReal(numerator), toReal(denominator));
1889     }
1890 
1891     // Now we have some fancy math things (like pow and trig stuff). This isn't
1892     // in the RealMath that was deployed with the original Macroverse
1893     // deployment, so it needs to be linked into your contract statically.
1894 
1895     /**
1896      * Raise a number to a positive integer power in O(log power) time.
1897      * See <https://stackoverflow.com/a/101613>
1898      */
1899     function ipow(int256 realBase, int216 exponent) internal pure returns (int256) {
1900         if (exponent < 0) {
1901             // Negative powers are not allowed here.
1902             revert();
1903         }
1904 
1905         int256 tempRealBase = realBase;
1906         int256 tempExponent = exponent;
1907 
1908         // Start with the 0th power
1909         int256 realResult = REAL_ONE;
1910         while (tempExponent != 0) {
1911             // While there are still bits set
1912             if ((tempExponent & 0x1) == 0x1) {
1913                 // If the low bit is set, multiply in the (many-times-squared) base
1914                 realResult = mul(realResult, tempRealBase);
1915             }
1916             // Shift off the low bit
1917             tempExponent = tempExponent >> 1;
1918             // Do the squaring
1919             tempRealBase = mul(tempRealBase, tempRealBase);
1920         }
1921 
1922         // Return the final result.
1923         return realResult;
1924     }
1925 
1926     /**
1927      * Zero all but the highest set bit of a number.
1928      * See <https://stackoverflow.com/a/53184>
1929      */
1930     function hibit(uint256 _val) internal pure returns (uint256) {
1931         // Set all the bits below the highest set bit
1932         uint256 val = _val;
1933         val |= (val >> 1);
1934         val |= (val >> 2);
1935         val |= (val >> 4);
1936         val |= (val >> 8);
1937         val |= (val >> 16);
1938         val |= (val >> 32);
1939         val |= (val >> 64);
1940         val |= (val >> 128);
1941         return val ^ (val >> 1);
1942     }
1943 
1944     /**
1945      * Given a number with one bit set, finds the index of that bit.
1946      */
1947     function findbit(uint256 val) internal pure returns (uint8 index) {
1948         index = 0;
1949         // We and the value with alternating bit patters of various pitches to find it.
1950         if (val & 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA != 0) {
1951             // Picth 1
1952             index |= 1;
1953         }
1954         if (val & 0xCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC != 0) {
1955             // Pitch 2
1956             index |= 2;
1957         }
1958         if (val & 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0 != 0) {
1959             // Pitch 4
1960             index |= 4;
1961         }
1962         if (val & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00 != 0) {
1963             // Pitch 8
1964             index |= 8;
1965         }
1966         if (val & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000 != 0) {
1967             // Pitch 16
1968             index |= 16;
1969         }
1970         if (val & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000 != 0) {
1971             // Pitch 32
1972             index |= 32;
1973         }
1974         if (val & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000 != 0) {
1975             // Pitch 64
1976             index |= 64;
1977         }
1978         if (val & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000 != 0) {
1979             // Pitch 128
1980             index |= 128;
1981         }
1982     }
1983 
1984     /**
1985      * Shift realArg left or right until it is between 1 and 2. Return the
1986      * rescaled value, and the number of bits of right shift applied. Shift may be negative.
1987      *
1988      * Expresses realArg as realScaled * 2^shift, setting shift to put realArg between [1 and 2).
1989      *
1990      * Rejects 0 or negative arguments.
1991      */
1992     function rescale(int256 realArg) internal pure returns (int256 realScaled, int216 shift) {
1993         if (realArg <= 0) {
1994             // Not in domain!
1995             revert();
1996         }
1997 
1998         // Find the high bit
1999         int216 highBit = findbit(hibit(uint256(realArg)));
2000 
2001         // We'll shift so the high bit is the lowest non-fractional bit.
2002         shift = highBit - int216(REAL_FBITS);
2003 
2004         if (shift < 0) {
2005             // Shift left
2006             realScaled = realArg << -shift;
2007         } else if (shift >= 0) {
2008             // Shift right
2009             realScaled = realArg >> shift;
2010         }
2011     }
2012 
2013     /**
2014      * Calculate the natural log of a number. Rescales the input value and uses
2015      * the algorithm outlined at <https://math.stackexchange.com/a/977836> and
2016      * the ipow implementation.
2017      *
2018      * Lets you artificially limit the number of iterations.
2019      *
2020      * Note that it is potentially possible to get an un-converged value; lack
2021      * of convergence does not throw.
2022      */
2023     function lnLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
2024         if (realArg <= 0) {
2025             // Outside of acceptable domain
2026             revert();
2027         }
2028 
2029         if (realArg == REAL_ONE) {
2030             // Handle this case specially because people will want exactly 0 and
2031             // not ~2^-39 ish.
2032             return 0;
2033         }
2034 
2035         // We know it's positive, so rescale it to be between [1 and 2)
2036         int256 realRescaled;
2037         int216 shift;
2038         (realRescaled, shift) = rescale(realArg);
2039 
2040         // Compute the argument to iterate on
2041         int256 realSeriesArg = div(realRescaled - REAL_ONE, realRescaled + REAL_ONE);
2042 
2043         // We will accumulate the result here
2044         int256 realSeriesResult = 0;
2045 
2046         for (int216 n = 0; n < maxIterations; n++) {
2047             // Compute term n of the series
2048             int256 realTerm = div(ipow(realSeriesArg, 2 * n + 1), toReal(2 * n + 1));
2049             // And add it in
2050             realSeriesResult += realTerm;
2051             if (realTerm == 0) {
2052                 // We must have converged. Next term is too small to represent.
2053                 break;
2054             }
2055             // If we somehow never converge I guess we will run out of gas
2056         }
2057 
2058         // Double it to account for the factor of 2 outside the sum
2059         realSeriesResult = mul(realSeriesResult, REAL_TWO);
2060 
2061         // Now compute and return the overall result
2062         return mul(toReal(shift), REAL_LN_TWO) + realSeriesResult;
2063 
2064     }
2065 
2066     /**
2067      * Calculate a natural logarithm with a sensible maximum iteration count to
2068      * wait until convergence. Note that it is potentially possible to get an
2069      * un-converged value; lack of convergence does not throw.
2070      */
2071     function ln(int256 realArg) internal pure returns (int256) {
2072         return lnLimited(realArg, 100);
2073     }
2074 
2075     /**
2076      * Calculate e^x. Uses the series given at
2077      * <http://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap04/exp.html>.
2078      *
2079      * Lets you artificially limit the number of iterations.
2080      *
2081      * Note that it is potentially possible to get an un-converged value; lack
2082      * of convergence does not throw.
2083      */
2084     function expLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
2085         // We will accumulate the result here
2086         int256 realResult = 0;
2087 
2088         // We use this to save work computing terms
2089         int256 realTerm = REAL_ONE;
2090 
2091         for (int216 n = 0; n < maxIterations; n++) {
2092             // Add in the term
2093             realResult += realTerm;
2094 
2095             // Compute the next term
2096             realTerm = mul(realTerm, div(realArg, toReal(n + 1)));
2097 
2098             if (realTerm == 0) {
2099                 // We must have converged. Next term is too small to represent.
2100                 break;
2101             }
2102             // If we somehow never converge I guess we will run out of gas
2103         }
2104 
2105         // Return the result
2106         return realResult;
2107 
2108     }
2109 
2110     /**
2111      * Calculate e^x with a sensible maximum iteration count to wait until
2112      * convergence. Note that it is potentially possible to get an un-converged
2113      * value; lack of convergence does not throw.
2114      */
2115     function exp(int256 realArg) internal pure returns (int256) {
2116         return expLimited(realArg, 100);
2117     }
2118 
2119     /**
2120      * Raise any number to any power, except for negative bases to fractional powers.
2121      */
2122     function pow(int256 realBase, int256 realExponent) internal pure returns (int256) {
2123         if (realExponent == 0) {
2124             // Anything to the 0 is 1
2125             return REAL_ONE;
2126         }
2127 
2128         if (realBase == 0) {
2129             if (realExponent < 0) {
2130                 // Outside of domain!
2131                 revert();
2132             }
2133             // Otherwise it's 0
2134             return 0;
2135         }
2136 
2137         if (fpart(realExponent) == 0) {
2138             // Anything (even a negative base) is super easy to do to an integer power.
2139 
2140             if (realExponent > 0) {
2141                 // Positive integer power is easy
2142                 return ipow(realBase, fromReal(realExponent));
2143             } else {
2144                 // Negative integer power is harder
2145                 return div(REAL_ONE, ipow(realBase, fromReal(-realExponent)));
2146             }
2147         }
2148 
2149         if (realBase < 0) {
2150             // It's a negative base to a non-integer power.
2151             // In general pow(-x^y) is undefined, unless y is an int or some
2152             // weird rational-number-based relationship holds.
2153             revert();
2154         }
2155 
2156         // If it's not a special case, actually do it.
2157         return exp(mul(realExponent, ln(realBase)));
2158     }
2159 
2160     /**
2161      * Compute the square root of a number.
2162      */
2163     function sqrt(int256 realArg) internal pure returns (int256) {
2164         return pow(realArg, REAL_HALF);
2165     }
2166 
2167     /**
2168      * Compute the sin of a number to a certain number of Taylor series terms.
2169      */
2170     function sinLimited(int256 _realArg, int216 maxIterations) internal pure returns (int256) {
2171         // First bring the number into 0 to 2 pi
2172         // TODO: This will introduce an error for very large numbers, because the error in our Pi will compound.
2173         // But for actual reasonable angle values we should be fine.
2174         int256 realArg = _realArg;
2175         realArg = realArg % REAL_TWO_PI;
2176 
2177         int256 accumulator = REAL_ONE;
2178 
2179         // We sum from large to small iteration so that we can have higher powers in later terms
2180         for (int216 iteration = maxIterations - 1; iteration >= 0; iteration--) {
2181             accumulator = REAL_ONE - mul(div(mul(realArg, realArg), toReal((2 * iteration + 2) * (2 * iteration + 3))), accumulator);
2182             // We can't stop early; we need to make it to the first term.
2183         }
2184 
2185         return mul(realArg, accumulator);
2186     }
2187 
2188     /**
2189      * Calculate sin(x) with a sensible maximum iteration count to wait until
2190      * convergence.
2191      */
2192     function sin(int256 realArg) internal pure returns (int256) {
2193         return sinLimited(realArg, 15);
2194     }
2195 
2196     /**
2197      * Calculate cos(x).
2198      */
2199     function cos(int256 realArg) internal pure returns (int256) {
2200         return sin(realArg + REAL_HALF_PI);
2201     }
2202 
2203     /**
2204      * Calculate tan(x). May overflow for large results. May throw if tan(x)
2205      * would be infinite, or return an approximation, or overflow.
2206      */
2207     function tan(int256 realArg) internal pure returns (int256) {
2208         return div(sin(realArg), cos(realArg));
2209     }
2210 }
2211 
2212 // File: openzeppelin-solidity/contracts/ECRecovery.sol
2213 
2214 /**
2215  * @title Eliptic curve signature operations
2216  *
2217  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
2218  *
2219  * TODO Remove this library once solidity supports passing a signature to ecrecover.
2220  * See https://github.com/ethereum/solidity/issues/864
2221  *
2222  */
2223 
2224 library ECRecovery {
2225 
2226   /**
2227    * @dev Recover signer address from a message by using their signature
2228    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
2229    * @param sig bytes signature, the signature is generated using web3.eth.sign()
2230    */
2231   function recover(bytes32 hash, bytes sig)
2232     internal
2233     pure
2234     returns (address)
2235   {
2236     bytes32 r;
2237     bytes32 s;
2238     uint8 v;
2239 
2240     // Check the signature length
2241     if (sig.length != 65) {
2242       return (address(0));
2243     }
2244 
2245     // Divide the signature in r, s and v variables
2246     // ecrecover takes the signature parameters, and the only way to get them
2247     // currently is to use assembly.
2248     // solium-disable-next-line security/no-inline-assembly
2249     assembly {
2250       r := mload(add(sig, 32))
2251       s := mload(add(sig, 64))
2252       v := byte(0, mload(add(sig, 96)))
2253     }
2254 
2255     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
2256     if (v < 27) {
2257       v += 27;
2258     }
2259 
2260     // If the version is correct return the signer address
2261     if (v != 27 && v != 28) {
2262       return (address(0));
2263     } else {
2264       // solium-disable-next-line arg-overflow
2265       return ecrecover(hash, v, r, s);
2266     }
2267   }
2268 
2269   /**
2270    * toEthSignedMessageHash
2271    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
2272    * @dev and hash the result
2273    */
2274   function toEthSignedMessageHash(bytes32 hash)
2275     internal
2276     pure
2277     returns (bytes32)
2278   {
2279     // 32 is the length in bytes of hash,
2280     // enforced by the type signature above
2281     return keccak256(
2282       "\x19Ethereum Signed Message:\n32",
2283       hash
2284     );
2285   }
2286 }
2287 
2288 // File: contracts/libs/OrderStatisticTree.sol
2289 
2290 library OrderStatisticTree {
2291 
2292     struct Node {
2293         mapping (bool => uint) children; // a mapping of left(false) child and right(true) child nodes
2294         uint parent; // parent node
2295         bool side;   // side of the node on the tree (left or right)
2296         uint height; //Height of this node
2297         uint count; //Number of tree nodes below this node (including this one)
2298         uint dupes; //Number of duplicates values for this node
2299     }
2300 
2301     struct Tree {
2302         // a mapping between node value(uint) to Node
2303         // the tree's root is always at node 0 ,which points to the "real" tree
2304         // as its right child.this is done to eliminate the need to update the tree
2305         // root in the case of rotation.(saving gas).
2306         mapping(uint => Node) nodes;
2307     }
2308     /**
2309      * @dev rank - find the rank of a value in the tree,
2310      *      i.e. its index in the sorted list of elements of the tree
2311      * @param _tree the tree
2312      * @param _value the input value to find its rank.
2313      * @return smaller - the number of elements in the tree which their value is
2314      * less than the input value.
2315      */
2316     function rank(Tree storage _tree,uint _value) internal view returns (uint smaller) {
2317         if (_value != 0) {
2318             smaller = _tree.nodes[0].dupes;
2319 
2320             uint cur = _tree.nodes[0].children[true];
2321             Node storage currentNode = _tree.nodes[cur];
2322 
2323             while (true) {
2324                 if (cur <= _value) {
2325                     if (cur<_value) {
2326                         smaller = smaller + 1+currentNode.dupes;
2327                     }
2328                     uint leftChild = currentNode.children[false];
2329                     if (leftChild!=0) {
2330                         smaller = smaller + _tree.nodes[leftChild].count;
2331                     }
2332                 }
2333                 if (cur == _value) {
2334                     break;
2335                 }
2336                 cur = currentNode.children[cur<_value];
2337                 if (cur == 0) {
2338                     break;
2339                 }
2340                 currentNode = _tree.nodes[cur];
2341             }
2342         }
2343     }
2344 
2345     function count(Tree storage _tree) internal view returns (uint) {
2346         Node storage root = _tree.nodes[0];
2347         Node memory child = _tree.nodes[root.children[true]];
2348         return root.dupes+child.count;
2349     }
2350 
2351     function updateCount(Tree storage _tree,uint _value) private {
2352         Node storage n = _tree.nodes[_value];
2353         n.count = 1+_tree.nodes[n.children[false]].count+_tree.nodes[n.children[true]].count+n.dupes;
2354     }
2355 
2356     function updateCounts(Tree storage _tree,uint _value) private {
2357         uint parent = _tree.nodes[_value].parent;
2358         while (parent!=0) {
2359             updateCount(_tree,parent);
2360             parent = _tree.nodes[parent].parent;
2361         }
2362     }
2363 
2364     function updateHeight(Tree storage _tree,uint _value) private {
2365         Node storage n = _tree.nodes[_value];
2366         uint heightLeft = _tree.nodes[n.children[false]].height;
2367         uint heightRight = _tree.nodes[n.children[true]].height;
2368         if (heightLeft > heightRight)
2369             n.height = heightLeft+1;
2370         else
2371             n.height = heightRight+1;
2372     }
2373 
2374     function balanceFactor(Tree storage _tree,uint _value) private view returns (int bf) {
2375         Node storage n = _tree.nodes[_value];
2376         return int(_tree.nodes[n.children[false]].height)-int(_tree.nodes[n.children[true]].height);
2377     }
2378 
2379     function rotate(Tree storage _tree,uint _value,bool dir) private {
2380         bool otherDir = !dir;
2381         Node storage n = _tree.nodes[_value];
2382         bool side = n.side;
2383         uint parent = n.parent;
2384         uint valueNew = n.children[otherDir];
2385         Node storage nNew = _tree.nodes[valueNew];
2386         uint orphan = nNew.children[dir];
2387         Node storage p = _tree.nodes[parent];
2388         Node storage o = _tree.nodes[orphan];
2389         p.children[side] = valueNew;
2390         nNew.side = side;
2391         nNew.parent = parent;
2392         nNew.children[dir] = _value;
2393         n.parent = valueNew;
2394         n.side = dir;
2395         n.children[otherDir] = orphan;
2396         o.parent = _value;
2397         o.side = otherDir;
2398         updateHeight(_tree,_value);
2399         updateHeight(_tree,valueNew);
2400         updateCount(_tree,_value);
2401         updateCount(_tree,valueNew);
2402     }
2403 
2404     function rebalanceInsert(Tree storage _tree,uint _nValue) private {
2405         updateHeight(_tree,_nValue);
2406         Node storage n = _tree.nodes[_nValue];
2407         uint pValue = n.parent;
2408         if (pValue!=0) {
2409             int pBf = balanceFactor(_tree,pValue);
2410             bool side = n.side;
2411             int sign;
2412             if (side)
2413                 sign = -1;
2414             else
2415                 sign = 1;
2416             if (pBf == sign*2) {
2417                 if (balanceFactor(_tree,_nValue) == (-1 * sign)) {
2418                     rotate(_tree,_nValue,side);
2419                 }
2420                 rotate(_tree,pValue,!side);
2421             } else if (pBf != 0) {
2422                 rebalanceInsert(_tree,pValue);
2423             }
2424         }
2425     }
2426 
2427     function rebalanceDelete(Tree storage _tree,uint _pValue,bool side) private {
2428         if (_pValue!=0) {
2429             updateHeight(_tree,_pValue);
2430             int pBf = balanceFactor(_tree,_pValue);
2431             int sign;
2432             if (side)
2433                 sign = 1;
2434             else
2435                 sign = -1;
2436             int bf = balanceFactor(_tree,_pValue);
2437             if (bf==(2*sign)) {
2438                 Node storage p = _tree.nodes[_pValue];
2439                 uint sValue = p.children[!side];
2440                 int sBf = balanceFactor(_tree,sValue);
2441                 if (sBf == (-1 * sign)) {
2442                     rotate(_tree,sValue,!side);
2443                 }
2444                 rotate(_tree,_pValue,side);
2445                 if (sBf!=0) {
2446                     p = _tree.nodes[_pValue];
2447                     rebalanceDelete(_tree,p.parent,p.side);
2448                 }
2449             } else if (pBf != sign) {
2450                 p = _tree.nodes[_pValue];
2451                 rebalanceDelete(_tree,p.parent,p.side);
2452             }
2453         }
2454     }
2455 
2456     function fixParents(Tree storage _tree,uint parent,bool side) private {
2457         if (parent!=0) {
2458             updateCount(_tree,parent);
2459             updateCounts(_tree,parent);
2460             rebalanceDelete(_tree,parent,side);
2461         }
2462     }
2463 
2464     function insertHelper(Tree storage _tree,uint _pValue,bool _side,uint _value) private {
2465         Node storage root = _tree.nodes[_pValue];
2466         uint cValue = root.children[_side];
2467         if (cValue==0) {
2468             root.children[_side] = _value;
2469             Node storage child = _tree.nodes[_value];
2470             child.parent = _pValue;
2471             child.side = _side;
2472             child.height = 1;
2473             child.count = 1;
2474             updateCounts(_tree,_value);
2475             rebalanceInsert(_tree,_value);
2476         } else if (cValue==_value) {
2477             _tree.nodes[cValue].dupes++;
2478             updateCount(_tree,_value);
2479             updateCounts(_tree,_value);
2480         } else {
2481             insertHelper(_tree,cValue,(_value >= cValue),_value);
2482         }
2483     }
2484 
2485     function insert(Tree storage _tree,uint _value) internal {
2486         if (_value==0) {
2487             _tree.nodes[_value].dupes++;
2488         } else {
2489             insertHelper(_tree,0,true,_value);
2490         }
2491     }
2492 
2493     function rightmostLeaf(Tree storage _tree,uint _value) private view returns (uint leaf) {
2494         uint child = _tree.nodes[_value].children[true];
2495         if (child!=0) {
2496             return rightmostLeaf(_tree,child);
2497         } else {
2498             return _value;
2499         }
2500     }
2501 
2502     function zeroOut(Tree storage _tree,uint _value) private {
2503         Node storage n = _tree.nodes[_value];
2504         n.parent = 0;
2505         n.side = false;
2506         n.children[false] = 0;
2507         n.children[true] = 0;
2508         n.count = 0;
2509         n.height = 0;
2510         n.dupes = 0;
2511     }
2512 
2513     function removeBranch(Tree storage _tree,uint _value,uint _left) private {
2514         uint ipn = rightmostLeaf(_tree,_left);
2515         Node storage i = _tree.nodes[ipn];
2516         uint dupes = i.dupes;
2517         removeHelper(_tree,ipn);
2518         Node storage n = _tree.nodes[_value];
2519         uint parent = n.parent;
2520         Node storage p = _tree.nodes[parent];
2521         uint height = n.height;
2522         bool side = n.side;
2523         uint ncount = n.count;
2524         uint right = n.children[true];
2525         uint left = n.children[false];
2526         p.children[side] = ipn;
2527         i.parent = parent;
2528         i.side = side;
2529         i.count = ncount+dupes-n.dupes;
2530         i.height = height;
2531         i.dupes = dupes;
2532         if (left!=0) {
2533             i.children[false] = left;
2534             _tree.nodes[left].parent = ipn;
2535         }
2536         if (right!=0) {
2537             i.children[true] = right;
2538             _tree.nodes[right].parent = ipn;
2539         }
2540         zeroOut(_tree,_value);
2541         updateCounts(_tree,ipn);
2542     }
2543 
2544     function removeHelper(Tree storage _tree,uint _value) private {
2545         Node storage n = _tree.nodes[_value];
2546         uint parent = n.parent;
2547         bool side = n.side;
2548         Node storage p = _tree.nodes[parent];
2549         uint left = n.children[false];
2550         uint right = n.children[true];
2551         if ((left == 0) && (right == 0)) {
2552             p.children[side] = 0;
2553             zeroOut(_tree,_value);
2554             fixParents(_tree,parent,side);
2555         } else if ((left != 0) && (right != 0)) {
2556             removeBranch(_tree,_value,left);
2557         } else {
2558             uint child = left+right;
2559             Node storage c = _tree.nodes[child];
2560             p.children[side] = child;
2561             c.parent = parent;
2562             c.side = side;
2563             zeroOut(_tree,_value);
2564             fixParents(_tree,parent,side);
2565         }
2566     }
2567 
2568     function remove(Tree storage _tree,uint _value) internal {
2569         Node storage n = _tree.nodes[_value];
2570         if (_value==0) {
2571             if (n.dupes==0) {
2572                 return;
2573             }
2574         } else {
2575             if (n.count==0) {
2576                 return;
2577             }
2578         }
2579         if (n.dupes>0) {
2580             n.dupes--;
2581             if (_value!=0) {
2582                 n.count--;
2583             }
2584             fixParents(_tree,n.parent,n.side);
2585         } else {
2586             removeHelper(_tree,_value);
2587         }
2588     }
2589 
2590 }
2591 
2592 // File: contracts/VotingMachines/GenesisProtocol.sol
2593 
2594 /**
2595  * @title GenesisProtocol implementation -an organization's voting machine scheme.
2596  */
2597 
2598 
2599 contract GenesisProtocol is IntVoteInterface,UniversalScheme {
2600     using SafeMath for uint;
2601     using RealMath for int216;
2602     using RealMath for int256;
2603     using ECRecovery for bytes32;
2604     using OrderStatisticTree for OrderStatisticTree.Tree;
2605 
2606     enum ProposalState { None ,Closed, Executed, PreBoosted,Boosted,QuietEndingPeriod }
2607     enum ExecutionState { None, PreBoostedTimeOut, PreBoostedBarCrossed, BoostedTimeOut,BoostedBarCrossed }
2608 
2609     //Organization's parameters
2610     struct Parameters {
2611         uint preBoostedVoteRequiredPercentage; // the absolute vote percentages bar.
2612         uint preBoostedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
2613         uint boostedVotePeriodLimit; //the time limit for a proposal to be in an relative voting mode.
2614         uint thresholdConstA;//constant A for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
2615         uint thresholdConstB;//constant B for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
2616         uint minimumStakingFee; //minimum staking fee allowed.
2617         uint quietEndingPeriod; //quite ending period
2618         uint proposingRepRewardConstA;//constant A for calculate proposer reward. proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
2619         uint proposingRepRewardConstB;//constant B for calculate proposing reward.proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
2620         uint stakerFeeRatioForVoters; // The “ratio of stake” to be paid to voters.
2621                                       // All stakers pay a portion of their stake to all voters, stakerFeeRatioForVoters * (s+ + s-).
2622                                       //All voters (pre and during boosting period) divide this portion in proportion to their reputation.
2623         uint votersReputationLossRatio;//Unsuccessful pre booster voters lose votersReputationLossRatio% of their reputation.
2624         uint votersGainRepRatioFromLostRep; //the percentages of the lost reputation which is divided by the successful pre boosted voters,
2625                                             //in proportion to their reputation.
2626                                             //The rest (100-votersGainRepRatioFromLostRep)% of lost reputation is divided between the successful wagers,
2627                                             //in proportion to their stake.
2628         uint daoBountyConst;//The DAO adds up a bounty for successful staker.
2629                             //The bounty formula is: s * daoBountyConst, where s+ is the wager staked for the proposal,
2630                             //and  daoBountyConst is a constant factor that is configurable and changeable by the DAO given.
2631                             //  daoBountyConst should be greater than stakerFeeRatioForVoters and less than 2 * stakerFeeRatioForVoters.
2632         uint daoBountyLimit;//The daoBounty cannot be greater than daoBountyLimit.
2633 
2634 
2635 
2636     }
2637     struct Voter {
2638         uint vote; // YES(1) ,NO(2)
2639         uint reputation; // amount of voter's reputation
2640         bool preBoosted;
2641     }
2642 
2643     struct Staker {
2644         uint vote; // YES(1) ,NO(2)
2645         uint amount; // amount of staker's stake
2646         uint amountForBounty; // amount of staker's stake which will be use for bounty calculation
2647     }
2648 
2649     struct Proposal {
2650         address avatar; // the organization's avatar the proposal is target to.
2651         uint numOfChoices;
2652         ExecutableInterface executable; // will be executed if the proposal will pass
2653         uint votersStakes;
2654         uint submittedTime;
2655         uint boostedPhaseTime; //the time the proposal shift to relative mode.
2656         ProposalState state;
2657         uint winningVote; //the winning vote.
2658         address proposer;
2659         uint currentBoostedVotePeriodLimit;
2660         bytes32 paramsHash;
2661         uint daoBountyRemain;
2662         uint[2] totalStakes;// totalStakes[0] - (amount staked minus fee) - Total number of tokens staked which can be redeemable by stakers.
2663                             // totalStakes[1] - (amount staked) - Total number of redeemable tokens.
2664         //      vote      reputation
2665         mapping(uint    =>  uint     ) votes;
2666         //      vote      reputation
2667         mapping(uint    =>  uint     ) preBoostedVotes;
2668         //      address     voter
2669         mapping(address =>  Voter    ) voters;
2670         //      vote        stakes
2671         mapping(uint    =>  uint     ) stakes;
2672         //      address  staker
2673         mapping(address  => Staker   ) stakers;
2674     }
2675 
2676     event GPExecuteProposal(bytes32 indexed _proposalId, ExecutionState _executionState);
2677     event Stake(bytes32 indexed _proposalId, address indexed _avatar, address indexed _staker,uint _vote,uint _amount);
2678     event Redeem(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2679     event RedeemDaoBounty(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2680     event RedeemReputation(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
2681 
2682     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
2683     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
2684 
2685     mapping(bytes=>bool) stakeSignatures; //stake signatures
2686 
2687     uint constant public NUM_OF_CHOICES = 2;
2688     uint constant public NO = 2;
2689     uint constant public YES = 1;
2690     uint public proposalsCnt; // Total number of proposals
2691     mapping(address=>uint) orgBoostedProposalsCnt;
2692     StandardToken public stakingToken;
2693     mapping(address=>OrderStatisticTree.Tree) proposalsExpiredTimes; //proposals expired times
2694 
2695     /**
2696      * @dev Constructor
2697      */
2698     constructor(StandardToken _stakingToken) public
2699     {
2700         stakingToken = _stakingToken;
2701     }
2702 
2703   /**
2704    * @dev Check that the proposal is votable (open and not executed yet)
2705    */
2706     modifier votable(bytes32 _proposalId) {
2707         require(_isVotable(_proposalId));
2708         _;
2709     }
2710 
2711     /**
2712      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
2713      * generated by calculating keccak256 of a incremented counter.
2714      * @param _numOfChoices number of voting choices
2715      * @param _avatar an address to be sent as the payload to the _executable contract.
2716      * @param _executable This contract will be executed when vote is over.
2717      * @param _proposer address
2718      * @return proposal's id.
2719      */
2720     function propose(uint _numOfChoices, bytes32 , address _avatar, ExecutableInterface _executable,address _proposer)
2721         external
2722         returns(bytes32)
2723     {
2724           // Check valid params and number of choices:
2725         require(_numOfChoices == NUM_OF_CHOICES);
2726         require(ExecutableInterface(_executable) != address(0));
2727         //Check parameters existence.
2728         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
2729 
2730         require(parameters[paramsHash].preBoostedVoteRequiredPercentage > 0);
2731         // Generate a unique ID:
2732         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
2733         proposalsCnt++;
2734         // Open proposal:
2735         Proposal memory proposal;
2736         proposal.numOfChoices = _numOfChoices;
2737         proposal.avatar = _avatar;
2738         proposal.executable = _executable;
2739         proposal.state = ProposalState.PreBoosted;
2740         // solium-disable-next-line security/no-block-members
2741         proposal.submittedTime = now;
2742         proposal.currentBoostedVotePeriodLimit = parameters[paramsHash].boostedVotePeriodLimit;
2743         proposal.proposer = _proposer;
2744         proposal.winningVote = NO;
2745         proposal.paramsHash = paramsHash;
2746         proposals[proposalId] = proposal;
2747         emit NewProposal(proposalId, _avatar, _numOfChoices, _proposer, paramsHash);
2748         return proposalId;
2749     }
2750 
2751   /**
2752    * @dev Cancel a proposal, only the owner can call this function and only if allowOwner flag is true.
2753    */
2754     function cancelProposal(bytes32 ) external returns(bool) {
2755         //This is not allowed.
2756         return false;
2757     }
2758 
2759     /**
2760      * @dev staking function
2761      * @param _proposalId id of the proposal
2762      * @param _vote  NO(2) or YES(1).
2763      * @param _amount the betting amount
2764      * @return bool true - the proposal has been executed
2765      *              false - otherwise.
2766      */
2767     function stake(bytes32 _proposalId, uint _vote, uint _amount) external returns(bool) {
2768         return _stake(_proposalId,_vote,_amount,msg.sender);
2769     }
2770 
2771     // Digest describing the data the user signs according EIP 712.
2772     // Needs to match what is passed to Metamask.
2773     bytes32 public constant DELEGATION_HASH_EIP712 =
2774     keccak256(abi.encodePacked("address GenesisProtocolAddress","bytes32 ProposalId", "uint Vote","uint AmountToStake","uint Nonce"));
2775     // web3.eth.sign prefix
2776     string public constant ETH_SIGN_PREFIX= "\x19Ethereum Signed Message:\n32";
2777 
2778     /**
2779      * @dev stakeWithSignature function
2780      * @param _proposalId id of the proposal
2781      * @param _vote  NO(2) or YES(1).
2782      * @param _amount the betting amount
2783      * @param _nonce nonce value ,it is part of the signature to ensure that
2784               a signature can be received only once.
2785      * @param _signatureType signature type
2786               1 - for web3.eth.sign
2787               2 - for eth_signTypedData according to EIP #712.
2788      * @param _signature  - signed data by the staker
2789      * @return bool true - the proposal has been executed
2790      *              false - otherwise.
2791      */
2792     function stakeWithSignature(
2793         bytes32 _proposalId,
2794         uint _vote,
2795         uint _amount,
2796         uint _nonce,
2797         uint _signatureType,
2798         bytes _signature
2799         )
2800         external
2801         returns(bool)
2802         {
2803         require(stakeSignatures[_signature] == false);
2804         // Recreate the digest the user signed
2805         bytes32 delegationDigest;
2806         if (_signatureType == 2) {
2807             delegationDigest = keccak256(
2808                 abi.encodePacked(
2809                     DELEGATION_HASH_EIP712, keccak256(
2810                         abi.encodePacked(
2811                            address(this),
2812                           _proposalId,
2813                           _vote,
2814                           _amount,
2815                           _nonce)))
2816             );
2817         } else {
2818             delegationDigest = keccak256(
2819                 abi.encodePacked(
2820                     ETH_SIGN_PREFIX, keccak256(
2821                         abi.encodePacked(
2822                             address(this),
2823                            _proposalId,
2824                            _vote,
2825                            _amount,
2826                            _nonce)))
2827             );
2828         }
2829         address staker = delegationDigest.recover(_signature);
2830         //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
2831         require(staker!=address(0));
2832         stakeSignatures[_signature] = true;
2833         return _stake(_proposalId,_vote,_amount,staker);
2834     }
2835 
2836   /**
2837    * @dev voting function
2838    * @param _proposalId id of the proposal
2839    * @param _vote NO(2) or YES(1).
2840    * @return bool true - the proposal has been executed
2841    *              false - otherwise.
2842    */
2843     function vote(bytes32 _proposalId, uint _vote) external votable(_proposalId) returns(bool) {
2844         return internalVote(_proposalId, msg.sender, _vote, 0);
2845     }
2846 
2847   /**
2848    * @dev voting function with owner functionality (can vote on behalf of someone else)
2849    * @return bool true - the proposal has been executed
2850    *              false - otherwise.
2851    */
2852     function ownerVote(bytes32 , uint , address ) external returns(bool) {
2853       //This is not allowed.
2854         return false;
2855     }
2856 
2857     function voteWithSpecifiedAmounts(bytes32 _proposalId,uint _vote,uint _rep,uint) external votable(_proposalId) returns(bool) {
2858         return internalVote(_proposalId,msg.sender,_vote,_rep);
2859     }
2860 
2861   /**
2862    * @dev Cancel the vote of the msg.sender.
2863    * cancel vote is not allow in genesisProtocol so this function doing nothing.
2864    * This function is here in order to comply to the IntVoteInterface .
2865    */
2866     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
2867        //this is not allowed
2868         return;
2869     }
2870 
2871   /**
2872     * @dev getNumberOfChoices returns the number of choices possible in this proposal
2873     * @param _proposalId the ID of the proposals
2874     * @return uint that contains number of choices
2875     */
2876     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint) {
2877         return proposals[_proposalId].numOfChoices;
2878     }
2879 
2880     /**
2881      * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
2882      * @param _proposalId the ID of the proposal
2883      * @param _voter the address of the voter
2884      * @return uint vote - the voters vote
2885      *        uint reputation - amount of reputation committed by _voter to _proposalId
2886      */
2887     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
2888         Voter memory voter = proposals[_proposalId].voters[_voter];
2889         return (voter.vote, voter.reputation);
2890     }
2891 
2892     /**
2893     * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
2894     * @param _proposalId the ID of the proposal
2895     * @param _choice the index in the
2896     * @return voted reputation for the given choice
2897     */
2898     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint) {
2899         return proposals[_proposalId].votes[_choice];
2900     }
2901 
2902     /**
2903     * @dev isVotable check if the proposal is votable
2904     * @param _proposalId the ID of the proposal
2905     * @return bool true or false
2906     */
2907     function isVotable(bytes32 _proposalId) external view returns(bool) {
2908         return _isVotable(_proposalId);
2909     }
2910 
2911     /**
2912     * @dev proposalStatus return the total votes and stakes for a given proposal
2913     * @param _proposalId the ID of the proposal
2914     * @return uint preBoostedVotes YES
2915     * @return uint preBoostedVotes NO
2916     * @return uint stakersStakes
2917     * @return uint totalRedeemableStakes
2918     * @return uint total stakes YES
2919     * @return uint total stakes NO
2920     */
2921     function proposalStatus(bytes32 _proposalId) external view returns(uint, uint, uint ,uint, uint ,uint) {
2922         return (
2923                 proposals[_proposalId].preBoostedVotes[YES],
2924                 proposals[_proposalId].preBoostedVotes[NO],
2925                 proposals[_proposalId].totalStakes[0],
2926                 proposals[_proposalId].totalStakes[1],
2927                 proposals[_proposalId].stakes[YES],
2928                 proposals[_proposalId].stakes[NO]
2929         );
2930     }
2931 
2932   /**
2933     * @dev proposalAvatar return the avatar for a given proposal
2934     * @param _proposalId the ID of the proposal
2935     * @return uint total reputation supply
2936     */
2937     function proposalAvatar(bytes32 _proposalId) external view returns(address) {
2938         return (proposals[_proposalId].avatar);
2939     }
2940 
2941   /**
2942     * @dev scoreThresholdParams return the score threshold params for a given
2943     * organization.
2944     * @param _avatar the organization's avatar
2945     * @return uint thresholdConstA
2946     * @return uint thresholdConstB
2947     */
2948     function scoreThresholdParams(address _avatar) external view returns(uint,uint) {
2949         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
2950         Parameters memory params = parameters[paramsHash];
2951         return (params.thresholdConstA,params.thresholdConstB);
2952     }
2953 
2954     /**
2955       * @dev getStaker return the vote and stake amount for a given proposal and staker
2956       * @param _proposalId the ID of the proposal
2957       * @param _staker staker address
2958       * @return uint vote
2959       * @return uint amount
2960     */
2961     function getStaker(bytes32 _proposalId,address _staker) external view returns(uint,uint) {
2962         return (proposals[_proposalId].stakers[_staker].vote,proposals[_proposalId].stakers[_staker].amount);
2963     }
2964 
2965     /**
2966       * @dev state return the state for a given proposal
2967       * @param _proposalId the ID of the proposal
2968       * @return ProposalState proposal state
2969     */
2970     function state(bytes32 _proposalId) external view returns(ProposalState) {
2971         return proposals[_proposalId].state;
2972     }
2973 
2974     /**
2975     * @dev winningVote return the winningVote for a given proposal
2976     * @param _proposalId the ID of the proposal
2977     * @return uint winningVote
2978     */
2979     function winningVote(bytes32 _proposalId) external view returns(uint) {
2980         return proposals[_proposalId].winningVote;
2981     }
2982 
2983    /**
2984     * @dev isAbstainAllow returns if the voting machine allow abstain (0)
2985     * @return bool true or false
2986     */
2987     function isAbstainAllow() external pure returns(bool) {
2988         return false;
2989     }
2990 
2991     /**
2992      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
2993      * @return min - minimum number of choices
2994                max - maximum number of choices
2995      */
2996     function getAllowedRangeOfChoices() external pure returns(uint min,uint max) {
2997         return (NUM_OF_CHOICES,NUM_OF_CHOICES);
2998     }
2999 
3000     /**
3001     * @dev execute check if the proposal has been decided, and if so, execute the proposal
3002     * @param _proposalId the id of the proposal
3003     * @return bool true - the proposal has been executed
3004     *              false - otherwise.
3005    */
3006     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
3007         return _execute(_proposalId);
3008     }
3009 
3010     /**
3011      * @dev redeem a reward for a successful stake, vote or proposing.
3012      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
3013      * users to redeem on behalf of someone else.
3014      * @param _proposalId the ID of the proposal
3015      * @param _beneficiary - the beneficiary address
3016      * @return rewards -
3017      *         rewards[0] - stakerTokenAmount
3018      *         rewards[1] - stakerReputationAmount
3019      *         rewards[2] - voterTokenAmount
3020      *         rewards[3] - voterReputationAmount
3021      *         rewards[4] - proposerReputationAmount
3022      * @return reputation - redeem reputation
3023      */
3024     function redeem(bytes32 _proposalId,address _beneficiary) public returns (uint[5] rewards) {
3025         Proposal storage proposal = proposals[_proposalId];
3026         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed),"wrong proposal state");
3027         Parameters memory params = parameters[proposal.paramsHash];
3028         uint amount;
3029         uint reputation;
3030         uint lostReputation;
3031         if (proposal.winningVote == YES) {
3032             lostReputation = proposal.preBoostedVotes[NO];
3033         } else {
3034             lostReputation = proposal.preBoostedVotes[YES];
3035         }
3036         lostReputation = (lostReputation * params.votersReputationLossRatio)/100;
3037         //as staker
3038         Staker storage staker = proposal.stakers[_beneficiary];
3039         if ((staker.amount>0) &&
3040              (staker.vote == proposal.winningVote)) {
3041             uint totalWinningStakes = proposal.stakes[proposal.winningVote];
3042             if (totalWinningStakes != 0) {
3043                 rewards[0] = (staker.amount * proposal.totalStakes[0]) / totalWinningStakes;
3044             }
3045             if (proposal.state != ProposalState.Closed) {
3046                 rewards[1] = (staker.amount * ( lostReputation - ((lostReputation * params.votersGainRepRatioFromLostRep)/100)))/proposal.stakes[proposal.winningVote];
3047             }
3048             staker.amount = 0;
3049         }
3050         //as voter
3051         Voter storage voter = proposal.voters[_beneficiary];
3052         if ((voter.reputation != 0 ) && (voter.preBoosted)) {
3053             uint preBoostedVotes = proposal.preBoostedVotes[YES] + proposal.preBoostedVotes[NO];
3054             if (preBoostedVotes>0) {
3055                 rewards[2] = ((proposal.votersStakes * voter.reputation) / preBoostedVotes);
3056             }
3057             if (proposal.state == ProposalState.Closed) {
3058               //give back reputation for the voter
3059                 rewards[3] = ((voter.reputation * params.votersReputationLossRatio)/100);
3060             } else if (proposal.winningVote == voter.vote ) {
3061                 rewards[3] = (((voter.reputation * params.votersReputationLossRatio)/100) +
3062                 (((voter.reputation * lostReputation * params.votersGainRepRatioFromLostRep)/100)/preBoostedVotes));
3063             }
3064             voter.reputation = 0;
3065         }
3066         //as proposer
3067         if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == YES)&&(proposal.proposer != address(0))) {
3068             rewards[4] = (params.proposingRepRewardConstA.mul(proposal.votes[YES]+proposal.votes[NO]) + params.proposingRepRewardConstB.mul(proposal.votes[YES]-proposal.votes[NO]))/1000;
3069             proposal.proposer = 0;
3070         }
3071         amount = rewards[0] + rewards[2];
3072         reputation = rewards[1] + rewards[3] + rewards[4];
3073         if (amount != 0) {
3074             proposal.totalStakes[1] = proposal.totalStakes[1].sub(amount);
3075             require(stakingToken.transfer(_beneficiary, amount));
3076             emit Redeem(_proposalId,proposal.avatar,_beneficiary,amount);
3077         }
3078         if (reputation != 0 ) {
3079             ControllerInterface(Avatar(proposal.avatar).owner()).mintReputation(reputation,_beneficiary,proposal.avatar);
3080             emit RedeemReputation(_proposalId,proposal.avatar,_beneficiary,reputation);
3081         }
3082     }
3083 
3084     /**
3085      * @dev redeemDaoBounty a reward for a successful stake, vote or proposing.
3086      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
3087      * users to redeem on behalf of someone else.
3088      * @param _proposalId the ID of the proposal
3089      * @param _beneficiary - the beneficiary address
3090      * @return redeemedAmount - redeem token amount
3091      * @return potentialAmount - potential redeem token amount(if there is enough tokens bounty at the avatar )
3092      */
3093     function redeemDaoBounty(bytes32 _proposalId,address _beneficiary) public returns(uint redeemedAmount,uint potentialAmount) {
3094         Proposal storage proposal = proposals[_proposalId];
3095         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed));
3096         uint totalWinningStakes = proposal.stakes[proposal.winningVote];
3097         if (
3098           // solium-disable-next-line operator-whitespace
3099             (proposal.stakers[_beneficiary].amountForBounty>0)&&
3100             (proposal.stakers[_beneficiary].vote == proposal.winningVote)&&
3101             (proposal.winningVote == YES)&&
3102             (totalWinningStakes != 0))
3103         {
3104             //as staker
3105             Parameters memory params = parameters[proposal.paramsHash];
3106             uint beneficiaryLimit = (proposal.stakers[_beneficiary].amountForBounty.mul(params.daoBountyLimit)) / totalWinningStakes;
3107             potentialAmount = (params.daoBountyConst.mul(proposal.stakers[_beneficiary].amountForBounty))/100;
3108             if (potentialAmount > beneficiaryLimit) {
3109                 potentialAmount = beneficiaryLimit;
3110             }
3111         }
3112         if ((potentialAmount != 0)&&(stakingToken.balanceOf(proposal.avatar) >= potentialAmount)) {
3113             proposal.daoBountyRemain = proposal.daoBountyRemain.sub(potentialAmount);
3114             require(ControllerInterface(Avatar(proposal.avatar).owner()).externalTokenTransfer(stakingToken,_beneficiary,potentialAmount,proposal.avatar));
3115             proposal.stakers[_beneficiary].amountForBounty = 0;
3116             redeemedAmount = potentialAmount;
3117             emit RedeemDaoBounty(_proposalId,proposal.avatar,_beneficiary,redeemedAmount);
3118         }
3119     }
3120 
3121     /**
3122      * @dev shouldBoost check if a proposal should be shifted to boosted phase.
3123      * @param _proposalId the ID of the proposal
3124      * @return bool true or false.
3125      */
3126     function shouldBoost(bytes32 _proposalId) public view returns(bool) {
3127         Proposal memory proposal = proposals[_proposalId];
3128         return (_score(_proposalId) >= threshold(proposal.paramsHash,proposal.avatar));
3129     }
3130 
3131     /**
3132      * @dev score return the proposal score
3133      * @param _proposalId the ID of the proposal
3134      * @return uint proposal score.
3135      */
3136     function score(bytes32 _proposalId) public view returns(int) {
3137         return _score(_proposalId);
3138     }
3139 
3140     /**
3141      * @dev getBoostedProposalsCount return the number of boosted proposal for an organization
3142      * @param _avatar the organization avatar
3143      * @return uint number of boosted proposals
3144      */
3145     function getBoostedProposalsCount(address _avatar) public view returns(uint) {
3146         uint expiredProposals;
3147         if (proposalsExpiredTimes[_avatar].count() != 0) {
3148           // solium-disable-next-line security/no-block-members
3149             expiredProposals = proposalsExpiredTimes[_avatar].rank(now);
3150         }
3151         return orgBoostedProposalsCnt[_avatar].sub(expiredProposals);
3152     }
3153 
3154     /**
3155      * @dev threshold return the organization's score threshold which required by
3156      * a proposal to shift to boosted state.
3157      * This threshold is dynamically set and it depend on the number of boosted proposal.
3158      * @param _avatar the organization avatar
3159      * @param _paramsHash the organization parameters hash
3160      * @return int organization's score threshold.
3161      */
3162     function threshold(bytes32 _paramsHash,address _avatar) public view returns(int) {
3163         uint boostedProposals = getBoostedProposalsCount(_avatar);
3164         int216 e = 2;
3165 
3166         Parameters memory params = parameters[_paramsHash];
3167         require(params.thresholdConstB > 0,"should be a valid parameter hash");
3168         int256 power = int216(boostedProposals).toReal().div(int216(params.thresholdConstB).toReal());
3169 
3170         if (power.fromReal() > 100 ) {
3171             power = int216(100).toReal();
3172         }
3173         int256 res = int216(params.thresholdConstA).toReal().mul(e.toReal().pow(power));
3174         return res.fromReal();
3175     }
3176 
3177     /**
3178      * @dev hash the parameters, save them if necessary, and return the hash value
3179      * @param _params a parameters array
3180      *    _params[0] - _preBoostedVoteRequiredPercentage,
3181      *    _params[1] - _preBoostedVotePeriodLimit, //the time limit for a proposal to be in an absolute voting mode.
3182      *    _params[2] -_boostedVotePeriodLimit, //the time limit for a proposal to be in an relative voting mode.
3183      *    _params[3] -_thresholdConstA
3184      *    _params[4] -_thresholdConstB
3185      *    _params[5] -_minimumStakingFee
3186      *    _params[6] -_quietEndingPeriod
3187      *    _params[7] -_proposingRepRewardConstA
3188      *    _params[8] -_proposingRepRewardConstB
3189      *    _params[9] -_stakerFeeRatioForVoters
3190      *    _params[10] -_votersReputationLossRatio
3191      *    _params[11] -_votersGainRepRatioFromLostRep
3192      *    _params[12] - _daoBountyConst
3193      *    _params[13] - _daoBountyLimit
3194     */
3195     function setParameters(
3196         uint[14] _params //use array here due to stack too deep issue.
3197     )
3198     public
3199     returns(bytes32)
3200     {
3201         require(_params[0] <= 100 && _params[0] > 0,"0 < preBoostedVoteRequiredPercentage <= 100");
3202         require(_params[4] > 0 && _params[4] <= 100000000,"0 < thresholdConstB < 100000000 ");
3203         require(_params[3] <= 100000000 ether,"thresholdConstA <= 100000000 wei");
3204         require(_params[9] <= 100,"stakerFeeRatioForVoters <= 100");
3205         require(_params[10] <= 100,"votersReputationLossRatio <= 100");
3206         require(_params[11] <= 100,"votersGainRepRatioFromLostRep <= 100");
3207         require(_params[2] >= _params[6],"boostedVotePeriodLimit >= quietEndingPeriod");
3208         require(_params[7] <= 100000000,"proposingRepRewardConstA <= 100000000");
3209         require(_params[8] <= 100000000,"proposingRepRewardConstB <= 100000000");
3210         require(_params[12] <= (2 * _params[9]),"daoBountyConst <= 2 * stakerFeeRatioForVoters");
3211         require(_params[12] >= _params[9],"daoBountyConst >= stakerFeeRatioForVoters");
3212 
3213 
3214         bytes32 paramsHash = getParametersHash(_params);
3215         parameters[paramsHash] = Parameters({
3216             preBoostedVoteRequiredPercentage: _params[0],
3217             preBoostedVotePeriodLimit: _params[1],
3218             boostedVotePeriodLimit: _params[2],
3219             thresholdConstA:_params[3],
3220             thresholdConstB:_params[4],
3221             minimumStakingFee: _params[5],
3222             quietEndingPeriod: _params[6],
3223             proposingRepRewardConstA: _params[7],
3224             proposingRepRewardConstB:_params[8],
3225             stakerFeeRatioForVoters:_params[9],
3226             votersReputationLossRatio:_params[10],
3227             votersGainRepRatioFromLostRep:_params[11],
3228             daoBountyConst:_params[12],
3229             daoBountyLimit:_params[13]
3230         });
3231         return paramsHash;
3232     }
3233 
3234   /**
3235    * @dev hashParameters returns a hash of the given parameters
3236    */
3237     function getParametersHash(
3238         uint[14] _params) //use array here due to stack too deep issue.
3239         public
3240         pure
3241         returns(bytes32)
3242         {
3243         return keccak256(
3244             abi.encodePacked(
3245             _params[0],
3246             _params[1],
3247             _params[2],
3248             _params[3],
3249             _params[4],
3250             _params[5],
3251             _params[6],
3252             _params[7],
3253             _params[8],
3254             _params[9],
3255             _params[10],
3256             _params[11],
3257             _params[12],
3258             _params[13]));
3259     }
3260 
3261     /**
3262     * @dev execute check if the proposal has been decided, and if so, execute the proposal
3263     * @param _proposalId the id of the proposal
3264     * @return bool true - the proposal has been executed
3265     *              false - otherwise.
3266    */
3267     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
3268         Proposal storage proposal = proposals[_proposalId];
3269         Parameters memory params = parameters[proposal.paramsHash];
3270         Proposal memory tmpProposal = proposal;
3271         uint totalReputation = Avatar(proposal.avatar).nativeReputation().totalSupply();
3272         uint executionBar = totalReputation * params.preBoostedVoteRequiredPercentage/100;
3273         ExecutionState executionState = ExecutionState.None;
3274 
3275         if (proposal.state == ProposalState.PreBoosted) {
3276             // solium-disable-next-line security/no-block-members
3277             if ((now - proposal.submittedTime) >= params.preBoostedVotePeriodLimit) {
3278                 proposal.state = ProposalState.Closed;
3279                 proposal.winningVote = NO;
3280                 executionState = ExecutionState.PreBoostedTimeOut;
3281              } else if (proposal.votes[proposal.winningVote] > executionBar) {
3282               // someone crossed the absolute vote execution bar.
3283                 proposal.state = ProposalState.Executed;
3284                 executionState = ExecutionState.PreBoostedBarCrossed;
3285                } else if ( shouldBoost(_proposalId)) {
3286                 //change proposal mode to boosted mode.
3287                 proposal.state = ProposalState.Boosted;
3288                 // solium-disable-next-line security/no-block-members
3289                 proposal.boostedPhaseTime = now;
3290                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3291                 orgBoostedProposalsCnt[proposal.avatar]++;
3292               }
3293            }
3294 
3295         if ((proposal.state == ProposalState.Boosted) ||
3296             (proposal.state == ProposalState.QuietEndingPeriod)) {
3297             // solium-disable-next-line security/no-block-members
3298             if ((now - proposal.boostedPhaseTime) >= proposal.currentBoostedVotePeriodLimit) {
3299                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3300                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
3301                 proposal.state = ProposalState.Executed;
3302                 executionState = ExecutionState.BoostedTimeOut;
3303              } else if (proposal.votes[proposal.winningVote] > executionBar) {
3304                // someone crossed the absolute vote execution bar.
3305                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
3306                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3307                 proposal.state = ProposalState.Executed;
3308                 executionState = ExecutionState.BoostedBarCrossed;
3309             }
3310        }
3311         if (executionState != ExecutionState.None) {
3312             if (proposal.winningVote == YES) {
3313                 uint daoBountyRemain = (params.daoBountyConst.mul(proposal.stakes[proposal.winningVote]))/100;
3314                 if (daoBountyRemain > params.daoBountyLimit) {
3315                     daoBountyRemain = params.daoBountyLimit;
3316                 }
3317                 proposal.daoBountyRemain = daoBountyRemain;
3318             }
3319             emit ExecuteProposal(_proposalId, proposal.avatar, proposal.winningVote, totalReputation);
3320             emit GPExecuteProposal(_proposalId, executionState);
3321             (tmpProposal.executable).execute(_proposalId, tmpProposal.avatar, int(proposal.winningVote));
3322         }
3323         return (executionState != ExecutionState.None);
3324     }
3325 
3326     /**
3327      * @dev staking function
3328      * @param _proposalId id of the proposal
3329      * @param _vote  NO(2) or YES(1).
3330      * @param _amount the betting amount
3331      * @param _staker the staker address
3332      * @return bool true - the proposal has been executed
3333      *              false - otherwise.
3334      */
3335     function _stake(bytes32 _proposalId, uint _vote, uint _amount,address _staker) internal returns(bool) {
3336         // 0 is not a valid vote.
3337 
3338         require(_vote <= NUM_OF_CHOICES && _vote > 0);
3339         require(_amount > 0);
3340         if (_execute(_proposalId)) {
3341             return true;
3342         }
3343 
3344         Proposal storage proposal = proposals[_proposalId];
3345 
3346         if (proposal.state != ProposalState.PreBoosted) {
3347             return false;
3348         }
3349 
3350         // enable to increase stake only on the previous stake vote
3351         Staker storage staker = proposal.stakers[_staker];
3352         if ((staker.amount > 0) && (staker.vote != _vote)) {
3353             return false;
3354         }
3355 
3356         uint amount = _amount;
3357         Parameters memory params = parameters[proposal.paramsHash];
3358         require(amount >= params.minimumStakingFee);
3359         require(stakingToken.transferFrom(_staker, address(this), amount));
3360         proposal.totalStakes[1] = proposal.totalStakes[1].add(amount); //update totalRedeemableStakes
3361         staker.amount += amount;
3362         staker.amountForBounty = staker.amount;
3363         staker.vote = _vote;
3364 
3365         proposal.votersStakes += (params.stakerFeeRatioForVoters * amount)/100;
3366         proposal.stakes[_vote] = amount.add(proposal.stakes[_vote]);
3367         amount = amount - ((params.stakerFeeRatioForVoters*amount)/100);
3368 
3369         proposal.totalStakes[0] = amount.add(proposal.totalStakes[0]);
3370       // Event:
3371         emit Stake(_proposalId, proposal.avatar, _staker, _vote, _amount);
3372       // execute the proposal if this vote was decisive:
3373         return _execute(_proposalId);
3374     }
3375 
3376     /**
3377      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
3378      * @param _proposalId id of the proposal
3379      * @param _voter used in case the vote is cast for someone else
3380      * @param _vote a value between 0 to and the proposal's number of choices.
3381      * @param _rep how many reputation the voter would like to stake for this vote.
3382      *         if  _rep==0 so the voter full reputation will be use.
3383      * @return true in case of proposal execution otherwise false
3384      * throws if proposal is not open or if it has been executed
3385      * NB: executes the proposal if a decision has been reached
3386      */
3387     function internalVote(bytes32 _proposalId, address _voter, uint _vote, uint _rep) internal returns(bool) {
3388         // 0 is not a valid vote.
3389         require(_vote <= NUM_OF_CHOICES && _vote > 0,"0 < _vote <= 2");
3390         if (_execute(_proposalId)) {
3391             return true;
3392         }
3393 
3394         Parameters memory params = parameters[proposals[_proposalId].paramsHash];
3395         Proposal storage proposal = proposals[_proposalId];
3396 
3397         // Check voter has enough reputation:
3398         uint reputation = Avatar(proposal.avatar).nativeReputation().reputationOf(_voter);
3399         require(reputation >= _rep);
3400         uint rep = _rep;
3401         if (rep == 0) {
3402             rep = reputation;
3403         }
3404         // If this voter has already voted, return false.
3405         if (proposal.voters[_voter].reputation != 0) {
3406             return false;
3407         }
3408         // The voting itself:
3409         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
3410         //check if the current winningVote changed or there is a tie.
3411         //for the case there is a tie the current winningVote set to NO.
3412         if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
3413            ((proposal.votes[NO] == proposal.votes[proposal.winningVote]) &&
3414              proposal.winningVote == YES))
3415         {
3416            // solium-disable-next-line security/no-block-members
3417             uint _now = now;
3418             if ((proposal.state == ProposalState.QuietEndingPeriod) ||
3419                ((proposal.state == ProposalState.Boosted) && ((_now - proposal.boostedPhaseTime) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod)))) {
3420                 //quietEndingPeriod
3421                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3422                 if (proposal.state != ProposalState.QuietEndingPeriod) {
3423                     proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
3424                     proposal.state = ProposalState.QuietEndingPeriod;
3425                 }
3426                 proposal.boostedPhaseTime = _now;
3427                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3428             }
3429             proposal.winningVote = _vote;
3430         }
3431         proposal.voters[_voter] = Voter({
3432             reputation: rep,
3433             vote: _vote,
3434             preBoosted:(proposal.state == ProposalState.PreBoosted)
3435         });
3436         if (proposal.state == ProposalState.PreBoosted) {
3437             proposal.preBoostedVotes[_vote] = rep.add(proposal.preBoostedVotes[_vote]);
3438             uint reputationDeposit = (params.votersReputationLossRatio * rep)/100;
3439             ControllerInterface(Avatar(proposal.avatar).owner()).burnReputation(reputationDeposit,_voter,proposal.avatar);
3440         }
3441         // Event:
3442         emit VoteProposal(_proposalId, proposal.avatar, _voter, _vote, rep);
3443         // execute the proposal if this vote was decisive:
3444         return _execute(_proposalId);
3445     }
3446 
3447     /**
3448      * @dev _score return the proposal score
3449      * For dual choice proposal S = (S+) - (S-)
3450      * @param _proposalId the ID of the proposal
3451      * @return int proposal score.
3452      */
3453     function _score(bytes32 _proposalId) private view returns(int) {
3454         Proposal storage proposal = proposals[_proposalId];
3455         return int(proposal.stakes[YES]) - int(proposal.stakes[NO]);
3456     }
3457 
3458     /**
3459       * @dev _isVotable check if the proposal is votable
3460       * @param _proposalId the ID of the proposal
3461       * @return bool true or false
3462     */
3463     function _isVotable(bytes32 _proposalId) private view returns(bool) {
3464         ProposalState pState = proposals[_proposalId].state;
3465         return ((pState == ProposalState.PreBoosted)||(pState == ProposalState.Boosted)||(pState == ProposalState.QuietEndingPeriod));
3466     }
3467 }