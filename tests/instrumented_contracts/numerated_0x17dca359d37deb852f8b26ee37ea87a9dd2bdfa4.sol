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
174     /**
175     * event for token purchase logging
176     * @param purchaser who paid for the tokens
177     * @param beneficiary who got the tokens
178     * @param value weis paid for purchase
179     * @param amount amount of tokens purchased
180     */
181     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
182 
183 
184     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
185         require(_startTime >= now);
186         require(_endTime >= _startTime);
187         require(_rate > 0);
188         require(_wallet != address(0));
189         require(_token != address(0));
190 
191         startTime = _startTime;
192         endTime = _endTime;
193         rate = _rate;
194         wallet = _wallet;
195         token = _token;
196     }
197 
198     /** @dev fallback function redirects to buy tokens */
199     function () external payable {
200         buyTokens(msg.sender);
201     }
202 
203     /** @dev buy tokens
204       * @param beneficiary the address to which the tokens have to be minted
205       */
206     function buyTokens(address beneficiary) public payable {
207         require(beneficiary != address(0));
208         require(validPurchase());
209 
210         uint256 weiAmount = msg.value;
211 
212         // calculate token amount to be created
213         uint256 tokens = getTokenAmount(weiAmount);
214 
215         // update state
216         weiRaised = weiRaised.add(weiAmount);
217 
218         TokenInterface(token).mint(beneficiary, tokens);
219         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
220 
221         forwardFunds();
222     }
223 
224     /** @return true if crowdsale event has ended */
225     function hasEnded() public view returns (bool) {
226         return now > endTime;
227     }
228 
229     // Override this method to have a way to add business logic to your crowdsale when buying
230     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
231         return weiAmount.mul(rate);
232     }
233 
234     // send ether to the fund collection wallet
235     // override to create custom fund forwarding mechanisms
236     function forwardFunds() internal {
237         wallet.transfer(msg.value);
238     }
239 
240     // @return true if the transaction can buy tokens
241     function validPurchase() internal view returns (bool) {
242         bool withinPeriod = now >= startTime && now <= endTime;
243         bool nonZeroPurchase = msg.value != 0;
244         return withinPeriod && nonZeroPurchase;
245     }
246 
247 }
248 
249 
250 
251 
252 /**
253  * @title FinalizableCrowdsale
254  * @dev Extension of Crowdsale where an owner can do extra work
255  * after finishing.
256  */
257 contract FinalizableCrowdsale is Crowdsale, Ownable {
258     using SafeMath for uint256;
259 
260     bool public isFinalized = false;
261 
262     event Finalized();
263  
264     constructor(address _owner) public Ownable(_owner) {}
265 
266     /**
267     * @dev Must be called after crowdsale ends, to do some extra finalization
268     * work. Calls the contract's finalization function.
269     */
270     function finalize() onlyOwner public {
271         require(!isFinalized);
272         require(hasEnded());
273 
274         finalization();
275         emit Finalized();
276 
277         isFinalized = true;
278     }
279 
280     /**
281     * @dev Can be overridden to add finalization logic. The overriding function
282     * should call super.finalization() to ensure the chain of finalization is
283     * executed entirely.
284     */
285     function finalization() internal {}
286 }
287 
288 
289 
290 
291 
292 
293 contract Whitelist is Ownable {
294     mapping(address => bool) internal investorMap;
295 
296     /**
297     * event for investor approval logging
298     * @param investor approved investor
299     */
300     event Approved(address indexed investor);
301 
302     /**
303     * event for investor disapproval logging
304     * @param investor disapproved investor
305     */
306     event Disapproved(address indexed investor);
307 
308     constructor(address _owner) 
309         public 
310         Ownable(_owner) 
311     {
312         
313     }
314 
315     /** @param _investor the address of investor to be checked
316       * @return true if investor is approved
317       */
318     function isInvestorApproved(address _investor) external view returns (bool) {
319         require(_investor != address(0));
320         return investorMap[_investor];
321     }
322 
323     /** @dev approve an investor
324       * @param toApprove investor to be approved
325       */
326     function approveInvestor(address toApprove) external onlyOwner {
327         investorMap[toApprove] = true;
328         emit Approved(toApprove);
329     }
330 
331     /** @dev approve investors in bulk
332       * @param toApprove array of investors to be approved
333       */
334     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
335         for (uint i = 0; i < toApprove.length; i++) {
336             investorMap[toApprove[i]] = true;
337             emit Approved(toApprove[i]);
338         }
339     }
340 
341     /** @dev disapprove an investor
342       * @param toDisapprove investor to be disapproved
343       */
344     function disapproveInvestor(address toDisapprove) external onlyOwner {
345         delete investorMap[toDisapprove];
346         emit Disapproved(toDisapprove);
347     }
348 
349     /** @dev disapprove investors in bulk
350       * @param toDisapprove array of investors to be disapproved
351       */
352     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
353         for (uint i = 0; i < toDisapprove.length; i++) {
354             delete investorMap[toDisapprove[i]];
355             emit Disapproved(toDisapprove[i]);
356         }
357     }
358 }
359 
360 
361 
362 /** @title Compliant Crowdsale */
363 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
364     Whitelist public whiteListingContract;
365 
366     struct MintStruct {
367         address to;
368         uint256 tokens;
369         uint256 weiAmount;
370     }
371 
372     mapping (uint => MintStruct) public pendingMints;
373     uint256 public currentMintNonce;
374     mapping (address => uint) public rejectedMintBalance;
375 
376     modifier checkIsInvestorApproved(address _account) {
377         require(whiteListingContract.isInvestorApproved(_account));
378         _;
379     }
380 
381     modifier checkIsAddressValid(address _account) {
382         require(_account != address(0));
383         _;
384     }
385 
386     /**
387     * event for rejected mint logging
388     * @param to address for which buy tokens got rejected
389     * @param value number of tokens
390     * @param amount number of ethers invested
391     * @param nonce request recorded at this particular nonce
392     * @param reason reason for rejection
393     */
394     event MintRejected(
395         address indexed to,
396         uint256 value,
397         uint256 amount,
398         uint256 indexed nonce,
399         uint256 reason
400     );
401 
402     /**
403     * event for buy tokens request logging
404     * @param beneficiary address for which buy tokens is requested
405     * @param tokens number of tokens
406     * @param weiAmount number of ethers invested
407     * @param nonce request recorded at this particular nonce
408     */
409     event ContributionRegistered(
410         address beneficiary,
411         uint256 tokens,
412         uint256 weiAmount,
413         uint256 nonce
414     );
415 
416     /**
417     * event for rate update logging
418     * @param rate new rate
419     */
420     event RateUpdated(uint256 rate);
421 
422     /**
423     * event for whitelist contract update logging
424     * @param _whiteListingContract address of the new whitelist contract
425     */
426     event WhiteListingContractSet(address indexed _whiteListingContract);
427 
428     /**
429     * event for claimed ether logging
430     * @param account user claiming the ether
431     * @param amount ether claimed
432     */
433     event Claimed(address indexed account, uint256 amount);
434 
435     /** @dev Constructor
436       * @param whitelistAddress Ethereum address of the whitelist contract
437       * @param _startTime crowdsale start time
438       * @param _endTime crowdsale end time
439       * @param _rate number of tokens to be sold per ether
440       * @param _wallet Ethereum address of the wallet
441       * @param _token Ethereum address of the token contract
442       * @param _owner Ethereum address of the owner
443       */
444     constructor(
445         address whitelistAddress,
446         uint256 _startTime,
447         uint256 _endTime,
448         uint256 _rate,
449         address _wallet,
450         address _token,
451         address _owner
452     )
453         public
454         FinalizableCrowdsale(_owner)
455         Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
456     {
457         setWhitelistContract(whitelistAddress);
458     }
459 
460     /** @dev Updates whitelist contract address
461       * @param whitelistAddress address of the new whitelist contract 
462       */
463     function setWhitelistContract(address whitelistAddress)
464         public 
465         onlyValidator 
466         checkIsAddressValid(whitelistAddress)
467     {
468         whiteListingContract = Whitelist(whitelistAddress);
469         emit WhiteListingContractSet(whiteListingContract);
470     }
471 
472     /** @dev buy tokens request
473       * @param beneficiary the address to which the tokens have to be minted
474       */
475     function buyTokens(address beneficiary)
476         public 
477         payable
478         checkIsInvestorApproved(beneficiary)
479     {
480         require(validPurchase());
481 
482         uint256 weiAmount = msg.value;
483 
484         // calculate token amount to be created
485         uint256 tokens = weiAmount.mul(rate);
486 
487         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
488         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
489 
490         currentMintNonce++;
491     }
492 
493     /** @dev Updates token rate 
494     * @param _rate New token rate 
495     */ 
496     function updateRate(uint256 _rate) public onlyOwner { 
497         require(_rate > 0);
498         rate = _rate;
499         emit RateUpdated(rate);
500     }
501 
502     /** @dev approve buy tokens request
503       * @param nonce request recorded at this particular nonce
504       */
505     function approveMint(uint256 nonce)
506         external 
507         onlyValidator
508     {
509         require(_approveMint(nonce));
510     }
511 
512     /** @dev reject buy tokens request
513       * @param nonce request recorded at this particular nonce
514       * @param reason reason for rejection
515       */
516     function rejectMint(uint256 nonce, uint256 reason)
517         external 
518         onlyValidator
519     {
520         _rejectMint(nonce, reason);
521     }
522 
523     /** @dev approve buy tokens requests in bulk
524       * @param nonces request recorded at these nonces
525       */
526     function bulkApproveMints(uint256[] nonces)
527         external 
528         onlyValidator
529     {
530         for (uint i = 0; i < nonces.length; i++) {
531             require(_approveMint(nonces[i]));
532         }        
533     }
534     
535     /** @dev reject buy tokens requests
536       * @param nonces request recorded at these nonces
537       * @param reasons reasons for rejection
538       */
539     function bulkRejectMints(uint256[] nonces, uint256[] reasons)
540         external 
541         onlyValidator
542     {
543         require(nonces.length == reasons.length);
544         for (uint i = 0; i < nonces.length; i++) {
545             _rejectMint(nonces[i], reasons[i]);
546         }
547     }
548 
549     /** @dev approve buy tokens request called internally in the approveMint and bulkApproveMints functions
550       * @param nonce request recorded at this particular nonce
551       */
552     function _approveMint(uint256 nonce)
553         private
554         checkIsInvestorApproved(pendingMints[nonce].to)
555         returns (bool)
556     {
557         // update state
558         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
559 
560         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
561         TokenInterface(token).mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
562         
563         emit TokenPurchase(
564             msg.sender,
565             pendingMints[nonce].to,
566             pendingMints[nonce].weiAmount,
567             pendingMints[nonce].tokens
568         );
569 
570         forwardFunds(pendingMints[nonce].weiAmount);
571         delete pendingMints[nonce];
572 
573         return true;
574     }
575 
576     /** @dev reject buy tokens request called internally in the rejectMint and bulkRejectMints functions
577       * @param nonce request recorded at this particular nonce
578       * @param reason reason for rejection
579       */
580     function _rejectMint(uint256 nonce, uint256 reason)
581         private
582         checkIsAddressValid(pendingMints[nonce].to)
583     {
584         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
585         
586         emit MintRejected(
587             pendingMints[nonce].to,
588             pendingMints[nonce].tokens,
589             pendingMints[nonce].weiAmount,
590             nonce,
591             reason
592         );
593         
594         delete pendingMints[nonce];
595     }
596 
597     /** @dev claim back ether if buy tokens request is rejected */
598     function claim() external {
599         require(rejectedMintBalance[msg.sender] > 0);
600         uint256 value = rejectedMintBalance[msg.sender];
601         rejectedMintBalance[msg.sender] = 0;
602 
603         msg.sender.transfer(value);
604 
605         emit Claimed(msg.sender, value);
606     }
607 
608     function finalization() internal {
609         TokenInterface(token).finishMinting();
610         transferTokenOwnership(owner);
611         super.finalization();
612     }
613 
614     /** @dev Updates token contract address
615       * @param newToken New token contract address
616       */
617     function setTokenContract(address newToken)
618         external 
619         onlyOwner
620         checkIsAddressValid(newToken)
621     {
622         token = newToken;
623     }
624 
625     /** @dev transfers ownership of the token contract
626       * @param newOwner New owner of the token contract
627       */
628     function transferTokenOwnership(address newOwner)
629         public 
630         onlyOwner
631         checkIsAddressValid(newOwner)
632     {
633         TokenInterface(token).transferOwnership(newOwner);
634     }
635 
636     function forwardFunds(uint256 amount) internal {
637         wallet.transfer(amount);
638     }
639 }