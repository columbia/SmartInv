1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipRenounced(address indexed previousOwner);
29   event OwnershipTransferred(
30     address indexed previousOwner,
31     address indexed newOwner
32   );
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(owner);
59     owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param _newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address _newOwner) internal {
75     require(_newOwner != address(0));
76     emit OwnershipTransferred(owner, _newOwner);
77     owner = _newOwner;
78   }
79 }
80 
81 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (_a == 0) {
97       return 0;
98     }
99 
100     c = _a * _b;
101     assert(c / _a == _b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     // assert(_b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = _a / _b;
111     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
112     return _a / _b;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     assert(_b <= _a);
120     return _a - _b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
127     c = _a + _b;
128     assert(c >= _a);
129     return c;
130   }
131 }
132 
133 // File: openzeppelin-solidity/contracts/AddressUtils.sol
134 
135 /**
136  * Utility library of inline functions on addresses
137  */
138 library AddressUtils {
139 
140   /**
141    * Returns whether the target address is a contract
142    * @dev This function will return false if invoked during the constructor of a contract,
143    * as the code is not actually created until after the constructor finishes.
144    * @param _addr address to check
145    * @return whether the target address is a contract
146    */
147   function isContract(address _addr) internal view returns (bool) {
148     uint256 size;
149     // XXX Currently there is no better way to check if there is a contract in an address
150     // than to check the size of the code at that address.
151     // See https://ethereum.stackexchange.com/a/14016/36603
152     // for more details about how this works.
153     // TODO Check this again before the Serenity release, because all addresses will be
154     // contracts then.
155     // solium-disable-next-line security/no-inline-assembly
156     assembly { size := extcodesize(_addr) }
157     return size > 0;
158   }
159 
160 }
161 
162 // File: contracts/VestingPrivateSale.sol
163 
164 /**
165  * Vesting smart contract for the private sale. Vesting period is 18 months in total.
166  * All 6 months 33% percent of the vested tokens will be released - step function.
167  */
168 contract VestingPrivateSale is Ownable {
169 
170     uint256 constant public sixMonth = 182 days;  
171     uint256 constant public twelveMonth = 365 days;  
172     uint256 constant public eighteenMonth = sixMonth + twelveMonth;
173 
174     ERC20Basic public erc20Contract;
175 
176     struct Locking {
177         uint256 bucket1;
178         uint256 bucket2;
179         uint256 bucket3;
180         uint256 startDate;
181     }
182 
183     mapping(address => Locking) public lockingMap;
184 
185     event ReleaseVestingEvent(address indexed to, uint256 value);
186 
187     /**
188      * @dev Constructor. With the reference to the ERC20 contract
189      */
190     constructor(address _erc20) public {
191         require(AddressUtils.isContract(_erc20), "Address is not a smart contract");
192 
193         erc20Contract = ERC20Basic(_erc20);
194     }
195 
196     /**
197      * @dev Adds vested tokens to this contract. ERC20 contract has assigned the tokens. 
198      * @param _tokenHolder The token holder.
199      * @param _bucket1 The first bucket. Will be available after 6 months.
200      * @param _bucket2 The second bucket. Will be available after 12 months.
201      * @param _bucket3 The third bucket. Will be available after 18 months.
202      * @return True if accepted.
203      */
204     function addVested(
205         address _tokenHolder, 
206         uint256 _bucket1, 
207         uint256 _bucket2, 
208         uint256 _bucket3
209     ) 
210         public 
211         returns (bool) 
212     {
213         require(msg.sender == address(erc20Contract), "ERC20 contract required");
214         require(lockingMap[_tokenHolder].startDate == 0, "Address is already vested");
215 
216         lockingMap[_tokenHolder].startDate = block.timestamp;
217         lockingMap[_tokenHolder].bucket1 = _bucket1;
218         lockingMap[_tokenHolder].bucket2 = _bucket2;
219         lockingMap[_tokenHolder].bucket3 = _bucket3;
220 
221         return true;
222     }
223 
224     /**
225      * @dev Calculates the amount of the total assigned tokens of a tokenholder.
226      * @param _tokenHolder The address to query the balance of.
227      * @return The total amount of owned tokens (vested + available). 
228      */
229     function balanceOf(
230         address _tokenHolder
231     ) 
232         public 
233         view 
234         returns (uint256) 
235     {
236         return lockingMap[_tokenHolder].bucket1 + lockingMap[_tokenHolder].bucket2 + lockingMap[_tokenHolder].bucket3;
237     }
238 
239     /**
240      * @dev Calculates the amount of currently available (unlocked) tokens. This amount can be unlocked. 
241      * @param _tokenHolder The address to query the balance of.
242      * @return The total amount of owned and available tokens.
243      */
244     function availableBalanceOf(
245         address _tokenHolder
246     ) 
247         public 
248         view 
249         returns (uint256) 
250     {
251         uint256 startDate = lockingMap[_tokenHolder].startDate;
252         uint256 tokens = 0;
253         
254         if (startDate + sixMonth <= block.timestamp) {
255             tokens = lockingMap[_tokenHolder].bucket1;
256         }
257 
258         if (startDate + twelveMonth <= block.timestamp) {
259             tokens = tokens + lockingMap[_tokenHolder].bucket2;
260         }
261 
262         if (startDate + eighteenMonth <= block.timestamp) {
263             tokens = tokens + lockingMap[_tokenHolder].bucket3;
264         }
265 
266         return tokens;
267     }
268 
269     /**
270      * @dev Releases unlocked tokens of the transaction sender. 
271      * @dev This function will transfer unlocked tokens to the owner.
272      * @return The total amount of released tokens.
273      */
274     function releaseBuckets() 
275         public 
276         returns (uint256) 
277     {
278         return _releaseBuckets(msg.sender);
279     }
280 
281     /**
282      * @dev Admin function.
283      * @dev Releases unlocked tokens of the _tokenHolder. 
284      * @dev This function will transfer unlocked tokens to the _tokenHolder.
285      * @param _tokenHolder Address of the token owner to release tokens.
286      * @return The total amount of released tokens.
287      */
288     function releaseBuckets(
289         address _tokenHolder
290     ) 
291         public 
292         onlyOwner
293         returns (uint256) 
294     {
295         return _releaseBuckets(_tokenHolder);
296     }
297 
298     function _releaseBuckets(
299         address _tokenHolder
300     ) 
301         private 
302         returns (uint256) 
303     {
304         require(lockingMap[_tokenHolder].startDate != 0, "Is not a locked address");
305         uint256 startDate = lockingMap[_tokenHolder].startDate;
306         uint256 tokens = 0;
307         
308         if (startDate + sixMonth <= block.timestamp) {
309             tokens = lockingMap[_tokenHolder].bucket1;
310             lockingMap[_tokenHolder].bucket1 = 0;
311         }
312 
313         if (startDate + twelveMonth <= block.timestamp) {
314             tokens = tokens + lockingMap[_tokenHolder].bucket2;
315             lockingMap[_tokenHolder].bucket2 = 0;
316         }
317 
318         if (startDate + eighteenMonth <= block.timestamp) {
319             tokens = tokens + lockingMap[_tokenHolder].bucket3;
320             lockingMap[_tokenHolder].bucket3 = 0;
321         }
322         
323         require(erc20Contract.transfer(_tokenHolder, tokens), "Transfer failed");
324         emit ReleaseVestingEvent(_tokenHolder, tokens);
325 
326         return tokens;
327     }
328 }
329 
330 // File: contracts/VestingTreasury.sol
331 
332 /**
333  * Treasury vesting smart contract. Vesting period is over 36 months.
334  * Tokens are locked for 6 months. After that releasing the tokens over 30 months with a linear function.
335  */
336 contract VestingTreasury {
337 
338     using SafeMath for uint256;
339 
340     uint256 constant public sixMonths = 182 days;  
341     uint256 constant public thirtyMonths = 912 days;  
342 
343     ERC20Basic public erc20Contract;
344 
345     struct Locking {
346         uint256 startDate;      // date when the release process of the vesting will start. 
347         uint256 initialized;    // initialized amount of tokens
348         uint256 released;       // already released tokens
349     }
350 
351     mapping(address => Locking) public lockingMap;
352 
353     event ReleaseVestingEvent(address indexed to, uint256 value);
354 
355     /**
356     * @dev Constructor. With the reference to the ERC20 contract
357     */
358     constructor(address _erc20) public {
359         require(AddressUtils.isContract(_erc20), "Address is not a smart contract");
360 
361         erc20Contract = ERC20Basic(_erc20);
362     }
363 
364     /**
365      * @dev Adds vested tokens to this contract. ERC20 contract has assigned the tokens. 
366      * @param _tokenHolder The token holder.
367      * @param _value The amount of tokens to protect.
368      * @return True if accepted.
369      */
370     function addVested(
371         address _tokenHolder, 
372         uint256 _value
373     ) 
374         public 
375         returns (bool) 
376     {
377         require(msg.sender == address(erc20Contract), "ERC20 contract required");
378         require(lockingMap[_tokenHolder].startDate == 0, "Address is already vested");
379 
380         lockingMap[_tokenHolder].startDate = block.timestamp + sixMonths;
381         lockingMap[_tokenHolder].initialized = _value;
382         lockingMap[_tokenHolder].released = 0;
383 
384         return true;
385     }
386 
387     /**
388      * @dev Calculates the amount of the total currently vested and available tokens.
389      * @param _tokenHolder The address to query the balance of.
390      * @return The total amount of owned tokens (vested + available). 
391      */
392     function balanceOf(
393         address _tokenHolder
394     ) 
395         public 
396         view 
397         returns (uint256) 
398     {
399         return lockingMap[_tokenHolder].initialized.sub(lockingMap[_tokenHolder].released);
400     }
401 
402     /**
403      * @dev Calculates the amount of currently available (unlocked) tokens. This amount can be unlocked. 
404      * @param _tokenHolder The address to query the balance of.
405      * @return The total amount of owned and available tokens.
406      */
407     function availableBalanceOf(
408         address _tokenHolder
409     ) 
410         public 
411         view 
412         returns (uint256) 
413     {
414         uint256 startDate = lockingMap[_tokenHolder].startDate;
415         
416         if (block.timestamp <= startDate) {
417             return 0;
418         }
419 
420         uint256 tmpAvailableTokens = 0;
421         if (block.timestamp >= startDate + thirtyMonths) {
422             tmpAvailableTokens = lockingMap[_tokenHolder].initialized;
423         } else {
424             uint256 timeDiff = block.timestamp - startDate;
425             uint256 totalBalance = lockingMap[_tokenHolder].initialized;
426 
427             tmpAvailableTokens = totalBalance.mul(timeDiff).div(thirtyMonths);
428         }
429 
430         uint256 availableTokens = tmpAvailableTokens.sub(lockingMap[_tokenHolder].released);
431         require(availableTokens <= lockingMap[_tokenHolder].initialized, "Max value exceeded");
432 
433         return availableTokens;
434     }
435 
436     /**
437      * @dev Releases unlocked tokens of the transaction sender. 
438      * @dev This function will transfer unlocked tokens to the owner.
439      * @return The total amount of released tokens.
440      */
441     function releaseTokens() 
442         public 
443         returns (uint256) 
444     {
445         require(lockingMap[msg.sender].startDate != 0, "Sender is not a vested address");
446 
447         uint256 tokens = availableBalanceOf(msg.sender);
448 
449         lockingMap[msg.sender].released = lockingMap[msg.sender].released.add(tokens);
450         require(lockingMap[msg.sender].released <= lockingMap[msg.sender].initialized, "Max value exceeded");
451 
452         require(erc20Contract.transfer(msg.sender, tokens), "Transfer failed");
453         emit ReleaseVestingEvent(msg.sender, tokens);
454 
455         return tokens;
456     }
457 }
458 
459 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
460 
461 /**
462  * @title Basic token
463  * @dev Basic version of StandardToken, with no allowances.
464  */
465 contract BasicToken is ERC20Basic {
466   using SafeMath for uint256;
467 
468   mapping(address => uint256) internal balances;
469 
470   uint256 internal totalSupply_;
471 
472   /**
473   * @dev Total number of tokens in existence
474   */
475   function totalSupply() public view returns (uint256) {
476     return totalSupply_;
477   }
478 
479   /**
480   * @dev Transfer token for a specified address
481   * @param _to The address to transfer to.
482   * @param _value The amount to be transferred.
483   */
484   function transfer(address _to, uint256 _value) public returns (bool) {
485     require(_value <= balances[msg.sender]);
486     require(_to != address(0));
487 
488     balances[msg.sender] = balances[msg.sender].sub(_value);
489     balances[_to] = balances[_to].add(_value);
490     emit Transfer(msg.sender, _to, _value);
491     return true;
492   }
493 
494   /**
495   * @dev Gets the balance of the specified address.
496   * @param _owner The address to query the the balance of.
497   * @return An uint256 representing the amount owned by the passed address.
498   */
499   function balanceOf(address _owner) public view returns (uint256) {
500     return balances[_owner];
501   }
502 
503 }
504 
505 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
506 
507 /**
508  * @title ERC20 interface
509  * @dev see https://github.com/ethereum/EIPs/issues/20
510  */
511 contract ERC20 is ERC20Basic {
512   function allowance(address _owner, address _spender)
513     public view returns (uint256);
514 
515   function transferFrom(address _from, address _to, uint256 _value)
516     public returns (bool);
517 
518   function approve(address _spender, uint256 _value) public returns (bool);
519   event Approval(
520     address indexed owner,
521     address indexed spender,
522     uint256 value
523   );
524 }
525 
526 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
527 
528 /**
529  * @title Standard ERC20 token
530  *
531  * @dev Implementation of the basic standard token.
532  * https://github.com/ethereum/EIPs/issues/20
533  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
534  */
535 contract StandardToken is ERC20, BasicToken {
536 
537   mapping (address => mapping (address => uint256)) internal allowed;
538 
539 
540   /**
541    * @dev Transfer tokens from one address to another
542    * @param _from address The address which you want to send tokens from
543    * @param _to address The address which you want to transfer to
544    * @param _value uint256 the amount of tokens to be transferred
545    */
546   function transferFrom(
547     address _from,
548     address _to,
549     uint256 _value
550   )
551     public
552     returns (bool)
553   {
554     require(_value <= balances[_from]);
555     require(_value <= allowed[_from][msg.sender]);
556     require(_to != address(0));
557 
558     balances[_from] = balances[_from].sub(_value);
559     balances[_to] = balances[_to].add(_value);
560     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
561     emit Transfer(_from, _to, _value);
562     return true;
563   }
564 
565   /**
566    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
567    * Beware that changing an allowance with this method brings the risk that someone may use both the old
568    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
569    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
570    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
571    * @param _spender The address which will spend the funds.
572    * @param _value The amount of tokens to be spent.
573    */
574   function approve(address _spender, uint256 _value) public returns (bool) {
575     allowed[msg.sender][_spender] = _value;
576     emit Approval(msg.sender, _spender, _value);
577     return true;
578   }
579 
580   /**
581    * @dev Function to check the amount of tokens that an owner allowed to a spender.
582    * @param _owner address The address which owns the funds.
583    * @param _spender address The address which will spend the funds.
584    * @return A uint256 specifying the amount of tokens still available for the spender.
585    */
586   function allowance(
587     address _owner,
588     address _spender
589    )
590     public
591     view
592     returns (uint256)
593   {
594     return allowed[_owner][_spender];
595   }
596 
597   /**
598    * @dev Increase the amount of tokens that an owner allowed to a spender.
599    * approve should be called when allowed[_spender] == 0. To increment
600    * allowed value is better to use this function to avoid 2 calls (and wait until
601    * the first transaction is mined)
602    * From MonolithDAO Token.sol
603    * @param _spender The address which will spend the funds.
604    * @param _addedValue The amount of tokens to increase the allowance by.
605    */
606   function increaseApproval(
607     address _spender,
608     uint256 _addedValue
609   )
610     public
611     returns (bool)
612   {
613     allowed[msg.sender][_spender] = (
614       allowed[msg.sender][_spender].add(_addedValue));
615     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
616     return true;
617   }
618 
619   /**
620    * @dev Decrease the amount of tokens that an owner allowed to a spender.
621    * approve should be called when allowed[_spender] == 0. To decrement
622    * allowed value is better to use this function to avoid 2 calls (and wait until
623    * the first transaction is mined)
624    * From MonolithDAO Token.sol
625    * @param _spender The address which will spend the funds.
626    * @param _subtractedValue The amount of tokens to decrease the allowance by.
627    */
628   function decreaseApproval(
629     address _spender,
630     uint256 _subtractedValue
631   )
632     public
633     returns (bool)
634   {
635     uint256 oldValue = allowed[msg.sender][_spender];
636     if (_subtractedValue >= oldValue) {
637       allowed[msg.sender][_spender] = 0;
638     } else {
639       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
640     }
641     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
642     return true;
643   }
644 
645 }
646 
647 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
648 
649 /**
650  * @title Mintable token
651  * @dev Simple ERC20 Token example, with mintable token creation
652  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
653  */
654 contract MintableToken is StandardToken, Ownable {
655   event Mint(address indexed to, uint256 amount);
656   event MintFinished();
657 
658   bool public mintingFinished = false;
659 
660 
661   modifier canMint() {
662     require(!mintingFinished);
663     _;
664   }
665 
666   modifier hasMintPermission() {
667     require(msg.sender == owner);
668     _;
669   }
670 
671   /**
672    * @dev Function to mint tokens
673    * @param _to The address that will receive the minted tokens.
674    * @param _amount The amount of tokens to mint.
675    * @return A boolean that indicates if the operation was successful.
676    */
677   function mint(
678     address _to,
679     uint256 _amount
680   )
681     public
682     hasMintPermission
683     canMint
684     returns (bool)
685   {
686     totalSupply_ = totalSupply_.add(_amount);
687     balances[_to] = balances[_to].add(_amount);
688     emit Mint(_to, _amount);
689     emit Transfer(address(0), _to, _amount);
690     return true;
691   }
692 
693   /**
694    * @dev Function to stop minting new tokens.
695    * @return True if the operation was successful.
696    */
697   function finishMinting() public onlyOwner canMint returns (bool) {
698     mintingFinished = true;
699     emit MintFinished();
700     return true;
701   }
702 }
703 
704 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
705 
706 /**
707  * @title Capped token
708  * @dev Mintable token with a token cap.
709  */
710 contract CappedToken is MintableToken {
711 
712   uint256 public cap;
713 
714   constructor(uint256 _cap) public {
715     require(_cap > 0);
716     cap = _cap;
717   }
718 
719   /**
720    * @dev Function to mint tokens
721    * @param _to The address that will receive the minted tokens.
722    * @param _amount The amount of tokens to mint.
723    * @return A boolean that indicates if the operation was successful.
724    */
725   function mint(
726     address _to,
727     uint256 _amount
728   )
729     public
730     returns (bool)
731   {
732     require(totalSupply_.add(_amount) <= cap);
733 
734     return super.mint(_to, _amount);
735   }
736 
737 }
738 
739 // File: contracts/LockedToken.sol
740 
741 contract LockedToken is CappedToken {
742     bool public transferActivated = false;
743 
744     event TransferActivatedEvent();
745 
746     constructor(uint256 _cap) public CappedToken(_cap) {
747     }
748 
749     /**
750      * @dev Admin function.
751      * @dev Activates the token transfer. This action cannot be undone. 
752      * @dev This function should be called after the ICO. 
753      * @return True if ok. 
754      */
755     function activateTransfer() 
756         public 
757         onlyOwner
758         returns (bool) 
759     {
760         require(transferActivated == false, "Already activated");
761 
762         transferActivated = true;
763 
764         emit TransferActivatedEvent();
765         return true;
766     }
767 
768     /**
769      * @dev Transfer token for a specified address.
770      * @param _to The address to transfer to.
771      * @param _value The amount to be transferred.
772      */
773     function transfer(
774         address _to, 
775         uint256 _value
776     ) 
777         public 
778         returns (bool) 
779     {
780         require(transferActivated, "Transfer is not activated");
781         require(_to != address(this), "Invalid _to address");
782 
783         return super.transfer(_to, _value);
784     }
785 
786     /**
787      * @dev Transfer tokens from one address to another.
788      * @param _from The address which you want to send tokens from.
789      * @param _to The address which you want to transfer to.
790      * @param _value The amount of tokens to be transferred.
791      */
792     function transferFrom(
793         address _from, 
794         address _to, 
795         uint256 _value
796     ) 
797         public 
798         returns (bool) 
799     {
800         require(transferActivated, "TransferFrom is not activated");
801         require(_to != address(this), "Invalid _to address");
802 
803         return super.transferFrom(_from, _to, _value);
804     }
805 }
806 
807 // File: contracts/AlprockzToken.sol
808 
809 /**
810  * @title The Alprockz ERC20 Token
811  */
812 contract AlprockzToken is LockedToken {
813     
814     string public constant name = "AlpRockz";
815     string public constant symbol = "APZ";
816     uint8 public constant decimals = 18;
817     VestingPrivateSale public vestingPrivateSale;
818     VestingTreasury public vestingTreasury;
819 
820     constructor() public LockedToken(175 * 1000000 * (10 ** uint256(decimals))) {
821     }
822 
823     /**
824      * @dev Admin function.
825      * @dev Inits the VestingPrivateSale functionality. 
826      * @dev Precondition: VestingPrivateSale smart contract must be deployed!
827      * @param _vestingContractAddr The address of the vesting contract for the function 'mintPrivateSale(...)'.
828      * @return True if everything is ok.
829      */
830     function initMintVestingPrivateSale(
831         address _vestingContractAddr
832     ) 
833         external
834         onlyOwner
835         returns (bool) 
836     {
837         require(address(vestingPrivateSale) == address(0x0), "Already initialized");
838         require(address(this) != _vestingContractAddr, "Invalid address");
839         require(AddressUtils.isContract(_vestingContractAddr), "Address is not a smart contract");
840         
841         vestingPrivateSale = VestingPrivateSale(_vestingContractAddr);
842         require(address(this) == address(vestingPrivateSale.erc20Contract()), "Vesting link address not match");
843         
844         return true;
845     }
846 
847     /**
848      * @dev Admin function.
849      * @dev Inits the VestingTreasury functionality. 
850      * @dev Precondition: VestingTreasury smart contract must be deployed!
851      * @param _vestingContractAddr The address of the vesting contract for the function 'mintTreasury(...)'.
852      * @return True if everything is ok.
853      */
854     function initMintVestingTreasury(
855         address _vestingContractAddr
856     ) 
857         external
858         onlyOwner
859         returns (bool) 
860     {
861         require(address(vestingTreasury) == address(0x0), "Already initialized");
862         require(address(this) != _vestingContractAddr, "Invalid address");
863         require(AddressUtils.isContract(_vestingContractAddr), "Address is not a smart contract");
864         
865         vestingTreasury = VestingTreasury(_vestingContractAddr);
866         require(address(this) == address(vestingTreasury.erc20Contract()), "Vesting link address not match");
867         
868         return true;
869     }
870 
871     /**
872      * @dev Admin function.
873      * @dev Bulk mint function to save gas. 
874      * @dev both arrays requires to have the same length.
875      * @param _recipients List of recipients.
876      * @param _tokens List of tokens to assign to the recipients.
877      */
878     function mintArray(
879         address[] _recipients, 
880         uint256[] _tokens
881     ) 
882         external
883         onlyOwner 
884         returns (bool) 
885     {
886         require(_recipients.length == _tokens.length, "Array length not match");
887         require(_recipients.length <= 40, "Too many recipients");
888 
889         for (uint256 i = 0; i < _recipients.length; i++) {
890             require(super.mint(_recipients[i], _tokens[i]), "Mint failed");
891         }
892 
893         return true;
894     }
895 
896     /**
897      * @dev Admin function.
898      * @dev Bulk mintPrivateSale function to save gas. 
899      * @dev both arrays are required to have the same length.
900      * @dev Vesting: 25% directly available, 25% after 6, 25% after 12 and 25% after 18 months. 
901      * @param _recipients List of recipients.
902      * @param _tokens List of tokens to assign to the recipients.
903      */
904     function mintPrivateSale(
905         address[] _recipients, 
906         uint256[] _tokens
907     ) 
908         external 
909         onlyOwner
910         returns (bool) 
911     {
912         require(address(vestingPrivateSale) != address(0x0), "Init required");
913         require(_recipients.length == _tokens.length, "Array length not match");
914         require(_recipients.length <= 10, "Too many recipients");
915 
916 
917         for (uint256 i = 0; i < _recipients.length; i++) {
918 
919             address recipient = _recipients[i];
920             uint256 token = _tokens[i];
921 
922             uint256 first;
923             uint256 second; 
924             uint256 third; 
925             uint256 fourth;
926             (first, second, third, fourth) = splitToFour(token);
927 
928             require(super.mint(recipient, first), "Mint failed");
929 
930             uint256 totalVested = second + third + fourth;
931             require(super.mint(address(vestingPrivateSale), totalVested), "Mint failed");
932             require(vestingPrivateSale.addVested(recipient, second, third, fourth), "Vesting failed");
933         }
934 
935         return true;
936     }
937 
938     /**
939      * @dev Admin function.
940      * @dev Bulk mintTreasury function to save gas. 
941      * @dev both arrays are required to have the same length.
942      * @dev Vesting: Tokens are locked for 6 months. After that the tokens are released in a linear way.
943      * @param _recipients List of recipients.
944      * @param _tokens List of tokens to assign to the recipients.
945      */
946     function mintTreasury(
947         address[] _recipients, 
948         uint256[] _tokens
949     ) 
950         external 
951         onlyOwner
952         returns (bool) 
953     {
954         require(address(vestingTreasury) != address(0x0), "Init required");
955         require(_recipients.length == _tokens.length, "Array length not match");
956         require(_recipients.length <= 10, "Too many recipients");
957 
958         for (uint256 i = 0; i < _recipients.length; i++) {
959 
960             address recipient = _recipients[i];
961             uint256 token = _tokens[i];
962 
963             require(super.mint(address(vestingTreasury), token), "Mint failed");
964             require(vestingTreasury.addVested(recipient, token), "Vesting failed");
965         }
966 
967         return true;
968     }
969 
970     function splitToFour(
971         uint256 _amount
972     ) 
973         private 
974         pure 
975         returns (
976             uint256 first, 
977             uint256 second, 
978             uint256 third, 
979             uint256 fourth
980         ) 
981     {
982         require(_amount >= 4, "Minimum amount");
983 
984         uint256 rest = _amount % 4;
985 
986         uint256 quarter = (_amount - rest) / 4;
987 
988         first = quarter + rest;
989         second = quarter;
990         third = quarter;
991         fourth = quarter;
992     }
993 }