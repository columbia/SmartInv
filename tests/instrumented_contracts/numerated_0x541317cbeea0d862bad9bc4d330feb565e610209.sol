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
191    * @dev Function to stop minting new tokens.
192    * @return True if the operation was successful.
193    */
194   function finishMinting() onlyOwner public returns (bool) {
195     mintingFinished = true;
196     emit MintFinished();
197     return true;
198   }
199 }
200 
201 /**
202  * @title BrickToken
203  * @dev Brick ERC20 Token that can be minted.
204  * It is meant to be used in Brick crowdsale contract.
205  */
206 contract BrickToken is MintableToken {
207 
208     string public constant name = "Brick"; 
209     string public constant symbol = "BRK";
210     uint8 public constant decimals = 18;
211 
212     function getTotalSupply() view public returns (uint256) {
213         return totalSupply;
214     }
215     
216     function transfer(address _to, uint256 _value) public returns (bool) {
217         super.transfer(_to, _value);
218     }
219     
220 }
221 
222 /**
223  * @title Brick Crowdsale
224  * @dev This is Brick's crowdsale contract.
225  */
226 contract BrickCrowdsale is Ownable {
227     using SafeMath for uint256;
228     
229     // start and end timestamps where investments are allowed (both inclusive)
230     uint256 public startTime;
231     uint256 public endTime;
232     // amount of raised money in wei
233     uint256 public weiRaised;
234     uint256 public limitDateSale; // end date in units
235     uint256 public currentTime;
236     
237     bool public isSoftCapHit = false;
238     bool public isStarted = false;
239     bool public isFinalized = false;
240     // Token rates as per rounds
241     uint256 icoPvtRate  = 40; 
242     uint256 icoPreRate  = 50;
243     uint256 ico1Rate    = 65;
244     uint256 ico2Rate    = 75;
245     uint256 ico3Rate    = 90;
246     // Tokens in each round
247     uint256 public pvtTokens        = (40000) * (10**18);
248     uint256 public preSaleTokens    = (6000000) * (10**18);
249     uint256 public ico1Tokens       = (8000000) * (10**18);
250     uint256 public ico2Tokens       = (8000000) * (10**18);
251     uint256 public ico3Tokens       = (8000000) * (10**18);
252     uint256 public totalTokens      = (40000000)* (10**18); // 40 million
253     
254       // address where funds are collected
255     address public advisoryEthWallet        = 0x0D7629d32546CD493bc33ADEF115D4489f5599Be;
256     address public infraEthWallet           = 0x536D36a05F6592aa29BB0beE30cda706B1272521;
257     address public techDevelopmentEthWallet = 0x4d0B70d8E612b5dca3597C64643a8d1efd5965e1;
258     address public operationsEthWallet      = 0xbc67B82924eEc8643A4f2ceDa59B5acfd888A967;
259    // address where token will go 
260      address public wallet = 0x44d44CA0f75bdd3AE8806D02515E8268459c554A; // wallet where remaining tokens will go
261      
262    struct ContributorData {
263         uint256 contributionAmount;
264         uint256 tokensIssued;
265     }
266    
267     mapping(address => ContributorData) public contributorList;
268     mapping(uint => address) contributorIndexes;
269     uint nextContributorIndex;
270 
271     constructor() public {}
272     
273    function init( uint256 _tokensForCrowdsale, uint256 _etherInUSD, address _tokenAddress, uint256 _softCapInEthers, uint256 _hardCapInEthers, 
274         uint _saleDurationInDays, uint bonus) onlyOwner public {
275         
276        // setTotalTokens(_totalTokens);
277         currentTime = now;
278         setTokensForCrowdSale(_tokensForCrowdsale);
279         setRate(_etherInUSD);
280         setTokenAddress(_tokenAddress);
281         setSoftCap(_softCapInEthers);
282         setHardCap(_hardCapInEthers);
283         setSaleDuration(_saleDurationInDays);
284         setSaleBonus(bonus);
285         start();
286         // starting the crowdsale
287    }
288    
289     /**
290     * @dev Must be called to start the crowdsale
291     */
292     function start() onlyOwner public {
293         require(!isStarted);
294         require(!hasStarted());
295         require(tokenAddress != address(0));
296         require(saleDuration != 0);
297         require(totalTokens != 0);
298         require(tokensForCrowdSale != 0);
299         require(softCap != 0);
300         require(hardCap != 0);
301         
302         starting();
303         emit BrickStarted();
304         
305         isStarted = true;
306         // endPvtSale();
307     }
308  
309     function splitTokens() internal {   
310         token.mint(techDevelopmentEthWallet, totalTokens.mul(3).div(100));          //wallet for tech development
311         tokensIssuedTillNow = tokensIssuedTillNow + totalTokens.mul(3).div(100);
312         token.mint(operationsEthWallet, totalTokens.mul(7).div(100));                //wallet for operations wallet
313         tokensIssuedTillNow = tokensIssuedTillNow + totalTokens.mul(7).div(100);
314         
315     }
316     
317        
318    uint256 public tokensForCrowdSale = 0;
319    function setTokensForCrowdSale(uint256 _tokensForCrowdsale) onlyOwner public {
320        tokensForCrowdSale = _tokensForCrowdsale.mul(10 ** 18);  
321    }
322  
323    
324     uint256 public rate=0;
325     uint256 public etherInUSD;
326     function setRate(uint256 _etherInUSD) internal {
327         etherInUSD = _etherInUSD;
328         rate = getCurrentRateInCents().mul(10**18).div(100).div(_etherInUSD);
329     }
330     
331     function setRate(uint256 rateInCents, uint256 _etherInUSD) public onlyOwner {
332         etherInUSD = _etherInUSD;
333         rate = rateInCents.mul(10**18).div(100).div(_etherInUSD);
334     }
335     
336     function updateRateInWei() internal { // this method requires that you must have called etherInUSD earliar, must not be called except when round is ending.
337         require(etherInUSD != 0);
338         rate = getCurrentRateInCents().mul(10**18).div(100).div(etherInUSD);
339     }
340     
341     function getCurrentRateInCents() public view returns (uint256)
342     {
343         if(currentRound == 1) {
344             return icoPvtRate;
345         } else if(currentRound == 2) {
346             return icoPreRate;
347         } else if(currentRound == 3) {
348             return ico1Rate;
349         } else if(currentRound == 4) {
350             return  ico2Rate;
351         } else if(currentRound == 5) {
352             return ico3Rate;
353         } else {
354             return ico3Rate;
355         }
356     }
357     // The token being sold
358     BrickToken public token;
359     address tokenAddress = 0x0; 
360     function setTokenAddress(address _tokenAddress) public onlyOwner {
361         tokenAddress = _tokenAddress; // to check if token address is provided at start
362         token = BrickToken(_tokenAddress);
363     }
364     
365  
366     function setPvtTokens (uint256 _pvtTokens)onlyOwner public {
367         require(!icoPvtEnded);
368         pvtTokens = (_pvtTokens).mul(10 ** 18);
369     }
370     function setPreSaleTokens (uint256 _preSaleTokens)onlyOwner public {
371         require(!icoPreEnded);
372         preSaleTokens = (_preSaleTokens).mul(10 ** 18);
373     }
374     function setIco1Tokens (uint256 _ico1Tokens)onlyOwner public {
375         require(!ico1Ended);
376         ico1Tokens = (_ico1Tokens).mul(10 ** 18);
377     }
378     function setIco2Tokens (uint256 _ico2Tokens)onlyOwner public {
379         require(!ico2Ended);
380         ico2Tokens = (_ico2Tokens).mul(10 ** 18);
381     }
382     function setIco3Tokens (uint256 _ico3Tokens)onlyOwner public {
383         require(!ico3Ended);
384         ico3Tokens = (_ico3Tokens).mul(10 ** 18);
385     }
386     
387    uint256 public softCap = 0;
388    function setSoftCap(uint256 _softCap) onlyOwner public {
389        softCap = _softCap.mul(10 ** 18); 
390     }
391    
392    uint256 public hardCap = 0; 
393    function setHardCap(uint256 _hardCap) onlyOwner public {
394        hardCap = _hardCap.mul(10 ** 18); 
395    }
396   
397     // sale period (includes holidays)
398     uint public saleDuration = 0; // in days ex: 60.
399     function setSaleDuration(uint _saleDurationInDays) onlyOwner public {
400         saleDuration = _saleDurationInDays;
401         limitDateSale = startTime.add(saleDuration * 1 days);
402         endTime = limitDateSale;
403     }
404   
405     uint public saleBonus = 0; // ex. 10
406     function setSaleBonus(uint bonus) public onlyOwner{
407         saleBonus = bonus;
408     }
409     
410     // fallback function can be used to buy tokens
411     function () public payable {
412         buyPhaseTokens(msg.sender);
413     }
414    
415    function transferTokenOwnership(address _address) onlyOwner public {
416        token.transferOwnership(_address);
417    }
418     
419     function releaseTokens(address _contributerAddress, uint256 tokensOfContributor) internal {
420        token.mint(_contributerAddress, tokensOfContributor);
421     }
422     
423     function currentTokenSupply() public view returns(uint256){
424         return token.getTotalSupply();
425     }
426     
427    function buyPhaseTokens(address beneficiary) public payable 
428    { 
429         assert(!ico3Ended);
430         require(beneficiary != address(0));
431         require(validPurchase());
432 
433         uint256 weiAmount = msg.value;
434         // calculate token amount to be created
435         uint256 tokens = computeTokens(weiAmount); //converts the wei to token amount
436         require(isWithinTokenAllocLimit(tokens));
437        
438         if(int(pvtTokens - tokensIssuedTillNow) > 0) { //phase1 80
439             require(int (tokens) < (int(pvtTokens -  tokensIssuedTillNow)));
440             buyTokens(tokens,weiAmount,beneficiary);
441         } else if (int (preSaleTokens + pvtTokens - tokensIssuedTillNow) > 0) {  //phase 2  80
442             require(int(tokens) < (int(preSaleTokens + pvtTokens - tokensIssuedTillNow)));
443             buyTokens(tokens,weiAmount,beneficiary);
444         } else if(int(ico1Tokens + preSaleTokens + pvtTokens - tokensIssuedTillNow) > 0) {  //phase3
445             require(int(tokens) < (int(ico1Tokens + preSaleTokens + pvtTokens -tokensIssuedTillNow)));
446             buyTokens(tokens,weiAmount,beneficiary);
447         } else if(int(ico2Tokens + ico1Tokens + preSaleTokens + pvtTokens - (tokensIssuedTillNow)) > 0) {  //phase4
448             require(int(tokens) < (int(ico2Tokens + ico1Tokens + preSaleTokens + pvtTokens - (tokensIssuedTillNow))));
449             buyTokens(tokens,weiAmount,beneficiary);
450         }  else if(!ico3Ended && (int(tokensForCrowdSale - (tokensIssuedTillNow)) > 0)) { // 500 -400
451             require(int(tokens) < (int(tokensForCrowdSale - (tokensIssuedTillNow))));
452             buyTokens(tokens,weiAmount,beneficiary);
453         }
454    }
455    uint256 public tokensIssuedTillNow=0;
456    function buyTokens(uint256 tokens, uint256 weiAmount ,address beneficiary) internal {
457        
458         // update state - Add to eth raised
459         weiRaised = weiRaised.add(weiAmount);
460 
461         if (contributorList[beneficiary].contributionAmount == 0) { // if its a new contributor, add him and increase index
462             contributorIndexes[nextContributorIndex] = beneficiary;
463             nextContributorIndex += 1;
464         }
465         
466         contributorList[beneficiary].contributionAmount += weiAmount;
467         contributorList[beneficiary].tokensIssued += tokens;
468         tokensIssuedTillNow = tokensIssuedTillNow + tokens;
469         releaseTokens(beneficiary, tokens); // releaseTokens
470         forwardFunds(); // forwardFunds
471         emit BrickTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
472     }
473    
474   
475       /**
476     * event for token purchase logging
477     * @param purchaser who paid for the tokens
478     * @param beneficiary who got the tokens
479     * @param value weis paid for purchase
480     * @param amount amount of tokens purchased
481     */
482     event BrickTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
483   
484     function investorCount() constant public returns(uint) {
485         return nextContributorIndex;
486     }
487     
488     function hasStarted() public constant returns (bool) {
489         return (startTime != 0 && now > startTime);
490     }
491 
492     function isWithinSaleTimeLimit() internal view returns (bool) {
493         return now <= limitDateSale;
494     }
495 
496     function isWithinSaleLimit(uint256 _tokens) internal view returns (bool) {
497         return token.getTotalSupply().add(_tokens) <= tokensForCrowdSale;
498     }
499     
500     function computeTokens(uint256 weiAmount) view internal returns (uint256) {
501        return weiAmount.mul(10 ** 18).div(rate);
502     }
503     
504     function isWithinTokenAllocLimit(uint256 _tokens) view internal returns (bool) {
505         return (isWithinSaleTimeLimit() && isWithinSaleLimit(_tokens));
506     }
507 
508     // overriding BrckBaseCrowdsale#validPurchase to add extra cap logic
509     // @return true if investors can buy at the moment
510     function validPurchase() internal constant returns (bool) {
511         bool withinCap = weiRaised.add(msg.value) <= hardCap;
512         bool withinPeriod = now >= startTime && now <= endTime; 
513         bool nonZeroPurchase = msg.value != 0; 
514         return (withinPeriod && nonZeroPurchase) && withinCap && isWithinSaleTimeLimit();
515     }
516 
517     // overriding Crowdsale#hasEnded to add cap logic
518     // @return true if crowdsale event has ended
519     function hasEnded() public constant returns (bool) {
520         bool capReached = weiRaised >= hardCap;
521         return (endTime != 0 && now > endTime) || capReached;
522     }
523 
524   
525 
526   event BrickStarted();
527   event BrickFinalized();
528 
529   /**
530    * @dev Must be called after crowdsale ends, to do some extra finalization
531    * work. Calls the contract's finalization function.
532    */
533     function finalize() onlyOwner public {
534         require(!isFinalized);
535         // require(hasEnded());
536         
537         finalization();
538         emit BrickFinalized();
539         
540         isFinalized = true;
541     }
542 
543     function starting() internal {
544         startTime = now;
545         limitDateSale = startTime.add(saleDuration * 1 days);
546         endTime = limitDateSale;
547     }
548 
549     function finalization() internal {
550          splitTokens();
551 
552         token.mint(wallet, totalTokens.sub(tokensIssuedTillNow));
553         if(address(this).balance > 0){ // if any funds are left in contract.
554             processFundsIfAny();
555         }
556     }
557     
558      // send ether to the fund collection wallet
559     function forwardFunds() internal {
560         
561         require(advisoryEthWallet != address(0));
562         require(infraEthWallet != address(0));
563         require(techDevelopmentEthWallet != address(0));
564         require(operationsEthWallet != address(0));
565         
566         operationsEthWallet.transfer(msg.value.mul(60).div(100));
567         advisoryEthWallet.transfer(msg.value.mul(5).div(100));
568         infraEthWallet.transfer(msg.value.mul(10).div(100));
569         techDevelopmentEthWallet.transfer(msg.value.mul(25).div(100));
570     }
571     
572      // send ether to the fund collection wallet
573     function processFundsIfAny() internal {
574         
575         require(advisoryEthWallet != address(0));
576         require(infraEthWallet != address(0));
577         require(techDevelopmentEthWallet != address(0));
578         require(operationsEthWallet != address(0));
579         
580         operationsEthWallet.transfer(address(this).balance.mul(60).div(100));
581         advisoryEthWallet.transfer(address(this).balance.mul(5).div(100));
582         infraEthWallet.transfer(address(this).balance.mul(10).div(100));
583         techDevelopmentEthWallet.transfer(address(this).balance.mul(25).div(100));
584     }
585     
586     //functions to manually end round sales
587     
588     uint256 public currentRound = 1;
589     bool public icoPvtEnded = false;
590      bool public icoPreEnded = false;
591       bool public ico1Ended = false;
592        bool public ico2Ended = false;
593         bool public ico3Ended = false;
594     
595     function endPvtSale() onlyOwner public       //ending private sale
596     {
597         require(!icoPvtEnded);
598         pvtTokens = tokensIssuedTillNow;
599         currentRound = 2;
600         updateRateInWei();
601         icoPvtEnded = true;
602         
603     }
604      function endPreSale() onlyOwner public      //ending pre-sale
605     {
606         require(!icoPreEnded && icoPvtEnded);
607         preSaleTokens = tokensIssuedTillNow - pvtTokens; 
608         currentRound = 3;
609         updateRateInWei();
610         icoPreEnded = true;
611     }
612      function endIcoSaleRound1() onlyOwner public   //ending IcoSaleRound1
613     {
614         require(!ico1Ended && icoPreEnded);
615        ico1Tokens = tokensIssuedTillNow - preSaleTokens - pvtTokens; 
616        currentRound = 4;
617        updateRateInWei();
618        ico1Ended = true;
619     }
620      function endIcoSaleRound2() onlyOwner public   //ending IcoSaleRound2
621     {
622        require(!ico2Ended && ico1Ended);
623        ico2Tokens = tokensIssuedTillNow - ico1Tokens - preSaleTokens - pvtTokens;
624        currentRound = 5;
625        updateRateInWei();
626        ico2Ended=true;
627     }
628      function endIcoSaleRound3() onlyOwner public  //ending IcoSaleRound3
629      {
630         require(!ico3Ended && ico2Ended);
631         ico3Tokens = tokensIssuedTillNow - ico2Tokens - ico1Tokens - preSaleTokens - pvtTokens;
632         updateRateInWei();
633         ico3Ended = true;
634     }
635     
636     modifier afterDeadline() { if (hasEnded() || isFinalized) _; } // a modifier to tell token sale ended
637     
638     function selfDestroy(address _address) public onlyOwner { // this method will send all money to the following address after finalize
639         assert(isFinalized);
640         selfdestruct(_address);
641     }
642     
643 }