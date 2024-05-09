1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         require(newOwner != address(0));
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 }
71 
72 /**
73  * @title Authorizable
74  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
75  * functions, this simplifies the implementation of "multiple user permissions".
76  */
77 contract Authorizable is Ownable {
78     
79     mapping(address => bool) public authorized;
80     event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
81 
82     /**
83      * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
84      * account.
85      */
86     function Authorizable() public {
87         authorize(msg.sender);
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the authorized.
92      */
93     modifier onlyAuthorized() {
94         require(authorized[msg.sender]);
95         _;
96     }
97 
98     /**
99      * @dev Allows 
100      * @param _address The address to change authorization.
101      */
102     function authorize(address _address) public onlyOwner {
103         require(!authorized[_address]);
104         emit AuthorizationSet(_address, true);
105         authorized[_address] = true;
106     }
107     /**
108      * @dev Disallows
109      * @param _address The address to change authorization.
110      */
111     function deauthorize(address _address) public onlyOwner {
112         require(authorized[_address]);
113         emit AuthorizationSet(_address, false);
114         authorized[_address] = false;
115     }
116 }
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124     uint256 public totalSupply;
125     function balanceOf(address who) public view returns (uint256);
126     function transfer(address to, uint256 value) public returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135     function allowance(address owner, address spender) public view returns (uint256);
136     function transferFrom(address from, address to, uint256 value) public returns (bool);
137     function approve(address spender, uint256 value) public returns (bool);
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 /**
142  * @title PrivateSaleExchangeRate interface
143  */
144 contract PrivateSaleExchangeRate {
145     uint256 public rate;
146     uint256 public timestamp;
147     event UpdateUsdEthRate(uint _rate);
148     function updateUsdEthRate(uint _rate) public;
149     function getTokenAmount(uint256 _weiAmount) public view returns (uint256);
150 }
151 
152 /**
153  * @title Whitelist interface
154  */
155 contract Whitelist {
156     mapping(address => bool) whitelisted;
157     event AddToWhitelist(address _beneficiary);
158     event RemoveFromWhitelist(address _beneficiary);
159     function isWhitelisted(address _address) public view returns (bool);
160     function addToWhitelist(address _beneficiary) public;
161     function removeFromWhitelist(address _beneficiary) public;
162 }
163 
164 // -----------------------------------------
165 // -----------------------------------------
166 // -----------------------------------------
167 // Crowdsale
168 // -----------------------------------------
169 // -----------------------------------------
170 // -----------------------------------------
171 
172 contract Crowdsale {
173     using SafeMath for uint256;
174 
175     // The token being sold
176     ERC20 public token;
177 
178     // Address where funds are collected
179     address public wallet;
180 
181     // How many token units a buyer gets per wei
182     PrivateSaleExchangeRate public rate;
183 
184     // Amount of wei raised
185     uint256 public weiRaised;
186     
187     // Amount of wei raised (token)
188     uint256 public tokenRaised;
189 
190     /**
191     * Event for token purchase logging
192     * @param purchaser who paid for the tokens
193     * @param beneficiary who got the tokens
194     * @param value weis paid for purchase
195     * @param amount amount of tokens purchased
196     */
197     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
198 
199     /**
200     * @param _rate Number of token units a buyer gets per wei
201     * @param _wallet Address where collected funds will be forwarded to
202     * @param _token Address of the token being sold
203     */
204     function Crowdsale(PrivateSaleExchangeRate _rate, address _wallet, ERC20 _token) public {
205         require(_rate.rate() > 0);
206         require(_token != address(0));
207         require(_wallet != address(0));
208 
209         rate = _rate;
210         token = _token;
211         wallet = _wallet;
212     }
213 
214     // -----------------------------------------
215     // Crowdsale external interface
216     // -----------------------------------------
217 
218     /**
219     * @dev fallback function ***DO NOT OVERRIDE***
220     */
221     function () external payable {
222         buyTokens(msg.sender);
223     }
224 
225     /**
226     * @dev low level token purchase ***DO NOT OVERRIDE***
227     * @param _beneficiary Address performing the token purchase
228     */
229     function buyTokens(address _beneficiary) public payable {
230 
231         uint256 weiAmount = msg.value;
232         
233          // calculate token amount to be created
234         uint256 tokenAmount = _getTokenAmount(weiAmount);
235         
236         _preValidatePurchase(_beneficiary, weiAmount, tokenAmount);
237 
238         // update state
239         weiRaised = weiRaised.add(weiAmount);
240         tokenRaised = tokenRaised.add(tokenAmount);
241 
242         _processPurchase(_beneficiary, tokenAmount);
243         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokenAmount);
244 
245         _updatePurchasingState(_beneficiary, weiAmount);
246 
247         _forwardFunds();
248         _postValidatePurchase(_beneficiary, weiAmount);
249     }
250 
251     // -----------------------------------------
252     // Internal interface (extensible)
253     // -----------------------------------------
254 
255     /**
256     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
257     * @param _beneficiary Address performing the token purchase
258     * @param _weiAmount Value in wei involved in the purchase
259     */
260     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal {
261         require(_beneficiary != address(0));
262         require(_weiAmount > 0);
263         require(_tokenAmount > 0);
264     }
265 
266     /**
267     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
268     * @param _beneficiary Address performing the token purchase
269     * @param _weiAmount Value in wei involved in the purchase
270     */
271     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
272         // optional override
273     }
274 
275     /**
276     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
277     * @param _beneficiary Address performing the token purchase
278     * @param _tokenAmount Number of tokens to be emitted
279     */
280     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
281         token.transfer(_beneficiary, _tokenAmount);
282     }
283     
284     /**
285     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
286     * @param _beneficiary Address receiving the tokens
287     * @param _tokenAmount Number of tokens to be purchased
288     */
289     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
290         _deliverTokens(_beneficiary, _tokenAmount);
291     }
292 
293     /**
294     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
295     * @param _beneficiary Address receiving the tokens
296     * @param _weiAmount Value in wei involved in the purchase
297     */
298     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
299         // optional override
300     }
301 
302     /**
303     * @dev Override to extend the way in which ether is converted to tokens.
304     * @param _weiAmount Value in wei to be converted into tokens
305     * @return Number of tokens that can be purchased with the specified _weiAmount
306     */
307     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
308         return rate.getTokenAmount(_weiAmount);
309     }
310 
311     /**
312     * @dev Determines how ETH is stored/forwarded on purchases.
313     */
314     function _forwardFunds() internal {
315         wallet.transfer(msg.value);
316     }
317 }
318 
319 /**
320  * @title TimedCrowdsale
321  * @dev Crowdsale accepting contributions only within a time frame.
322  */
323 contract TimedCrowdsale is Crowdsale {
324     using SafeMath for uint256;
325 
326     uint256 public openingTime;
327     uint256 public closingTime;
328 
329     /**
330      * @dev Reverts if not in crowdsale time range. 
331     */
332     modifier onlyWhileOpen {
333         require(now >= openingTime && now <= closingTime);
334         _;
335     }
336 
337     /**
338      * @dev Constructor, takes crowdsale opening and closing times.
339      * @param _openingTime Crowdsale opening time
340      * @param _closingTime Crowdsale closing time
341      */
342     function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
343         
344         require(_closingTime >= now);
345          
346         require(_closingTime >= _openingTime);
347         openingTime = _openingTime;
348         closingTime = _closingTime;
349     }
350 
351     /**
352      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
353      * @return Whether crowdsale period has elapsed
354      */
355     function hasClosed() public view returns (bool) {
356         return now > closingTime;
357     }
358 
359     /**
360      * @dev Checks whether the period in which the crowdsale is opened.
361      * @return Whether crowdsale period has elapsed
362      */
363     function hasOpening() public view returns (bool) {
364         return (now >= openingTime && now <= closingTime);
365     }
366   
367     /**
368      * @dev Extend parent behavior requiring to be within contributing period
369      * @param _beneficiary Token purchaser
370      * @param _weiAmount Amount of wei contributed
371      */
372     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal onlyWhileOpen {
373         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
374     }
375 
376 }
377 
378 /**
379  * @title AllowanceCrowdsale
380  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
381  */
382 contract AllowanceCrowdsale is Crowdsale {
383     using SafeMath for uint256;
384     address public tokenWallet;
385 
386     /**
387     * @dev Constructor, takes token wallet address. 
388     * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
389     */
390     function AllowanceCrowdsale(address _tokenWallet) public {
391         require(_tokenWallet != address(0));
392         tokenWallet = _tokenWallet;
393     }
394 
395     /**
396     * @dev Overrides parent behavior by transferring tokens from wallet.
397     * @param _beneficiary Token purchaser
398     * @param _tokenAmount Amount of tokens purchased
399     */
400     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
401         token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
402     }
403 }
404 
405 /**
406  * @title CappedCrowdsale
407  * @dev Crowdsale with a limit for total contributions.
408  */
409 contract CappedCrowdsale is Crowdsale {
410     using SafeMath for uint256;
411 
412     uint256 public minWei;
413     uint256 public capToken;
414 
415     /**
416     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
417     * @param _capToken Max amount of token to be contributed
418     */
419     function CappedCrowdsale(uint256 _capToken, uint256 _minWei) public {
420         require(_minWei > 0);
421         require(_capToken > 0);
422         minWei = _minWei;
423         capToken = _capToken;
424     }
425 
426     /**
427     * @dev Checks whether the cap has been reached. 
428     * @return Whether the cap was reached
429     */
430     function capReached() public view returns (bool) {
431         if(tokenRaised >= capToken) return true;
432         uint256 minTokens = rate.getTokenAmount(minWei);
433         if(capToken - tokenRaised <= minTokens) return true;
434         return false;
435     }
436 
437     /**
438     * @dev Extend parent behavior requiring purchase to respect the funding cap.
439     * @param _beneficiary Token purchaser
440     * @param _weiAmount Amount of wei contributed
441     */
442     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal {
443         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
444         require(_weiAmount >= minWei);
445         require(tokenRaised.add(_tokenAmount) <= capToken);
446     }
447 }
448 
449 /**
450  * @title WhitelistedCrowdsale
451  * @dev Crowdsale with a limit for total contributions.
452  */
453 contract WhitelistedCrowdsale is Crowdsale {
454     using SafeMath for uint256;
455 
456     // Only KYC investor allowed to buy the token
457     Whitelist public whitelist;
458 
459     /**
460     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
461     * @param _whitelist whitelist contract
462     */
463     function WhitelistedCrowdsale(Whitelist _whitelist) public {
464         whitelist = _whitelist;
465     }
466 
467     function isWhitelisted(address _address) public view returns (bool) {
468         return whitelist.isWhitelisted(_address);
469     }
470 
471     /**
472     * @dev Extend parent behavior requiring purchase to respect the funding cap.
473     * @param _beneficiary Token purchaser
474     * @param _weiAmount Amount of wei contributed
475     */
476     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal {
477         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
478         require(whitelist.isWhitelisted(_beneficiary));
479     }
480 }
481 
482 /**
483  * @title ClaimedCrowdsale
484  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
485  */
486 contract ClaimCrowdsale is Crowdsale, Authorizable {
487     using SafeMath for uint256;
488     
489     uint256 divider;
490     event ClaimToken(address indexed claimant, address indexed beneficiary, uint256 claimAmount);
491      
492     // Claim remain amount of token
493     //addressIndices not use index 0 
494     address[] public addressIndices;
495 
496     // get amount of claim token
497     mapping(address => uint256) mapAddressToToken;
498     
499     //get index of addressIndices if = 0 >> not found
500     mapping(address => uint256) mapAddressToIndex;
501     
502      // Amount of wei waiting for claim (token)
503     uint256 public waitingForClaimTokens;
504 
505     /**
506     * @dev Constructor, takes token wallet address. 
507     */
508     function ClaimCrowdsale(uint256 _divider) public {
509         require(_divider > 0);
510         divider = _divider;
511         addressIndices.push(address(0));
512     }
513     
514     /**
515     * @dev Claim remained token after closed time
516     */
517     function claim(address _beneficiary) public onlyAuthorized {
518        
519         require(_beneficiary != address(0));
520         require(mapAddressToToken[_beneficiary] > 0);
521         
522         // remove from list
523         uint indexToBeDeleted = mapAddressToIndex[_beneficiary];
524         require(indexToBeDeleted != 0);
525         
526         uint arrayLength = addressIndices.length;
527         // if index to be deleted is not the last index, swap position.
528         if (indexToBeDeleted < arrayLength-1) {
529             // swap 
530             addressIndices[indexToBeDeleted] = addressIndices[arrayLength-1];
531             mapAddressToIndex[addressIndices[indexToBeDeleted]] = indexToBeDeleted;
532         }
533          // we can now reduce the array length by 1
534         addressIndices.length--;
535         mapAddressToIndex[_beneficiary] = 0;
536         
537         // deliver token
538         uint256 _claimAmount = mapAddressToToken[_beneficiary];
539         mapAddressToToken[_beneficiary] = 0;
540         waitingForClaimTokens = waitingForClaimTokens.sub(_claimAmount);
541         emit ClaimToken(msg.sender, _beneficiary, _claimAmount);
542         
543         _deliverTokens(_beneficiary, _claimAmount);
544     }
545     
546     function checkClaimTokenByIndex(uint index) public view returns (uint256){
547         require(index >= 0);
548         require(index < addressIndices.length);
549         return checkClaimTokenByAddress(addressIndices[index]);
550     }
551     
552     function checkClaimTokenByAddress(address _beneficiary) public view returns (uint256){
553         require(_beneficiary != address(0));
554         return mapAddressToToken[_beneficiary];
555     }
556     function countClaimBackers()  public view returns (uint256) {
557         return addressIndices.length-1;
558     }
559     
560     function _addToClaimList(address _beneficiary, uint256 _claimAmount) internal {
561         require(_beneficiary != address(0));
562         require(_claimAmount > 0);
563         
564         if(mapAddressToToken[_beneficiary] == 0){
565             addressIndices.push(_beneficiary);
566             mapAddressToIndex[_beneficiary] = addressIndices.length-1;
567         }
568         waitingForClaimTokens = waitingForClaimTokens.add(_claimAmount);
569         mapAddressToToken[_beneficiary] = mapAddressToToken[_beneficiary].add(_claimAmount);
570     }
571 
572    
573     /**
574      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
575      * @param _beneficiary Address receiving the tokens
576      * @param _tokenAmount Number of tokens to be purchased
577      */
578     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
579         
580         // To protect our private-sale investors who transfered eth via wallet from exchange.
581         // Instead of send all tokens amount back, the private-sale contract will send back in small portion of tokens (ppm). 
582         // The full amount of tokens will be send later after the investor has confirmed received amount to us.
583         uint256 tokenSampleAmount = _tokenAmount.div(divider);
584 
585         _addToClaimList(_beneficiary, _tokenAmount.sub(tokenSampleAmount));
586         _deliverTokens(_beneficiary, tokenSampleAmount);
587     }
588 }
589 
590 // -----------------------------------------
591 // -----------------------------------------
592 // -----------------------------------------
593 // ZMINE
594 // -----------------------------------------
595 // -----------------------------------------
596 // -----------------------------------------
597 
598 /**
599  * @title ZminePrivateSale
600  */
601 contract ZminePrivateSale is ClaimCrowdsale
602                                 , AllowanceCrowdsale
603                                 , CappedCrowdsale
604                                 , TimedCrowdsale
605                                 , WhitelistedCrowdsale {
606     using SafeMath for uint256;
607     
608     /**
609      * @param _rate Number of token units a buyer gets per wei
610      * @param _whitelist Allowd address of buyer
611      * @param _wallet Address where collected funds will be forwarded to
612      * @param _token Address of the token being sold
613      */
614     function ZminePrivateSale(PrivateSaleExchangeRate _rate
615                                 , Whitelist _whitelist
616                                 , uint256 _capToken
617                                 , uint256 _minWei
618                                 , uint256 _openingTime
619                                 , uint256 _closingTime
620                                 , address _wallet
621                                 , address _tokenWallet
622                                 , ERC20 _token
623     ) public 
624         Crowdsale(_rate, _wallet, _token) 
625         ClaimCrowdsale(1000000)
626         AllowanceCrowdsale(_tokenWallet) 
627         CappedCrowdsale(_capToken, _minWei)
628         TimedCrowdsale(_openingTime, _closingTime) 
629         WhitelistedCrowdsale(_whitelist)
630     {
631         
632         
633         
634     }
635 
636     function calculateTokenAmount(uint256 _weiAmount)  public view returns (uint256) {
637         return rate.getTokenAmount(_weiAmount);
638     }
639     
640      /**
641       * @dev Checks the amount of tokens left in the allowance.
642       * @return Amount of tokens left in the allowance
643       */
644     function remainingTokenForSale() public view returns (uint256) {
645         uint256 allowanceTokenLeft = (token.allowance(tokenWallet, this)).sub(waitingForClaimTokens);
646         uint256 balanceTokenLeft = (token.balanceOf(tokenWallet)).sub(waitingForClaimTokens);
647         if(allowanceTokenLeft < balanceTokenLeft) return allowanceTokenLeft;
648         return balanceTokenLeft;
649     }
650     
651      /**
652      * @dev Extend parent behavior requiring to be within contributing period
653      * @param _beneficiary Token purchaser
654      * @param _weiAmount Amount of wei contributed
655      */
656     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal {
657         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
658         require(remainingTokenForSale().sub(_tokenAmount) >= 0);
659     }
660 }
661 
662 // -----------------------------------------
663 // -----------------------------------------
664 // -----------------------------------------