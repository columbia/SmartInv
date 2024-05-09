1 pragma solidity 0.4.24;
2 
3 // File: contracts\lib\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
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
31     require(msg.sender == owner, "only owner is able to call this function");
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
64 
65 // File: contracts\lib\Pausable.sol
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() onlyOwner whenNotPaused public {
98     paused = true;
99     emit Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() onlyOwner whenPaused public {
106     paused = false;
107     emit Unpause();
108   }
109 }
110 
111 // File: contracts\lib\SafeMath.sol
112 
113 /**
114  * @title SafeMath
115  * @dev Math operations with safety checks that throw on error
116  */
117 library SafeMath {
118 
119   /**
120   * @dev Multiplies two numbers, throws on overflow.
121   */
122   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
123     if (a == 0) {
124       return 0;
125     }
126     c = a * b;
127     assert(c / a == b);
128     return c;
129   }
130 
131   /**
132   * @dev Integer division of two numbers, truncating the quotient.
133   */
134   function div(uint256 a, uint256 b) internal pure returns (uint256) {
135     // assert(b > 0); // Solidity automatically throws when dividing by 0
136     // uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138     return a / b;
139   }
140 
141   /**
142   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
143   */
144   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145     assert(b <= a);
146     return a - b;
147   }
148 
149   /**
150   * @dev Adds two numbers, throws on overflow.
151   */
152   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
153     c = a + b;
154     assert(c >= a);
155     return c;
156   }
157 }
158 
159 // File: contracts\lib\Crowdsale.sol
160 
161 /**
162  * @title Crowdsale - modified from zeppelin-solidity library
163  * @dev Crowdsale is a base contract for managing a token crowdsale.
164  * Crowdsales have a start and end timestamps, where investors can make
165  * token purchases and the crowdsale will assign them tokens based
166  * on a token per ETH rate. Funds collected are forwarded to a wallet
167  * as they arrive.
168  */
169 contract Crowdsale {
170     // start and end timestamps where investments are allowed (both inclusive)
171     uint256 public startTime;
172     uint256 public endTime;
173 
174     // address where funds are collected
175     address public wallet;
176 
177     // how many token units a buyer gets per wei
178     uint256 public rate;
179 
180     // amount of raised money in wei
181     uint256 public weiRaised;
182 
183 
184     // event for token purchase logging
185     // purchaser who paid for the tokens
186     // beneficiary who got the tokens
187     // value weis paid for purchase
188     // amount amount of tokens purchased
189     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
190 
191     function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
192         require(
193             startTime == 0 && endTime == 0 && rate == 0 && wallet == address(0),
194             "Global variables must be empty when initializing crowdsale!"
195         );
196         require(_startTime >= now, "_startTime must be more than current time!");
197         require(_endTime >= _startTime, "_endTime must be more than _startTime!");
198         require(_wallet != address(0), "_wallet parameter must not be empty!");
199 
200         startTime = _startTime;
201         endTime = _endTime;
202         rate = _rate;
203         wallet = _wallet;
204     }
205 
206     // @return true if crowdsale event has ended
207     function hasEnded() public view returns (bool) {
208         return now > endTime;
209     }
210 
211     // send ether to the fund collection wallet
212     // override to create custom fund forwarding mechanisms
213     function forwardFunds() internal {
214         wallet.transfer(msg.value);
215     }
216 }
217 
218 // File: contracts\lib\FinalizableCrowdsale.sol
219 
220 /**
221  * @title FinalizableCrowdsale
222  * @dev Extension of Crowdsale where an owner can do extra work
223  * after finishing.
224  */
225 contract FinalizableCrowdsale is Crowdsale, Ownable {
226   using SafeMath for uint256;
227 
228   bool public isFinalized = false;
229 
230   event Finalized();
231 
232   /**
233    * @dev Must be called after crowdsale ends, to do some extra finalization
234    * work. Calls the contract's finalization function.
235    */
236   function finalize() onlyOwner public {
237     require(!isFinalized);
238     require(hasEnded());
239 
240     finalization();
241     emit Finalized();
242 
243     isFinalized = true;
244   }
245 
246   /**
247    * @dev Can be overridden to add finalization logic. The overriding function
248    * should call super.finalization() to ensure the chain of finalization is
249    * executed entirely.
250    */
251   function finalization() internal {
252   }
253 }
254 
255 // File: contracts\lib\ERC20Basic.sol
256 
257 /**
258  * @title ERC20Basic
259  * @dev Simpler version of ERC20 interface
260  * @dev see https://github.com/ethereum/EIPs/issues/179
261  */
262 contract ERC20Basic {
263   function totalSupply() public view returns (uint256);
264   function balanceOf(address who) public view returns (uint256);
265   function transfer(address to, uint256 value) public returns (bool);
266   event Transfer(address indexed from, address indexed to, uint256 value);
267 }
268 
269 // File: contracts\lib\BasicToken.sol
270 
271 /**
272  * @title Basic token
273  * @dev Basic version of StandardToken, with no allowances.
274  */
275 contract BasicToken is ERC20Basic {
276   using SafeMath for uint256;
277 
278   mapping(address => uint256) balances;
279 
280   uint256 totalSupply_;
281 
282   /**
283   * @dev total number of tokens in existence
284   */
285   function totalSupply() public view returns (uint256) {
286     return totalSupply_;
287   }
288 
289   /**
290   * @dev transfer token for a specified address
291   * @param _to The address to transfer to.
292   * @param _value The amount to be transferred.
293   */
294   function transfer(address _to, uint256 _value) public returns (bool) {
295     require(_to != address(0));
296     require(_value <= balances[msg.sender]);
297 
298     // SafeMath.sub will throw if there is not enough balance.
299     balances[msg.sender] = balances[msg.sender].sub(_value);
300     balances[_to] = balances[_to].add(_value);
301     emit Transfer(msg.sender, _to, _value);
302     return true;
303   }
304 
305   /**
306   * @dev Gets the balance of the specified address.
307   * @param _owner The address to query the the balance of.
308   * @return An uint256 representing the amount owned by the passed address.
309   */
310   function balanceOf(address _owner) public view returns (uint256 balance) {
311     return balances[_owner];
312   }
313 
314 }
315 
316 // File: contracts\lib\ERC20.sol
317 
318 /**
319  * @title ERC20 interface
320  * @dev see https://github.com/ethereum/EIPs/issues/20
321  */
322 contract ERC20 {
323     function allowance(address owner, address spender) public view returns (uint256);
324     function transferFrom(address from, address to, uint256 value) public returns (bool);
325     function approve(address spender, uint256 value) public returns (bool);
326     function totalSupply() public view returns (uint256);
327     function balanceOf(address who) public view returns (uint256);
328     function transfer(address to, uint256 value) public returns (bool);
329 
330     event Approval(address indexed owner, address indexed spender, uint256 value);
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 }
333 
334 // File: contracts\lib\StandardToken.sol
335 
336 /**
337  * @title Standard ERC20 token
338  *
339  * @dev Implementation of the basic standard token.
340  * @dev https://github.com/ethereum/EIPs/issues/20
341  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
342  */
343 contract StandardToken is ERC20, BasicToken {
344 
345   mapping (address => mapping (address => uint256)) internal allowed;
346 
347 
348   /**
349    * @dev Transfer tokens from one address to another
350    * @param _from address The address which you want to send tokens from
351    * @param _to address The address which you want to transfer to
352    * @param _value uint256 the amount of tokens to be transferred
353    */
354   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
355     require(_to != address(0));
356     require(_value <= balances[_from]);
357     require(_value <= allowed[_from][msg.sender]);
358 
359     balances[_from] = balances[_from].sub(_value);
360     balances[_to] = balances[_to].add(_value);
361     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
362     emit Transfer(_from, _to, _value);
363     return true;
364   }
365 
366   /**
367    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
368    *
369    * Beware that changing an allowance with this method brings the risk that someone may use both the old
370    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
371    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
372    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373    * @param _spender The address which will spend the funds.
374    * @param _value The amount of tokens to be spent.
375    */
376   function approve(address _spender, uint256 _value) public returns (bool) {
377     allowed[msg.sender][_spender] = _value;
378     emit Approval(msg.sender, _spender, _value);
379     return true;
380   }
381 
382   /**
383    * @dev Function to check the amount of tokens that an owner allowed to a spender.
384    * @param _owner address The address which owns the funds.
385    * @param _spender address The address which will spend the funds.
386    * @return A uint256 specifying the amount of tokens still available for the spender.
387    */
388   function allowance(address _owner, address _spender) public view returns (uint256) {
389     return allowed[_owner][_spender];
390   }
391 
392   /**
393    * @dev Increase the amount of tokens that an owner allowed to a spender.
394    *
395    * approve should be called when allowed[_spender] == 0. To increment
396    * allowed value is better to use this function to avoid 2 calls (and wait until
397    * the first transaction is mined)
398    * From MonolithDAO Token.sol
399    * @param _spender The address which will spend the funds.
400    * @param _addedValue The amount of tokens to increase the allowance by.
401    */
402   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
403     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
404     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
405     return true;
406   }
407 
408   /**
409    * @dev Decrease the amount of tokens that an owner allowed to a spender.
410    *
411    * approve should be called when allowed[_spender] == 0. To decrement
412    * allowed value is better to use this function to avoid 2 calls (and wait until
413    * the first transaction is mined)
414    * From MonolithDAO Token.sol
415    * @param _spender The address which will spend the funds.
416    * @param _subtractedValue The amount of tokens to decrease the allowance by.
417    */
418   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
419     uint oldValue = allowed[msg.sender][_spender];
420     if (_subtractedValue > oldValue) {
421       allowed[msg.sender][_spender] = 0;
422     } else {
423       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
424     }
425     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429 }
430 
431 // File: contracts\lib\MintableToken.sol
432 
433 /**
434  * @title Mintable token
435  * @dev Simple ERC20 Token example, with mintable token creation
436  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
437  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
438  */
439 contract MintableToken is StandardToken, Ownable {
440   event Mint(address indexed to, uint256 amount);
441   event MintFinished();
442 
443   bool public mintingFinished = false;
444 
445 
446   modifier canMint() {
447     require(!mintingFinished);
448     _;
449   }
450 
451   /**
452    * @dev Function to mint tokens
453    * @param _to The address that will receive the minted tokens.
454    * @param _amount The amount of tokens to mint.
455    * @return A boolean that indicates if the operation was successful.
456    */
457   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
458     totalSupply_ = totalSupply_.add(_amount);
459     balances[_to] = balances[_to].add(_amount);
460     emit Mint(_to, _amount);
461     emit Transfer(address(0), _to, _amount);
462     return true;
463   }
464 
465   /**
466    * @dev Function to stop minting new tokens.
467    * @return True if the operation was successful.
468    */
469   function finishMinting() onlyOwner canMint public returns (bool) {
470     mintingFinished = true;
471     emit MintFinished();
472     return true;
473   }
474 }
475 
476 // File: contracts\lib\PausableToken.sol
477 
478 /**
479  * @title Pausable token
480  * @dev StandardToken modified with pausable transfers.
481  **/
482 contract PausableToken is StandardToken, Pausable {
483 
484   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
485     return super.transfer(_to, _value);
486   }
487 
488   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
489     return super.transferFrom(_from, _to, _value);
490   }
491 
492   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
493     return super.approve(_spender, _value);
494   }
495 
496   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
497     return super.increaseApproval(_spender, _addedValue);
498   }
499 
500   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
501     return super.decreaseApproval(_spender, _subtractedValue);
502   }
503 }
504 
505 // File: contracts\CompanyToken.sol
506 
507 /**
508  * @title CompanyToken contract - ERC20 compatible token contract with customized token parameters.
509  * @author Gustavo Guimaraes - <gustavo@starbase.co>
510  */
511 contract CompanyToken is PausableToken, MintableToken {
512     string public name;
513     string public symbol;
514     uint8 public decimals;
515 
516     /**
517      * @dev Contract constructor function
518      * @param _name Token name
519      * @param _symbol Token symbol - up to 4 characters
520      * @param _decimals Decimals for token
521      */
522     constructor(string _name, string _symbol, uint8 _decimals) public {
523         name = _name;
524         symbol = _symbol;
525         decimals = _decimals;
526 
527         pause();
528     }
529 }
530 
531 // File: contracts\Whitelist.sol
532 
533 /**
534  * @title Whitelist - crowdsale whitelist contract
535  * @author Gustavo Guimaraes - <gustavo@starbase.co>
536  */
537 contract Whitelist is Ownable {
538     mapping(address => bool) public allowedAddresses;
539 
540     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
541 
542     /**
543     * @dev Adds single address to whitelist.
544     * @param _address Address to be added to the whitelist
545     */
546     function addToWhitelist(address _address) external onlyOwner {
547         allowedAddresses[_address] = true;
548         emit WhitelistUpdated(now, "Added", _address);
549     }
550 
551     /**
552      * @dev add various whitelist addresses
553      * @param _addresses Array of ethereum addresses
554      */
555     function addManyToWhitelist(address[] _addresses) external onlyOwner {
556         for (uint256 i = 0; i < _addresses.length; i++) {
557             allowedAddresses[_addresses[i]] = true;
558             emit WhitelistUpdated(now, "Added", _addresses[i]);
559         }
560     }
561 
562     /**
563      * @dev remove whitelist addresses
564      * @param _addresses Array of ethereum addresses
565      */
566     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
567         for (uint256 i = 0; i < _addresses.length; i++) {
568             allowedAddresses[_addresses[i]] = false;
569             emit WhitelistUpdated(now, "Removed", _addresses[i]);
570         }
571     }
572 }
573 
574 // File: contracts\TokenSaleInterface.sol
575 
576 /**
577  * @title TokenSale contract interface
578  */
579 interface TokenSaleInterface {
580     function init
581     (
582         uint256 _startTime,
583         uint256 _endTime,
584         address _whitelist,
585         address _starToken,
586         address _companyToken,
587         uint256 _rate,
588         uint256 _starRate,
589         address _wallet,
590         uint256 _crowdsaleCap,
591         bool    _isWeiAccepted
592     )
593     external;
594 }
595 
596 // File: contracts\TokenSale.sol
597 
598 /**
599  * @title Token Sale contract - crowdsale of company tokens.
600  * @author Gustavo Guimaraes - <gustavo@starbase.co>
601  */
602 contract TokenSale is FinalizableCrowdsale, Pausable {
603     uint256 public crowdsaleCap;
604     // amount of raised money in STAR
605     uint256 public starRaised;
606     uint256 public starRate;
607     address public initialTokenOwner;
608     bool public isWeiAccepted;
609 
610     // external contracts
611     Whitelist public whitelist;
612     StandardToken public starToken;
613     // The token being sold
614     MintableToken public tokenOnSale;
615 
616     event TokenRateChanged(uint256 previousRate, uint256 newRate);
617     event TokenStarRateChanged(uint256 previousStarRate, uint256 newStarRate);
618     event TokenPurchaseWithStar(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
619 
620     /**
621      * @dev initialization function
622      * @param _startTime The timestamp of the beginning of the crowdsale
623      * @param _endTime Timestamp when the crowdsale will finish
624      * @param _whitelist contract containing the whitelisted addresses
625      * @param _starToken STAR token contract address
626      * @param _companyToken ERC20 CompanyToken contract address
627      * @param _rate The token rate per ETH
628      * @param _starRate The token rate per STAR
629      * @param _wallet Multisig wallet that will hold the crowdsale funds.
630      * @param _crowdsaleCap Cap for the token sale
631      * @param _isWeiAccepted Bool for acceptance of ether in token sale
632      */
633     function init(
634         uint256 _startTime,
635         uint256 _endTime,
636         address _whitelist,
637         address _starToken,
638         address _companyToken,
639         uint256 _rate,
640         uint256 _starRate,
641         address _wallet,
642         uint256 _crowdsaleCap,
643         bool    _isWeiAccepted
644     )
645         external
646     {
647         require(
648             whitelist == address(0) &&
649             starToken == address(0) &&
650             rate == 0 &&
651             starRate == 0 &&
652             tokenOnSale == address(0) &&
653             crowdsaleCap == 0,
654             "Global variables should not have been set before!"
655         );
656 
657         require(
658             _whitelist != address(0) &&
659             _starToken != address(0) &&
660             !(_rate == 0 && _starRate == 0) &&
661             _companyToken != address(0) &&
662             _crowdsaleCap != 0,
663             "Parameter variables cannot be empty!"
664         );
665 
666         initCrowdsale(_startTime, _endTime, _rate, _wallet);
667         tokenOnSale = CompanyToken(_companyToken);
668         whitelist = Whitelist(_whitelist);
669         starToken = StandardToken(_starToken);
670         starRate = _starRate;
671         isWeiAccepted = _isWeiAccepted;
672         owner = tx.origin;
673 
674         initialTokenOwner = CompanyToken(tokenOnSale).owner();
675         uint256 tokenDecimals = CompanyToken(tokenOnSale).decimals();
676         crowdsaleCap = _crowdsaleCap.mul(10 ** tokenDecimals);
677 
678         require(CompanyToken(tokenOnSale).paused(), "Company token must be paused upon initialization!");
679     }
680 
681     modifier isWhitelisted(address beneficiary) {
682         require(whitelist.allowedAddresses(beneficiary), "Beneficiary not whitelisted!");
683         _;
684     }
685 
686     modifier crowdsaleIsTokenOwner() {
687         require(tokenOnSale.owner() == address(this), "The token owner must be contract address!");
688         _;
689     }
690 
691     /**
692      * @dev override fallback function. cannot use it
693      */
694     function () external payable {
695         revert("No fallback function defined!");
696     }
697 
698     /**
699      * @dev change crowdsale ETH rate
700      * @param newRate Figure that corresponds to the new ETH rate per token
701      */
702     function setRate(uint256 newRate) external onlyOwner {
703         require(newRate != 0, "ETH rate must be more than 0");
704 
705         emit TokenRateChanged(rate, newRate);
706         rate = newRate;
707     }
708 
709     /**
710      * @dev change crowdsale STAR rate
711      * @param newStarRate Figure that corresponds to the new STAR rate per token
712      */
713     function setStarRate(uint256 newStarRate) external onlyOwner {
714         require(newStarRate != 0, "Star rate must be more than 0!");
715 
716         emit TokenStarRateChanged(starRate, newStarRate);
717         starRate = newStarRate;
718     }
719 
720     /**
721      * @dev allows sale to receive wei or not
722      */
723     function setIsWeiAccepted(bool _isWeiAccepted) external onlyOwner {
724         require(rate != 0, "When accepting Wei you need to set a conversion rate!");
725         isWeiAccepted = _isWeiAccepted;
726     }
727 
728     /**
729      * @dev function that allows token purchases with STAR
730      * @param beneficiary Address of the purchaser
731      */
732     function buyTokens(address beneficiary)
733         public
734         payable
735         whenNotPaused
736         isWhitelisted(beneficiary)
737         crowdsaleIsTokenOwner
738     {
739         require(beneficiary != address(0));
740         require(validPurchase() && tokenOnSale.totalSupply() < crowdsaleCap);
741 
742         if (!isWeiAccepted) {
743             require(msg.value == 0);
744         } else if (msg.value > 0) {
745             buyTokensWithWei(beneficiary);
746         }
747 
748         // beneficiary must allow TokenSale address to transfer star tokens on its behalf
749         uint256 starAllocationToTokenSale = starToken.allowance(beneficiary, this);
750         if (starAllocationToTokenSale > 0) {
751             // calculate token amount to be created
752             uint256 tokens = starAllocationToTokenSale.mul(starRate);
753 
754             //remainder logic
755             if (tokenOnSale.totalSupply().add(tokens) > crowdsaleCap) {
756                 tokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
757 
758                 starAllocationToTokenSale = tokens.div(starRate);
759             }
760 
761             // update state
762             starRaised = starRaised.add(starAllocationToTokenSale);
763 
764             tokenOnSale.mint(beneficiary, tokens);
765             emit TokenPurchaseWithStar(msg.sender, beneficiary, starAllocationToTokenSale, tokens);
766 
767             // forward funds
768             starToken.transferFrom(beneficiary, wallet, starAllocationToTokenSale);
769         }
770     }
771 
772     /**
773      * @dev function that allows token purchases with Wei
774      * @param beneficiary Address of the purchaser
775      */
776     function buyTokensWithWei(address beneficiary)
777         internal
778     {
779         uint256 weiAmount = msg.value;
780         uint256 weiRefund = 0;
781 
782         // calculate token amount to be created
783         uint256 tokens = weiAmount.mul(rate);
784 
785         //remainder logic
786         if (tokenOnSale.totalSupply().add(tokens) > crowdsaleCap) {
787             tokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
788             weiAmount = tokens.div(rate);
789 
790             weiRefund = msg.value.sub(weiAmount);
791         }
792 
793         // update state
794         weiRaised = weiRaised.add(weiAmount);
795 
796         tokenOnSale.mint(beneficiary, tokens);
797         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
798 
799         wallet.transfer(weiAmount);
800         if (weiRefund > 0) {
801             msg.sender.transfer(weiRefund);
802         }
803     }
804 
805     // override Crowdsale#hasEnded to add cap logic
806     // @return true if crowdsale event has ended
807     function hasEnded() public view returns (bool) {
808         if (tokenOnSale.totalSupply() >= crowdsaleCap) {
809             return true;
810         }
811 
812         return super.hasEnded();
813     }
814 
815     /**
816      * @dev override Crowdsale#validPurchase
817      * @return true if the transaction can buy tokens
818      */
819     function validPurchase() internal view returns (bool) {
820         return now >= startTime && now <= endTime;
821     }
822 
823     /**
824      * @dev finalizes crowdsale
825      */
826     function finalization() internal {
827         if (crowdsaleCap > tokenOnSale.totalSupply()) {
828             uint256 remainingTokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
829 
830             tokenOnSale.mint(wallet, remainingTokens);
831         }
832 
833         tokenOnSale.transferOwnership(initialTokenOwner);
834         super.finalization();
835     }
836 }