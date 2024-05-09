1 pragma solidity ^0.4.18;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9 
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure
16         returns (uint256)
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure
25         returns (uint256)
26     {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure
33         returns (uint256)
34     {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable
49 {
50     address public owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 }
80 
81 interface tokenRecipient
82 {
83     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
84 }
85 
86 contract TokenERC20 is Ownable
87 {
88     using SafeMath for uint;
89 
90     // Public variables of the token
91     string public name;
92     string public symbol;
93     uint256 public decimals = 18;
94     uint256 DEC = 10 ** uint256(decimals);
95     uint256 public totalSupply;
96     uint256 public avaliableSupply;
97     uint256 public buyPrice = 1000000000000000000 wei;
98 
99     // This creates an array with all balances
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     // This generates a public event on the blockchain that will notify clients
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Burn(address indexed from, uint256 value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 
108     /**
109      * Constrctor function
110      *
111      * Initializes contract with initial supply tokens to the creator of the contract
112      */
113     function TokenERC20(
114         uint256 initialSupply,
115         string tokenName,
116         string tokenSymbol
117     ) public
118     {
119         totalSupply = initialSupply.mul(DEC);  // Update total supply with the decimal amount
120         balanceOf[this] = totalSupply;         // Give the creator all initial tokens
121         avaliableSupply = balanceOf[this];     // Show how much tokens on contract
122         name = tokenName;                      // Set the name for display purposes
123         symbol = tokenSymbol;                  // Set the symbol for display purposes
124     }
125 
126     /**
127      * Internal transfer, only can be called by this contract
128      *
129      * @param _from - address of the contract
130      * @param _to - address of the investor
131      * @param _value - tokens for the investor
132      */
133     function _transfer(address _from, address _to, uint256 _value) internal
134     {
135         // Prevent transfer to 0x0 address. Use burn() instead
136         require(_to != 0x0);
137         // Check if the sender has enough
138         require(balanceOf[_from] >= _value);
139         // Check for overflows
140         require(balanceOf[_to].add(_value) > balanceOf[_to]);
141         // Save this for an assertion in the future
142         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
143         // Subtract from the sender
144         balanceOf[_from] = balanceOf[_from].sub(_value);
145         // Add the same to the recipient
146         balanceOf[_to] = balanceOf[_to].add(_value);
147 
148         emit Transfer(_from, _to, _value);
149         // Asserts are used to use static analysis to find bugs in your code. They should never fail
150         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
151     }
152 
153     /**
154      * Transfer tokens
155      *
156      * Send `_value` tokens to `_to` from your account
157      *
158      * @param _to The address of the recipient
159      * @param _value the amount to send
160      */
161     function transfer(address _to, uint256 _value) public
162     {
163         _transfer(msg.sender, _to, _value);
164     }
165 
166     /**
167      * Transfer tokens from other address
168      *
169      * Send `_value` tokens to `_to` in behalf of `_from`
170      *
171      * @param _from The address of the sender
172      * @param _to The address of the recipient
173      * @param _value the amount to send
174      */
175     function transferFrom(address _from, address _to, uint256 _value) public
176         returns (bool success)
177     {
178         require(_value <= allowance[_from][msg.sender]);     // Check allowance
179 
180         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
181         _transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186     /**
187      * Set allowance for other address
188      *
189      * Allows `_spender` to spend no more than `_value` tokens in your behalf
190      *
191      * @param _spender The address authorized to spend
192      * @param _value the max amount they can spend
193      */
194     function approve(address _spender, uint256 _value) public
195         returns (bool success)
196     {
197         allowance[msg.sender][_spender] = _value;
198 
199         return true;
200     }
201 
202     /**
203      * Set allowance for other address and notify
204      *
205      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
206      *
207      * @param _spender The address authorized to spend
208      * @param _value the max amount they can spend
209      * @param _extraData some extra information to send to the approved contract
210      */
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner
212         returns (bool success)
213     {
214         tokenRecipient spender = tokenRecipient(_spender);
215 
216         if (approve(_spender, _value)) {
217             spender.receiveApproval(msg.sender, _value, this, _extraData);
218 
219             return true;
220         }
221     }
222 
223     /**
224      * approve should be called when allowed[_spender] == 0. To increment
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      */
229     function increaseApproval (address _spender, uint _addedValue) public
230         returns (bool success)
231     {
232         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
233 
234         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
235 
236         return true;
237     }
238 
239     function decreaseApproval (address _spender, uint _subtractedValue) public
240         returns (bool success)
241     {
242         uint oldValue = allowance[msg.sender][_spender];
243 
244         if (_subtractedValue > oldValue) {
245             allowance[msg.sender][_spender] = 0;
246         } else {
247             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248         }
249 
250         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
251 
252         return true;
253     }
254 
255     /**
256      * Destroy tokens
257      *
258      * Remove `_value` tokens from the system irreversibly
259      *
260      * @param _value the amount of money to burn
261      */
262     function burn(uint256 _value) public onlyOwner
263         returns (bool success)
264     {
265         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
266 
267         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
268         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
269         avaliableSupply = avaliableSupply.sub(_value);
270 
271         emit Burn(msg.sender, _value);
272 
273         return true;
274     }
275 
276     /**
277      * Destroy tokens from other account
278      *
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _value the amount of money to burn
283      */
284     function burnFrom(address _from, uint256 _value) public onlyOwner
285         returns (bool success)
286     {
287         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
288         require(_value <= allowance[_from][msg.sender]);    // Check allowance
289 
290         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
291         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);    // Subtract from the sender's allowance
292         totalSupply = totalSupply.sub(_value);              // Update totalSupply
293         avaliableSupply = avaliableSupply.sub(_value);
294 
295         emit Burn(_from, _value);
296 
297         return true;
298     }
299 }
300 
301 contract ERC20Extending is TokenERC20
302 {
303     using SafeMath for uint;
304 
305     /**
306     * Function for transfer ethereum from contract to any address
307     *
308     * @param _to - address of the recipient
309     * @param amount - ethereum
310     */
311     function transferEthFromContract(address _to, uint256 amount) public onlyOwner
312     {
313         _to.transfer(amount);
314     }
315 
316     /**
317     * Function for transfer tokens from contract to any address
318     *
319     */
320     function transferTokensFromContract(address _to, uint256 _value) public onlyOwner
321     {
322         avaliableSupply = avaliableSupply.sub(_value);
323         _transfer(this, _to, _value);
324     }
325 }
326 
327 contract Pauseble is TokenERC20
328 {
329     event EPause();
330     event EUnpause();
331 
332     bool public paused = true;
333     uint public startIcoDate = 0;
334 
335     modifier whenNotPaused()
336     {
337         require(!paused);
338         _;
339     }
340 
341     modifier whenPaused()
342     {
343         require(paused);
344         _;
345     }
346 
347     function pause() public onlyOwner
348     {
349         paused = true;
350         emit EPause();
351     }
352 
353     function pauseInternal() internal
354     {
355         paused = true;
356         emit EPause();
357     }
358 
359     function unpause() public onlyOwner
360     {
361         paused = false;
362         emit EUnpause();
363     }
364 
365     function unpauseInternal() internal
366     {
367         paused = false;
368         emit EUnpause();
369     }
370 }
371 
372 contract StreamityCrowdsale is Pauseble
373 {
374     using SafeMath for uint;
375 
376     uint public stage = 0;
377 
378     event CrowdSaleFinished(string info);
379 
380     struct Ico {
381         uint256 tokens;             // Tokens in crowdsale
382         uint startDate;             // Date when crowsale will be starting, after its starting that property will be the 0
383         uint endDate;               // Date when crowdsale will be stop
384         uint8 discount;             // Discount
385         uint8 discountFirstDayICO;  // Discount. Only for first stage ico
386     }
387 
388     Ico public ICO;
389 
390     /**
391     * Expanding of the functionality
392     *
393     * @param _numerator - Numerator - value (10000)
394     * @param _denominator - Denominator - value (10000)
395     *
396     * example: price 1000 tokens by 1 ether = changeRate(1, 1000)
397     */
398     function changeRate(uint256 _numerator, uint256 _denominator) public onlyOwner
399         returns (bool success)
400     {
401         if (_numerator == 0) _numerator = 1;
402         if (_denominator == 0) _denominator = 1;
403 
404         buyPrice = (_numerator.mul(DEC)).div(_denominator);
405 
406         return true;
407     }
408 
409     /*
410     * Function show in contract what is now
411     *
412     */
413     function crowdSaleStatus() internal constant
414         returns (string)
415     {
416         if (1 == stage) {
417             return "Pre-ICO";
418         } else if(2 == stage) {
419             return "ICO first stage";
420         } else if (3 == stage) {
421             return "ICO second stage";
422         } else if (4 >= stage) {
423             return "feature stage";
424         }
425 
426         return "there is no stage at present";
427     }
428 
429     /*
430     * Function for selling tokens in crowd time.
431     *
432     */
433     function sell(address _investor, uint256 amount) internal
434     {
435         uint256 _amount = (amount.mul(DEC)).div(buyPrice);
436 
437         if (1 == stage) {
438             _amount = _amount.add(withDiscount(_amount, ICO.discount));
439         }
440         else if (2 == stage)
441         {
442             if (now <= ICO.startDate + 1 days)
443             {
444                   if (0 == ICO.discountFirstDayICO) {
445                       ICO.discountFirstDayICO = 20;
446                   }
447 
448                   _amount = _amount.add(withDiscount(_amount, ICO.discountFirstDayICO));
449             } else {
450                 _amount = _amount.add(withDiscount(_amount, ICO.discount));
451             }
452         } else if (3 == stage) {
453             _amount = _amount.add(withDiscount(_amount, ICO.discount));
454         }
455 
456         if (ICO.tokens < _amount)
457         {
458             emit CrowdSaleFinished(crowdSaleStatus());
459             pauseInternal();
460 
461             revert();
462         }
463 
464         ICO.tokens = ICO.tokens.sub(_amount);
465         avaliableSupply = avaliableSupply.sub(_amount);
466 
467         _transfer(this, _investor, _amount);
468     }
469 
470     /*
471     * Function for start crowdsale (any)
472     *
473     * @param _tokens - How much tokens will have the crowdsale - amount humanlike value (10000)
474     * @param _startDate - When crowdsale will be start - unix timestamp (1512231703 )
475     * @param _endDate - When crowdsale will be end - humanlike value (7) same as 7 days
476     * @param _discount - Discount for the crowd - humanlive value (7) same as 7 %
477     * @param _discount - Discount for the crowds first day - humanlive value (7) same as 7 %
478     */
479     function startCrowd(uint256 _tokens, uint _startDate, uint _endDate, uint8 _discount, uint8 _discountFirstDayICO) public onlyOwner
480     {
481         require(_tokens * DEC <= avaliableSupply);  // require to set correct tokens value for crowd
482         startIcoDate = _startDate;
483         ICO = Ico (_tokens * DEC, _startDate, _startDate + _endDate * 1 days , _discount, _discountFirstDayICO);
484         stage = stage.add(1);
485         unpauseInternal();
486     }
487 
488     /**
489     * Function for web3js, should be call when somebody will buy tokens from website. This function only delegator.
490     *
491     * @param _investor - address of investor (who payed)
492     * @param _amount - ethereum
493     */
494     function transferWeb3js(address _investor, uint256 _amount) external onlyOwner
495     {
496         sell(_investor, _amount);
497     }
498 
499     /**
500     * Function for adding discount
501     *
502     */
503     function withDiscount(uint256 _amount, uint _percent) internal pure
504         returns (uint256)
505     {
506         return (_amount.mul(_percent)).div(100);
507     }
508 }
509 
510 contract StreamityContract is ERC20Extending, StreamityCrowdsale
511 {
512     using SafeMath for uint;
513 
514     uint public weisRaised;  // how many weis was raised on crowdsale
515 
516     /* Streamity tokens Constructor */
517     function StreamityContract() public TokenERC20(130000000, "Streamity", "STM") {} //change before send !!!
518 
519     /**
520     * Function payments handler
521     *
522     */
523     function () public payable
524     {
525         assert(msg.value >= 1 ether / 10);
526         require(now >= ICO.startDate);
527 
528         if (now >= ICO.endDate) {
529             pauseInternal();
530             emit CrowdSaleFinished(crowdSaleStatus());
531         }
532 
533 
534         if (0 != startIcoDate) {
535             if (now < startIcoDate) {
536                 revert();
537             } else {
538                 startIcoDate = 0;
539             }
540         }
541 
542         if (paused == false) {
543             sell(msg.sender, msg.value);
544             weisRaised = weisRaised.add(msg.value);
545         }
546     }
547 }
548 
549 /**
550  * @title Helps contracts guard agains reentrancy attacks.
551  * @author Remco Bloemen <remco@2π.com>
552  * @notice If you mark a function `nonReentrant`, you should also
553  * mark it `external`.
554  */
555 contract ReentrancyGuard {
556 
557   /**
558    * @dev We use a single lock for the whole contract.
559    */
560   bool private reentrancy_lock = false;
561 
562   /**
563    * @dev Prevents a contract from calling itself, directly or indirectly.
564    * @notice If you mark a function `nonReentrant`, you should also
565    * mark it `external`. Calling one nonReentrant function from
566    * another is not supported. Instead, you can implement a
567    * `private` function doing the actual work, and a `external`
568    * wrapper marked as `nonReentrant`.
569    */
570   modifier nonReentrant() {
571     require(!reentrancy_lock);
572     reentrancy_lock = true;
573     _;
574     reentrancy_lock = false;
575   }
576 
577 }
578 
579 /**
580  * @title Eliptic curve signature operations
581  *
582  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
583  */
584 
585 library ECRecovery {
586 
587   /**
588    * @dev Recover signer address from a message by using his signature
589    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
590    * @param sig bytes signature, the signature is generated using web3.eth.sign()
591    */
592   function recover(bytes32 hash, bytes sig) public pure returns (address) {
593     bytes32 r;
594     bytes32 s;
595     uint8 v;
596 
597     //Check the signature length
598     if (sig.length != 65) {
599       return (address(0));
600     }
601 
602     // Divide the signature in r, s and v variables
603     assembly {
604       r := mload(add(sig, 32))
605       s := mload(add(sig, 64))
606       v := byte(0, mload(add(sig, 96)))
607     }
608 
609     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
610     if (v < 27) {
611       v += 27;
612     }
613 
614     // If the version is correct return the signer address
615     if (v != 27 && v != 28) {
616       return (address(0));
617     } else {
618       return ecrecover(hash, v, r, s);
619     }
620   }
621 
622 }
623 
624 contract ContractToken {
625     function transfer(address _to, uint _value) public returns (bool success);
626     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
627     function approve(address _spender, uint _value) public returns (bool success);
628 }
629 
630 contract StreamityEscrow is Ownable, ReentrancyGuard {
631     using SafeMath for uint256;
632     using ECRecovery for bytes32;
633 
634     uint8 constant public STATUS_NO_DEAL = 0x0;
635     uint8 constant public STATUS_DEAL_WAIT_CONFIRMATION = 0x01;
636     uint8 constant public STATUS_DEAL_APPROVE = 0x02;
637     uint8 constant public STATUS_DEAL_RELEASE = 0x03;
638 
639     TokenERC20 public streamityContractAddress;
640     
641     uint256 public availableForWithdrawal;
642 
643     uint32 public requestCancelationTime;
644 
645     mapping(bytes32 => Deal) public streamityTransfers;
646 
647     function StreamityEscrow(address streamityContract) public {
648         require(streamityContract != 0x0);
649         requestCancelationTime = 2 hours;
650         streamityContractAddress = TokenERC20(streamityContract);
651     }
652 
653     struct Deal {
654         uint256 value;
655         uint256 cancelTime;
656         address seller;
657         address buyer;
658         uint8 status;
659         uint256 commission;
660         bool isAltCoin;
661     }
662 
663     event StartDealEvent(bytes32 _hashDeal, address _seller, address _buyer);
664     event ApproveDealEvent(bytes32 _hashDeal, address _seller, address _buyer);
665     event ReleasedEvent(bytes32 _hashDeal, address _seller, address _buyer);
666     event SellerCancelEvent(bytes32 _hashDeal, address _seller, address _buyer);
667     
668     function pay(bytes32 _tradeID, address _seller, address _buyer, uint256 _value, uint256 _commission, bytes _sign) 
669     external 
670     payable 
671     {
672         require(msg.value > 0);
673         require(msg.value == _value);
674         require(msg.value > _commission);
675         bytes32 _hashDeal = keccak256(_tradeID, _seller, _buyer, msg.value, _commission);
676         verifyDeal(_hashDeal, _sign);
677         startDealForUser(_hashDeal, _seller, _buyer, _commission, msg.value, false);
678     }
679 
680     function () public payable {
681         availableForWithdrawal = availableForWithdrawal.add(msg.value);
682     }
683 
684     function payAltCoin(bytes32 _tradeID, address _seller, address _buyer, uint256 _value, uint256 _commission, bytes _sign) 
685     external 
686     {
687         bytes32 _hashDeal = keccak256(_tradeID, _seller, _buyer, _value, _commission);
688         verifyDeal(_hashDeal, _sign);
689         bool result = streamityContractAddress.transferFrom(msg.sender, address(this), _value);
690         require(result == true);
691         startDealForUser(_hashDeal, _seller, _buyer, _commission, _value, true);
692     }
693 
694     function verifyDeal(bytes32 _hashDeal, bytes _sign) private view {
695         require(_hashDeal.recover(_sign) == owner);
696         require(streamityTransfers[_hashDeal].status == STATUS_NO_DEAL); 
697     }
698 
699     function startDealForUser(bytes32 _hashDeal, address _seller, address _buyer, uint256 _commission, uint256 _value, bool isAltCoin) 
700     private returns(bytes32) 
701     {
702         Deal storage userDeals = streamityTransfers[_hashDeal];
703         userDeals.seller = _seller;
704         userDeals.buyer = _buyer;
705         userDeals.value = _value; 
706         userDeals.commission = _commission; 
707         userDeals.cancelTime = block.timestamp.add(requestCancelationTime); 
708         userDeals.status = STATUS_DEAL_WAIT_CONFIRMATION;
709         userDeals.isAltCoin = isAltCoin;
710         emit StartDealEvent(_hashDeal, _seller, _buyer);
711         
712         return _hashDeal;
713     }
714 
715     function withdrawCommisionToAddress(address _to, uint256 _amount) external onlyOwner {
716         require(_amount <= availableForWithdrawal); 
717         availableForWithdrawal = availableForWithdrawal.sub(_amount);
718         _to.transfer(_amount);
719     }
720 
721     function withdrawCommisionToAddressAltCoin(address _to, uint256 _amount) external onlyOwner {
722         streamityContractAddress.transfer(_to, _amount);
723     }
724 
725     function getStatusDeal(bytes32 _hashDeal) external view returns (uint8) {
726         return streamityTransfers[_hashDeal].status;
727     }
728     
729     // _additionalComission is wei
730     uint256 constant GAS_releaseTokens = 60000;
731     function releaseTokens(bytes32 _hashDeal, uint256 _additionalGas) 
732     external 
733     nonReentrant
734     returns(bool) 
735     {
736         Deal storage deal = streamityTransfers[_hashDeal];
737 
738         if (deal.status == STATUS_DEAL_APPROVE) {
739             deal.status = STATUS_DEAL_RELEASE; 
740             bool result = false;
741 
742             if (deal.isAltCoin == false)
743                 result = transferMinusComission(deal.buyer, deal.value, deal.commission.add((msg.sender == owner ? (GAS_releaseTokens.add(_additionalGas)).mul(tx.gasprice) : 0)));
744             else 
745                 result = transferMinusComissionAltCoin(streamityContractAddress, deal.buyer, deal.value, deal.commission);
746 
747             if (result == false) {
748                 deal.status = STATUS_DEAL_APPROVE; 
749                 return false;   
750             }
751 
752             emit ReleasedEvent(_hashDeal, deal.seller, deal.buyer);
753             delete streamityTransfers[_hashDeal];
754             return true;
755         }
756         
757         return false;
758     }
759 
760     function releaseTokensForce(bytes32 _hashDeal) 
761     external onlyOwner
762     nonReentrant
763     returns(bool) 
764     {
765         Deal storage deal = streamityTransfers[_hashDeal];
766         uint8 prevStatus = deal.status; 
767         if (deal.status != STATUS_NO_DEAL) {
768             deal.status = STATUS_DEAL_RELEASE; 
769             bool result = false;
770 
771             if (deal.isAltCoin == false)
772                 result = transferMinusComission(deal.buyer, deal.value, deal.commission);
773             else 
774                 result = transferMinusComissionAltCoin(streamityContractAddress, deal.buyer, deal.value, deal.commission);
775 
776             if (result == false) {
777                 deal.status = prevStatus; 
778                 return false;   
779             }
780 
781             emit ReleasedEvent(_hashDeal, deal.seller, deal.buyer);
782             delete streamityTransfers[_hashDeal];
783             return true;
784         }
785         
786         return false;
787     }
788 
789     uint256 constant GAS_cancelSeller = 30000;
790     function cancelSeller(bytes32 _hashDeal, uint256 _additionalGas) 
791     external onlyOwner
792     nonReentrant	
793     returns(bool)   
794     {
795         Deal storage deal = streamityTransfers[_hashDeal];
796 
797         if (deal.cancelTime > block.timestamp)
798             return false;
799 
800         if (deal.status == STATUS_DEAL_WAIT_CONFIRMATION) {
801             deal.status = STATUS_DEAL_RELEASE; 
802 
803             bool result = false;
804             if (deal.isAltCoin == false)
805                 result = transferMinusComission(deal.seller, deal.value, GAS_cancelSeller.add(_additionalGas).mul(tx.gasprice));
806             else 
807                 result = transferMinusComissionAltCoin(streamityContractAddress, deal.seller, deal.value, _additionalGas);
808 
809             if (result == false) {
810                 deal.status = STATUS_DEAL_WAIT_CONFIRMATION; 
811                 return false;   
812             }
813 
814             emit SellerCancelEvent(_hashDeal, deal.seller, deal.buyer);
815             delete streamityTransfers[_hashDeal];
816             return true;
817         }
818         
819         return false;
820     }
821 
822     function approveDeal(bytes32 _hashDeal) 
823     external 
824     onlyOwner 
825     nonReentrant	
826     returns(bool) 
827     {
828         Deal storage deal = streamityTransfers[_hashDeal];
829         
830         if (deal.status == STATUS_DEAL_WAIT_CONFIRMATION) {
831             deal.status = STATUS_DEAL_APPROVE;
832             emit ApproveDealEvent(_hashDeal, deal.seller, deal.buyer);
833             return true;
834         }
835         
836         return false;
837     }
838 
839     function transferMinusComission(address _to, uint256 _value, uint256 _commission) 
840     private returns(bool) 
841     {
842         uint256 _totalComission = _commission; 
843         
844         require(availableForWithdrawal.add(_totalComission) >= availableForWithdrawal); // Check for overflows
845 
846         availableForWithdrawal = availableForWithdrawal.add(_totalComission); 
847 
848         _to.transfer(_value.sub(_totalComission));
849         return true;
850     }
851 
852     function transferMinusComissionAltCoin(TokenERC20 _contract, address _to, uint256 _value, uint256 _commission) 
853     private returns(bool) 
854     {
855         uint256 _totalComission = _commission; 
856         _contract.transfer(_to, _value.sub(_totalComission));
857         return true;
858     }
859 
860     function setStreamityContractAddress(address newAddress) 
861     external onlyOwner 
862     {
863         streamityContractAddress = TokenERC20(newAddress);
864     }
865 
866     // For other Tokens
867     function transferToken(ContractToken _tokenContract, address _transferTo, uint256 _value) onlyOwner external {
868         _tokenContract.transfer(_transferTo, _value);
869     }
870     function transferTokenFrom(ContractToken _tokenContract, address _transferTo, address _transferFrom, uint256 _value) onlyOwner external {
871         _tokenContract.transferFrom(_transferTo, _transferFrom, _value);
872     }
873     function approveToken(ContractToken _tokenContract, address _spender, uint256 _value) onlyOwner external {
874         _tokenContract.approve(_spender, _value);
875     }
876 }