1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 pragma solidity ^0.4.11;
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) onlyOwner public {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 pragma solidity ^0.4.11;
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 pragma solidity ^0.4.11;
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 pragma solidity ^0.4.11;
133 
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) public constant returns (uint256);
141   function transferFrom(address from, address to, uint256 value) public returns (bool);
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 pragma solidity ^0.4.11;
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169 
170     uint256 _allowance = allowed[_from][msg.sender];
171 
172     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
173     // require (_value <= _allowance);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = _allowance.sub(_value);
178     Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    *
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    */
214   function increaseApproval (address _spender, uint _addedValue)
215     returns (bool success) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   function decreaseApproval (address _spender, uint _subtractedValue)
222     returns (bool success) {
223     uint oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue > oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 pragma solidity ^0.4.11;
236 
237 
238 /*****
239 * @title The ICO Contract
240 */
241 contract DadiToken is StandardToken, Ownable {
242     using SafeMath for uint256;
243 
244     /* Public variables of the token */
245     string public name = "DADI";
246     string public symbol = "DADI";
247     uint8 public decimals = 18;
248     string public version = "H1.0";
249 
250     address public owner;
251 
252     uint256 public hundredPercent = 1000;
253     uint256 public foundersPercentOfTotal = 200;
254     uint256 public referralPercentOfTotal = 50;
255     uint256 public ecosystemPercentOfTotal = 25;
256     uint256 public operationsPercentOfTotal = 25;
257 
258     uint256 public investorCount = 0;
259     uint256 public totalRaised; // total ether raised (in wei)
260     uint256 public preSaleRaised = 0; // ether raised (in wei)
261     uint256 public publicSaleRaised = 0; // ether raised (in wei)
262 
263     // PartnerSale variables
264     uint256 public partnerSaleTokensAvailable;
265     uint256 public partnerSaleTokensPurchased = 0;
266     mapping(address => uint256) public purchasedTokens;
267     mapping(address => uint256) public partnerSaleWei;
268 
269     // PreSale variables
270     uint256 public preSaleTokensAvailable;
271     uint256 public preSaleTokensPurchased = 0;
272 
273     // PublicSale variables
274     uint256 public publicSaleTokensAvailable;
275     uint256 public publicSaleTokensPurchased = 0;
276 
277     // Price data
278     uint256 public partnerSaleTokenPrice = 125;     // USD$0.125
279     uint256 public partnerSaleTokenValue;
280     uint256 public preSaleTokenPrice = 250;         // USD$0.25
281     uint256 public publicSaleTokenPrice = 500;       // USD$0.50
282 
283     // ETH to USD Rate, set by owner: 1 ETH = ethRate USD
284     uint256 public ethRate;
285 
286     // Address which will receive raised funds and owns the total supply of tokens
287     address public fundsWallet;
288     address public ecosystemWallet;
289     address public operationsWallet;
290     address public referralProgrammeWallet;
291     address[] public foundingTeamWallets;
292     
293     address[] public partnerSaleWallets;
294     address[] public preSaleWallets;
295     address[] public publicSaleWallets;
296    
297     /*****
298     * State machine
299     *  0 - Preparing:            All contract initialization calls
300     *  1 - PartnerSale:          Contract is in the invite-only PartnerSale Period
301     *  6 - PartnerSaleFinalized: PartnerSale has completed
302     *  2 - PreSale:              Contract is in the PreSale Period
303     *  7 - PreSaleFinalized:     PreSale has completed
304     *  3 - PublicSale:           The public sale of tokens, follows PreSale
305     *  8 - PublicSaleFinalized:  The PublicSale has completed
306     *  4 - Success:              ICO Successful
307     *  5 - Failure:              Minimum funding goal not reached
308     *  9 - Refunding:            Owner can transfer refunds
309     * 10 - Closed:               ICO has finished, all tokens must have been claimed
310     */
311     enum SaleState { Preparing, PartnerSale, PreSale, PublicSale, Success, Failure, PartnerSaleFinalized, PreSaleFinalized, PublicSaleFinalized, Refunding, Closed }
312     SaleState public state = SaleState.Preparing;
313 
314     /**
315     * event for token purchase logging
316     * @param purchaser who paid for the tokens
317     * @param beneficiary who got the tokens
318     * @param value weis paid for purchase
319     * @param tokens amount of tokens purchased
320     */
321     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
322     event LogRedistributeTokens(address recipient, SaleState state, uint256 tokens);
323     event LogRefundProcessed(address recipient, uint256 value);
324     event LogRefundFailed(address recipient, uint256 value);
325     event LogClaimTokens(address recipient, uint256 tokens);
326     event LogFundTransfer(address wallet, uint256 value);
327 
328     /*****
329     * @dev Modifier to check that amount transferred is not 0
330     */
331     modifier nonZero() {
332         require(msg.value != 0);
333         _;
334     }
335 
336     /*****
337     * @dev The constructor function to initialize the token related properties
338     * @param _wallet                        address     Specifies the address of the funding wallet
339     * @param _operationalWallets            address[]   Specifies an array of addresses for [0] ecosystem, [1] operations, [2] referral programme
340     * @param _foundingTeamWallets           address[]   Specifies an array of addresses of the founding team wallets
341     * @param _initialSupply                 uint256     Specifies the total number of tokens available
342     * @param _tokensAvailable               uint256[]   Specifies an array of tokens available for each phase, [0] PartnerSale, [1] PreSale, [2] PublicSale
343     */
344     function DadiToken (
345         address _wallet,
346         address[] _operationalWallets,
347         address[] _foundingTeamWallets,
348         uint256 _initialSupply,
349         uint256[] _tokensAvailable
350     ) public {
351         require(_wallet != address(0));
352 
353         owner = msg.sender;
354  
355         // Token distribution per sale phase
356         partnerSaleTokensAvailable = _tokensAvailable[0];
357         preSaleTokensAvailable = _tokensAvailable[1];
358         publicSaleTokensAvailable = _tokensAvailable[2];
359 
360         // Determine the actual supply using token amount * decimals
361         totalSupply = _initialSupply * (uint256(10) ** decimals);
362 
363         // Give all the initial tokens to the contract owner
364         balances[owner] = totalSupply;
365         Transfer(0x0, owner, totalSupply);
366 
367         // Distribute tokens to the supporting operational wallets
368         ecosystemWallet = _operationalWallets[0];
369         operationsWallet = _operationalWallets[1];
370         referralProgrammeWallet = _operationalWallets[2];
371         foundingTeamWallets = _foundingTeamWallets;
372         fundsWallet = _wallet;
373         
374         // Set a base ETHUSD rate
375         updateEthRate(300000);
376     }
377 
378     /*****
379     * @dev Fallback Function to buy the tokens
380     */
381     function () payable {
382         require(
383             state == SaleState.PartnerSale || 
384             state == SaleState.PreSale || 
385             state == SaleState.PublicSale
386         );
387 
388         buyTokens(msg.sender, msg.value);
389     }
390 
391     /*****
392     * @dev Allows transfer of tokens to a recipient who has purchased offline, during the PartnerSale
393     * @param _recipient     address     The address of the recipient of the tokens
394     * @param _tokens        uint256     The number of tokens purchased by the recipient
395     * @return success       bool        Returns true if executed successfully
396     */
397     function offlineTransaction (address _recipient, uint256 _tokens) public onlyOwner returns (bool) {
398         require(state == SaleState.PartnerSale);
399         require(_tokens > 0);
400 
401         // Convert to a token with decimals 
402         uint256 tokens = _tokens * (uint256(10) ** decimals);
403 
404         purchasedTokens[_recipient] = purchasedTokens[_recipient].add(tokens);
405 
406         // Use original _token argument to increase the count of tokens purchased in the PartnerSale
407         partnerSaleTokensPurchased = partnerSaleTokensPurchased.add(_tokens);
408 
409         // Finalize the PartnerSale if necessary
410         if (partnerSaleTokensPurchased >= partnerSaleTokensAvailable) {
411             state = SaleState.PartnerSaleFinalized;
412         }
413 
414         LogTokenPurchase(msg.sender, _recipient, 0, tokens);
415 
416         return true;
417     }
418 
419     /*****
420     * @dev Allow updating the ETH USD exchange rate
421     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
422     * @return bool  Return true if the contract is in PartnerSale Period
423     */
424     function updateEthRate (uint256 rate) public onlyOwner returns (bool) {
425         require(rate >= 100000);
426         
427         ethRate = rate;
428         return true;
429     }
430 
431     /*****
432     * @dev Allows the contract owner to add a new PartnerSale wallet, used to hold funds safely
433     *      Can only be performed in the Preparing state
434     * @param _wallet        address     The address of the wallet
435     * @return success       bool        Returns true if executed successfully
436     */
437     function addPartnerSaleWallet (address _wallet) public onlyOwner returns (bool) {
438         require(state < SaleState.PartnerSaleFinalized);
439         require(_wallet != address(0));
440         partnerSaleWallets.push(_wallet);
441         return true;
442     }
443 
444     /*****
445     * @dev Allows the contract owner to add a new PreSale wallet, used to hold funds safely
446     *      Can not be performed in the PreSale state
447     * @param _wallet        address     The address of the wallet
448     * @return success       bool        Returns true if executed successfully
449     */
450     function addPreSaleWallet (address _wallet) public onlyOwner returns (bool) {
451         require(state != SaleState.PreSale);
452         require(_wallet != address(0));
453         preSaleWallets.push(_wallet);
454         return true;
455     }
456 
457     /*****
458     * @dev Allows the contract owner to add a new PublicSale wallet, used to hold funds safely
459     *      Can not be performed in the PublicSale state
460     * @param _wallet        address     The address of the wallet
461     * @return success       bool        Returns true if executed successfully
462     */
463     function addPublicSaleWallet (address _wallet) public onlyOwner returns (bool) {
464         require(state != SaleState.PublicSale);
465         require(_wallet != address(0));
466         publicSaleWallets.push(_wallet);
467         return true;
468     }
469 
470     /*****
471     * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred
472     * @param _amount    uint256     The amount of money invested by the investor
473     * @return tokens    uint256     The number of tokens purchased for the amount invested
474     */
475     function calculateTokens (uint256 _amount) public returns (uint256 tokens) {
476         if (isStatePartnerSale()) {
477             tokens = _amount * ethRate / partnerSaleTokenPrice;
478         } else if (isStatePreSale()) {
479             tokens = _amount * ethRate / preSaleTokenPrice;
480         } else if (isStatePublicSale()) {
481             tokens = _amount * ethRate / publicSaleTokenPrice;
482         } else {
483             tokens = 0;
484         }
485 
486         return tokens;
487     }
488 
489     /*****
490     * @dev Called by the owner of the contract to open the Partner/Pre/Crowd Sale periods
491     */
492     function setPhase (uint256 phase) public onlyOwner {
493         state = SaleState(uint(phase));
494     }
495 
496     /*****
497     * @dev Called by the owner of the contract to start the Partner Sale
498     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
499     */
500     function startPartnerSale (uint256 rate) public onlyOwner {
501         state = SaleState.PartnerSale;
502         updateEthRate(rate);
503     }
504 
505     /*****
506     * @dev Called by the owner of the contract to start the Pre Sale
507     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
508     */
509     function startPreSale (uint256 rate) public onlyOwner {
510         state = SaleState.PreSale;
511         updateEthRate(rate);
512     }
513 
514     /*****
515     * @dev Called by the owner of the contract to start the Public Sale
516     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
517     */
518     function startPublicSale (uint256 rate) public onlyOwner {
519         state = SaleState.PublicSale;
520         updateEthRate(rate);
521     }
522 
523     /*****
524     * @dev Called by the owner of the contract to close the Partner Sale
525     */
526     function finalizePartnerSale () public onlyOwner {
527         require(state == SaleState.PartnerSale);
528         
529         state = SaleState.PartnerSaleFinalized;
530     }
531 
532     /*****
533     * @dev Called by the owner of the contract to close the Pre Sale
534     */
535     function finalizePreSale () public onlyOwner {
536         require(state == SaleState.PreSale);
537         
538         state = SaleState.PreSaleFinalized;
539     }
540 
541     /*****
542     * @dev Called by the owner of the contract to close the Public Sale
543     */
544     function finalizePublicSale () public onlyOwner {
545         require(state == SaleState.PublicSale);
546         
547         state = SaleState.PublicSaleFinalized;
548     }
549 
550     /*****
551     * @dev Called by the owner of the contract to finalize the ICO
552     *      and redistribute funds and unsold tokens
553     */
554     function finalizeIco () public onlyOwner {
555         require(state == SaleState.PublicSaleFinalized);
556 
557         state = SaleState.Success;
558 
559         // 2.5% of total goes to DADI ecosystem
560         distribute(ecosystemWallet, ecosystemPercentOfTotal);
561 
562         // 2.5% of total goes to DADI+ operations
563         distribute(operationsWallet, operationsPercentOfTotal);
564 
565         // 5% of total goes to referral programme
566         distribute(referralProgrammeWallet, referralPercentOfTotal);
567         
568         // 20% of total goes to the founding team wallets
569         distributeFoundingTeamTokens(foundingTeamWallets);
570 
571         // redistribute unsold tokens to DADI ecosystem
572         uint256 remainingPreSaleTokens = getPreSaleTokensAvailable();
573         preSaleTokensAvailable = 0;
574         
575         uint256 remainingPublicSaleTokens = getPublicSaleTokensAvailable();
576         publicSaleTokensAvailable = 0;
577 
578         // we need to represent the tokens with included decimals
579         // `2640 ** (10 ^ 18)` not `2640`
580         if (remainingPreSaleTokens > 0) {
581             remainingPreSaleTokens = remainingPreSaleTokens * (uint256(10) ** decimals);
582             balances[owner] = balances[owner].sub(remainingPreSaleTokens);
583             balances[ecosystemWallet] = balances[ecosystemWallet].add(remainingPreSaleTokens);
584             Transfer(0, ecosystemWallet, remainingPreSaleTokens);
585         }
586 
587         if (remainingPublicSaleTokens > 0) {
588             remainingPublicSaleTokens = remainingPublicSaleTokens * (uint256(10) ** decimals);
589             balances[owner] = balances[owner].sub(remainingPublicSaleTokens);
590             balances[ecosystemWallet] = balances[ecosystemWallet].add(remainingPublicSaleTokens);
591             Transfer(0, ecosystemWallet, remainingPublicSaleTokens);
592         }
593 
594         // Transfer ETH to the funding wallet.
595         if (!fundsWallet.send(this.balance)) {
596             revert();
597         }
598     }
599 
600     /*****
601     * @dev Called by the owner of the contract to close the ICO
602     *      and unsold tokens to the ecosystem wallet. No more tokens 
603     *      may be claimed
604     */
605     function closeIco () public onlyOwner {
606         state = SaleState.Closed;
607     }
608     
609 
610     /*****
611     * @dev Allow investors to claim their tokens after the ICO is finalized & successful
612     * @return   bool  Return true, if executed successfully
613     */
614     function claimTokens () public returns (bool) {
615         require(state == SaleState.Success);
616         
617         // get the tokens available for the sender
618         uint256 tokens = purchasedTokens[msg.sender];
619         require(tokens > 0);
620 
621         purchasedTokens[msg.sender] = 0;
622 
623         balances[owner] = balances[owner].sub(tokens);
624         balances[msg.sender] = balances[msg.sender].add(tokens);
625       
626         LogClaimTokens(msg.sender, tokens);
627         Transfer(owner, msg.sender, tokens);
628         return true;
629     }
630 
631     /*****
632     * @dev Allow investors to take their money back after a failure in the ICO
633     * @param _recipient     address     The caller of the function who is looking for refund
634     * @return               bool        Return true, if executed successfully
635     */
636     function refund (address _recipient) public onlyOwner returns (bool) {
637         require(state == SaleState.Refunding);
638 
639         uint256 value = partnerSaleWei[_recipient];
640         
641         require(value > 0);
642 
643         partnerSaleWei[_recipient] = 0;
644 
645         if(!_recipient.send(value)) {
646             partnerSaleWei[_recipient] = value;
647             LogRefundFailed(_recipient, value);
648         }
649 
650         LogRefundProcessed(_recipient, value);
651         return true;
652     }
653 
654     /*****
655     * @dev Allows owner to withdraw funds from the contract balance for marketing purposes
656     * @param _address       address     The recipient address for the ether
657     * @return               bool        Return true, if executed successfully
658     */
659     function withdrawFunds (address _address, uint256 _amount) public onlyOwner {
660         _address.transfer(_amount);
661     }
662 
663     /*****
664     * @dev Generates a random number from 1 to max based on the last block hash
665     * @param max     uint  the maximum value 
666     * @return a random number
667     */
668     function getRandom(uint max) public constant returns (uint randomNumber) {
669         return (uint(sha3(block.blockhash(block.number - 1))) % max) + 1;
670     }
671 
672     /*****
673     * @dev Called by the owner of the contract to set the state to Refunding
674     */
675     function setRefunding () public onlyOwner {
676         require(state == SaleState.PartnerSaleFinalized);
677         
678         state = SaleState.Refunding;
679     }
680 
681     /*****
682     * @dev Get the overall success state of the ICO
683     * @return bool whether the state is successful, or not
684     */
685     function isSuccessful () public constant returns (bool) {
686         return state == SaleState.Success;
687     }
688 
689     /*****
690     * @dev Get the amount of PreSale tokens left for purchase
691     * @return uint256 the count of tokens available
692     */
693     function getPreSaleTokensAvailable () public constant returns (uint256) {
694         if (preSaleTokensAvailable == 0) {
695             return 0;
696         }
697 
698         return preSaleTokensAvailable - preSaleTokensPurchased;
699     }
700 
701     /*****
702     * @dev Get the amount of PublicSale tokens left for purchase
703     * @return uint256 the count of tokens available
704     */
705     function getPublicSaleTokensAvailable () public constant returns (uint256) {
706         if (publicSaleTokensAvailable == 0) {
707             return 0;
708         }
709 
710         return publicSaleTokensAvailable - publicSaleTokensPurchased;
711     }
712 
713     /*****
714     * @dev Get the total count of tokens purchased in all the Sale periods
715     * @return uint256 the count of tokens purchased
716     */
717     function getTokensPurchased () public constant returns (uint256) {
718         return partnerSaleTokensPurchased + preSaleTokensPurchased + publicSaleTokensPurchased;
719     }
720 
721     /*****
722     * @dev Get the total amount raised in the PreSale and PublicSale periods
723     * @return uint256 the amount raised, in Wei
724     */
725     function getTotalRaised () public constant returns (uint256) {
726         return preSaleRaised + publicSaleRaised;
727     }
728 
729     /*****
730     * @dev Get the balance sent to the contract
731     * @return uint256 the amount sent to this contract, in Wei
732     */
733     function getBalance () public constant returns (uint256) {
734         return this.balance;
735     }
736 
737     /*****
738     * @dev Get the balance of the funds wallet used to transfer the final balance
739     * @return uint256 the amount sent to the funds wallet at the end of the ICO, in Wei
740     */
741     function getFundsWalletBalance () public constant onlyOwner returns (uint256) {
742         return fundsWallet.balance;
743     }
744 
745     /*****
746     * @dev Get the count of unique investors
747     * @return uint256 the total number of unique investors
748     */
749     function getInvestorCount () public constant returns (uint256) {
750         return investorCount;
751     }
752 
753     /*****
754     * @dev Send ether to the fund collection wallets
755     */
756     function forwardFunds (uint256 _value) internal {
757         // if (isStatePartnerSale()) {
758         //     // move funds to a partnerSaleWallet
759         //     if (partnerSaleWallets.length > 0) {
760         //         // Transfer ETH to a random wallet
761         //         uint accountNumber = getRandom(partnerSaleWallets.length) - 1;
762         //         address account = partnerSaleWallets[accountNumber];
763         //         account.transfer(_value);
764         //         LogFundTransfer(account, _value);
765         //     }
766         // }
767 
768         uint accountNumber;
769         address account;
770 
771         if (isStatePreSale()) {
772             // move funds to a preSaleWallet
773             if (preSaleWallets.length > 0) {
774                 // Transfer ETH to a random wallet
775                 accountNumber = getRandom(preSaleWallets.length) - 1;
776                 account = preSaleWallets[accountNumber];
777                 account.transfer(_value);
778                 LogFundTransfer(account, _value);
779             }
780         } else if (isStatePublicSale()) {
781             // move funds to a publicSaleWallet
782             if (publicSaleWallets.length > 0) {
783                 // Transfer ETH to a random wallet
784                 accountNumber = getRandom(publicSaleWallets.length) - 1;
785                 account = publicSaleWallets[accountNumber];
786                 account.transfer(_value);
787                 LogFundTransfer(account, _value);
788             }
789         }
790     }
791 
792     /*****
793     * @dev Internal function to execute the token transfer to the recipient
794     *      In the PartnerSale period, token balances are stored in a separate mapping, to
795     *      await the PartnerSaleFinalized state, when investors may call claimTokens
796     * @param _recipient     address     The address of the recipient of the tokens
797     * @param _value         uint256     The amount invested by the recipient
798     * @return success       bool        Returns true if executed successfully
799     */
800     function buyTokens (address _recipient, uint256 _value) internal returns (bool) {
801         uint256 boughtTokens = calculateTokens(_value);
802         require(boughtTokens != 0);
803 
804         if (isStatePartnerSale()) {
805             // assign tokens to separate mapping
806             purchasedTokens[_recipient] = purchasedTokens[_recipient].add(boughtTokens);
807             partnerSaleWei[_recipient] = partnerSaleWei[_recipient].add(_value);
808         } else {
809             // increment the unique investor count
810             if (purchasedTokens[_recipient] == 0) {
811                 investorCount++;
812             }
813 
814             // assign tokens to separate mapping, that is not "balances"
815             purchasedTokens[_recipient] = purchasedTokens[_recipient].add(boughtTokens);
816         }
817 
818        
819         LogTokenPurchase(msg.sender, _recipient, _value, boughtTokens);
820 
821         forwardFunds(_value);
822 
823         updateSaleParameters(_value, boughtTokens);
824 
825         return true;
826     }
827 
828     /*****
829     * @dev Internal function to modify parameters based on tokens bought
830     * @param _value         uint256     The amount invested in exchange for the tokens
831     * @param _tokens        uint256     The number of tokens purchased
832     * @return success       bool        Returns true if executed successfully
833     */
834     function updateSaleParameters (uint256 _value, uint256 _tokens) internal returns (bool) {
835         // we need to represent the integer value of tokens here
836         // tokensPurchased = `2640`, not `2640 ** (10 ^ 18)`
837         uint256 tokens = _tokens / (uint256(10) ** decimals);
838 
839         if (isStatePartnerSale()) {
840             partnerSaleTokensPurchased = partnerSaleTokensPurchased.add(tokens);
841 
842             // No PartnerSale tokens remaining
843             if (partnerSaleTokensPurchased >= partnerSaleTokensAvailable) {
844                 state = SaleState.PartnerSaleFinalized;
845             }
846         } else if (isStatePreSale()) {
847             preSaleTokensPurchased = preSaleTokensPurchased.add(tokens);
848 
849             preSaleRaised = preSaleRaised.add(_value);
850 
851             // No PreSale tokens remaining
852             if (preSaleTokensPurchased >= preSaleTokensAvailable) {
853                 state = SaleState.PreSaleFinalized;
854             }
855         } else if (isStatePublicSale()) {
856             publicSaleTokensPurchased = publicSaleTokensPurchased.add(tokens);
857 
858             publicSaleRaised = publicSaleRaised.add(_value);
859 
860             // No PublicSale tokens remaining
861             if (publicSaleTokensPurchased >= publicSaleTokensAvailable) {
862                 state = SaleState.PublicSaleFinalized;
863             }
864         }
865     }
866 
867     /*****
868     * @dev Internal calculation for the amount of Wei the specified tokens are worth
869     * @param _tokens    uint256     The number of tokens purchased by the investor
870     * @return amount    uint256     The amount the tokens are worth
871     */
872     function calculateValueFromTokens (uint256 _tokens) internal returns (uint256) {
873         uint256 amount = _tokens.div(ethRate.div(partnerSaleTokenPrice));
874         return amount;
875     }
876 
877     /*****
878     * @dev Private function to distribute tokens evenly amongst the founding team wallet addresses
879     * @param _recipients    address[]   An array of founding team wallet addresses
880     * @return success       bool        Returns true if executed successfully
881     */
882     function distributeFoundingTeamTokens (address[] _recipients) private returns (bool) {
883         // determine the split between wallets
884         // to arrive at a valid percentage we start the percentage the founding team has
885         // available, which is 20% of the total supply. The percentage to distribute then is the
886         // total percentage divided by the number of founding team wallets (likely 4).
887         uint percentage = foundersPercentOfTotal / _recipients.length;
888 
889         for (uint i = 0; i < _recipients.length; i++) {
890             distribute(_recipients[i], percentage);
891         }
892     }
893 
894     /*****
895     * @dev Private function to move tokens to the specified wallet address
896     * @param _recipient     address     The address of the wallet to move tokens to
897     * @param percentage     uint        The percentage of the total supply of tokens to move
898     * @return success       bool        Returns true if executed successfully
899     */
900     function distribute (address _recipient, uint percentage) private returns (bool) {
901         uint256 tokens = totalSupply / (hundredPercent / percentage);
902 
903         balances[owner] = balances[owner].sub(tokens);
904         balances[_recipient] = balances[_recipient].add(tokens);
905         Transfer(0, _recipient, tokens);
906     }
907 
908     /*****
909     * @dev Check the PartnerSale state of the contract
910     * @return bool  Return true if the contract is in the PartnerSale state
911     */
912     function isStatePartnerSale () private constant returns (bool) {
913         return state == SaleState.PartnerSale;
914     }
915 
916     /*****
917     * @dev Check the PreSale state of the contract
918     * @return bool  Return true if the contract is in the PreSale state
919     */
920     function isStatePreSale () private constant returns (bool) {
921         return state == SaleState.PreSale;
922     }
923 
924     /*****
925     * @dev Check the PublicSale state of the contract
926     * @return bool  Return true if the contract is in the PublicSale state
927     */
928     function isStatePublicSale () private constant returns (bool) {
929         return state == SaleState.PublicSale;
930     }
931 }