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
1707 // File: contracts/universalSchemes/UpgradeScheme.sol
1708 
1709 /**
1710  * @title A scheme to manage the upgrade of an organization.
1711  * @dev The scheme is used to upgrade the controller of an organization to a new controller.
1712  */
1713 
1714 contract UpgradeScheme is UniversalScheme, ExecutableInterface {
1715     event NewUpgradeProposal(
1716         address indexed _avatar,
1717         bytes32 indexed _proposalId,
1718         address indexed _intVoteInterface,
1719         address _newController
1720     );
1721     event ChangeUpgradeSchemeProposal(
1722         address indexed _avatar,
1723         bytes32 indexed _proposalId,
1724         address indexed _intVoteInterface,
1725         address _newUpgradeScheme,
1726         bytes32 _params
1727     );
1728     event ProposalExecuted(address indexed _avatar, bytes32 indexed _proposalId,int _param);
1729     event ProposalDeleted(address indexed _avatar, bytes32 indexed _proposalId);
1730 
1731     // Details of an upgrade proposal:
1732     struct UpgradeProposal {
1733         address upgradeContract; // Either the new controller we upgrade to, or the new upgrading scheme.
1734         bytes32 params; // Params for the new upgrading scheme.
1735         uint proposalType; // 1: Upgrade controller, 2: change upgrade scheme.
1736     }
1737 
1738     // A mapping from the organization's (Avatar) address to the saved data of the organization:
1739     mapping(address=>mapping(bytes32=>UpgradeProposal)) public organizationsProposals;
1740 
1741     // A mapping from hashes to parameters (use to store a particular configuration on the controller)
1742     struct Parameters {
1743         bytes32 voteParams;
1744         IntVoteInterface intVote;
1745     }
1746 
1747     mapping(bytes32=>Parameters) public parameters;
1748 
1749     /**
1750     * @dev hash the parameters, save them if necessary, and return the hash value
1751     */
1752     function setParameters(
1753         bytes32 _voteParams,
1754         IntVoteInterface _intVote
1755     ) public returns(bytes32)
1756     {
1757         bytes32 paramsHash = getParametersHash(_voteParams, _intVote);
1758         parameters[paramsHash].voteParams = _voteParams;
1759         parameters[paramsHash].intVote = _intVote;
1760         return paramsHash;
1761     }
1762 
1763     /**
1764     * @dev return a hash of the given parameters
1765     */
1766     function getParametersHash(
1767         bytes32 _voteParams,
1768         IntVoteInterface _intVote
1769     ) public pure returns(bytes32)
1770     {
1771         return  (keccak256(abi.encodePacked(_voteParams, _intVote)));
1772     }
1773 
1774     /**
1775     * @dev propose an upgrade of the organization's controller
1776     * @param _avatar avatar of the organization
1777     * @param _newController address of the new controller that is being proposed
1778     * @return an id which represents the proposal
1779     */
1780     function proposeUpgrade(Avatar _avatar, address _newController)
1781         public
1782         returns(bytes32)
1783     {
1784         Parameters memory params = parameters[getParametersFromController(_avatar)];
1785         bytes32 proposalId = params.intVote.propose(2, params.voteParams, _avatar, ExecutableInterface(this),msg.sender);
1786         UpgradeProposal memory proposal = UpgradeProposal({
1787             proposalType: 1,
1788             upgradeContract: _newController,
1789             params: bytes32(0)
1790         });
1791         organizationsProposals[_avatar][proposalId] = proposal;
1792         emit NewUpgradeProposal(_avatar, proposalId, params.intVote, _newController);
1793         params.intVote.ownerVote(proposalId, 1, msg.sender); // Automatically votes `yes` in the name of the proposal submitter.*/
1794         return proposalId;
1795     }
1796 
1797     /**
1798     * @dev propose to replace this scheme by another upgrading scheme
1799     * @param _avatar avatar of the organization
1800     * @param _scheme address of the new upgrading scheme
1801     * @param _params ???
1802     * @return an id which represents the proposal
1803     */
1804     function proposeChangeUpgradingScheme(
1805         Avatar _avatar,
1806         address _scheme,
1807         bytes32 _params
1808     )
1809         public
1810         returns(bytes32)
1811     {
1812         Parameters memory params = parameters[getParametersFromController(_avatar)];
1813         IntVoteInterface intVote = params.intVote;
1814         bytes32 proposalId = intVote.propose(2, params.voteParams, _avatar, ExecutableInterface(this),msg.sender);
1815         require(organizationsProposals[_avatar][proposalId].proposalType == 0);
1816 
1817         UpgradeProposal memory proposal = UpgradeProposal({
1818             proposalType: 2,
1819             upgradeContract: _scheme,
1820             params: _params
1821         });
1822         organizationsProposals[_avatar][proposalId] = proposal;
1823 
1824         emit ChangeUpgradeSchemeProposal(
1825             _avatar,
1826             proposalId,
1827             params.intVote,
1828             _scheme,
1829             _params
1830         );
1831         intVote.ownerVote(proposalId, 1, msg.sender); // Automatically votes `yes` in the name of the opener.
1832         return proposalId;
1833     }
1834 
1835     /**
1836     * @dev execution of proposals, can only be called by the voting machine in which the vote is held.
1837     * @param _proposalId the ID of the voting in the voting machine
1838     * @param _avatar address of the controller
1839     * @param _param a parameter of the voting result, 0 is no and 1 is yes.
1840     */
1841     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool) {
1842         // Check the caller is indeed the voting machine:
1843         require(parameters[getParametersFromController(Avatar(_avatar))].intVote == msg.sender);
1844         UpgradeProposal memory proposal = organizationsProposals[_avatar][_proposalId];
1845         require(proposal.proposalType != 0);
1846         delete organizationsProposals[_avatar][_proposalId];
1847         emit ProposalDeleted(_avatar,_proposalId);
1848         // Check if vote was successful:
1849         if (_param == 1) {
1850 
1851         // Define controller and get the params:
1852             ControllerInterface controller = ControllerInterface(Avatar(_avatar).owner());
1853         // Upgrading controller:
1854             if (proposal.proposalType == 1) {
1855                 require(controller.upgradeController(proposal.upgradeContract,_avatar));
1856             }
1857 
1858         // Changing upgrade scheme:
1859             if (proposal.proposalType == 2) {
1860                 bytes4 permissions = controller.getSchemePermissions(this,_avatar);
1861 
1862                 require(controller.registerScheme(proposal.upgradeContract, proposal.params, permissions,_avatar));
1863                 if (proposal.upgradeContract != address(this) ) {
1864                     require(controller.unregisterSelf(_avatar));
1865                     }
1866                   }
1867         }
1868         emit ProposalExecuted(_avatar, _proposalId,_param);
1869         return true;
1870     }
1871 }