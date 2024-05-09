1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/Ownable.sol
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
65 // File: contracts/lib/Pausable.sol
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
111 // File: contracts/lib/SafeMath.sol
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
159 // File: contracts/lib/ERC20Basic.sol
160 
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167   function totalSupply() public view returns (uint256);
168   function balanceOf(address who) public view returns (uint256);
169   function transfer(address to, uint256 value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 // File: contracts/lib/BasicToken.sol
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   uint256 totalSupply_;
185 
186   /**
187   * @dev total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193   /**
194   * @dev transfer token for a specified address
195   * @param _to The address to transfer to.
196   * @param _value The amount to be transferred.
197   */
198   function transfer(address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     // SafeMath.sub will throw if there is not enough balance.
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256 balance) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 // File: contracts/lib/ERC20.sol
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 contract ERC20 {
227     function allowance(address owner, address spender) public view returns (uint256);
228     function transferFrom(address from, address to, uint256 value) public returns (bool);
229     function approve(address spender, uint256 value) public returns (bool);
230     function totalSupply() public view returns (uint256);
231     function balanceOf(address who) public view returns (uint256);
232     function transfer(address to, uint256 value) public returns (bool);
233 
234     event Approval(address indexed owner, address indexed spender, uint256 value);
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 }
237 
238 // File: contracts/lib/StandardToken.sol
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     emit Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(address _owner, address _spender) public view returns (uint256) {
293     return allowed[_owner][_spender];
294   }
295 
296   /**
297    * @dev Increase the amount of tokens that an owner allowed to a spender.
298    *
299    * approve should be called when allowed[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _addedValue The amount of tokens to increase the allowance by.
305    */
306   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
307     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    *
315    * approve should be called when allowed[_spender] == 0. To decrement
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _subtractedValue The amount of tokens to decrease the allowance by.
321    */
322   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
335 // File: contracts/lib/MintableToken.sol
336 
337 /**
338  * @title Mintable token
339  * @dev Simple ERC20 Token example, with mintable token creation
340  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
341  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
342  */
343 contract MintableToken is StandardToken, Ownable {
344   event Mint(address indexed to, uint256 amount);
345   event MintFinished();
346 
347   bool public mintingFinished = false;
348 
349 
350   modifier canMint() {
351     require(!mintingFinished);
352     _;
353   }
354 
355   /**
356    * @dev Function to mint tokens
357    * @param _to The address that will receive the minted tokens.
358    * @param _amount The amount of tokens to mint.
359    * @return A boolean that indicates if the operation was successful.
360    */
361   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
362     totalSupply_ = totalSupply_.add(_amount);
363     balances[_to] = balances[_to].add(_amount);
364     emit Mint(_to, _amount);
365     emit Transfer(address(0), _to, _amount);
366     return true;
367   }
368 
369   /**
370    * @dev Function to stop minting new tokens.
371    * @return True if the operation was successful.
372    */
373   function finishMinting() onlyOwner canMint public returns (bool) {
374     mintingFinished = true;
375     emit MintFinished();
376     return true;
377   }
378 }
379 
380 // File: contracts/lib/Crowdsale.sol
381 
382 /**
383  * @title Crowdsale - modified from zeppelin-solidity library
384  * @dev Crowdsale is a base contract for managing a token crowdsale.
385  * Crowdsales have a start and end timestamps, where investors can make
386  * token purchases and the crowdsale will assign them tokens based
387  * on a token per ETH rate. Funds collected are forwarded to a wallet
388  * as they arrive.
389  */
390 contract Crowdsale {
391     using SafeMath for uint256;
392 
393     // The token being sold
394     MintableToken public tokenOnSale;
395 
396     // start and end timestamps where investments are allowed (both inclusive)
397     uint256 public startTime;
398     uint256 public endTime;
399 
400     // address where funds are collected
401     address public wallet;
402 
403     // how many token units a buyer gets per wei
404     uint256 public rate;
405 
406     // amount of raised money in wei
407     uint256 public weiRaised;
408 
409 
410     // event for token purchase logging
411     // purchaser who paid for the tokens
412     // beneficiary who got the tokens
413     // value weis paid for purchase
414     // amount amount of tokens purchased
415     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
416 
417     function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
418         require(
419             startTime == 0 && endTime == 0 && rate == 0 && wallet == address(0),
420             "Global variables must be empty when initializing crowdsale!"
421         );
422         require(_startTime >= now, "_startTime must be more than current time!");
423         require(_endTime >= _startTime, "_endTime must be more than _startTime!");
424         require(_wallet != address(0), "_wallet parameter must not be empty!");
425 
426         startTime = _startTime;
427         endTime = _endTime;
428         rate = _rate;
429         wallet = _wallet;
430     }
431 
432     // @return true if crowdsale event has ended
433     function hasEnded() public view returns (bool) {
434         return now > endTime;
435     }
436 
437     // send ether to the fund collection wallet
438     // override to create custom fund forwarding mechanisms
439     function forwardFunds() internal {
440         wallet.transfer(msg.value);
441     }
442 }
443 
444 // File: contracts/lib/FinalizableCrowdsale.sol
445 
446 /**
447  * @title FinalizableCrowdsale
448  * @dev Extension of Crowdsale where an owner can do extra work
449  * after finishing.
450  */
451 contract FinalizableCrowdsale is Crowdsale, Ownable {
452   using SafeMath for uint256;
453 
454   bool public isFinalized = false;
455 
456   event Finalized();
457 
458   /**
459    * @dev Must be called after crowdsale ends, to do some extra finalization
460    * work. Calls the contract's finalization function.
461    */
462   function finalize() onlyOwner public {
463     require(!isFinalized);
464     require(hasEnded());
465 
466     finalization();
467     emit Finalized();
468 
469     isFinalized = true;
470   }
471 
472   /**
473    * @dev Can be overridden to add finalization logic. The overriding function
474    * should call super.finalization() to ensure the chain of finalization is
475    * executed entirely.
476    */
477   function finalization() internal {
478   }
479 }
480 
481 // File: contracts/lib/PausableToken.sol
482 
483 /**
484  * @title Pausable token
485  * @dev StandardToken modified with pausable transfers.
486  **/
487 contract PausableToken is StandardToken, Pausable {
488 
489   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
494     return super.transferFrom(_from, _to, _value);
495   }
496 
497   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
502     return super.increaseApproval(_spender, _addedValue);
503   }
504 
505   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 
510 // File: contracts/CompanyToken.sol
511 
512 /**
513  * @title CompanyToken contract - ERC20 compatible token contract with customized token parameters.
514  * @author Gustavo Guimaraes - <gustavo@starbase.co>
515  */
516 contract CompanyToken is PausableToken, MintableToken {
517     string public name;
518     string public symbol;
519     uint8 public decimals;
520 
521     /**
522      * @dev Contract constructor function
523      * @param _name Token name
524      * @param _symbol Token symbol - up to 4 characters
525      * @param _decimals Decimals for token
526      */
527     constructor(string _name, string _symbol, uint8 _decimals) public {
528         name = _name;
529         symbol = _symbol;
530         decimals = _decimals;
531 
532         pause();
533     }
534 }
535 
536 // File: contracts/Whitelist.sol
537 
538 /**
539  * @title Whitelist - crowdsale whitelist contract
540  * @author Gustavo Guimaraes - <gustavo@starbase.co>
541  */
542 contract Whitelist is Ownable {
543     mapping(address => bool) public allowedAddresses;
544 
545     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
546 
547     /**
548     * @dev Adds single address to whitelist.
549     * @param _address Address to be added to the whitelist
550     */
551     function addToWhitelist(address _address) external onlyOwner {
552         allowedAddresses[_address] = true;
553         emit WhitelistUpdated(now, "Added", _address);
554     }
555 
556     /**
557      * @dev add various whitelist addresses
558      * @param _addresses Array of ethereum addresses
559      */
560     function addManyToWhitelist(address[] _addresses) external onlyOwner {
561         for (uint256 i = 0; i < _addresses.length; i++) {
562             allowedAddresses[_addresses[i]] = true;
563             emit WhitelistUpdated(now, "Added", _addresses[i]);
564         }
565     }
566 
567     /**
568      * @dev remove whitelist addresses
569      * @param _addresses Array of ethereum addresses
570      */
571     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
572         for (uint256 i = 0; i < _addresses.length; i++) {
573             allowedAddresses[_addresses[i]] = false;
574             emit WhitelistUpdated(now, "Removed", _addresses[i]);
575         }
576     }
577 }
578 
579 // File: contracts/TokenSaleInterface.sol
580 
581 /**
582  * @title TokenSale contract interface
583  */
584 interface TokenSaleInterface {
585     function init
586     (
587         uint256 _startTime,
588         uint256 _endTime,
589         address _whitelist,
590         address _starToken,
591         address _companyToken,
592         uint256 _rate,
593         uint256 _starRate,
594         address _wallet,
595         uint256 _crowdsaleCap,
596         bool    _isWeiAccepted
597     )
598     external;
599 }
600 
601 // File: contracts/TokenSale.sol
602 
603 /**
604  * @title Token Sale contract - crowdsale of company tokens.
605  * @author Gustavo Guimaraes - <gustavo@starbase.co>
606  */
607 contract TokenSale is FinalizableCrowdsale, Pausable {
608     uint256 public crowdsaleCap;
609     // amount of raised money in STAR
610     uint256 public starRaised;
611     uint256 public starRate;
612     address public initialTokenOwner;
613     bool public isWeiAccepted;
614 
615     // external contracts
616     Whitelist public whitelist;
617     StandardToken public starToken;
618 
619     event TokenRateChanged(uint256 previousRate, uint256 newRate);
620     event TokenStarRateChanged(uint256 previousStarRate, uint256 newStarRate);
621     event TokenPurchaseWithStar(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
622 
623     /**
624      * @dev initialization function
625      * @param _startTime The timestamp of the beginning of the crowdsale
626      * @param _endTime Timestamp when the crowdsale will finish
627      * @param _whitelist contract containing the whitelisted addresses
628      * @param _starToken STAR token contract address
629      * @param _companyToken ERC20 CompanyToken contract address
630      * @param _rate The token rate per ETH
631      * @param _starRate The token rate per STAR
632      * @param _wallet Multisig wallet that will hold the crowdsale funds.
633      * @param _crowdsaleCap Cap for the token sale
634      * @param _isWeiAccepted Bool for acceptance of ether in token sale
635      */
636     function init(
637         uint256 _startTime,
638         uint256 _endTime,
639         address _whitelist,
640         address _starToken,
641         address _companyToken,
642         uint256 _rate,
643         uint256 _starRate,
644         address _wallet,
645         uint256 _crowdsaleCap,
646         bool    _isWeiAccepted
647     )
648         external
649     {
650         require(
651             whitelist == address(0) &&
652             starToken == address(0) &&
653             rate == 0 &&
654             starRate == 0 &&
655             tokenOnSale == address(0) &&
656             crowdsaleCap == 0,
657             "Global variables should not have been set before!"
658         );
659 
660         require(
661             _whitelist != address(0) &&
662             _starToken != address(0) &&
663             !(_rate == 0 && _starRate == 0) &&
664             _companyToken != address(0) &&
665             _crowdsaleCap != 0,
666             "Parameter variables cannot be empty!"
667         );
668 
669         initCrowdsale(_startTime, _endTime, _rate, _wallet);
670         tokenOnSale = CompanyToken(_companyToken);
671         whitelist = Whitelist(_whitelist);
672         starToken = StandardToken(_starToken);
673         starRate = _starRate;
674         isWeiAccepted = _isWeiAccepted;
675         owner = tx.origin;
676 
677         initialTokenOwner = CompanyToken(tokenOnSale).owner();
678         uint256 tokenDecimals = CompanyToken(tokenOnSale).decimals();
679         crowdsaleCap = _crowdsaleCap.mul(10 ** tokenDecimals);
680 
681         require(CompanyToken(tokenOnSale).paused(), "Company token must be paused upon initialization!");
682     }
683 
684     modifier isWhitelisted(address beneficiary) {
685         require(whitelist.allowedAddresses(beneficiary), "Beneficiary not whitelisted!");
686         _;
687     }
688 
689     modifier crowdsaleIsTokenOwner() {
690         require(tokenOnSale.owner() == address(this), "The token owner must be contract address!");
691         _;
692     }
693 
694     /**
695      * @dev override fallback function. cannot use it
696      */
697     function () external payable {
698         revert("No fallback function defined!");
699     }
700 
701     /**
702      * @dev change crowdsale ETH rate
703      * @param newRate Figure that corresponds to the new ETH rate per token
704      */
705     function setRate(uint256 newRate) external onlyOwner {
706         require(newRate != 0, "ETH rate must be more than 0");
707 
708         emit TokenRateChanged(rate, newRate);
709         rate = newRate;
710     }
711 
712     /**
713      * @dev change crowdsale STAR rate
714      * @param newStarRate Figure that corresponds to the new STAR rate per token
715      */
716     function setStarRate(uint256 newStarRate) external onlyOwner {
717         require(newStarRate != 0, "Star rate must be more than 0!");
718 
719         emit TokenStarRateChanged(starRate, newStarRate);
720         starRate = newStarRate;
721     }
722 
723     /**
724      * @dev allows sale to receive wei or not
725      */
726     function setIsWeiAccepted(bool _isWeiAccepted) external onlyOwner {
727         require(rate != 0, "When accepting Wei you need to set a conversion rate!");
728         isWeiAccepted = _isWeiAccepted;
729     }
730 
731     /**
732      * @dev function that allows token purchases with STAR
733      * @param beneficiary Address of the purchaser
734      */
735     function buyTokens(address beneficiary)
736         public
737         payable
738         whenNotPaused
739         isWhitelisted(beneficiary)
740         crowdsaleIsTokenOwner
741     {
742         require(beneficiary != address(0));
743         require(validPurchase() && tokenOnSale.totalSupply() < crowdsaleCap);
744 
745         if (!isWeiAccepted) {
746             require(msg.value == 0);
747         } else if (msg.value > 0) {
748             buyTokensWithWei(beneficiary);
749         }
750 
751         // beneficiary must allow TokenSale address to transfer star tokens on its behalf
752         uint256 starAllocationToTokenSale = starToken.allowance(beneficiary, this);
753         if (starAllocationToTokenSale > 0) {
754             // calculate token amount to be created
755             uint256 tokens = starAllocationToTokenSale.mul(starRate);
756 
757             //remainder logic
758             if (tokenOnSale.totalSupply().add(tokens) > crowdsaleCap) {
759                 tokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
760 
761                 starAllocationToTokenSale = tokens.div(starRate);
762             }
763 
764             // update state
765             starRaised = starRaised.add(starAllocationToTokenSale);
766 
767             tokenOnSale.mint(beneficiary, tokens);
768             emit TokenPurchaseWithStar(msg.sender, beneficiary, starAllocationToTokenSale, tokens);
769 
770             // forward funds
771             starToken.transferFrom(beneficiary, wallet, starAllocationToTokenSale);
772         }
773     }
774 
775     /**
776      * @dev function that allows token purchases with Wei
777      * @param beneficiary Address of the purchaser
778      */
779     function buyTokensWithWei(address beneficiary)
780         internal
781     {
782         uint256 weiAmount = msg.value;
783         uint256 weiRefund = 0;
784 
785         // calculate token amount to be created
786         uint256 tokens = weiAmount.mul(rate);
787 
788         //remainder logic
789         if (tokenOnSale.totalSupply().add(tokens) > crowdsaleCap) {
790             tokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
791             weiAmount = tokens.div(rate);
792 
793             weiRefund = msg.value.sub(weiAmount);
794         }
795 
796         // update state
797         weiRaised = weiRaised.add(weiAmount);
798 
799         tokenOnSale.mint(beneficiary, tokens);
800         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
801 
802         wallet.transfer(weiAmount);
803         if (weiRefund > 0) {
804             msg.sender.transfer(weiRefund);
805         }
806     }
807 
808     // override Crowdsale#hasEnded to add cap logic
809     // @return true if crowdsale event has ended
810     function hasEnded() public view returns (bool) {
811         if (tokenOnSale.totalSupply() >= crowdsaleCap) {
812             return true;
813         }
814 
815         return super.hasEnded();
816     }
817 
818     /**
819      * @dev override Crowdsale#validPurchase
820      * @return true if the transaction can buy tokens
821      */
822     function validPurchase() internal view returns (bool) {
823         return now >= startTime && now <= endTime;
824     }
825 
826     /**
827      * @dev finalizes crowdsale
828      */
829     function finalization() internal {
830         if (crowdsaleCap > tokenOnSale.totalSupply()) {
831             uint256 remainingTokens = crowdsaleCap.sub(tokenOnSale.totalSupply());
832 
833             tokenOnSale.mint(wallet, remainingTokens);
834         }
835 
836         tokenOnSale.transferOwnership(initialTokenOwner);
837         super.finalization();
838     }
839 }