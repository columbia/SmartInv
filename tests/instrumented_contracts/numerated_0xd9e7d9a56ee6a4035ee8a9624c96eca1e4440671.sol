1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/CrowdsaleAuthorizer.sol
52 
53 /**
54  * @title CrowdsaleAuthorizer
55  * @dev Crowd Sale Authorizer
56  */
57 contract CrowdsaleAuthorizer {
58     mapping(address => uint256)    public participated;
59     mapping(address => bool)       public whitelistAddresses;
60 
61     address                        public admin;
62     uint256                        public saleStartTime;
63     uint256                        public saleEndTime;
64     uint256                        public increaseMaxContribTime;
65     uint256                        public minContribution;
66     uint256                        public maxContribution;
67 
68     using SafeMath for uint256;
69 
70     /**
71     * @dev Modifier for only admin
72     */
73     modifier onlyAdmin() {
74       require(msg.sender == admin);
75       _;
76     }
77 
78     /**
79     * @dev Modifier for valid address
80     */
81     modifier validAddress(address _addr) {
82       require(_addr != address(0x0));
83       require(_addr != address(this));
84       _;
85     }
86 
87     /**
88      * @dev Contract Constructor
89      * @param _saleStartTime - The Start Time of the Token Sale
90      * @param _saleEndTime - The End Time of the Token Sale
91      * @param _increaseMaxContribTime - Time to increase Max Contribution of the Token Sale
92      * @param _minContribution - Minimum ETH contribution per contributor
93      * @param _maxContribution - Maximum ETH contribution per contributor
94      */
95     function CrowdsaleAuthorizer(
96         address _admin,
97         uint256 _saleStartTime,
98         uint256 _saleEndTime,
99         uint256 _increaseMaxContribTime,
100         uint256 _minContribution,
101         uint256 _maxContribution
102     )
103         validAddress(_admin)
104         public
105     {
106         require(_saleStartTime > now);
107         require(_saleEndTime > now);
108         require(_increaseMaxContribTime > now);
109         require(_saleStartTime < _saleEndTime);
110         require(_increaseMaxContribTime > _saleStartTime);
111         require(_maxContribution > 0);
112         require(_minContribution < _maxContribution);
113 
114         admin = _admin;
115         saleStartTime = _saleStartTime;
116         saleEndTime = _saleEndTime;
117         increaseMaxContribTime = _increaseMaxContribTime;
118 
119         minContribution = _minContribution;
120         maxContribution = _maxContribution;
121     }
122 
123     event UpdateWhitelist(address _user, bool _allow, uint _time);
124 
125     /**
126      * @dev Update Whitelist Address
127      * @param _user - Whitelist address
128      * @param _allow - eligibility
129      */
130     function updateWhitelist(address _user, bool _allow)
131         public
132         onlyAdmin
133     {
134         whitelistAddresses[_user] = _allow;
135         UpdateWhitelist(_user, _allow, now);
136     }
137 
138     /**
139      * @dev Batch Update Whitelist Address
140      * @param _users - Array of Whitelist addresses
141      * @param _allows - Array of eligibilities
142      */
143     function updateWhitelists(address[] _users, bool[] _allows)
144         external
145         onlyAdmin
146     {
147         require(_users.length == _allows.length);
148         for (uint i = 0 ; i < _users.length ; i++) {
149             address _user = _users[i];
150             bool _allow = _allows[i];
151             whitelistAddresses[_user] = _allow;
152             UpdateWhitelist(_user, _allow, now);
153         }
154     }
155 
156     /**
157      * @dev Get Eligible Amount
158      * @param _contributor - Contributor address
159      * @param _amount - Intended contribution amount
160      */
161     function eligibleAmount(address _contributor, uint256 _amount)
162         public
163         view
164         returns(uint256)
165     {
166         // If sales has not started or sale ended, there's no allocation
167         if (!saleStarted() || saleEnded()) {
168             return 0;
169         }
170 
171         // Amount lesser than minimum contribution will be rejected
172         if (_amount < minContribution) {
173             return 0;
174         }
175 
176         uint256 userMaxContribution = maxContribution;
177         // If sale has past 24hrs, increase max cap
178         if (now >= increaseMaxContribTime) {
179             userMaxContribution = maxContribution.mul(10);
180         }
181 
182         // Calculate remaining contribution for the contributor
183         uint256 remainingCap = userMaxContribution.sub(participated[_contributor]);
184 
185         // Return either the amount contributed or cap whichever is lower
186         return (remainingCap > _amount) ? _amount : remainingCap;
187     }
188 
189     /**
190      * @dev Get if sale has started
191      */
192     function saleStarted() public view returns(bool) {
193         return now >= saleStartTime;
194     }
195 
196     /**
197      * @dev Get if sale has ended
198      */
199     function saleEnded() public view returns(bool) {
200         return now > saleEndTime;
201     }
202 
203     /**
204      * @dev Check for eligible amount and modify participation map
205      * @param _contributor - Contributor address
206      * @param _amount - Intended contribution amount
207      */
208     function eligibleAmountCheck(address _contributor, uint256 _amount)
209         internal
210         returns(uint256)
211     {
212         // Check if contributor is whitelisted
213         if (!whitelistAddresses[_contributor]) {
214             return 0;
215         }
216 
217         uint256 result = eligibleAmount(_contributor, _amount);
218         participated[_contributor] = participated[_contributor].add(result);
219 
220         return result;
221     }
222 }
223 
224 // File: contracts/zeppelin/ownership/Ownable.sol
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237 
238   /**
239    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
240    * account.
241    */
242   function Ownable() public {
243     owner = msg.sender;
244   }
245 
246   /**
247    * @dev Throws if called by any account other than the owner.
248    */
249   modifier onlyOwner() {
250     require(msg.sender == owner);
251     _;
252   }
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) public onlyOwner {
259     require(newOwner != address(0));
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262   }
263 
264 }
265 
266 // File: contracts/zeppelin/token/ERC20Basic.sol
267 
268 /**
269  * @title ERC20Basic
270  * @dev Simpler version of ERC20 interface
271  * @dev see https://github.com/ethereum/EIPs/issues/179
272  */
273 contract ERC20Basic {
274   function totalSupply() public view returns (uint256);
275   function balanceOf(address who) public view returns (uint256);
276   function transfer(address to, uint256 value) public returns (bool);
277   event Transfer(address indexed from, address indexed to, uint256 value);
278 }
279 
280 // File: contracts/zeppelin/token/BasicToken.sol
281 
282 /**
283  * @title Basic token
284  * @dev Basic version of StandardToken, with no allowances.
285  */
286 contract BasicToken is ERC20Basic {
287   using SafeMath for uint256;
288 
289   mapping(address => uint256) balances;
290 
291   uint256 totalSupply_;
292 
293   /**
294   * @dev total number of tokens in existence
295   */
296   function totalSupply() public view returns (uint256) {
297     return totalSupply_;
298   }
299 
300   /**
301   * @dev transfer token for a specified address
302   * @param _to The address to transfer to.
303   * @param _value The amount to be transferred.
304   */
305   function transfer(address _to, uint256 _value) public returns (bool) {
306     require(_to != address(0));
307     require(_value <= balances[msg.sender]);
308 
309     // SafeMath.sub will throw if there is not enough balance.
310     balances[msg.sender] = balances[msg.sender].sub(_value);
311     balances[_to] = balances[_to].add(_value);
312     Transfer(msg.sender, _to, _value);
313     return true;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param _owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address _owner) public view returns (uint256 balance) {
322     return balances[_owner];
323   }
324 
325 }
326 
327 // File: contracts/zeppelin/token/BurnableToken.sol
328 
329 /**
330  * @title Burnable Token
331  * @dev Token that can be irreversibly burned (destroyed).
332  */
333 contract BurnableToken is BasicToken {
334 
335   event Burn(address indexed burner, uint256 value);
336 
337   /**
338    * @dev Burns a specific amount of tokens.
339    * @param _value The amount of token to be burned.
340    */
341   function burn(uint256 _value) public {
342     require(_value <= balances[msg.sender]);
343     // no need to require value <= totalSupply, since that would imply the
344     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
345 
346     address burner = msg.sender;
347     balances[burner] = balances[burner].sub(_value);
348     totalSupply_ = totalSupply_.sub(_value);
349     Burn(burner, _value);
350   }
351 }
352 
353 // File: contracts/zeppelin/token/ERC20.sol
354 
355 /**
356  * @title ERC20 interface
357  * @dev see https://github.com/ethereum/EIPs/issues/20
358  */
359 contract ERC20 is ERC20Basic {
360   function allowance(address owner, address spender) public view returns (uint256);
361   function transferFrom(address from, address to, uint256 value) public returns (bool);
362   function approve(address spender, uint256 value) public returns (bool);
363   event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 // File: contracts/zeppelin/token/StandardToken.sol
367 
368 /**
369  * @title Standard ERC20 token
370  *
371  * @dev Implementation of the basic standard token.
372  * @dev https://github.com/ethereum/EIPs/issues/20
373  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
374  */
375 contract StandardToken is ERC20, BasicToken {
376 
377   mapping (address => mapping (address => uint256)) internal allowed;
378 
379 
380   /**
381    * @dev Transfer tokens from one address to another
382    * @param _from address The address which you want to send tokens from
383    * @param _to address The address which you want to transfer to
384    * @param _value uint256 the amount of tokens to be transferred
385    */
386   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
387     require(_to != address(0));
388     require(_value <= balances[_from]);
389     require(_value <= allowed[_from][msg.sender]);
390 
391     balances[_from] = balances[_from].sub(_value);
392     balances[_to] = balances[_to].add(_value);
393     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
394     Transfer(_from, _to, _value);
395     return true;
396   }
397 
398   /**
399    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
400    *
401    * Beware that changing an allowance with this method brings the risk that someone may use both the old
402    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
403    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
404    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405    * @param _spender The address which will spend the funds.
406    * @param _value The amount of tokens to be spent.
407    */
408   function approve(address _spender, uint256 _value) public returns (bool) {
409     allowed[msg.sender][_spender] = _value;
410     Approval(msg.sender, _spender, _value);
411     return true;
412   }
413 
414   /**
415    * @dev Function to check the amount of tokens that an owner allowed to a spender.
416    * @param _owner address The address which owns the funds.
417    * @param _spender address The address which will spend the funds.
418    * @return A uint256 specifying the amount of tokens still available for the spender.
419    */
420   function allowance(address _owner, address _spender) public view returns (uint256) {
421     return allowed[_owner][_spender];
422   }
423 
424   /**
425    * @dev Increase the amount of tokens that an owner allowed to a spender.
426    *
427    * approve should be called when allowed[_spender] == 0. To increment
428    * allowed value is better to use this function to avoid 2 calls (and wait until
429    * the first transaction is mined)
430    * From MonolithDAO Token.sol
431    * @param _spender The address which will spend the funds.
432    * @param _addedValue The amount of tokens to increase the allowance by.
433    */
434   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
435     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
436     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
437     return true;
438   }
439 
440   /**
441    * @dev Decrease the amount of tokens that an owner allowed to a spender.
442    *
443    * approve should be called when allowed[_spender] == 0. To decrement
444    * allowed value is better to use this function to avoid 2 calls (and wait until
445    * the first transaction is mined)
446    * From MonolithDAO Token.sol
447    * @param _spender The address which will spend the funds.
448    * @param _subtractedValue The amount of tokens to decrease the allowance by.
449    */
450   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
451     uint oldValue = allowed[msg.sender][_spender];
452     if (_subtractedValue > oldValue) {
453       allowed[msg.sender][_spender] = 0;
454     } else {
455       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
456     }
457     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
458     return true;
459   }
460 
461 }
462 
463 // File: contracts/PolicyPalNetworkToken.sol
464 
465 /**
466  * @title PolicyPalNetwork Token
467  * @dev A standard ownable token
468  */
469 contract PolicyPalNetworkToken is StandardToken, BurnableToken, Ownable {
470     /**
471     * @dev Token Contract Constants
472     */
473     string    public constant name     = "PolicyPal Network Token";
474     string    public constant symbol   = "PAL";
475     uint8     public constant decimals = 18;
476 
477     /**
478     * @dev Token Contract Public Variables
479     */
480     address public  tokenSaleContract;
481     bool    public  isTokenTransferable = false;
482 
483 
484     /**
485     * @dev   Token Contract Modifier
486     *
487     * Check if a transfer is allowed
488     * Transfers are restricted to token creator & owner(admin) during token sale duration
489     * Transfers after token sale is limited by `isTokenTransferable` toggle
490     *
491     */
492     modifier onlyWhenTransferAllowed() {
493         require(isTokenTransferable || msg.sender == owner || msg.sender == tokenSaleContract);
494         _;
495     }
496 
497     /**
498      * @dev Token Contract Modifier
499      * @param _to - Address to check if valid
500      *
501      *  Check if an address is valid
502      *  A valid address is as follows,
503      *    1. Not zero address
504      *    2. Not token address
505      *
506      */
507     modifier isValidDestination(address _to) {
508         require(_to != address(0x0));
509         require(_to != address(this));
510         _;
511     }
512 
513     /**
514      * @dev Enable Transfers (Only Owner)
515      */
516     function toggleTransferable(bool _toggle) external
517         onlyOwner
518     {
519         isTokenTransferable = _toggle;
520     }
521     
522 
523     /**
524     * @dev Token Contract Constructor
525     * @param _adminAddr - Address of the Admin
526     */
527     function PolicyPalNetworkToken(
528         uint _tokenTotalAmount,
529         address _adminAddr
530     ) 
531         public
532         isValidDestination(_adminAddr)
533     {
534         require(_tokenTotalAmount > 0);
535 
536         totalSupply_ = _tokenTotalAmount;
537 
538         // Mint all token
539         balances[msg.sender] = _tokenTotalAmount;
540         Transfer(address(0x0), msg.sender, _tokenTotalAmount);
541 
542         // Assign token sale contract to creator
543         tokenSaleContract = msg.sender;
544 
545         // Transfer contract ownership to admin
546         transferOwnership(_adminAddr);
547     }
548 
549     /**
550     * @dev Token Contract transfer
551     * @param _to - Address to transfer to
552     * @param _value - Value to transfer
553     * @return bool - Result of transfer
554     * "Overloaded" Function of ERC20Basic's transfer
555     *
556     */
557     function transfer(address _to, uint256 _value) public
558         onlyWhenTransferAllowed
559         isValidDestination(_to)
560         returns (bool)
561     {
562         return super.transfer(_to, _value);
563     }
564 
565     /**
566     * @dev Token Contract transferFrom
567     * @param _from - Address to transfer from
568     * @param _to - Address to transfer to
569     * @param _value - Value to transfer
570     * @return bool - Result of transferFrom
571     *
572     * "Overloaded" Function of ERC20's transferFrom
573     * Added with modifiers,
574     *    1. onlyWhenTransferAllowed
575     *    2. isValidDestination
576     *
577     */
578     function transferFrom(address _from, address _to, uint256 _value) public
579         onlyWhenTransferAllowed
580         isValidDestination(_to)
581         returns (bool)
582     {
583         return super.transferFrom(_from, _to, _value);
584     }
585 
586     /**
587     * @dev Token Contract burn
588     * @param _value - Value to burn
589     * "Overloaded" Function of BurnableToken's burn
590     */
591     function burn(uint256 _value)
592         public
593     {
594         super.burn(_value);
595         Transfer(msg.sender, address(0x0), _value);
596     }
597 
598     /**
599     * @dev Token Contract Emergency Drain
600     * @param _token - Token to drain
601     * @param _amount - Amount to drain
602     */
603     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public
604         onlyOwner
605     {
606         _token.transfer(owner, _amount);
607     }
608 }
609 
610 // File: contracts/PolicyPalNetworkCrowdsale.sol
611 
612 /**
613  * @title PPN Crowdsale
614  * @dev Crowd Sale Contract
615  */
616 contract PolicyPalNetworkCrowdsale is CrowdsaleAuthorizer {
617     /**
618     * @dev Token Crowd Sale Contract Public Variables
619     */
620     address                 public multiSigWallet;
621     PolicyPalNetworkToken   public token;
622     uint256                 public raisedWei;
623     bool                    public haltSale;
624     uint                    public rate;
625 
626     /**
627     * @dev Modifier for valid sale
628     */
629     modifier validSale() {
630       require(!haltSale);
631       require(saleStarted());
632       require(!saleEnded());
633       _;
634     }
635 
636     /**
637      * @dev Buy Event
638      */
639     event Buy(address _buyer, uint256 _tokens, uint256 _payedWei);
640 
641     /**
642      * @dev Token Crowd Sale Contract Constructor
643      * @param _admin - Address of the Admin
644      * @param _multiSigWallet - Address of Multisig wallet
645      * @param _totalTokenSupply - Total Token Supply
646      * @param _premintedTokenSupply - Total preminted token supply
647      * @param _saleStartTime - The Start Time of the Token Sale
648      * @param _saleEndTime - The End Time of the Token Sale
649      * @param _increaseMaxContribTime - Time to increase max contribution
650      * @param _rate - Rate of ETH to PAL
651      * @param _minContribution - Minimum ETH contribution per contributor
652      * @param _maxContribution - Maximum ETH contribution per contributor
653      */
654     function PolicyPalNetworkCrowdsale(
655         address _admin,
656         address _multiSigWallet,
657         uint256 _totalTokenSupply,
658         uint256 _premintedTokenSupply,
659         uint256 _presaleTokenSupply,
660         uint256 _saleStartTime,
661         uint256 _saleEndTime,
662         uint256 _increaseMaxContribTime,
663         uint    _rate,
664         uint256 _minContribution,
665         uint256 _maxContribution
666     )
667     CrowdsaleAuthorizer(
668         _admin,
669         _saleStartTime,
670         _saleEndTime,
671         _increaseMaxContribTime,
672         _minContribution,
673         _maxContribution
674     )
675         validAddress(_multiSigWallet)
676         public
677     {
678         require(_totalTokenSupply > 0);
679         require(_premintedTokenSupply > 0);
680         require(_presaleTokenSupply > 0);
681         require(_rate > 0);
682         
683         require(_premintedTokenSupply < _totalTokenSupply);
684         require(_presaleTokenSupply < _totalTokenSupply);
685 
686         multiSigWallet = _multiSigWallet;
687         rate = _rate;
688 
689         token = new PolicyPalNetworkToken(
690             _totalTokenSupply,
691             _admin
692         );
693 
694         // transfer preminted tokens to company wallet
695         token.transfer(multiSigWallet, _premintedTokenSupply);
696         // transfer presale tokens to admin
697         token.transfer(_admin, _presaleTokenSupply);
698     }
699 
700     /**
701      * @dev Token Crowd Sale Contract Halter
702      * @param _halt - Flag to halt sale
703      */
704     function setHaltSale(bool _halt)
705         onlyAdmin
706         public
707     {
708         haltSale = _halt;
709     }
710 
711     /**
712      * @dev Token Crowd Sale payable
713      */
714     function() public payable {
715         buy(msg.sender);
716     }
717 
718     /**
719      * @dev Token Crowd Sale Buy
720      * @param _recipient - Address of the recipient
721      */
722     function buy(address _recipient) public payable
723         validSale
724         validAddress(_recipient)
725         returns(uint256)
726     {
727         // Get the contributor's eligible amount
728         uint256 weiContributionAllowed = eligibleAmountCheck(_recipient, msg.value);
729         require(weiContributionAllowed > 0);
730 
731         // Get tokens remaining for sale
732         uint256 tokensRemaining = token.balanceOf(address(this));
733         require(tokensRemaining > 0);
734 
735         // Get tokens that the contributor will receive
736         uint256 receivedTokens = weiContributionAllowed.mul(rate);
737 
738         // Check remaining tokens
739         // If lesser, update tokens to be transfer and contribution allowed
740         if (receivedTokens > tokensRemaining) {
741             receivedTokens = tokensRemaining;
742             weiContributionAllowed = tokensRemaining.div(rate);
743         }
744 
745         // Transfer tokens to contributor
746         assert(token.transfer(_recipient, receivedTokens));
747 
748         // Send ETH payment to MultiSig Wallet
749         sendETHToMultiSig(weiContributionAllowed);
750         raisedWei = raisedWei.add(weiContributionAllowed);
751 
752         // Check weiContributionAllowed is larger than value sent
753         // If larger, transfer the excess back to the contributor
754         if (msg.value > weiContributionAllowed) {
755             msg.sender.transfer(msg.value.sub(weiContributionAllowed));
756         }
757 
758         // Broadcast event
759         Buy(_recipient, receivedTokens, weiContributionAllowed);
760 
761         return weiContributionAllowed;
762     }
763 
764     /**
765      * @dev Token Crowd Sale Emergency Drain
766      *      In case something went wrong and ETH is stuck in contract
767      * @param _anyToken - Token to drain
768      */
769     function emergencyDrain(ERC20 _anyToken) public
770         onlyAdmin
771         returns(bool)
772     {
773         if (this.balance > 0) {
774             sendETHToMultiSig(this.balance);
775         }
776         if (_anyToken != address(0x0)) {
777             assert(_anyToken.transfer(multiSigWallet, _anyToken.balanceOf(this)));
778         }
779         return true;
780     }
781 
782     /**
783      * @dev Token Crowd Sale
784      *      Transfer ETH to MultiSig Wallet
785      * @param _value - Value of ETH to send
786      */
787     function sendETHToMultiSig(uint256 _value) internal {
788         multiSigWallet.transfer(_value);
789     }
790 }