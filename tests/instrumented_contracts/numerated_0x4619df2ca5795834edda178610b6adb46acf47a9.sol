1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   constructor() public { owner = msg.sender;  }
7  
8   modifier onlyOwner() {     
9       address sender =  msg.sender;
10       address _owner = owner;
11       require(msg.sender == _owner);    
12       _;  
13   }
14   
15   function transferOwnership(address newOwner) onlyOwner public { 
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) public constant returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) public constant returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83   
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) allowed;
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     uint256 _allowance = allowed[_from][msg.sender];
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     emit Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 contract MintableToken is StandardToken, Ownable {
174   event Mint(address indexed to, uint256 amount);
175   event MintFinished();
176 
177   bool public mintingFinished = false;
178 
179   modifier canMint() {
180     require(!mintingFinished);
181     _;
182   }
183 
184   /**
185    * @dev Function to mint tokens
186    * @param _to The address that will receive the minted tokens.
187    * @param _amount The amount of tokens to mint.
188    * @return A boolean that indicates if the operation was successful.
189    */
190   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
191     totalSupply = totalSupply.add(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     emit Mint(_to, _amount);
194     emit Transfer(0x0, _to, _amount);
195     return true;
196   }
197   
198   /**
199    * @dev Function to mint tokens
200    * @param _to The address that will receive the minted tokens.
201    * @param _amount The amount of tokens to mint.
202    * @return A boolean that indicates if the operation was successful.
203    */
204   function mintFinalize(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
205     totalSupply = totalSupply.add(_amount);
206     balances[_to] = balances[_to].add(_amount);
207     emit Mint(_to, _amount);
208     emit Transfer(0x0, _to, _amount);
209     return true;
210   }
211 
212   /**
213    * @dev Function to stop minting new tokens.
214    * @return True if the operation was successful.
215    */
216   function finishMinting() onlyOwner public returns (bool) {
217     mintingFinished = true;
218     emit MintFinished();
219     return true;
220   }
221 }
222 
223 /**
224  * @title SwordToken
225  * @dev Sword ERC20 Token that can be minted.
226  * It is meant to be used in Sword crowdsale contract.
227  */
228 contract SwordToken is MintableToken {
229 
230     string public constant name = "Sword Coin"; 
231     string public constant symbol = "SWDC";
232     uint8 public constant decimals = 18;
233 
234     function getTotalSupply() view public returns (uint256) {
235         return totalSupply;
236     }
237     
238     function transfer(address _to, uint256 _value) public returns (bool) {
239         super.transfer(_to, _value);
240     }
241     
242 }
243 
244 contract KycContractInterface {
245     function isAddressVerified(address _address) public view returns (bool);
246 }
247 
248 contract KycContract is Ownable {
249     
250     mapping (address => bool) verifiedAddresses;
251     
252     function isAddressVerified(address _address) public view returns (bool) {
253         return verifiedAddresses[_address];
254     }
255     
256     function addAddress(address _newAddress) public onlyOwner {
257         require(!verifiedAddresses[_newAddress]);
258         
259         verifiedAddresses[_newAddress] = true;
260     }
261     
262     function removeAddress(address _oldAddress) public onlyOwner {
263         require(verifiedAddresses[_oldAddress]);
264         
265         verifiedAddresses[_oldAddress] = false;
266     }
267     
268     function batchAddAddresses(address[] _addresses) public onlyOwner {
269         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
270             assert(!verifiedAddresses[_addresses[cnt]]);
271             verifiedAddresses[_addresses[cnt]] = true;
272         }
273     }
274 }
275 
276 
277 /**
278  * @title SwordCrowdsale
279  * @dev This is Sword's crowdsale contract.
280  */
281 contract SwordCrowdsale is Ownable {
282     using SafeMath for uint256;
283     
284     // start and end timestamps where investments are allowed (both inclusive)
285     uint256 public startTime;
286     uint256 public endTime;
287     // amount of raised money in wei
288     uint256 public weiRaised;
289     uint256 public limitDateSale; // end date in units
290    
291     bool public isSoftCapHit = false;
292     bool public isStarted = false;
293     bool public isFinalized = false;
294    
295    struct ContributorData {
296         uint256 contributionAmount;
297         uint256 tokensIssued;
298     }
299    
300    address[] public tokenSendFailures;
301    
302     mapping(address => ContributorData) public contributorList;
303     mapping(uint => address) contributorIndexes;
304     uint nextContributorIndex;
305 
306     constructor() public {}
307     
308    function init(uint256 _totalTokens, uint256 _tokensForCrowdsale, address _wallet, 
309         uint256 _etherInUSD, address _tokenAddress, uint256 _softCapInEthers, uint256 _hardCapInEthers, 
310         uint _saleDurationInDays, address _kycAddress, uint bonus) onlyOwner public {
311         
312         setTotalTokens(_totalTokens);
313         setTokensForCrowdSale(_tokensForCrowdsale);
314         setWallet(_wallet);
315         setRate(_etherInUSD);
316         setTokenAddress(_tokenAddress);
317         setSoftCap(_softCapInEthers);
318         setHardCap(_hardCapInEthers);
319         setSaleDuration(_saleDurationInDays);
320         setKycAddress(_kycAddress);
321         setSaleBonus(bonus);
322         kyc = KycContract(_kycAddress);
323         start(); // starting the crowdsale
324    }
325    
326     /**
327     * @dev Must be called to start the crowdsale
328     */
329     function start() onlyOwner public {
330         require(!isStarted);
331         require(!hasStarted());
332         require(wallet != address(0));
333         require(tokenAddress != address(0));
334         require(kycAddress != address(0));
335         require(rate != 0);
336         require(saleDuration != 0);
337         require(totalTokens != 0);
338         require(tokensForCrowdSale != 0);
339         require(softCap != 0);
340         require(hardCap != 0);
341         
342         starting();
343         emit SwordStarted();
344         
345         isStarted = true;
346     }
347   
348   
349    uint256 public totalTokens = 0;
350    function setTotalTokens(uint256 _totalTokens) onlyOwner public {
351        totalTokens = _totalTokens * (10 ** 18); // Total 1 billion tokens, 75 percent will be sold
352    }
353     
354    uint256 public tokensForCrowdSale = 0;
355    function setTokensForCrowdSale(uint256 _tokensForCrowdsale) onlyOwner public {
356        tokensForCrowdSale = _tokensForCrowdsale * (10 ** 18); // Total 1 billion tokens, 75 percent will be sold 
357    }
358  
359     // address where funds are collected
360     address public wallet = 0x0;
361     function setWallet(address _wallet) onlyOwner public {
362         wallet = _wallet;
363     } 
364 
365     uint256 public rate = 0;
366     function setRate(uint256 _etherInUSD) public onlyOwner{
367          rate = (5 * (10**18) / 100) / _etherInUSD;
368     }
369     
370     // The token being sold
371     SwordToken public token;
372     address tokenAddress = 0x0; 
373     function setTokenAddress(address _tokenAddress) public onlyOwner {
374         tokenAddress = _tokenAddress; // to check if token address is provided at start
375         token = SwordToken(_tokenAddress);
376     }
377 
378    uint256 public softCap = 0;
379    function setSoftCap(uint256 _softCap) onlyOwner public {
380        softCap = _softCap * (10 ** 18); 
381     }
382    
383    uint256 public hardCap = 0; 
384    function setHardCap(uint256 _hardCap) onlyOwner public {
385        hardCap = _hardCap * (10 ** 18); 
386    }
387   
388     // sale period (includes holidays)
389     uint public saleDuration = 0; // in days ex: 60.
390     function setSaleDuration(uint _saleDurationInDays) onlyOwner public {
391         saleDuration = _saleDurationInDays;
392 		limitDateSale = startTime + (saleDuration * 1 days);
393         endTime = limitDateSale;
394     }
395   
396     address kycAddress = 0x0;
397     function setKycAddress(address _kycAddress) onlyOwner public {
398         kycAddress = _kycAddress;
399     }
400 	
401     uint public saleBonus = 0; // ex. 10
402     function setSaleBonus(uint bonus) public onlyOwner{
403         saleBonus = bonus;
404     }
405   
406    bool public isKYCRequiredToReceiveFunds = true; // whether Kyc is required to receive funds.
407     function setKYCRequiredToReceiveFunds(bool IS_KYCRequiredToReceiveFunds) public onlyOwner{
408         isKYCRequiredToReceiveFunds = IS_KYCRequiredToReceiveFunds;
409     }
410     
411     bool public isKYCRequiredToSendTokens = true; // whether Kyc is required to send tokens.
412       function setKYCRequiredToSendTokens(bool IS_KYCRequiredToSendTokens) public onlyOwner{
413         isKYCRequiredToSendTokens = IS_KYCRequiredToSendTokens;
414     }
415     
416     
417     // fallback function can be used to buy tokens
418     function () public payable {
419         buyTokens(msg.sender);
420     }
421     
422    KycContract public kyc;
423    function transferKycOwnerShip(address _address) onlyOwner public {
424        kyc.transferOwnership(_address);
425    }
426    
427    function transferTokenOwnership(address _address) onlyOwner public {
428        token.transferOwnership(_address);
429    }
430    
431     /**
432      * release Tokens
433      */
434     function releaseAllTokens() onlyOwner public {
435         for(uint i=0; i < nextContributorIndex; i++) {
436             address addressToSendTo = contributorIndexes[i]; // address of user
437             releaseTokens(addressToSendTo);
438         }
439     }
440     
441     /**
442      * release Tokens of an individual address
443      */
444     function releaseTokens(address _contributerAddress) onlyOwner public {
445         if(isKYCRequiredToSendTokens){
446              if(KycContractInterface(kycAddress).isAddressVerified(_contributerAddress)){ // if kyc needs to be checked at release time
447                 release(_contributerAddress);
448              }
449         } else {
450             release(_contributerAddress);
451         }
452     }
453     
454     function release(address _contributerAddress) internal {
455         if(contributorList[_contributerAddress].tokensIssued > 0) { 
456             if(token.mint(_contributerAddress, contributorList[_contributerAddress].tokensIssued)) { // tokens sent successfully
457                 contributorList[_contributerAddress].tokensIssued = 0;
458                 contributorList[_contributerAddress].contributionAmount = 0;
459             } else { // token sending failed, has to be processed manually
460                 tokenSendFailures.push(_contributerAddress);
461             }
462         }
463     }
464     
465     function tokenSendFailuresCount() public view returns (uint) {
466         return tokenSendFailures.length;
467     }
468    
469     function buyTokens(address beneficiary) public payable {
470         require(beneficiary != address(0));
471         require(validPurchase());
472         if(isKYCRequiredToReceiveFunds){
473             require(KycContractInterface(kycAddress).isAddressVerified(msg.sender));
474         }
475 
476         uint256 weiAmount = msg.value;
477 
478         // calculate token amount to be created
479         uint256 tokens = computeTokens(weiAmount);
480 
481         require(isWithinTokenAllocLimit(tokens));
482 
483         // update state - Add to eth raised
484         weiRaised = weiRaised.add(weiAmount);
485 
486         if (contributorList[beneficiary].contributionAmount == 0) { // if its a new contributor, add him and increase index
487             contributorIndexes[nextContributorIndex] = beneficiary;
488             nextContributorIndex += 1;
489         }
490         contributorList[beneficiary].contributionAmount += weiAmount;
491         contributorList[beneficiary].tokensIssued += tokens;
492 
493         emit SwordTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
494         handleFunds();
495     }
496   
497       /**
498     * event for token purchase logging
499     * @param purchaser who paid for the tokens
500     * @param beneficiary who got the tokens
501     * @param value weis paid for purchase
502     * @param amount amount of tokens purchased
503     */
504     event SwordTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
505   
506     function investorCount() constant public returns(uint) {
507         return nextContributorIndex;
508     }
509     
510     // @return true if crowdsale event has started
511     function hasStarted() public constant returns (bool) {
512         return (startTime != 0 && now > startTime);
513     }
514 
515     // send ether to the fund collection wallet
516     function forwardFunds() internal {
517         wallet.transfer(msg.value);
518     }
519     
520      // send ether to the fund collection wallet
521     function forwardAllRaisedFunds() internal {
522         wallet.transfer(weiRaised);
523     }
524 
525     function isWithinSaleTimeLimit() internal view returns (bool) {
526         return now <= limitDateSale;
527     }
528 
529     function isWithinSaleLimit(uint256 _tokens) internal view returns (bool) {
530         return token.getTotalSupply().add(_tokens) <= tokensForCrowdSale;
531     }
532 
533     function computeTokens(uint256 weiAmount) view internal returns (uint256) {
534         uint256 appliedBonus = 0;
535         if (isWithinSaleTimeLimit()) {
536             appliedBonus = saleBonus;
537         } 
538         return (weiAmount.div(rate) + (weiAmount.div(rate).mul(appliedBonus).div(100))) * (10 ** 18);
539     }
540     
541     function isWithinTokenAllocLimit(uint256 _tokens) view internal returns (bool) {
542         return (isWithinSaleTimeLimit() && isWithinSaleLimit(_tokens));
543     }
544 
545     function didSoftCapReached() internal returns (bool) {
546         if(weiRaised >= softCap){
547             isSoftCapHit = true; // setting the flag that soft cap is hit and all funds should be sent directly to wallet from now on.
548         } else {
549             isSoftCapHit = false;
550         }
551         return isSoftCapHit;
552     }
553 
554     // overriding SwordBaseCrowdsale#validPurchase to add extra cap logic
555     // @return true if investors can buy at the moment
556     function validPurchase() internal constant returns (bool) {
557         bool withinCap = weiRaised.add(msg.value) <= hardCap;
558         bool withinPeriod = now >= startTime && now <= endTime; 
559         bool nonZeroPurchase = msg.value != 0; 
560         return (withinPeriod && nonZeroPurchase) && withinCap && isWithinSaleTimeLimit();
561     }
562 
563     // overriding Crowdsale#hasEnded to add cap logic
564     // @return true if crowdsale event has ended
565     function hasEnded() public constant returns (bool) {
566         bool capReached = weiRaised >= hardCap;
567         return (endTime != 0 && now > endTime) || capReached;
568     }
569 
570   
571 
572   event SwordStarted();
573   event SwordFinalized();
574 
575   /**
576    * @dev Must be called after crowdsale ends, to do some extra finalization
577    * work. Calls the contract's finalization function.
578    */
579   function finalize() onlyOwner public {
580     require(!isFinalized);
581    // require(hasEnded());
582 
583     finalization();
584     emit SwordFinalized();
585 
586     isFinalized = true;
587   }
588 
589     function starting() internal {
590         startTime = now;
591         limitDateSale = startTime + (saleDuration * 1 days);
592         endTime = limitDateSale;
593     }
594 
595     function finalization() internal {
596         uint256 remainingTokens = totalTokens.sub(token.getTotalSupply());
597         token.mintFinalize(wallet, remainingTokens);
598         forwardAllRaisedFunds(); 
599     }
600     
601     // overridden
602     function handleFunds() internal {
603         if(isSoftCapHit){ // if soft cap is reached, start transferring funds immediately to wallet
604             forwardFunds();  
605         } else {
606             if(didSoftCapReached()){    
607                 forwardAllRaisedFunds();            
608             }
609         }
610     }
611     
612      modifier afterDeadline() { if (hasEnded() || isFinalized) _; } // a modifier to tell token sale ended 
613     
614   /**
615      * auto refund Tokens
616      */
617     function refundAllMoney() onlyOwner public {
618         for(uint i=0; i < nextContributorIndex; i++) {
619             address addressToSendTo = contributorIndexes[i];
620             refundMoney(addressToSendTo); 
621         }
622     }
623     
624     /**
625      * refund Tokens of a single address
626      */
627     function refundMoney(address _address) onlyOwner public {
628         uint amount = contributorList[_address].contributionAmount;
629         if (amount > 0 && _address.send(amount)) { // user got money back
630             contributorList[_address].contributionAmount =  0;
631             contributorList[_address].tokensIssued =  0;
632         } 
633     }
634 }