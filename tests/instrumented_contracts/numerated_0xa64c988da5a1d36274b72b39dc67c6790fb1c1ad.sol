1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     emit Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     emit Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 /**
254  * @title Pausable
255  * @dev Base contract which allows children to implement an emergency stop mechanism.
256  */
257 contract Pausable is Ownable {
258   event Pause();
259   event Unpause();
260 
261   bool public paused = false;
262 
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is not paused.
266    */
267   modifier whenNotPaused() {
268     require(!paused);
269     _;
270   }
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is paused.
274    */
275   modifier whenPaused() {
276     require(paused);
277     _;
278   }
279 
280   /**
281    * @dev called by the owner to pause, triggers stopped state
282    */
283   function pause() onlyOwner whenNotPaused public {
284     paused = true;
285     emit Pause();
286   }
287 
288   /**
289    * @dev called by the owner to unpause, returns to normal state
290    */
291   function unpause() onlyOwner whenPaused public {
292     paused = false;
293     emit Unpause();
294   }
295 }
296 
297 
298 contract ufoodoToken is StandardToken, Ownable {
299     using SafeMath for uint256;
300 
301     // Token where will be stored and managed
302     address public vault = this;
303 
304     string public name = "ufoodo Token";
305     string public symbol = "UFT";
306     uint8 public decimals = 18;
307 
308     // Total Supply DAICO: 500,000,000 UFT
309     uint256 public INITIAL_SUPPLY = 500000000 * (10**uint256(decimals));
310     // 400,000,000 UFT for DAICO at Q4 2018
311     uint256 public supplyDAICO = INITIAL_SUPPLY.mul(80).div(100);
312 
313     address public salesAgent;
314     mapping (address => bool) public owners;
315 
316     event SalesAgentPermissionsTransferred(address indexed previousSalesAgent, address indexed newSalesAgent);
317     event SalesAgentRemoved(address indexed currentSalesAgent);
318 
319     // 100,000,000 Seed UFT
320     function supplySeed() public view returns (uint256) {
321         uint256 _supplySeed = INITIAL_SUPPLY.mul(20).div(100);
322         return _supplySeed;
323     }
324     // Constructor
325     function ufoodoToken() public {
326         totalSupply_ = INITIAL_SUPPLY;
327         balances[msg.sender] = INITIAL_SUPPLY;
328         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
329     }
330     // Transfer sales agent permissions to another account
331     function transferSalesAgentPermissions(address _salesAgent) onlyOwner public {
332         emit SalesAgentPermissionsTransferred(salesAgent, _salesAgent);
333         salesAgent = _salesAgent;
334     }
335 
336     // Remove sales agent from token
337     function removeSalesAgent() onlyOwner public {
338         emit SalesAgentRemoved(salesAgent);
339         salesAgent = address(0);
340     }
341 
342     function transferFromVault(address _from, address _to, uint256 _amount) public {
343         require(salesAgent == msg.sender);
344         balances[vault] = balances[vault].sub(_amount);
345         balances[_to] = balances[_to].add(_amount);
346         emit Transfer(_from, _to, _amount);
347     }
348 
349     // Lock the DAICO supply until 2018-09-01 14:00:00
350     // Which can then transferred to the created DAICO contract
351     function transferDaico(address _to) public onlyOwner returns(bool) {
352         require(now >= 1535810400);
353 
354         balances[vault] = balances[vault].sub(supplyDAICO);
355         balances[_to] = balances[_to].add(supplyDAICO);
356         emit Transfer(vault, _to, supplyDAICO);
357         return(true);
358     }
359 
360 }
361 
362 contract SeedSale is Ownable, Pausable {
363     using SafeMath for uint256;
364 
365     // Tokens that will be sold
366     ufoodoToken public token;
367 
368     // Time in Unix timestamp
369     // Start: 01-Apr-18 14:00:00 UTC
370     uint256 public constant seedStartTime = 1522591200;
371     // End: 31-May-18 14:00:00 UTC
372     uint256 public constant seedEndTime = 1527775200;
373 
374     uint256 public seedSupply_ = 0;
375 
376     // Update all funds raised that are not validated yet, 140 ether from private sale already added
377     uint256 public fundsRaised = 140 ether;
378 
379     // Update only funds validated, 140 ether from private sale already added
380     uint256 public fundsRaisedFinalized = 140 ether; //
381 
382     // Lock tokens for team
383     uint256 public releasedLockedAmount = 0;
384 
385     // All pending UFT which needs to validated before transfered to contributors
386     uint256 public pendingUFT = 0;
387     // Conclude UFT which are transferred to contributer if soft cap reached and contributor is validated
388     uint256 public concludeUFT = 0;
389 
390     uint256 public constant softCap = 200 ether;
391     uint256 public constant hardCap = 3550 ether;
392     uint256 public constant minContrib = 0.1 ether;
393 
394     uint256 public lockedTeamUFT = 0;
395     uint256 public privateReservedUFT = 0;
396 
397     // Will updated in condition with funds raised finalized
398     bool public SoftCapReached = false;
399     bool public hardCapReached = false;
400     bool public seedSaleFinished = false;
401 
402     //Refund will enabled if seed sale End and min cap not reached
403     bool public refundAllowed = false;
404 
405     // Address where only validated funds will be transfered
406     address public fundWallet = 0xf7d4C80DE0e2978A1C5ef3267F488B28499cD22E;
407 
408     // Amount of ether in wei, needs to be validated first
409     mapping(address => uint256) public weiContributedPending;
410     // Amount of ether in wei validated
411     mapping(address => uint256) public weiContributedConclude;
412     // Amount of UFT which will reserved first until the contributor is validated
413     mapping(address => uint256) public pendingAmountUFT;
414 
415     event OpenTier(uint256 activeTier);
416     event LogContributionPending(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 activeTier, uint256 timestamp);
417     event LogContributionConclude(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 timeStamp);
418     event ValidationFailed(address contributor, uint256 amountWeiRefunded, uint timestamp);
419 
420     // Initialized Tier
421     uint public activeTier = 0;
422 
423     // Max ether per tier to collect
424     uint256[8] public tierCap = [
425         400 ether,
426         420 ether,
427         380 ether,
428         400 ether,
429         410 ether,
430         440 ether,
431         460 ether,
432         500 ether
433     ];
434 
435     // Based on 1 Ether = 12500
436     // Tokenrate + tokenBonus = totalAmount the contributor received
437     uint256[8] public tierTokens = [
438         17500, //40%
439         16875, //35%
440         16250, //30%
441         15625, //25%
442         15000, //20%
443         13750, //10%
444         13125, //5%
445         12500  //0%
446     ];
447 
448     // Will be updated due wei contribution
449     uint256[8] public activeFundRaisedTier = [
450         0,
451         0,
452         0,
453         0,
454         0,
455         0,
456         0,
457         0
458     ];
459 
460     // Constructor
461     function SeedSale(address _vault) public {
462         token = ufoodoToken(_vault);
463         privateReservedUFT = token.supplySeed().mul(4).div(100);
464         lockedTeamUFT = token.supplySeed().mul(20).div(100);
465         seedSupply_ = token.supplySeed();
466     }
467 
468     function seedStarted() public view returns (bool) {
469         return now >= seedStartTime;
470     }
471 
472     function seedEnded() public view returns (bool) {
473         return now >= seedEndTime || fundsRaised >= hardCap;
474     }
475 
476     modifier checkContribution() {
477         require(canContribute());
478         _;
479     }
480 
481     function canContribute() internal view returns(bool) {
482         if(!seedStarted() || seedEnded()) {
483             return false;
484         }
485         if(msg.value < minContrib) {
486             return false;
487         }
488         return true;
489     }
490 
491     // Fallback function
492     function() payable public whenNotPaused {
493         buyUFT(msg.sender);
494     }
495 
496     // Process UFT contribution
497     function buyUFT(address contributor) public whenNotPaused checkContribution payable {
498         uint256 weiAmount = msg.value;
499         uint256 refund = 0;
500         uint256 _tierIndex = activeTier;
501         uint256 _activeTierCap = tierCap[_tierIndex];
502         uint256 _activeFundRaisedTier = activeFundRaisedTier[_tierIndex];
503 
504         require(_activeFundRaisedTier < _activeTierCap);
505 
506         // Checks Amoount of eth still can contributed to the active Tier
507         uint256 tierCapOverSold = _activeTierCap.sub(_activeFundRaisedTier);
508 
509         // if contributer amount will oversold the active tier cap, partial
510         // purchase will proceed, rest contributer amount will refunded to contributor
511         if(tierCapOverSold < weiAmount) {
512             weiAmount = tierCapOverSold;
513             refund = msg.value.sub(weiAmount);
514 
515         }
516         // Calculate the amount of tokens the Contributor will receive
517         uint256 amountUFT = weiAmount.mul(tierTokens[_tierIndex]);
518 
519         // Update status
520         fundsRaised = fundsRaised.add(weiAmount);
521         activeFundRaisedTier[_tierIndex] = activeFundRaisedTier[_tierIndex].add(weiAmount);
522         weiContributedPending[contributor] = weiContributedPending[contributor].add(weiAmount);
523         pendingAmountUFT[contributor] = pendingAmountUFT[contributor].add(amountUFT);
524         pendingUFT = pendingUFT.add(amountUFT);
525 
526         // partial process, refund rest value
527         if(refund > 0) {
528             msg.sender.transfer(refund);
529         }
530 
531         emit LogContributionPending(contributor, weiAmount, amountUFT, _tierIndex, now);
532     }
533 
534     function softCapReached() public returns (bool) {
535         if (fundsRaisedFinalized >= softCap) {
536             SoftCapReached = true;
537             return true;
538         }
539         return false;
540     }
541 
542     // Next Tier will increment manually and Paused by the team to guarantee safe transition
543     // Initialized next tier if previous tier sold out
544     // For contributor safety we pause the seedSale process
545     function nextTier() onlyOwner public {
546         require(paused == true);
547         require(activeTier < 7);
548         uint256 _tierIndex = activeTier;
549         activeTier = _tierIndex +1;
550         emit OpenTier(activeTier);
551     }
552 
553     // Validation Update Process
554     // After we finished the kyc process, we update each validated contributor and transfer if softCapReached the tokens
555     // If the contributor is not validated due failed validation, the contributed wei amount will refundet back to the contributor
556     function validationPassed(address contributor) onlyOwner public returns (bool) {
557         require(contributor != 0x0);
558 
559         uint256 amountFinalized = pendingAmountUFT[contributor];
560         pendingAmountUFT[contributor] = 0;
561         token.transferFromVault(token, contributor, amountFinalized);
562 
563         // Update status
564         uint256 _fundsRaisedFinalized = fundsRaisedFinalized.add(weiContributedPending[contributor]);
565         fundsRaisedFinalized = _fundsRaisedFinalized;
566         concludeUFT = concludeUFT.add(amountFinalized);
567 
568         weiContributedConclude[contributor] = weiContributedConclude[contributor].add(weiContributedPending[contributor]);
569 
570         emit LogContributionConclude(contributor, weiContributedPending[contributor], amountFinalized, now);
571         softCapReached();
572         // Amount finalized tokes update status
573 
574         return true;
575     }
576 
577     // Update which address is not validated
578     // By updating the address, the contributor will receive his contribution back
579     function validationFailed(address contributor) onlyOwner public returns (bool) {
580         require(contributor != 0x0);
581         require(weiContributedPending[contributor] > 0);
582 
583         uint256 currentBalance = weiContributedPending[contributor];
584 
585         weiContributedPending[contributor] = 0;
586         contributor.transfer(currentBalance);
587         emit ValidationFailed(contributor, currentBalance, now);
588         return true;
589     }
590 
591     // If seed sale ends and soft cap is not reached, Contributer can claim their funds
592     function refund() public {
593         require(refundAllowed);
594         require(!SoftCapReached);
595         require(weiContributedPending[msg.sender] > 0);
596 
597         uint256 currentBalance = weiContributedPending[msg.sender];
598 
599         weiContributedPending[msg.sender] = 0;
600         msg.sender.transfer(currentBalance);
601     }
602 
603 
604    // Allows only to refund the contributed amount that passed the validation and reached the softcap
605     function withdrawFunds(uint256 _weiAmount) public onlyOwner {
606         require(SoftCapReached);
607         fundWallet.transfer(_weiAmount);
608     }
609 
610     /*
611      * If tokens left make a priveledge token sale for contributor that are already validated
612      * make a new date time for left tokens only for priveledge whitelisted
613      * If not enouhgt tokens left for a sale send directly to locked contract/ vault
614      */
615     function seedSaleTokenLeft(address _tokenContract) public onlyOwner {
616         require(seedEnded());
617         uint256 amountLeft = pendingUFT.sub(concludeUFT);
618         token.transferFromVault(token, _tokenContract, amountLeft );
619     }
620 
621 
622     function vestingToken(address _beneficiary) public onlyOwner returns (bool) {
623       require(SoftCapReached);
624       uint256 release_1 = seedStartTime.add(180 days);
625       uint256 release_2 = release_1.add(180 days);
626       uint256 release_3 = release_2.add(180 days);
627       uint256 release_4 = release_3.add(180 days);
628 
629       //20,000,000 UFT total splitted in 4 time periods
630       uint256 lockedAmount_1 = lockedTeamUFT.mul(25).div(100);
631       uint256 lockedAmount_2 = lockedTeamUFT.mul(25).div(100);
632       uint256 lockedAmount_3 = lockedTeamUFT.mul(25).div(100);
633       uint256 lockedAmount_4 = lockedTeamUFT.mul(25).div(100);
634 
635       if(seedStartTime >= release_1 && releasedLockedAmount < lockedAmount_1) {
636         token.transferFromVault(token, _beneficiary, lockedAmount_1 );
637         releasedLockedAmount = releasedLockedAmount.add(lockedAmount_1);
638         return true;
639 
640       } else if(seedStartTime >= release_2 && releasedLockedAmount < lockedAmount_2.mul(2)) {
641         token.transferFromVault(token, _beneficiary, lockedAmount_2 );
642         releasedLockedAmount = releasedLockedAmount.add(lockedAmount_2);
643         return true;
644 
645       } else if(seedStartTime >= release_3 && releasedLockedAmount < lockedAmount_3.mul(3)) {
646         token.transferFromVault(token, _beneficiary, lockedAmount_3 );
647         releasedLockedAmount = releasedLockedAmount.add(lockedAmount_3);
648         return true;
649 
650       } else if(seedStartTime >= release_4 && releasedLockedAmount < lockedAmount_4.mul(4)) {
651         token.transferFromVault(token, _beneficiary, lockedAmount_4 );
652         releasedLockedAmount = releasedLockedAmount.add(lockedAmount_4);
653         return true;
654       }
655 
656     }
657 
658     // Total Reserved from Private Sale Contributor 4,000,000 UFT
659     function transferPrivateReservedUFT(address _beneficiary, uint256 _amount) public onlyOwner {
660         require(SoftCapReached);
661         require(_amount > 0);
662         require(privateReservedUFT >= _amount);
663 
664         token.transferFromVault(token, _beneficiary, _amount);
665         privateReservedUFT = privateReservedUFT.sub(_amount);
666 
667     }
668 
669      function finalizeSeedSale() public onlyOwner {
670         if(seedStartTime >= seedEndTime && SoftCapReached) {
671 
672         // Bounty Campaign: 5,000,000 UFT
673         uint256 bountyAmountUFT = token.supplySeed().mul(5).div(100);
674         token.transferFromVault(token, fundWallet, bountyAmountUFT);
675 
676         // Reserved Company: 20,000,000 UFT
677         uint256 reservedCompanyUFT = token.supplySeed().mul(20).div(100);
678         token.transferFromVault(token, fundWallet, reservedCompanyUFT);
679 
680         } else if(seedStartTime >= seedEndTime && !SoftCapReached) {
681 
682             // Enable fund`s crowdsale refund if soft cap is not reached
683             refundAllowed = true;
684 
685             token.transferFromVault(token, owner, seedSupply_);
686             seedSupply_ = 0;
687 
688         }
689     }
690 
691 }