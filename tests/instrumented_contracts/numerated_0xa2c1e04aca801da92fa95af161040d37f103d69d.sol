1 pragma solidity 0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\CappedToken.sol
379 
380 /**
381  * @title Capped token
382  * @dev Mintable token with a token cap.
383  */
384 contract CappedToken is MintableToken {
385 
386   uint256 public cap;
387 
388   constructor(uint256 _cap) public {
389     require(_cap > 0);
390     cap = _cap;
391   }
392 
393   /**
394    * @dev Function to mint tokens
395    * @param _to The address that will receive the minted tokens.
396    * @param _amount The amount of tokens to mint.
397    * @return A boolean that indicates if the operation was successful.
398    */
399   function mint(
400     address _to,
401     uint256 _amount
402   )
403     public
404     returns (bool)
405   {
406     require(totalSupply_.add(_amount) <= cap);
407 
408     return super.mint(_to, _amount);
409   }
410 
411 }
412 
413 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
414 
415 /**
416  * @title Burnable Token
417  * @dev Token that can be irreversibly burned (destroyed).
418  */
419 contract BurnableToken is BasicToken {
420 
421   event Burn(address indexed burner, uint256 value);
422 
423   /**
424    * @dev Burns a specific amount of tokens.
425    * @param _value The amount of token to be burned.
426    */
427   function burn(uint256 _value) public {
428     _burn(msg.sender, _value);
429   }
430 
431   function _burn(address _who, uint256 _value) internal {
432     require(_value <= balances[_who]);
433     // no need to require value <= totalSupply, since that would imply the
434     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
435 
436     balances[_who] = balances[_who].sub(_value);
437     totalSupply_ = totalSupply_.sub(_value);
438     emit Burn(_who, _value);
439     emit Transfer(_who, address(0), _value);
440   }
441 }
442 
443 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
444 
445 /**
446  * @title DetailedERC20 token
447  * @dev The decimals are only for visualization purposes.
448  * All the operations are done using the smallest and indivisible token unit,
449  * just as on Ethereum all the operations are done in wei.
450  */
451 contract DetailedERC20 is ERC20 {
452   string public name;
453   string public symbol;
454   uint8 public decimals;
455 
456   constructor(string _name, string _symbol, uint8 _decimals) public {
457     name = _name;
458     symbol = _symbol;
459     decimals = _decimals;
460   }
461 }
462 
463 // File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
464 
465 /**
466  * @title Pausable
467  * @dev Base contract which allows children to implement an emergency stop mechanism.
468  */
469 contract Pausable is Ownable {
470   event Pause();
471   event Unpause();
472 
473   bool public paused = false;
474 
475 
476   /**
477    * @dev Modifier to make a function callable only when the contract is not paused.
478    */
479   modifier whenNotPaused() {
480     require(!paused);
481     _;
482   }
483 
484   /**
485    * @dev Modifier to make a function callable only when the contract is paused.
486    */
487   modifier whenPaused() {
488     require(paused);
489     _;
490   }
491 
492   /**
493    * @dev called by the owner to pause, triggers stopped state
494    */
495   function pause() public onlyOwner whenNotPaused {
496     paused = true;
497     emit Pause();
498   }
499 
500   /**
501    * @dev called by the owner to unpause, returns to normal state
502    */
503   function unpause() public onlyOwner whenPaused {
504     paused = false;
505     emit Unpause();
506   }
507 }
508 
509 // File: contracts\CoyToken.sol
510 
511 /**
512  * @title COYToken
513  * @dev CoinAnalyst's ERC20 Token.
514  * Besides the standard ERC20 functionality, the token allows minting, batch minting, 
515  * burning, and assigning. Furthermore, it is a pausable capped token.
516  * When paused, transfers are impossible.
517  *
518  * This contract is heavily based on the Open Zeppelin classes:
519  * - CappedToken
520  * - BurnableToken
521  * - Pausable
522  * - SafeMath
523  */
524 contract CoyToken is CappedToken, BurnableToken, DetailedERC20, Pausable {
525     using SafeMath for uint256;
526     using SafeMath for uint8;
527     
528     string private constant COY_NAME = "CoinAnalyst";
529     string private constant COY_SYMBOL = "COY";
530     uint8 private constant COY_DECIMALS = 18;
531     
532     /** 
533      * Define cap internally to later use for capped token.
534      * Using same number of decimal figures as ETH (i.e. 18).
535      * Maximum number of tokens in circulation: 3.75 billion.
536      */
537     uint256 private constant TOKEN_UNIT = 10 ** uint256(COY_DECIMALS);
538     uint256 private constant COY_CAP = (3.75 * 10 ** 9) * TOKEN_UNIT;
539     
540     // Token roles
541     address public minter;
542     address public assigner;
543     address public burner;
544 
545     /**
546      * @dev Constructor that initializes the COYToken contract.
547      * @param _minter The minter account.
548      * @param _assigner The assigner account.
549      * @param _burner The burner account.
550      */
551     constructor(address _minter, address _assigner, address _burner) 
552         CappedToken(COY_CAP) 
553         DetailedERC20(COY_NAME, COY_SYMBOL, COY_DECIMALS)
554         public
555     {
556         require(_minter != address(0), "Minter must be a valid non-null address");
557         require(_assigner != address(0), "Assigner must be a valid non-null address");
558         require(_burner != address(0), "Burner must be a valid non-null address");
559 
560         minter = _minter;
561         assigner = _assigner;
562         burner = _burner;
563     }
564 
565     event MinterTransferred(address indexed _minter, address indexed _newMinter);
566     event AssignerTransferred(address indexed _assigner, address indexed _newAssigner);
567     event BurnerTransferred(address indexed _burner, address indexed _newBurner);
568     event BatchMint(uint256 _totalMintedTokens, uint256 _batchMintId);
569     event Assign(address indexed _to, uint256 _amount);
570     event BatchAssign(uint256 _totalAssignedTokens, uint256 _batchAssignId);
571     event BatchTransfer(uint256 _totalTransferredTokens, uint256 _batchTransferId);
572     
573     /** 
574      * @dev Throws if called by any account other than the minter.
575      *      Override from MintableToken
576      */
577     modifier hasMintPermission() {
578         require(msg.sender == minter, "Only the minter can do this.");
579         _;
580     }
581     
582     /** 
583      * @dev Throws if called by any account other than the assigner.
584      */
585     modifier hasAssignPermission() {
586         require(msg.sender == assigner, "Only the assigner can do this.");
587         _;
588     }
589     
590     /**
591      *  @dev Throws if called by any account other than the burner.
592      */
593     modifier hasBurnPermission() {
594         require(msg.sender == burner, "Only the burner can do this.");
595         _;
596     }
597     
598     /**
599      *  @dev Throws if minting period is still ongoing.
600      */
601     modifier whenMintingFinished() {
602         require(mintingFinished, "Minting has to be finished.");
603         _;
604     }
605 
606 
607     /**
608      *  @dev Allows the current owner to change the minter.
609      *  @param _newMinter The address of the new minter.
610      *  @return True if the operation was successful.
611      */
612     function setMinter(address _newMinter) external 
613         canMint
614         onlyOwner 
615         returns(bool) 
616     {
617         require(_newMinter != address(0), "New minter must be a valid non-null address");
618         require(_newMinter != minter, "New minter has to differ from previous minter");
619 
620         emit MinterTransferred(minter, _newMinter);
621         minter = _newMinter;
622         return true;
623     }
624     
625     /**
626      *  @dev Allows the current owner to change the assigner.
627      *  @param _newAssigner The address of the new assigner.
628      *  @return True if the operation was successful.
629      */
630     function setAssigner(address _newAssigner) external 
631         onlyOwner 
632         canMint
633         returns(bool) 
634     {
635         require(_newAssigner != address(0), "New assigner must be a valid non-null address");
636         require(_newAssigner != assigner, "New assigner has to differ from previous assigner");
637 
638         emit AssignerTransferred(assigner, _newAssigner);
639         assigner = _newAssigner;
640         return true;
641     }
642     
643     /**
644      *  @dev Allows the current owner to change the burner.
645      *  @param _newBurner The address of the new burner.
646      *  @return True if the operation was successful.
647      */
648     function setBurner(address _newBurner) external 
649         onlyOwner 
650         returns(bool) 
651     {
652         require(_newBurner != address(0), "New burner must be a valid non-null address");
653         require(_newBurner != burner, "New burner has to differ from previous burner");
654 
655         emit BurnerTransferred(burner, _newBurner);
656         burner = _newBurner;
657         return true;
658     }
659     
660     /**
661      * @dev Function to batch mint tokens.
662      * @param _to An array of addresses that will receive the minted tokens.
663      * @param _amounts An array with the amounts of tokens each address will get minted.
664      * @param _batchMintId Identifier for the batch in order to synchronize with internal (off-chain) processes.
665      * @return A boolean that indicates whether the operation was successful.
666      */
667     function batchMint(address[] _to, uint256[] _amounts, uint256 _batchMintId) external
668         canMint
669         hasMintPermission
670         returns (bool) 
671     {
672         require(_to.length == _amounts.length, "Input arrays must have the same length");
673         
674         uint256 totalMintedTokens = 0;
675         for (uint i = 0; i < _to.length; i++) {
676             mint(_to[i], _amounts[i]);
677             totalMintedTokens = totalMintedTokens.add(_amounts[i]);
678         }
679         
680         emit BatchMint(totalMintedTokens, _batchMintId);
681         return true;
682     }
683     
684     /**
685      * @dev Function to assign any number of tokens to a given address.
686      *      Compared to the `mint` function, the `assign` function allows not just to increase but also to decrease
687      *      the number of tokens of an address by assigning a lower value than the address current balance.
688      *      This function can only be executed during initial token sale.
689      * @param _to The address that will receive the assigned tokens.
690      * @param _amount The amount of tokens to assign.
691      * @return True if the operation was successful.
692      */
693     function assign(address _to, uint256 _amount) public 
694         canMint
695         hasAssignPermission 
696         returns(bool) 
697     {
698         // The desired value to assign (`_amount`) can be either higher or lower than the current number of tokens
699         // of the address (`balances[_to]`). To calculate the new `totalSupply_` value, the difference between `_amount`
700         // and `balances[_to]` (`delta`) is calculated first, and then added or substracted to `totalSupply_` accordingly.
701         uint256 delta = 0;
702         if (balances[_to] < _amount) {
703             // balances[_to] will be increased, so totalSupply_ should be increased
704             delta = _amount.sub(balances[_to]);
705             totalSupply_ = totalSupply_.add(delta);
706             require(totalSupply_ <= cap, "Total supply cannot be higher than cap");
707             emit Transfer(address(0), _to, delta); // conformity to mint and burn functions for easier balance retrieval via event logs
708         } else {
709             // balances[_to] will be decreased, so totalSupply_ should be decreased
710             delta = balances[_to].sub(_amount);
711             totalSupply_ = totalSupply_.sub(delta);
712             emit Transfer(_to, address(0), delta); // conformity to mint and burn functions for easier balance retrieval via event logs
713         }
714         
715         require(delta > 0, "Delta should not be zero");
716 
717         balances[_to] = _amount;
718         emit Assign(_to, _amount);
719         return true;
720     }
721     
722     /**
723      * @dev Function to assign a list of numbers of tokens to a given list of addresses.
724      * @param _to The addresses that will receive the assigned tokens.
725      * @param _amounts The amounts of tokens to assign.
726      * @param _batchAssignId Identifier for the batch in order to synchronize with internal (off-chain) processes.
727      * @return True if the operation was successful.
728      */
729     function batchAssign(address[] _to, uint256[] _amounts, uint256 _batchAssignId) external
730         canMint
731         hasAssignPermission
732         returns (bool) 
733     {
734         require(_to.length == _amounts.length, "Input arrays must have the same length");
735         
736         uint256 totalAssignedTokens = 0;
737         for (uint i = 0; i < _to.length; i++) {
738             assign(_to[i], _amounts[i]);
739             totalAssignedTokens = totalAssignedTokens.add(_amounts[i]);
740         }
741         
742         emit BatchAssign(totalAssignedTokens, _batchAssignId);
743         return true;
744     }
745     
746     /**
747      * @dev Burns a specific amount of tokens.
748      * @param _value The amount of token to be burned.
749      */
750     function burn(uint256 _value) public
751         hasBurnPermission
752     {
753         super.burn(_value);
754     }
755 
756     /**
757      * @dev transfer token for a specified address when minting is finished.
758      * @param _to The address to transfer to.
759      * @param _value The amount to be transferred.
760      */
761     function transfer(address _to, uint256 _value) public
762         whenMintingFinished
763         whenNotPaused
764         returns (bool) 
765     {
766         return super.transfer(_to, _value);
767     }
768 
769     /**
770      * @dev Transfer tokens from one address to another when minting is finished.
771      * @param _from address The address which you want to send tokens from
772      * @param _to address The address which you want to transfer to
773      * @param _value uint256 the amount of tokens to be transferred
774      */
775     function transferFrom(address _from, address _to, uint256 _value) public
776         whenMintingFinished
777         whenNotPaused
778         returns (bool) 
779     {
780         return super.transferFrom(_from, _to, _value);
781     }
782     
783     /**
784      * @dev Transfer tokens from one address to several others when minting is finished.
785      * @param _to addresses The addresses which you want to transfer to
786      * @param _amounts uint256 the amounts of tokens to be transferred
787      * @param _batchTransferId Identifier for the batch in order to synchronize with internal (off-chain) processes.
788      */
789     function transferInBatches(address[] _to, uint256[] _amounts, uint256 _batchTransferId) public
790         whenMintingFinished
791         whenNotPaused
792         returns (bool) 
793     {
794         require(_to.length == _amounts.length, "Input arrays must have the same length");
795         
796         uint256 totalTransferredTokens = 0;
797         for (uint i = 0; i < _to.length; i++) {
798             transfer(_to[i], _amounts[i]);
799             totalTransferredTokens = totalTransferredTokens.add(_amounts[i]);
800         }
801         
802         emit BatchTransfer(totalTransferredTokens, _batchTransferId);
803         return true;
804     }
805 }