1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender)
24     public view returns (uint256);
25 
26   function transferFrom(address from, address to, uint256 value)
27     public returns (bool);
28 
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 /**
38  * @title Basic token
39  * @dev Basic version of StandardToken, with no allowances.
40  */
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   uint256 totalSupply_;
47 
48   /**
49   * @dev Total number of tokens in existence
50   */
51   function totalSupply() public view returns (uint256) {
52     return totalSupply_;
53   }
54 
55   /**
56   * @dev Transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     emit Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public view returns (uint256) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 /**
82  * @title Standard ERC20 token
83  *
84  * @dev Implementation of the basic standard token.
85  * https://github.com/ethereum/EIPs/issues/20
86  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
87  */
88 contract StandardToken is ERC20, BasicToken {
89 
90   mapping (address => mapping (address => uint256)) internal allowed;
91 
92 
93   /**
94    * @dev Transfer tokens from one address to another
95    * @param _from address The address which you want to send tokens from
96    * @param _to address The address which you want to transfer to
97    * @param _value uint256 the amount of tokens to be transferred
98    */
99   function transferFrom(
100     address _from,
101     address _to,
102     uint256 _value
103   )
104     public
105     returns (bool)
106   {
107     require(_to != address(0));
108     require(_value <= balances[_from]);
109     require(_value <= allowed[_from][msg.sender]);
110 
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114     emit Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     allowed[msg.sender][_spender] = _value;
129     emit Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(
140     address _owner,
141     address _spender
142    )
143     public
144     view
145     returns (uint256)
146   {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    * @param _spender The address which will spend the funds.
157    * @param _addedValue The amount of tokens to increase the allowance by.
158    */
159   function increaseApproval(
160     address _spender,
161     uint256 _addedValue
162   )
163     public
164     returns (bool)
165   {
166     allowed[msg.sender][_spender] = (
167       allowed[msg.sender][_spender].add(_addedValue));
168     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   /**
173    * @dev Decrease the amount of tokens that an owner allowed to a spender.
174    * approve should be called when allowed[_spender] == 0. To decrement
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _subtractedValue The amount of tokens to decrease the allowance by.
180    */
181   function decreaseApproval(
182     address _spender,
183     uint256 _subtractedValue
184   )
185     public
186     returns (bool)
187   {
188     uint256 oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 
201 /**
202  * @title Ownable
203  * @dev The Ownable contract has an owner address, and provides basic authorization control
204  * functions, this simplifies the implementation of "user permissions".
205  */
206 contract Ownable {
207   address public owner;
208 
209 
210   event OwnershipRenounced(address indexed previousOwner);
211   event OwnershipTransferred(
212     address indexed previousOwner,
213     address indexed newOwner
214   );
215 
216 
217   /**
218    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
219    * account.
220    */
221   constructor() public {
222     owner = msg.sender;
223   }
224 
225   /**
226    * @dev Throws if called by any account other than the owner.
227    */
228   modifier onlyOwner() {
229     require(msg.sender == owner);
230     _;
231   }
232 
233   /**
234    * @dev Allows the current owner to relinquish control of the contract.
235    * @notice Renouncing to ownership will leave the contract without an owner.
236    * It will not be possible to call the functions with the `onlyOwner`
237    * modifier anymore.
238    */
239   function renounceOwnership() public onlyOwner {
240     emit OwnershipRenounced(owner);
241     owner = address(0);
242   }
243 
244   /**
245    * @dev Allows the current owner to transfer control of the contract to a newOwner.
246    * @param _newOwner The address to transfer ownership to.
247    */
248   function transferOwnership(address _newOwner) public onlyOwner {
249     _transferOwnership(_newOwner);
250   }
251 
252   /**
253    * @dev Transfers control of the contract to a newOwner.
254    * @param _newOwner The address to transfer ownership to.
255    */
256   function _transferOwnership(address _newOwner) internal {
257     require(_newOwner != address(0));
258     emit OwnershipTransferred(owner, _newOwner);
259     owner = _newOwner;
260   }
261 }
262 
263 
264 /**
265  * @title Mintable token
266  * @dev Simple ERC20 Token example, with mintable token creation
267  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
268  */
269 contract MintableToken is StandardToken, Ownable {
270   event Mint(address indexed to, uint256 amount);
271   event MintFinished();
272 
273   bool public mintingFinished = false;
274 
275 
276   modifier canMint() {
277     require(!mintingFinished);
278     _;
279   }
280 
281   modifier hasMintPermission() {
282     require(msg.sender == owner);
283     _;
284   }
285 
286   /**
287    * @dev Function to mint tokens
288    * @param _to The address that will receive the minted tokens.
289    * @param _amount The amount of tokens to mint.
290    * @return A boolean that indicates if the operation was successful.
291    */
292   function mint(
293     address _to,
294     uint256 _amount
295   )
296     hasMintPermission
297     canMint
298     public
299     returns (bool)
300   {
301     totalSupply_ = totalSupply_.add(_amount);
302     balances[_to] = balances[_to].add(_amount);
303     emit Mint(_to, _amount);
304     emit Transfer(address(0), _to, _amount);
305     return true;
306   }
307 
308   /**
309    * @dev Function to stop minting new tokens.
310    * @return True if the operation was successful.
311    */
312   function finishMinting() onlyOwner canMint public returns (bool) {
313     mintingFinished = true;
314     emit MintFinished();
315     return true;
316   }
317 }
318 
319 /**
320  * @title Burnable Token
321  * @dev Token that can be irreversibly burned (destroyed).
322  */
323 contract BurnableToken is BasicToken {
324 
325   event Burn(address indexed burner, uint256 value);
326 
327   /**
328    * @dev Burns a specific amount of tokens.
329    * @param _value The amount of token to be burned.
330    */
331   function burn(uint256 _value) public {
332     _burn(msg.sender, _value);
333   }
334 
335   function _burn(address _who, uint256 _value) internal {
336     require(_value <= balances[_who]);
337     // no need to require value <= totalSupply, since that would imply the
338     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
339 
340     balances[_who] = balances[_who].sub(_value);
341     totalSupply_ = totalSupply_.sub(_value);
342     emit Burn(_who, _value);
343     emit Transfer(_who, address(0), _value);
344   }
345 }
346 
347 
348 
349 /**
350  * @title SafeMath
351  * @dev Math operations with safety checks that throw on error
352  */
353 library SafeMath {
354 
355   /**
356   * @dev Multiplies two numbers, throws on overflow.
357   */
358   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
359     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
360     // benefit is lost if 'b' is also tested.
361     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
362     if (a == 0) {
363       return 0;
364     }
365 
366     c = a * b;
367     assert(c / a == b);
368     return c;
369   }
370 
371   /**
372   * @dev Integer division of two numbers, truncating the quotient.
373   */
374   function div(uint256 a, uint256 b) internal pure returns (uint256) {
375     // assert(b > 0); // Solidity automatically throws when dividing by 0
376     // uint256 c = a / b;
377     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
378     return a / b;
379   }
380 
381   /**
382   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
383   */
384   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385     assert(b <= a);
386     return a - b;
387   }
388 
389   /**
390   * @dev Adds two numbers, throws on overflow.
391   */
392   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
393     c = a + b;
394     assert(c >= a);
395     return c;
396   }
397 }
398 
399 /**
400  * @title ERC827 interface, an extension of ERC20 token standard
401  *
402  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
403  * methods to transfer value and data and execute calls in transfers and
404  * approvals.
405  */
406 contract ERC827 is ERC20 {
407 
408     function approveAndCall(address _spender,uint256 _value,bytes _data) public payable returns(bool);
409 
410     function transferAndCall(address _to,uint256 _value,bytes _data) public payable returns(bool);
411 
412     function transferFromAndCall(address _from,address _to,uint256 _value,bytes _data) public payable returns(bool);
413 
414 }
415 
416 /**
417  * @title ERC827, an extension of ERC20 token standard
418  *
419  * @dev Implementation the ERC827, following the ERC20 standard with extra
420  * methods to transfer value and data and execute calls in transfers and
421  * approvals. Uses OpenZeppelin StandardToken.
422  */
423 contract ERC827Token is ERC827, StandardToken {
424 
425   /**
426    * @dev Addition to ERC20 token methods. It allows to
427    * approve the transfer of value and execute a call with the sent data.
428    * Beware that changing an allowance with this method brings the risk that
429    * someone may use both the old and the new allowance by unfortunate
430    * transaction ordering. One possible solution to mitigate this race condition
431    * is to first reduce the spender's allowance to 0 and set the desired value
432    * afterwards:
433    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
434    * @param _spender The address that will spend the funds.
435    * @param _value The amount of tokens to be spent.
436    * @param _data ABI-encoded contract call to call `_spender` address.
437    * @return true if the call function was executed successfully
438    */
439     function approveAndCall(
440         address _spender,
441         uint256 _value,
442         bytes _data
443     )
444     public
445     payable
446     returns (bool)
447     {
448         require(_spender != address(this));
449 
450         super.approve(_spender, _value);
451 
452         // solium-disable-next-line security/no-call-value
453         require(_spender.call.value(msg.value)(_data));
454 
455         return true;
456     }
457 
458   /**
459    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
460    * address and execute a call with the sent data on the same transaction
461    * @param _to address The address which you want to transfer to
462    * @param _value uint256 the amout of tokens to be transfered
463    * @param _data ABI-encoded contract call to call `_to` address.
464    * @return true if the call function was executed successfully
465    */
466     function transferAndCall(
467         address _to,
468         uint256 _value,
469         bytes _data
470     )
471     public
472     payable
473     returns (bool)
474     {
475         require(_to != address(this));
476 
477         super.transfer(_to, _value);
478 
479         // solium-disable-next-line security/no-call-value
480         require(_to.call.value(msg.value)(_data));
481         return true;
482     }
483 
484   /**
485    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
486    * another and make a contract call on the same transaction
487    * @param _from The address which you want to send tokens from
488    * @param _to The address which you want to transfer to
489    * @param _value The amout of tokens to be transferred
490    * @param _data ABI-encoded contract call to call `_to` address.
491    * @return true if the call function was executed successfully
492    */
493     function transferFromAndCall(
494         address _from,
495         address _to,
496         uint256 _value,
497         bytes _data
498     )
499     public payable returns (bool)
500     {
501         require(_to != address(this));
502 
503         super.transferFrom(_from, _to, _value);
504 
505         // solium-disable-next-line security/no-call-value
506         require(_to.call.value(msg.value)(_data));
507         return true;
508     }
509 
510   /**
511    * @dev Addition to StandardToken methods. Increase the amount of tokens that
512    * an owner allowed to a spender and execute a call with the sent data.
513    * approve should be called when allowed[_spender] == 0. To increment
514    * allowed value is better to use this function to avoid 2 calls (and wait until
515    * the first transaction is mined)
516    * From MonolithDAO Token.sol
517    * @param _spender The address which will spend the funds.
518    * @param _addedValue The amount of tokens to increase the allowance by.
519    * @param _data ABI-encoded contract call to call `_spender` address.
520    */
521     function increaseApprovalAndCall(
522         address _spender,
523         uint _addedValue,
524         bytes _data
525     )
526     public
527     payable
528     returns (bool)
529     {
530         require(_spender != address(this));
531 
532         super.increaseApproval(_spender, _addedValue);
533 
534         // solium-disable-next-line security/no-call-value
535         require(_spender.call.value(msg.value)(_data));
536 
537         return true;
538     }
539 
540   /**
541    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
542    * an owner allowed to a spender and execute a call with the sent data.
543    * approve should be called when allowed[_spender] == 0. To decrement
544    * allowed value is better to use this function to avoid 2 calls (and wait until
545    * the first transaction is mined)
546    * From MonolithDAO Token.sol
547    * @param _spender The address which will spend the funds.
548    * @param _subtractedValue The amount of tokens to decrease the allowance by.
549    * @param _data ABI-encoded contract call to call `_spender` address.
550    */
551     function decreaseApprovalAndCall(
552         address _spender,
553         uint _subtractedValue,
554         bytes _data
555     )
556     public
557     payable
558     returns (bool)
559     {
560         require(_spender != address(this));
561 
562         super.decreaseApproval(_spender, _subtractedValue);
563 
564         // solium-disable-next-line security/no-call-value
565         require(_spender.call.value(msg.value)(_data));
566 
567         return true;
568     }
569 
570 }
571 
572 /**
573  * @title DAOToken, base on zeppelin contract.
574  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
575  */
576 
577 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
578 
579     string public name;
580     string public symbol;
581     // solium-disable-next-line uppercase
582     uint8 public constant decimals = 18;
583     uint public cap;
584 
585     /**
586     * @dev Constructor
587     * @param _name - token name
588     * @param _symbol - token symbol
589     * @param _cap - token cap - 0 value means no cap
590     */
591     constructor(string _name, string _symbol,uint _cap) public {
592         name = _name;
593         symbol = _symbol;
594         cap = _cap;
595     }
596 
597     /**
598      * @dev Function to mint tokens
599      * @param _to The address that will receive the minted tokens.
600      * @param _amount The amount of tokens to mint.
601      * @return A boolean that indicates if the operation was successful.
602      */
603     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
604         if (cap > 0)
605             require(totalSupply_.add(_amount) <= cap);
606         return super.mint(_to, _amount);
607     }
608 }
609 
610 /**
611  * @title Reputation system
612  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
613  * A reputation is use to assign influence measure to a DAO'S peers.
614  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
615  * The Reputation contract maintain a map of address to reputation value.
616  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
617  */
618 
619 contract Reputation is Ownable {
620     using SafeMath for uint;
621 
622     mapping (address => uint256) public balances;
623     uint256 public totalSupply;
624     uint public decimals = 18;
625 
626     // Event indicating minting of reputation to an address.
627     event Mint(address indexed _to, uint256 _amount);
628     // Event indicating burning of reputation for an address.
629     event Burn(address indexed _from, uint256 _amount);
630 
631     /**
632     * @dev return the reputation amount of a given owner
633     * @param _owner an address of the owner which we want to get his reputation
634     */
635     function reputationOf(address _owner) public view returns (uint256 balance) {
636         return balances[_owner];
637     }
638 
639     /**
640     * @dev Generates `_amount` of reputation that are assigned to `_to`
641     * @param _to The address that will be assigned the new reputation
642     * @param _amount The quantity of reputation to be generated
643     * @return True if the reputation are generated correctly
644     */
645     function mint(address _to, uint _amount)
646     public
647     onlyOwner
648     returns (bool)
649     {
650         totalSupply = totalSupply.add(_amount);
651         balances[_to] = balances[_to].add(_amount);
652         emit Mint(_to, _amount);
653         return true;
654     }
655 
656     /**
657     * @dev Burns `_amount` of reputation from `_from`
658     * if _amount tokens to burn > balances[_from] the balance of _from will turn to zero.
659     * @param _from The address that will lose the reputation
660     * @param _amount The quantity of reputation to burn
661     * @return True if the reputation are burned correctly
662     */
663     function burn(address _from, uint _amount)
664     public
665     onlyOwner
666     returns (bool)
667     {
668         uint amountMinted = _amount;
669         if (balances[_from] < _amount) {
670             amountMinted = balances[_from];
671         }
672         totalSupply = totalSupply.sub(amountMinted);
673         balances[_from] = balances[_from].sub(amountMinted);
674         emit Burn(_from, amountMinted);
675         return true;
676     }
677 }
678 
679 /**
680  * @title An Avatar holds tokens, reputation and ether for a controller
681  */
682 contract Avatar is Ownable {
683     bytes32 public orgName;
684     DAOToken public nativeToken;
685     Reputation public nativeReputation;
686 
687     event GenericAction(address indexed _action, bytes32[] _params);
688     event SendEther(uint _amountInWei, address indexed _to);
689     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
690     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
691     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
692     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
693     event ReceiveEther(address indexed _sender, uint _value);
694 
695     /**
696     * @dev the constructor takes organization name, native token and reputation system
697     and creates an avatar for a controller
698     */
699     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
700         orgName = _orgName;
701         nativeToken = _nativeToken;
702         nativeReputation = _nativeReputation;
703     }
704 
705     /**
706     * @dev enables an avatar to receive ethers
707     */
708     function() public payable {
709         emit ReceiveEther(msg.sender, msg.value);
710     }
711 
712     /**
713     * @dev perform a generic call to an arbitrary contract
714     * @param _contract  the contract's address to call
715     * @param _data ABI-encoded contract call to call `_contract` address.
716     * @return the return bytes of the called contract's function.
717     */
718     function genericCall(address _contract,bytes _data) public onlyOwner {
719         // solium-disable-next-line security/no-low-level-calls
720         bool result = _contract.call(_data);
721         // solium-disable-next-line security/no-inline-assembly
722         assembly {
723         // Copy the returned data.
724         returndatacopy(0, 0, returndatasize)
725 
726         switch result
727         // call returns 0 on error.
728         case 0 { revert(0, returndatasize) }
729         default { return(0, returndatasize) }
730         }
731     }
732 
733     /**
734     * @dev send ethers from the avatar's wallet
735     * @param _amountInWei amount to send in Wei units
736     * @param _to send the ethers to this address
737     * @return bool which represents success
738     */
739     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
740         _to.transfer(_amountInWei);
741         emit SendEther(_amountInWei, _to);
742         return true;
743     }
744 
745     /**
746     * @dev external token transfer
747     * @param _externalToken the token contract
748     * @param _to the destination address
749     * @param _value the amount of tokens to transfer
750     * @return bool which represents success
751     */
752     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
753     public onlyOwner returns(bool)
754     {
755         _externalToken.transfer(_to, _value);
756         emit ExternalTokenTransfer(_externalToken, _to, _value);
757         return true;
758     }
759 
760     /**
761     * @dev external token transfer from a specific account
762     * @param _externalToken the token contract
763     * @param _from the account to spend token from
764     * @param _to the destination address
765     * @param _value the amount of tokens to transfer
766     * @return bool which represents success
767     */
768     function externalTokenTransferFrom(
769         StandardToken _externalToken,
770         address _from,
771         address _to,
772         uint _value
773     )
774     public onlyOwner returns(bool)
775     {
776         _externalToken.transferFrom(_from, _to, _value);
777         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
778         return true;
779     }
780 
781     /**
782     * @dev increase approval for the spender address to spend a specified amount of tokens
783     *      on behalf of msg.sender.
784     * @param _externalToken the address of the Token Contract
785     * @param _spender address
786     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
787     * @return bool which represents a success
788     */
789     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
790     public onlyOwner returns(bool)
791     {
792         _externalToken.increaseApproval(_spender, _addedValue);
793         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
794         return true;
795     }
796 
797     /**
798     * @dev decrease approval for the spender address to spend a specified amount of tokens
799     *      on behalf of msg.sender.
800     * @param _externalToken the address of the Token Contract
801     * @param _spender address
802     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
803     * @return bool which represents a success
804     */
805     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
806     public onlyOwner returns(bool)
807     {
808         _externalToken.decreaseApproval(_spender, _subtractedValue);
809         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
810         return true;
811     }
812 
813 }