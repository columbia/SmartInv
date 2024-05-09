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
67 // File: contracts/FreezableToken.sol
68 
69 /**
70 * @title Freezable Token
71 * @dev Token that can be freezed for chosen token holder.
72 */
73 contract FreezableToken is Ownable {
74 
75     mapping (address => bool) public frozenList;
76 
77     event FrozenFunds(address indexed wallet, bool frozen);
78 
79     /**
80     * @dev Owner can freeze the token balance for chosen token holder.
81     * @param _wallet The address of token holder whose tokens to be frozen.
82     */
83     function freezeAccount(address _wallet) public onlyOwner {
84         require(
85             _wallet != address(0),
86             "Address must be not empty"
87         );
88         frozenList[_wallet] = true;
89         emit FrozenFunds(_wallet, true);
90     }
91 
92     /**
93     * @dev Owner can unfreeze the token balance for chosen token holder.
94     * @param _wallet The address of token holder whose tokens to be unfrozen.
95     */
96     function unfreezeAccount(address _wallet) public onlyOwner {
97         require(
98             _wallet != address(0),
99             "Address must be not empty"
100         );
101         frozenList[_wallet] = false;
102         emit FrozenFunds(_wallet, false);
103     }
104 
105     /**
106     * @dev Check the specified token holder whether his/her token balance is frozen.
107     * @param _wallet The address of token holder to check.
108     */ 
109     function isFrozen(address _wallet) public view returns (bool) {
110         return frozenList[_wallet];
111     }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
116 
117 /**
118  * @title Pausable
119  * @dev Base contract which allows children to implement an emergency stop mechanism.
120  */
121 contract Pausable is Ownable {
122   event Pause();
123   event Unpause();
124 
125   bool public paused = false;
126 
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is not paused.
130    */
131   modifier whenNotPaused() {
132     require(!paused);
133     _;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is paused.
138    */
139   modifier whenPaused() {
140     require(paused);
141     _;
142   }
143 
144   /**
145    * @dev called by the owner to pause, triggers stopped state
146    */
147   function pause() onlyOwner whenNotPaused public {
148     paused = true;
149     emit Pause();
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     emit Unpause();
158   }
159 }
160 
161 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
162 
163 /**
164  * @title SafeMath
165  * @dev Math operations with safety checks that throw on error
166  */
167 library SafeMath {
168 
169   /**
170   * @dev Multiplies two numbers, throws on overflow.
171   */
172   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
173     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
174     // benefit is lost if 'b' is also tested.
175     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
176     if (a == 0) {
177       return 0;
178     }
179 
180     c = a * b;
181     assert(c / a == b);
182     return c;
183   }
184 
185   /**
186   * @dev Integer division of two numbers, truncating the quotient.
187   */
188   function div(uint256 a, uint256 b) internal pure returns (uint256) {
189     // assert(b > 0); // Solidity automatically throws when dividing by 0
190     // uint256 c = a / b;
191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192     return a / b;
193   }
194 
195   /**
196   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
197   */
198   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199     assert(b <= a);
200     return a - b;
201   }
202 
203   /**
204   * @dev Adds two numbers, throws on overflow.
205   */
206   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
207     c = a + b;
208     assert(c >= a);
209     return c;
210   }
211 }
212 
213 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
214 
215 /**
216  * @title ERC20Basic
217  * @dev Simpler version of ERC20 interface
218  * See https://github.com/ethereum/EIPs/issues/179
219  */
220 contract ERC20Basic {
221   function totalSupply() public view returns (uint256);
222   function balanceOf(address who) public view returns (uint256);
223   function transfer(address to, uint256 value) public returns (bool);
224   event Transfer(address indexed from, address indexed to, uint256 value);
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
228 
229 /**
230  * @title Basic token
231  * @dev Basic version of StandardToken, with no allowances.
232  */
233 contract BasicToken is ERC20Basic {
234   using SafeMath for uint256;
235 
236   mapping(address => uint256) balances;
237 
238   uint256 totalSupply_;
239 
240   /**
241   * @dev Total number of tokens in existence
242   */
243   function totalSupply() public view returns (uint256) {
244     return totalSupply_;
245   }
246 
247   /**
248   * @dev Transfer token for a specified address
249   * @param _to The address to transfer to.
250   * @param _value The amount to be transferred.
251   */
252   function transfer(address _to, uint256 _value) public returns (bool) {
253     require(_to != address(0));
254     require(_value <= balances[msg.sender]);
255 
256     balances[msg.sender] = balances[msg.sender].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     emit Transfer(msg.sender, _to, _value);
259     return true;
260   }
261 
262   /**
263   * @dev Gets the balance of the specified address.
264   * @param _owner The address to query the the balance of.
265   * @return An uint256 representing the amount owned by the passed address.
266   */
267   function balanceOf(address _owner) public view returns (uint256) {
268     return balances[_owner];
269   }
270 
271 }
272 
273 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
274 
275 /**
276  * @title Burnable Token
277  * @dev Token that can be irreversibly burned (destroyed).
278  */
279 contract BurnableToken is BasicToken {
280 
281   event Burn(address indexed burner, uint256 value);
282 
283   /**
284    * @dev Burns a specific amount of tokens.
285    * @param _value The amount of token to be burned.
286    */
287   function burn(uint256 _value) public {
288     _burn(msg.sender, _value);
289   }
290 
291   function _burn(address _who, uint256 _value) internal {
292     require(_value <= balances[_who]);
293     // no need to require value <= totalSupply, since that would imply the
294     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
295 
296     balances[_who] = balances[_who].sub(_value);
297     totalSupply_ = totalSupply_.sub(_value);
298     emit Burn(_who, _value);
299     emit Transfer(_who, address(0), _value);
300   }
301 }
302 
303 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
304 
305 /**
306  * @title ERC20 interface
307  * @dev see https://github.com/ethereum/EIPs/issues/20
308  */
309 contract ERC20 is ERC20Basic {
310   function allowance(address owner, address spender)
311     public view returns (uint256);
312 
313   function transferFrom(address from, address to, uint256 value)
314     public returns (bool);
315 
316   function approve(address spender, uint256 value) public returns (bool);
317   event Approval(
318     address indexed owner,
319     address indexed spender,
320     uint256 value
321   );
322 }
323 
324 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
325 
326 /**
327  * @title Standard ERC20 token
328  *
329  * @dev Implementation of the basic standard token.
330  * https://github.com/ethereum/EIPs/issues/20
331  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
397    * approve should be called when allowed[_spender] == 0. To increment
398    * allowed value is better to use this function to avoid 2 calls (and wait until
399    * the first transaction is mined)
400    * From MonolithDAO Token.sol
401    * @param _spender The address which will spend the funds.
402    * @param _addedValue The amount of tokens to increase the allowance by.
403    */
404   function increaseApproval(
405     address _spender,
406     uint256 _addedValue
407   )
408     public
409     returns (bool)
410   {
411     allowed[msg.sender][_spender] = (
412       allowed[msg.sender][_spender].add(_addedValue));
413     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414     return true;
415   }
416 
417   /**
418    * @dev Decrease the amount of tokens that an owner allowed to a spender.
419    * approve should be called when allowed[_spender] == 0. To decrement
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _subtractedValue The amount of tokens to decrease the allowance by.
425    */
426   function decreaseApproval(
427     address _spender,
428     uint256 _subtractedValue
429   )
430     public
431     returns (bool)
432   {
433     uint256 oldValue = allowed[msg.sender][_spender];
434     if (_subtractedValue > oldValue) {
435       allowed[msg.sender][_spender] = 0;
436     } else {
437       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438     }
439     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443 }
444 
445 // File: contracts/MocrowCoin.sol
446 
447 interface tokenRecipient {
448     function receiveApproval(
449         address _from,
450         uint256 _value,
451         address _token,
452         bytes _extraData)
453     external;
454 }
455 
456 
457 contract MocrowCoin is StandardToken, BurnableToken, FreezableToken, Pausable {
458     string public constant name = "MOCROW";
459     string public constant symbol = "MCW";
460     uint8 public constant decimals = 18;
461 
462     uint256 public constant RESERVED_TOKENS_FOR_FOUNDERS_AND_FOUNDATION = 201700456 * (10 ** uint256(decimals));
463     uint256 public constant RESERVED_TOKENS_FOR_PLATFORM_OPERATIONS = 113010700 * (10 ** uint256(decimals));
464     uint256 public constant RESERVED_TOKENS_FOR_ROI_ON_CAPITAL = 9626337 * (10 ** uint256(decimals));
465     uint256 public constant RESERVED_TOKENS_FOR_FINANCIAL_INSTITUTION = 77010700 * (10 ** uint256(decimals));
466     uint256 public constant RESERVED_TOKENS_FOR_CYNOTRUST = 11551604 * (10 ** uint256(decimals));
467     uint256 public constant RESERVED_TOKENS_FOR_CRYPTO_EXCHANGES = 244936817 * (10 ** uint256(decimals));
468     uint256 public constant RESERVED_TOKENS_FOR_FURTHER_TECH_DEVELOPMENT = 11551604 * (10 ** uint256(decimals));
469 
470     uint256 public constant RESERVED_TOKENS_FOR_PRE_ICO = 59561520 * (10 ** uint256(decimals));
471     uint256 public constant RESERVED_TOKENS_FOR_ICO = 139999994 * (10 ** uint256(decimals));
472     uint256 public constant RESERVED_TOKENS_FOR_ICO_BONUSES = 15756152 * (10 ** uint256(decimals));
473 
474     uint256 public constant TOTAL_SUPPLY_VALUE = 884705884 * (10 ** uint256(decimals));
475 
476     address public addressIco;
477 
478     bool isIcoSet = false;
479 
480     modifier onlyIco() {
481         require(
482             msg.sender == addressIco,
483             "Address must be the address of the ICO"
484         );
485         _;
486     }
487 
488     /**
489     * @dev Create MocrowCoin contract with reserves.
490     * @param _foundersFoundationReserve The address of founders and foundation reserve.
491     * @param _platformOperationsReserve The address of platform operations reserve.
492     * @param _roiOnCapitalReserve The address of roi on capital reserve.
493     * @param _financialInstitutionReserve The address of financial institution reserve.
494     * @param _cynotrustReserve The address of Cynotrust reserve.
495     * @param _cryptoExchangesReserve The address of crypto exchanges reserve.
496     * @param _furtherTechDevelopmentReserve The address of further tech development reserve.
497     */
498     constructor(
499         address _foundersFoundationReserve,
500         address _platformOperationsReserve,
501         address _roiOnCapitalReserve,
502         address _financialInstitutionReserve,
503         address _cynotrustReserve,
504         address _cryptoExchangesReserve,
505         address _furtherTechDevelopmentReserve) public
506         {
507         require(
508             _foundersFoundationReserve != address(0) && 
509             _platformOperationsReserve != address(0) && _roiOnCapitalReserve != address(0) && _financialInstitutionReserve != address(0),
510             "Addresses must be not empty"
511         );
512 
513         require(
514             _cynotrustReserve != address(0) && 
515             _cryptoExchangesReserve != address(0) && _furtherTechDevelopmentReserve != address(0),
516             "Addresses must be not empty"
517         );
518 
519         balances[_foundersFoundationReserve] = RESERVED_TOKENS_FOR_FOUNDERS_AND_FOUNDATION;
520         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_FOUNDERS_AND_FOUNDATION);
521         emit Transfer(address(0), _foundersFoundationReserve, RESERVED_TOKENS_FOR_FOUNDERS_AND_FOUNDATION);
522 
523         balances[_platformOperationsReserve] = RESERVED_TOKENS_FOR_PLATFORM_OPERATIONS;
524         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_PLATFORM_OPERATIONS);
525         emit Transfer(address(0), _platformOperationsReserve, RESERVED_TOKENS_FOR_PLATFORM_OPERATIONS);
526 
527         balances[_roiOnCapitalReserve] = RESERVED_TOKENS_FOR_ROI_ON_CAPITAL;
528         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_ROI_ON_CAPITAL);
529         emit Transfer(address(0), _roiOnCapitalReserve, RESERVED_TOKENS_FOR_ROI_ON_CAPITAL);
530 
531         balances[_financialInstitutionReserve] = RESERVED_TOKENS_FOR_FINANCIAL_INSTITUTION;
532         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_FINANCIAL_INSTITUTION);
533         emit Transfer(address(0), _financialInstitutionReserve, RESERVED_TOKENS_FOR_FINANCIAL_INSTITUTION);
534 
535         balances[_cynotrustReserve] = RESERVED_TOKENS_FOR_CYNOTRUST;
536         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_CYNOTRUST);
537         emit Transfer(address(0), _cynotrustReserve, RESERVED_TOKENS_FOR_CYNOTRUST);
538 
539         balances[_cryptoExchangesReserve] = RESERVED_TOKENS_FOR_CRYPTO_EXCHANGES;
540         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_CRYPTO_EXCHANGES);
541         emit Transfer(address(0), _cryptoExchangesReserve, RESERVED_TOKENS_FOR_CRYPTO_EXCHANGES);
542 
543         balances[_furtherTechDevelopmentReserve] = RESERVED_TOKENS_FOR_FURTHER_TECH_DEVELOPMENT;
544         totalSupply_ = totalSupply_.add(RESERVED_TOKENS_FOR_FURTHER_TECH_DEVELOPMENT);
545         emit Transfer(address(0), _furtherTechDevelopmentReserve, RESERVED_TOKENS_FOR_FURTHER_TECH_DEVELOPMENT);
546     }
547 
548     /**
549     * @dev Transfer token for a specified address with pause and freeze features for owner.
550     * @dev Only applies when the transfer is allowed by the owner.
551     * @param _to The address to transfer to.
552     * @param _value The amount to be transferred.
553     */
554     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
555         require(
556             !isFrozen(msg.sender),
557             "Transfer possibility must be unfrozen for the address"
558         );
559         return super.transfer(_to, _value);
560     }
561 
562     /**
563     * @dev Transfer tokens from one address to another with pause and freeze features for owner.
564     * @dev Only applies when the transfer is allowed by the owner.
565     * @param _from address The address which you want to send tokens from
566     * @param _to address The address which you want to transfer to
567     * @param _value uint256 the amount of tokens to be transferred
568     */
569     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
570         require(
571             !isFrozen(msg.sender),
572             "Transfer possibility must be unfrozen for the address"
573         );
574         require(
575             !isFrozen(_from),
576             "Transfer possibility must be unfrozen for the address"
577         );
578         return super.transferFrom(_from, _to, _value);
579     }
580 
581     /**
582     * @dev Transfer tokens from ICO address to another address.
583     * @param _to The address to transfer to.
584     * @param _value The amount to be transferred.
585     */
586     function transferFromIco(address _to, uint256 _value) public onlyIco returns (bool) {
587         return super.transfer(_to, _value);
588     }
589 
590     /**
591     * @dev Set ICO address.
592     * @param _addressIco The address of ICO contract.
593     */
594     function setIco(address _addressIco) public onlyOwner {
595         require(
596             _addressIco != address(0),
597             "Address must be not empty"
598         );
599 
600         require(
601             !isIcoSet,
602             "ICO address is already set"
603         );
604         
605         addressIco = _addressIco;
606 
607         uint256 amountToSell = RESERVED_TOKENS_FOR_PRE_ICO.add(RESERVED_TOKENS_FOR_ICO).add(RESERVED_TOKENS_FOR_ICO_BONUSES);
608         balances[addressIco] = amountToSell;
609         totalSupply_ = totalSupply_.add(amountToSell);
610         emit Transfer(address(0), addressIco, amountToSell);
611 
612         isIcoSet = true;        
613     }
614 
615     /**
616     * Set allowance for other address and notify
617     *
618     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
619     *
620     * @param _spender The address authorized to spend
621     * @param _value the max amount they can spend
622     * @param _extraData some extra information to send to the approved contract
623     */
624     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
625         tokenRecipient spender = tokenRecipient(_spender);
626         if (approve(_spender, _value)) {
627             spender.receiveApproval(
628                 msg.sender,
629                 _value, this,
630                 _extraData);
631             return true;
632         }
633     }
634 
635 }