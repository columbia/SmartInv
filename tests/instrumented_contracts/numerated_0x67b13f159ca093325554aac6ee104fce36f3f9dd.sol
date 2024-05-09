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
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: contracts/controller/Reputation.sol
120 
121 /**
122  * @title Reputation system
123  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
124  * A reputation is use to assign influence measure to a DAO'S peers.
125  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
126  * The Reputation contract maintain a map of address to reputation value.
127  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
128  */
129 
130 contract Reputation is Ownable {
131     using SafeMath for uint;
132 
133     mapping (address => uint256) public balances;
134     uint256 public totalSupply;
135     uint public decimals = 18;
136 
137     // Event indicating minting of reputation to an address.
138     event Mint(address indexed _to, uint256 _amount);
139     // Event indicating burning of reputation for an address.
140     event Burn(address indexed _from, uint256 _amount);
141 
142     /**
143     * @dev return the reputation amount of a given owner
144     * @param _owner an address of the owner which we want to get his reputation
145     */
146     function reputationOf(address _owner) public view returns (uint256 balance) {
147         return balances[_owner];
148     }
149 
150     /**
151     * @dev Generates `_amount` of reputation that are assigned to `_to`
152     * @param _to The address that will be assigned the new reputation
153     * @param _amount The quantity of reputation to be generated
154     * @return True if the reputation are generated correctly
155     */
156     function mint(address _to, uint _amount)
157     public
158     onlyOwner
159     returns (bool)
160     {
161         totalSupply = totalSupply.add(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit Mint(_to, _amount);
164         return true;
165     }
166 
167     /**
168     * @dev Burns `_amount` of reputation from `_from`
169     * if _amount tokens to burn > balances[_from] the balance of _from will turn to zero.
170     * @param _from The address that will lose the reputation
171     * @param _amount The quantity of reputation to burn
172     * @return True if the reputation are burned correctly
173     */
174     function burn(address _from, uint _amount)
175     public
176     onlyOwner
177     returns (bool)
178     {
179         uint amountMinted = _amount;
180         if (balances[_from] < _amount) {
181             amountMinted = balances[_from];
182         }
183         totalSupply = totalSupply.sub(amountMinted);
184         balances[_from] = balances[_from].sub(amountMinted);
185         emit Burn(_from, amountMinted);
186         return true;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
191 
192 /**
193  * @title ERC20Basic
194  * @dev Simpler version of ERC20 interface
195  * See https://github.com/ethereum/EIPs/issues/179
196  */
197 contract ERC20Basic {
198   function totalSupply() public view returns (uint256);
199   function balanceOf(address who) public view returns (uint256);
200   function transfer(address to, uint256 value) public returns (bool);
201   event Transfer(address indexed from, address indexed to, uint256 value);
202 }
203 
204 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
205 
206 /**
207  * @title Basic token
208  * @dev Basic version of StandardToken, with no allowances.
209  */
210 contract BasicToken is ERC20Basic {
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) balances;
214 
215   uint256 totalSupply_;
216 
217   /**
218   * @dev Total number of tokens in existence
219   */
220   function totalSupply() public view returns (uint256) {
221     return totalSupply_;
222   }
223 
224   /**
225   * @dev Transfer token for a specified address
226   * @param _to The address to transfer to.
227   * @param _value The amount to be transferred.
228   */
229   function transfer(address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_value <= balances[msg.sender]);
232 
233     balances[msg.sender] = balances[msg.sender].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     emit Transfer(msg.sender, _to, _value);
236     return true;
237   }
238 
239   /**
240   * @dev Gets the balance of the specified address.
241   * @param _owner The address to query the the balance of.
242   * @return An uint256 representing the amount owned by the passed address.
243   */
244   function balanceOf(address _owner) public view returns (uint256) {
245     return balances[_owner];
246   }
247 
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
251 
252 /**
253  * @title ERC20 interface
254  * @dev see https://github.com/ethereum/EIPs/issues/20
255  */
256 contract ERC20 is ERC20Basic {
257   function allowance(address owner, address spender)
258     public view returns (uint256);
259 
260   function transferFrom(address from, address to, uint256 value)
261     public returns (bool);
262 
263   function approve(address spender, uint256 value) public returns (bool);
264   event Approval(
265     address indexed owner,
266     address indexed spender,
267     uint256 value
268   );
269 }
270 
271 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * https://github.com/ethereum/EIPs/issues/20
278  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281 
282   mapping (address => mapping (address => uint256)) internal allowed;
283 
284 
285   /**
286    * @dev Transfer tokens from one address to another
287    * @param _from address The address which you want to send tokens from
288    * @param _to address The address which you want to transfer to
289    * @param _value uint256 the amount of tokens to be transferred
290    */
291   function transferFrom(
292     address _from,
293     address _to,
294     uint256 _value
295   )
296     public
297     returns (bool)
298   {
299     require(_to != address(0));
300     require(_value <= balances[_from]);
301     require(_value <= allowed[_from][msg.sender]);
302 
303     balances[_from] = balances[_from].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
306     emit Transfer(_from, _to, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
312    * Beware that changing an allowance with this method brings the risk that someone may use both the old
313    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
314    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
315    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) public returns (bool) {
320     allowed[msg.sender][_spender] = _value;
321     emit Approval(msg.sender, _spender, _value);
322     return true;
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param _owner address The address which owns the funds.
328    * @param _spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(
332     address _owner,
333     address _spender
334    )
335     public
336     view
337     returns (uint256)
338   {
339     return allowed[_owner][_spender];
340   }
341 
342   /**
343    * @dev Increase the amount of tokens that an owner allowed to a spender.
344    * approve should be called when allowed[_spender] == 0. To increment
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _addedValue The amount of tokens to increase the allowance by.
350    */
351   function increaseApproval(
352     address _spender,
353     uint256 _addedValue
354   )
355     public
356     returns (bool)
357   {
358     allowed[msg.sender][_spender] = (
359       allowed[msg.sender][_spender].add(_addedValue));
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   /**
365    * @dev Decrease the amount of tokens that an owner allowed to a spender.
366    * approve should be called when allowed[_spender] == 0. To decrement
367    * allowed value is better to use this function to avoid 2 calls (and wait until
368    * the first transaction is mined)
369    * From MonolithDAO Token.sol
370    * @param _spender The address which will spend the funds.
371    * @param _subtractedValue The amount of tokens to decrease the allowance by.
372    */
373   function decreaseApproval(
374     address _spender,
375     uint256 _subtractedValue
376   )
377     public
378     returns (bool)
379   {
380     uint256 oldValue = allowed[msg.sender][_spender];
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
397  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
398  */
399 contract MintableToken is StandardToken, Ownable {
400   event Mint(address indexed to, uint256 amount);
401   event MintFinished();
402 
403   bool public mintingFinished = false;
404 
405 
406   modifier canMint() {
407     require(!mintingFinished);
408     _;
409   }
410 
411   modifier hasMintPermission() {
412     require(msg.sender == owner);
413     _;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param _to The address that will receive the minted tokens.
419    * @param _amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(
423     address _to,
424     uint256 _amount
425   )
426     hasMintPermission
427     canMint
428     public
429     returns (bool)
430   {
431     totalSupply_ = totalSupply_.add(_amount);
432     balances[_to] = balances[_to].add(_amount);
433     emit Mint(_to, _amount);
434     emit Transfer(address(0), _to, _amount);
435     return true;
436   }
437 
438   /**
439    * @dev Function to stop minting new tokens.
440    * @return True if the operation was successful.
441    */
442   function finishMinting() onlyOwner canMint public returns (bool) {
443     mintingFinished = true;
444     emit MintFinished();
445     return true;
446   }
447 }
448 
449 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
450 
451 /**
452  * @title Burnable Token
453  * @dev Token that can be irreversibly burned (destroyed).
454  */
455 contract BurnableToken is BasicToken {
456 
457   event Burn(address indexed burner, uint256 value);
458 
459   /**
460    * @dev Burns a specific amount of tokens.
461    * @param _value The amount of token to be burned.
462    */
463   function burn(uint256 _value) public {
464     _burn(msg.sender, _value);
465   }
466 
467   function _burn(address _who, uint256 _value) internal {
468     require(_value <= balances[_who]);
469     // no need to require value <= totalSupply, since that would imply the
470     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
471 
472     balances[_who] = balances[_who].sub(_value);
473     totalSupply_ = totalSupply_.sub(_value);
474     emit Burn(_who, _value);
475     emit Transfer(_who, address(0), _value);
476   }
477 }
478 
479 // File: contracts/token/ERC827/ERC827.sol
480 
481 /**
482  * @title ERC827 interface, an extension of ERC20 token standard
483  *
484  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
485  * methods to transfer value and data and execute calls in transfers and
486  * approvals.
487  */
488 contract ERC827 is ERC20 {
489 
490     function approveAndCall(address _spender,uint256 _value,bytes _data) public payable returns(bool);
491 
492     function transferAndCall(address _to,uint256 _value,bytes _data) public payable returns(bool);
493 
494     function transferFromAndCall(address _from,address _to,uint256 _value,bytes _data) public payable returns(bool);
495 
496 }
497 
498 // File: contracts/token/ERC827/ERC827Token.sol
499 
500 /* solium-disable security/no-low-level-calls */
501 
502 pragma solidity ^0.4.24;
503 
504 
505 
506 
507 /**
508  * @title ERC827, an extension of ERC20 token standard
509  *
510  * @dev Implementation the ERC827, following the ERC20 standard with extra
511  * methods to transfer value and data and execute calls in transfers and
512  * approvals. Uses OpenZeppelin StandardToken.
513  */
514 contract ERC827Token is ERC827, StandardToken {
515 
516   /**
517    * @dev Addition to ERC20 token methods. It allows to
518    * approve the transfer of value and execute a call with the sent data.
519    * Beware that changing an allowance with this method brings the risk that
520    * someone may use both the old and the new allowance by unfortunate
521    * transaction ordering. One possible solution to mitigate this race condition
522    * is to first reduce the spender's allowance to 0 and set the desired value
523    * afterwards:
524    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
525    * @param _spender The address that will spend the funds.
526    * @param _value The amount of tokens to be spent.
527    * @param _data ABI-encoded contract call to call `_spender` address.
528    * @return true if the call function was executed successfully
529    */
530     function approveAndCall(
531         address _spender,
532         uint256 _value,
533         bytes _data
534     )
535     public
536     payable
537     returns (bool)
538     {
539         require(_spender != address(this));
540 
541         super.approve(_spender, _value);
542 
543         // solium-disable-next-line security/no-call-value
544         require(_spender.call.value(msg.value)(_data));
545 
546         return true;
547     }
548 
549   /**
550    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
551    * address and execute a call with the sent data on the same transaction
552    * @param _to address The address which you want to transfer to
553    * @param _value uint256 the amout of tokens to be transfered
554    * @param _data ABI-encoded contract call to call `_to` address.
555    * @return true if the call function was executed successfully
556    */
557     function transferAndCall(
558         address _to,
559         uint256 _value,
560         bytes _data
561     )
562     public
563     payable
564     returns (bool)
565     {
566         require(_to != address(this));
567 
568         super.transfer(_to, _value);
569 
570         // solium-disable-next-line security/no-call-value
571         require(_to.call.value(msg.value)(_data));
572         return true;
573     }
574 
575   /**
576    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
577    * another and make a contract call on the same transaction
578    * @param _from The address which you want to send tokens from
579    * @param _to The address which you want to transfer to
580    * @param _value The amout of tokens to be transferred
581    * @param _data ABI-encoded contract call to call `_to` address.
582    * @return true if the call function was executed successfully
583    */
584     function transferFromAndCall(
585         address _from,
586         address _to,
587         uint256 _value,
588         bytes _data
589     )
590     public payable returns (bool)
591     {
592         require(_to != address(this));
593 
594         super.transferFrom(_from, _to, _value);
595 
596         // solium-disable-next-line security/no-call-value
597         require(_to.call.value(msg.value)(_data));
598         return true;
599     }
600 
601   /**
602    * @dev Addition to StandardToken methods. Increase the amount of tokens that
603    * an owner allowed to a spender and execute a call with the sent data.
604    * approve should be called when allowed[_spender] == 0. To increment
605    * allowed value is better to use this function to avoid 2 calls (and wait until
606    * the first transaction is mined)
607    * From MonolithDAO Token.sol
608    * @param _spender The address which will spend the funds.
609    * @param _addedValue The amount of tokens to increase the allowance by.
610    * @param _data ABI-encoded contract call to call `_spender` address.
611    */
612     function increaseApprovalAndCall(
613         address _spender,
614         uint _addedValue,
615         bytes _data
616     )
617     public
618     payable
619     returns (bool)
620     {
621         require(_spender != address(this));
622 
623         super.increaseApproval(_spender, _addedValue);
624 
625         // solium-disable-next-line security/no-call-value
626         require(_spender.call.value(msg.value)(_data));
627 
628         return true;
629     }
630 
631   /**
632    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
633    * an owner allowed to a spender and execute a call with the sent data.
634    * approve should be called when allowed[_spender] == 0. To decrement
635    * allowed value is better to use this function to avoid 2 calls (and wait until
636    * the first transaction is mined)
637    * From MonolithDAO Token.sol
638    * @param _spender The address which will spend the funds.
639    * @param _subtractedValue The amount of tokens to decrease the allowance by.
640    * @param _data ABI-encoded contract call to call `_spender` address.
641    */
642     function decreaseApprovalAndCall(
643         address _spender,
644         uint _subtractedValue,
645         bytes _data
646     )
647     public
648     payable
649     returns (bool)
650     {
651         require(_spender != address(this));
652 
653         super.decreaseApproval(_spender, _subtractedValue);
654 
655         // solium-disable-next-line security/no-call-value
656         require(_spender.call.value(msg.value)(_data));
657 
658         return true;
659     }
660 
661 }
662 
663 // File: contracts/controller/DAOToken.sol
664 
665 /**
666  * @title DAOToken, base on zeppelin contract.
667  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
668  */
669 
670 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
671 
672     string public name;
673     string public symbol;
674     // solium-disable-next-line uppercase
675     uint8 public constant decimals = 18;
676     uint public cap;
677 
678     /**
679     * @dev Constructor
680     * @param _name - token name
681     * @param _symbol - token symbol
682     * @param _cap - token cap - 0 value means no cap
683     */
684     constructor(string _name, string _symbol,uint _cap) public {
685         name = _name;
686         symbol = _symbol;
687         cap = _cap;
688     }
689 
690     /**
691      * @dev Function to mint tokens
692      * @param _to The address that will receive the minted tokens.
693      * @param _amount The amount of tokens to mint.
694      * @return A boolean that indicates if the operation was successful.
695      */
696     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
697         if (cap > 0)
698             require(totalSupply_.add(_amount) <= cap);
699         return super.mint(_to, _amount);
700     }
701 }
702 
703 // File: contracts/controller/Avatar.sol
704 
705 /**
706  * @title An Avatar holds tokens, reputation and ether for a controller
707  */
708 contract Avatar is Ownable {
709     bytes32 public orgName;
710     DAOToken public nativeToken;
711     Reputation public nativeReputation;
712 
713     event GenericAction(address indexed _action, bytes32[] _params);
714     event SendEther(uint _amountInWei, address indexed _to);
715     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
716     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
717     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
718     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
719     event ReceiveEther(address indexed _sender, uint _value);
720 
721     /**
722     * @dev the constructor takes organization name, native token and reputation system
723     and creates an avatar for a controller
724     */
725     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
726         orgName = _orgName;
727         nativeToken = _nativeToken;
728         nativeReputation = _nativeReputation;
729     }
730 
731     /**
732     * @dev enables an avatar to receive ethers
733     */
734     function() public payable {
735         emit ReceiveEther(msg.sender, msg.value);
736     }
737 
738     /**
739     * @dev perform a generic call to an arbitrary contract
740     * @param _contract  the contract's address to call
741     * @param _data ABI-encoded contract call to call `_contract` address.
742     * @return the return bytes of the called contract's function.
743     */
744     function genericCall(address _contract,bytes _data) public onlyOwner {
745         // solium-disable-next-line security/no-low-level-calls
746         bool result = _contract.call(_data);
747         // solium-disable-next-line security/no-inline-assembly
748         assembly {
749         // Copy the returned data.
750         returndatacopy(0, 0, returndatasize)
751 
752         switch result
753         // call returns 0 on error.
754         case 0 { revert(0, returndatasize) }
755         default { return(0, returndatasize) }
756         }
757     }
758 
759     /**
760     * @dev send ethers from the avatar's wallet
761     * @param _amountInWei amount to send in Wei units
762     * @param _to send the ethers to this address
763     * @return bool which represents success
764     */
765     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
766         _to.transfer(_amountInWei);
767         emit SendEther(_amountInWei, _to);
768         return true;
769     }
770 
771     /**
772     * @dev external token transfer
773     * @param _externalToken the token contract
774     * @param _to the destination address
775     * @param _value the amount of tokens to transfer
776     * @return bool which represents success
777     */
778     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
779     public onlyOwner returns(bool)
780     {
781         _externalToken.transfer(_to, _value);
782         emit ExternalTokenTransfer(_externalToken, _to, _value);
783         return true;
784     }
785 
786     /**
787     * @dev external token transfer from a specific account
788     * @param _externalToken the token contract
789     * @param _from the account to spend token from
790     * @param _to the destination address
791     * @param _value the amount of tokens to transfer
792     * @return bool which represents success
793     */
794     function externalTokenTransferFrom(
795         StandardToken _externalToken,
796         address _from,
797         address _to,
798         uint _value
799     )
800     public onlyOwner returns(bool)
801     {
802         _externalToken.transferFrom(_from, _to, _value);
803         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
804         return true;
805     }
806 
807     /**
808     * @dev increase approval for the spender address to spend a specified amount of tokens
809     *      on behalf of msg.sender.
810     * @param _externalToken the address of the Token Contract
811     * @param _spender address
812     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
813     * @return bool which represents a success
814     */
815     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
816     public onlyOwner returns(bool)
817     {
818         _externalToken.increaseApproval(_spender, _addedValue);
819         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
820         return true;
821     }
822 
823     /**
824     * @dev decrease approval for the spender address to spend a specified amount of tokens
825     *      on behalf of msg.sender.
826     * @param _externalToken the address of the Token Contract
827     * @param _spender address
828     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
829     * @return bool which represents a success
830     */
831     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
832     public onlyOwner returns(bool)
833     {
834         _externalToken.decreaseApproval(_spender, _subtractedValue);
835         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
836         return true;
837     }
838 
839 }
840 
841 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
842 
843 contract GlobalConstraintInterface {
844 
845     enum CallPhase { Pre, Post,PreAndPost }
846 
847     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
848     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
849     /**
850      * @dev when return if this globalConstraints is pre, post or both.
851      * @return CallPhase enum indication  Pre, Post or PreAndPost.
852      */
853     function when() public returns(CallPhase);
854 }
855 
856 // File: contracts/controller/ControllerInterface.sol
857 
858 /**
859  * @title Controller contract
860  * @dev A controller controls the organizations tokens ,reputation and avatar.
861  * It is subject to a set of schemes and constraints that determine its behavior.
862  * Each scheme has it own parameters and operation permissions.
863  */
864 interface ControllerInterface {
865 
866     /**
867      * @dev Mint `_amount` of reputation that are assigned to `_to` .
868      * @param  _amount amount of reputation to mint
869      * @param _to beneficiary address
870      * @return bool which represents a success
871     */
872     function mintReputation(uint256 _amount, address _to,address _avatar)
873     external
874     returns(bool);
875 
876     /**
877      * @dev Burns `_amount` of reputation from `_from`
878      * @param _amount amount of reputation to burn
879      * @param _from The address that will lose the reputation
880      * @return bool which represents a success
881      */
882     function burnReputation(uint256 _amount, address _from,address _avatar)
883     external
884     returns(bool);
885 
886     /**
887      * @dev mint tokens .
888      * @param  _amount amount of token to mint
889      * @param _beneficiary beneficiary address
890      * @param _avatar address
891      * @return bool which represents a success
892      */
893     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
894     external
895     returns(bool);
896 
897   /**
898    * @dev register or update a scheme
899    * @param _scheme the address of the scheme
900    * @param _paramsHash a hashed configuration of the usage of the scheme
901    * @param _permissions the permissions the new scheme will have
902    * @param _avatar address
903    * @return bool which represents a success
904    */
905     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
906     external
907     returns(bool);
908 
909     /**
910      * @dev unregister a scheme
911      * @param _avatar address
912      * @param _scheme the address of the scheme
913      * @return bool which represents a success
914      */
915     function unregisterScheme(address _scheme,address _avatar)
916     external
917     returns(bool);
918     /**
919      * @dev unregister the caller's scheme
920      * @param _avatar address
921      * @return bool which represents a success
922      */
923     function unregisterSelf(address _avatar) external returns(bool);
924 
925     function isSchemeRegistered( address _scheme,address _avatar) external view returns(bool);
926 
927     function getSchemeParameters(address _scheme,address _avatar) external view returns(bytes32);
928 
929     function getGlobalConstraintParameters(address _globalConstraint,address _avatar) external view returns(bytes32);
930 
931     function getSchemePermissions(address _scheme,address _avatar) external view returns(bytes4);
932 
933     /**
934      * @dev globalConstraintsCount return the global constraint pre and post count
935      * @return uint globalConstraintsPre count.
936      * @return uint globalConstraintsPost count.
937      */
938     function globalConstraintsCount(address _avatar) external view returns(uint,uint);
939 
940     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar) external view returns(bool);
941 
942     /**
943      * @dev add or update Global Constraint
944      * @param _globalConstraint the address of the global constraint to be added.
945      * @param _params the constraint parameters hash.
946      * @param _avatar the avatar of the organization
947      * @return bool which represents a success
948      */
949     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
950     external returns(bool);
951 
952     /**
953      * @dev remove Global Constraint
954      * @param _globalConstraint the address of the global constraint to be remove.
955      * @param _avatar the organization avatar.
956      * @return bool which represents a success
957      */
958     function removeGlobalConstraint (address _globalConstraint,address _avatar)
959     external  returns(bool);
960 
961   /**
962     * @dev upgrade the Controller
963     *      The function will trigger an event 'UpgradeController'.
964     * @param  _newController the address of the new controller.
965     * @param _avatar address
966     * @return bool which represents a success
967     */
968     function upgradeController(address _newController,address _avatar)
969     external returns(bool);
970 
971     /**
972     * @dev perform a generic call to an arbitrary contract
973     * @param _contract  the contract's address to call
974     * @param _data ABI-encoded contract call to call `_contract` address.
975     * @param _avatar the controller's avatar address
976     * @return bytes32  - the return value of the called _contract's function.
977     */
978     function genericCall(address _contract,bytes _data,address _avatar)
979     external
980     returns(bytes32);
981 
982   /**
983    * @dev send some ether
984    * @param _amountInWei the amount of ether (in Wei) to send
985    * @param _to address of the beneficiary
986    * @param _avatar address
987    * @return bool which represents a success
988    */
989     function sendEther(uint _amountInWei, address _to,address _avatar)
990     external returns(bool);
991 
992     /**
993     * @dev send some amount of arbitrary ERC20 Tokens
994     * @param _externalToken the address of the Token Contract
995     * @param _to address of the beneficiary
996     * @param _value the amount of ether (in Wei) to send
997     * @param _avatar address
998     * @return bool which represents a success
999     */
1000     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1001     external
1002     returns(bool);
1003 
1004     /**
1005     * @dev transfer token "from" address "to" address
1006     *      One must to approve the amount of tokens which can be spend from the
1007     *      "from" account.This can be done using externalTokenApprove.
1008     * @param _externalToken the address of the Token Contract
1009     * @param _from address of the account to send from
1010     * @param _to address of the beneficiary
1011     * @param _value the amount of ether (in Wei) to send
1012     * @param _avatar address
1013     * @return bool which represents a success
1014     */
1015     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1016     external
1017     returns(bool);
1018 
1019     /**
1020     * @dev increase approval for the spender address to spend a specified amount of tokens
1021     *      on behalf of msg.sender.
1022     * @param _externalToken the address of the Token Contract
1023     * @param _spender address
1024     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1025     * @param _avatar address
1026     * @return bool which represents a success
1027     */
1028     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1029     external
1030     returns(bool);
1031 
1032     /**
1033     * @dev decrease approval for the spender address to spend a specified amount of tokens
1034     *      on behalf of msg.sender.
1035     * @param _externalToken the address of the Token Contract
1036     * @param _spender address
1037     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1038     * @param _avatar address
1039     * @return bool which represents a success
1040     */
1041     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1042     external
1043     returns(bool);
1044 
1045     /**
1046      * @dev getNativeReputation
1047      * @param _avatar the organization avatar.
1048      * @return organization native reputation
1049      */
1050     function getNativeReputation(address _avatar)
1051     external
1052     view
1053     returns(address);
1054 }
1055 
1056 // File: contracts/controller/Controller.sol
1057 
1058 /**
1059  * @title Controller contract
1060  * @dev A controller controls the organizations tokens,reputation and avatar.
1061  * It is subject to a set of schemes and constraints that determine its behavior.
1062  * Each scheme has it own parameters and operation permissions.
1063  */
1064 contract Controller is ControllerInterface {
1065 
1066     struct Scheme {
1067         bytes32 paramsHash;  // a hash "configuration" of the scheme
1068         bytes4  permissions; // A bitwise flags of permissions,
1069                              // All 0: Not registered,
1070                              // 1st bit: Flag if the scheme is registered,
1071                              // 2nd bit: Scheme can register other schemes
1072                              // 3rd bit: Scheme can add/remove global constraints
1073                              // 4th bit: Scheme can upgrade the controller
1074                              // 5th bit: Scheme can call genericCall on behalf of
1075                              //          the organization avatar
1076     }
1077 
1078     struct GlobalConstraint {
1079         address gcAddress;
1080         bytes32 params;
1081     }
1082 
1083     struct GlobalConstraintRegister {
1084         bool isRegistered; //is registered
1085         uint index;    //index at globalConstraints
1086     }
1087 
1088     mapping(address=>Scheme) public schemes;
1089 
1090     Avatar public avatar;
1091     DAOToken public nativeToken;
1092     Reputation public nativeReputation;
1093   // newController will point to the new controller after the present controller is upgraded
1094     address public newController;
1095   // globalConstraintsPre that determine pre conditions for all actions on the controller
1096 
1097     GlobalConstraint[] public globalConstraintsPre;
1098   // globalConstraintsPost that determine post conditions for all actions on the controller
1099     GlobalConstraint[] public globalConstraintsPost;
1100   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1101     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1102   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1103     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1104 
1105     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1106     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1107     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1108     event RegisterScheme (address indexed _sender, address indexed _scheme);
1109     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1110     event GenericAction (address indexed _sender, bytes32[] _params);
1111     event SendEther (address indexed _sender, uint _amountInWei, address indexed _to);
1112     event ExternalTokenTransfer (address indexed _sender, address indexed _externalToken, address indexed _to, uint _value);
1113     event ExternalTokenTransferFrom (address indexed _sender, address indexed _externalToken, address _from, address _to, uint _value);
1114     event ExternalTokenIncreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1115     event ExternalTokenDecreaseApproval (address indexed _sender, StandardToken indexed _externalToken, address _spender, uint _value);
1116     event UpgradeController(address indexed _oldController,address _newController);
1117     event AddGlobalConstraint(address indexed _globalConstraint, bytes32 _params,GlobalConstraintInterface.CallPhase _when);
1118     event RemoveGlobalConstraint(address indexed _globalConstraint ,uint256 _index,bool _isPre);
1119     event GenericCall(address indexed _contract,bytes _data);
1120 
1121     constructor( Avatar _avatar) public
1122     {
1123         avatar = _avatar;
1124         nativeToken = avatar.nativeToken();
1125         nativeReputation = avatar.nativeReputation();
1126         schemes[msg.sender] = Scheme({paramsHash: bytes32(0),permissions: bytes4(0x1F)});
1127     }
1128 
1129   // Do not allow mistaken calls:
1130     function() external {
1131         revert();
1132     }
1133 
1134   // Modifiers:
1135     modifier onlyRegisteredScheme() {
1136         require(schemes[msg.sender].permissions&bytes4(1) == bytes4(1));
1137         _;
1138     }
1139 
1140     modifier onlyRegisteringSchemes() {
1141         require(schemes[msg.sender].permissions&bytes4(2) == bytes4(2));
1142         _;
1143     }
1144 
1145     modifier onlyGlobalConstraintsScheme() {
1146         require(schemes[msg.sender].permissions&bytes4(4) == bytes4(4));
1147         _;
1148     }
1149 
1150     modifier onlyUpgradingScheme() {
1151         require(schemes[msg.sender].permissions&bytes4(8) == bytes4(8));
1152         _;
1153     }
1154 
1155     modifier onlyGenericCallScheme() {
1156         require(schemes[msg.sender].permissions&bytes4(16) == bytes4(16));
1157         _;
1158     }
1159 
1160     modifier onlySubjectToConstraint(bytes32 func) {
1161         uint idx;
1162         for (idx = 0;idx<globalConstraintsPre.length;idx++) {
1163             require((GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress)).pre(msg.sender,globalConstraintsPre[idx].params,func));
1164         }
1165         _;
1166         for (idx = 0;idx<globalConstraintsPost.length;idx++) {
1167             require((GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress)).post(msg.sender,globalConstraintsPost[idx].params,func));
1168         }
1169     }
1170 
1171     modifier isAvatarValid(address _avatar) {
1172         require(_avatar == address(avatar));
1173         _;
1174     }
1175 
1176     /**
1177      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1178      * @param  _amount amount of reputation to mint
1179      * @param _to beneficiary address
1180      * @return bool which represents a success
1181      */
1182     function mintReputation(uint256 _amount, address _to,address _avatar)
1183     external
1184     onlyRegisteredScheme
1185     onlySubjectToConstraint("mintReputation")
1186     isAvatarValid(_avatar)
1187     returns(bool)
1188     {
1189         emit MintReputation(msg.sender, _to, _amount);
1190         return nativeReputation.mint(_to, _amount);
1191     }
1192 
1193     /**
1194      * @dev Burns `_amount` of reputation from `_from`
1195      * @param _amount amount of reputation to burn
1196      * @param _from The address that will lose the reputation
1197      * @return bool which represents a success
1198      */
1199     function burnReputation(uint256 _amount, address _from,address _avatar)
1200     external
1201     onlyRegisteredScheme
1202     onlySubjectToConstraint("burnReputation")
1203     isAvatarValid(_avatar)
1204     returns(bool)
1205     {
1206         emit BurnReputation(msg.sender, _from, _amount);
1207         return nativeReputation.burn(_from, _amount);
1208     }
1209 
1210     /**
1211      * @dev mint tokens .
1212      * @param  _amount amount of token to mint
1213      * @param _beneficiary beneficiary address
1214      * @return bool which represents a success
1215      */
1216     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
1217     external
1218     onlyRegisteredScheme
1219     onlySubjectToConstraint("mintTokens")
1220     isAvatarValid(_avatar)
1221     returns(bool)
1222     {
1223         emit MintTokens(msg.sender, _beneficiary, _amount);
1224         return nativeToken.mint(_beneficiary, _amount);
1225     }
1226 
1227   /**
1228    * @dev register a scheme
1229    * @param _scheme the address of the scheme
1230    * @param _paramsHash a hashed configuration of the usage of the scheme
1231    * @param _permissions the permissions the new scheme will have
1232    * @return bool which represents a success
1233    */
1234     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
1235     external
1236     onlyRegisteringSchemes
1237     onlySubjectToConstraint("registerScheme")
1238     isAvatarValid(_avatar)
1239     returns(bool)
1240     {
1241 
1242         Scheme memory scheme = schemes[_scheme];
1243 
1244     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1245     // Implementation is a bit messy. One must recall logic-circuits ^^
1246 
1247     // produces non-zero if sender does not have all of the perms that are changing between old and new
1248         require(bytes4(0x1F)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1249 
1250     // produces non-zero if sender does not have all of the perms in the old scheme
1251         require(bytes4(0x1F)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1252 
1253     // Add or change the scheme:
1254         schemes[_scheme].paramsHash = _paramsHash;
1255         schemes[_scheme].permissions = _permissions|bytes4(1);
1256         emit RegisterScheme(msg.sender, _scheme);
1257         return true;
1258     }
1259 
1260     /**
1261      * @dev unregister a scheme
1262      * @param _scheme the address of the scheme
1263      * @return bool which represents a success
1264      */
1265     function unregisterScheme( address _scheme,address _avatar)
1266     external
1267     onlyRegisteringSchemes
1268     onlySubjectToConstraint("unregisterScheme")
1269     isAvatarValid(_avatar)
1270     returns(bool)
1271     {
1272     //check if the scheme is registered
1273         if (schemes[_scheme].permissions&bytes4(1) == bytes4(0)) {
1274             return false;
1275           }
1276     // Check the unregistering scheme has enough permissions:
1277         require(bytes4(0x1F)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1278 
1279     // Unregister:
1280         emit UnregisterScheme(msg.sender, _scheme);
1281         delete schemes[_scheme];
1282         return true;
1283     }
1284 
1285     /**
1286      * @dev unregister the caller's scheme
1287      * @return bool which represents a success
1288      */
1289     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1290         if (_isSchemeRegistered(msg.sender,_avatar) == false) {
1291             return false;
1292         }
1293         delete schemes[msg.sender];
1294         emit UnregisterScheme(msg.sender, msg.sender);
1295         return true;
1296     }
1297 
1298     function isSchemeRegistered(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bool) {
1299         return _isSchemeRegistered(_scheme,_avatar);
1300     }
1301 
1302     function getSchemeParameters(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes32) {
1303         return schemes[_scheme].paramsHash;
1304     }
1305 
1306     function getSchemePermissions(address _scheme,address _avatar) external isAvatarValid(_avatar) view returns(bytes4) {
1307         return schemes[_scheme].permissions;
1308     }
1309 
1310     function getGlobalConstraintParameters(address _globalConstraint,address) external view returns(bytes32) {
1311 
1312         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
1313 
1314         if (register.isRegistered) {
1315             return globalConstraintsPre[register.index].params;
1316         }
1317 
1318         register = globalConstraintsRegisterPost[_globalConstraint];
1319 
1320         if (register.isRegistered) {
1321             return globalConstraintsPost[register.index].params;
1322         }
1323     }
1324 
1325    /**
1326     * @dev globalConstraintsCount return the global constraint pre and post count
1327     * @return uint globalConstraintsPre count.
1328     * @return uint globalConstraintsPost count.
1329     */
1330     function globalConstraintsCount(address _avatar)
1331         external
1332         isAvatarValid(_avatar)
1333         view
1334         returns(uint,uint)
1335         {
1336         return (globalConstraintsPre.length,globalConstraintsPost.length);
1337     }
1338 
1339     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar)
1340         external
1341         isAvatarValid(_avatar)
1342         view
1343         returns(bool)
1344         {
1345         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered || globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1346     }
1347 
1348     /**
1349      * @dev add or update Global Constraint
1350      * @param _globalConstraint the address of the global constraint to be added.
1351      * @param _params the constraint parameters hash.
1352      * @return bool which represents a success
1353      */
1354     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
1355     external
1356     onlyGlobalConstraintsScheme
1357     isAvatarValid(_avatar)
1358     returns(bool)
1359     {
1360         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1361         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1362             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1363                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint,_params));
1364                 globalConstraintsRegisterPre[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPre.length-1);
1365             }else {
1366                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1367             }
1368         }
1369         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1370             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1371                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint,_params));
1372                 globalConstraintsRegisterPost[_globalConstraint] = GlobalConstraintRegister(true,globalConstraintsPost.length-1);
1373             }else {
1374                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1375             }
1376         }
1377         emit AddGlobalConstraint(_globalConstraint, _params,when);
1378         return true;
1379     }
1380 
1381     /**
1382      * @dev remove Global Constraint
1383      * @param _globalConstraint the address of the global constraint to be remove.
1384      * @return bool which represents a success
1385      */
1386     function removeGlobalConstraint (address _globalConstraint,address _avatar)
1387     external
1388     onlyGlobalConstraintsScheme
1389     isAvatarValid(_avatar)
1390     returns(bool)
1391     {
1392         GlobalConstraintRegister memory globalConstraintRegister;
1393         GlobalConstraint memory globalConstraint;
1394         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1395         bool retVal = false;
1396 
1397         if ((when == GlobalConstraintInterface.CallPhase.Pre)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1398             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
1399             if (globalConstraintRegister.isRegistered) {
1400                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
1401                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
1402                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
1403                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1404                 }
1405                 globalConstraintsPre.length--;
1406                 delete globalConstraintsRegisterPre[_globalConstraint];
1407                 retVal = true;
1408             }
1409         }
1410         if ((when == GlobalConstraintInterface.CallPhase.Post)||(when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1411             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
1412             if (globalConstraintRegister.isRegistered) {
1413                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
1414                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
1415                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
1416                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1417                 }
1418                 globalConstraintsPost.length--;
1419                 delete globalConstraintsRegisterPost[_globalConstraint];
1420                 retVal = true;
1421             }
1422         }
1423         if (retVal) {
1424             emit RemoveGlobalConstraint(_globalConstraint,globalConstraintRegister.index,when == GlobalConstraintInterface.CallPhase.Pre);
1425         }
1426         return retVal;
1427     }
1428 
1429   /**
1430     * @dev upgrade the Controller
1431     *      The function will trigger an event 'UpgradeController'.
1432     * @param  _newController the address of the new controller.
1433     * @return bool which represents a success
1434     */
1435     function upgradeController(address _newController,address _avatar)
1436     external
1437     onlyUpgradingScheme
1438     isAvatarValid(_avatar)
1439     returns(bool)
1440     {
1441         require(newController == address(0));   // so the upgrade could be done once for a contract.
1442         require(_newController != address(0));
1443         newController = _newController;
1444         avatar.transferOwnership(_newController);
1445         require(avatar.owner()==_newController);
1446         if (nativeToken.owner() == address(this)) {
1447             nativeToken.transferOwnership(_newController);
1448             require(nativeToken.owner()==_newController);
1449         }
1450         if (nativeReputation.owner() == address(this)) {
1451             nativeReputation.transferOwnership(_newController);
1452             require(nativeReputation.owner()==_newController);
1453         }
1454         emit UpgradeController(this,newController);
1455         return true;
1456     }
1457 
1458     /**
1459     * @dev perform a generic call to an arbitrary contract
1460     * @param _contract  the contract's address to call
1461     * @param _data ABI-encoded contract call to call `_contract` address.
1462     * @param _avatar the controller's avatar address
1463     * @return bytes32  - the return value of the called _contract's function.
1464     */
1465     function genericCall(address _contract,bytes _data,address _avatar)
1466     external
1467     onlyGenericCallScheme
1468     onlySubjectToConstraint("genericCall")
1469     isAvatarValid(_avatar)
1470     returns (bytes32)
1471     {
1472         emit GenericCall(_contract, _data);
1473         avatar.genericCall(_contract, _data);
1474         // solium-disable-next-line security/no-inline-assembly
1475         assembly {
1476         // Copy the returned data.
1477         returndatacopy(0, 0, returndatasize)
1478         return(0, returndatasize)
1479         }
1480     }
1481 
1482   /**
1483    * @dev send some ether
1484    * @param _amountInWei the amount of ether (in Wei) to send
1485    * @param _to address of the beneficiary
1486    * @return bool which represents a success
1487    */
1488     function sendEther(uint _amountInWei, address _to,address _avatar)
1489     external
1490     onlyRegisteredScheme
1491     onlySubjectToConstraint("sendEther")
1492     isAvatarValid(_avatar)
1493     returns(bool)
1494     {
1495         emit SendEther(msg.sender, _amountInWei, _to);
1496         return avatar.sendEther(_amountInWei, _to);
1497     }
1498 
1499     /**
1500     * @dev send some amount of arbitrary ERC20 Tokens
1501     * @param _externalToken the address of the Token Contract
1502     * @param _to address of the beneficiary
1503     * @param _value the amount of ether (in Wei) to send
1504     * @return bool which represents a success
1505     */
1506     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
1507     external
1508     onlyRegisteredScheme
1509     onlySubjectToConstraint("externalTokenTransfer")
1510     isAvatarValid(_avatar)
1511     returns(bool)
1512     {
1513         emit ExternalTokenTransfer(msg.sender, _externalToken, _to, _value);
1514         return avatar.externalTokenTransfer(_externalToken, _to, _value);
1515     }
1516 
1517     /**
1518     * @dev transfer token "from" address "to" address
1519     *      One must to approve the amount of tokens which can be spend from the
1520     *      "from" account.This can be done using externalTokenApprove.
1521     * @param _externalToken the address of the Token Contract
1522     * @param _from address of the account to send from
1523     * @param _to address of the beneficiary
1524     * @param _value the amount of ether (in Wei) to send
1525     * @return bool which represents a success
1526     */
1527     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
1528     external
1529     onlyRegisteredScheme
1530     onlySubjectToConstraint("externalTokenTransferFrom")
1531     isAvatarValid(_avatar)
1532     returns(bool)
1533     {
1534         emit ExternalTokenTransferFrom(msg.sender, _externalToken, _from, _to, _value);
1535         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1536     }
1537 
1538     /**
1539     * @dev increase approval for the spender address to spend a specified amount of tokens
1540     *      on behalf of msg.sender.
1541     * @param _externalToken the address of the Token Contract
1542     * @param _spender address
1543     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
1544     * @return bool which represents a success
1545     */
1546     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
1547     external
1548     onlyRegisteredScheme
1549     onlySubjectToConstraint("externalTokenIncreaseApproval")
1550     isAvatarValid(_avatar)
1551     returns(bool)
1552     {
1553         emit ExternalTokenIncreaseApproval(msg.sender,_externalToken,_spender,_addedValue);
1554         return avatar.externalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
1555     }
1556 
1557     /**
1558     * @dev decrease approval for the spender address to spend a specified amount of tokens
1559     *      on behalf of msg.sender.
1560     * @param _externalToken the address of the Token Contract
1561     * @param _spender address
1562     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
1563     * @return bool which represents a success
1564     */
1565     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1566     external
1567     onlyRegisteredScheme
1568     onlySubjectToConstraint("externalTokenDecreaseApproval")
1569     isAvatarValid(_avatar)
1570     returns(bool)
1571     {
1572         emit ExternalTokenDecreaseApproval(msg.sender,_externalToken,_spender,_subtractedValue);
1573         return avatar.externalTokenDecreaseApproval(_externalToken, _spender, _subtractedValue);
1574     }
1575 
1576     /**
1577      * @dev getNativeReputation
1578      * @param _avatar the organization avatar.
1579      * @return organization native reputation
1580      */
1581     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
1582         return address(nativeReputation);
1583     }
1584 
1585     function _isSchemeRegistered(address _scheme,address _avatar) private isAvatarValid(_avatar) view returns(bool) {
1586         return (schemes[_scheme].permissions&bytes4(1) != bytes4(0));
1587     }
1588 }
1589 
1590 // File: contracts/universalSchemes/ExecutableInterface.sol
1591 
1592 contract ExecutableInterface {
1593     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool);
1594 }
1595 
1596 // File: contracts/VotingMachines/IntVoteInterface.sol
1597 
1598 interface IntVoteInterface {
1599     //When implementing this interface please do not only override function and modifier,
1600     //but also to keep the modifiers on the overridden functions.
1601     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
1602     modifier votable(bytes32 _proposalId) {revert(); _;}
1603 
1604     event NewProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _numOfChoices, address _proposer, bytes32 _paramsHash);
1605     event ExecuteProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _decision, uint _totalReputation);
1606     event VoteProposal(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter, uint _vote, uint _reputation);
1607     event CancelProposal(bytes32 indexed _proposalId, address indexed _avatar );
1608     event CancelVoting(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter);
1609 
1610     /**
1611      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1612      * generated by calculating keccak256 of a incremented counter.
1613      * @param _numOfChoices number of voting choices
1614      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
1615      * @param _avatar an address to be sent as the payload to the _executable contract.
1616      * @param _executable This contract will be executed when vote is over.
1617      * @param _proposer address
1618      * @return proposal's id.
1619      */
1620     function propose(
1621         uint _numOfChoices,
1622         bytes32 _proposalParameters,
1623         address _avatar,
1624         ExecutableInterface _executable,
1625         address _proposer
1626         ) external returns(bytes32);
1627 
1628     // Only owned proposals and only the owner:
1629     function cancelProposal(bytes32 _proposalId) external returns(bool);
1630 
1631     // Only owned proposals and only the owner:
1632     function ownerVote(bytes32 _proposalId, uint _vote, address _voter) external returns(bool);
1633 
1634     function vote(bytes32 _proposalId, uint _vote) external returns(bool);
1635 
1636     function voteWithSpecifiedAmounts(
1637         bytes32 _proposalId,
1638         uint _vote,
1639         uint _rep,
1640         uint _token) external returns(bool);
1641 
1642     function cancelVote(bytes32 _proposalId) external;
1643 
1644     //@dev execute check if the proposal has been decided, and if so, execute the proposal
1645     //@param _proposalId the id of the proposal
1646     //@return bool true - the proposal has been executed
1647     //             false - otherwise.
1648     function execute(bytes32 _proposalId) external returns(bool);
1649 
1650     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint);
1651 
1652     function isVotable(bytes32 _proposalId) external view returns(bool);
1653 
1654     /**
1655      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1656      * @param _proposalId the ID of the proposal
1657      * @param _choice the index in the
1658      * @return voted reputation for the given choice
1659      */
1660     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint);
1661 
1662     /**
1663      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1664      * @return bool true or false
1665      */
1666     function isAbstainAllow() external pure returns(bool);
1667 
1668     /**
1669      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1670      * @return min - minimum number of choices
1671                max - maximum number of choices
1672      */
1673     function getAllowedRangeOfChoices() external pure returns(uint min,uint max);
1674 }
1675 
1676 // File: contracts/universalSchemes/UniversalSchemeInterface.sol
1677 
1678 contract UniversalSchemeInterface {
1679 
1680     function updateParameters(bytes32 _hashedParameters) public;
1681 
1682     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
1683 }
1684 
1685 // File: contracts/universalSchemes/UniversalScheme.sol
1686 
1687 contract UniversalScheme is Ownable, UniversalSchemeInterface {
1688     bytes32 public hashedParameters; // For other parameters.
1689 
1690     function updateParameters(
1691         bytes32 _hashedParameters
1692     )
1693         public
1694         onlyOwner
1695     {
1696         hashedParameters = _hashedParameters;
1697     }
1698 
1699     /**
1700     *  @dev get the parameters for the current scheme from the controller
1701     */
1702     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1703         return ControllerInterface(_avatar.owner()).getSchemeParameters(this,address(_avatar));
1704     }
1705 }
1706 
1707 // File: contracts/universalSchemes/ContributionReward.sol
1708 
1709 /**
1710  * @title A scheme for proposing and rewarding contributions to an organization
1711  * @dev An agent can ask an organization to recognize a contribution and reward
1712  * him with token, reputation, ether or any combination.
1713  */
1714 
1715 contract ContributionReward is UniversalScheme {
1716     using SafeMath for uint;
1717 
1718     event NewContributionProposal(
1719         address indexed _avatar,
1720         bytes32 indexed _proposalId,
1721         address indexed _intVoteInterface,
1722         bytes32 _contributionDescription,
1723         int _reputationChange,
1724         uint[5]  _rewards,
1725         StandardToken _externalToken,
1726         address _beneficiary
1727     );
1728     event ProposalExecuted(address indexed _avatar, bytes32 indexed _proposalId,int _param);
1729     event RedeemReputation(address indexed _avatar, bytes32 indexed _proposalId, address indexed _beneficiary,int _amount);
1730     event RedeemEther(address indexed _avatar, bytes32 indexed _proposalId, address indexed _beneficiary,uint _amount);
1731     event RedeemNativeToken(address indexed _avatar, bytes32 indexed _proposalId, address indexed _beneficiary,uint _amount);
1732     event RedeemExternalToken(address indexed _avatar, bytes32 indexed _proposalId, address indexed _beneficiary,uint _amount);
1733 
1734     // A struct holding the data for a contribution proposal
1735     struct ContributionProposal {
1736         bytes32 contributionDescriptionHash; // Hash of contribution document.
1737         uint nativeTokenReward; // Reward asked in the native token of the organization.
1738         int reputationChange; // Organization reputation reward requested.
1739         uint ethReward;
1740         StandardToken externalToken;
1741         uint externalTokenReward;
1742         address beneficiary;
1743         uint periodLength;
1744         uint numberOfPeriods;
1745         uint executionTime;
1746         uint[4] redeemedPeriods;
1747     }
1748 
1749     // A mapping from the organization (Avatar) address to the saved data of the organization:
1750     mapping(address=>mapping(bytes32=>ContributionProposal)) public organizationsProposals;
1751 
1752     // A mapping from hashes to parameters (use to store a particular configuration on the controller)
1753     // A contribution fee can be in the organization token or the scheme token or a combination
1754     struct Parameters {
1755         uint orgNativeTokenFee; // a fee (in the organization's token) that is to be paid for submitting a contribution
1756         bytes32 voteApproveParams;
1757         IntVoteInterface intVote;
1758     }
1759     // A mapping from hashes to parameters (use to store a particular configuration on the controller)
1760     mapping(bytes32=>Parameters) public parameters;
1761 
1762     /**
1763     * @dev hash the parameters, save them if necessary, and return the hash value
1764     */
1765     function setParameters(
1766         uint _orgNativeTokenFee,
1767         bytes32 _voteApproveParams,
1768         IntVoteInterface _intVote
1769     ) public returns(bytes32)
1770     {
1771         bytes32 paramsHash = getParametersHash(
1772             _orgNativeTokenFee,
1773             _voteApproveParams,
1774             _intVote
1775         );
1776         parameters[paramsHash].orgNativeTokenFee = _orgNativeTokenFee;
1777         parameters[paramsHash].voteApproveParams = _voteApproveParams;
1778         parameters[paramsHash].intVote = _intVote;
1779         return paramsHash;
1780     }
1781 
1782     /**
1783     * @dev return a hash of the given parameters
1784     * @param _orgNativeTokenFee the fee for submitting a contribution in organizations native token
1785     * @param _voteApproveParams parameters for the voting machine used to approve a contribution
1786     * @param _intVote the voting machine used to approve a contribution
1787     * @return a hash of the parameters
1788     */
1789     // TODO: These fees are messy. Better to have a _fee and _feeToken pair, just as in some other contract (which one?) with some sane default
1790     function getParametersHash(
1791         uint _orgNativeTokenFee,
1792         bytes32 _voteApproveParams,
1793         IntVoteInterface _intVote
1794     ) public pure returns(bytes32)
1795     {
1796         return (keccak256(abi.encodePacked(_voteApproveParams, _orgNativeTokenFee, _intVote)));
1797     }
1798 
1799     /**
1800     * @dev Submit a proposal for a reward for a contribution:
1801     * @param _avatar Avatar of the organization that the contribution was made for
1802     * @param _contributionDescriptionHash A hash of the contribution's description
1803     * @param _reputationChange - Amount of reputation change requested .Can be negative.
1804     * @param _rewards rewards array:
1805     *         rewards[0] - Amount of tokens requested per period
1806     *         rewards[1] - Amount of ETH requested per period
1807     *         rewards[2] - Amount of external tokens requested per period
1808     *         rewards[3] - Period length - if set to zero it allows immediate redeeming after execution.
1809     *         rewards[4] - Number of periods
1810     * @param _externalToken Address of external token, if reward is requested there
1811     * @param _beneficiary Who gets the rewards
1812     */
1813     function proposeContributionReward(
1814         Avatar _avatar,
1815         bytes32 _contributionDescriptionHash,
1816         int _reputationChange,
1817         uint[5] _rewards,
1818         StandardToken _externalToken,
1819         address _beneficiary
1820     ) public
1821       returns(bytes32)
1822     {
1823         require(((_rewards[3] > 0) || (_rewards[4] == 1)),"periodLength equal 0 require numberOfPeriods to be 1");
1824         Parameters memory controllerParams = parameters[getParametersFromController(_avatar)];
1825         // Pay fees for submitting the contribution:
1826         if (controllerParams.orgNativeTokenFee > 0) {
1827             _avatar.nativeToken().transferFrom(msg.sender, _avatar, controllerParams.orgNativeTokenFee);
1828         }
1829 
1830         bytes32 contributionId = controllerParams.intVote.propose(
1831             2,
1832             controllerParams.voteApproveParams,
1833            _avatar,
1834            ExecutableInterface(this),
1835            msg.sender
1836         );
1837 
1838         // Check beneficiary is not null:
1839         address beneficiary = _beneficiary;
1840         if (beneficiary == address(0)) {
1841             beneficiary = msg.sender;
1842         }
1843 
1844         // Set the struct:
1845         ContributionProposal memory proposal = ContributionProposal({
1846             contributionDescriptionHash: _contributionDescriptionHash,
1847             nativeTokenReward: _rewards[0],
1848             reputationChange: _reputationChange,
1849             ethReward: _rewards[1],
1850             externalToken: _externalToken,
1851             externalTokenReward: _rewards[2],
1852             beneficiary: beneficiary,
1853             periodLength: _rewards[3],
1854             numberOfPeriods: _rewards[4],
1855             executionTime: 0,
1856             redeemedPeriods:[uint(0),uint(0),uint(0),uint(0)]
1857         });
1858         organizationsProposals[_avatar][contributionId] = proposal;
1859 
1860         emit NewContributionProposal(
1861             _avatar,
1862             contributionId,
1863             controllerParams.intVote,
1864             _contributionDescriptionHash,
1865             _reputationChange,
1866             _rewards,
1867             _externalToken,
1868             beneficiary
1869         );
1870 
1871         // vote for this proposal
1872         controllerParams.intVote.ownerVote(contributionId, 1, msg.sender); // Automatically votes `yes` in the name of the opener.
1873         return contributionId;
1874     }
1875 
1876     /**
1877     * @dev execution of proposals, can only be called by the voting machine in which the vote is held.
1878     * @param _proposalId the ID of the voting in the voting machine
1879     * @param _avatar address of the controller
1880     * @param _param a parameter of the voting result, 1 yes and 2 is no.
1881     */
1882     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool) {
1883         // Check the caller is indeed the voting machine:
1884         require(parameters[getParametersFromController(Avatar(_avatar))].intVote == msg.sender);
1885         require(organizationsProposals[_avatar][_proposalId].executionTime == 0);
1886         require(organizationsProposals[_avatar][_proposalId].beneficiary != address(0));
1887         // Check if vote was successful:
1888         if (_param == 1) {
1889           // solium-disable-next-line security/no-block-members
1890             organizationsProposals[_avatar][_proposalId].executionTime = now;
1891         }
1892         emit ProposalExecuted(_avatar, _proposalId,_param);
1893         return true;
1894     }
1895 
1896     /**
1897     * @dev RedeemReputation reward for proposal
1898     * @param _proposalId the ID of the voting in the voting machine
1899     * @param _avatar address of the controller
1900     * @return  result boolean for success indication.
1901     */
1902     function redeemReputation(bytes32 _proposalId, address _avatar) public returns(bool) {
1903 
1904         ContributionProposal memory _proposal = organizationsProposals[_avatar][_proposalId];
1905         ContributionProposal storage proposal = organizationsProposals[_avatar][_proposalId];
1906         require(proposal.executionTime != 0);
1907         uint periodsToPay = getPeriodsToPay(_proposalId,_avatar,0);
1908         bool result;
1909 
1910         //set proposal reward to zero to prevent reentrancy attack.
1911         proposal.reputationChange = 0;
1912         int reputation = int(periodsToPay) * _proposal.reputationChange;
1913         if (reputation > 0 ) {
1914             require(ControllerInterface(Avatar(_avatar).owner()).mintReputation(uint(reputation), _proposal.beneficiary,_avatar));
1915             result = true;
1916         } else if (reputation < 0 ) {
1917             require(ControllerInterface(Avatar(_avatar).owner()).burnReputation(uint(reputation*(-1)), _proposal.beneficiary,_avatar));
1918             result = true;
1919         }
1920         if (result) {
1921             proposal.redeemedPeriods[0] = proposal.redeemedPeriods[0].add(periodsToPay);
1922             emit RedeemReputation(_avatar,_proposalId,_proposal.beneficiary,reputation);
1923         }
1924         //restore proposal reward.
1925         proposal.reputationChange = _proposal.reputationChange;
1926         return result;
1927     }
1928 
1929     /**
1930     * @dev RedeemNativeToken reward for proposal
1931     * @param _proposalId the ID of the voting in the voting machine
1932     * @param _avatar address of the controller
1933     * @return  result boolean for success indication.
1934     */
1935     function redeemNativeToken(bytes32 _proposalId, address _avatar) public returns(bool) {
1936 
1937         ContributionProposal memory _proposal = organizationsProposals[_avatar][_proposalId];
1938         ContributionProposal storage proposal = organizationsProposals[_avatar][_proposalId];
1939         require(proposal.executionTime != 0);
1940         uint periodsToPay = getPeriodsToPay(_proposalId,_avatar,1);
1941         bool result;
1942         //set proposal rewards to zero to prevent reentrancy attack.
1943         proposal.nativeTokenReward = 0;
1944 
1945         uint amount = periodsToPay.mul(_proposal.nativeTokenReward);
1946         if (amount > 0) {
1947             require(ControllerInterface(Avatar(_avatar).owner()).mintTokens(amount, _proposal.beneficiary,_avatar));
1948             proposal.redeemedPeriods[1] = proposal.redeemedPeriods[1].add(periodsToPay);
1949             result = true;
1950             emit RedeemNativeToken(_avatar,_proposalId,_proposal.beneficiary,amount);
1951         }
1952 
1953         //restore proposal reward.
1954         proposal.nativeTokenReward = _proposal.nativeTokenReward;
1955         return result;
1956     }
1957 
1958     /**
1959     * @dev RedeemEther reward for proposal
1960     * @param _proposalId the ID of the voting in the voting machine
1961     * @param _avatar address of the controller
1962     * @return  result boolean for success indication.
1963     */
1964     function redeemEther(bytes32 _proposalId, address _avatar) public returns(bool) {
1965 
1966         ContributionProposal memory _proposal = organizationsProposals[_avatar][_proposalId];
1967         ContributionProposal storage proposal = organizationsProposals[_avatar][_proposalId];
1968         require(proposal.executionTime != 0);
1969         uint periodsToPay = getPeriodsToPay(_proposalId,_avatar,2);
1970         bool result;
1971         //set proposal rewards to zero to prevent reentrancy attack.
1972         proposal.ethReward = 0;
1973         uint amount = periodsToPay.mul(_proposal.ethReward);
1974 
1975         if (amount > 0) {
1976             require(ControllerInterface(Avatar(_avatar).owner()).sendEther(amount, _proposal.beneficiary,_avatar));
1977             proposal.redeemedPeriods[2] = proposal.redeemedPeriods[2].add(periodsToPay);
1978             result = true;
1979             emit RedeemEther(_avatar,_proposalId,_proposal.beneficiary,amount);
1980         }
1981 
1982         //restore proposal reward.
1983         proposal.ethReward = _proposal.ethReward;
1984         return result;
1985     }
1986 
1987     /**
1988     * @dev RedeemNativeToken reward for proposal
1989     * @param _proposalId the ID of the voting in the voting machine
1990     * @param _avatar address of the controller
1991     * @return  result boolean for success indication.
1992     */
1993     function redeemExternalToken(bytes32 _proposalId, address _avatar) public returns(bool) {
1994 
1995         ContributionProposal memory _proposal = organizationsProposals[_avatar][_proposalId];
1996         ContributionProposal storage proposal = organizationsProposals[_avatar][_proposalId];
1997         require(proposal.executionTime != 0);
1998         uint periodsToPay = getPeriodsToPay(_proposalId,_avatar,3);
1999         bool result;
2000         //set proposal rewards to zero to prevent reentrancy attack.
2001         proposal.externalTokenReward = 0;
2002 
2003         if (proposal.externalToken != address(0) && _proposal.externalTokenReward > 0) {
2004             uint amount = periodsToPay.mul(_proposal.externalTokenReward);
2005             if (amount > 0) {
2006                 require(ControllerInterface(Avatar(_avatar).owner()).externalTokenTransfer(_proposal.externalToken, _proposal.beneficiary, amount,_avatar));
2007                 proposal.redeemedPeriods[3] = proposal.redeemedPeriods[3].add(periodsToPay);
2008                 result = true;
2009                 emit RedeemExternalToken(_avatar,_proposalId,_proposal.beneficiary,amount);
2010             }
2011         }
2012         //restore proposal reward.
2013         proposal.externalTokenReward = _proposal.externalTokenReward;
2014         return result;
2015     }
2016 
2017     /**
2018     * @dev redeem rewards for proposal
2019     * @param _proposalId the ID of the voting in the voting machine
2020     * @param _avatar address of the controller
2021     * @param _whatToRedeem whatToRedeem array:
2022     *         whatToRedeem[0] - reputation
2023     *         whatToRedeem[1] - nativeTokenReward
2024     *         whatToRedeem[2] - Ether
2025     *         whatToRedeem[3] - ExternalToken
2026     * @return  result boolean array for each redeem type.
2027     */
2028     function redeem(bytes32 _proposalId, address _avatar,bool[4] _whatToRedeem) public returns(bool[4] result) {
2029 
2030         if (_whatToRedeem[0]) {
2031             result[0] = redeemReputation(_proposalId,_avatar);
2032         }
2033 
2034         if (_whatToRedeem[1]) {
2035             result[1] = redeemNativeToken(_proposalId,_avatar);
2036         }
2037 
2038         if (_whatToRedeem[2]) {
2039             result[2] = redeemEther(_proposalId,_avatar);
2040         }
2041 
2042         if (_whatToRedeem[3]) {
2043             result[3] = redeemExternalToken(_proposalId,_avatar);
2044         }
2045 
2046         return result;
2047     }
2048 
2049     /**
2050     * @dev getPeriodsToPay return the periods left to be paid for reputation,nativeToken,ether or externalToken.
2051     * The function ignore the reward amount to be paid (which can be zero).
2052     * @param _proposalId the ID of the voting in the voting machine
2053     * @param _avatar address of the controller
2054     * @param _redeemType - the type of the reward  :
2055     *         0 - reputation
2056     *         1 - nativeTokenReward
2057     *         2 - Ether
2058     *         3 - ExternalToken
2059     * @return  periods left to be paid.
2060     */
2061     function getPeriodsToPay(bytes32 _proposalId, address _avatar,uint _redeemType) public view returns (uint) {
2062         ContributionProposal memory _proposal = organizationsProposals[_avatar][_proposalId];
2063         if (_proposal.executionTime == 0)
2064             return 0;
2065         uint periodsFromExecution;
2066         if (_proposal.periodLength > 0) {
2067           // solium-disable-next-line security/no-block-members
2068             periodsFromExecution = (now.sub(_proposal.executionTime))/(_proposal.periodLength);
2069         }
2070         uint periodsToPay;
2071         if ((_proposal.periodLength == 0) || (periodsFromExecution >= _proposal.numberOfPeriods)) {
2072             periodsToPay = _proposal.numberOfPeriods.sub(_proposal.redeemedPeriods[_redeemType]);
2073         } else {
2074             periodsToPay = periodsFromExecution.sub(_proposal.redeemedPeriods[_redeemType]);
2075         }
2076         return periodsToPay;
2077     }
2078 
2079     /**
2080     * @dev getRedeemedPeriods return the already redeemed periods for reputation, nativeToken, ether or externalToken.
2081     * @param _proposalId the ID of the voting in the voting machine
2082     * @param _avatar address of the controller
2083     * @param _redeemType - the type of the reward  :
2084     *         0 - reputation
2085     *         1 - nativeTokenReward
2086     *         2 - Ether
2087     *         3 - ExternalToken
2088     * @return redeemed period.
2089     */
2090     function getRedeemedPeriods(bytes32 _proposalId, address _avatar,uint _redeemType) public view returns (uint) {
2091         return organizationsProposals[_avatar][_proposalId].redeemedPeriods[_redeemType];
2092     }
2093 
2094     function getProposalEthReward(bytes32 _proposalId, address _avatar) public view returns (uint) {
2095         return organizationsProposals[_avatar][_proposalId].ethReward;
2096     }
2097 
2098     function getProposalExternalTokenReward(bytes32 _proposalId, address _avatar) public view returns (uint) {
2099         return organizationsProposals[_avatar][_proposalId].externalTokenReward;
2100     }
2101 
2102     function getProposalExternalToken(bytes32 _proposalId, address _avatar) public view returns (address) {
2103         return organizationsProposals[_avatar][_proposalId].externalToken;
2104     }
2105 
2106     function getProposalExecutionTime(bytes32 _proposalId, address _avatar) public view returns (uint) {
2107         return organizationsProposals[_avatar][_proposalId].executionTime;
2108     }
2109 
2110 }
2111 
2112 // File: contracts/libs/RealMath.sol
2113 
2114 /**
2115  * RealMath: fixed-point math library, based on fractional and integer parts.
2116  * Using int256 as real216x40, which isn't in Solidity yet.
2117  * 40 fractional bits gets us down to 1E-12 precision, while still letting us
2118  * go up to galaxy scale counting in meters.
2119  * Internally uses the wider int256 for some math.
2120  *
2121  * Note that for addition, subtraction, and mod (%), you should just use the
2122  * built-in Solidity operators. Functions for these operations are not provided.
2123  *
2124  * Note that the fancy functions like sqrt, atan2, etc. aren't as accurate as
2125  * they should be. They are (hopefully) Good Enough for doing orbital mechanics
2126  * on block timescales in a game context, but they may not be good enough for
2127  * other applications.
2128  */
2129 
2130 
2131 library RealMath {
2132 
2133     /**
2134      * How many total bits are there?
2135      */
2136     int256 constant REAL_BITS = 256;
2137 
2138     /**
2139      * How many fractional bits are there?
2140      */
2141     int256 constant REAL_FBITS = 40;
2142 
2143     /**
2144      * How many integer bits are there?
2145      */
2146     int256 constant REAL_IBITS = REAL_BITS - REAL_FBITS;
2147 
2148     /**
2149      * What's the first non-fractional bit
2150      */
2151     int256 constant REAL_ONE = int256(1) << REAL_FBITS;
2152 
2153     /**
2154      * What's the last fractional bit?
2155      */
2156     int256 constant REAL_HALF = REAL_ONE >> 1;
2157 
2158     /**
2159      * What's two? Two is pretty useful.
2160      */
2161     int256 constant REAL_TWO = REAL_ONE << 1;
2162 
2163     /**
2164      * And our logarithms are based on ln(2).
2165      */
2166     int256 constant REAL_LN_TWO = 762123384786;
2167 
2168     /**
2169      * It is also useful to have Pi around.
2170      */
2171     int256 constant REAL_PI = 3454217652358;
2172 
2173     /**
2174      * And half Pi, to save on divides.
2175      * TODO: That might not be how the compiler handles constants.
2176      */
2177     int256 constant REAL_HALF_PI = 1727108826179;
2178 
2179     /**
2180      * And two pi, which happens to be odd in its most accurate representation.
2181      */
2182     int256 constant REAL_TWO_PI = 6908435304715;
2183 
2184     /**
2185      * What's the sign bit?
2186      */
2187     int256 constant SIGN_MASK = int256(1) << 255;
2188 
2189 
2190     /**
2191      * Convert an integer to a real. Preserves sign.
2192      */
2193     function toReal(int216 ipart) internal pure returns (int256) {
2194         return int256(ipart) * REAL_ONE;
2195     }
2196 
2197     /**
2198      * Convert a real to an integer. Preserves sign.
2199      */
2200     function fromReal(int256 realValue) internal pure returns (int216) {
2201         return int216(realValue / REAL_ONE);
2202     }
2203 
2204     /**
2205      * Round a real to the nearest integral real value.
2206      */
2207     function round(int256 realValue) internal pure returns (int256) {
2208         // First, truncate.
2209         int216 ipart = fromReal(realValue);
2210         if ((fractionalBits(realValue) & (uint40(1) << (REAL_FBITS - 1))) > 0) {
2211             // High fractional bit is set. Round up.
2212             if (realValue < int256(0)) {
2213                 // Rounding up for a negative number is rounding down.
2214                 ipart -= 1;
2215             } else {
2216                 ipart += 1;
2217             }
2218         }
2219         return toReal(ipart);
2220     }
2221 
2222     /**
2223      * Get the absolute value of a real. Just the same as abs on a normal int256.
2224      */
2225     function abs(int256 realValue) internal pure returns (int256) {
2226         if (realValue > 0) {
2227             return realValue;
2228         } else {
2229             return -realValue;
2230         }
2231     }
2232 
2233     /**
2234      * Returns the fractional bits of a real. Ignores the sign of the real.
2235      */
2236     function fractionalBits(int256 realValue) internal pure returns (uint40) {
2237         return uint40(abs(realValue) % REAL_ONE);
2238     }
2239 
2240     /**
2241      * Get the fractional part of a real, as a real. Ignores sign (so fpart(-0.5) is 0.5).
2242      */
2243     function fpart(int256 realValue) internal pure returns (int256) {
2244         // This gets the fractional part but strips the sign
2245         return abs(realValue) % REAL_ONE;
2246     }
2247 
2248     /**
2249      * Get the fractional part of a real, as a real. Respects sign (so fpartSigned(-0.5) is -0.5).
2250      */
2251     function fpartSigned(int256 realValue) internal pure returns (int256) {
2252         // This gets the fractional part but strips the sign
2253         int256 fractional = fpart(realValue);
2254         if (realValue < 0) {
2255             // Add the negative sign back in.
2256             return -fractional;
2257         } else {
2258             return fractional;
2259         }
2260     }
2261 
2262     /**
2263      * Get the integer part of a fixed point value.
2264      */
2265     function ipart(int256 realValue) internal pure returns (int256) {
2266         // Subtract out the fractional part to get the real part.
2267         return realValue - fpartSigned(realValue);
2268     }
2269 
2270     /**
2271      * Multiply one real by another. Truncates overflows.
2272      */
2273     function mul(int256 realA, int256 realB) internal pure returns (int256) {
2274         // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
2275         // So we just have to clip off the extra REAL_FBITS fractional bits.
2276         return int256((int256(realA) * int256(realB)) >> REAL_FBITS);
2277     }
2278 
2279     /**
2280      * Divide one real by another real. Truncates overflows.
2281      */
2282     function div(int256 realNumerator, int256 realDenominator) internal pure returns (int256) {
2283         // We use the reverse of the multiplication trick: convert numerator from
2284         // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
2285         return int256((int256(realNumerator) * REAL_ONE) / int256(realDenominator));
2286     }
2287 
2288     /**
2289      * Create a real from a rational fraction.
2290      */
2291     function fraction(int216 numerator, int216 denominator) internal pure returns (int256) {
2292         return div(toReal(numerator), toReal(denominator));
2293     }
2294 
2295     // Now we have some fancy math things (like pow and trig stuff). This isn't
2296     // in the RealMath that was deployed with the original Macroverse
2297     // deployment, so it needs to be linked into your contract statically.
2298 
2299     /**
2300      * Raise a number to a positive integer power in O(log power) time.
2301      * See <https://stackoverflow.com/a/101613>
2302      */
2303     function ipow(int256 realBase, int216 exponent) internal pure returns (int256) {
2304         if (exponent < 0) {
2305             // Negative powers are not allowed here.
2306             revert();
2307         }
2308 
2309         int256 tempRealBase = realBase;
2310         int256 tempExponent = exponent;
2311 
2312         // Start with the 0th power
2313         int256 realResult = REAL_ONE;
2314         while (tempExponent != 0) {
2315             // While there are still bits set
2316             if ((tempExponent & 0x1) == 0x1) {
2317                 // If the low bit is set, multiply in the (many-times-squared) base
2318                 realResult = mul(realResult, tempRealBase);
2319             }
2320             // Shift off the low bit
2321             tempExponent = tempExponent >> 1;
2322             // Do the squaring
2323             tempRealBase = mul(tempRealBase, tempRealBase);
2324         }
2325 
2326         // Return the final result.
2327         return realResult;
2328     }
2329 
2330     /**
2331      * Zero all but the highest set bit of a number.
2332      * See <https://stackoverflow.com/a/53184>
2333      */
2334     function hibit(uint256 _val) internal pure returns (uint256) {
2335         // Set all the bits below the highest set bit
2336         uint256 val = _val;
2337         val |= (val >> 1);
2338         val |= (val >> 2);
2339         val |= (val >> 4);
2340         val |= (val >> 8);
2341         val |= (val >> 16);
2342         val |= (val >> 32);
2343         val |= (val >> 64);
2344         val |= (val >> 128);
2345         return val ^ (val >> 1);
2346     }
2347 
2348     /**
2349      * Given a number with one bit set, finds the index of that bit.
2350      */
2351     function findbit(uint256 val) internal pure returns (uint8 index) {
2352         index = 0;
2353         // We and the value with alternating bit patters of various pitches to find it.
2354         if (val & 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA != 0) {
2355             // Picth 1
2356             index |= 1;
2357         }
2358         if (val & 0xCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC != 0) {
2359             // Pitch 2
2360             index |= 2;
2361         }
2362         if (val & 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0 != 0) {
2363             // Pitch 4
2364             index |= 4;
2365         }
2366         if (val & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00 != 0) {
2367             // Pitch 8
2368             index |= 8;
2369         }
2370         if (val & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000 != 0) {
2371             // Pitch 16
2372             index |= 16;
2373         }
2374         if (val & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000 != 0) {
2375             // Pitch 32
2376             index |= 32;
2377         }
2378         if (val & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000 != 0) {
2379             // Pitch 64
2380             index |= 64;
2381         }
2382         if (val & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000 != 0) {
2383             // Pitch 128
2384             index |= 128;
2385         }
2386     }
2387 
2388     /**
2389      * Shift realArg left or right until it is between 1 and 2. Return the
2390      * rescaled value, and the number of bits of right shift applied. Shift may be negative.
2391      *
2392      * Expresses realArg as realScaled * 2^shift, setting shift to put realArg between [1 and 2).
2393      *
2394      * Rejects 0 or negative arguments.
2395      */
2396     function rescale(int256 realArg) internal pure returns (int256 realScaled, int216 shift) {
2397         if (realArg <= 0) {
2398             // Not in domain!
2399             revert();
2400         }
2401 
2402         // Find the high bit
2403         int216 highBit = findbit(hibit(uint256(realArg)));
2404 
2405         // We'll shift so the high bit is the lowest non-fractional bit.
2406         shift = highBit - int216(REAL_FBITS);
2407 
2408         if (shift < 0) {
2409             // Shift left
2410             realScaled = realArg << -shift;
2411         } else if (shift >= 0) {
2412             // Shift right
2413             realScaled = realArg >> shift;
2414         }
2415     }
2416 
2417     /**
2418      * Calculate the natural log of a number. Rescales the input value and uses
2419      * the algorithm outlined at <https://math.stackexchange.com/a/977836> and
2420      * the ipow implementation.
2421      *
2422      * Lets you artificially limit the number of iterations.
2423      *
2424      * Note that it is potentially possible to get an un-converged value; lack
2425      * of convergence does not throw.
2426      */
2427     function lnLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
2428         if (realArg <= 0) {
2429             // Outside of acceptable domain
2430             revert();
2431         }
2432 
2433         if (realArg == REAL_ONE) {
2434             // Handle this case specially because people will want exactly 0 and
2435             // not ~2^-39 ish.
2436             return 0;
2437         }
2438 
2439         // We know it's positive, so rescale it to be between [1 and 2)
2440         int256 realRescaled;
2441         int216 shift;
2442         (realRescaled, shift) = rescale(realArg);
2443 
2444         // Compute the argument to iterate on
2445         int256 realSeriesArg = div(realRescaled - REAL_ONE, realRescaled + REAL_ONE);
2446 
2447         // We will accumulate the result here
2448         int256 realSeriesResult = 0;
2449 
2450         for (int216 n = 0; n < maxIterations; n++) {
2451             // Compute term n of the series
2452             int256 realTerm = div(ipow(realSeriesArg, 2 * n + 1), toReal(2 * n + 1));
2453             // And add it in
2454             realSeriesResult += realTerm;
2455             if (realTerm == 0) {
2456                 // We must have converged. Next term is too small to represent.
2457                 break;
2458             }
2459             // If we somehow never converge I guess we will run out of gas
2460         }
2461 
2462         // Double it to account for the factor of 2 outside the sum
2463         realSeriesResult = mul(realSeriesResult, REAL_TWO);
2464 
2465         // Now compute and return the overall result
2466         return mul(toReal(shift), REAL_LN_TWO) + realSeriesResult;
2467 
2468     }
2469 
2470     /**
2471      * Calculate a natural logarithm with a sensible maximum iteration count to
2472      * wait until convergence. Note that it is potentially possible to get an
2473      * un-converged value; lack of convergence does not throw.
2474      */
2475     function ln(int256 realArg) internal pure returns (int256) {
2476         return lnLimited(realArg, 100);
2477     }
2478 
2479     /**
2480      * Calculate e^x. Uses the series given at
2481      * <http://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap04/exp.html>.
2482      *
2483      * Lets you artificially limit the number of iterations.
2484      *
2485      * Note that it is potentially possible to get an un-converged value; lack
2486      * of convergence does not throw.
2487      */
2488     function expLimited(int256 realArg, int maxIterations) internal pure returns (int256) {
2489         // We will accumulate the result here
2490         int256 realResult = 0;
2491 
2492         // We use this to save work computing terms
2493         int256 realTerm = REAL_ONE;
2494 
2495         for (int216 n = 0; n < maxIterations; n++) {
2496             // Add in the term
2497             realResult += realTerm;
2498 
2499             // Compute the next term
2500             realTerm = mul(realTerm, div(realArg, toReal(n + 1)));
2501 
2502             if (realTerm == 0) {
2503                 // We must have converged. Next term is too small to represent.
2504                 break;
2505             }
2506             // If we somehow never converge I guess we will run out of gas
2507         }
2508 
2509         // Return the result
2510         return realResult;
2511 
2512     }
2513 
2514     /**
2515      * Calculate e^x with a sensible maximum iteration count to wait until
2516      * convergence. Note that it is potentially possible to get an un-converged
2517      * value; lack of convergence does not throw.
2518      */
2519     function exp(int256 realArg) internal pure returns (int256) {
2520         return expLimited(realArg, 100);
2521     }
2522 
2523     /**
2524      * Raise any number to any power, except for negative bases to fractional powers.
2525      */
2526     function pow(int256 realBase, int256 realExponent) internal pure returns (int256) {
2527         if (realExponent == 0) {
2528             // Anything to the 0 is 1
2529             return REAL_ONE;
2530         }
2531 
2532         if (realBase == 0) {
2533             if (realExponent < 0) {
2534                 // Outside of domain!
2535                 revert();
2536             }
2537             // Otherwise it's 0
2538             return 0;
2539         }
2540 
2541         if (fpart(realExponent) == 0) {
2542             // Anything (even a negative base) is super easy to do to an integer power.
2543 
2544             if (realExponent > 0) {
2545                 // Positive integer power is easy
2546                 return ipow(realBase, fromReal(realExponent));
2547             } else {
2548                 // Negative integer power is harder
2549                 return div(REAL_ONE, ipow(realBase, fromReal(-realExponent)));
2550             }
2551         }
2552 
2553         if (realBase < 0) {
2554             // It's a negative base to a non-integer power.
2555             // In general pow(-x^y) is undefined, unless y is an int or some
2556             // weird rational-number-based relationship holds.
2557             revert();
2558         }
2559 
2560         // If it's not a special case, actually do it.
2561         return exp(mul(realExponent, ln(realBase)));
2562     }
2563 
2564     /**
2565      * Compute the square root of a number.
2566      */
2567     function sqrt(int256 realArg) internal pure returns (int256) {
2568         return pow(realArg, REAL_HALF);
2569     }
2570 
2571     /**
2572      * Compute the sin of a number to a certain number of Taylor series terms.
2573      */
2574     function sinLimited(int256 _realArg, int216 maxIterations) internal pure returns (int256) {
2575         // First bring the number into 0 to 2 pi
2576         // TODO: This will introduce an error for very large numbers, because the error in our Pi will compound.
2577         // But for actual reasonable angle values we should be fine.
2578         int256 realArg = _realArg;
2579         realArg = realArg % REAL_TWO_PI;
2580 
2581         int256 accumulator = REAL_ONE;
2582 
2583         // We sum from large to small iteration so that we can have higher powers in later terms
2584         for (int216 iteration = maxIterations - 1; iteration >= 0; iteration--) {
2585             accumulator = REAL_ONE - mul(div(mul(realArg, realArg), toReal((2 * iteration + 2) * (2 * iteration + 3))), accumulator);
2586             // We can't stop early; we need to make it to the first term.
2587         }
2588 
2589         return mul(realArg, accumulator);
2590     }
2591 
2592     /**
2593      * Calculate sin(x) with a sensible maximum iteration count to wait until
2594      * convergence.
2595      */
2596     function sin(int256 realArg) internal pure returns (int256) {
2597         return sinLimited(realArg, 15);
2598     }
2599 
2600     /**
2601      * Calculate cos(x).
2602      */
2603     function cos(int256 realArg) internal pure returns (int256) {
2604         return sin(realArg + REAL_HALF_PI);
2605     }
2606 
2607     /**
2608      * Calculate tan(x). May overflow for large results. May throw if tan(x)
2609      * would be infinite, or return an approximation, or overflow.
2610      */
2611     function tan(int256 realArg) internal pure returns (int256) {
2612         return div(sin(realArg), cos(realArg));
2613     }
2614 }
2615 
2616 // File: openzeppelin-solidity/contracts/ECRecovery.sol
2617 
2618 /**
2619  * @title Eliptic curve signature operations
2620  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
2621  * TODO Remove this library once solidity supports passing a signature to ecrecover.
2622  * See https://github.com/ethereum/solidity/issues/864
2623  */
2624 
2625 library ECRecovery {
2626 
2627   /**
2628    * @dev Recover signer address from a message by using their signature
2629    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
2630    * @param sig bytes signature, the signature is generated using web3.eth.sign()
2631    */
2632   function recover(bytes32 hash, bytes sig)
2633     internal
2634     pure
2635     returns (address)
2636   {
2637     bytes32 r;
2638     bytes32 s;
2639     uint8 v;
2640 
2641     // Check the signature length
2642     if (sig.length != 65) {
2643       return (address(0));
2644     }
2645 
2646     // Divide the signature in r, s and v variables
2647     // ecrecover takes the signature parameters, and the only way to get them
2648     // currently is to use assembly.
2649     // solium-disable-next-line security/no-inline-assembly
2650     assembly {
2651       r := mload(add(sig, 32))
2652       s := mload(add(sig, 64))
2653       v := byte(0, mload(add(sig, 96)))
2654     }
2655 
2656     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
2657     if (v < 27) {
2658       v += 27;
2659     }
2660 
2661     // If the version is correct return the signer address
2662     if (v != 27 && v != 28) {
2663       return (address(0));
2664     } else {
2665       // solium-disable-next-line arg-overflow
2666       return ecrecover(hash, v, r, s);
2667     }
2668   }
2669 
2670   /**
2671    * toEthSignedMessageHash
2672    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
2673    * and hash the result
2674    */
2675   function toEthSignedMessageHash(bytes32 hash)
2676     internal
2677     pure
2678     returns (bytes32)
2679   {
2680     // 32 is the length in bytes of hash,
2681     // enforced by the type signature above
2682     return keccak256(
2683       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
2684     );
2685   }
2686 }
2687 
2688 // File: contracts/libs/OrderStatisticTree.sol
2689 
2690 library OrderStatisticTree {
2691 
2692     struct Node {
2693         mapping (bool => uint) children; // a mapping of left(false) child and right(true) child nodes
2694         uint parent; // parent node
2695         bool side;   // side of the node on the tree (left or right)
2696         uint height; //Height of this node
2697         uint count; //Number of tree nodes below this node (including this one)
2698         uint dupes; //Number of duplicates values for this node
2699     }
2700 
2701     struct Tree {
2702         // a mapping between node value(uint) to Node
2703         // the tree's root is always at node 0 ,which points to the "real" tree
2704         // as its right child.this is done to eliminate the need to update the tree
2705         // root in the case of rotation.(saving gas).
2706         mapping(uint => Node) nodes;
2707     }
2708     /**
2709      * @dev rank - find the rank of a value in the tree,
2710      *      i.e. its index in the sorted list of elements of the tree
2711      * @param _tree the tree
2712      * @param _value the input value to find its rank.
2713      * @return smaller - the number of elements in the tree which their value is
2714      * less than the input value.
2715      */
2716     function rank(Tree storage _tree,uint _value) internal view returns (uint smaller) {
2717         if (_value != 0) {
2718             smaller = _tree.nodes[0].dupes;
2719 
2720             uint cur = _tree.nodes[0].children[true];
2721             Node storage currentNode = _tree.nodes[cur];
2722 
2723             while (true) {
2724                 if (cur <= _value) {
2725                     if (cur<_value) {
2726                         smaller = smaller + 1+currentNode.dupes;
2727                     }
2728                     uint leftChild = currentNode.children[false];
2729                     if (leftChild!=0) {
2730                         smaller = smaller + _tree.nodes[leftChild].count;
2731                     }
2732                 }
2733                 if (cur == _value) {
2734                     break;
2735                 }
2736                 cur = currentNode.children[cur<_value];
2737                 if (cur == 0) {
2738                     break;
2739                 }
2740                 currentNode = _tree.nodes[cur];
2741             }
2742         }
2743     }
2744 
2745     function count(Tree storage _tree) internal view returns (uint) {
2746         Node storage root = _tree.nodes[0];
2747         Node memory child = _tree.nodes[root.children[true]];
2748         return root.dupes+child.count;
2749     }
2750 
2751     function updateCount(Tree storage _tree,uint _value) private {
2752         Node storage n = _tree.nodes[_value];
2753         n.count = 1+_tree.nodes[n.children[false]].count+_tree.nodes[n.children[true]].count+n.dupes;
2754     }
2755 
2756     function updateCounts(Tree storage _tree,uint _value) private {
2757         uint parent = _tree.nodes[_value].parent;
2758         while (parent!=0) {
2759             updateCount(_tree,parent);
2760             parent = _tree.nodes[parent].parent;
2761         }
2762     }
2763 
2764     function updateHeight(Tree storage _tree,uint _value) private {
2765         Node storage n = _tree.nodes[_value];
2766         uint heightLeft = _tree.nodes[n.children[false]].height;
2767         uint heightRight = _tree.nodes[n.children[true]].height;
2768         if (heightLeft > heightRight)
2769             n.height = heightLeft+1;
2770         else
2771             n.height = heightRight+1;
2772     }
2773 
2774     function balanceFactor(Tree storage _tree,uint _value) private view returns (int bf) {
2775         Node storage n = _tree.nodes[_value];
2776         return int(_tree.nodes[n.children[false]].height)-int(_tree.nodes[n.children[true]].height);
2777     }
2778 
2779     function rotate(Tree storage _tree,uint _value,bool dir) private {
2780         bool otherDir = !dir;
2781         Node storage n = _tree.nodes[_value];
2782         bool side = n.side;
2783         uint parent = n.parent;
2784         uint valueNew = n.children[otherDir];
2785         Node storage nNew = _tree.nodes[valueNew];
2786         uint orphan = nNew.children[dir];
2787         Node storage p = _tree.nodes[parent];
2788         Node storage o = _tree.nodes[orphan];
2789         p.children[side] = valueNew;
2790         nNew.side = side;
2791         nNew.parent = parent;
2792         nNew.children[dir] = _value;
2793         n.parent = valueNew;
2794         n.side = dir;
2795         n.children[otherDir] = orphan;
2796         o.parent = _value;
2797         o.side = otherDir;
2798         updateHeight(_tree,_value);
2799         updateHeight(_tree,valueNew);
2800         updateCount(_tree,_value);
2801         updateCount(_tree,valueNew);
2802     }
2803 
2804     function rebalanceInsert(Tree storage _tree,uint _nValue) private {
2805         updateHeight(_tree,_nValue);
2806         Node storage n = _tree.nodes[_nValue];
2807         uint pValue = n.parent;
2808         if (pValue!=0) {
2809             int pBf = balanceFactor(_tree,pValue);
2810             bool side = n.side;
2811             int sign;
2812             if (side)
2813                 sign = -1;
2814             else
2815                 sign = 1;
2816             if (pBf == sign*2) {
2817                 if (balanceFactor(_tree,_nValue) == (-1 * sign)) {
2818                     rotate(_tree,_nValue,side);
2819                 }
2820                 rotate(_tree,pValue,!side);
2821             } else if (pBf != 0) {
2822                 rebalanceInsert(_tree,pValue);
2823             }
2824         }
2825     }
2826 
2827     function rebalanceDelete(Tree storage _tree,uint _pValue,bool side) private {
2828         if (_pValue!=0) {
2829             updateHeight(_tree,_pValue);
2830             int pBf = balanceFactor(_tree,_pValue);
2831             int sign;
2832             if (side)
2833                 sign = 1;
2834             else
2835                 sign = -1;
2836             int bf = balanceFactor(_tree,_pValue);
2837             if (bf==(2*sign)) {
2838                 Node storage p = _tree.nodes[_pValue];
2839                 uint sValue = p.children[!side];
2840                 int sBf = balanceFactor(_tree,sValue);
2841                 if (sBf == (-1 * sign)) {
2842                     rotate(_tree,sValue,!side);
2843                 }
2844                 rotate(_tree,_pValue,side);
2845                 if (sBf!=0) {
2846                     p = _tree.nodes[_pValue];
2847                     rebalanceDelete(_tree,p.parent,p.side);
2848                 }
2849             } else if (pBf != sign) {
2850                 p = _tree.nodes[_pValue];
2851                 rebalanceDelete(_tree,p.parent,p.side);
2852             }
2853         }
2854     }
2855 
2856     function fixParents(Tree storage _tree,uint parent,bool side) private {
2857         if (parent!=0) {
2858             updateCount(_tree,parent);
2859             updateCounts(_tree,parent);
2860             rebalanceDelete(_tree,parent,side);
2861         }
2862     }
2863 
2864     function insertHelper(Tree storage _tree,uint _pValue,bool _side,uint _value) private {
2865         Node storage root = _tree.nodes[_pValue];
2866         uint cValue = root.children[_side];
2867         if (cValue==0) {
2868             root.children[_side] = _value;
2869             Node storage child = _tree.nodes[_value];
2870             child.parent = _pValue;
2871             child.side = _side;
2872             child.height = 1;
2873             child.count = 1;
2874             updateCounts(_tree,_value);
2875             rebalanceInsert(_tree,_value);
2876         } else if (cValue==_value) {
2877             _tree.nodes[cValue].dupes++;
2878             updateCount(_tree,_value);
2879             updateCounts(_tree,_value);
2880         } else {
2881             insertHelper(_tree,cValue,(_value >= cValue),_value);
2882         }
2883     }
2884 
2885     function insert(Tree storage _tree,uint _value) internal {
2886         if (_value==0) {
2887             _tree.nodes[_value].dupes++;
2888         } else {
2889             insertHelper(_tree,0,true,_value);
2890         }
2891     }
2892 
2893     function rightmostLeaf(Tree storage _tree,uint _value) private view returns (uint leaf) {
2894         uint child = _tree.nodes[_value].children[true];
2895         if (child!=0) {
2896             return rightmostLeaf(_tree,child);
2897         } else {
2898             return _value;
2899         }
2900     }
2901 
2902     function zeroOut(Tree storage _tree,uint _value) private {
2903         Node storage n = _tree.nodes[_value];
2904         n.parent = 0;
2905         n.side = false;
2906         n.children[false] = 0;
2907         n.children[true] = 0;
2908         n.count = 0;
2909         n.height = 0;
2910         n.dupes = 0;
2911     }
2912 
2913     function removeBranch(Tree storage _tree,uint _value,uint _left) private {
2914         uint ipn = rightmostLeaf(_tree,_left);
2915         Node storage i = _tree.nodes[ipn];
2916         uint dupes = i.dupes;
2917         removeHelper(_tree,ipn);
2918         Node storage n = _tree.nodes[_value];
2919         uint parent = n.parent;
2920         Node storage p = _tree.nodes[parent];
2921         uint height = n.height;
2922         bool side = n.side;
2923         uint ncount = n.count;
2924         uint right = n.children[true];
2925         uint left = n.children[false];
2926         p.children[side] = ipn;
2927         i.parent = parent;
2928         i.side = side;
2929         i.count = ncount+dupes-n.dupes;
2930         i.height = height;
2931         i.dupes = dupes;
2932         if (left!=0) {
2933             i.children[false] = left;
2934             _tree.nodes[left].parent = ipn;
2935         }
2936         if (right!=0) {
2937             i.children[true] = right;
2938             _tree.nodes[right].parent = ipn;
2939         }
2940         zeroOut(_tree,_value);
2941         updateCounts(_tree,ipn);
2942     }
2943 
2944     function removeHelper(Tree storage _tree,uint _value) private {
2945         Node storage n = _tree.nodes[_value];
2946         uint parent = n.parent;
2947         bool side = n.side;
2948         Node storage p = _tree.nodes[parent];
2949         uint left = n.children[false];
2950         uint right = n.children[true];
2951         if ((left == 0) && (right == 0)) {
2952             p.children[side] = 0;
2953             zeroOut(_tree,_value);
2954             fixParents(_tree,parent,side);
2955         } else if ((left != 0) && (right != 0)) {
2956             removeBranch(_tree,_value,left);
2957         } else {
2958             uint child = left+right;
2959             Node storage c = _tree.nodes[child];
2960             p.children[side] = child;
2961             c.parent = parent;
2962             c.side = side;
2963             zeroOut(_tree,_value);
2964             fixParents(_tree,parent,side);
2965         }
2966     }
2967 
2968     function remove(Tree storage _tree,uint _value) internal {
2969         Node storage n = _tree.nodes[_value];
2970         if (_value==0) {
2971             if (n.dupes==0) {
2972                 return;
2973             }
2974         } else {
2975             if (n.count==0) {
2976                 return;
2977             }
2978         }
2979         if (n.dupes>0) {
2980             n.dupes--;
2981             if (_value!=0) {
2982                 n.count--;
2983             }
2984             fixParents(_tree,n.parent,n.side);
2985         } else {
2986             removeHelper(_tree,_value);
2987         }
2988     }
2989 
2990 }
2991 
2992 // File: contracts/VotingMachines/GenesisProtocol.sol
2993 
2994 /**
2995  * @title GenesisProtocol implementation -an organization's voting machine scheme.
2996  */
2997 
2998 
2999 contract GenesisProtocol is IntVoteInterface,UniversalScheme {
3000     using SafeMath for uint;
3001     using RealMath for int216;
3002     using RealMath for int256;
3003     using ECRecovery for bytes32;
3004     using OrderStatisticTree for OrderStatisticTree.Tree;
3005 
3006     enum ProposalState { None ,Closed, Executed, PreBoosted,Boosted,QuietEndingPeriod }
3007     enum ExecutionState { None, PreBoostedTimeOut, PreBoostedBarCrossed, BoostedTimeOut,BoostedBarCrossed }
3008 
3009     //Organization's parameters
3010     struct Parameters {
3011         uint preBoostedVoteRequiredPercentage; // the absolute vote percentages bar.
3012         uint preBoostedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
3013         uint boostedVotePeriodLimit; //the time limit for a proposal to be in an relative voting mode.
3014         uint thresholdConstA;//constant A for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
3015         uint thresholdConstB;//constant B for threshold calculation . threshold =A * (e ** (numberOfBoostedProposals/B))
3016         uint minimumStakingFee; //minimum staking fee allowed.
3017         uint quietEndingPeriod; //quite ending period
3018         uint proposingRepRewardConstA;//constant A for calculate proposer reward. proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
3019         uint proposingRepRewardConstB;//constant B for calculate proposing reward.proposerReward =(A*(RTotal) +B*(R+ - R-))/1000
3020         uint stakerFeeRatioForVoters; // The “ratio of stake” to be paid to voters.
3021                                       // All stakers pay a portion of their stake to all voters, stakerFeeRatioForVoters * (s+ + s-).
3022                                       //All voters (pre and during boosting period) divide this portion in proportion to their reputation.
3023         uint votersReputationLossRatio;//Unsuccessful pre booster voters lose votersReputationLossRatio% of their reputation.
3024         uint votersGainRepRatioFromLostRep; //the percentages of the lost reputation which is divided by the successful pre boosted voters,
3025                                             //in proportion to their reputation.
3026                                             //The rest (100-votersGainRepRatioFromLostRep)% of lost reputation is divided between the successful wagers,
3027                                             //in proportion to their stake.
3028         uint daoBountyConst;//The DAO adds up a bounty for successful staker.
3029                             //The bounty formula is: s * daoBountyConst, where s+ is the wager staked for the proposal,
3030                             //and  daoBountyConst is a constant factor that is configurable and changeable by the DAO given.
3031                             //  daoBountyConst should be greater than stakerFeeRatioForVoters and less than 2 * stakerFeeRatioForVoters.
3032         uint daoBountyLimit;//The daoBounty cannot be greater than daoBountyLimit.
3033 
3034 
3035 
3036     }
3037     struct Voter {
3038         uint vote; // YES(1) ,NO(2)
3039         uint reputation; // amount of voter's reputation
3040         bool preBoosted;
3041     }
3042 
3043     struct Staker {
3044         uint vote; // YES(1) ,NO(2)
3045         uint amount; // amount of staker's stake
3046         uint amountForBounty; // amount of staker's stake which will be use for bounty calculation
3047     }
3048 
3049     struct Proposal {
3050         address avatar; // the organization's avatar the proposal is target to.
3051         uint numOfChoices;
3052         ExecutableInterface executable; // will be executed if the proposal will pass
3053         uint votersStakes;
3054         uint submittedTime;
3055         uint boostedPhaseTime; //the time the proposal shift to relative mode.
3056         ProposalState state;
3057         uint winningVote; //the winning vote.
3058         address proposer;
3059         uint currentBoostedVotePeriodLimit;
3060         bytes32 paramsHash;
3061         uint daoBountyRemain;
3062         uint[2] totalStakes;// totalStakes[0] - (amount staked minus fee) - Total number of tokens staked which can be redeemable by stakers.
3063                             // totalStakes[1] - (amount staked) - Total number of redeemable tokens.
3064         //      vote      reputation
3065         mapping(uint    =>  uint     ) votes;
3066         //      vote      reputation
3067         mapping(uint    =>  uint     ) preBoostedVotes;
3068         //      address     voter
3069         mapping(address =>  Voter    ) voters;
3070         //      vote        stakes
3071         mapping(uint    =>  uint     ) stakes;
3072         //      address  staker
3073         mapping(address  => Staker   ) stakers;
3074     }
3075 
3076     event GPExecuteProposal(bytes32 indexed _proposalId, ExecutionState _executionState);
3077     event Stake(bytes32 indexed _proposalId, address indexed _avatar, address indexed _staker,uint _vote,uint _amount);
3078     event Redeem(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
3079     event RedeemDaoBounty(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
3080     event RedeemReputation(bytes32 indexed _proposalId, address indexed _avatar, address indexed _beneficiary,uint _amount);
3081 
3082     mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
3083     mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
3084 
3085     mapping(bytes=>bool) stakeSignatures; //stake signatures
3086 
3087     uint constant public NUM_OF_CHOICES = 2;
3088     uint constant public NO = 2;
3089     uint constant public YES = 1;
3090     uint public proposalsCnt; // Total number of proposals
3091     mapping(address=>uint) orgBoostedProposalsCnt;
3092     StandardToken public stakingToken;
3093     mapping(address=>OrderStatisticTree.Tree) proposalsExpiredTimes; //proposals expired times
3094 
3095     /**
3096      * @dev Constructor
3097      */
3098     constructor(StandardToken _stakingToken) public
3099     {
3100         stakingToken = _stakingToken;
3101     }
3102 
3103   /**
3104    * @dev Check that the proposal is votable (open and not executed yet)
3105    */
3106     modifier votable(bytes32 _proposalId) {
3107         require(_isVotable(_proposalId));
3108         _;
3109     }
3110 
3111     /**
3112      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
3113      * generated by calculating keccak256 of a incremented counter.
3114      * @param _numOfChoices number of voting choices
3115      * @param _avatar an address to be sent as the payload to the _executable contract.
3116      * @param _executable This contract will be executed when vote is over.
3117      * @param _proposer address
3118      * @return proposal's id.
3119      */
3120     function propose(uint _numOfChoices, bytes32 , address _avatar, ExecutableInterface _executable,address _proposer)
3121         external
3122         returns(bytes32)
3123     {
3124           // Check valid params and number of choices:
3125         require(_numOfChoices == NUM_OF_CHOICES);
3126         require(ExecutableInterface(_executable) != address(0));
3127         //Check parameters existence.
3128         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
3129 
3130         require(parameters[paramsHash].preBoostedVoteRequiredPercentage > 0);
3131         // Generate a unique ID:
3132         bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
3133         proposalsCnt++;
3134         // Open proposal:
3135         Proposal memory proposal;
3136         proposal.numOfChoices = _numOfChoices;
3137         proposal.avatar = _avatar;
3138         proposal.executable = _executable;
3139         proposal.state = ProposalState.PreBoosted;
3140         // solium-disable-next-line security/no-block-members
3141         proposal.submittedTime = now;
3142         proposal.currentBoostedVotePeriodLimit = parameters[paramsHash].boostedVotePeriodLimit;
3143         proposal.proposer = _proposer;
3144         proposal.winningVote = NO;
3145         proposal.paramsHash = paramsHash;
3146         proposals[proposalId] = proposal;
3147         emit NewProposal(proposalId, _avatar, _numOfChoices, _proposer, paramsHash);
3148         return proposalId;
3149     }
3150 
3151   /**
3152    * @dev Cancel a proposal, only the owner can call this function and only if allowOwner flag is true.
3153    */
3154     function cancelProposal(bytes32 ) external returns(bool) {
3155         //This is not allowed.
3156         return false;
3157     }
3158 
3159     /**
3160      * @dev staking function
3161      * @param _proposalId id of the proposal
3162      * @param _vote  NO(2) or YES(1).
3163      * @param _amount the betting amount
3164      * @return bool true - the proposal has been executed
3165      *              false - otherwise.
3166      */
3167     function stake(bytes32 _proposalId, uint _vote, uint _amount) external returns(bool) {
3168         return _stake(_proposalId,_vote,_amount,msg.sender);
3169     }
3170 
3171     // Digest describing the data the user signs according EIP 712.
3172     // Needs to match what is passed to Metamask.
3173     bytes32 public constant DELEGATION_HASH_EIP712 =
3174     keccak256(abi.encodePacked("address GenesisProtocolAddress","bytes32 ProposalId", "uint Vote","uint AmountToStake","uint Nonce"));
3175     // web3.eth.sign prefix
3176     string public constant ETH_SIGN_PREFIX= "\x19Ethereum Signed Message:\n32";
3177 
3178     /**
3179      * @dev stakeWithSignature function
3180      * @param _proposalId id of the proposal
3181      * @param _vote  NO(2) or YES(1).
3182      * @param _amount the betting amount
3183      * @param _nonce nonce value ,it is part of the signature to ensure that
3184               a signature can be received only once.
3185      * @param _signatureType signature type
3186               1 - for web3.eth.sign
3187               2 - for eth_signTypedData according to EIP #712.
3188      * @param _signature  - signed data by the staker
3189      * @return bool true - the proposal has been executed
3190      *              false - otherwise.
3191      */
3192     function stakeWithSignature(
3193         bytes32 _proposalId,
3194         uint _vote,
3195         uint _amount,
3196         uint _nonce,
3197         uint _signatureType,
3198         bytes _signature
3199         )
3200         external
3201         returns(bool)
3202         {
3203         require(stakeSignatures[_signature] == false);
3204         // Recreate the digest the user signed
3205         bytes32 delegationDigest;
3206         if (_signatureType == 2) {
3207             delegationDigest = keccak256(
3208                 abi.encodePacked(
3209                     DELEGATION_HASH_EIP712, keccak256(
3210                         abi.encodePacked(
3211                            address(this),
3212                           _proposalId,
3213                           _vote,
3214                           _amount,
3215                           _nonce)))
3216             );
3217         } else {
3218             delegationDigest = keccak256(
3219                 abi.encodePacked(
3220                     ETH_SIGN_PREFIX, keccak256(
3221                         abi.encodePacked(
3222                             address(this),
3223                            _proposalId,
3224                            _vote,
3225                            _amount,
3226                            _nonce)))
3227             );
3228         }
3229         address staker = delegationDigest.recover(_signature);
3230         //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
3231         require(staker!=address(0));
3232         stakeSignatures[_signature] = true;
3233         return _stake(_proposalId,_vote,_amount,staker);
3234     }
3235 
3236   /**
3237    * @dev voting function
3238    * @param _proposalId id of the proposal
3239    * @param _vote NO(2) or YES(1).
3240    * @return bool true - the proposal has been executed
3241    *              false - otherwise.
3242    */
3243     function vote(bytes32 _proposalId, uint _vote) external votable(_proposalId) returns(bool) {
3244         return internalVote(_proposalId, msg.sender, _vote, 0);
3245     }
3246 
3247   /**
3248    * @dev voting function with owner functionality (can vote on behalf of someone else)
3249    * @return bool true - the proposal has been executed
3250    *              false - otherwise.
3251    */
3252     function ownerVote(bytes32 , uint , address ) external returns(bool) {
3253       //This is not allowed.
3254         return false;
3255     }
3256 
3257     function voteWithSpecifiedAmounts(bytes32 _proposalId,uint _vote,uint _rep,uint) external votable(_proposalId) returns(bool) {
3258         return internalVote(_proposalId,msg.sender,_vote,_rep);
3259     }
3260 
3261   /**
3262    * @dev Cancel the vote of the msg.sender.
3263    * cancel vote is not allow in genesisProtocol so this function doing nothing.
3264    * This function is here in order to comply to the IntVoteInterface .
3265    */
3266     function cancelVote(bytes32 _proposalId) external votable(_proposalId) {
3267        //this is not allowed
3268         return;
3269     }
3270 
3271   /**
3272     * @dev getNumberOfChoices returns the number of choices possible in this proposal
3273     * @param _proposalId the ID of the proposals
3274     * @return uint that contains number of choices
3275     */
3276     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint) {
3277         return proposals[_proposalId].numOfChoices;
3278     }
3279 
3280     /**
3281      * @dev voteInfo returns the vote and the amount of reputation of the user committed to this proposal
3282      * @param _proposalId the ID of the proposal
3283      * @param _voter the address of the voter
3284      * @return uint vote - the voters vote
3285      *        uint reputation - amount of reputation committed by _voter to _proposalId
3286      */
3287     function voteInfo(bytes32 _proposalId, address _voter) external view returns(uint, uint) {
3288         Voter memory voter = proposals[_proposalId].voters[_voter];
3289         return (voter.vote, voter.reputation);
3290     }
3291 
3292     /**
3293     * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
3294     * @param _proposalId the ID of the proposal
3295     * @param _choice the index in the
3296     * @return voted reputation for the given choice
3297     */
3298     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint) {
3299         return proposals[_proposalId].votes[_choice];
3300     }
3301 
3302     /**
3303     * @dev isVotable check if the proposal is votable
3304     * @param _proposalId the ID of the proposal
3305     * @return bool true or false
3306     */
3307     function isVotable(bytes32 _proposalId) external view returns(bool) {
3308         return _isVotable(_proposalId);
3309     }
3310 
3311     /**
3312     * @dev proposalStatus return the total votes and stakes for a given proposal
3313     * @param _proposalId the ID of the proposal
3314     * @return uint preBoostedVotes YES
3315     * @return uint preBoostedVotes NO
3316     * @return uint stakersStakes
3317     * @return uint totalRedeemableStakes
3318     * @return uint total stakes YES
3319     * @return uint total stakes NO
3320     */
3321     function proposalStatus(bytes32 _proposalId) external view returns(uint, uint, uint ,uint, uint ,uint) {
3322         return (
3323                 proposals[_proposalId].preBoostedVotes[YES],
3324                 proposals[_proposalId].preBoostedVotes[NO],
3325                 proposals[_proposalId].totalStakes[0],
3326                 proposals[_proposalId].totalStakes[1],
3327                 proposals[_proposalId].stakes[YES],
3328                 proposals[_proposalId].stakes[NO]
3329         );
3330     }
3331 
3332   /**
3333     * @dev proposalAvatar return the avatar for a given proposal
3334     * @param _proposalId the ID of the proposal
3335     * @return uint total reputation supply
3336     */
3337     function proposalAvatar(bytes32 _proposalId) external view returns(address) {
3338         return (proposals[_proposalId].avatar);
3339     }
3340 
3341   /**
3342     * @dev scoreThresholdParams return the score threshold params for a given
3343     * organization.
3344     * @param _avatar the organization's avatar
3345     * @return uint thresholdConstA
3346     * @return uint thresholdConstB
3347     */
3348     function scoreThresholdParams(address _avatar) external view returns(uint,uint) {
3349         bytes32 paramsHash = getParametersFromController(Avatar(_avatar));
3350         Parameters memory params = parameters[paramsHash];
3351         return (params.thresholdConstA,params.thresholdConstB);
3352     }
3353 
3354     /**
3355       * @dev getStaker return the vote and stake amount for a given proposal and staker
3356       * @param _proposalId the ID of the proposal
3357       * @param _staker staker address
3358       * @return uint vote
3359       * @return uint amount
3360     */
3361     function getStaker(bytes32 _proposalId,address _staker) external view returns(uint,uint) {
3362         return (proposals[_proposalId].stakers[_staker].vote,proposals[_proposalId].stakers[_staker].amount);
3363     }
3364 
3365     /**
3366       * @dev state return the state for a given proposal
3367       * @param _proposalId the ID of the proposal
3368       * @return ProposalState proposal state
3369     */
3370     function state(bytes32 _proposalId) external view returns(ProposalState) {
3371         return proposals[_proposalId].state;
3372     }
3373 
3374     /**
3375     * @dev winningVote return the winningVote for a given proposal
3376     * @param _proposalId the ID of the proposal
3377     * @return uint winningVote
3378     */
3379     function winningVote(bytes32 _proposalId) external view returns(uint) {
3380         return proposals[_proposalId].winningVote;
3381     }
3382 
3383    /**
3384     * @dev isAbstainAllow returns if the voting machine allow abstain (0)
3385     * @return bool true or false
3386     */
3387     function isAbstainAllow() external pure returns(bool) {
3388         return false;
3389     }
3390 
3391     /**
3392      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
3393      * @return min - minimum number of choices
3394                max - maximum number of choices
3395      */
3396     function getAllowedRangeOfChoices() external pure returns(uint min,uint max) {
3397         return (NUM_OF_CHOICES,NUM_OF_CHOICES);
3398     }
3399 
3400     /**
3401     * @dev execute check if the proposal has been decided, and if so, execute the proposal
3402     * @param _proposalId the id of the proposal
3403     * @return bool true - the proposal has been executed
3404     *              false - otherwise.
3405    */
3406     function execute(bytes32 _proposalId) external votable(_proposalId) returns(bool) {
3407         return _execute(_proposalId);
3408     }
3409 
3410     /**
3411      * @dev redeem a reward for a successful stake, vote or proposing.
3412      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
3413      * users to redeem on behalf of someone else.
3414      * @param _proposalId the ID of the proposal
3415      * @param _beneficiary - the beneficiary address
3416      * @return rewards -
3417      *         rewards[0] - stakerTokenAmount
3418      *         rewards[1] - stakerReputationAmount
3419      *         rewards[2] - voterTokenAmount
3420      *         rewards[3] - voterReputationAmount
3421      *         rewards[4] - proposerReputationAmount
3422      * @return reputation - redeem reputation
3423      */
3424     function redeem(bytes32 _proposalId,address _beneficiary) public returns (uint[5] rewards) {
3425         Proposal storage proposal = proposals[_proposalId];
3426         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed),"wrong proposal state");
3427         Parameters memory params = parameters[proposal.paramsHash];
3428         uint amount;
3429         uint reputation;
3430         uint lostReputation;
3431         if (proposal.winningVote == YES) {
3432             lostReputation = proposal.preBoostedVotes[NO];
3433         } else {
3434             lostReputation = proposal.preBoostedVotes[YES];
3435         }
3436         lostReputation = (lostReputation * params.votersReputationLossRatio)/100;
3437         //as staker
3438         Staker storage staker = proposal.stakers[_beneficiary];
3439         if ((staker.amount>0) &&
3440              (staker.vote == proposal.winningVote)) {
3441             uint totalWinningStakes = proposal.stakes[proposal.winningVote];
3442             if (totalWinningStakes != 0) {
3443                 rewards[0] = (staker.amount * proposal.totalStakes[0]) / totalWinningStakes;
3444             }
3445             if (proposal.state != ProposalState.Closed) {
3446                 rewards[1] = (staker.amount * ( lostReputation - ((lostReputation * params.votersGainRepRatioFromLostRep)/100)))/proposal.stakes[proposal.winningVote];
3447             }
3448             staker.amount = 0;
3449         }
3450         //as voter
3451         Voter storage voter = proposal.voters[_beneficiary];
3452         if ((voter.reputation != 0 ) && (voter.preBoosted)) {
3453             uint preBoostedVotes = proposal.preBoostedVotes[YES] + proposal.preBoostedVotes[NO];
3454             if (preBoostedVotes>0) {
3455                 rewards[2] = ((proposal.votersStakes * voter.reputation) / preBoostedVotes);
3456             }
3457             if (proposal.state == ProposalState.Closed) {
3458               //give back reputation for the voter
3459                 rewards[3] = ((voter.reputation * params.votersReputationLossRatio)/100);
3460             } else if (proposal.winningVote == voter.vote ) {
3461                 rewards[3] = (((voter.reputation * params.votersReputationLossRatio)/100) +
3462                 (((voter.reputation * lostReputation * params.votersGainRepRatioFromLostRep)/100)/preBoostedVotes));
3463             }
3464             voter.reputation = 0;
3465         }
3466         //as proposer
3467         if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == YES)&&(proposal.proposer != address(0))) {
3468             rewards[4] = (params.proposingRepRewardConstA.mul(proposal.votes[YES]+proposal.votes[NO]) + params.proposingRepRewardConstB.mul(proposal.votes[YES]-proposal.votes[NO]))/1000;
3469             proposal.proposer = 0;
3470         }
3471         amount = rewards[0] + rewards[2];
3472         reputation = rewards[1] + rewards[3] + rewards[4];
3473         if (amount != 0) {
3474             proposal.totalStakes[1] = proposal.totalStakes[1].sub(amount);
3475             require(stakingToken.transfer(_beneficiary, amount));
3476             emit Redeem(_proposalId,proposal.avatar,_beneficiary,amount);
3477         }
3478         if (reputation != 0 ) {
3479             ControllerInterface(Avatar(proposal.avatar).owner()).mintReputation(reputation,_beneficiary,proposal.avatar);
3480             emit RedeemReputation(_proposalId,proposal.avatar,_beneficiary,reputation);
3481         }
3482     }
3483 
3484     /**
3485      * @dev redeemDaoBounty a reward for a successful stake, vote or proposing.
3486      * The function use a beneficiary address as a parameter (and not msg.sender) to enable
3487      * users to redeem on behalf of someone else.
3488      * @param _proposalId the ID of the proposal
3489      * @param _beneficiary - the beneficiary address
3490      * @return redeemedAmount - redeem token amount
3491      * @return potentialAmount - potential redeem token amount(if there is enough tokens bounty at the avatar )
3492      */
3493     function redeemDaoBounty(bytes32 _proposalId,address _beneficiary) public returns(uint redeemedAmount,uint potentialAmount) {
3494         Proposal storage proposal = proposals[_proposalId];
3495         require((proposal.state == ProposalState.Executed) || (proposal.state == ProposalState.Closed));
3496         uint totalWinningStakes = proposal.stakes[proposal.winningVote];
3497         if (
3498           // solium-disable-next-line operator-whitespace
3499             (proposal.stakers[_beneficiary].amountForBounty>0)&&
3500             (proposal.stakers[_beneficiary].vote == proposal.winningVote)&&
3501             (proposal.winningVote == YES)&&
3502             (totalWinningStakes != 0))
3503         {
3504             //as staker
3505             Parameters memory params = parameters[proposal.paramsHash];
3506             uint beneficiaryLimit = (proposal.stakers[_beneficiary].amountForBounty.mul(params.daoBountyLimit)) / totalWinningStakes;
3507             potentialAmount = (params.daoBountyConst.mul(proposal.stakers[_beneficiary].amountForBounty))/100;
3508             if (potentialAmount > beneficiaryLimit) {
3509                 potentialAmount = beneficiaryLimit;
3510             }
3511         }
3512         if ((potentialAmount != 0)&&(stakingToken.balanceOf(proposal.avatar) >= potentialAmount)) {
3513             proposal.daoBountyRemain = proposal.daoBountyRemain.sub(potentialAmount);
3514             require(ControllerInterface(Avatar(proposal.avatar).owner()).externalTokenTransfer(stakingToken,_beneficiary,potentialAmount,proposal.avatar));
3515             proposal.stakers[_beneficiary].amountForBounty = 0;
3516             redeemedAmount = potentialAmount;
3517             emit RedeemDaoBounty(_proposalId,proposal.avatar,_beneficiary,redeemedAmount);
3518         }
3519     }
3520 
3521     /**
3522      * @dev shouldBoost check if a proposal should be shifted to boosted phase.
3523      * @param _proposalId the ID of the proposal
3524      * @return bool true or false.
3525      */
3526     function shouldBoost(bytes32 _proposalId) public view returns(bool) {
3527         Proposal memory proposal = proposals[_proposalId];
3528         return (_score(_proposalId) >= threshold(proposal.paramsHash,proposal.avatar));
3529     }
3530 
3531     /**
3532      * @dev score return the proposal score
3533      * @param _proposalId the ID of the proposal
3534      * @return uint proposal score.
3535      */
3536     function score(bytes32 _proposalId) public view returns(int) {
3537         return _score(_proposalId);
3538     }
3539 
3540     /**
3541      * @dev getBoostedProposalsCount return the number of boosted proposal for an organization
3542      * @param _avatar the organization avatar
3543      * @return uint number of boosted proposals
3544      */
3545     function getBoostedProposalsCount(address _avatar) public view returns(uint) {
3546         uint expiredProposals;
3547         if (proposalsExpiredTimes[_avatar].count() != 0) {
3548           // solium-disable-next-line security/no-block-members
3549             expiredProposals = proposalsExpiredTimes[_avatar].rank(now);
3550         }
3551         return orgBoostedProposalsCnt[_avatar].sub(expiredProposals);
3552     }
3553 
3554     /**
3555      * @dev threshold return the organization's score threshold which required by
3556      * a proposal to shift to boosted state.
3557      * This threshold is dynamically set and it depend on the number of boosted proposal.
3558      * @param _avatar the organization avatar
3559      * @param _paramsHash the organization parameters hash
3560      * @return int organization's score threshold.
3561      */
3562     function threshold(bytes32 _paramsHash,address _avatar) public view returns(int) {
3563         uint boostedProposals = getBoostedProposalsCount(_avatar);
3564         int216 e = 2;
3565 
3566         Parameters memory params = parameters[_paramsHash];
3567         require(params.thresholdConstB > 0,"should be a valid parameter hash");
3568         int256 power = int216(boostedProposals).toReal().div(int216(params.thresholdConstB).toReal());
3569 
3570         if (power.fromReal() > 100 ) {
3571             power = int216(100).toReal();
3572         }
3573         int256 res = int216(params.thresholdConstA).toReal().mul(e.toReal().pow(power));
3574         return res.fromReal();
3575     }
3576 
3577     /**
3578      * @dev hash the parameters, save them if necessary, and return the hash value
3579      * @param _params a parameters array
3580      *    _params[0] - _preBoostedVoteRequiredPercentage,
3581      *    _params[1] - _preBoostedVotePeriodLimit, //the time limit for a proposal to be in an absolute voting mode.
3582      *    _params[2] -_boostedVotePeriodLimit, //the time limit for a proposal to be in an relative voting mode.
3583      *    _params[3] -_thresholdConstA
3584      *    _params[4] -_thresholdConstB
3585      *    _params[5] -_minimumStakingFee
3586      *    _params[6] -_quietEndingPeriod
3587      *    _params[7] -_proposingRepRewardConstA
3588      *    _params[8] -_proposingRepRewardConstB
3589      *    _params[9] -_stakerFeeRatioForVoters
3590      *    _params[10] -_votersReputationLossRatio
3591      *    _params[11] -_votersGainRepRatioFromLostRep
3592      *    _params[12] - _daoBountyConst
3593      *    _params[13] - _daoBountyLimit
3594     */
3595     function setParameters(
3596         uint[14] _params //use array here due to stack too deep issue.
3597     )
3598     public
3599     returns(bytes32)
3600     {
3601         require(_params[0] <= 100 && _params[0] > 0,"0 < preBoostedVoteRequiredPercentage <= 100");
3602         require(_params[4] > 0 && _params[4] <= 100000000,"0 < thresholdConstB < 100000000 ");
3603         require(_params[3] <= 100000000 ether,"thresholdConstA <= 100000000 wei");
3604         require(_params[9] <= 100,"stakerFeeRatioForVoters <= 100");
3605         require(_params[10] <= 100,"votersReputationLossRatio <= 100");
3606         require(_params[11] <= 100,"votersGainRepRatioFromLostRep <= 100");
3607         require(_params[2] >= _params[6],"boostedVotePeriodLimit >= quietEndingPeriod");
3608         require(_params[7] <= 100000000,"proposingRepRewardConstA <= 100000000");
3609         require(_params[8] <= 100000000,"proposingRepRewardConstB <= 100000000");
3610         require(_params[12] <= (2 * _params[9]),"daoBountyConst <= 2 * stakerFeeRatioForVoters");
3611         require(_params[12] >= _params[9],"daoBountyConst >= stakerFeeRatioForVoters");
3612 
3613 
3614         bytes32 paramsHash = getParametersHash(_params);
3615         parameters[paramsHash] = Parameters({
3616             preBoostedVoteRequiredPercentage: _params[0],
3617             preBoostedVotePeriodLimit: _params[1],
3618             boostedVotePeriodLimit: _params[2],
3619             thresholdConstA:_params[3],
3620             thresholdConstB:_params[4],
3621             minimumStakingFee: _params[5],
3622             quietEndingPeriod: _params[6],
3623             proposingRepRewardConstA: _params[7],
3624             proposingRepRewardConstB:_params[8],
3625             stakerFeeRatioForVoters:_params[9],
3626             votersReputationLossRatio:_params[10],
3627             votersGainRepRatioFromLostRep:_params[11],
3628             daoBountyConst:_params[12],
3629             daoBountyLimit:_params[13]
3630         });
3631         return paramsHash;
3632     }
3633 
3634   /**
3635    * @dev hashParameters returns a hash of the given parameters
3636    */
3637     function getParametersHash(
3638         uint[14] _params) //use array here due to stack too deep issue.
3639         public
3640         pure
3641         returns(bytes32)
3642         {
3643         return keccak256(
3644             abi.encodePacked(
3645             _params[0],
3646             _params[1],
3647             _params[2],
3648             _params[3],
3649             _params[4],
3650             _params[5],
3651             _params[6],
3652             _params[7],
3653             _params[8],
3654             _params[9],
3655             _params[10],
3656             _params[11],
3657             _params[12],
3658             _params[13]));
3659     }
3660 
3661     /**
3662     * @dev execute check if the proposal has been decided, and if so, execute the proposal
3663     * @param _proposalId the id of the proposal
3664     * @return bool true - the proposal has been executed
3665     *              false - otherwise.
3666    */
3667     function _execute(bytes32 _proposalId) internal votable(_proposalId) returns(bool) {
3668         Proposal storage proposal = proposals[_proposalId];
3669         Parameters memory params = parameters[proposal.paramsHash];
3670         Proposal memory tmpProposal = proposal;
3671         uint totalReputation = Avatar(proposal.avatar).nativeReputation().totalSupply();
3672         uint executionBar = totalReputation * params.preBoostedVoteRequiredPercentage/100;
3673         ExecutionState executionState = ExecutionState.None;
3674 
3675         if (proposal.state == ProposalState.PreBoosted) {
3676             // solium-disable-next-line security/no-block-members
3677             if ((now - proposal.submittedTime) >= params.preBoostedVotePeriodLimit) {
3678                 proposal.state = ProposalState.Closed;
3679                 proposal.winningVote = NO;
3680                 executionState = ExecutionState.PreBoostedTimeOut;
3681              } else if (proposal.votes[proposal.winningVote] > executionBar) {
3682               // someone crossed the absolute vote execution bar.
3683                 proposal.state = ProposalState.Executed;
3684                 executionState = ExecutionState.PreBoostedBarCrossed;
3685                } else if ( shouldBoost(_proposalId)) {
3686                 //change proposal mode to boosted mode.
3687                 proposal.state = ProposalState.Boosted;
3688                 // solium-disable-next-line security/no-block-members
3689                 proposal.boostedPhaseTime = now;
3690                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3691                 orgBoostedProposalsCnt[proposal.avatar]++;
3692               }
3693            }
3694 
3695         if ((proposal.state == ProposalState.Boosted) ||
3696             (proposal.state == ProposalState.QuietEndingPeriod)) {
3697             // solium-disable-next-line security/no-block-members
3698             if ((now - proposal.boostedPhaseTime) >= proposal.currentBoostedVotePeriodLimit) {
3699                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3700                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
3701                 proposal.state = ProposalState.Executed;
3702                 executionState = ExecutionState.BoostedTimeOut;
3703              } else if (proposal.votes[proposal.winningVote] > executionBar) {
3704                // someone crossed the absolute vote execution bar.
3705                 orgBoostedProposalsCnt[tmpProposal.avatar] = orgBoostedProposalsCnt[tmpProposal.avatar].sub(1);
3706                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3707                 proposal.state = ProposalState.Executed;
3708                 executionState = ExecutionState.BoostedBarCrossed;
3709             }
3710        }
3711         if (executionState != ExecutionState.None) {
3712             if (proposal.winningVote == YES) {
3713                 uint daoBountyRemain = (params.daoBountyConst.mul(proposal.stakes[proposal.winningVote]))/100;
3714                 if (daoBountyRemain > params.daoBountyLimit) {
3715                     daoBountyRemain = params.daoBountyLimit;
3716                 }
3717                 proposal.daoBountyRemain = daoBountyRemain;
3718             }
3719             emit ExecuteProposal(_proposalId, proposal.avatar, proposal.winningVote, totalReputation);
3720             emit GPExecuteProposal(_proposalId, executionState);
3721             (tmpProposal.executable).execute(_proposalId, tmpProposal.avatar, int(proposal.winningVote));
3722         }
3723         return (executionState != ExecutionState.None);
3724     }
3725 
3726     /**
3727      * @dev staking function
3728      * @param _proposalId id of the proposal
3729      * @param _vote  NO(2) or YES(1).
3730      * @param _amount the betting amount
3731      * @param _staker the staker address
3732      * @return bool true - the proposal has been executed
3733      *              false - otherwise.
3734      */
3735     function _stake(bytes32 _proposalId, uint _vote, uint _amount,address _staker) internal returns(bool) {
3736         // 0 is not a valid vote.
3737 
3738         require(_vote <= NUM_OF_CHOICES && _vote > 0);
3739         require(_amount > 0);
3740         if (_execute(_proposalId)) {
3741             return true;
3742         }
3743 
3744         Proposal storage proposal = proposals[_proposalId];
3745 
3746         if (proposal.state != ProposalState.PreBoosted) {
3747             return false;
3748         }
3749 
3750         // enable to increase stake only on the previous stake vote
3751         Staker storage staker = proposal.stakers[_staker];
3752         if ((staker.amount > 0) && (staker.vote != _vote)) {
3753             return false;
3754         }
3755 
3756         uint amount = _amount;
3757         Parameters memory params = parameters[proposal.paramsHash];
3758         require(amount >= params.minimumStakingFee);
3759         require(stakingToken.transferFrom(_staker, address(this), amount));
3760         proposal.totalStakes[1] = proposal.totalStakes[1].add(amount); //update totalRedeemableStakes
3761         staker.amount += amount;
3762         staker.amountForBounty = staker.amount;
3763         staker.vote = _vote;
3764 
3765         proposal.votersStakes += (params.stakerFeeRatioForVoters * amount)/100;
3766         proposal.stakes[_vote] = amount.add(proposal.stakes[_vote]);
3767         amount = amount - ((params.stakerFeeRatioForVoters*amount)/100);
3768 
3769         proposal.totalStakes[0] = amount.add(proposal.totalStakes[0]);
3770       // Event:
3771         emit Stake(_proposalId, proposal.avatar, _staker, _vote, _amount);
3772       // execute the proposal if this vote was decisive:
3773         return _execute(_proposalId);
3774     }
3775 
3776     /**
3777      * @dev Vote for a proposal, if the voter already voted, cancel the last vote and set a new one instead
3778      * @param _proposalId id of the proposal
3779      * @param _voter used in case the vote is cast for someone else
3780      * @param _vote a value between 0 to and the proposal's number of choices.
3781      * @param _rep how many reputation the voter would like to stake for this vote.
3782      *         if  _rep==0 so the voter full reputation will be use.
3783      * @return true in case of proposal execution otherwise false
3784      * throws if proposal is not open or if it has been executed
3785      * NB: executes the proposal if a decision has been reached
3786      */
3787     function internalVote(bytes32 _proposalId, address _voter, uint _vote, uint _rep) internal returns(bool) {
3788         // 0 is not a valid vote.
3789         require(_vote <= NUM_OF_CHOICES && _vote > 0,"0 < _vote <= 2");
3790         if (_execute(_proposalId)) {
3791             return true;
3792         }
3793 
3794         Parameters memory params = parameters[proposals[_proposalId].paramsHash];
3795         Proposal storage proposal = proposals[_proposalId];
3796 
3797         // Check voter has enough reputation:
3798         uint reputation = Avatar(proposal.avatar).nativeReputation().reputationOf(_voter);
3799         require(reputation >= _rep);
3800         uint rep = _rep;
3801         if (rep == 0) {
3802             rep = reputation;
3803         }
3804         // If this voter has already voted, return false.
3805         if (proposal.voters[_voter].reputation != 0) {
3806             return false;
3807         }
3808         // The voting itself:
3809         proposal.votes[_vote] = rep.add(proposal.votes[_vote]);
3810         //check if the current winningVote changed or there is a tie.
3811         //for the case there is a tie the current winningVote set to NO.
3812         if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
3813            ((proposal.votes[NO] == proposal.votes[proposal.winningVote]) &&
3814              proposal.winningVote == YES))
3815         {
3816            // solium-disable-next-line security/no-block-members
3817             uint _now = now;
3818             if ((proposal.state == ProposalState.QuietEndingPeriod) ||
3819                ((proposal.state == ProposalState.Boosted) && ((_now - proposal.boostedPhaseTime) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod)))) {
3820                 //quietEndingPeriod
3821                 proposalsExpiredTimes[proposal.avatar].remove(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3822                 if (proposal.state != ProposalState.QuietEndingPeriod) {
3823                     proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
3824                     proposal.state = ProposalState.QuietEndingPeriod;
3825                 }
3826                 proposal.boostedPhaseTime = _now;
3827                 proposalsExpiredTimes[proposal.avatar].insert(proposal.boostedPhaseTime + proposal.currentBoostedVotePeriodLimit);
3828             }
3829             proposal.winningVote = _vote;
3830         }
3831         proposal.voters[_voter] = Voter({
3832             reputation: rep,
3833             vote: _vote,
3834             preBoosted:(proposal.state == ProposalState.PreBoosted)
3835         });
3836         if (proposal.state != ProposalState.Boosted) {
3837             proposal.preBoostedVotes[_vote] = rep.add(proposal.preBoostedVotes[_vote]);
3838             uint reputationDeposit = (params.votersReputationLossRatio * rep)/100;
3839             ControllerInterface(Avatar(proposal.avatar).owner()).burnReputation(reputationDeposit,_voter,proposal.avatar);
3840         }
3841         // Event:
3842         emit VoteProposal(_proposalId, proposal.avatar, _voter, _vote, rep);
3843         // execute the proposal if this vote was decisive:
3844         return _execute(_proposalId);
3845     }
3846 
3847     /**
3848      * @dev _score return the proposal score
3849      * For dual choice proposal S = (S+) - (S-)
3850      * @param _proposalId the ID of the proposal
3851      * @return int proposal score.
3852      */
3853     function _score(bytes32 _proposalId) private view returns(int) {
3854         Proposal storage proposal = proposals[_proposalId];
3855         return int(proposal.stakes[YES]) - int(proposal.stakes[NO]);
3856     }
3857 
3858     /**
3859       * @dev _isVotable check if the proposal is votable
3860       * @param _proposalId the ID of the proposal
3861       * @return bool true or false
3862     */
3863     function _isVotable(bytes32 _proposalId) private view returns(bool) {
3864         ProposalState pState = proposals[_proposalId].state;
3865         return ((pState == ProposalState.PreBoosted)||(pState == ProposalState.Boosted)||(pState == ProposalState.QuietEndingPeriod));
3866     }
3867 }
3868 
3869 // File: contracts/utils/Redeemer.sol
3870 
3871 contract Redeemer {
3872     using SafeMath for uint;
3873 
3874     ContributionReward public contributionReward;
3875     GenesisProtocol public genesisProtocol;
3876 
3877     constructor(address _contributionReward,address _genesisProtocol) public {
3878         contributionReward = ContributionReward(_contributionReward);
3879         genesisProtocol = GenesisProtocol(_genesisProtocol);
3880     }
3881 
3882    /**
3883     * @dev helper to redeem rewards for a proposal
3884     * It calls execute on the proposal if it is not yet executed.
3885     * It tries to redeem reputation and stake from the GenesisProtocol.
3886     * It tries to redeem proposal rewards from the contribution rewards scheme.
3887     * This function does not emit events.
3888     * A client should listen to GenesisProtocol and ContributionReward redemption events
3889     * to monitor redemption operations.
3890     * @param _proposalId the ID of the voting in the voting machine
3891     * @param _avatar address of the controller
3892     * @param _beneficiary beneficiary
3893     * @return gpRewards array
3894     *          gpRewards[0] - stakerTokenAmount
3895     *          gpRewards[1] - stakerReputationAmount
3896     *          gpRewards[2] - voterTokenAmount
3897     *          gpRewards[3] - voterReputationAmount
3898     *          gpRewards[4] - proposerReputationAmount
3899     * @return gpDaoBountyReward array
3900     *         gpDaoBountyReward[0] - staker dao bounty reward -
3901     *                                will be zero for the case there is not enough tokens in avatar for the reward.
3902     *         gpDaoBountyReward[1] - staker potential dao bounty reward.
3903     * @return executed bool true or false
3904     * @return crResults array
3905     *          crResults[0]- reputation - from ContributionReward
3906     *          crResults[1]- nativeTokenReward - from ContributionReward
3907     *          crResults[2]- Ether - from ContributionReward
3908     *          crResults[3]- ExternalToken - from ContributionReward
3909 
3910     */
3911     function redeem(bytes32 _proposalId,address _avatar,address _beneficiary)
3912     external
3913     returns(uint[5] gpRewards,
3914             uint[2] gpDaoBountyReward,
3915             bool executed,
3916             bool[4] crResults)
3917     {
3918         GenesisProtocol.ProposalState pState = genesisProtocol.state(_proposalId);
3919         // solium-disable-next-line operator-whitespace
3920         if ((pState == GenesisProtocol.ProposalState.PreBoosted)||
3921             (pState == GenesisProtocol.ProposalState.Boosted)||
3922             (pState == GenesisProtocol.ProposalState.QuietEndingPeriod)) {
3923             executed = genesisProtocol.execute(_proposalId);
3924         }
3925         pState = genesisProtocol.state(_proposalId);
3926         if ((pState == GenesisProtocol.ProposalState.Executed) ||
3927             (pState == GenesisProtocol.ProposalState.Closed)) {
3928             gpRewards = genesisProtocol.redeem(_proposalId,_beneficiary);
3929             (gpDaoBountyReward[0],gpDaoBountyReward[1]) = genesisProtocol.redeemDaoBounty(_proposalId,_beneficiary);
3930             //redeem from contributionReward only if it executed
3931             if (contributionReward.getProposalExecutionTime(_proposalId,_avatar) > 0) {
3932                 (crResults[0],crResults[1],crResults[2],crResults[3]) = contributionRewardRedeem(_proposalId,_avatar);
3933             }
3934         }
3935     }
3936 
3937     function contributionRewardRedeem(bytes32 _proposalId,address _avatar)
3938     private
3939     returns (bool,bool,bool,bool)
3940     {
3941         bool[4] memory whatToRedeem;
3942         whatToRedeem[0] = true; //reputation
3943         whatToRedeem[1] = true; //nativeToken
3944         uint periodsToPay = contributionReward.getPeriodsToPay(_proposalId,_avatar,2);
3945         uint ethReward = contributionReward.getProposalEthReward(_proposalId,_avatar);
3946         uint externalTokenReward = contributionReward.getProposalExternalTokenReward(_proposalId,_avatar);
3947         address externalToken = contributionReward.getProposalExternalToken(_proposalId,_avatar);
3948         ethReward = periodsToPay.mul(ethReward);
3949         if ((ethReward == 0) || (_avatar.balance < ethReward)) {
3950             whatToRedeem[2] = false;
3951         } else {
3952             whatToRedeem[2] = true;
3953         }
3954         periodsToPay = contributionReward.getPeriodsToPay(_proposalId,_avatar,3);
3955         externalTokenReward = periodsToPay.mul(externalTokenReward);
3956         if ((externalTokenReward == 0) || (StandardToken(externalToken).balanceOf(_avatar) < externalTokenReward)) {
3957             whatToRedeem[3] = false;
3958         } else {
3959             whatToRedeem[3] = true;
3960         }
3961         whatToRedeem = contributionReward.redeem(_proposalId,_avatar,whatToRedeem);
3962         return (whatToRedeem[0],whatToRedeem[1],whatToRedeem[2],whatToRedeem[3]);
3963     }
3964 }