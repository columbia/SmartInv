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
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 /**
114  * @title ERC20Basic
115  * @dev Simpler version of ERC20 interface
116  * See https://github.com/ethereum/EIPs/issues/179
117  */
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender)
132     public view returns (uint256);
133 
134   function transferFrom(address from, address to, uint256 value)
135     public returns (bool);
136 
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(
139     address indexed owner,
140     address indexed spender,
141     uint256 value
142   );
143 }
144 /**
145  * @title ERC827 interface, an extension of ERC20 token standard
146  *
147  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
148  * methods to transfer value and data and execute calls in transfers and
149  * approvals.
150  */
151 contract ERC827 is ERC20 {
152 
153     function approveAndCall(address _spender,uint256 _value,bytes _data) public payable returns(bool);
154 
155     function transferAndCall(address _to,uint256 _value,bytes _data) public payable returns(bool);
156 
157     function transferFromAndCall(address _from,address _to,uint256 _value,bytes _data) public payable returns(bool);
158 
159 }
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev Total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev Transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256) {
199     return balances[_owner];
200   }
201 
202 }
203 
204 /**
205  * @title Standard ERC20 token
206  *
207  * @dev Implementation of the basic standard token.
208  * https://github.com/ethereum/EIPs/issues/20
209  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
210  */
211 contract StandardToken is ERC20, BasicToken {
212 
213   mapping (address => mapping (address => uint256)) internal allowed;
214 
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param _from address The address which you want to send tokens from
219    * @param _to address The address which you want to transfer to
220    * @param _value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(
223     address _from,
224     address _to,
225     uint256 _value
226   )
227     public
228     returns (bool)
229   {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     emit Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param _spender The address which will spend the funds.
248    * @param _value The amount of tokens to be spent.
249    */
250   function approve(address _spender, uint256 _value) public returns (bool) {
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(
263     address _owner,
264     address _spender
265    )
266     public
267     view
268     returns (uint256)
269   {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(
283     address _spender,
284     uint256 _addedValue
285   )
286     public
287     returns (bool)
288   {
289     allowed[msg.sender][_spender] = (
290       allowed[msg.sender][_spender].add(_addedValue));
291     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295   /**
296    * @dev Decrease the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(
305     address _spender,
306     uint256 _subtractedValue
307   )
308     public
309     returns (bool)
310   {
311     uint256 oldValue = allowed[msg.sender][_spender];
312     if (_subtractedValue > oldValue) {
313       allowed[msg.sender][_spender] = 0;
314     } else {
315       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
316     }
317     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 
321 }
322 
323 
324 
325 
326 
327 /**
328  * @title Mintable token
329  * @dev Simple ERC20 Token example, with mintable token creation
330  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
331  */
332 contract MintableToken is StandardToken, Ownable {
333   event Mint(address indexed to, uint256 amount);
334   event MintFinished();
335 
336   bool public mintingFinished = false;
337 
338 
339   modifier canMint() {
340     require(!mintingFinished);
341     _;
342   }
343 
344   modifier hasMintPermission() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Function to mint tokens
351    * @param _to The address that will receive the minted tokens.
352    * @param _amount The amount of tokens to mint.
353    * @return A boolean that indicates if the operation was successful.
354    */
355   function mint(
356     address _to,
357     uint256 _amount
358   )
359     hasMintPermission
360     canMint
361     public
362     returns (bool)
363   {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     emit Mint(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     emit MintFinished();
378     return true;
379   }
380 }
381 
382 /**
383  * @title Burnable Token
384  * @dev Token that can be irreversibly burned (destroyed).
385  */
386 contract BurnableToken is BasicToken {
387 
388   event Burn(address indexed burner, uint256 value);
389 
390   /**
391    * @dev Burns a specific amount of tokens.
392    * @param _value The amount of token to be burned.
393    */
394   function burn(uint256 _value) public {
395     _burn(msg.sender, _value);
396   }
397 
398   function _burn(address _who, uint256 _value) internal {
399     require(_value <= balances[_who]);
400     // no need to require value <= totalSupply, since that would imply the
401     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
402 
403     balances[_who] = balances[_who].sub(_value);
404     totalSupply_ = totalSupply_.sub(_value);
405     emit Burn(_who, _value);
406     emit Transfer(_who, address(0), _value);
407   }
408 }
409 
410 
411 /**
412  * @title ERC827, an extension of ERC20 token standard
413  *
414  * @dev Implementation the ERC827, following the ERC20 standard with extra
415  * methods to transfer value and data and execute calls in transfers and
416  * approvals. Uses OpenZeppelin StandardToken.
417  */
418 contract ERC827Token is ERC827, StandardToken {
419 
420   /**
421    * @dev Addition to ERC20 token methods. It allows to
422    * approve the transfer of value and execute a call with the sent data.
423    * Beware that changing an allowance with this method brings the risk that
424    * someone may use both the old and the new allowance by unfortunate
425    * transaction ordering. One possible solution to mitigate this race condition
426    * is to first reduce the spender's allowance to 0 and set the desired value
427    * afterwards:
428    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
429    * @param _spender The address that will spend the funds.
430    * @param _value The amount of tokens to be spent.
431    * @param _data ABI-encoded contract call to call `_spender` address.
432    * @return true if the call function was executed successfully
433    */
434     function approveAndCall(
435         address _spender,
436         uint256 _value,
437         bytes _data
438     )
439     public
440     payable
441     returns (bool)
442     {
443         require(_spender != address(this));
444 
445         super.approve(_spender, _value);
446 
447         // solium-disable-next-line security/no-call-value
448         require(_spender.call.value(msg.value)(_data));
449 
450         return true;
451     }
452 
453   /**
454    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
455    * address and execute a call with the sent data on the same transaction
456    * @param _to address The address which you want to transfer to
457    * @param _value uint256 the amout of tokens to be transfered
458    * @param _data ABI-encoded contract call to call `_to` address.
459    * @return true if the call function was executed successfully
460    */
461     function transferAndCall(
462         address _to,
463         uint256 _value,
464         bytes _data
465     )
466     public
467     payable
468     returns (bool)
469     {
470         require(_to != address(this));
471 
472         super.transfer(_to, _value);
473 
474         // solium-disable-next-line security/no-call-value
475         require(_to.call.value(msg.value)(_data));
476         return true;
477     }
478 
479   /**
480    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
481    * another and make a contract call on the same transaction
482    * @param _from The address which you want to send tokens from
483    * @param _to The address which you want to transfer to
484    * @param _value The amout of tokens to be transferred
485    * @param _data ABI-encoded contract call to call `_to` address.
486    * @return true if the call function was executed successfully
487    */
488     function transferFromAndCall(
489         address _from,
490         address _to,
491         uint256 _value,
492         bytes _data
493     )
494     public payable returns (bool)
495     {
496         require(_to != address(this));
497 
498         super.transferFrom(_from, _to, _value);
499 
500         // solium-disable-next-line security/no-call-value
501         require(_to.call.value(msg.value)(_data));
502         return true;
503     }
504 
505   /**
506    * @dev Addition to StandardToken methods. Increase the amount of tokens that
507    * an owner allowed to a spender and execute a call with the sent data.
508    * approve should be called when allowed[_spender] == 0. To increment
509    * allowed value is better to use this function to avoid 2 calls (and wait until
510    * the first transaction is mined)
511    * From MonolithDAO Token.sol
512    * @param _spender The address which will spend the funds.
513    * @param _addedValue The amount of tokens to increase the allowance by.
514    * @param _data ABI-encoded contract call to call `_spender` address.
515    */
516     function increaseApprovalAndCall(
517         address _spender,
518         uint _addedValue,
519         bytes _data
520     )
521     public
522     payable
523     returns (bool)
524     {
525         require(_spender != address(this));
526 
527         super.increaseApproval(_spender, _addedValue);
528 
529         // solium-disable-next-line security/no-call-value
530         require(_spender.call.value(msg.value)(_data));
531 
532         return true;
533     }
534 
535   /**
536    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
537    * an owner allowed to a spender and execute a call with the sent data.
538    * approve should be called when allowed[_spender] == 0. To decrement
539    * allowed value is better to use this function to avoid 2 calls (and wait until
540    * the first transaction is mined)
541    * From MonolithDAO Token.sol
542    * @param _spender The address which will spend the funds.
543    * @param _subtractedValue The amount of tokens to decrease the allowance by.
544    * @param _data ABI-encoded contract call to call `_spender` address.
545    */
546     function decreaseApprovalAndCall(
547         address _spender,
548         uint _subtractedValue,
549         bytes _data
550     )
551     public
552     payable
553     returns (bool)
554     {
555         require(_spender != address(this));
556 
557         super.decreaseApproval(_spender, _subtractedValue);
558 
559         // solium-disable-next-line security/no-call-value
560         require(_spender.call.value(msg.value)(_data));
561 
562         return true;
563     }
564 
565 }
566 /**
567  * @title DAOToken, base on zeppelin contract.
568  * @dev ERC20 compatible token. It is a mintable, destructible, burnable token.
569  */
570 
571 contract DAOToken is ERC827Token,MintableToken,BurnableToken {
572 
573     string public name;
574     string public symbol;
575     // solium-disable-next-line uppercase
576     uint8 public constant decimals = 18;
577     uint public cap;
578 
579     /**
580     * @dev Constructor
581     * @param _name - token name
582     * @param _symbol - token symbol
583     * @param _cap - token cap - 0 value means no cap
584     */
585     constructor(string _name, string _symbol,uint _cap) public {
586         name = _name;
587         symbol = _symbol;
588         cap = _cap;
589     }
590 
591     /**
592      * @dev Function to mint tokens
593      * @param _to The address that will receive the minted tokens.
594      * @param _amount The amount of tokens to mint.
595      * @return A boolean that indicates if the operation was successful.
596      */
597     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
598         if (cap > 0)
599             require(totalSupply_.add(_amount) <= cap);
600         return super.mint(_to, _amount);
601     }
602 }
603 
604 /**
605  * @title Reputation system
606  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
607  * A reputation is use to assign influence measure to a DAO'S peers.
608  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
609  * The Reputation contract maintain a map of address to reputation value.
610  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
611  */
612 
613 contract Reputation is Ownable {
614     using SafeMath for uint;
615 
616     mapping (address => uint256) public balances;
617     uint256 public totalSupply;
618     uint public decimals = 18;
619 
620     // Event indicating minting of reputation to an address.
621     event Mint(address indexed _to, uint256 _amount);
622     // Event indicating burning of reputation for an address.
623     event Burn(address indexed _from, uint256 _amount);
624 
625     /**
626     * @dev return the reputation amount of a given owner
627     * @param _owner an address of the owner which we want to get his reputation
628     */
629     function reputationOf(address _owner) public view returns (uint256 balance) {
630         return balances[_owner];
631     }
632 
633     /**
634     * @dev Generates `_amount` of reputation that are assigned to `_to`
635     * @param _to The address that will be assigned the new reputation
636     * @param _amount The quantity of reputation to be generated
637     * @return True if the reputation are generated correctly
638     */
639     function mint(address _to, uint _amount)
640     public
641     onlyOwner
642     returns (bool)
643     {
644         totalSupply = totalSupply.add(_amount);
645         balances[_to] = balances[_to].add(_amount);
646         emit Mint(_to, _amount);
647         return true;
648     }
649 
650     /**
651     * @dev Burns `_amount` of reputation from `_from`
652     * if _amount tokens to burn > balances[_from] the balance of _from will turn to zero.
653     * @param _from The address that will lose the reputation
654     * @param _amount The quantity of reputation to burn
655     * @return True if the reputation are burned correctly
656     */
657     function burn(address _from, uint _amount)
658     public
659     onlyOwner
660     returns (bool)
661     {
662         uint amountMinted = _amount;
663         if (balances[_from] < _amount) {
664             amountMinted = balances[_from];
665         }
666         totalSupply = totalSupply.sub(amountMinted);
667         balances[_from] = balances[_from].sub(amountMinted);
668         emit Burn(_from, amountMinted);
669         return true;
670     }
671 }
672 
673 /**
674  * @title An Avatar holds tokens, reputation and ether for a controller
675  */
676 contract Avatar is Ownable {
677     bytes32 public orgName;
678     DAOToken public nativeToken;
679     Reputation public nativeReputation;
680 
681     event GenericAction(address indexed _action, bytes32[] _params);
682     event SendEther(uint _amountInWei, address indexed _to);
683     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint _value);
684     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint _value);
685     event ExternalTokenIncreaseApproval(StandardToken indexed _externalToken, address _spender, uint _addedValue);
686     event ExternalTokenDecreaseApproval(StandardToken indexed _externalToken, address _spender, uint _subtractedValue);
687     event ReceiveEther(address indexed _sender, uint _value);
688 
689     /**
690     * @dev the constructor takes organization name, native token and reputation system
691     and creates an avatar for a controller
692     */
693     constructor(bytes32 _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
694         orgName = _orgName;
695         nativeToken = _nativeToken;
696         nativeReputation = _nativeReputation;
697     }
698 
699     /**
700     * @dev enables an avatar to receive ethers
701     */
702     function() public payable {
703         emit ReceiveEther(msg.sender, msg.value);
704     }
705 
706     /**
707     * @dev perform a generic call to an arbitrary contract
708     * @param _contract  the contract's address to call
709     * @param _data ABI-encoded contract call to call `_contract` address.
710     * @return the return bytes of the called contract's function.
711     */
712     function genericCall(address _contract,bytes _data) public onlyOwner {
713         // solium-disable-next-line security/no-low-level-calls
714         bool result = _contract.call(_data);
715         // solium-disable-next-line security/no-inline-assembly
716         assembly {
717         // Copy the returned data.
718         returndatacopy(0, 0, returndatasize)
719 
720         switch result
721         // call returns 0 on error.
722         case 0 { revert(0, returndatasize) }
723         default { return(0, returndatasize) }
724         }
725     }
726 
727     /**
728     * @dev send ethers from the avatar's wallet
729     * @param _amountInWei amount to send in Wei units
730     * @param _to send the ethers to this address
731     * @return bool which represents success
732     */
733     function sendEther(uint _amountInWei, address _to) public onlyOwner returns(bool) {
734         _to.transfer(_amountInWei);
735         emit SendEther(_amountInWei, _to);
736         return true;
737     }
738 
739     /**
740     * @dev external token transfer
741     * @param _externalToken the token contract
742     * @param _to the destination address
743     * @param _value the amount of tokens to transfer
744     * @return bool which represents success
745     */
746     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value)
747     public onlyOwner returns(bool)
748     {
749         _externalToken.transfer(_to, _value);
750         emit ExternalTokenTransfer(_externalToken, _to, _value);
751         return true;
752     }
753 
754     /**
755     * @dev external token transfer from a specific account
756     * @param _externalToken the token contract
757     * @param _from the account to spend token from
758     * @param _to the destination address
759     * @param _value the amount of tokens to transfer
760     * @return bool which represents success
761     */
762     function externalTokenTransferFrom(
763         StandardToken _externalToken,
764         address _from,
765         address _to,
766         uint _value
767     )
768     public onlyOwner returns(bool)
769     {
770         _externalToken.transferFrom(_from, _to, _value);
771         emit ExternalTokenTransferFrom(_externalToken, _from, _to, _value);
772         return true;
773     }
774 
775     /**
776     * @dev increase approval for the spender address to spend a specified amount of tokens
777     *      on behalf of msg.sender.
778     * @param _externalToken the address of the Token Contract
779     * @param _spender address
780     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
781     * @return bool which represents a success
782     */
783     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue)
784     public onlyOwner returns(bool)
785     {
786         _externalToken.increaseApproval(_spender, _addedValue);
787         emit ExternalTokenIncreaseApproval(_externalToken, _spender, _addedValue);
788         return true;
789     }
790 
791     /**
792     * @dev decrease approval for the spender address to spend a specified amount of tokens
793     *      on behalf of msg.sender.
794     * @param _externalToken the address of the Token Contract
795     * @param _spender address
796     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
797     * @return bool which represents a success
798     */
799     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue )
800     public onlyOwner returns(bool)
801     {
802         _externalToken.decreaseApproval(_spender, _subtractedValue);
803         emit ExternalTokenDecreaseApproval(_externalToken,_spender, _subtractedValue);
804         return true;
805     }
806 
807 }
808 
809 
810 contract UniversalSchemeInterface {
811 
812     function updateParameters(bytes32 _hashedParameters) public;
813 
814     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
815 }
816 
817 
818 /**
819  * @title Controller contract
820  * @dev A controller controls the organizations tokens ,reputation and avatar.
821  * It is subject to a set of schemes and constraints that determine its behavior.
822  * Each scheme has it own parameters and operation permissions.
823  */
824 interface ControllerInterface {
825 
826     /**
827      * @dev Mint `_amount` of reputation that are assigned to `_to` .
828      * @param  _amount amount of reputation to mint
829      * @param _to beneficiary address
830      * @return bool which represents a success
831     */
832     function mintReputation(uint256 _amount, address _to,address _avatar)
833     external
834     returns(bool);
835 
836     /**
837      * @dev Burns `_amount` of reputation from `_from`
838      * @param _amount amount of reputation to burn
839      * @param _from The address that will lose the reputation
840      * @return bool which represents a success
841      */
842     function burnReputation(uint256 _amount, address _from,address _avatar)
843     external
844     returns(bool);
845 
846     /**
847      * @dev mint tokens .
848      * @param  _amount amount of token to mint
849      * @param _beneficiary beneficiary address
850      * @param _avatar address
851      * @return bool which represents a success
852      */
853     function mintTokens(uint256 _amount, address _beneficiary,address _avatar)
854     external
855     returns(bool);
856 
857   /**
858    * @dev register or update a scheme
859    * @param _scheme the address of the scheme
860    * @param _paramsHash a hashed configuration of the usage of the scheme
861    * @param _permissions the permissions the new scheme will have
862    * @param _avatar address
863    * @return bool which represents a success
864    */
865     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions,address _avatar)
866     external
867     returns(bool);
868 
869     /**
870      * @dev unregister a scheme
871      * @param _avatar address
872      * @param _scheme the address of the scheme
873      * @return bool which represents a success
874      */
875     function unregisterScheme(address _scheme,address _avatar)
876     external
877     returns(bool);
878     /**
879      * @dev unregister the caller's scheme
880      * @param _avatar address
881      * @return bool which represents a success
882      */
883     function unregisterSelf(address _avatar) external returns(bool);
884 
885     function isSchemeRegistered( address _scheme,address _avatar) external view returns(bool);
886 
887     function getSchemeParameters(address _scheme,address _avatar) external view returns(bytes32);
888 
889     function getGlobalConstraintParameters(address _globalConstraint,address _avatar) external view returns(bytes32);
890 
891     function getSchemePermissions(address _scheme,address _avatar) external view returns(bytes4);
892 
893     /**
894      * @dev globalConstraintsCount return the global constraint pre and post count
895      * @return uint globalConstraintsPre count.
896      * @return uint globalConstraintsPost count.
897      */
898     function globalConstraintsCount(address _avatar) external view returns(uint,uint);
899 
900     function isGlobalConstraintRegistered(address _globalConstraint,address _avatar) external view returns(bool);
901 
902     /**
903      * @dev add or update Global Constraint
904      * @param _globalConstraint the address of the global constraint to be added.
905      * @param _params the constraint parameters hash.
906      * @param _avatar the avatar of the organization
907      * @return bool which represents a success
908      */
909     function addGlobalConstraint(address _globalConstraint, bytes32 _params,address _avatar)
910     external returns(bool);
911 
912     /**
913      * @dev remove Global Constraint
914      * @param _globalConstraint the address of the global constraint to be remove.
915      * @param _avatar the organization avatar.
916      * @return bool which represents a success
917      */
918     function removeGlobalConstraint (address _globalConstraint,address _avatar)
919     external  returns(bool);
920 
921   /**
922     * @dev upgrade the Controller
923     *      The function will trigger an event 'UpgradeController'.
924     * @param  _newController the address of the new controller.
925     * @param _avatar address
926     * @return bool which represents a success
927     */
928     function upgradeController(address _newController,address _avatar)
929     external returns(bool);
930 
931     /**
932     * @dev perform a generic call to an arbitrary contract
933     * @param _contract  the contract's address to call
934     * @param _data ABI-encoded contract call to call `_contract` address.
935     * @param _avatar the controller's avatar address
936     * @return bytes32  - the return value of the called _contract's function.
937     */
938     function genericCall(address _contract,bytes _data,address _avatar)
939     external
940     returns(bytes32);
941 
942   /**
943    * @dev send some ether
944    * @param _amountInWei the amount of ether (in Wei) to send
945    * @param _to address of the beneficiary
946    * @param _avatar address
947    * @return bool which represents a success
948    */
949     function sendEther(uint _amountInWei, address _to,address _avatar)
950     external returns(bool);
951 
952     /**
953     * @dev send some amount of arbitrary ERC20 Tokens
954     * @param _externalToken the address of the Token Contract
955     * @param _to address of the beneficiary
956     * @param _value the amount of ether (in Wei) to send
957     * @param _avatar address
958     * @return bool which represents a success
959     */
960     function externalTokenTransfer(StandardToken _externalToken, address _to, uint _value,address _avatar)
961     external
962     returns(bool);
963 
964     /**
965     * @dev transfer token "from" address "to" address
966     *      One must to approve the amount of tokens which can be spend from the
967     *      "from" account.This can be done using externalTokenApprove.
968     * @param _externalToken the address of the Token Contract
969     * @param _from address of the account to send from
970     * @param _to address of the beneficiary
971     * @param _value the amount of ether (in Wei) to send
972     * @param _avatar address
973     * @return bool which represents a success
974     */
975     function externalTokenTransferFrom(StandardToken _externalToken, address _from, address _to, uint _value,address _avatar)
976     external
977     returns(bool);
978 
979     /**
980     * @dev increase approval for the spender address to spend a specified amount of tokens
981     *      on behalf of msg.sender.
982     * @param _externalToken the address of the Token Contract
983     * @param _spender address
984     * @param _addedValue the amount of ether (in Wei) which the approval is referring to.
985     * @param _avatar address
986     * @return bool which represents a success
987     */
988     function externalTokenIncreaseApproval(StandardToken _externalToken, address _spender, uint _addedValue,address _avatar)
989     external
990     returns(bool);
991 
992     /**
993     * @dev decrease approval for the spender address to spend a specified amount of tokens
994     *      on behalf of msg.sender.
995     * @param _externalToken the address of the Token Contract
996     * @param _spender address
997     * @param _subtractedValue the amount of ether (in Wei) which the approval is referring to.
998     * @param _avatar address
999     * @return bool which represents a success
1000     */
1001     function externalTokenDecreaseApproval(StandardToken _externalToken, address _spender, uint _subtractedValue,address _avatar)
1002     external
1003     returns(bool);
1004 
1005     /**
1006      * @dev getNativeReputation
1007      * @param _avatar the organization avatar.
1008      * @return organization native reputation
1009      */
1010     function getNativeReputation(address _avatar)
1011     external
1012     view
1013     returns(address);
1014 }
1015 
1016 contract UniversalScheme is Ownable, UniversalSchemeInterface {
1017     bytes32 public hashedParameters; // For other parameters.
1018 
1019     function updateParameters(
1020         bytes32 _hashedParameters
1021     )
1022         public
1023         onlyOwner
1024     {
1025         hashedParameters = _hashedParameters;
1026     }
1027 
1028     /**
1029     *  @dev get the parameters for the current scheme from the controller
1030     */
1031     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1032         return ControllerInterface(_avatar.owner()).getSchemeParameters(this,address(_avatar));
1033     }
1034 }
1035 contract ExecutableInterface {
1036     function execute(bytes32 _proposalId, address _avatar, int _param) public returns(bool);
1037 }
1038 
1039 interface IntVoteInterface {
1040     //When implementing this interface please do not only override function and modifier,
1041     //but also to keep the modifiers on the overridden functions.
1042     modifier onlyProposalOwner(bytes32 _proposalId) {revert(); _;}
1043     modifier votable(bytes32 _proposalId) {revert(); _;}
1044 
1045     event NewProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _numOfChoices, address _proposer, bytes32 _paramsHash);
1046     event ExecuteProposal(bytes32 indexed _proposalId, address indexed _avatar, uint _decision, uint _totalReputation);
1047     event VoteProposal(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter, uint _vote, uint _reputation);
1048     event CancelProposal(bytes32 indexed _proposalId, address indexed _avatar );
1049     event CancelVoting(bytes32 indexed _proposalId, address indexed _avatar, address indexed _voter);
1050 
1051     /**
1052      * @dev register a new proposal with the given parameters. Every proposal has a unique ID which is being
1053      * generated by calculating keccak256 of a incremented counter.
1054      * @param _numOfChoices number of voting choices
1055      * @param _proposalParameters defines the parameters of the voting machine used for this proposal
1056      * @param _avatar an address to be sent as the payload to the _executable contract.
1057      * @param _executable This contract will be executed when vote is over.
1058      * @param _proposer address
1059      * @return proposal's id.
1060      */
1061     function propose(
1062         uint _numOfChoices,
1063         bytes32 _proposalParameters,
1064         address _avatar,
1065         ExecutableInterface _executable,
1066         address _proposer
1067         ) external returns(bytes32);
1068 
1069     // Only owned proposals and only the owner:
1070     function cancelProposal(bytes32 _proposalId) external returns(bool);
1071 
1072     // Only owned proposals and only the owner:
1073     function ownerVote(bytes32 _proposalId, uint _vote, address _voter) external returns(bool);
1074 
1075     function vote(bytes32 _proposalId, uint _vote) external returns(bool);
1076 
1077     function voteWithSpecifiedAmounts(
1078         bytes32 _proposalId,
1079         uint _vote,
1080         uint _rep,
1081         uint _token) external returns(bool);
1082 
1083     function cancelVote(bytes32 _proposalId) external;
1084 
1085     //@dev execute check if the proposal has been decided, and if so, execute the proposal
1086     //@param _proposalId the id of the proposal
1087     //@return bool true - the proposal has been executed
1088     //             false - otherwise.
1089     function execute(bytes32 _proposalId) external returns(bool);
1090 
1091     function getNumberOfChoices(bytes32 _proposalId) external view returns(uint);
1092 
1093     function isVotable(bytes32 _proposalId) external view returns(bool);
1094 
1095     /**
1096      * @dev voteStatus returns the reputation voted for a proposal for a specific voting choice.
1097      * @param _proposalId the ID of the proposal
1098      * @param _choice the index in the
1099      * @return voted reputation for the given choice
1100      */
1101     function voteStatus(bytes32 _proposalId,uint _choice) external view returns(uint);
1102 
1103     /**
1104      * @dev isAbstainAllow returns if the voting machine allow abstain (0)
1105      * @return bool true or false
1106      */
1107     function isAbstainAllow() external pure returns(bool);
1108 
1109     /**
1110      * @dev getAllowedRangeOfChoices returns the allowed range of choices for a voting machine.
1111      * @return min - minimum number of choices
1112                max - maximum number of choices
1113      */
1114     function getAllowedRangeOfChoices() external pure returns(uint min,uint max);
1115 }
1116 
1117 
1118 
1119 /**
1120  * @title A registrar for Schemes for organizations
1121  * @dev The SchemeRegistrar is used for registering and unregistering schemes at organizations
1122  */
1123 
1124 contract SchemeRegistrar is UniversalScheme {
1125     event NewSchemeProposal(
1126         address indexed _avatar,
1127         bytes32 indexed _proposalId,
1128         address indexed _intVoteInterface,
1129         address _scheme,
1130         bytes32 _parametersHash,
1131         bytes4 _permissions
1132     );
1133     event RemoveSchemeProposal(address indexed _avatar,
1134         bytes32 indexed _proposalId,
1135         address indexed _intVoteInterface,
1136         address _scheme
1137     );
1138     event ProposalExecuted(address indexed _avatar, bytes32 indexed _proposalId,int _param);
1139     event ProposalDeleted(address indexed _avatar, bytes32 indexed _proposalId);
1140 
1141     // a SchemeProposal is a  proposal to add or remove a scheme to/from the an organization
1142     struct SchemeProposal {
1143         address scheme; //
1144         bytes32 parametersHash;
1145         uint proposalType; // 1: add a scheme, 2: remove a scheme.
1146         bytes4 permissions;
1147     }
1148 
1149     // A mapping from the organization (Avatar) address to the saved data of the organization:
1150     mapping(address=>mapping(bytes32=>SchemeProposal)) public organizationsProposals;
1151 
1152     // A mapping from hashes to parameters (use to store a particular configuration on the controller)
1153     struct Parameters {
1154         bytes32 voteRegisterParams;
1155         bytes32 voteRemoveParams;
1156         IntVoteInterface intVote;
1157     }
1158     mapping(bytes32=>Parameters) public parameters;
1159 
1160 
1161     /**
1162     * @dev execute a  proposal
1163     * This method can only be called by the voting machine in which the vote is held.
1164     * @param _proposalId the ID of the proposal in the voting machine
1165     * @param _avatar address of the controller
1166     * @param _param identifies the action to be taken
1167     */
1168     // TODO: this call can be simplified if we save the _avatar together with the proposal
1169     function execute(bytes32 _proposalId, address _avatar, int _param) external returns(bool) {
1170           // Check the caller is indeed the voting machine:
1171         require(parameters[getParametersFromController(Avatar(_avatar))].intVote == msg.sender);
1172         SchemeProposal memory proposal = organizationsProposals[_avatar][_proposalId];
1173         require(proposal.scheme != address(0));
1174         delete organizationsProposals[_avatar][_proposalId];
1175         emit ProposalDeleted(_avatar,_proposalId);
1176         if (_param == 1) {
1177 
1178           // Define controller and get the params:
1179             ControllerInterface controller = ControllerInterface(Avatar(_avatar).owner());
1180 
1181           // Add a scheme:
1182             if (proposal.proposalType == 1) {
1183                 require(controller.registerScheme(proposal.scheme, proposal.parametersHash, proposal.permissions,_avatar));
1184             }
1185           // Remove a scheme:
1186             if ( proposal.proposalType == 2 ) {
1187                 require(controller.unregisterScheme(proposal.scheme,_avatar));
1188             }
1189           }
1190         emit ProposalExecuted(_avatar, _proposalId,_param);
1191         return true;
1192     }
1193 
1194     /**
1195     * @dev hash the parameters, save them if necessary, and return the hash value
1196     */
1197     function setParameters(
1198         bytes32 _voteRegisterParams,
1199         bytes32 _voteRemoveParams,
1200         IntVoteInterface _intVote
1201     ) public returns(bytes32)
1202     {
1203         bytes32 paramsHash = getParametersHash(_voteRegisterParams, _voteRemoveParams, _intVote);
1204         parameters[paramsHash].voteRegisterParams = _voteRegisterParams;
1205         parameters[paramsHash].voteRemoveParams = _voteRemoveParams;
1206         parameters[paramsHash].intVote = _intVote;
1207         return paramsHash;
1208     }
1209 
1210     function getParametersHash(
1211         bytes32 _voteRegisterParams,
1212         bytes32 _voteRemoveParams,
1213         IntVoteInterface _intVote
1214     ) public pure returns(bytes32)
1215     {
1216         return keccak256(abi.encodePacked(_voteRegisterParams, _voteRemoveParams, _intVote));
1217     }
1218 
1219     /**
1220     * @dev create a proposal to register a scheme
1221     * @param _avatar the address of the organization the scheme will be registered for
1222     * @param _scheme the address of the scheme to be registered
1223     * @param _parametersHash a hash of the configuration of the _scheme
1224     * @param _permissions the permission of the scheme to be registered
1225     * @return a proposal Id
1226     * @dev NB: not only proposes the vote, but also votes for it
1227     */
1228     function proposeScheme(
1229         Avatar _avatar,
1230         address _scheme,
1231         bytes32 _parametersHash,
1232         bytes4 _permissions
1233     )
1234     public
1235     returns(bytes32)
1236     {
1237         // propose
1238         require(_scheme != address(0));
1239         Parameters memory controllerParams = parameters[getParametersFromController(_avatar)];
1240 
1241         bytes32 proposalId = controllerParams.intVote.propose(
1242             2,
1243             controllerParams.voteRegisterParams,
1244             _avatar,
1245             ExecutableInterface(this),
1246             msg.sender
1247         );
1248 
1249         SchemeProposal memory proposal = SchemeProposal({
1250             scheme: _scheme,
1251             parametersHash: _parametersHash,
1252             proposalType: 1,
1253             permissions: _permissions
1254         });
1255         emit NewSchemeProposal(
1256             _avatar,
1257             proposalId,
1258             controllerParams.intVote,
1259             _scheme, _parametersHash,
1260             _permissions
1261         );
1262         organizationsProposals[_avatar][proposalId] = proposal;
1263 
1264         // vote for this proposal
1265         controllerParams.intVote.ownerVote(proposalId, 1, msg.sender); // Automatically votes `yes` in the name of the opener.
1266         return proposalId;
1267     }
1268 
1269     /**
1270     * @dev propose to remove a scheme for a controller
1271     * @param _avatar the address of the controller from which we want to remove a scheme
1272     * @param _scheme the address of the scheme we want to remove
1273     *
1274     * NB: not only registers the proposal, but also votes for it
1275     */
1276     function proposeToRemoveScheme(Avatar _avatar, address _scheme)
1277     public
1278     returns(bytes32)
1279     {
1280         bytes32 paramsHash = getParametersFromController(_avatar);
1281         Parameters memory params = parameters[paramsHash];
1282 
1283         IntVoteInterface intVote = params.intVote;
1284         bytes32 proposalId = intVote.propose(2, params.voteRemoveParams, _avatar, ExecutableInterface(this),msg.sender);
1285 
1286         organizationsProposals[_avatar][proposalId].proposalType = 2;
1287         organizationsProposals[_avatar][proposalId].scheme = _scheme;
1288         emit RemoveSchemeProposal(_avatar, proposalId, intVote, _scheme);
1289         // vote for this proposal
1290         intVote.ownerVote(proposalId, 1, msg.sender); // Automatically votes `yes` in the name of the opener.
1291         return proposalId;
1292     }
1293 }