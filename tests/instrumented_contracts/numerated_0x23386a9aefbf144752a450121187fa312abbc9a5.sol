1 pragma solidity ^ 0.4.19;
2 
3 /**
4  * @title GdprConfig
5  * @dev Configuration for GDPR Cash token and crowdsale
6 */
7 contract GdprConfig {
8 
9     // Token settings
10     string public constant TOKEN_NAME = "GDPR Cash";
11     string public constant TOKEN_SYMBOL = "GDPR";
12     uint8 public constant TOKEN_DECIMALS = 18;
13 
14     // Smallest value of the GDPR
15     uint256 public constant MIN_TOKEN_UNIT = 10 ** uint256(TOKEN_DECIMALS);
16     // Minimum cap per purchaser on public sale ~ $100 in GDPR Cash
17     uint256 public constant PURCHASER_MIN_TOKEN_CAP = 500 * MIN_TOKEN_UNIT;
18     // Maximum cap per purchaser on first day of public sale ~ $2,000 in GDPR Cash
19     uint256 public constant PURCHASER_MAX_TOKEN_CAP_DAY1 = 10000 * MIN_TOKEN_UNIT;
20     // Maximum cap per purchaser on public sale ~ $20,000 in GDPR
21     uint256 public constant PURCHASER_MAX_TOKEN_CAP = 100000 * MIN_TOKEN_UNIT;
22 
23     // Crowdsale rate GDPR / ETH
24     uint256 public constant INITIAL_RATE = 7600; // 7600 GDPR for 1 ether
25 
26     // Initial distribution amounts
27     uint256 public constant TOTAL_SUPPLY_CAP = 200000000 * MIN_TOKEN_UNIT;
28     // 60% of the total supply cap
29     uint256 public constant SALE_CAP = 120000000 * MIN_TOKEN_UNIT;
30     // 10% tokens for the experts
31     uint256 public constant EXPERTS_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;
32     // 10% tokens for marketing expenses
33     uint256 public constant MARKETING_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;
34     // 9% founders' distribution
35     uint256 public constant TEAM_POOL_TOKENS = 18000000 * MIN_TOKEN_UNIT;
36     // 1% for legal advisors
37     uint256 public constant LEGAL_EXPENSES_TOKENS = 2000000 * MIN_TOKEN_UNIT;
38     // 10% tokens for the reserve
39     uint256 public constant RESERVE_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;
40 
41     // Contract wallet addresses for initial allocation
42     address public constant EXPERTS_POOL_ADDR = 0x289bB02deaF473c6Aa5edc4886A71D85c18F328B;
43     address public constant MARKETING_POOL_ADDR = 0x7BFD82C978EDDce94fe12eBF364c6943c7cC2f27;
44     address public constant TEAM_POOL_ADDR = 0xB4AfbF5F39895adf213194198c0ba316f801B24d;
45     address public constant LEGAL_EXPENSES_ADDR = 0xf72931B08f8Ef3d8811aD682cE24A514105f713c;
46     address public constant SALE_FUNDS_ADDR = 0xb8E81a87c6D96ed5f424F0A33F13b046C1f24a24;
47     address public constant RESERVE_POOL_ADDR = 0x010aAA10BfB913184C5b2E046143c2ec8A037413;
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 
92 
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100     /**
101     * @dev Multiplies two numbers, throws on overflow.
102     */
103     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         assert(c / a == b);
109         return c;
110     }
111 
112     /**
113     * @dev Integer division of two numbers, truncating the quotient.
114     */
115     function div(uint256 a, uint256 b) internal pure returns(uint256) {
116         // assert(b > 0); // Solidity automatically throws when dividing by 0
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119         return c;
120     }
121 
122     /**
123     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124     */
125     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
126         assert(b <= a);
127         return a - b;
128     }
129 
130     /**
131     * @dev Adds two numbers, throws on overflow.
132     */
133     function add(uint256 a, uint256 b) internal pure returns(uint256) {
134         uint256 c = a + b;
135         assert(c >= a);
136         return c;
137     }
138 }
139 
140 
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable {
147     event Pause();
148     event Unpause();
149 
150     bool public paused = false;
151 
152 
153     /**
154      * @dev Modifier to make a function callable only when the contract is not paused.
155      */
156     modifier whenNotPaused() {
157         require(!paused);
158         _;
159     }
160 
161     /**
162      * @dev Modifier to make a function callable only when the contract is paused.
163      */
164     modifier whenPaused() {
165         require(paused);
166         _;
167     }
168 
169     /**
170      * @dev called by the owner to pause, triggers stopped state
171      */
172     function pause() onlyOwner whenNotPaused public {
173         paused = true;
174         Pause();
175     }
176 
177     /**
178      * @dev called by the owner to unpause, returns to normal state
179      */
180     function unpause() onlyOwner whenPaused public {
181         paused = false;
182         Unpause();
183     }
184 }
185 
186 /**
187  * @title ERC20Basic
188  * @dev Simpler version of ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/179
190  */
191 contract ERC20Basic {
192     function totalSupply() public view returns(uint256);
193     function balanceOf(address who) public view returns(uint256);
194     function transfer(address to, uint256 value) public returns(bool);
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 }
197 
198 
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 contract ERC20 is ERC20Basic {
205     function allowance(address owner, address spender) public view returns(uint256);
206     function transferFrom(address from, address to, uint256 value) public returns(bool);
207     function approve(address spender, uint256 value) public returns(bool);
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 
212 
213 contract DetailedERC20 is ERC20 {
214     string public name;
215     string public symbol;
216     uint8 public decimals;
217 
218     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
219         name = _name;
220         symbol = _symbol;
221         decimals = _decimals;
222     }
223 }
224 
225 
226 
227 /**
228  * @title Basic token
229  * @dev Basic version of StandardToken, with no allowances.
230  */
231 contract BasicToken is ERC20Basic {
232     using SafeMath for uint256;
233 
234         mapping(address => uint256) balances;
235 
236     uint256 totalSupply_;
237 
238     /**
239     * @dev total number of tokens in existence
240     */
241     function totalSupply() public view returns(uint256) {
242         return totalSupply_;
243     }
244 
245     /**
246     * @dev transfer token for a specified address
247     * @param _to The address to transfer to.
248     * @param _value The amount to be transferred.
249     */
250     function transfer(address _to, uint256 _value) public returns(bool) {
251         require(_to != address(0));
252         require(_value <= balances[msg.sender]);
253 
254         // SafeMath.sub will throw if there is not enough balance.
255         balances[msg.sender] = balances[msg.sender].sub(_value);
256         balances[_to] = balances[_to].add(_value);
257         Transfer(msg.sender, _to, _value);
258         return true;
259     }
260 
261     /**
262     * @dev Gets the balance of the specified address.
263     * @param _owner The address to query the the balance of.
264     * @return An uint256 representing the amount owned by the passed address.
265     */
266     function balanceOf(address _owner) public view returns(uint256 balance) {
267         return balances[_owner];
268     }
269 
270 }
271 
272 
273 
274 /**
275  * @title Standard ERC20 token
276  *
277  * @dev Implementation of the basic standard token.
278  * @dev https://github.com/ethereum/EIPs/issues/20
279  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
280  */
281 contract StandardToken is ERC20, BasicToken {
282 
283     mapping(address => mapping(address => uint256)) internal allowed;
284 
285 
286     /**
287      * @dev Transfer tokens from one address to another
288      * @param _from address The address which you want to send tokens from
289      * @param _to address The address which you want to transfer to
290      * @param _value uint256 the amount of tokens to be transferred
291      */
292     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
293         require(_to != address(0));
294         require(_value <= balances[_from]);
295         require(_value <= allowed[_from][msg.sender]);
296 
297         balances[_from] = balances[_from].sub(_value);
298         balances[_to] = balances[_to].add(_value);
299         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300         Transfer(_from, _to, _value);
301         return true;
302     }
303 
304     /**
305      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306      *
307      * Beware that changing an allowance with this method brings the risk that someone may use both the old
308      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      * @param _spender The address which will spend the funds.
312      * @param _value The amount of tokens to be spent.
313      */
314     function approve(address _spender, uint256 _value) public returns(bool) {
315         allowed[msg.sender][_spender] = _value;
316         Approval(msg.sender, _spender, _value);
317         return true;
318     }
319 
320     /**
321      * @dev Function to check the amount of tokens that an owner allowed to a spender.
322      * @param _owner address The address which owns the funds.
323      * @param _spender address The address which will spend the funds.
324      * @return A uint256 specifying the amount of tokens still available for the spender.
325      */
326     function allowance(address _owner, address _spender) public view returns(uint256) {
327         return allowed[_owner][_spender];
328     }
329 
330     /**
331      * @dev Increase the amount of tokens that an owner allowed to a spender.
332      *
333      * approve should be called when allowed[_spender] == 0. To increment
334      * allowed value is better to use this function to avoid 2 calls (and wait until
335      * the first transaction is mined)
336      * From MonolithDAO Token.sol
337      * @param _spender The address which will spend the funds.
338      * @param _addedValue The amount of tokens to increase the allowance by.
339      */
340     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
341         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
342         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343         return true;
344     }
345 
346     /**
347      * @dev Decrease the amount of tokens that an owner allowed to a spender.
348      *
349      * approve should be called when allowed[_spender] == 0. To decrement
350      * allowed value is better to use this function to avoid 2 calls (and wait until
351      * the first transaction is mined)
352      * From MonolithDAO Token.sol
353      * @param _spender The address which will spend the funds.
354      * @param _subtractedValue The amount of tokens to decrease the allowance by.
355      */
356     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
357         uint oldValue = allowed[msg.sender][_spender];
358         if (_subtractedValue > oldValue) {
359             allowed[msg.sender][_spender] = 0;
360         } else {
361             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362         }
363         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364         return true;
365     }
366 
367 }
368 
369 
370 
371 /**
372  * @title Mintable token
373  * @dev Simple ERC20 Token example, with mintable token creation
374  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
375  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
376  */
377 contract MintableToken is StandardToken, Ownable {
378     event Mint(address indexed to, uint256 amount);
379     event MintFinished();
380 
381     bool public mintingFinished = false;
382 
383 
384     modifier canMint() {
385         require(!mintingFinished);
386         _;
387     }
388 
389     /**
390      * @dev Function to mint tokens
391      * @param _to The address that will receive the minted tokens.
392      * @param _amount The amount of tokens to mint.
393      * @return A boolean that indicates if the operation was successful.
394      */
395     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
396         totalSupply_ = totalSupply_.add(_amount);
397         balances[_to] = balances[_to].add(_amount);
398         Mint(_to, _amount);
399         Transfer(address(0), _to, _amount);
400         return true;
401     }
402 
403     /**
404      * @dev Function to stop minting new tokens.
405      * @return True if the operation was successful.
406      */
407     function finishMinting() onlyOwner canMint public returns(bool) {
408         mintingFinished = true;
409         MintFinished();
410         return true;
411     }
412 }
413 
414 
415 
416 /**
417  * @title Capped token
418  * @dev Mintable token with a token cap.
419  */
420 contract CappedToken is MintableToken {
421 
422     uint256 public cap;
423 
424     function CappedToken(uint256 _cap) public {
425         require(_cap > 0);
426         cap = _cap;
427     }
428 
429     /**
430      * @dev Function to mint tokens
431      * @param _to The address that will receive the minted tokens.
432      * @param _amount The amount of tokens to mint.
433      * @return A boolean that indicates if the operation was successful.
434      */
435     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
436         require(totalSupply_.add(_amount) <= cap);
437 
438         return super.mint(_to, _amount);
439     }
440 
441 }
442 
443 
444 /**
445  * @title Burnable Token
446  * @dev Token that can be irreversibly burned (destroyed).
447  */
448 contract BurnableToken is BasicToken {
449 
450     event Burn(address indexed burner, uint256 value);
451 
452     /**
453      * @dev Burns a specific amount of tokens.
454      * @param _value The amount of token to be burned.
455      */
456     function burn(uint256 _value) public {
457         require(_value <= balances[msg.sender]);
458         // no need to require value <= totalSupply, since that would imply the
459         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
460 
461         address burner = msg.sender;
462         balances[burner] = balances[burner].sub(_value);
463         totalSupply_ = totalSupply_.sub(_value);
464         Burn(burner, _value);
465     }
466 }
467 
468 
469 
470 
471 /**
472  * @title GdprCash
473  * @dev GDPR Cash - the token used in the gdpr.cash network.
474  *
475  * All tokens are preminted and distributed at deploy time.
476  * Transfers are disabled until the crowdsale is over. 
477  * All unsold tokens are burned.
478  */
479 contract GdprCash is DetailedERC20, CappedToken, GdprConfig {
480 
481     bool private transfersEnabled = false;
482     address public crowdsale = address(0);
483 
484     /**
485      * @dev Triggered on token burn
486      */
487     event Burn(address indexed burner, uint256 value);
488 
489     /**
490      * @dev Transfers are restricted to the crowdsale and owner only
491      *      until the crowdsale is over.
492      */
493     modifier canTransfer() {
494         require(transfersEnabled || msg.sender == owner || msg.sender == crowdsale);
495         _;
496     }
497 
498     /**
499      * @dev Restriected to the crowdsale only
500      */
501     modifier onlyCrowdsale() {
502         require(msg.sender == crowdsale);
503         _;
504     }
505 
506     /**
507      * @dev Constructor that sets name, symbol, decimals as well as a maximum supply cap.
508      */
509     function GdprCash() public
510     DetailedERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
511     CappedToken(TOTAL_SUPPLY_CAP) {
512     }
513 
514     /**
515      * @dev Sets the crowdsale. Can be invoked only once and by the owner
516      * @param _crowdsaleAddr address The address of the crowdsale contract
517      */
518     function setCrowdsale(address _crowdsaleAddr) external onlyOwner {
519         require(crowdsale == address(0));
520         require(_crowdsaleAddr != address(0));
521         require(!transfersEnabled);
522         crowdsale = _crowdsaleAddr;
523 
524         // Generate sale tokens
525         mint(crowdsale, SALE_CAP);
526 
527         // Distribute non-sale tokens to pools
528         mint(EXPERTS_POOL_ADDR, EXPERTS_POOL_TOKENS);
529         mint(MARKETING_POOL_ADDR, MARKETING_POOL_TOKENS);
530         mint(TEAM_POOL_ADDR, TEAM_POOL_TOKENS);
531         mint(LEGAL_EXPENSES_ADDR, LEGAL_EXPENSES_TOKENS);
532         mint(RESERVE_POOL_ADDR, RESERVE_POOL_TOKENS);
533 
534         finishMinting();
535     }
536 
537     /**
538      * @dev Checks modifier and transfers
539      * @param _to address The address which you want to transfer to
540      * @param _value uint256 the amount of tokens to be transferred
541      */
542     function transfer(address _to, uint256 _value)
543         public canTransfer returns(bool)
544     {
545         return super.transfer(_to, _value);
546     }
547 
548     /**
549      * @dev Checks modifier and transfers
550      * @param _from address The address which you want to send tokens from
551      * @param _to address The address which you want to transfer to
552      * @param _value uint256 the amount of tokens to be transferred
553      */
554     function transferFrom(address _from, address _to, uint256 _value)
555         public canTransfer returns(bool)
556     {
557         return super.transferFrom(_from, _to, _value);
558     }
559 
560     /**
561      * @dev Enables token transfers.
562      * Called when the token sale is successfully finalized
563      */
564     function enableTransfers() public onlyCrowdsale {
565         transfersEnabled = true;
566     }
567 
568     /**
569     * @dev Burns a specific number of tokens.
570     * @param _value uint256 The number of tokens to be burned.
571     */
572     function burn(uint256 _value) public onlyCrowdsale {
573         require(_value <= balances[msg.sender]);
574 
575         address burner = msg.sender;
576         balances[burner] = balances[burner].sub(_value);
577         totalSupply_ = totalSupply_.sub(_value);
578         Burn(burner, _value);
579     }
580 }
581 
582 
583 
584 
585 
586 /**
587  * @title GDPR Crowdsale
588  * @dev GDPR Cash crowdsale contract. 
589  */
590 contract GdprCrowdsale is Pausable {
591     using SafeMath for uint256;
592 
593         // Token contract
594         GdprCash public token;
595 
596     // Start and end timestamps where investments are allowed (both inclusive)
597     uint256 public startTime;
598     uint256 public endTime;
599 
600     // Address where funds are collected
601     address public wallet;
602 
603     // How many token units a buyer gets per wei
604     uint256 public rate;
605 
606     // Amount of raised money in wei
607     uint256 public weiRaised = 0;
608 
609     // Total amount of tokens purchased
610     uint256 public totalPurchased = 0;
611 
612     // Purchases
613     mapping(address => uint256) public tokensPurchased;
614 
615     // Whether the crowdsale is finalized
616     bool public isFinalized = false;
617 
618     // Crowdsale events
619     /**
620      * Event for token purchase logging
621      * @param purchaser who paid for the tokens
622      * @param beneficiary who got the tokens
623      * @param value weis paid for purchase
624      * @param amount amount of tokens purchased
625      */
626     event TokenPurchase(
627         address indexed purchaser,
628         address indexed beneficiary,
629         uint256 value,
630         uint256 amount);
631 
632     /**
633     * Event for token purchase logging
634     * @param purchaser who paid for the tokens
635     * @param amount amount of tokens purchased
636     */
637     event TokenPresale(
638         address indexed purchaser,
639         uint256 amount);
640 
641     /**
642      * Event invoked when the rate is changed
643      * @param newRate The new rate GDPR / ETH
644      */
645     event RateChange(uint256 newRate);
646 
647     /**
648      * Triggered when ether is withdrawn to the sale wallet
649      * @param amount How many funds to withdraw in wei
650      */
651     event FundWithdrawal(uint256 amount);
652 
653     /**
654      * Event for crowdsale finalization
655      */
656     event Finalized();
657 
658     /**
659      * @dev GdprCrowdsale contract constructor
660      * @param _startTime uint256 Unix timestamp representing the crowdsale start time
661      * @param _endTime uint256 Unix timestamp representing the crowdsale end time
662      * @param _tokenAddress address Address of the GDPR Cash token contract
663      */
664     function GdprCrowdsale(
665         uint256 _startTime,
666         uint256 _endTime,
667         address _tokenAddress
668     ) public
669     {
670         require(_endTime > _startTime);
671         require(_tokenAddress != address(0));
672 
673         startTime = _startTime;
674         endTime = _endTime;
675         token = GdprCash(_tokenAddress);
676         rate = token.INITIAL_RATE();
677         wallet = token.SALE_FUNDS_ADDR();
678     }
679 
680     /**
681      * @dev Fallback function is used to buy tokens.
682      * It's the only entry point since `buyTokens` is internal.
683      * When paused funds are not accepted.
684      */
685     function () public whenNotPaused payable {
686         buyTokens(msg.sender, msg.value);
687     }
688 
689     /**
690      * @dev Sets a new start date as long as token sale hasn't started yet
691      * @param _startTime uint256 Unix timestamp of the new start time
692      */
693     function setStartTime(uint256 _startTime) public onlyOwner {
694         require(now < startTime);
695         require(_startTime > now);
696         require(_startTime < endTime);
697 
698         startTime = _startTime;
699     }
700 
701     /**
702      * @dev Sets a new end date as long as end date hasn't been reached
703      * @param _endTime uint2t56 Unix timestamp of the new end time
704      */
705     function setEndTime(uint256 _endTime) public onlyOwner {
706         require(now < endTime);
707         require(_endTime > now);
708         require(_endTime > startTime);
709 
710         endTime = _endTime;
711     }
712 
713     /**
714      * @dev Updates the GDPR/ETH conversion rate
715      * @param _rate uint256 Updated conversion rate
716      */
717     function setRate(uint256 _rate) public onlyOwner {
718         require(_rate > 0);
719         rate = _rate;
720         RateChange(rate);
721     }
722 
723     /**
724      * @dev Must be called after crowdsale ends, to do some extra finalization
725      * work. Calls the contract's finalization function.
726      */
727     function finalize() public onlyOwner {
728         require(now > endTime);
729         require(!isFinalized);
730 
731         finalization();
732         Finalized();
733 
734         isFinalized = true;
735     }
736 
737     /**
738      * @dev Anyone can check if the crowdsale is over
739      * @return true if crowdsale has endeds
740      */
741     function hasEnded() public view returns(bool) {
742         return now > endTime;
743     }
744 
745     /**
746      * @dev Transfers ether to the sale wallet
747      * @param _amount uint256 The amount to withdraw. 
748      * If 0 supplied transfers the entire balance.
749      */
750     function withdraw(uint256 _amount) public onlyOwner {
751         require(this.balance > 0);
752         require(_amount <= this.balance);
753         uint256 balanceToSend = _amount;
754         if (balanceToSend == 0) {
755             balanceToSend = this.balance;
756         }
757         wallet.transfer(balanceToSend);
758         FundWithdrawal(balanceToSend);
759     }
760 
761     /**
762      *  @dev Registers a presale order
763      *  @param _participant address The address of the token purchaser
764      *  @param _tokenAmount uin256 The amount of GDPR Cash (in wei) purchased
765      */
766     function addPresaleOrder(address _participant, uint256 _tokenAmount) external onlyOwner {
767         require(now < startTime);
768 
769         // Update state
770         tokensPurchased[_participant] = tokensPurchased[_participant].add(_tokenAmount);
771         totalPurchased = totalPurchased.add(_tokenAmount);
772 
773         token.transfer(_participant, _tokenAmount);
774 
775         TokenPresale(
776             _participant,
777             _tokenAmount
778         );
779     }
780 
781     /**
782      *  @dev Token purchase logic. Used internally.
783      *  @param _participant address The address of the token purchaser
784      *  @param _weiAmount uin256 The amount of ether in wei sent to the contract
785      */
786     function buyTokens(address _participant, uint256 _weiAmount) internal {
787         require(_participant != address(0));
788         require(now >= startTime);
789         require(now < endTime);
790         require(!isFinalized);
791         require(_weiAmount != 0);
792 
793         // Calculate the token amount to be allocated
794         uint256 tokens = _weiAmount.mul(rate);
795 
796         // Update state
797         tokensPurchased[_participant] = tokensPurchased[_participant].add(tokens);
798         totalPurchased = totalPurchased.add(tokens);
799         // update state
800         weiRaised = weiRaised.add(_weiAmount);
801 
802         require(totalPurchased <= token.SALE_CAP());
803         require(tokensPurchased[_participant] >= token.PURCHASER_MIN_TOKEN_CAP());
804 
805         if (now < startTime + 86400) {
806             // if still during the first day of token sale, apply different max cap
807             require(tokensPurchased[_participant] <= token.PURCHASER_MAX_TOKEN_CAP_DAY1());
808         } else {
809             require(tokensPurchased[_participant] <= token.PURCHASER_MAX_TOKEN_CAP());
810         }
811 
812         token.transfer(_participant, tokens);
813 
814         TokenPurchase(
815             msg.sender,
816             _participant,
817             _weiAmount,
818             tokens
819         );
820     }
821 
822     /**
823      * @dev Additional finalization logic. 
824      * Enables token transfers and burns all unsold tokens.
825      */
826     function finalization() internal {
827         withdraw(0);
828         burnUnsold();
829         token.enableTransfers();
830     }
831 
832     /**
833      * @dev Burn all remaining (unsold) tokens.
834      * This should be called automatically after sale finalization
835      */
836     function burnUnsold() internal {
837         // All tokens held by this contract get burned
838         token.burn(token.balanceOf(this));
839     }
840 }