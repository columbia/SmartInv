1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     constructor(address _owner) public {
19         owner = _owner;
20     }
21 
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address newOwner) public onlyOwner {
35         require(newOwner != address(0));
36         emit OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 
40 }
41 
42 
43 
44 /**
45  * @title Validator
46  * @dev The Validator contract has a validator address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Validator {
50     address public validator;
51 
52     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
53 
54     /**
55     * @dev The Validator constructor sets the original `validator` of the contract to the sender
56     * account.
57     */
58     constructor() public {
59         validator = msg.sender;
60     }
61 
62     /**
63     * @dev Throws if called by any account other than the validator.
64     */
65     modifier onlyValidator() {
66         require(msg.sender == validator);
67         _;
68     }
69 
70     /**
71     * @dev Allows the current validator to transfer control of the contract to a newValidator.
72     * @param newValidator The address to become next validator.
73     */
74     function setNewValidator(address newValidator) public onlyValidator {
75         require(newValidator != address(0));
76         emit NewValidatorSet(validator, newValidator);
77         validator = newValidator;
78     }
79 }
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99     if (a == 0) {
100       return 0;
101     }
102     uint256 c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   /**
108   * @dev Integer division of two numbers, truncating the quotient.
109   */
110   function div(uint256 a, uint256 b) internal pure returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   /**
118   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   /**
126   * @dev Adds two numbers, throws on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 
135 
136 
137 contract TokenInterface {
138     function mint(address _to, uint256 _amount) public returns (bool);
139     function finishMinting() public returns (bool);
140     function transferOwnership(address newOwner) public;
141 }
142 
143 
144 /**
145  * @title Crowdsale
146  * @dev Crowdsale is a base contract for managing a token crowdsale.
147  * Crowdsales have a start and end timestamps, where investors can make
148  * token purchases and the crowdsale will assign them tokens based
149  * on a token per ETH rate. Funds collected are forwarded to a wallet
150  * as they arrive. The contract requires a MintableToken that will be
151  * minted as contributions arrive, note that the crowdsale contract
152  * must be owner of the token in order to be able to mint it.
153  */
154 contract Crowdsale {
155     using SafeMath for uint256;
156 
157     // The token being sold
158     address public token;
159 
160     // start and end timestamps where investments are allowed (both inclusive)
161     uint256 public startTime;
162     uint256 public endTime;
163 
164     // address where funds are collected
165     address public wallet;
166 
167     // how many token units a buyer gets per ether
168     uint256 public rate;
169 
170     // amount of raised money in wei
171     uint256 public weiRaised;
172 
173     // amount of tokens sold
174     uint256 public totalSupply;
175 
176     // maximum amount of tokens that can be sold
177     uint256 public tokenCap;
178 
179     /**
180     * event for token purchase logging
181     * @param purchaser who paid for the tokens
182     * @param beneficiary who got the tokens
183     * @param value weis paid for purchase
184     * @param amount amount of tokens purchased
185     */
186     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
187 
188 
189     constructor(uint256 _startTime, uint256 _endTime, uint256 _tokenCap, uint256 _rate, address _wallet, address _token) public {
190         require(_startTime >= now);
191         require(_endTime >= _startTime);
192         require(_rate > 0);
193         require(_wallet != address(0));
194         require(_token != address(0));
195 
196         startTime = _startTime;
197         endTime = _endTime;
198         tokenCap = _tokenCap;
199         rate = _rate;
200         wallet = _wallet;
201         token = _token;
202     }
203 
204     // fallback function can be used to buy tokens
205     function () external payable {
206         buyTokens(msg.sender);
207     }
208 
209     // low level token purchase function
210     function buyTokens(address beneficiary) public payable {
211         require(beneficiary != address(0));
212         require(validPurchase());
213 
214         uint256 weiAmount = msg.value;
215 
216         // calculate token amount to be created
217         uint256 tokens = getTokenAmount(weiAmount);
218 
219         // update state
220         weiRaised = weiRaised.add(weiAmount);
221         totalSupply = totalSupply.add(tokens);
222 
223         TokenInterface(token).mint(beneficiary, tokens);
224         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
225 
226         forwardFunds();
227     }
228 
229     // @return true if crowdsale event has ended
230     function hasEnded() public view returns (bool) {
231         return now > endTime;
232     }
233 
234     // Override this method to have a way to add business logic to your crowdsale when buying
235     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
236         return weiAmount.mul(rate);
237     }
238 
239     // send ether to the fund collection wallet
240     // override to create custom fund forwarding mechanisms
241     function forwardFunds() internal {
242         wallet.transfer(msg.value);
243     }
244 
245     // @return true if the transaction can buy tokens
246     function validPurchase() internal view returns (bool) {
247         uint256 tokens = msg.value.mul(rate);
248         require(totalSupply.add(tokens) <= tokenCap);
249         bool withinPeriod = now >= startTime && now <= endTime;
250         bool nonZeroPurchase = msg.value != 0;
251         return withinPeriod && nonZeroPurchase;
252     }
253 
254 }
255 
256 
257 
258 
259 /**
260  * @title FinalizableCrowdsale
261  * @dev Extension of Crowdsale where an owner can do extra work
262  * after finishing.
263  */
264 contract FinalizableCrowdsale is Crowdsale, Ownable {
265     using SafeMath for uint256;
266 
267     bool public isFinalized = false;
268 
269     event Finalized();
270  
271     constructor(address _owner) public Ownable(_owner) {}
272 
273     /**
274     * @dev Must be called after crowdsale ends, to do some extra finalization
275     * work. Calls the contract's finalization function.
276     */
277     function finalize() onlyOwner public {
278         require(!isFinalized);
279         require(hasEnded());
280 
281         finalization();
282         emit Finalized();
283 
284         isFinalized = true;
285     }
286 
287     /**
288     * @dev Can be overridden to add finalization logic. The overriding function
289     * should call super.finalization() to ensure the chain of finalization is
290     * executed entirely.
291     */
292     function finalization() internal {}
293 }
294 
295 
296 
297 
298 
299 
300 
301 contract Whitelist is Ownable {
302     mapping(address => bool) internal investorMap;
303 
304     /**
305     * event for investor approval logging
306     * @param investor approved investor
307     */
308     event Approved(address indexed investor);
309 
310     /**
311     * event for investor disapproval logging
312     * @param investor disapproved investor
313     */
314     event Disapproved(address indexed investor);
315 
316     constructor(address _owner) 
317         public 
318         Ownable(_owner) 
319     {
320         
321     }
322 
323     /** @param _investor the address of investor to be checked
324       * @return true if investor is approved
325       */
326     function isInvestorApproved(address _investor) external view returns (bool) {
327         require(_investor != address(0));
328         return investorMap[_investor];
329     }
330 
331     /** @dev approve an investor
332       * @param toApprove investor to be approved
333       */
334     function approveInvestor(address toApprove) external onlyOwner {
335         investorMap[toApprove] = true;
336         emit Approved(toApprove);
337     }
338 
339     /** @dev approve investors in bulk
340       * @param toApprove array of investors to be approved
341       */
342     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
343         for (uint i = 0; i < toApprove.length; i++) {
344             investorMap[toApprove[i]] = true;
345             emit Approved(toApprove[i]);
346         }
347     }
348 
349     /** @dev disapprove an investor
350       * @param toDisapprove investor to be disapproved
351       */
352     function disapproveInvestor(address toDisapprove) external onlyOwner {
353         delete investorMap[toDisapprove];
354         emit Disapproved(toDisapprove);
355     }
356 
357     /** @dev disapprove investors in bulk
358       * @param toDisapprove array of investors to be disapproved
359       */
360     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
361         for (uint i = 0; i < toDisapprove.length; i++) {
362             delete investorMap[toDisapprove[i]];
363             emit Disapproved(toDisapprove[i]);
364         }
365     }
366 }
367 
368 
369 
370 /** @title Compliant Crowdsale */
371 contract CompliantCrowdsaleTokencap is Validator, FinalizableCrowdsale {
372     Whitelist public whiteListingContract;
373 
374     struct MintStruct {
375         address to;
376         uint256 tokens;
377         uint256 weiAmount;
378     }
379 
380     mapping (uint => MintStruct) public pendingMints;
381     uint256 public currentMintNonce;
382     mapping (address => uint) public rejectedMintBalance;
383 
384     modifier checkIsInvestorApproved(address _account) {
385         require(whiteListingContract.isInvestorApproved(_account));
386         _;
387     }
388 
389     modifier checkIsAddressValid(address _account) {
390         require(_account != address(0));
391         _;
392     }
393 
394     /**
395     * event for rejected mint logging
396     * @param to address for which buy tokens got rejected
397     * @param value number of tokens
398     * @param amount number of ethers invested
399     * @param nonce request recorded at this particular nonce
400     * @param reason reason for rejection
401     */
402     event MintRejected(
403         address indexed to,
404         uint256 value,
405         uint256 amount,
406         uint256 indexed nonce,
407         uint256 reason
408     );
409 
410     /**
411     * event for buy tokens request logging
412     * @param beneficiary address for which buy tokens is requested
413     * @param tokens number of tokens
414     * @param weiAmount number of ethers invested
415     * @param nonce request recorded at this particular nonce
416     */
417     event ContributionRegistered(
418         address beneficiary,
419         uint256 tokens,
420         uint256 weiAmount,
421         uint256 nonce
422     );
423 
424     /**
425     * event for rate update logging
426     * @param rate new rate
427     */
428     event RateUpdated(uint256 rate);
429 
430     /**
431     * event for whitelist contract update logging
432     * @param _whiteListingContract address of the new whitelist contract
433     */
434     event WhiteListingContractSet(address indexed _whiteListingContract);
435 
436     /**
437     * event for claimed ether logging
438     * @param account user claiming the ether
439     * @param amount ether claimed
440     */
441     event Claimed(address indexed account, uint256 amount);
442 
443     /** @dev Constructor
444       * @param whitelistAddress Ethereum address of the whitelist contract
445       * @param _startTime crowdsale start time
446       * @param _endTime crowdsale end time
447       * @param _tokenCap maximum number of tokens to be sold in the crowdsale
448       * @param _rate number of tokens to be sold per ether
449       * @param _wallet Ethereum address of the wallet
450       * @param _token Ethereum address of the token contract
451       * @param _owner Ethereum address of the owner
452       */
453     constructor(
454         address whitelistAddress,
455         uint256 _startTime,
456         uint256 _endTime,
457         uint256 _tokenCap,
458         uint256 _rate,
459         address _wallet,
460         address _token,
461         address _owner
462     )
463         public
464         FinalizableCrowdsale(_owner)
465         Crowdsale(_startTime, _endTime, _tokenCap, _rate, _wallet, _token)
466     {
467         setWhitelistContract(whitelistAddress);
468     }
469 
470     /** @dev Updates whitelist contract address
471       * @param whitelistAddress address of the new whitelist contract 
472       */
473     function setWhitelistContract(address whitelistAddress)
474         public 
475         onlyValidator 
476         checkIsAddressValid(whitelistAddress)
477     {
478         whiteListingContract = Whitelist(whitelistAddress);
479         emit WhiteListingContractSet(whiteListingContract);
480     }
481 
482     /** @dev buy tokens request
483       * @param beneficiary the address to which the tokens have to be minted
484       */
485     function buyTokens(address beneficiary)
486         public 
487         payable
488         checkIsInvestorApproved(beneficiary)
489     {
490         require(validPurchase());
491 
492         uint256 weiAmount = msg.value;
493 
494         // calculate token amount to be created
495         uint256 tokens = weiAmount.mul(rate);
496 
497         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
498         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
499 
500         currentMintNonce++;
501     }
502 
503     /** @dev Updates token rate 
504     * @param _rate New token rate 
505     */ 
506     function updateRate(uint256 _rate) public onlyOwner { 
507         require(_rate > 0);
508         rate = _rate;
509         emit RateUpdated(rate);
510     }
511 
512     /** @dev approve buy tokens request
513       * @param nonce request recorded at this particular nonce
514       */
515     function approveMint(uint256 nonce)
516         external 
517         onlyValidator
518     {
519         require(_approveMint(nonce));
520     }
521 
522     /** @dev reject buy tokens request
523       * @param nonce request recorded at this particular nonce
524       * @param reason reason for rejection
525       */
526     function rejectMint(uint256 nonce, uint256 reason)
527         external 
528         onlyValidator
529     {
530         _rejectMint(nonce, reason);
531     }
532 
533     /** @dev approve buy tokens requests in bulk
534       * @param nonces request recorded at these nonces
535       */
536     function bulkApproveMints(uint256[] nonces)
537         external 
538         onlyValidator
539     {
540         for (uint i = 0; i < nonces.length; i++) {
541             require(_approveMint(nonces[i]));
542         }
543     }
544     
545     /** @dev reject buy tokens requests
546       * @param nonces request recorded at these nonces
547       * @param reasons reasons for rejection
548       */
549     function bulkRejectMints(uint256[] nonces, uint256[] reasons)
550         external 
551         onlyValidator
552     {
553         require(nonces.length == reasons.length);
554         for (uint i = 0; i < nonces.length; i++) {
555             _rejectMint(nonces[i], reasons[i]);
556         }
557     }
558 
559     /** @dev approve buy tokens request called internally in the approveMint and bulkApproveMints functions
560       * @param nonce request recorded at this particular nonce
561       */
562     function _approveMint(uint256 nonce)
563         private
564         checkIsInvestorApproved(pendingMints[nonce].to)
565         returns (bool)
566     {
567         // update state
568         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
569         totalSupply = totalSupply.add(pendingMints[nonce].tokens);
570 
571         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
572         TokenInterface(token).mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
573         
574         emit TokenPurchase(
575             msg.sender,
576             pendingMints[nonce].to,
577             pendingMints[nonce].weiAmount,
578             pendingMints[nonce].tokens
579         );
580 
581         forwardFunds(pendingMints[nonce].weiAmount);
582         delete pendingMints[nonce];
583 
584         return true;
585     }
586 
587     /** @dev reject buy tokens request called internally in the rejectMint and bulkRejectMints functions
588       * @param nonce request recorded at this particular nonce
589       * @param reason reason for rejection
590       */
591     function _rejectMint(uint256 nonce, uint256 reason)
592         private
593         checkIsAddressValid(pendingMints[nonce].to)
594     {
595         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
596         
597         emit MintRejected(
598             pendingMints[nonce].to,
599             pendingMints[nonce].tokens,
600             pendingMints[nonce].weiAmount,
601             nonce,
602             reason
603         );
604         
605         delete pendingMints[nonce];
606     }
607 
608     /** @dev claim back ether if buy tokens request is rejected */
609     function claim() external {
610         require(rejectedMintBalance[msg.sender] > 0);
611         uint256 value = rejectedMintBalance[msg.sender];
612         rejectedMintBalance[msg.sender] = 0;
613 
614         msg.sender.transfer(value);
615 
616         emit Claimed(msg.sender, value);
617     }
618 
619     function finalization() internal {
620         TokenInterface(token).finishMinting();
621         transferTokenOwnership(owner);
622         super.finalization();
623     }
624 
625     /** @dev Updates token contract address
626       * @param newToken New token contract address
627       */
628     function setTokenContract(address newToken)
629         external 
630         onlyOwner
631         checkIsAddressValid(newToken)
632     {
633         token = newToken;
634     }
635 
636     /** @dev transfers ownership of the token contract
637       * @param newOwner New owner of the token contract
638       */
639     function transferTokenOwnership(address newOwner)
640         public 
641         onlyOwner
642         checkIsAddressValid(newOwner)
643     {
644         TokenInterface(token).transferOwnership(newOwner);
645     }
646 
647     function forwardFunds(uint256 amount) internal {
648         wallet.transfer(amount);
649     }
650 }