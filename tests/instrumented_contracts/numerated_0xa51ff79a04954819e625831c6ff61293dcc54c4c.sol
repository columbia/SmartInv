1 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 pragma solidity ^0.4.23;
3 
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
64 //File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
65 pragma solidity ^0.4.23;
66 
67 
68 
69 
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is not paused.
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is paused.
92    */
93   modifier whenPaused() {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() onlyOwner whenNotPaused public {
102     paused = true;
103     emit Pause();
104   }
105 
106   /**
107    * @dev called by the owner to unpause, returns to normal state
108    */
109   function unpause() onlyOwner whenPaused public {
110     paused = false;
111     emit Unpause();
112   }
113 }
114 
115 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
116 pragma solidity ^0.4.23;
117 
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   function totalSupply() public view returns (uint256);
126   function balanceOf(address who) public view returns (uint256);
127   function transfer(address to, uint256 value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
132 pragma solidity ^0.4.23;
133 
134 
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender)
143     public view returns (uint256);
144 
145   function transferFrom(address from, address to, uint256 value)
146     public returns (bool);
147 
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(
150     address indexed owner,
151     address indexed spender,
152     uint256 value
153   );
154 }
155 
156 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
157 pragma solidity ^0.4.23;
158 
159 
160 
161 
162 
163 /**
164  * @title SafeERC20
165  * @dev Wrappers around ERC20 operations that throw on failure.
166  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
167  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
168  */
169 library SafeERC20 {
170   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
171     require(token.transfer(to, value));
172   }
173 
174   function safeTransferFrom(
175     ERC20 token,
176     address from,
177     address to,
178     uint256 value
179   )
180     internal
181   {
182     require(token.transferFrom(from, to, value));
183   }
184 
185   function safeApprove(ERC20 token, address spender, uint256 value) internal {
186     require(token.approve(spender, value));
187   }
188 }
189 
190 //File: node_modules\openzeppelin-solidity\contracts\ownership\CanReclaimToken.sol
191 pragma solidity ^0.4.23;
192 
193 
194 
195 
196 
197 
198 /**
199  * @title Contracts that should be able to recover tokens
200  * @author SylTi
201  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
202  * This will prevent any accidental loss of tokens.
203  */
204 contract CanReclaimToken is Ownable {
205   using SafeERC20 for ERC20Basic;
206 
207   /**
208    * @dev Reclaim all ERC20Basic compatible tokens
209    * @param token ERC20Basic The address of the token contract
210    */
211   function reclaimToken(ERC20Basic token) external onlyOwner {
212     uint256 balance = token.balanceOf(this);
213     token.safeTransfer(owner, balance);
214   }
215 
216 }
217 
218 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
219 pragma solidity ^0.4.23;
220 
221 
222 /**
223  * @title SafeMath
224  * @dev Math operations with safety checks that throw on error
225  */
226 library SafeMath {
227 
228   /**
229   * @dev Multiplies two numbers, throws on overflow.
230   */
231   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
232     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
233     // benefit is lost if 'b' is also tested.
234     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
235     if (a == 0) {
236       return 0;
237     }
238 
239     c = a * b;
240     assert(c / a == b);
241     return c;
242   }
243 
244   /**
245   * @dev Integer division of two numbers, truncating the quotient.
246   */
247   function div(uint256 a, uint256 b) internal pure returns (uint256) {
248     // assert(b > 0); // Solidity automatically throws when dividing by 0
249     // uint256 c = a / b;
250     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251     return a / b;
252   }
253 
254   /**
255   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
256   */
257   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258     assert(b <= a);
259     return a - b;
260   }
261 
262   /**
263   * @dev Adds two numbers, throws on overflow.
264   */
265   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
266     c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }
271 
272 //File: contracts\ico\KYCBase.sol
273 pragma solidity ^0.4.24;
274 
275 
276 
277 // Abstract base contract
278 contract KYCBase {
279     using SafeMath for uint256;
280 
281     mapping (address => bool) public isKycSigner;
282     mapping (uint64 => uint256) public alreadyPayed;
283 
284     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
285 
286     constructor(address[] kycSigners) internal {
287         for (uint i = 0; i < kycSigners.length; i++) {
288             isKycSigner[kycSigners[i]] = true;
289         }
290     }
291 
292     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
293     function releaseTokensTo(address buyer) internal returns(bool);
294 
295     // This method can be overridden to enable some sender to buy token for a different address
296     function senderAllowedFor(address buyer)
297     internal view returns(bool)
298     {
299         return buyer == msg.sender;
300     }
301 
302     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
303     public payable returns (bool)
304     {
305         require(senderAllowedFor(buyerAddress));
306         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
307     }
308 
309     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
310     public payable returns (bool)
311     {
312         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
313     }
314 
315     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
316     private returns (bool)
317     {
318         // check the signature
319         bytes32 hash = sha256(abi.encodePacked("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount));
320         address signer = ecrecover(hash, v, r, s);
321         if (!isKycSigner[signer]) {
322             revert();
323         } else {
324             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
325             require(totalPayed <= maxAmount);
326             alreadyPayed[buyerId] = totalPayed;
327             emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
328             return releaseTokensTo(buyerAddress);
329         }
330     }
331 
332     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
333     function () public {
334         revert();
335     }
336 }
337 //File: contracts\ico\ICOEngineInterface.sol
338 pragma solidity ^0.4.24;
339 
340 
341 contract ICOEngineInterface {
342 
343     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
344     function started() public view returns(bool);
345 
346     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
347     function ended() public view returns(bool);
348 
349     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
350     function startTime() public view returns(uint);
351 
352     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
353     function endTime() public view returns(uint);
354 
355     // Optional function, can be implemented in place of startTime
356     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
357     // function startBlock() public view returns(uint);
358 
359     // Optional function, can be implemented in place of endTime
360     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
361     // function endBlock() public view returns(uint);
362 
363     // returns the total number of the tokens available for the sale, must not change when the ico is started
364     function totalTokens() public view returns(uint);
365 
366     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
367     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
368     function remainingTokens() public view returns(uint);
369 
370     // return the price as number of tokens released for each ether
371     function price() public view returns(uint);
372 }
373 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
374 pragma solidity ^0.4.23;
375 
376 
377 
378 
379 
380 
381 /**
382  * @title Basic token
383  * @dev Basic version of StandardToken, with no allowances.
384  */
385 contract BasicToken is ERC20Basic {
386   using SafeMath for uint256;
387 
388   mapping(address => uint256) balances;
389 
390   uint256 totalSupply_;
391 
392   /**
393   * @dev total number of tokens in existence
394   */
395   function totalSupply() public view returns (uint256) {
396     return totalSupply_;
397   }
398 
399   /**
400   * @dev transfer token for a specified address
401   * @param _to The address to transfer to.
402   * @param _value The amount to be transferred.
403   */
404   function transfer(address _to, uint256 _value) public returns (bool) {
405     require(_to != address(0));
406     require(_value <= balances[msg.sender]);
407 
408     balances[msg.sender] = balances[msg.sender].sub(_value);
409     balances[_to] = balances[_to].add(_value);
410     emit Transfer(msg.sender, _to, _value);
411     return true;
412   }
413 
414   /**
415   * @dev Gets the balance of the specified address.
416   * @param _owner The address to query the the balance of.
417   * @return An uint256 representing the amount owned by the passed address.
418   */
419   function balanceOf(address _owner) public view returns (uint256) {
420     return balances[_owner];
421   }
422 
423 }
424 
425 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
426 pragma solidity ^0.4.23;
427 
428 
429 
430 
431 
432 /**
433  * @title Standard ERC20 token
434  *
435  * @dev Implementation of the basic standard token.
436  * @dev https://github.com/ethereum/EIPs/issues/20
437  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
438  */
439 contract StandardToken is ERC20, BasicToken {
440 
441   mapping (address => mapping (address => uint256)) internal allowed;
442 
443 
444   /**
445    * @dev Transfer tokens from one address to another
446    * @param _from address The address which you want to send tokens from
447    * @param _to address The address which you want to transfer to
448    * @param _value uint256 the amount of tokens to be transferred
449    */
450   function transferFrom(
451     address _from,
452     address _to,
453     uint256 _value
454   )
455     public
456     returns (bool)
457   {
458     require(_to != address(0));
459     require(_value <= balances[_from]);
460     require(_value <= allowed[_from][msg.sender]);
461 
462     balances[_from] = balances[_from].sub(_value);
463     balances[_to] = balances[_to].add(_value);
464     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
465     emit Transfer(_from, _to, _value);
466     return true;
467   }
468 
469   /**
470    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
471    *
472    * Beware that changing an allowance with this method brings the risk that someone may use both the old
473    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
474    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
475    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
476    * @param _spender The address which will spend the funds.
477    * @param _value The amount of tokens to be spent.
478    */
479   function approve(address _spender, uint256 _value) public returns (bool) {
480     allowed[msg.sender][_spender] = _value;
481     emit Approval(msg.sender, _spender, _value);
482     return true;
483   }
484 
485   /**
486    * @dev Function to check the amount of tokens that an owner allowed to a spender.
487    * @param _owner address The address which owns the funds.
488    * @param _spender address The address which will spend the funds.
489    * @return A uint256 specifying the amount of tokens still available for the spender.
490    */
491   function allowance(
492     address _owner,
493     address _spender
494    )
495     public
496     view
497     returns (uint256)
498   {
499     return allowed[_owner][_spender];
500   }
501 
502   /**
503    * @dev Increase the amount of tokens that an owner allowed to a spender.
504    *
505    * approve should be called when allowed[_spender] == 0. To increment
506    * allowed value is better to use this function to avoid 2 calls (and wait until
507    * the first transaction is mined)
508    * From MonolithDAO Token.sol
509    * @param _spender The address which will spend the funds.
510    * @param _addedValue The amount of tokens to increase the allowance by.
511    */
512   function increaseApproval(
513     address _spender,
514     uint _addedValue
515   )
516     public
517     returns (bool)
518   {
519     allowed[msg.sender][_spender] = (
520       allowed[msg.sender][_spender].add(_addedValue));
521     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
522     return true;
523   }
524 
525   /**
526    * @dev Decrease the amount of tokens that an owner allowed to a spender.
527    *
528    * approve should be called when allowed[_spender] == 0. To decrement
529    * allowed value is better to use this function to avoid 2 calls (and wait until
530    * the first transaction is mined)
531    * From MonolithDAO Token.sol
532    * @param _spender The address which will spend the funds.
533    * @param _subtractedValue The amount of tokens to decrease the allowance by.
534    */
535   function decreaseApproval(
536     address _spender,
537     uint _subtractedValue
538   )
539     public
540     returns (bool)
541   {
542     uint oldValue = allowed[msg.sender][_spender];
543     if (_subtractedValue > oldValue) {
544       allowed[msg.sender][_spender] = 0;
545     } else {
546       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
547     }
548     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
549     return true;
550   }
551 
552 }
553 
554 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
555 pragma solidity ^0.4.23;
556 
557 
558 
559 
560 
561 /**
562  * @title Mintable token
563  * @dev Simple ERC20 Token example, with mintable token creation
564  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
565  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
566  */
567 contract MintableToken is StandardToken, Ownable {
568   event Mint(address indexed to, uint256 amount);
569   event MintFinished();
570 
571   bool public mintingFinished = false;
572 
573 
574   modifier canMint() {
575     require(!mintingFinished);
576     _;
577   }
578 
579   modifier hasMintPermission() {
580     require(msg.sender == owner);
581     _;
582   }
583 
584   /**
585    * @dev Function to mint tokens
586    * @param _to The address that will receive the minted tokens.
587    * @param _amount The amount of tokens to mint.
588    * @return A boolean that indicates if the operation was successful.
589    */
590   function mint(
591     address _to,
592     uint256 _amount
593   )
594     hasMintPermission
595     canMint
596     public
597     returns (bool)
598   {
599     totalSupply_ = totalSupply_.add(_amount);
600     balances[_to] = balances[_to].add(_amount);
601     emit Mint(_to, _amount);
602     emit Transfer(address(0), _to, _amount);
603     return true;
604   }
605 
606   /**
607    * @dev Function to stop minting new tokens.
608    * @return True if the operation was successful.
609    */
610   function finishMinting() onlyOwner canMint public returns (bool) {
611     mintingFinished = true;
612     emit MintFinished();
613     return true;
614   }
615 }
616 
617 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\PausableToken.sol
618 pragma solidity ^0.4.23;
619 
620 
621 
622 
623 
624 /**
625  * @title Pausable token
626  * @dev StandardToken modified with pausable transfers.
627  **/
628 contract PausableToken is StandardToken, Pausable {
629 
630   function transfer(
631     address _to,
632     uint256 _value
633   )
634     public
635     whenNotPaused
636     returns (bool)
637   {
638     return super.transfer(_to, _value);
639   }
640 
641   function transferFrom(
642     address _from,
643     address _to,
644     uint256 _value
645   )
646     public
647     whenNotPaused
648     returns (bool)
649   {
650     return super.transferFrom(_from, _to, _value);
651   }
652 
653   function approve(
654     address _spender,
655     uint256 _value
656   )
657     public
658     whenNotPaused
659     returns (bool)
660   {
661     return super.approve(_spender, _value);
662   }
663 
664   function increaseApproval(
665     address _spender,
666     uint _addedValue
667   )
668     public
669     whenNotPaused
670     returns (bool success)
671   {
672     return super.increaseApproval(_spender, _addedValue);
673   }
674 
675   function decreaseApproval(
676     address _spender,
677     uint _subtractedValue
678   )
679     public
680     whenNotPaused
681     returns (bool success)
682   {
683     return super.decreaseApproval(_spender, _subtractedValue);
684   }
685 }
686 
687 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
688 pragma solidity ^0.4.23;
689 
690 
691 
692 
693 /**
694  * @title Burnable Token
695  * @dev Token that can be irreversibly burned (destroyed).
696  */
697 contract BurnableToken is BasicToken {
698 
699   event Burn(address indexed burner, uint256 value);
700 
701   /**
702    * @dev Burns a specific amount of tokens.
703    * @param _value The amount of token to be burned.
704    */
705   function burn(uint256 _value) public {
706     _burn(msg.sender, _value);
707   }
708 
709   function _burn(address _who, uint256 _value) internal {
710     require(_value <= balances[_who]);
711     // no need to require value <= totalSupply, since that would imply the
712     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
713 
714     balances[_who] = balances[_who].sub(_value);
715     totalSupply_ = totalSupply_.sub(_value);
716     emit Burn(_who, _value);
717     emit Transfer(_who, address(0), _value);
718   }
719 }
720 
721 //File: contracts\ico\GotToken.sol
722 /**
723  * @title ParkinGO token
724  *
725  * @version 1.0
726  * @author ParkinGO
727  */
728 pragma solidity ^0.4.24;
729 
730 
731 
732 
733 
734 
735 
736 contract GotToken is CanReclaimToken, MintableToken, PausableToken, BurnableToken {
737     string public constant name = "GOToken";
738     string public constant symbol = "GOT";
739     uint8 public constant decimals = 18;
740 
741     /**
742      * @dev Constructor of GotToken that instantiates a new Mintable Pausable Token
743      */
744     constructor() public {
745         // token should not be transferable until after all tokens have been issued
746         paused = true;
747     }
748 }
749 
750 
751 //File: contracts\ico\PGOVault.sol
752 /**
753  * @title PGOVault
754  * @dev A token holder contract that allows the release of tokens to the ParkinGo Wallet.
755  *
756  * @version 1.0
757  * @author ParkinGo
758  */
759 
760 pragma solidity ^0.4.24;
761 
762 
763 
764 
765 
766 
767 
768 contract PGOVault {
769     using SafeMath for uint256;
770     using SafeERC20 for GotToken;
771 
772     uint256[4] public vesting_offsets = [
773         360 days,
774         540 days,
775         720 days,
776         900 days
777     ];
778 
779     uint256[4] public vesting_amounts = [
780         0.875e7 * 1e18,
781         0.875e7 * 1e18,
782         0.875e7 * 1e18,
783         0.875e7 * 1e18
784     ];
785 
786     address public pgoWallet;
787     GotToken public token;
788     uint256 public start;
789     uint256 public released;
790     uint256 public vestingOffsetsLength = vesting_offsets.length;
791 
792     /**
793      * @dev Constructor.
794      * @param _pgoWallet The address that will receive the vested tokens.
795      * @param _token The GOT Token, which is being vested.
796      * @param _start The start time from which each release time will be calculated.
797      */
798     constructor(
799         address _pgoWallet,
800         address _token,
801         uint256 _start
802     )
803         public
804     {
805         pgoWallet = _pgoWallet;
806         token = GotToken(_token);
807         start = _start;
808     }
809 
810     /**
811      * @dev Transfers vested tokens to ParkinGo Wallet.
812      */
813     function release() public {
814         uint256 unreleased = releasableAmount();
815         require(unreleased > 0);
816 
817         released = released.add(unreleased);
818 
819         token.safeTransfer(pgoWallet, unreleased);
820     }
821 
822     /**
823      * @dev Calculates the amount that has already vested but hasn't been released yet.
824      */
825     function releasableAmount() public view returns (uint256) {
826         return vestedAmount().sub(released);
827     }
828 
829     /**
830      * @dev Calculates the amount that has already vested.
831      */
832     function vestedAmount() public view returns (uint256) {
833         uint256 vested = 0;
834         for (uint256 i = 0; i < vestingOffsetsLength; i = i.add(1)) {
835             if (block.timestamp > start.add(vesting_offsets[i])) {
836                 vested = vested.add(vesting_amounts[i]);
837             }
838         }
839         return vested;
840     }
841     
842     /**
843      * @dev Calculates the amount that has not yet released.
844      */
845     function unreleasedAmount() public view returns (uint256) {
846         uint256 unreleased = 0;
847         for (uint256 i = 0; i < vestingOffsetsLength; i = i.add(1)) {
848             unreleased = unreleased.add(vesting_amounts[i]);
849         }
850         return unreleased.sub(released);
851     }
852 }
853 
854 
855 //File: contracts\ico\PGOMonthlyInternalVault.sol
856 /**
857  * @title PGOMonthlyVault
858  * @dev A token holder contract that allows the release of tokens after a vesting period.
859  *
860  * @version 1.0
861  * @author ParkinGO
862  */
863 
864 pragma solidity ^0.4.24;
865 
866 
867 
868 
869 
870 
871 
872 contract PGOMonthlyInternalVault {
873     using SafeMath for uint256;
874     using SafeERC20 for GotToken;
875 
876     struct Investment {
877         address beneficiary;
878         uint256 totalBalance;
879         uint256 released;
880     }
881 
882     /*** CONSTANTS ***/
883     uint256 public constant VESTING_DIV_RATE = 21;                  // division rate of monthly vesting
884     uint256 public constant VESTING_INTERVAL = 30 days;             // vesting interval
885     uint256 public constant VESTING_CLIFF = 90 days;                // duration until cliff is reached
886     uint256 public constant VESTING_DURATION = 720 days;            // vesting duration
887 
888     GotToken public token;
889     uint256 public start;
890     uint256 public end;
891     uint256 public cliff;
892 
893     //Investment[] public investments;
894 
895     // key: investor address; value: index in investments array.
896     //mapping(address => uint256) public investorLUT;
897 
898     mapping(address => Investment) public investments;
899 
900     /**
901      * @dev Function to be fired by the initPGOMonthlyInternalVault function from the GotCrowdSale contract to set the
902      * InternalVault's state after deployment.
903      * @param beneficiaries Array of the internal investors addresses to whom vested tokens are transferred.
904      * @param balances Array of token amount per beneficiary.
905      * @param startTime Start time at which the first released will be executed, and from which the cliff for second
906      * release is calculated.
907      * @param _token The address of the GOT Token.
908      */
909     function init(address[] beneficiaries, uint256[] balances, uint256 startTime, address _token) public {
910         // makes sure this function is only called once
911         require(token == address(0));
912         require(beneficiaries.length == balances.length);
913 
914         start = startTime;
915         cliff = start.add(VESTING_CLIFF);
916         end = start.add(VESTING_DURATION);
917 
918         token = GotToken(_token);
919 
920         for (uint256 i = 0; i < beneficiaries.length; i = i.add(1)) {
921             investments[beneficiaries[i]] = Investment(beneficiaries[i], balances[i], 0);
922         }
923     }
924 
925     /**
926      * @dev Allows a sender to transfer vested tokens to the beneficiary's address.
927      * @param beneficiary The address that will receive the vested tokens.
928      */
929     function release(address beneficiary) public {
930         uint256 unreleased = releasableAmount(beneficiary);
931         require(unreleased > 0);
932 
933         investments[beneficiary].released = investments[beneficiary].released.add(unreleased);
934         token.safeTransfer(beneficiary, unreleased);
935     }
936 
937     /**
938      * @dev Transfers vested tokens to the sender's address.
939      */
940     function release() public {
941         release(msg.sender);
942     }
943 
944     /**
945      * @dev Allows to check an investment.
946      * @param beneficiary The address of the beneficiary of the investment to check.
947      */
948     function getInvestment(address beneficiary) public view returns(address, uint256, uint256) {
949         return (
950             investments[beneficiary].beneficiary,
951             investments[beneficiary].totalBalance,
952             investments[beneficiary].released
953         );
954     }
955 
956     /**
957      * @dev Calculates the amount that has already vested but hasn't been released yet.
958      * @param beneficiary The address that will receive the vested tokens.
959      */
960     function releasableAmount(address beneficiary) public view returns (uint256) {
961         return vestedAmount(beneficiary).sub(investments[beneficiary].released);
962     }
963 
964     /**
965      * @dev Calculates the amount that has already vested.
966      * @param beneficiary The address that will receive the vested tokens.
967      */
968     function vestedAmount(address beneficiary) public view returns (uint256) {
969         uint256 vested = 0;
970         if (block.timestamp >= cliff && block.timestamp < end) {
971             // after cliff -> 1/21 of totalBalance every month, must skip first 3 months
972             uint256 totalBalance = investments[beneficiary].totalBalance;
973             uint256 monthlyBalance = totalBalance.div(VESTING_DIV_RATE);
974             uint256 time = block.timestamp.sub(cliff);
975             uint256 elapsedOffsets = time.div(VESTING_INTERVAL);
976             uint256 vestedToSum = elapsedOffsets.mul(monthlyBalance);
977             vested = vested.add(vestedToSum);
978         }
979         if (block.timestamp >= end) {
980             // after end -> all vested
981             vested = investments[beneficiary].totalBalance;
982         }
983         return vested;
984     }
985 }
986 
987 
988 //File: contracts\ico\PGOMonthlyPresaleVault.sol
989 /**
990  * @title PGOMonthlyVault
991  * @dev A token holder contract that allows the release of tokens after a vesting period.
992  *
993  * @version 1.0
994  * @author ParkinGO
995  */
996 
997 pragma solidity ^0.4.24;
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 contract PGOMonthlyPresaleVault is PGOMonthlyInternalVault {
1007     /**
1008      * @dev OVERRIDE vestedAmount from PGOMonthlyInternalVault
1009      * Calculates the amount that has already vested, release 1/3 of token immediately.
1010      * @param beneficiary The address that will receive the vested tokens.
1011      */
1012     function vestedAmount(address beneficiary) public view returns (uint256) {
1013         uint256 vested = 0;
1014 
1015         if (block.timestamp >= start) {
1016             // after start -> 1/3 released (fixed)
1017             vested = investments[beneficiary].totalBalance.div(3);
1018         }
1019         if (block.timestamp >= cliff && block.timestamp < end) {
1020             // after cliff -> 1/27 of totalBalance every month, must skip first 9 month 
1021             uint256 unlockedStartBalance = investments[beneficiary].totalBalance.div(3);
1022             uint256 totalBalance = investments[beneficiary].totalBalance;
1023             uint256 lockedBalance = totalBalance.sub(unlockedStartBalance);
1024             uint256 monthlyBalance = lockedBalance.div(VESTING_DIV_RATE);
1025             uint256 daysToSkip = 90 days;
1026             uint256 time = block.timestamp.sub(start).sub(daysToSkip);
1027             uint256 elapsedOffsets = time.div(VESTING_INTERVAL);
1028             vested = vested.add(elapsedOffsets.mul(monthlyBalance));
1029         }
1030         if (block.timestamp >= end) {
1031             // after end -> all vested
1032             vested = investments[beneficiary].totalBalance;
1033         }
1034         return vested;
1035     }
1036 }
1037 
1038 
1039 //File: contracts\ico\GotCrowdSale.sol
1040 /**
1041  * @title GotCrowdSale
1042  *
1043  * @version 1.0
1044  * @author ParkinGo
1045  */
1046 pragma solidity ^0.4.24;
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 contract GotCrowdSale is Pausable, CanReclaimToken, ICOEngineInterface, KYCBase {
1060     /*** CONSTANTS ***/
1061     uint256 public constant START_TIME = 1529416800;
1062     //uint256 public constant START_TIME = 1529416800;                     // 19 June 2018 14:00:00 GMT
1063     uint256 public constant END_TIME = 1530655140;                       // 03 July 2018 21:59:00 GMT
1064     //uint256 public constant USD_PER_TOKEN = 75;                          // 0.75$
1065     //uint256 public constant USD_PER_ETHER = 60000;                       // REMEMBER TO CHANGE IT AT ICO START
1066     uint256 public constant TOKEN_PER_ETHER = 740;                       // REMEMBER TO CHANGE IT AT ICO START
1067 
1068     //Token allocation
1069     //Team, founder, partners and advisor cap locked using Monthly Internal Vault
1070     uint256 public constant MONTHLY_INTERNAL_VAULT_CAP = 2.85e7 * 1e18;
1071     //Company unlocked liquidity and Airdrop allocation
1072     uint256 public constant PGO_UNLOCKED_LIQUIDITY_CAP = 1.5e7 * 1e18;
1073     //Internal reserve fund
1074     uint256 public constant PGO_INTERNAL_RESERVE_CAP = 3.5e7 * 1e18;
1075     //Reserved Presale Allocation 33% free and 67% locked using Monthly Presale Vault
1076     uint256 public constant RESERVED_PRESALE_CAP = 1.5754888e7 * 1e18;
1077     //ICO TOKEN ALLOCATION
1078     //Public ICO Cap
1079     //uint256 public constant CROWDSALE_CAP = 0.15e7 * 1e18;
1080     //Reservation contract Cap
1081     uint256 public constant RESERVATION_CAP = 0.4297111e7 * 1e18;
1082     //TOTAL ICO CAP
1083     uint256 public constant TOTAL_ICO_CAP = 0.5745112e7 * 1e18;
1084 
1085     uint256 public start;                                             // ICOEngineInterface
1086     uint256 public end;                                               // ICOEngineInterface
1087     uint256 public cap;                                               // ICOEngineInterface
1088     uint256 public tokenPerEth;
1089     uint256 public availableTokens;                                   // ICOEngineInterface
1090     address[] public kycSigners;                                      // KYCBase
1091     bool public capReached;
1092     uint256 public weiRaised;
1093     uint256 public tokensSold;
1094 
1095     // Vesting contracts.
1096     //Unlock funds after 9 months monthly
1097     PGOMonthlyInternalVault public pgoMonthlyInternalVault;
1098     //Unlock 1/3 funds immediately and remaining after 9 months monthly
1099     PGOMonthlyPresaleVault public pgoMonthlyPresaleVault;
1100     //Unlock funds after 12 months 25% every 6 months
1101     PGOVault public pgoVault;
1102 
1103     // Vesting wallets.
1104     address public pgoInternalReserveWallet;
1105     //Unlocked wallets
1106     address public pgoUnlockedLiquidityWallet;
1107     //ether wallet
1108     address public wallet;
1109 
1110     GotToken public token;
1111 
1112     // Lets owner manually end crowdsale.
1113     bool public didOwnerEndCrowdsale;
1114 
1115     /**
1116      * @dev Constructor.
1117      * @param _token address contract got tokens.
1118      * @param _wallet The address where funds should be transferred.
1119      * @param _pgoInternalReserveWallet The address where token will be send after vesting should be transferred.
1120      * @param _pgoUnlockedLiquidityWallet The address where token will be send after vesting should be transferred.
1121      * @param _pgoMonthlyInternalVault The address of internal funds vault contract with monthly unlocking after 9 months.
1122      * @param _pgoMonthlyPresaleVault The address of presale funds vault contract with 1/3 free funds and monthly unlocking after 9 months.
1123      * @param _kycSigners Array of the signers addresses required by the KYCBase constructor, provided by Eidoo.
1124      * See https://github.com/eidoo/icoengine
1125      */
1126     constructor(
1127         address _token,
1128         address _wallet,
1129         address _pgoInternalReserveWallet,
1130         address _pgoUnlockedLiquidityWallet,
1131         address _pgoMonthlyInternalVault,
1132         address _pgoMonthlyPresaleVault,
1133         address[] _kycSigners
1134     )
1135         public
1136         KYCBase(_kycSigners)
1137     {
1138         require(END_TIME >= START_TIME);
1139         require(TOTAL_ICO_CAP > 0);
1140 
1141         start = START_TIME;
1142         end = END_TIME;
1143         cap = TOTAL_ICO_CAP;
1144         wallet = _wallet;
1145         tokenPerEth = TOKEN_PER_ETHER;// USD_PER_ETHER.div(USD_PER_TOKEN);
1146         availableTokens = TOTAL_ICO_CAP;
1147         kycSigners = _kycSigners;
1148 
1149         token = GotToken(_token);
1150         pgoMonthlyInternalVault = PGOMonthlyInternalVault(_pgoMonthlyInternalVault);
1151         pgoMonthlyPresaleVault = PGOMonthlyPresaleVault(_pgoMonthlyPresaleVault);
1152         pgoInternalReserveWallet = _pgoInternalReserveWallet;
1153         pgoUnlockedLiquidityWallet = _pgoUnlockedLiquidityWallet;
1154         wallet = _wallet;
1155         // Creates ParkinGo vault contract
1156         pgoVault = new PGOVault(pgoInternalReserveWallet, address(token), END_TIME);
1157     }
1158 
1159     /**
1160      * @dev Mints unlocked tokens to unlockedLiquidityWallet and
1161      * assings tokens to be held into the internal reserve vault contracts.
1162      * To be called by the crowdsale's owner only.
1163      */
1164     function mintPreAllocatedTokens() public onlyOwner {
1165         mintTokens(pgoUnlockedLiquidityWallet, PGO_UNLOCKED_LIQUIDITY_CAP);
1166         mintTokens(address(pgoVault), PGO_INTERNAL_RESERVE_CAP);
1167     }
1168 
1169     /**
1170      * @dev Sets the state of the internal monthly locked vault contract and mints tokens.
1171      * It will contains all TEAM, FOUNDER, ADVISOR and PARTNERS tokens.
1172      * All token are locked for the first 9 months and then unlocked monthly.
1173      * It will check that all internal token are correctly allocated.
1174      * So far, the internal monthly vault contract has been deployed and this function
1175      * needs to be called to set its investments and vesting conditions.
1176      * @param beneficiaries Array of the internal addresses to whom vested tokens are transferred.
1177      * @param balances Array of token amount per beneficiary.
1178      */
1179     function initPGOMonthlyInternalVault(address[] beneficiaries, uint256[] balances)
1180         public
1181         onlyOwner
1182         equalLength(beneficiaries, balances)
1183     {
1184         uint256 totalInternalBalance = 0;
1185         uint256 balancesLength = balances.length;
1186 
1187         for (uint256 i = 0; i < balancesLength; i++) {
1188             totalInternalBalance = totalInternalBalance.add(balances[i]);
1189         }
1190         //check that all balances matches internal vault allocated Cap
1191         require(totalInternalBalance == MONTHLY_INTERNAL_VAULT_CAP);
1192 
1193         pgoMonthlyInternalVault.init(beneficiaries, balances, END_TIME, token);
1194 
1195         mintTokens(address(pgoMonthlyInternalVault), MONTHLY_INTERNAL_VAULT_CAP);
1196     }
1197 
1198     /**
1199      * @dev Sets the state of the reserved presale vault contract and mints reserved presale tokens. 
1200      * It will contains all reserved PRESALE token,
1201      * 1/3 of tokens are free and the remaining are locked for the first 9 months and then unlocked monthly.
1202      * It will check that all reserved presale token are correctly allocated.
1203      * So far, the monthly presale vault contract has been deployed and
1204      * this function needs to be called to set its investments and vesting conditions.
1205      * @param beneficiaries Array of the presale investors addresses to whom vested tokens are transferred.
1206      * @param balances Array of token amount per beneficiary.
1207      */
1208     function initPGOMonthlyPresaleVault(address[] beneficiaries, uint256[] balances)
1209         public
1210         onlyOwner
1211         equalLength(beneficiaries, balances)
1212     {
1213         uint256 totalPresaleBalance = 0;
1214         uint256 balancesLength = balances.length;
1215 
1216         for (uint256 i = 0; i < balancesLength; i++) {
1217             totalPresaleBalance = totalPresaleBalance.add(balances[i]);
1218         }
1219         //check that all balances matches internal vault allocated Cap
1220         require(totalPresaleBalance == RESERVED_PRESALE_CAP);
1221 
1222         pgoMonthlyPresaleVault.init(beneficiaries, balances, END_TIME, token);
1223 
1224         mintTokens(address(pgoMonthlyPresaleVault), totalPresaleBalance);
1225     }
1226 
1227     /**
1228      * @dev Mint all token collected by second private presale (called reservation),
1229      * all KYC control are made outside contract under responsability of ParkinGO.
1230      * Also, updates tokensSold and availableTokens in the crowdsale contract,
1231      * it checks that sold token are less than reservation contract cap.
1232      * @param beneficiaries Array of the reservation user that bought tokens in private reservation sale.
1233      * @param balances Array of token amount per beneficiary.
1234      */
1235     function mintReservation(address[] beneficiaries, uint256[] balances)
1236         public
1237         onlyOwner
1238         equalLength(beneficiaries, balances)
1239     {
1240         //require(tokensSold == 0);
1241 
1242         uint256 totalReservationBalance = 0;
1243         uint256 balancesLength = balances.length;
1244 
1245         for (uint256 i = 0; i < balancesLength; i++) {
1246             totalReservationBalance = totalReservationBalance.add(balances[i]);
1247             uint256 amount = balances[i];
1248             //update token sold of crowdsale contract
1249             tokensSold = tokensSold.add(amount);
1250             //update available token of crowdsale contract
1251             availableTokens = availableTokens.sub(amount);
1252             mintTokens(beneficiaries[i], amount);
1253         }
1254 
1255         require(totalReservationBalance <= RESERVATION_CAP);
1256     }
1257 
1258     /**
1259      * @dev Allows the owner to close the crowdsale manually before the end time.
1260      */
1261     function closeCrowdsale() public onlyOwner {
1262         require(block.timestamp >= START_TIME && block.timestamp < END_TIME);
1263         didOwnerEndCrowdsale = true;
1264     }
1265 
1266     /**
1267      * @dev Allows the owner to unpause tokens, stop minting and transfer ownership of the token contract.
1268      */
1269     function finalise() public onlyOwner {
1270         require(didOwnerEndCrowdsale || block.timestamp > end || capReached);
1271 
1272         token.finishMinting();
1273         token.unpause();
1274 
1275         // Token contract extends CanReclaimToken so the owner can recover
1276         // any ERC20 token received in this contract by mistake.
1277         // So far, the owner of the token contract is the crowdsale contract.
1278         // We transfer the ownership so the owner of the crowdsale is also the owner of the token.
1279         token.transferOwnership(owner);
1280     }
1281 
1282     /**
1283      * @dev Implements the price function from EidooEngineInterface.
1284      * @notice Calculates the price as tokens/ether based on the corresponding bonus bracket.
1285      * @return Price as tokens/ether.
1286      */
1287     function price() public view returns (uint256 _price) {
1288         return tokenPerEth;
1289     }
1290 
1291     /**
1292      * @dev Implements the ICOEngineInterface.
1293      * @return False if the ico is not started, true if the ico is started and running, true if the ico is completed.
1294      */
1295     function started() public view returns(bool) {
1296         if (block.timestamp >= start) {
1297             return true;
1298         } else {
1299             return false;
1300         }
1301     }
1302 
1303     /**
1304      * @dev Implements the ICOEngineInterface.
1305      * @return False if the ico is not started, false if the ico is started and running, true if the ico is completed.
1306      */
1307     function ended() public view returns(bool) {
1308         if (block.timestamp >= end) {
1309             return true;
1310         } else {
1311             return false;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Implements the ICOEngineInterface.
1317      * @return Timestamp of the ico start time.
1318      */
1319     function startTime() public view returns(uint) {
1320         return start;
1321     }
1322 
1323     /**
1324      * @dev Implements the ICOEngineInterface.
1325      * @return Timestamp of the ico end time.
1326      */
1327     function endTime() public view returns(uint) {
1328         return end;
1329     }
1330 
1331     /**
1332      * @dev Implements the ICOEngineInterface.
1333      * @return The total number of the tokens available for the sale, must not change when the ico is started.
1334      */
1335     function totalTokens() public view returns(uint) {
1336         return cap;
1337     }
1338 
1339     /**
1340      * @dev Implements the ICOEngineInterface.
1341      * @return The number of the tokens available for the ico.
1342      * At the moment the ico starts it must be equal to totalTokens(),
1343      * then it will decrease.
1344      */
1345     function remainingTokens() public view returns(uint) {
1346         return availableTokens;
1347     }
1348 
1349     /**
1350      * @dev Implements the KYCBase senderAllowedFor function to enable a sender to buy tokens for a different address.
1351      * @return true.
1352      */
1353     function senderAllowedFor(address buyer) internal view returns(bool) {
1354         require(buyer != address(0));
1355 
1356         return true;
1357     }
1358 
1359     /**
1360      * @dev Implements the KYCBase releaseTokensTo function to mint tokens for an investor.
1361      * Called after the KYC process has passed.
1362      * @return A boolean that indicates if the operation was successful.
1363      */
1364     function releaseTokensTo(address buyer) internal returns(bool) {
1365         require(validPurchase());
1366 
1367         uint256 overflowTokens;
1368         uint256 refundWeiAmount;
1369 
1370         uint256 weiAmount = msg.value;
1371         uint256 tokenAmount = weiAmount.mul(price());
1372 
1373         if (tokenAmount >= availableTokens) {
1374             capReached = true;
1375             overflowTokens = tokenAmount.sub(availableTokens);
1376             tokenAmount = tokenAmount.sub(overflowTokens);
1377             refundWeiAmount = overflowTokens.div(price());
1378             weiAmount = weiAmount.sub(refundWeiAmount);
1379             buyer.transfer(refundWeiAmount);
1380         }
1381 
1382         weiRaised = weiRaised.add(weiAmount);
1383         tokensSold = tokensSold.add(tokenAmount);
1384         availableTokens = availableTokens.sub(tokenAmount);
1385         mintTokens(buyer, tokenAmount);
1386         forwardFunds(weiAmount);
1387 
1388         return true;
1389     }
1390 
1391     /**
1392      * @dev Fired by the releaseTokensTo function after minting tokens,
1393      * to forward the raised wei to the address that collects funds.
1394      * @param _weiAmount Amount of wei send by the investor.
1395      */
1396     function forwardFunds(uint256 _weiAmount) internal {
1397         wallet.transfer(_weiAmount);
1398     }
1399 
1400     /**
1401      * @dev Validates an incoming purchase. Required statements revert state when conditions are not met.
1402      * @return true If the transaction can buy tokens.
1403      */
1404     function validPurchase() internal view returns (bool) {
1405         require(!paused && !capReached);
1406         require(block.timestamp >= start && block.timestamp <= end);
1407 
1408         return true;
1409     }
1410 
1411     /**
1412      * @dev Mints tokens being sold during the crowdsale phase as part of the implementation of releaseTokensTo function
1413      * from the KYCBase contract.
1414      * @param to The address that will receive the minted tokens.
1415      * @param amount The amount of tokens to mint.
1416      */
1417     function mintTokens(address to, uint256 amount) private {
1418         token.mint(to, amount);
1419     }
1420 
1421     modifier equalLength(address[] beneficiaries, uint256[] balances) {
1422         require(beneficiaries.length == balances.length);
1423         _;
1424     }
1425 }