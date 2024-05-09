1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52     /**
53     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54     * account.
55     */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     /**
61     * @dev Throws if called by any account other than the owner.
62     */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69     * @dev Allows the current owner to transfer control of the contract to a newOwner.
70     * @param newOwner The address to transfer ownership to.
71     */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78 }
79 
80 contract ERC20Basic {
81     function totalSupply() public view returns (uint256);
82     function balanceOf(address who) public view returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88     function allowance(address owner, address spender) public view returns (uint256);
89     function transferFrom(address from, address to, uint256 value) public returns (bool);
90     function approve(address spender, uint256 value) public returns (bool);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract BasicToken is ERC20Basic {
95     using SafeMath for uint256;
96 
97     mapping(address => uint256) balances;
98 
99     uint256 totalSupply_;
100 
101     /**
102     * @dev total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     /**
109     * @dev transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116 
117         // SafeMath.sub will throw if there is not enough balance.
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         emit Transfer(msg.sender, _to, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141     * @dev Transfer tokens from one address to another
142     * @param _from address The address which you want to send tokens from
143     * @param _to address The address which you want to transfer to
144     * @param _value uint256 the amount of tokens to be transferred
145     */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160     *
161     * Beware that changing an allowance with this method brings the risk that someone may use both the old
162     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165     * @param _spender The address which will spend the funds.
166     * @param _value The amount of tokens to be spent.
167     */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Function to check the amount of tokens that an owner allowed to a spender.
176     * @param _owner address The address which owns the funds.
177     * @param _spender address The address which will spend the funds.
178     * @return A uint256 specifying the amount of tokens still available for the spender.
179     */
180     function allowance(address _owner, address _spender) public view returns (uint256) {
181         return allowed[_owner][_spender];
182     }
183 
184     /**
185     * @dev Increase the amount of tokens that an owner allowed to a spender.
186     *
187     * approve should be called when allowed[_spender] == 0. To increment
188     * allowed value is better to use this function to avoid 2 calls (and wait until
189     * the first transaction is mined)
190     * From MonolithDAO Token.sol
191     * @param _spender The address which will spend the funds.
192     * @param _addedValue The amount of tokens to increase the allowance by.
193     */
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     /**
201     * @dev Decrease the amount of tokens that an owner allowed to a spender.
202     *
203     * approve should be called when allowed[_spender] == 0. To decrement
204     * allowed value is better to use this function to avoid 2 calls (and wait until
205     * the first transaction is mined)
206     * From MonolithDAO Token.sol
207     * @param _spender The address which will spend the funds.
208     * @param _subtractedValue The amount of tokens to decrease the allowance by.
209     */
210     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221 }
222 
223 library SafeERC20 {
224     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
225         assert(token.transfer(to, value));
226     }
227 
228     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
229         assert(token.transferFrom(from, to, value));
230     }
231 
232     function safeApprove(ERC20 token, address spender, uint256 value) internal {
233         assert(token.approve(spender, value));
234     }
235 }
236 
237 contract MintableToken is StandardToken, Ownable {
238     event Mint(address indexed to, uint256 amount);
239     event MintFinished();
240 
241     bool public mintingFinished = false;
242 
243 
244     modifier canMint() {
245         require(!mintingFinished);
246         _;
247     }
248 
249     /**
250     * @dev Function to mint tokens
251     * @param _to The address that will receive the minted tokens.
252     * @param _amount The amount of tokens to mint.
253     * @return A boolean that indicates if the operation was successful.
254     */
255     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
256         totalSupply_ = totalSupply_.add(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         emit Mint(_to, _amount);
259         emit Transfer(address(0), _to, _amount);
260         return true;
261     }
262 
263     /**
264     * @dev Function to stop minting new tokens.
265     * @return True if the operation was successful.
266     */
267     function finishMinting() onlyOwner canMint public returns (bool) {
268         mintingFinished = true;
269         emit MintFinished();
270         return true;
271     }
272 }
273 
274 
275 contract APOToken is MintableToken {
276     string public name = "Advanced Parimutuel Options";
277     string public symbol = "APO";
278     uint8 public decimals = 18;
279 }
280 
281 contract TokenTimelock {
282     
283     using SafeERC20 for ERC20Basic;
284 
285     // ERC20 basic token contract being held
286     ERC20Basic public token;
287 
288     // beneficiary of tokens after they are released
289     address public beneficiary;
290 
291     // timestamp when token release is enabled
292     uint256 public releaseTime;
293     
294     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
295         require(_releaseTime > now);
296         token = _token;
297         beneficiary = _beneficiary;
298         releaseTime = _releaseTime;
299     }
300 
301     /**
302     * @notice Transfers tokens held by timelock to beneficiary.
303     */
304     function release() public {
305         require(now >= releaseTime);
306 
307         uint256 amount = token.balanceOf(this);
308         require(amount > 0);
309 
310         token.safeTransfer(beneficiary, amount);
311     }
312     
313 }
314 
315 contract RefundVault is Ownable {
316     using SafeMath for uint256;   
317     
318     enum State { Active, Refunding, Closed }
319 
320     mapping (address => uint256) public deposited;
321     address public wallet;
322     State public state;
323     //  
324      
325     event Closed();
326     event RefundsEnabled();
327     event Refunded(address indexed beneficiary, uint256 weiAmount);
328     
329      
330     /**
331     * @param _wallet Vault address
332     */
333     function RefundVault(address _wallet) public {
334         require(_wallet != address(0));
335         wallet = _wallet;
336         state = State.Active;
337     }
338     
339     /**
340     * @param investor Investor address
341     */
342     function deposit(address investor) onlyOwner public payable {
343         require(state == State.Active);
344         deposited[investor] = deposited[investor].add(msg.value);
345     }
346     
347     function close() onlyOwner public  {
348         require(state == State.Active);
349         state = State.Closed;
350         emit Closed();
351         wallet.transfer(address(this).balance); // check
352     }
353 
354     function enableRefunds() onlyOwner public {
355         require(state == State.Active);
356         state = State.Refunding;
357         emit RefundsEnabled();
358     }
359 
360     /**
361     * @param investor Investor address
362     */
363     function refund(address investor) public {
364         require(state == State.Refunding);
365         uint256 depositedValue = deposited[investor];
366         deposited[investor] = 0;
367         investor.transfer(depositedValue);
368         emit Refunded(investor, depositedValue);
369     }
370      
371 }
372 
373 contract Crowdsale {
374     
375   using SafeMath for uint256;
376   
377     // The token being sold
378     ERC20 public token;
379 
380     // Address where funds are collected
381     address public wallet;
382 
383     // How many token units a buyer gets per wei
384     uint256 public rate;
385 
386     // Amount of wei raised
387     uint256 public weiRaised;
388     
389     
390    /**
391     * Event for token purchase logging
392     * @param purchaser who paid for the tokens
393     * @param beneficiary who got the tokens
394     * @param value weis paid for purchase
395     * @param amount amount of tokens purchased
396     */
397     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
398 
399     function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public 
400     {
401     require(_rate > 0);
402     require(_wallet != address(0));
403     require(_token != address(0));
404 
405     rate = _rate;
406     wallet = _wallet;
407     token = _token;
408     }
409   
410     // -----------------------------------------
411     // Crowdsale external interface
412     // -----------------------------------------
413 
414    /**
415     * @dev fallback function ***DO NOT OVERRIDE***
416     */
417     function () external payable {
418         buyTokens(msg.sender);
419     }
420     
421    /**
422     * @dev low level token purchase ***DO NOT OVERRIDE***
423     * @param _beneficiary Address performing the token purchase
424     */
425     function buyTokens(address _beneficiary) public payable {
426 
427         uint256 weiAmount = msg.value;
428         _preValidatePurchase(_beneficiary, weiAmount);
429 
430         // calculate token amount to be created
431         uint256 tokens = _getTokenAmount(weiAmount);
432 
433         // update state
434         weiRaised = weiRaised.add(weiAmount);
435 
436         _processPurchase(_beneficiary, tokens);
437         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
438         
439         _forwardFunds();
440     }
441 
442     // -----------------------------------------
443     // Internal interface (extensible)
444     // -----------------------------------------
445 
446 
447     /**
448     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
449     * @param _beneficiary Address performing the token purchase
450     * @param _weiAmount Value in wei involved in the purchase
451     */
452     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
453         require(_beneficiary != address(0));
454         require(_weiAmount != 0);
455     }
456 
457 
458     /**
459     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
460     * @param _beneficiary Address performing the token purchase
461     * @param _tokenAmount Number of tokens to be emitted
462     */
463     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
464         token.transfer(_beneficiary, _tokenAmount);
465     }
466 
467 
468     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
469         _deliverTokens(_beneficiary, _tokenAmount);
470     }
471 
472 
473     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
474         uint256 etherAmount = _weiAmount.mul(rate).div(1 ether);
475         return etherAmount;
476     }
477 
478 
479     /**
480     * @dev Determines how ETH is stored/forwarded on purchases.
481     */
482     function _forwardFunds() internal {
483         wallet.transfer(msg.value);
484     }
485     
486 }
487 
488 contract APOTokenCrowdsale is Ownable, Crowdsale  {
489 
490     // The token being sold
491     APOToken public token = new APOToken();
492     
493     // Locked Tokens for 12 month
494     TokenTimelock public teamTokens;
495     TokenTimelock public reserveTokens;
496     
497     // Address where funds are collected
498     address public wallet;
499     
500     // Address of ither wallets
501     address public bountyWallet;
502     
503     address public privateWallet;
504     
505     // refund vault used to hold funds while crowdsale is running
506     RefundVault public vault = new RefundVault(msg.sender);
507 
508     // How many token units a buyer gets per wei
509     uint256 public rate = 15000;
510 
511     // ICO start time
512     uint256 public startTime = 1524650400;
513     
514     // ICO end time
515     uint256 public endTime = 1527069599;
516     
517     // Min Amount for Purchase
518     uint256 public minAmount = 0.1 * 1 ether;
519     
520     // Soft Cap
521     uint256 public softCap = 5500 * 1 ether;
522     
523     // Hard Cap
524     uint256 public hardCap = 12700 * 1 ether;
525     
526     // Unlock Date
527     uint256 public unlockTime = endTime + 1 years;
528     
529     // Discount
530     uint256 public discountPeriod =  1 weeks;
531          
532     // Finished
533     bool public isFinalized = false;
534 
535     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
536     event Finalized();
537 
538     modifier onlyWhileOpen {
539         require(now >= startTime && now <= endTime);
540         _;
541     }
542     
543     // Initial function
544     function APOTokenCrowdsale() public
545     Crowdsale(rate, vault, token) 
546     {
547         wallet = msg.sender;
548         bountyWallet = 0x06F05ebdf3b871813f80C4A1744e66357B0d9e44;
549         privateWallet = 0xb62109986F19f710415e71F27fAaF4ece89eFf83;
550         teamTokens = new TokenTimelock(token, msg.sender, unlockTime);
551         reserveTokens = new TokenTimelock(token, 0x2700C56A67F12899a4CB9316ab6541d90EcE52E9, unlockTime);
552     }
553 
554 
555     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
556         require(_beneficiary != address(0));
557         require(_weiAmount != 0);
558         require(_weiAmount >= minAmount);
559         require(weiRaised.add(_weiAmount) <= hardCap);
560     }
561     
562 
563     /**
564     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
565     * @param _beneficiary Address performing the token purchase
566     * @param _tokenAmount Number of tokens to be emitted
567     */
568     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
569         // Calculate discount rate
570         if (now <= startTime + 1 * discountPeriod) {
571             _tokenAmount = _tokenAmount.mul(125).div(100);
572         } else if ((now > startTime + 1 * discountPeriod) && (now <= startTime + 2 * discountPeriod))  {
573             _tokenAmount = _tokenAmount.mul(115).div(100);
574         } else if ((now > startTime + 2 * discountPeriod) && (now <= startTime + 3 * discountPeriod))  {
575             _tokenAmount = _tokenAmount.mul(105).div(100);
576         }
577         
578         // Mint token for contributor
579         token.mint(_beneficiary, _tokenAmount);
580     }
581 
582 
583     /**
584     * @dev Determines how ETH is stored/forwarded on purchases.
585     */
586     function _forwardFunds() internal {
587         vault.deposit.value(msg.value)(msg.sender);
588     }
589 
590 
591     /**
592     * @dev Checks whether the cap has been reached. 
593     * @return Whether the cap was reached
594     */
595     function capReached() public view returns (bool) {
596         return weiRaised >= hardCap;
597     }
598 
599 
600     /**
601     * @dev Must be called after crowdsale ends, to do some extra finalization
602     * work. Calls the contract's finalization function.
603     */
604     function finalize() onlyOwner public {
605         require(!isFinalized);
606         require(hasClosed());
607         
608         // Finalize
609         finalization();
610         emit Finalized();
611 
612         isFinalized = true;
613     }
614 
615 
616     /**
617     * @dev Can be overridden to add finalization logic. The overriding function
618     * should call super.finalization() to ensure the chain of finalization is
619     * executed entirely.
620     */
621     function finalization() internal {
622         // 
623         if (goalReached()) {
624             
625             vault.close();
626             
627             // For team - 20%, reserve - 25%, bounty - 5%, private investors - 10%
628             uint issuedTokenSupply = token.totalSupply();
629             uint teamPercent = issuedTokenSupply.mul(20).div(40);
630             uint reservePercent = issuedTokenSupply.mul(25).div(40);
631             uint bountyPercent = issuedTokenSupply.mul(5).div(40);
632             uint privatePercent = issuedTokenSupply.mul(10).div(40);   
633             
634             // Mint
635             token.mint(teamTokens, teamPercent);
636             token.mint(reserveTokens, reservePercent);
637             token.mint(bountyWallet, bountyPercent);
638             token.mint(privateWallet, privatePercent);
639             
640             // Finish minting
641             token.finishMinting();
642             
643         } else {
644             vault.enableRefunds();
645             // Finish minting
646             token.finishMinting();
647         }
648         
649     }
650 
651 
652     /**
653     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
654     * @return Whether crowdsale period has elapsed
655     */
656     function hasClosed() public view returns (bool) {
657         return now > endTime;
658     }
659 
660 
661     /**
662     * @dev Investors can claim refunds here if crowdsale is unsuccessful
663     */
664     function claimRefund() public {
665         require(isFinalized);
666         require(!goalReached());
667 
668         vault.refund(msg.sender);
669     }
670     
671 
672     /**
673     * @dev Checks whether funding goal was reached. 
674     * @return Whether funding goal was reached
675     */
676     function goalReached() public view returns (bool) {
677         return weiRaised >= softCap;
678     }
679 
680 }