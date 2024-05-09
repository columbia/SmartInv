1 /**
2  * @title TEND token
3  * @version 2.0
4  * @author Validity Labs AG <info@validitylabs.org>
5  *
6  * The TTA tokens are issued as participation certificates and represent
7  * uncertificated securities within the meaning of article 973c Swiss CO. The
8  * issuance of the TTA tokens has been governed by a prospectus issued by
9  * Tend Technologies AG.
10  *
11  * TTA tokens are only recognized and transferable in undivided units.
12  *
13  * The holder of a TTA token must prove his possessorship to be recognized by
14  * the issuer as being entitled to the rights arising out of the respective
15  * participation certificate; he/she waives any rights if he/she is not in a
16  * position to prove him/her being the holder of the respective token.
17  *
18  * Similarly, only the person who proves him/her being the holder of the TTA
19  * Token is entitled to transfer title and ownership on the token to another
20  * person. Both the transferor and the transferee agree and accept hereby
21  * explicitly that the tokens are transferred digitally, i.e. in a form-free
22  * manner. However, if any regulators, courts or similar would require written
23  * confirmation of a transfer of the transferable uncertificated securities
24  * from one investor to another investor, such investors will provide written
25  * evidence of such transfer.
26  */
27 pragma solidity ^0.4.24;
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    */
64   function renounceOwnership() public onlyOwner {
65     emit OwnershipRenounced(owner);
66     owner = address(0);
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address _newOwner) public onlyOwner {
74     _transferOwnership(_newOwner);
75   }
76 
77   /**
78    * @dev Transfers control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function _transferOwnership(address _newOwner) internal {
82     require(_newOwner != address(0));
83     emit OwnershipTransferred(owner, _newOwner);
84     owner = _newOwner;
85   }
86 }
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
99     // benefit is lost if 'b' is also tested.
100     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
101     if (a == 0) {
102       return 0;
103     }
104 
105     c = a * b;
106     assert(c / a == b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     // uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return a / b;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
132     c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 
138 /**
139  * @title ERC20Basic
140  * @dev Simpler version of ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/179
142  */
143 contract ERC20Basic {
144   function totalSupply() public view returns (uint256);
145   function balanceOf(address who) public view returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender)
156     public view returns (uint256);
157 
158   function transferFrom(address from, address to, uint256 value)
159     public returns (bool);
160 
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 
169 /**
170  * @title Basic token
171  * @dev Basic version of StandardToken, with no allowances.
172  */
173 contract BasicToken is ERC20Basic {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   /**
181   * @dev total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185   }
186 
187   /**
188   * @dev transfer token for a specified address
189   * @param _to The address to transfer to.
190   * @param _value The amount to be transferred.
191   */
192   function transfer(address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[msg.sender]);
195 
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     emit Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203   * @dev Gets the balance of the specified address.
204   * @param _owner The address to query the the balance of.
205   * @return An uint256 representing the amount owned by the passed address.
206   */
207   function balanceOf(address _owner) public view returns (uint256) {
208     return balances[_owner];
209   }
210 
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     returns (bool)
238   {
239     require(_to != address(0));
240     require(_value <= balances[_from]);
241     require(_value <= allowed[_from][msg.sender]);
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     emit Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    *
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     emit Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address _owner,
274     address _spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(
294     address _spender,
295     uint _addedValue
296   )
297     public
298     returns (bool)
299   {
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To decrement
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _subtractedValue The amount of tokens to decrease the allowance by.
315    */
316   function decreaseApproval(
317     address _spender,
318     uint _subtractedValue
319   )
320     public
321     returns (bool)
322   {
323     uint oldValue = allowed[msg.sender][_spender];
324     if (_subtractedValue > oldValue) {
325       allowed[msg.sender][_spender] = 0;
326     } else {
327       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328     }
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333 }
334 
335 /**
336  * @title Mintable token
337  * @dev Simple ERC20 Token example, with mintable token creation
338  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
339  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
340  */
341 contract MintableToken is StandardToken, Ownable {
342   event Mint(address indexed to, uint256 amount);
343   event MintFinished();
344 
345   bool public mintingFinished = false;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   modifier hasMintPermission() {
354     require(msg.sender == owner);
355     _;
356   }
357 
358   /**
359    * @dev Function to mint tokens
360    * @param _to The address that will receive the minted tokens.
361    * @param _amount The amount of tokens to mint.
362    * @return A boolean that indicates if the operation was successful.
363    */
364   function mint(
365     address _to,
366     uint256 _amount
367   )
368     hasMintPermission
369     canMint
370     public
371     returns (bool)
372   {
373     totalSupply_ = totalSupply_.add(_amount);
374     balances[_to] = balances[_to].add(_amount);
375     emit Mint(_to, _amount);
376     emit Transfer(address(0), _to, _amount);
377     return true;
378   }
379 
380   /**
381    * @dev Function to stop minting new tokens.
382    * @return True if the operation was successful.
383    */
384   function finishMinting() onlyOwner canMint public returns (bool) {
385     mintingFinished = true;
386     emit MintFinished();
387     return true;
388   }
389 }
390 
391 /**
392  * @title Pausable
393  * @dev Base contract which allows children to implement an emergency stop mechanism.
394  */
395 contract Pausable is Ownable {
396   event Pause();
397   event Unpause();
398 
399   bool public paused = false;
400 
401 
402   /**
403    * @dev Modifier to make a function callable only when the contract is not paused.
404    */
405   modifier whenNotPaused() {
406     require(!paused);
407     _;
408   }
409 
410   /**
411    * @dev Modifier to make a function callable only when the contract is paused.
412    */
413   modifier whenPaused() {
414     require(paused);
415     _;
416   }
417 
418   /**
419    * @dev called by the owner to pause, triggers stopped state
420    */
421   function pause() onlyOwner whenNotPaused public {
422     paused = true;
423     emit Pause();
424   }
425 
426   /**
427    * @dev called by the owner to unpause, returns to normal state
428    */
429   function unpause() onlyOwner whenPaused public {
430     paused = false;
431     emit Unpause();
432   }
433 }
434 
435 /**
436  * @title Pausable token
437  * @dev StandardToken modified with pausable transfers.
438  **/
439 contract PausableToken is StandardToken, Pausable {
440 
441   function transfer(
442     address _to,
443     uint256 _value
444   )
445     public
446     whenNotPaused
447     returns (bool)
448   {
449     return super.transfer(_to, _value);
450   }
451 
452   function transferFrom(
453     address _from,
454     address _to,
455     uint256 _value
456   )
457     public
458     whenNotPaused
459     returns (bool)
460   {
461     return super.transferFrom(_from, _to, _value);
462   }
463 
464   function approve(
465     address _spender,
466     uint256 _value
467   )
468     public
469     whenNotPaused
470     returns (bool)
471   {
472     return super.approve(_spender, _value);
473   }
474 
475   function increaseApproval(
476     address _spender,
477     uint _addedValue
478   )
479     public
480     whenNotPaused
481     returns (bool success)
482   {
483     return super.increaseApproval(_spender, _addedValue);
484   }
485 
486   function decreaseApproval(
487     address _spender,
488     uint _subtractedValue
489   )
490     public
491     whenNotPaused
492     returns (bool success)
493   {
494     return super.decreaseApproval(_spender, _subtractedValue);
495   }
496 }
497 
498 contract DividendToken is StandardToken, Ownable {
499     using SafeMath for uint256;
500 
501     // time before dividendEndTime during which dividend cannot be claimed by token holders
502     // instead the unclaimed dividend can be claimed by treasury in that time span
503     uint256 public claimTimeout = 20 days;
504 
505     uint256 public dividendCycleTime = 350 days;
506 
507     uint256 public currentDividend;
508 
509     mapping(address => uint256) unclaimedDividend;
510 
511     // tracks when the dividend balance has been updated last time
512     mapping(address => uint256) public lastUpdate;
513 
514     uint256 public lastDividendIncreaseDate;
515 
516     // allow payment of dividend only by special treasury account (treasury can be set and altered by owner,
517     // multiple treasurer accounts are possible
518     mapping(address => bool) public isTreasurer;
519 
520     uint256 public dividendEndTime = 0;
521 
522     event Payin(address _owner, uint256 _value, uint256 _endTime);
523 
524     event Payout(address _tokenHolder, uint256 _value);
525 
526     event Reclaimed(uint256 remainingBalance, uint256 _endTime, uint256 _now);
527 
528     event ChangedTreasurer(address treasurer, bool active);
529 
530     /**
531      * @dev Deploy the DividendToken contract and set the owner of the contract
532      */
533     constructor() public {
534         isTreasurer[owner] = true;
535     }
536 
537     /**
538      * @dev Request payout dividend (claim) (requested by tokenHolder -> pull)
539      * dividends that have not been claimed within 330 days expire and cannot be claimed anymore by the token holder.
540      */
541     function claimDividend() public returns (bool) {
542         // unclaimed dividend fractions should expire after 330 days and the owner can reclaim that fraction
543         require(dividendEndTime > 0);
544         require(dividendEndTime.sub(claimTimeout) > block.timestamp);
545 
546         updateDividend(msg.sender);
547 
548         uint256 payment = unclaimedDividend[msg.sender];
549         unclaimedDividend[msg.sender] = 0;
550 
551         msg.sender.transfer(payment);
552 
553         // Trigger payout event
554         emit Payout(msg.sender, payment);
555 
556         return true;
557     }
558 
559     /**
560      * @dev Transfer dividend (fraction) to new token holder
561      * @param _from address The address of the old token holder
562      * @param _to address The address of the new token holder
563      * @param _value uint256 Number of tokens to transfer
564      */
565     function transferDividend(address _from, address _to, uint256 _value) internal {
566         updateDividend(_from);
567         updateDividend(_to);
568 
569         uint256 transAmount = unclaimedDividend[_from].mul(_value).div(balanceOf(_from));
570 
571         unclaimedDividend[_from] = unclaimedDividend[_from].sub(transAmount);
572         unclaimedDividend[_to] = unclaimedDividend[_to].add(transAmount);
573     }
574 
575     /**
576      * @dev Update the dividend of hodler
577      * @param _hodler address The Address of the hodler
578      */
579     function updateDividend(address _hodler) internal {
580         // last update in previous period -> reset claimable dividend
581         if (lastUpdate[_hodler] < lastDividendIncreaseDate) {
582             unclaimedDividend[_hodler] = calcDividend(_hodler, totalSupply_);
583             lastUpdate[_hodler] = block.timestamp;
584         }
585     }
586 
587     /**
588      * @dev Get claimable dividend for the hodler
589      * @param _hodler address The Address of the hodler
590      */
591     function getClaimableDividend(address _hodler) public constant returns (uint256 claimableDividend) {
592         if (lastUpdate[_hodler] < lastDividendIncreaseDate) {
593             return calcDividend(_hodler, totalSupply_);
594         } else {
595             return (unclaimedDividend[_hodler]);
596         }
597     }
598 
599     /**
600      * @dev Overrides transfer method from BasicToken
601      * transfer token for a specified address
602      * @param _to address The address to transfer to.
603      * @param _value uint256 The amount to be transferred.
604      */
605     function transfer(address _to, uint256 _value) public returns (bool) {
606         transferDividend(msg.sender, _to, _value);
607 
608         // Return from inherited transfer method
609         return super.transfer(_to, _value);
610     }
611 
612     /**
613      * @dev Transfer tokens from one address to another
614      * @param _from address The address which you want to send tokens from
615      * @param _to address The address which you want to transfer to
616      * @param _value uint256 the amount of tokens to be transferred
617      */
618     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
619         // Prevent dividend to be claimed twice
620         transferDividend(_from, _to, _value);
621 
622         // Return from inherited transferFrom method
623         return super.transferFrom(_from, _to, _value);
624     }
625 
626     /**
627      * @dev Set / alter treasurer "account". This can be done from owner only
628      * @param _treasurer address Address of the treasurer to create/alter
629      * @param _active bool Flag that shows if the treasurer account is active
630      */
631     function setTreasurer(address _treasurer, bool _active) public onlyOwner {
632         isTreasurer[_treasurer] = _active;
633         emit ChangedTreasurer(_treasurer, _active);
634     }
635 
636     /**
637      * @dev Request unclaimed ETH, payback to beneficiary (owner) wallet
638      * dividend payment is possible every 330 days at the earliest - can be later, this allows for some flexibility,
639      * e.g. board meeting had to happen a bit earlier this year than previous year.
640      */
641     function requestUnclaimed() public onlyOwner {
642         // Send remaining ETH to beneficiary (back to owner) if dividend round is over
643         require(block.timestamp >= dividendEndTime.sub(claimTimeout));
644 
645         msg.sender.transfer(address(this).balance);
646 
647         emit Reclaimed(address(this).balance, dividendEndTime, block.timestamp);
648     }
649 
650     /**
651      * @dev ETH Payin for Treasurer
652      * Only owner or treasurer can do a payin for all token holder.
653      * Owner / treasurer can also increase dividend by calling fallback function multiple times.
654      */
655     function() public payable {
656         require(isTreasurer[msg.sender]);
657         require(dividendEndTime < block.timestamp);
658 
659         // pay back unclaimed dividend that might not have been claimed by owner yet
660         if (address(this).balance > msg.value) {
661             uint256 payout = address(this).balance.sub(msg.value);
662             owner.transfer(payout);
663             emit Reclaimed(payout, dividendEndTime, block.timestamp);
664         }
665 
666         currentDividend = address(this).balance;
667 
668         // No active dividend cycle found, initialize new round
669         dividendEndTime = block.timestamp.add(dividendCycleTime);
670 
671         // Trigger payin event
672         emit Payin(msg.sender, msg.value, dividendEndTime);
673 
674         lastDividendIncreaseDate = block.timestamp;
675     }
676 
677     /**
678      * @dev calculate the dividend
679      * @param _hodler address
680      * @param _totalSupply uint256
681      */
682     function calcDividend(address _hodler, uint256 _totalSupply) public view returns(uint256) {
683         return (currentDividend.mul(balanceOf(_hodler))).div(_totalSupply);
684     }
685 }
686 
687 contract TendToken is MintableToken, PausableToken, DividendToken {
688     using SafeMath for uint256;
689 
690     string public constant name = "Tend Token";
691     string public constant symbol = "TTA";
692     uint8 public constant decimals = 18;
693 
694     // Minimum transferable chunk
695     uint256 public granularity = 1e18;
696 
697     /**
698      * @dev Constructor of TendToken that instantiate a new DividendToken
699      */
700     constructor() public DividendToken() {
701         // token should not be transferrable until after all tokens have been issued
702         paused = true;
703     }
704 
705     /**
706      * @dev Internal function that ensures `_amount` is multiple of the granularity
707      * @param _amount The quantity that wants to be checked
708      */
709     function requireMultiple(uint256 _amount) internal view {
710         require(_amount.div(granularity).mul(granularity) == _amount);
711     }
712 
713     /**
714      * @dev Transfer token for a specified address
715      * @param _to The address to transfer to.
716      * @param _value The amount to be transferred.
717      */
718     function transfer(address _to, uint256 _value) public returns (bool) {
719         requireMultiple(_value);
720 
721         return super.transfer(_to, _value);
722     }
723 
724     /**
725      * @dev Transfer tokens from one address to another
726      * @param _from address The address which you want to send tokens from
727      * @param _to address The address which you want to transfer to
728      * @param _value uint256 the amount of tokens to be transferred
729      */
730     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
731         requireMultiple(_value);
732 
733         return super.transferFrom(_from, _to, _value);
734     }
735 
736     /**
737      * @dev Function to mint tokens
738      * @param _to The address that will receive the minted tokens.
739      * @param _amount The amount of tokens to mint.
740      * @return A boolean that indicates if the operation was successful.
741      */
742     function mint(address _to, uint256 _amount) public returns (bool) {
743         requireMultiple(_amount);
744 
745         // Return from inherited mint method
746         return super.mint(_to, _amount);
747     }
748 
749     /**
750      * @dev Function to batch mint tokens
751      * @param _to An array of addresses that will receive the minted tokens.
752      * @param _amount An array with the amounts of tokens each address will get minted.
753      * @return A boolean that indicates whether the operation was successful.
754      */
755     function batchMint(
756         address[] _to,
757         uint256[] _amount
758     )
759         hasMintPermission
760         canMint
761         public
762         returns (bool)
763     {
764         require(_to.length == _amount.length);
765 
766         for (uint i = 0; i < _to.length; i++) {
767             requireMultiple(_amount[i]);
768 
769             require(mint(_to[i], _amount[i]));
770         }
771         return true;
772     }
773 }
774 
775 /**
776  * @title SafeERC20
777  * @dev Wrappers around ERC20 operations that throw on failure.
778  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
779  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
780  */
781 library SafeERC20 {
782   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
783     require(token.transfer(to, value));
784   }
785 
786   function safeTransferFrom(
787     ERC20 token,
788     address from,
789     address to,
790     uint256 value
791   )
792     internal
793   {
794     require(token.transferFrom(from, to, value));
795   }
796 
797   function safeApprove(ERC20 token, address spender, uint256 value) internal {
798     require(token.approve(spender, value));
799   }
800 }
801 
802 /**
803  * @title TokenVesting
804  * @dev A token holder contract that can release its token balance gradually like a
805  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
806  * owner.
807  */
808 contract TokenVesting is Ownable {
809   using SafeMath for uint256;
810   using SafeERC20 for ERC20Basic;
811 
812   event Released(uint256 amount);
813   event Revoked();
814 
815   // beneficiary of tokens after they are released
816   address public beneficiary;
817 
818   uint256 public cliff;
819   uint256 public start;
820   uint256 public duration;
821 
822   bool public revocable;
823 
824   mapping (address => uint256) public released;
825   mapping (address => bool) public revoked;
826 
827   /**
828    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
829    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
830    * of the balance will have vested.
831    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
832    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
833    * @param _start the time (as Unix time) at which point vesting starts 
834    * @param _duration duration in seconds of the period in which the tokens will vest
835    * @param _revocable whether the vesting is revocable or not
836    */
837   constructor(
838     address _beneficiary,
839     uint256 _start,
840     uint256 _cliff,
841     uint256 _duration,
842     bool _revocable
843   )
844     public
845   {
846     require(_beneficiary != address(0));
847     require(_cliff <= _duration);
848 
849     beneficiary = _beneficiary;
850     revocable = _revocable;
851     duration = _duration;
852     cliff = _start.add(_cliff);
853     start = _start;
854   }
855 
856   /**
857    * @notice Transfers vested tokens to beneficiary.
858    * @param token ERC20 token which is being vested
859    */
860   function release(ERC20Basic token) public {
861     uint256 unreleased = releasableAmount(token);
862 
863     require(unreleased > 0);
864 
865     released[token] = released[token].add(unreleased);
866 
867     token.safeTransfer(beneficiary, unreleased);
868 
869     emit Released(unreleased);
870   }
871 
872   /**
873    * @notice Allows the owner to revoke the vesting. Tokens already vested
874    * remain in the contract, the rest are returned to the owner.
875    * @param token ERC20 token which is being vested
876    */
877   function revoke(ERC20Basic token) public onlyOwner {
878     require(revocable);
879     require(!revoked[token]);
880 
881     uint256 balance = token.balanceOf(this);
882 
883     uint256 unreleased = releasableAmount(token);
884     uint256 refund = balance.sub(unreleased);
885 
886     revoked[token] = true;
887 
888     token.safeTransfer(owner, refund);
889 
890     emit Revoked();
891   }
892 
893   /**
894    * @dev Calculates the amount that has already vested but hasn't been released yet.
895    * @param token ERC20 token which is being vested
896    */
897   function releasableAmount(ERC20Basic token) public view returns (uint256) {
898     return vestedAmount(token).sub(released[token]);
899   }
900 
901   /**
902    * @dev Calculates the amount that has already vested.
903    * @param token ERC20 token which is being vested
904    */
905   function vestedAmount(ERC20Basic token) public view returns (uint256) {
906     uint256 currentBalance = token.balanceOf(this);
907     uint256 totalBalance = currentBalance.add(released[token]);
908 
909     if (block.timestamp < cliff) {
910       return 0;
911     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
912       return totalBalance;
913     } else {
914       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
915     }
916   }
917 }
918 
919 contract RoundedTokenVesting is TokenVesting {
920     using SafeMath for uint256;
921 
922     // Minimum transferable chunk
923     uint256 public granularity;
924 
925     /**
926      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
927      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
928      * of the balance will have vested.
929      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
930      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
931      * @param _start the time (as Unix time) at which point vesting starts 
932      * @param _duration duration in seconds of the period in which the tokens will vest
933      * @param _revocable whether the vesting is revocable or not
934      */
935     constructor(
936         address _beneficiary,
937         uint256 _start,
938         uint256 _cliff,
939         uint256 _duration,
940         bool _revocable,
941         uint256 _granularity
942     )
943         public
944         TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
945     {
946         granularity = _granularity;
947     }
948     
949     /**
950      * @dev Calculates the amount that has already vested.
951      * @param token ERC20 token which is being vested
952      */
953     function vestedAmount(ERC20Basic token) public view returns (uint256) {
954         uint256 currentBalance = token.balanceOf(this);
955         uint256 totalBalance = currentBalance.add(released[token]);
956 
957         if (block.timestamp < cliff) {
958             return 0;
959         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
960             return totalBalance;
961         } else {
962             uint256 notRounded = totalBalance.mul(block.timestamp.sub(start)).div(duration);
963 
964             // Round down to the nearest token chunk by using integer division: (x / 1e18) * 1e18
965             uint256 rounded = notRounded.div(granularity).mul(granularity);
966 
967             return rounded;
968         }
969     }
970 }
971 
972 contract TendTokenVested is TendToken {
973     using SafeMath for uint256;
974 
975     /*** CONSTANTS ***/
976     uint256 public constant DEVELOPMENT_TEAM_CAP = 2e6 * 1e18;  // 2 million * 1e18
977 
978     uint256 public constant VESTING_CLIFF = 0 days;
979     uint256 public constant VESTING_DURATION = 3 * 365 days;
980 
981     uint256 public developmentTeamTokensMinted;
982 
983     // for convenience we store vesting wallets
984     address[] public vestingWallets;
985 
986     modifier onlyNoneZero(address _to, uint256 _amount) {
987         require(_to != address(0));
988         require(_amount > 0);
989         _;
990     }
991 
992     /**
993      * @dev allows contract owner to mint team tokens per DEVELOPMENT_TEAM_CAP and transfer to the development team's wallet (yes vesting)
994      * @param _to address for beneficiary
995      * @param _tokens uint256 token amount to mint
996      */
997     function mintDevelopmentTeamTokens(address _to, uint256 _tokens) public onlyOwner onlyNoneZero(_to, _tokens) returns (bool) {
998         requireMultiple(_tokens);
999         require(developmentTeamTokensMinted.add(_tokens) <= DEVELOPMENT_TEAM_CAP);
1000 
1001         developmentTeamTokensMinted = developmentTeamTokensMinted.add(_tokens);
1002         RoundedTokenVesting newVault = new RoundedTokenVesting(_to, block.timestamp, VESTING_CLIFF, VESTING_DURATION, false, granularity);
1003         vestingWallets.push(address(newVault)); // for convenience we keep them in storage so that they are easily accessible via MEW or etherscan
1004         return mint(address(newVault), _tokens);
1005     }
1006 
1007     /**
1008      * @dev returns number of elements in the vestinWallets array
1009      */
1010     function getVestingWalletLength() public view returns (uint256) {
1011         return vestingWallets.length;
1012     }
1013 }