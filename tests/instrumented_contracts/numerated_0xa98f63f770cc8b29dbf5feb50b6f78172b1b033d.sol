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
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     if (a == 0) {
101       return 0;
102     }
103     uint256 c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   /**
119   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 
137 
138 contract TokenInterface {
139     function mint(address _to, uint256 _amount) public returns (bool);
140     function finishMinting() public returns (bool);
141     function transferOwnership(address newOwner) public;
142 }
143 
144 
145 /**
146  * @title Crowdsale
147  * @dev Crowdsale is a base contract for managing a token crowdsale.
148  * Crowdsales have a start and end timestamps, where investors can make
149  * token purchases and the crowdsale will assign them tokens based
150  * on a token per ETH rate. Funds collected are forwarded to a wallet
151  * as they arrive. The contract requires a MintableToken that will be
152  * minted as contributions arrive, note that the crowdsale contract
153  * must be owner of the token in order to be able to mint it.
154  */
155 contract Crowdsale {
156     using SafeMath for uint256;
157 
158     // The token being sold
159     address public token;
160 
161     // start and end timestamps where investments are allowed (both inclusive)
162     uint256 public startTime;
163     uint256 public endTime;
164 
165     // address where funds are collected
166     address public wallet;
167 
168     // how many token units a buyer gets per ether
169     uint256 public rate;
170 
171     // amount of raised money in wei
172     uint256 public weiRaised;
173 
174     // maximum amount of wei that can be raised
175     uint256 public hardCap;
176 
177     /**
178     * event for token purchase logging
179     * @param purchaser who paid for the tokens
180     * @param beneficiary who got the tokens
181     * @param value weis paid for purchase
182     * @param amount amount of tokens purchased
183     */
184     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
185 
186     constructor(uint256 _startTime, uint256 _endTime, uint256 _hardCap, uint256 _rate, address _wallet, address _token) public {
187         require(_startTime >= now);
188         require(_endTime >= _startTime);
189         require(_rate > 0);
190         require(_wallet != address(0));
191         require(_token != address(0));
192 
193         startTime = _startTime;
194         endTime = _endTime;
195         hardCap = _hardCap;
196         rate = _rate;
197         wallet = _wallet;
198         token = _token;
199     }
200 
201     // fallback function can be used to buy tokens
202     function () external payable {
203         buyTokens(msg.sender);
204     }
205 
206     // low level token purchase function
207     function buyTokens(address beneficiary) public payable {
208         require(beneficiary != address(0));
209         require(validPurchase());
210 
211         uint256 weiAmount = msg.value;
212 
213         // calculate token amount to be created
214         uint256 tokens = getTokenAmount(weiAmount);
215 
216         // update state
217         weiRaised = weiRaised.add(weiAmount);
218 
219         TokenInterface(token).mint(beneficiary, tokens);
220         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
221 
222         forwardFunds();
223     }
224 
225     // @return true if crowdsale event has ended
226     function hasEnded() public view returns (bool) {
227         return now > endTime;
228     }
229 
230     // Override this method to have a way to add business logic to your crowdsale when buying
231     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
232         return weiAmount.mul(rate);
233     }
234 
235     // send ether to the fund collection wallet
236     // override to create custom fund forwarding mechanisms
237     function forwardFunds() internal {
238         wallet.transfer(msg.value);
239     }
240 
241     // @return true if the transaction can buy tokens
242     function validPurchase() internal view returns (bool) {
243         require(weiRaised.add(msg.value) <= hardCap);
244         bool withinPeriod = now >= startTime && now <= endTime;
245         bool nonZeroPurchase = msg.value != 0;
246         return withinPeriod && nonZeroPurchase;
247     }
248 
249 }
250 
251 
252 
253 /**
254  * @title FinalizableCrowdsale
255  * @dev Extension of Crowdsale where an owner can do extra work
256  * after finishing.
257  */
258 contract FinalizableCrowdsale is Crowdsale, Ownable {
259     using SafeMath for uint256;
260 
261     bool public isFinalized = false;
262 
263     event Finalized();
264  
265     constructor(address _owner) public Ownable(_owner) {}
266 
267     /**
268     * @dev Must be called after crowdsale ends, to do some extra finalization
269     * work. Calls the contract's finalization function.
270     */
271     function finalize() onlyOwner public {
272         require(!isFinalized);
273         require(hasEnded());
274 
275         finalization();
276         emit Finalized();
277 
278         isFinalized = true;
279     }
280 
281     /**
282     * @dev Can be overridden to add finalization logic. The overriding function
283     * should call super.finalization() to ensure the chain of finalization is
284     * executed entirely.
285     */
286     function finalization() internal {}
287 }
288 
289 
290 
291 
292 
293 
294 
295 contract Whitelist is Ownable {
296     mapping(address => bool) internal investorMap;
297 
298     /**
299     * event for investor approval logging
300     * @param investor approved investor
301     */
302     event Approved(address indexed investor);
303 
304     /**
305     * event for investor disapproval logging
306     * @param investor disapproved investor
307     */
308     event Disapproved(address indexed investor);
309 
310     constructor(address _owner) 
311         public 
312         Ownable(_owner) 
313     {
314         
315     }
316 
317     /** @param _investor the address of investor to be checked
318       * @return true if investor is approved
319       */
320     function isInvestorApproved(address _investor) external view returns (bool) {
321         require(_investor != address(0));
322         return investorMap[_investor];
323     }
324 
325     /** @dev approve an investor
326       * @param toApprove investor to be approved
327       */
328     function approveInvestor(address toApprove) external onlyOwner {
329         investorMap[toApprove] = true;
330         emit Approved(toApprove);
331     }
332 
333     /** @dev approve investors in bulk
334       * @param toApprove array of investors to be approved
335       */
336     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
337         for (uint i = 0; i < toApprove.length; i++) {
338             investorMap[toApprove[i]] = true;
339             emit Approved(toApprove[i]);
340         }
341     }
342 
343     /** @dev disapprove an investor
344       * @param toDisapprove investor to be disapproved
345       */
346     function disapproveInvestor(address toDisapprove) external onlyOwner {
347         delete investorMap[toDisapprove];
348         emit Disapproved(toDisapprove);
349     }
350 
351     /** @dev disapprove investors in bulk
352       * @param toDisapprove array of investors to be disapproved
353       */
354     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
355         for (uint i = 0; i < toDisapprove.length; i++) {
356             delete investorMap[toDisapprove[i]];
357             emit Disapproved(toDisapprove[i]);
358         }
359     }
360 }
361 
362 
363 
364 /** @title Compliant Crowdsale */
365 contract CompliantCrowdsaleHardcap is Validator, FinalizableCrowdsale {
366     Whitelist public whiteListingContract;
367 
368     struct MintStruct {
369         address to;
370         uint256 tokens;
371         uint256 weiAmount;
372     }
373 
374     mapping (uint => MintStruct) public pendingMints;
375     uint256 public currentMintNonce;
376     mapping (address => uint) public rejectedMintBalance;
377 
378     modifier checkIsInvestorApproved(address _account) {
379         require(whiteListingContract.isInvestorApproved(_account));
380         _;
381     }
382 
383     modifier checkIsAddressValid(address _account) {
384         require(_account != address(0));
385         _;
386     }
387 
388     /**
389     * event for rejected mint logging
390     * @param to address for which buy tokens got rejected
391     * @param value number of tokens
392     * @param amount number of ethers invested
393     * @param nonce request recorded at this particular nonce
394     * @param reason reason for rejection
395     */
396     event MintRejected(
397         address indexed to,
398         uint256 value,
399         uint256 amount,
400         uint256 indexed nonce,
401         uint256 reason
402     );
403 
404     /**
405     * event for buy tokens request logging
406     * @param beneficiary address for which buy tokens is requested
407     * @param tokens number of tokens
408     * @param weiAmount number of ethers invested
409     * @param nonce request recorded at this particular nonce
410     */
411     event ContributionRegistered(
412         address beneficiary,
413         uint256 tokens,
414         uint256 weiAmount,
415         uint256 nonce
416     );
417 
418     /**
419     * event for rate update logging
420     * @param rate new rate
421     */
422     event RateUpdated(uint256 rate);
423 
424     /**
425     * event for whitelist contract update logging
426     * @param _whiteListingContract address of the new whitelist contract
427     */
428     event WhiteListingContractSet(address indexed _whiteListingContract);
429 
430     /**
431     * event for claimed ether logging
432     * @param account user claiming the ether
433     * @param amount ether claimed
434     */
435     event Claimed(address indexed account, uint256 amount);
436 
437     /** @dev Constructor
438       * @param whitelistAddress Ethereum address of the whitelist contract
439       * @param _startTime crowdsale start time
440       * @param _endTime crowdsale end time
441       * @param _hardcap maximum ether(in weis) this crowdsale can raise
442       * @param _rate number of tokens to be sold per ether
443       * @param _wallet Ethereum address of the wallet
444       * @param _token Ethereum address of the token contract
445       * @param _owner Ethereum address of the owner
446       */
447     constructor(
448         address whitelistAddress,
449         uint256 _startTime,
450         uint256 _endTime,
451         uint256 _hardcap,
452         uint256 _rate,
453         address _wallet,
454         address _token,
455         address _owner
456     )
457         public
458         FinalizableCrowdsale(_owner)
459         Crowdsale(_startTime, _endTime, _hardcap, _rate, _wallet, _token)
460     {
461         setWhitelistContract(whitelistAddress);
462     }
463 
464     /** @dev Updates whitelist contract address
465       * @param whitelistAddress address of the new whitelist contract 
466       */
467     function setWhitelistContract(address whitelistAddress)
468         public 
469         onlyValidator 
470         checkIsAddressValid(whitelistAddress)
471     {
472         whiteListingContract = Whitelist(whitelistAddress);
473         emit WhiteListingContractSet(whiteListingContract);
474     }
475 
476     /** @dev buy tokens request
477       * @param beneficiary the address to which the tokens have to be minted
478       */
479     function buyTokens(address beneficiary)
480         public 
481         payable
482         checkIsInvestorApproved(beneficiary)
483     {
484         require(validPurchase());
485 
486         uint256 weiAmount = msg.value;
487 
488         // calculate token amount to be created
489         uint256 tokens = weiAmount.mul(rate);
490 
491         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
492         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
493 
494         currentMintNonce++;
495     }
496 
497     /** @dev Updates token rate 
498     * @param _rate New token rate 
499     */ 
500     function updateRate(uint256 _rate) public onlyOwner { 
501         require(_rate > 0);
502         rate = _rate;
503         emit RateUpdated(rate);
504     }
505 
506     /** @dev approve buy tokens request
507       * @param nonce request recorded at this particular nonce
508       */
509     function approveMint(uint256 nonce)
510         external 
511         onlyValidator
512     {
513         require(_approveMint(nonce));
514     }
515 
516     /** @dev reject buy tokens request
517       * @param nonce request recorded at this particular nonce
518       * @param reason reason for rejection
519       */
520     function rejectMint(uint256 nonce, uint256 reason)
521         external 
522         onlyValidator
523     {
524         _rejectMint(nonce, reason);
525     }
526 
527     /** @dev approve buy tokens requests in bulk
528       * @param nonces request recorded at these nonces
529       */
530     function bulkApproveMints(uint256[] nonces)
531         external 
532         onlyValidator
533     {
534         for (uint i = 0; i < nonces.length; i++) {
535             require(_approveMint(nonces[i]));
536         }        
537     }
538     
539     /** @dev reject buy tokens requests
540       * @param nonces request recorded at these nonces
541       * @param reasons reasons for rejection
542       */
543     function bulkRejectMints(uint256[] nonces, uint256[] reasons)
544         external 
545         onlyValidator
546     {
547         require(nonces.length == reasons.length);
548         for (uint i = 0; i < nonces.length; i++) {
549             _rejectMint(nonces[i], reasons[i]);
550         }
551     }
552 
553     /** @dev approve buy tokens request called internally in the approveMint and bulkApproveMints functions
554       * @param nonce request recorded at this particular nonce
555       */
556     function _approveMint(uint256 nonce)
557         private
558         checkIsInvestorApproved(pendingMints[nonce].to)
559         returns (bool)
560     {
561         // update state
562         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
563 
564         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
565         TokenInterface(token).mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
566         
567         emit TokenPurchase(
568             msg.sender,
569             pendingMints[nonce].to,
570             pendingMints[nonce].weiAmount,
571             pendingMints[nonce].tokens
572         );
573 
574         forwardFunds(pendingMints[nonce].weiAmount);
575         delete pendingMints[nonce];
576 
577         return true;
578     }
579 
580     /** @dev reject buy tokens request called internally in the rejectMint and bulkRejectMints functions
581       * @param nonce request recorded at this particular nonce
582       * @param reason reason for rejection
583       */
584     function _rejectMint(uint256 nonce, uint256 reason)
585         private
586         checkIsAddressValid(pendingMints[nonce].to)
587     {
588         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
589         
590         emit MintRejected(
591             pendingMints[nonce].to,
592             pendingMints[nonce].tokens,
593             pendingMints[nonce].weiAmount,
594             nonce,
595             reason
596         );
597         
598         delete pendingMints[nonce];
599     }
600 
601     /** @dev claim back ether if buy tokens request is rejected */
602     function claim() external {
603         require(rejectedMintBalance[msg.sender] > 0);
604         uint256 value = rejectedMintBalance[msg.sender];
605         rejectedMintBalance[msg.sender] = 0;
606 
607         msg.sender.transfer(value);
608 
609         emit Claimed(msg.sender, value);
610     }
611 
612     function finalization() internal {
613         TokenInterface(token).finishMinting();
614         transferTokenOwnership(owner);
615         super.finalization();
616     }
617 
618     /** @dev Updates token contract address
619       * @param newToken New token contract address
620       */
621     function setTokenContract(address newToken)
622         external 
623         onlyOwner
624         checkIsAddressValid(newToken)
625     {
626         token = newToken;
627     }
628 
629     /** @dev transfers ownership of the token contract
630       * @param newOwner New owner of the token contract
631       */
632     function transferTokenOwnership(address newOwner)
633         public 
634         onlyOwner
635         checkIsAddressValid(newOwner)
636     {
637         TokenInterface(token).transferOwnership(newOwner);
638     }
639 
640     function forwardFunds(uint256 amount) internal {
641         wallet.transfer(amount);
642     }
643 }