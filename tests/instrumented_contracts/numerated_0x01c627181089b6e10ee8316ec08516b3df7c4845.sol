1 pragma solidity ^0.4.24;
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
69   
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79   
80   
81   function balanceOf(address _owner) public constant returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev https://github.com/ethereum/EIPs/issues/20
92  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amount of tokens to be transferred
103    */
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     uint256 _allowance = allowed[_from][msg.sender];
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = _allowance.sub(_value);
110     emit Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    *
117    
118    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
119    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
120    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     emit Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param _owner address The address which owns the funds.
133    * @param _spender address The address which will spend the funds.
134    * @return A uint256 specifying the amount of tokens still available for the spender.
135    */
136   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140   /**
141    * approve should be called when allowed[_spender] == 0. To increment
142    * allowed value is better to use this function to avoid 2 calls (and wait until
143    * the first transaction is mined)
144    * From MonolithDAO Token.sol
145    */
146   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163 }
164 
165 contract MintableToken is StandardToken, Ownable {
166   event Mint(address indexed to, uint256 amount);
167   event MintFinished();
168 
169   bool public mintingFinished = false;
170 
171   modifier canMint() {
172     require(!mintingFinished);
173     _;
174   }
175 
176   /**
177    * @dev Function to mint tokens
178    * @param _to The address that will receive the minted tokens.
179    * @param _amount The amount of tokens to mint.
180    * @return A boolean that indicates if the operation was successful.
181    */
182   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
183     totalSupply = totalSupply.add(_amount);
184     balances[_to] = balances[_to].add(_amount);
185     emit Mint(_to, _amount);
186     emit Transfer(0x0, _to, _amount);
187     return true;
188   }
189   
190   /**
191    * @dev Function to mint tokens
192    * @param _to The address that will receive the minted tokens.
193    * @param _amount The amount of tokens to mint.
194    * @return A boolean that indicates if the operation was successful.
195    */
196   function mintFinalize(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
197     totalSupply = totalSupply.add(_amount);
198     balances[_to] = balances[_to].add(_amount);
199     emit Mint(_to, _amount);
200     emit Transfer(0x0, _to, _amount);
201     return true;
202   }
203 
204   /**
205    * @dev Function to stop minting new tokens.
206    * @return True if the operation was successful.
207    */
208   function finishMinting() onlyOwner public returns (bool) {
209     mintingFinished = true;
210     emit MintFinished();
211     return true;
212   }
213 }
214 
215 /**
216  * @title BrickToken
217  * @dev Brick ERC20 Token that can be minted.
218  * It is meant to be used in Brick crowdsale contract.
219  */
220 contract BrickToken is MintableToken {
221 
222     string public constant name = "Brick"; 
223     string public constant symbol = "BRK";
224     uint8 public constant decimals = 18;
225 
226     function getTotalSupply() view public returns (uint256) {
227         return totalSupply;
228     }
229     
230     function transfer(address _to, uint256 _value) public returns (bool) {
231         super.transfer(_to, _value);
232     }
233     
234 }
235 
236 contract KycContractInterface {
237     function isAddressVerified(address _address) public view returns (bool);
238 }
239 
240 contract KycContract is Ownable {
241     
242     mapping (address => bool) verifiedAddresses;
243     
244     function isAddressVerified(address _address) public view returns (bool) {
245         return verifiedAddresses[_address];
246     }
247     
248     function addAddress(address _newAddress) public onlyOwner {
249         require(!verifiedAddresses[_newAddress]);
250         
251         verifiedAddresses[_newAddress] = true;
252     }
253     
254     function removeAddress(address _oldAddress) public onlyOwner {
255         require(verifiedAddresses[_oldAddress]);
256         
257         verifiedAddresses[_oldAddress] = false;
258     }
259     
260     function batchAddAddresses(address[] _addresses) public onlyOwner {
261         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
262             assert(!verifiedAddresses[_addresses[cnt]]);
263             verifiedAddresses[_addresses[cnt]] = true;
264         }
265     }
266 }
267 
268 
269 /**
270  * @title Brick Crowdsale
271  * @dev This is Brick's crowdsale contract.
272  */
273 contract BrickCrowdsale is Ownable {
274     using SafeMath for uint256;
275     
276     // start and end timestamps where investments are allowed (both inclusive)
277     uint256 public startTime;
278     uint256 public endTime;
279     // amount of raised money in wei
280     uint256 public weiRaised;
281     uint256 public limitDateSale; // end date in units
282     
283     bool public isSoftCapHit = false;
284     bool public isStarted = false;
285     bool public isFinalized = false;
286     // Token rates as per rounds
287     uint256 icoPvtRate  = 40; 
288     uint256 icoPreRate  = 50;
289     uint256 ico1Rate    = 65;
290     uint256 ico2Rate    = 75;
291     uint256 ico3Rate    = 90;
292     // Tokens in each round
293     uint256 public pvtTokens        = (40000) * (10**18);
294     uint256 public preSaleTokens    = (6000000) * (10**18);
295     uint256 public ico1Tokens       = (8000000) * (10**18);
296     uint256 public ico2Tokens       = (8000000) * (10**18);
297     uint256 public ico3Tokens       = (8000000) * (10**18);
298     uint256 public totalTokens      = (40000000)* (10**18); // 40 million
299     
300      // address where funds are collected
301     address public advisoryEthWallet        = 0x0D7629d32546CD493bc33ADEF115D4489f5599Be;
302     address public infraEthWallet           = 0x536D36a05F6592aa29BB0beE30cda706B1272521;
303     address public techDevelopmentEthWallet = 0x4d0B70d8E612b5dca3597C64643a8d1efd5965e1;
304     address public operationsEthWallet      = 0xbc67B82924eEc8643A4f2ceDa59B5acfd888A967;
305    // address where token will go 
306      address public wallet = 0x44d44CA0f75bdd3AE8806D02515E8268459c554A; // wallet where remaining tokens will go
307      
308    struct ContributorData {
309         uint256 contributionAmountViewOnly;
310         uint256 tokensIssuedViewOnly;
311         uint256 contributionAmount;
312         uint256 tokensIssued;
313     }
314    
315    address[] public tokenSendFailures;
316    
317     mapping(address => ContributorData) public contributorList;
318     mapping(uint => address) contributorIndexes;
319     uint nextContributorIndex;
320 
321     constructor() public {}
322     
323    function init( uint256 _tokensForCrowdsale,
324         uint256 _etherInUSD, address _tokenAddress, uint256 _softCapInEthers, uint256 _hardCapInEthers, 
325         uint _saleDurationInDays, address _kycAddress, uint bonus) onlyOwner public {
326         
327        // setTotalTokens(_totalTokens);
328         setTokensForCrowdSale(_tokensForCrowdsale);
329     
330         setRate(_etherInUSD);
331         setTokenAddress(_tokenAddress);
332         setSoftCap(_softCapInEthers);
333         setHardCap(_hardCapInEthers);
334         setSaleDuration(_saleDurationInDays);
335         setKycAddress(_kycAddress);
336         setSaleBonus(bonus);
337         
338         kyc = KycContract(_kycAddress);
339         start();
340         // starting the crowdsale
341    }
342    
343     /**
344     * @dev Must be called to start the crowdsale
345     */
346     function start() onlyOwner public {
347         require(!isStarted);
348         require(!hasStarted());
349         require(tokenAddress != address(0));
350         require(kycAddress != address(0));
351         require(saleDuration != 0);
352         require(totalTokens != 0);
353         require(tokensForCrowdSale != 0);
354         require(softCap != 0);
355         require(hardCap != 0);
356         
357         starting();
358         emit BrickStarted();
359         
360         isStarted = true;
361         // endPvtSale();
362     }
363  
364     function splitTokens() internal {   
365         token.mint(techDevelopmentEthWallet,((totalTokens * 3).div(100))); //wallet for tech development
366         tokensIssuedTillNow = tokensIssuedTillNow + ((totalTokens * 3).div(100));
367         token.mint(operationsEthWallet,((totalTokens * 7).div(100))); //wallet for operations wallet
368         tokensIssuedTillNow = tokensIssuedTillNow + ((totalTokens * 7).div(100));
369         
370     }
371     
372        
373    uint256 public tokensForCrowdSale = 0;
374    function setTokensForCrowdSale(uint256 _tokensForCrowdsale) onlyOwner public {
375        tokensForCrowdSale = _tokensForCrowdsale * (10 ** 18);  
376    }
377  
378    
379     uint256 public rate=0;
380     uint256 public etherInUSD;
381     function setRate(uint256 _etherInUSD) internal {
382         etherInUSD = _etherInUSD;
383         rate = (getCurrentRateInCents() * (10**18) / 100) / _etherInUSD;
384     }
385     
386     function setRate(uint256 rateInCents, uint256 _etherInUSD) public onlyOwner {
387         etherInUSD = _etherInUSD;
388         rate = (rateInCents * (10**18) / 100) / _etherInUSD;
389     }
390     
391     function updateRateInWei() internal { // this method requires that you must have called etherInUSD earliar, must not be called except when round is ending.
392         require(etherInUSD != 0);
393         rate = (getCurrentRateInCents() * (10**18) / 100) / etherInUSD;
394     }
395     
396     function getCurrentRateInCents() public view returns (uint256)
397     {
398         if(currentRound == 1) {
399             return icoPvtRate;
400         } else if(currentRound == 2) {
401             return icoPreRate;
402         } else if(currentRound == 3) {
403             return ico1Rate;
404         } else if(currentRound == 4) {
405             return  ico2Rate;
406         } else if(currentRound == 5) {
407             return ico3Rate;
408         } else {
409             return ico3Rate;
410         }
411     }
412     // The token being sold
413     BrickToken public token;
414     address tokenAddress = 0x0; 
415     function setTokenAddress(address _tokenAddress) public onlyOwner {
416         tokenAddress = _tokenAddress; // to check if token address is provided at start
417         token = BrickToken(_tokenAddress);
418     }
419     
420  
421     function setPvtTokens (uint256 _pvtTokens)onlyOwner public {
422         require(!icoPvtEnded);
423         pvtTokens = (_pvtTokens) * (10 ** 18);
424     }
425     function setPreSaleTokens (uint256 _preSaleTokens)onlyOwner public {
426         require(!icoPreEnded);
427         preSaleTokens = (_preSaleTokens) * (10 ** 18);
428     }
429     function setIco1Tokens (uint256 _ico1Tokens)onlyOwner public {
430         require(!ico1Ended);
431         ico1Tokens = (_ico1Tokens) * (10 ** 18);
432     }
433     function setIco2Tokens (uint256 _ico2Tokens)onlyOwner public {
434         require(!ico2Ended);
435         ico2Tokens = (_ico2Tokens) * (10 ** 18);
436     }
437     function setIco3Tokens (uint256 _ico3Tokens)onlyOwner public {
438         require(!ico3Ended);
439         ico3Tokens = (_ico3Tokens) * (10 ** 18);
440     }
441     
442    uint256 public softCap = 0;
443    function setSoftCap(uint256 _softCap) onlyOwner public {
444        softCap = _softCap * (10 ** 18); 
445     }
446    
447    uint256 public hardCap = 0; 
448    function setHardCap(uint256 _hardCap) onlyOwner public {
449        hardCap = _hardCap * (10 ** 18); 
450    }
451   
452     // sale period (includes holidays)
453     uint public saleDuration = 0; // in days ex: 60.
454     function setSaleDuration(uint _saleDurationInDays) onlyOwner public {
455         saleDuration = _saleDurationInDays;
456         limitDateSale = startTime + (saleDuration * 1 days);
457         endTime = limitDateSale;
458     }
459   
460     address kycAddress = 0x0;
461     function setKycAddress(address _kycAddress) onlyOwner public {
462         kycAddress = _kycAddress;
463     }
464   
465     uint public saleBonus = 0; // ex. 10
466     function setSaleBonus(uint bonus) public onlyOwner{
467         saleBonus = bonus;
468     }
469   
470    bool public isKYCRequiredToReceiveFunds = false; // whether Kyc is required to receive funds.
471     function setKYCRequiredToReceiveFunds(bool IS_KYCRequiredToReceiveFunds) public onlyOwner{
472         isKYCRequiredToReceiveFunds = IS_KYCRequiredToReceiveFunds;
473     }
474     
475     bool public isKYCRequiredToSendTokens = false; // whether Kyc is required to send tokens.
476       function setKYCRequiredToSendTokens(bool IS_KYCRequiredToSendTokens) public onlyOwner{
477         isKYCRequiredToSendTokens = IS_KYCRequiredToSendTokens;
478     }
479     
480     
481     // fallback function can be used to buy tokens
482     function () public payable {
483         buyPhaseTokens(msg.sender);
484     }
485     
486    KycContract public kyc;
487    function transferKycOwnerShip(address _address) onlyOwner public {
488        kyc.transferOwnership(_address);
489    }
490    
491    function transferTokenOwnership(address _address) onlyOwner public {
492        token.transferOwnership(_address);
493    }
494    
495     /**
496      * release Tokens
497      */
498     function releaseAllTokens() onlyOwner public {
499         for(uint i=0; i < nextContributorIndex; i++) {
500             address addressToSendTo = contributorIndexes[i]; // address of user
501             releaseTokens(addressToSendTo);
502         }
503     }
504     
505     /**
506      * release Tokens of an individual address
507      */
508     function releaseTokens(address _contributerAddress) onlyOwner public {
509         if(isKYCRequiredToSendTokens){
510              if(KycContractInterface(kycAddress).isAddressVerified(_contributerAddress)){ // if kyc needs to be checked at release time
511                 release(_contributerAddress);
512              }
513         } else {
514             release(_contributerAddress);
515         }
516     }
517     
518     function release(address _contributerAddress) internal {
519         if(contributorList[_contributerAddress].tokensIssued > 0) { 
520             if(token.mint(_contributerAddress, contributorList[_contributerAddress].tokensIssued)) { // tokens sent successfully
521                 contributorList[_contributerAddress].tokensIssued = 0;
522                 contributorList[_contributerAddress].contributionAmount = 0;
523             } else { // token sending failed, has to be processed manually
524                 tokenSendFailures.push(_contributerAddress);
525             }
526         }
527     }
528     
529     function tokenSendFailuresCount() public view returns (uint) {
530         return tokenSendFailures.length;
531     }
532     
533     function currentTokenSupply() public view returns(uint256){
534         return token.getTotalSupply();
535     }
536     
537    function buyPhaseTokens(address beneficiary) public payable 
538    { 
539        
540         require(beneficiary != address(0));
541         require(validPurchase());
542         if(isKYCRequiredToReceiveFunds){
543             require(KycContractInterface(kycAddress).isAddressVerified(msg.sender));
544         }
545 
546         uint256 weiAmount = msg.value;
547         // calculate token amount to be created
548         uint256 tokens = computeTokens(weiAmount); //converts the wei to token amount
549         require(isWithinTokenAllocLimit(tokens));
550        
551         if(int(pvtTokens - tokensIssuedTillNow) > 0) { //phase1 80
552             require(int (tokens) < (int(pvtTokens -  tokensIssuedTillNow)));
553             buyTokens(tokens,weiAmount,beneficiary);
554         } else if (int (preSaleTokens + pvtTokens - tokensIssuedTillNow) > 0) {  //phase 2  80
555             require(int(tokens) < (int(preSaleTokens + pvtTokens - tokensIssuedTillNow)));
556             buyTokens(tokens,weiAmount,beneficiary);
557         } else if(int(ico1Tokens + preSaleTokens + pvtTokens - tokensIssuedTillNow) > 0) {  //phase3
558             require(int(tokens) < (int(ico1Tokens + preSaleTokens + pvtTokens -tokensIssuedTillNow)));
559             buyTokens(tokens,weiAmount,beneficiary);
560         } else if(int(ico2Tokens + ico1Tokens + preSaleTokens + pvtTokens - (tokensIssuedTillNow)) > 0) {  //phase4
561             require(int(tokens) < (int(ico2Tokens + ico1Tokens + preSaleTokens + pvtTokens - (tokensIssuedTillNow))));
562             buyTokens(tokens,weiAmount,beneficiary);
563         }  else if(!ico3Ended && (int(tokensForCrowdSale - (tokensIssuedTillNow)) > 0)) { // 500 -400
564             require(int(tokens) < (int(tokensForCrowdSale - (tokensIssuedTillNow))));
565             buyTokens(tokens,weiAmount,beneficiary);
566         }
567    }
568    uint256 public tokensIssuedTillNow=0;
569    function buyTokens(uint256 tokens,uint256 weiAmount ,address beneficiary) internal {
570        
571         // update state - Add to eth raised
572         weiRaised = weiRaised.add(weiAmount);
573 
574         if (contributorList[beneficiary].contributionAmount == 0) { // if its a new contributor, add him and increase index
575             contributorIndexes[nextContributorIndex] = beneficiary;
576             nextContributorIndex += 1;
577         }
578         
579         contributorList[beneficiary].contributionAmount += weiAmount;
580         contributorList[beneficiary].contributionAmountViewOnly += weiAmount;
581         contributorList[beneficiary].tokensIssued += tokens;
582         contributorList[beneficiary].tokensIssuedViewOnly += tokens;
583         tokensIssuedTillNow = tokensIssuedTillNow + tokens;
584         emit BrickTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
585     }
586    
587   
588       /**
589     * event for token purchase logging
590     * @param purchaser who paid for the tokens
591     * @param beneficiary who got the tokens
592     * @param value weis paid for purchase
593     * @param amount amount of tokens purchased
594     */
595     event BrickTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
596   
597     function investorCount() constant public returns(uint) {
598         return nextContributorIndex;
599     }
600     
601     function hasStarted() public constant returns (bool) {
602         return (startTime != 0 && now > startTime);
603     }
604 
605     // send ether to the fund collection wallet
606     // function forwardFunds() internal {
607     //     wallet.transfer(msg.value);
608     // }
609     
610    
611     
612      // send ether to the fund collection wallet
613     function forwardAllRaisedFunds() internal {
614         
615         require(advisoryEthWallet != address(0));
616         require(infraEthWallet != address(0));
617         require(techDevelopmentEthWallet != address(0));
618         require(operationsEthWallet != address(0));
619         
620         operationsEthWallet.transfer((weiRaised * 60) / 100);
621         advisoryEthWallet.transfer((weiRaised *5) / 100);
622         infraEthWallet.transfer((weiRaised * 10) / 100);
623         techDevelopmentEthWallet.transfer((weiRaised * 25) / 100);
624     }
625 
626     function isWithinSaleTimeLimit() internal view returns (bool) {
627         return now <= limitDateSale;
628     }
629 
630     function isWithinSaleLimit(uint256 _tokens) internal view returns (bool) {
631         return token.getTotalSupply().add(_tokens) <= tokensForCrowdSale;
632     }
633     
634     function computeTokens(uint256 weiAmount) view internal returns (uint256) {
635        return (weiAmount.div(rate)) * (10 ** 18);
636     }
637     
638     function isWithinTokenAllocLimit(uint256 _tokens) view internal returns (bool) {
639         return (isWithinSaleTimeLimit() && isWithinSaleLimit(_tokens));
640     }
641 
642     function didSoftCapReached() internal returns (bool) {
643         if(weiRaised >= softCap){
644             isSoftCapHit = true; // setting the flag that soft cap is hit and all funds should be sent directly to wallet from now on.
645         } else {
646             isSoftCapHit = false;
647         }
648         return isSoftCapHit;
649     }
650 
651     // overriding BrckBaseCrowdsale#validPurchase to add extra cap logic
652     // @return true if investors can buy at the moment
653     function validPurchase() internal constant returns (bool) {
654         bool withinCap = weiRaised.add(msg.value) <= hardCap;
655         bool withinPeriod = now >= startTime && now <= endTime; 
656         bool nonZeroPurchase = msg.value != 0; 
657         return (withinPeriod && nonZeroPurchase) && withinCap && isWithinSaleTimeLimit();
658     }
659 
660     // overriding Crowdsale#hasEnded to add cap logic
661     // @return true if crowdsale event has ended
662     function hasEnded() public constant returns (bool) {
663         bool capReached = weiRaised >= hardCap;
664         return (endTime != 0 && now > endTime) || capReached;
665     }
666 
667   
668 
669   event BrickStarted();
670   event BrickFinalized();
671 
672   /**
673    * @dev Must be called after crowdsale ends, to do some extra finalization
674    * work. Calls the contract's finalization function.
675    */
676     function finalize() onlyOwner public {
677         require(!isFinalized);
678         // require(hasEnded());
679         
680         finalization();
681         emit BrickFinalized();
682         
683         isFinalized = true;
684     }
685 
686     function starting() internal {
687         startTime = now;
688         limitDateSale = startTime + (saleDuration * 1 days);
689         endTime = limitDateSale;
690     }
691 
692     function finalization() internal {
693          splitTokens();
694 
695         token.mintFinalize(wallet, totalTokens.sub(tokensIssuedTillNow));
696         forwardAllRaisedFunds(); 
697     }
698     
699     //functions to manually end round sales
700     
701     uint256 public currentRound = 1;
702     bool public icoPvtEnded = false;
703      bool public icoPreEnded = false;
704       bool public ico1Ended = false;
705        bool public ico2Ended = false;
706         bool public ico3Ended = false;
707     
708     function endPvtSale() onlyOwner public       //ending private sale
709     {
710         require(!icoPvtEnded);
711         pvtTokens = tokensIssuedTillNow;
712         currentRound = 2;
713         updateRateInWei();
714         icoPvtEnded = true;
715         
716     }
717      function endPreSale() onlyOwner public      //ending pre-sale
718     {
719         require(!icoPreEnded && icoPvtEnded);
720         preSaleTokens = tokensIssuedTillNow - pvtTokens; 
721         currentRound = 3;
722         updateRateInWei();
723         icoPreEnded = true;
724     }
725      function endIcoSaleRound1() onlyOwner public   //ending IcoSaleRound1
726     {
727         require(!ico1Ended && icoPreEnded);
728        ico1Tokens = tokensIssuedTillNow - preSaleTokens - pvtTokens; 
729        currentRound = 4;
730        updateRateInWei();
731        ico1Ended = true;
732     }
733      function endIcoSaleRound2() onlyOwner public  
734     {
735        require(!ico2Ended && ico1Ended);
736        ico2Tokens = tokensIssuedTillNow - ico1Tokens - preSaleTokens - pvtTokens;
737        currentRound = 5;
738        updateRateInWei();
739        ico2Ended=true;
740     }
741      function endIcoSaleRound3() onlyOwner public  //ending IcoSaleRound3
742     {
743         require(!ico3Ended && ico2Ended);
744       ico3Tokens = tokensIssuedTillNow - ico2Tokens - ico1Tokens - preSaleTokens - pvtTokens;
745       updateRateInWei();
746       ico3Ended = true;
747     }
748     
749     
750      modifier afterDeadline() { if (hasEnded() || isFinalized) _; } // a modifier to tell token sale ended 
751     
752   /**
753      * auto refund Tokens
754      */
755     function refundAllMoney() onlyOwner public {
756         for(uint i=0; i < nextContributorIndex; i++) {
757             address addressToSendTo = contributorIndexes[i];
758             refundMoney(addressToSendTo); 
759         }
760     }
761     
762     /**
763      * refund Tokens of a single address
764      */
765     function refundMoney(address _address) onlyOwner public {
766         uint amount = contributorList[_address].contributionAmount;
767         if (amount > 0 && _address.send(amount)) { // user got money back
768             contributorList[_address].contributionAmount =  0;
769             contributorList[_address].tokensIssued =  0;
770             contributorList[_address].contributionAmountViewOnly =  0;
771             contributorList[_address].tokensIssuedViewOnly =  0;
772         } 
773     }
774 }