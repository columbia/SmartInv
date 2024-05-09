1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "./LetsbetToken.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "./StandardToken.sol" : start
18  *************************************************************************/
19 
20 /*************************************************************************
21  * import "./BasicToken.sol" : start
22  *************************************************************************/
23 
24 
25 /*************************************************************************
26  * import "./ERC20Basic.sol" : start
27  *************************************************************************/
28 
29 
30 /**
31  * @title ERC20Basic
32  * @dev Simpler version of ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/179
34  */
35 contract ERC20Basic {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 /*************************************************************************
42  * import "./ERC20Basic.sol" : end
43  *************************************************************************/
44 /*************************************************************************
45  * import "../../math/SafeMath.sol" : start
46  *************************************************************************/
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, throws on overflow.
57   */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62     uint256 c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   /**
78   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 /*************************************************************************
95  * import "../../math/SafeMath.sol" : end
96  *************************************************************************/
97 
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   uint256 totalSupply_;
109 
110   /**
111   * @dev total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 /*************************************************************************
144  * import "./BasicToken.sol" : end
145  *************************************************************************/
146 /*************************************************************************
147  * import "./ERC20.sol" : start
148  *************************************************************************/
149 
150 
151 
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public view returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 /*************************************************************************
164  * import "./ERC20.sol" : end
165  *************************************************************************/
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 /*************************************************************************
263  * import "./StandardToken.sol" : end
264  *************************************************************************/
265 /*************************************************************************
266  * import "../../lifecycle/Pausable.sol" : start
267  *************************************************************************/
268 
269 
270 /*************************************************************************
271  * import "../ownership/Ownable.sol" : start
272  *************************************************************************/
273 
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286 
287   /**
288    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289    * account.
290    */
291   function Ownable() public {
292     owner = msg.sender;
293   }
294 
295   /**
296    * @dev Throws if called by any account other than the owner.
297    */
298   modifier onlyOwner() {
299     require(msg.sender == owner);
300     _;
301   }
302 
303   /**
304    * @dev Allows the current owner to transfer control of the contract to a newOwner.
305    * @param newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address newOwner) public onlyOwner {
308     require(newOwner != address(0));
309     OwnershipTransferred(owner, newOwner);
310     owner = newOwner;
311   }
312 
313 }
314 /*************************************************************************
315  * import "../ownership/Ownable.sol" : end
316  *************************************************************************/
317 
318 
319 /**
320  * @title Pausable
321  * @dev Base contract which allows children to implement an emergency stop mechanism.
322  */
323 contract Pausable is Ownable {
324   event Pause();
325   event Unpause();
326 
327   bool public paused = false;
328 
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is not paused.
332    */
333   modifier whenNotPaused() {
334     require(!paused);
335     _;
336   }
337 
338   /**
339    * @dev Modifier to make a function callable only when the contract is paused.
340    */
341   modifier whenPaused() {
342     require(paused);
343     _;
344   }
345 
346   /**
347    * @dev called by the owner to pause, triggers stopped state
348    */
349   function pause() onlyOwner whenNotPaused public {
350     paused = true;
351     Pause();
352   }
353 
354   /**
355    * @dev called by the owner to unpause, returns to normal state
356    */
357   function unpause() onlyOwner whenPaused public {
358     paused = false;
359     Unpause();
360   }
361 }
362 /*************************************************************************
363  * import "../../lifecycle/Pausable.sol" : end
364  *************************************************************************/
365 
366 
367 /**
368  * @title Pausable token
369  * @dev StandardToken modified with pausable transfers.
370  **/
371 contract PausableToken is StandardToken, Pausable {
372 
373   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
374     return super.transfer(_to, _value);
375   }
376 
377   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
378     return super.transferFrom(_from, _to, _value);
379   }
380 
381   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
382     return super.approve(_spender, _value);
383   }
384 
385   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
386     return super.increaseApproval(_spender, _addedValue);
387   }
388 
389   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
390     return super.decreaseApproval(_spender, _subtractedValue);
391   }
392 }
393 /*************************************************************************
394  * import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol" : end
395  *************************************************************************/
396 /*************************************************************************
397  * import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol" : start
398  *************************************************************************/
399 
400 
401 
402 
403 /**
404  * @title Burnable Token
405  * @dev Token that can be irreversibly burned (destroyed).
406  */
407 contract BurnableToken is BasicToken {
408 
409   event Burn(address indexed burner, uint256 value);
410 
411   /**
412    * @dev Burns a specific amount of tokens.
413    * @param _value The amount of token to be burned.
414    */
415   function burn(uint256 _value) public {
416     require(_value <= balances[msg.sender]);
417     // no need to require value <= totalSupply, since that would imply the
418     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
419 
420     address burner = msg.sender;
421     balances[burner] = balances[burner].sub(_value);
422     totalSupply_ = totalSupply_.sub(_value);
423     Burn(burner, _value);
424   }
425 }
426 /*************************************************************************
427  * import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol" : end
428  *************************************************************************/
429 
430 
431 /**
432  * @title LetsbetToken Token
433  * @dev ERC20 LetsbetToken Token (XBET)
434  */
435 contract LetsbetToken is PausableToken, BurnableToken {
436 
437     string public constant name = "Letsbet Token";
438     string public constant symbol = "XBET";
439     uint8 public constant decimals = 18;
440 
441     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**uint256(decimals); // 100 000 000 (100m)
442     uint256 public constant TEAM_TOKENS = 18000000 * 10**uint256(decimals); // 18 000 000 (18m)
443     uint256 public constant BOUNTY_TOKENS = 5000000 * 10**uint256(decimals); // 5 000 000 (5m)
444     uint256 public constant AUCTION_TOKENS = 77000000 * 10**uint256(decimals); // 77 000 000 (77m)
445 
446     event Deployed(uint indexed _totalSupply);
447 
448     /**
449     * @dev LetsbetToken Constructor
450     */
451     function LetsbetToken(
452         address auctionAddress,
453         address walletAddress,
454         address bountyAddress)
455         public
456     {
457 
458         require(auctionAddress != 0x0);
459         require(walletAddress != 0x0);
460         require(bountyAddress != 0x0);
461         
462         totalSupply_ = INITIAL_SUPPLY;
463 
464         balances[auctionAddress] = AUCTION_TOKENS;
465         balances[walletAddress] = TEAM_TOKENS;
466         balances[bountyAddress] = BOUNTY_TOKENS;
467 
468         Transfer(0x0, auctionAddress, balances[auctionAddress]);
469         Transfer(0x0, walletAddress, balances[walletAddress]);
470         Transfer(0x0, bountyAddress, balances[bountyAddress]);
471 
472         Deployed(totalSupply_);
473         assert(totalSupply_ == balances[auctionAddress] + balances[walletAddress] + balances[bountyAddress]);
474     }
475 }/*************************************************************************
476  * import "./LetsbetToken.sol" : end
477  *************************************************************************/
478 
479 /// @title Dutch auction contract - distribution of a fixed number of tokens using an auction.
480 /// The contract code is inspired by the Gnosis and Raiden auction contract. Main difference is that the
481 /// auction ends if a fixed number of tokens was sold.
482 contract DutchAuction {
483     
484 	/*
485      * Auction for the XBET Token.
486      */
487     // Wait 7 days after the end of the auction, before anyone can claim tokens
488     uint constant public TOKEN_CLAIM_WAITING_PERIOD = 7 days;
489 
490     LetsbetToken public token;
491     address public ownerAddress;
492     address public walletAddress;
493 
494     // Starting price in WEI
495     uint public startPrice;
496 
497     // Divisor constant; e.g. 180000000
498     uint public priceDecreaseRate;
499 
500     // For calculating elapsed time for price
501     uint public startTime;
502 
503     uint public endTimeOfBids;
504 
505     // When auction was finalized
506     uint public finalizedTime;
507     uint public startBlock;
508 
509     // Keep track of all ETH received in the bids
510     uint public receivedWei;
511 
512     // Keep track of cumulative ETH funds for which the tokens have been claimed
513     uint public fundsClaimed;
514 
515     uint public tokenMultiplier;
516 
517     // Total number of Rei (XBET * tokenMultiplier) that will be auctioned
518     uint public tokensAuctioned;
519 
520     // Wei per XBET
521     uint public finalPrice;
522 
523     // Bidder address => bid value
524     mapping (address => uint) public bids;
525 
526 
527     Stages public stage;
528 
529     /*
530      * Enums
531      */
532     enum Stages {
533         AuctionDeployed,
534         AuctionSetUp,
535         AuctionStarted,
536         AuctionEnded,
537         TokensDistributed
538     }
539 
540     /*
541      * Modifiers
542      */
543     modifier atStage(Stages _stage) {
544         require(stage == _stage);
545         _;
546     }
547 
548     modifier isOwner() {
549         require(msg.sender == ownerAddress);
550         _;
551     }
552 	
553     /*
554      * Events
555      */
556     event Deployed(
557         uint indexed _startPrice,
558         uint indexed _priceDecreaseRate
559     );
560     
561 	event Setup();
562     
563 	event AuctionStarted(uint indexed _startTime, uint indexed _blockNumber);
564     
565 	event BidSubmission(
566         address indexed sender,
567         uint amount,
568         uint missingFunds,
569         uint timestamp
570     );
571     
572 	event ClaimedTokens(address indexed _recipient, uint _sentAmount);
573     
574 	event AuctionEnded(uint _finalPrice);
575     
576 	event TokensDistributed();
577 
578     /// @dev Contract constructor function sets the starting price, divisor constant and
579     /// divisor exponent for calculating the Dutch Auction price.
580     /// @param _walletAddress Wallet address to which all contributed ETH will be forwarded.
581     /// @param _startPrice High price in WEI at which the auction starts.
582     /// @param _priceDecreaseRate Auction price decrease rate.
583     /// @param _endTimeOfBids last time bids could be accepted.
584     function DutchAuction(
585         address _walletAddress,
586         uint _startPrice,
587         uint _priceDecreaseRate,
588         uint _endTimeOfBids) 
589     public
590     {
591         require(_walletAddress != 0x0);
592         walletAddress = _walletAddress;
593 
594         ownerAddress = msg.sender;
595         stage = Stages.AuctionDeployed;
596         changeSettings(_startPrice, _priceDecreaseRate,_endTimeOfBids);
597         Deployed(_startPrice, _priceDecreaseRate);
598     }
599 
600     function () public payable atStage(Stages.AuctionStarted) {
601         bid();
602     }
603 
604     /// @notice Set `_tokenAddress` as the token address to be used in the auction.
605     /// @dev Setup function sets external contracts addresses.
606     /// @param _tokenAddress Token address.
607     function setup(address _tokenAddress) public isOwner atStage(Stages.AuctionDeployed) {
608         require(_tokenAddress != 0x0);
609         token = LetsbetToken(_tokenAddress);
610 
611         // Get number of Rei (XBET * tokenMultiplier) to be auctioned from token auction balance
612         tokensAuctioned = token.balanceOf(address(this));
613 
614         // Set the number of the token multiplier for its decimals
615         tokenMultiplier = 10 ** uint(token.decimals());
616 
617         stage = Stages.AuctionSetUp;
618         Setup();
619     }
620 
621     /// @dev Changes auction price function parameters before auction is started.
622     /// @param _startPrice Updated start price.
623     /// @param _priceDecreaseRate Updated price decrease rate.
624     function changeSettings(
625         uint _startPrice,
626         uint _priceDecreaseRate,
627         uint _endTimeOfBids
628         )
629         internal
630     {
631         require(stage == Stages.AuctionDeployed || stage == Stages.AuctionSetUp);
632         require(_startPrice > 0);
633         require(_priceDecreaseRate > 0);
634         require(_endTimeOfBids > now);
635         
636         endTimeOfBids = _endTimeOfBids;
637         startPrice = _startPrice;
638         priceDecreaseRate = _priceDecreaseRate;
639     }
640 
641 
642     /// @notice Start the auction.
643     /// @dev Starts auction and sets startTime.
644     function startAuction() public isOwner atStage(Stages.AuctionSetUp) {
645         stage = Stages.AuctionStarted;
646         startTime = now;
647         startBlock = block.number;
648         AuctionStarted(startTime, startBlock);
649     }
650 
651     /// @notice Finalize the auction - sets the final XBET token price and changes the auction
652     /// stage after no bids are allowed anymore.
653     /// @dev Finalize auction and set the final XBET token price.
654     function finalizeAuction() public isOwner atStage(Stages.AuctionStarted) {
655         // Missing funds should be 0 at this point
656         uint missingFunds = missingFundsToEndAuction();
657         require(missingFunds == 0 || now > endTimeOfBids);
658 
659         // Calculate the final price = WEI / XBET = WEI / (Rei / tokenMultiplier)
660         // Reminder: tokensAuctioned is the number of Rei (XBET * tokenMultiplier) that are auctioned
661         finalPrice = tokenMultiplier * receivedWei / tokensAuctioned;
662 
663         finalizedTime = now;
664         stage = Stages.AuctionEnded;
665         AuctionEnded(finalPrice);
666 
667         assert(finalPrice > 0);
668     }
669 
670     /// --------------------------------- Auction Functions ------------------
671 
672 
673     /// @notice Send `msg.value` WEI to the auction from the `msg.sender` account.
674     /// @dev Allows to send a bid to the auction.
675     function bid()
676         public
677         payable
678         atStage(Stages.AuctionStarted)
679     {
680         require(msg.value > 0);
681         assert(bids[msg.sender] + msg.value >= msg.value);
682 
683         // Missing funds without the current bid value
684         uint missingFunds = missingFundsToEndAuction();
685 
686         // We require bid values to be less than the funds missing to end the auction
687         // at the current price.
688         require(msg.value <= missingFunds);
689 
690         bids[msg.sender] += msg.value;
691         receivedWei += msg.value;
692 
693         // Send bid amount to wallet
694         walletAddress.transfer(msg.value);
695 
696         BidSubmission(msg.sender, msg.value, missingFunds,block.timestamp);
697 
698         assert(receivedWei >= msg.value);
699     }
700 
701     /// @notice Claim auction tokens for `msg.sender` after the auction has ended.
702     /// @dev Claims tokens for `msg.sender` after auction. To be used if tokens can
703     /// be claimed by beneficiaries, individually.
704     function claimTokens() public atStage(Stages.AuctionEnded) returns (bool) {
705         return proxyClaimTokens(msg.sender);
706     }
707 
708     /// @notice Claim auction tokens for `receiverAddress` after the auction has ended.
709     /// @dev Claims tokens for `receiverAddress` after auction has ended.
710     /// @param receiverAddress Tokens will be assigned to this address if eligible.
711     function proxyClaimTokens(address receiverAddress)
712         public
713         atStage(Stages.AuctionEnded)
714         returns (bool)
715     {
716         // Waiting period after the end of the auction, before anyone can claim tokens
717         // Ensures enough time to check if auction was finalized correctly
718         // before users start transacting tokens
719         require(now > finalizedTime + TOKEN_CLAIM_WAITING_PERIOD);
720         require(receiverAddress != 0x0);
721 
722         if (bids[receiverAddress] == 0) {
723             return false;
724         }
725 
726         uint num = (tokenMultiplier * bids[receiverAddress]) / finalPrice;
727 
728         // Due to finalPrice floor rounding, the number of assigned tokens may be higher
729         // than expected. Therefore, the number of remaining unassigned auction tokens
730         // may be smaller than the number of tokens needed for the last claimTokens call
731         uint auctionTokensBalance = token.balanceOf(address(this));
732         if (num > auctionTokensBalance) {
733             num = auctionTokensBalance;
734         }
735 
736         // Update the total amount of funds for which tokens have been claimed
737         fundsClaimed += bids[receiverAddress];
738 
739         // Set receiver bid to 0 before assigning tokens
740         bids[receiverAddress] = 0;
741 
742         require(token.transfer(receiverAddress, num));
743 
744         ClaimedTokens(receiverAddress, num);
745 
746         // After the last tokens are claimed, we change the auction stage
747         // Due to the above logic, rounding errors will not be an issue
748         if (fundsClaimed == receivedWei) {
749             stage = Stages.TokensDistributed;
750             TokensDistributed();
751         }
752 
753         assert(token.balanceOf(receiverAddress) >= num);
754         assert(bids[receiverAddress] == 0);
755         return true;
756     }
757 
758     /// @notice Get the XBET price in WEI during the auction, at the time of
759     /// calling this function. Returns `0` if auction has ended.
760     /// Returns `startPrice` before auction has started.
761     /// @dev Calculates the current XBET token price in WEI.
762     /// @return Returns WEI per XBET (tokenMultiplier * Rei).
763     function price() public constant returns (uint) {
764         if (stage == Stages.AuctionEnded ||
765             stage == Stages.TokensDistributed) {
766             return finalPrice;
767         }
768         return calcTokenPrice();
769     }
770 
771     /// @notice Get the missing funds needed to end the auction,
772     /// calculated at the current XBET price in WEI.
773     /// @dev The missing funds amount necessary to end the auction at the current XBET price in WEI.
774     /// @return Returns the missing funds amount in WEI.
775     function missingFundsToEndAuction() constant public returns (uint) {
776 
777         uint requiredWei = tokensAuctioned * price() / tokenMultiplier;
778         if (requiredWei <= receivedWei) {
779             return 0;
780         }
781 
782         return requiredWei - receivedWei;
783     }
784 
785     /*
786      *  Private functions
787      */
788     /// @dev Calculates the token price (WEI / XBET) at the current timestamp.
789     /// For every new block the price decreases with priceDecreaseRate * numberOfNewBLocks
790     /// @return current price
791     function calcTokenPrice() constant private returns (uint) {
792         uint currentPrice;
793         if (stage == Stages.AuctionStarted) {
794             currentPrice = startPrice - priceDecreaseRate * (block.number - startBlock);
795         }else {
796             currentPrice = startPrice;
797         }
798 
799         return currentPrice;
800     }
801 }