1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title TokenlessCrowdsale
51  * @dev Crowdsale based on OpenZeppelin's Crowdsale but without token-related logic
52  * @author U-Zyn Chua <uzyn@zynesis.com>
53  *
54  * Largely similar to OpenZeppelin except the following irrelevant token-related hooks removed:
55  * - function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal
56  * - function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal
57  * - function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256)
58  * - event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount)
59  *
60  * Added hooks:
61  * - function _processPurchaseInWei(address _beneficiary, uint256 _weiAmount) internal
62  * - event SaleContribution(address indexed purchaser, address indexed beneficiary, uint256 value)
63  */
64 contract TokenlessCrowdsale {
65   using SafeMath for uint256;
66 
67   // Address where funds are collected
68   address public wallet;
69 
70   // Amount of wei raised
71   uint256 public weiRaised;
72 
73   /**
74    * Event for token purchase logging
75    * similar to TokenPurchase without the token amount
76    * @param purchaser who paid for the tokens
77    * @param beneficiary who got the tokens
78    * @param value weis paid for purchase
79    */
80   event SaleContribution(address indexed purchaser, address indexed beneficiary, uint256 value);
81 
82   /**
83    * @param _wallet Address where collected funds will be forwarded to
84    */
85   constructor (address _wallet) public {
86     require(_wallet != address(0));
87     wallet = _wallet;
88   }
89 
90   // -----------------------------------------
91   // Crowdsale external interface
92   // -----------------------------------------
93 
94   /**
95    * @dev fallback function ***DO NOT OVERRIDE***
96    */
97   function () external payable {
98     buyTokens(msg.sender);
99   }
100 
101   /**
102    * @dev low level token purchase ***DO NOT OVERRIDE***
103    * @param _beneficiary Address performing the token purchase
104    */
105   function buyTokens(address _beneficiary) public payable {
106 
107     uint256 weiAmount = msg.value;
108     _preValidatePurchase(_beneficiary, weiAmount);
109 
110     // update state
111     weiRaised = weiRaised.add(weiAmount);
112 
113     _processPurchaseInWei(_beneficiary, weiAmount);
114     emit SaleContribution(
115       msg.sender,
116       _beneficiary,
117       weiAmount
118     );
119 
120     _updatePurchasingState(_beneficiary, weiAmount);
121 
122     _forwardFunds();
123     _postValidatePurchase(_beneficiary, weiAmount);
124   }
125 
126   // -----------------------------------------
127   // Internal interface (extensible)
128   // -----------------------------------------
129 
130   /**
131    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
132    * @param _beneficiary Address performing the token purchase
133    * @param _weiAmount Value in wei involved in the purchase
134    */
135   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
136     require(_beneficiary != address(0));
137     require(_weiAmount != 0);
138   }
139 
140   /**
141    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
142    * @param _beneficiary Address performing the token purchase
143    * @param _weiAmount Value in wei involved in the purchase
144    */
145   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
146     // optional override
147   }
148 
149   /**
150    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
151    * @param _beneficiary Address receiving the tokens
152    * @param _weiAmount Number of wei contributed
153    */
154   function _processPurchaseInWei(address _beneficiary, uint256 _weiAmount) internal {
155     // override with logic on tokens delivery
156   }
157 
158   /**
159    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
160    * @param _beneficiary Address receiving the tokens
161    * @param _weiAmount Value in wei involved in the purchase
162    */
163   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
164     // optional override
165   }
166 
167   /**
168    * @dev Determines how ETH is stored/forwarded on purchases.
169    */
170   function _forwardFunds() internal {
171     wallet.transfer(msg.value);
172   }
173 }
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     emit OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 
216 /**
217  * @title WhitelistedAICrowdsale
218  * @dev Crowdsale in which only whitelisted users can contribute,
219  * with a defined individual cap in wei,
220  * and a bool flag on whether a user is an accredited investor (AI)
221  * Based on OpenZeppelin's WhitelistedCrowdsale and IndividuallyCappedCrowdsale
222  * @author U-Zyn Chua <uzyn@zynesis.com>
223  */
224 contract WhitelistedAICrowdsale is TokenlessCrowdsale, Ownable {
225   using SafeMath for uint256;
226 
227   mapping(address => bool) public accredited;
228 
229   // Individual cap
230   mapping(address => uint256) public contributions;
231   mapping(address => uint256) public caps;
232 
233  /**
234   * @dev Returns if a beneficiary is whitelisted
235   * @return bool
236   */
237   function isWhitelisted(address _beneficiary) public view returns (bool) {
238     if (caps[_beneficiary] != 0) {
239       return true;
240     }
241     return false;
242   }
243 
244   /**
245    * @dev Adds single address to whitelist.
246    * Use this also to update
247    * @param _beneficiary Address to be added to the whitelist
248    */
249   function addToWhitelist(address _beneficiary, uint256 _cap, bool _accredited) external onlyOwner {
250     caps[_beneficiary] = _cap;
251     accredited[_beneficiary] = _accredited;
252   }
253 
254   /**
255    * @dev Removes single address from whitelist.
256    * @param _beneficiary Address to be removed to the whitelist
257    */
258   function removeFromWhitelist(address _beneficiary) external onlyOwner {
259     caps[_beneficiary] = 0;
260     accredited[_beneficiary] = false;
261   }
262 
263   /**
264    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
265    * @param _beneficiary Token beneficiary
266    * @param _weiAmount Amount of wei contributed
267    */
268   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
269     super._preValidatePurchase(_beneficiary, _weiAmount);
270     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
271   }
272 
273   /**
274    * @dev Extend parent behavior to update user contributions
275    * @param _beneficiary Token purchaser
276    * @param _weiAmount Amount of wei contributed
277    */
278   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
279     super._updatePurchasingState(_beneficiary, _weiAmount);
280     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
281   }
282 
283 }
284 
285 
286 /**
287  * @title FiatCappedCrowdsale
288  * @dev Crowdsale with a limit for total contributions defined in fiat (USD).
289  * Based on OpenZeppelin's CappedCrowdsale
290  * Handles fiat rates, but does not handle token awarding.
291  * @author U-Zyn Chua <uzyn@zynesis.com>
292  */
293 contract FiatCappedCrowdsale is TokenlessCrowdsale, Ownable {
294   using SafeMath for uint256;
295 
296   // 1 USD = 1000 mill (1 mill is USD 0.001)
297   // 1 ETH = 1e18 wei
298   // 1 SPX = 1e18 leconte
299 
300   uint256 public millCap; // cap defined in USD mill
301   uint256 public millRaised; // amount of USD mill raised
302 
303   // Minimum fiat value purchase per transaction
304   uint256 public minMillPurchase;
305 
306   // How many ETH wei per USD 0.001
307   uint256 public millWeiRate;
308 
309   // How many SPX leconte per USD 0.001, without bonus
310   uint256 public millLeconteRate;
311 
312   // Sanity checks
313   // 1 ETH is between USD 100 and USD 5,000
314   uint256 constant minMillWeiRate = (10 ** 18) / (5000 * (10 ** 3)); // USD 5,000
315   uint256 constant maxMillWeiRate = (10 ** 18) / (100 * (10 ** 3)); // USD 100
316 
317   // 1 SPX is between USD 0.01 and USD 1
318   uint256 constant minMillLeconteRate = (10 ** 18) / 1000; // USD 1
319   uint256 constant maxMillLeconteRate = (10 ** 18) / 10; // USD 0.01
320 
321   /**
322    * @dev Throws if mill rate for ETH wei is not sane
323    */
324   modifier isSaneETHRate(uint256 _millWeiRate) {
325     require(_millWeiRate >= minMillWeiRate);
326     require(_millWeiRate <= maxMillWeiRate);
327     _;
328   }
329 
330   /**
331    * @dev Throws if mill rate for SPX wei is not sane
332    */
333   modifier isSaneSPXRate(uint256 _millLeconteRate) {
334     require(_millLeconteRate >= minMillLeconteRate);
335     require(_millLeconteRate <= maxMillLeconteRate);
336     _;
337   }
338 
339   /**
340    * @dev Constructor
341    * @param _millCap Max amount of mill to be contributed
342    * @param _millLeconteRate How many SPX leconte per mill
343    * @param _millWeiRate How many ETH wei per mill, this is updateable with setWeiRate()
344    */
345   constructor (
346     uint256 _millCap,
347     uint256 _minMillPurchase,
348     uint256 _millLeconteRate,
349     uint256 _millWeiRate
350   ) public isSaneSPXRate(_millLeconteRate) isSaneETHRate(_millWeiRate) {
351     require(_millCap > 0);
352     require(_minMillPurchase > 0);
353 
354     millCap = _millCap;
355     minMillPurchase = _minMillPurchase;
356     millLeconteRate = _millLeconteRate;
357     millWeiRate = _millWeiRate;
358   }
359 
360   /**
361    * @dev Checks whether the cap has been reached.
362    * @return Whether the cap was reached
363    */
364   function capReached() public view returns (bool) {
365     return millRaised >= millCap;
366   }
367 
368   /**
369    * @dev Sets the current ETH wei rate - How many ETH wei per mill
370    */
371   function setWeiRate(uint256 _millWeiRate) external onlyOwner isSaneETHRate(_millWeiRate) {
372     millWeiRate = _millWeiRate;
373   }
374 
375   /**
376    * @dev Extend parent behavior requiring purchase to respect the funding cap,
377    * and that contribution should be >= minMillPurchase
378    * @param _beneficiary Token purchaser
379    * @param _weiAmount Amount of wei contributed
380    */
381   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
382     super._preValidatePurchase(_beneficiary, _weiAmount);
383 
384     // Check for minimum contribution
385     uint256 _millAmount = _toMill(_weiAmount);
386     require(_millAmount >= minMillPurchase);
387 
388     // Check for funding cap
389     uint256 _millRaised = millRaised.add(_millAmount);
390     require(_millRaised <= millCap);
391     millRaised = _millRaised;
392   }
393 
394   /**
395    * @dev Returns the amount in USD mill given ETH wei
396    * @param _weiAmount Amount in ETH wei
397    * @return amount in mill
398    */
399   function _toMill(uint256 _weiAmount) internal returns (uint256) {
400     return _weiAmount.div(millWeiRate);
401   }
402 
403   /**
404    * @dev Returns the amount in SPX leconte given ETH wei
405    * @param _weiAmount Amount in ETH wei
406    * @return amount in leconte
407    */
408   function _toLeconte(uint256 _weiAmount) internal returns (uint256) {
409     return _toMill(_weiAmount).mul(millLeconteRate);
410   }
411 }
412 
413 /**
414  * @title PausableCrowdsale
415  * @dev Crowdsale allowing owner to halt sale process
416  * Based on OpenZeppelin's TimedCrowdsale
417  * @author U-Zyn Chua <uzyn@zynesis.com>
418  */
419 contract PausableCrowdsale is TokenlessCrowdsale, Ownable {
420   /**
421    * Owner controllable switch to open or halt sale
422    * This is independent from other checks such as cap, no other processes except owner should alter this value. This also means that even if hardCap is reached, this variable does not set to false on its own.
423    * This variable is revocable, hence behaving more like a pause than close when turned to off.
424    */
425   bool public open = true;
426 
427   modifier saleIsOpen() {
428     require(open);
429     _;
430   }
431 
432   function unpauseSale() external onlyOwner {
433     require(!open);
434     open = true;
435   }
436 
437   function pauseSale() external onlyOwner saleIsOpen {
438     open = false;
439   }
440 
441   /**
442    * @dev Extend parent behavior requiring sale to be opened
443    */
444   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal saleIsOpen {
445     super._preValidatePurchase(_beneficiary, _weiAmount);
446   }
447 }
448 
449 /**
450  * @title ERC20Basic
451  * @dev Simpler version of ERC20 interface
452  * @dev see https://github.com/ethereum/EIPs/issues/179
453  */
454 contract ERC20Basic {
455   function totalSupply() public view returns (uint256);
456   function balanceOf(address who) public view returns (uint256);
457   function transfer(address to, uint256 value) public returns (bool);
458   event Transfer(address indexed from, address indexed to, uint256 value);
459 }
460 
461 /**
462  * @title Basic token
463  * @dev Basic version of StandardToken, with no allowances.
464  */
465 contract BasicToken is ERC20Basic {
466   using SafeMath for uint256;
467 
468   mapping(address => uint256) balances;
469 
470   uint256 totalSupply_;
471 
472   /**
473   * @dev total number of tokens in existence
474   */
475   function totalSupply() public view returns (uint256) {
476     return totalSupply_;
477   }
478 
479   /**
480   * @dev transfer token for a specified address
481   * @param _to The address to transfer to.
482   * @param _value The amount to be transferred.
483   */
484   function transfer(address _to, uint256 _value) public returns (bool) {
485     require(_to != address(0));
486     require(_value <= balances[msg.sender]);
487 
488     balances[msg.sender] = balances[msg.sender].sub(_value);
489     balances[_to] = balances[_to].add(_value);
490     emit Transfer(msg.sender, _to, _value);
491     return true;
492   }
493 
494   /**
495   * @dev Gets the balance of the specified address.
496   * @param _owner The address to query the the balance of.
497   * @return An uint256 representing the amount owned by the passed address.
498   */
499   function balanceOf(address _owner) public view returns (uint256) {
500     return balances[_owner];
501   }
502 }
503 
504 /**
505  * @title ERC223 Token Receiver Interface
506  * based on https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/Receiver_Interface.sol but much simplified
507  */
508 contract BasicERC223Receiver {
509   function tokenFallback(address _from, uint256 _value, bytes _data) public pure;
510 }
511 
512 
513 /**
514  * @title RestrictedToken
515  * @dev Standard Mintable ERC20 Token that can only be sent to an authorized address
516  * Based on Consensys' TokenFoundry's ControllableToken
517  * @author U-Zyn Chua <uzyn@zynesis.com>
518  */
519 contract RestrictedToken is BasicToken, Ownable {
520   string public name;
521   string public symbol;
522   uint8 public decimals;
523 
524   // Authorized senders are able to transfer tokens freely, usu. Sale contract
525   address public issuer;
526 
527   // Vesting period for exchanging of RestrictedToken to non-restricted token
528   // This is for reference by exchange contract and no inherit use for this contract
529   uint256 public vestingPeriod;
530 
531   // Holders of RestrictedToken are only able to transfer token to authorizedRecipients, usu. Exchange contract
532   mapping(address => bool) public authorizedRecipients;
533 
534   // Whether recipients are ERC223-compliant
535   mapping(address => bool) public erc223Recipients;
536 
537   // Last issued time of token per recipient
538   mapping(address => uint256) public lastIssuedTime;
539 
540   event Issue(address indexed to, uint256 value);
541 
542   /**
543    * @dev Throws if called by any account other than the issuer.
544    */
545   modifier onlyIssuer() {
546     require(msg.sender == issuer);
547     _;
548   }
549 
550   /**
551    * @dev Modifier to check if a transfer is allowed
552    */
553   modifier isAuthorizedRecipient(address _recipient) {
554     require(authorizedRecipients[_recipient]);
555     _;
556   }
557 
558   constructor (
559     uint256 _supply,
560     string _name,
561     string _symbol,
562     uint8 _decimals,
563     uint256 _vestingPeriod,
564     address _owner, // usu. human
565     address _issuer // usu. sale contract
566   ) public {
567     require(_supply != 0);
568     require(_owner != address(0));
569     require(_issuer != address(0));
570 
571     name = _name;
572     symbol = _symbol;
573     decimals = _decimals;
574     vestingPeriod = _vestingPeriod;
575     owner = _owner;
576     issuer = _issuer;
577     totalSupply_ = _supply;
578     balances[_issuer] = _supply;
579     emit Transfer(address(0), _issuer, _supply);
580   }
581 
582   /**
583    * @dev Allows owner to authorize or deauthorize recipients
584    */
585   function authorize(address _recipient, bool _isERC223) public onlyOwner {
586     require(_recipient != address(0));
587     authorizedRecipients[_recipient] = true;
588     erc223Recipients[_recipient] = _isERC223;
589   }
590 
591   function deauthorize(address _recipient) public onlyOwner isAuthorizedRecipient(_recipient) {
592     authorizedRecipients[_recipient] = false;
593     erc223Recipients[_recipient] = false;
594   }
595 
596   /**
597    * @dev Only allow transfer to authorized recipients
598    */
599   function transfer(address _to, uint256 _value) public isAuthorizedRecipient(_to) returns (bool) {
600     if (erc223Recipients[_to]) {
601       BasicERC223Receiver receiver = BasicERC223Receiver(_to);
602       bytes memory empty;
603       receiver.tokenFallback(msg.sender, _value, empty);
604     }
605     return super.transfer(_to, _value);
606   }
607 
608   /**
609    * Issue token
610    * @dev also records the token issued time
611    */
612   function issue(address _to, uint256 _value) public onlyIssuer returns (bool) {
613     lastIssuedTime[_to] = block.timestamp;
614 
615     emit Issue(_to, _value);
616     return super.transfer(_to, _value);
617   }
618 }
619 
620 /**
621  * @title Sparrow Token private sale
622  */
623 contract PrivateSale is TokenlessCrowdsale, WhitelistedAICrowdsale, FiatCappedCrowdsale, PausableCrowdsale {
624   using SafeMath for uint256;
625 
626   // The 2 tokens being sold
627   RestrictedToken public tokenR0; // SPX-R0 - restricted token with no vesting
628   RestrictedToken public tokenR6; // SPX-R6 - restricted token with 6-month vesting
629 
630   uint8 constant bonusPct = 30;
631 
632   constructor (address _wallet, uint256 _millWeiRate) TokenlessCrowdsale(_wallet)
633     FiatCappedCrowdsale(
634       5000000 * (10 ** 3), // millCap: USD 5 million
635       10000 * (10 ** 3), // minMillPurchase: USD 10,000
636       (10 ** 18) / 50, // millLeconteRate: 1 SPX = USD 0.05
637       _millWeiRate
638     )
639   public {
640     tokenR0 = new RestrictedToken(
641       2 * 100000000 * (10 ** 18), // supply: 100 million (* 2 for edge safety)
642       'Sparrow Token (Restricted)', // name
643       'SPX-R0', // symbol
644       18, // decimals
645       0, // no vesting
646       msg.sender, // owner
647       this // issuer
648     );
649 
650     // SPX-R6: Only 30 mil needed if all contributors are AI, 130 mil needed if all contributors are non-AIs
651     tokenR6 = new RestrictedToken(
652       2 * 130000000 * (10 ** 18), // supply: 130 million (* 2 for edge safety)
653       'Sparrow Token (Restricted with 6-month vesting)', // name
654       'SPX-R6', // symbol
655       18, // decimals
656       6 * 30 * 86400, // vesting: 6 months
657       msg.sender, // owner
658       this // issuer
659     );
660   }
661 
662   // If accredited, non-bonus tokens are given as tokenR0, bonus tokens are given as tokenR6
663   // If non-accredited, non-bonus and bonus tokens are given as tokenR6
664   function _processPurchaseInWei(address _beneficiary, uint256 _weiAmount) internal {
665     super._processPurchaseInWei(_beneficiary, _weiAmount);
666 
667     uint256 tokens = _toLeconte(_weiAmount);
668     uint256 bonus = tokens.mul(bonusPct).div(100);
669 
670     // Accredited
671     if (accredited[_beneficiary]) {
672       tokenR0.issue(_beneficiary, tokens);
673       tokenR6.issue(_beneficiary, bonus);
674     } else {
675       tokenR6.issue(_beneficiary, tokens.add(bonus));
676     }
677   }
678 }