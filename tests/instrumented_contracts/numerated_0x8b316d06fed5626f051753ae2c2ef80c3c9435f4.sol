1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 contract PresaleFallbackReceiver {
62   bool public presaleFallBackCalled;
63 
64   function presaleFallBack(uint256 _presaleWeiRaised) public returns (bool);
65 }
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event Pause();
83   event Unpause();
84 
85   bool public paused = false;
86 
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
121 
122 
123 
124 
125 
126 /**
127  * @title RefundVault
128  * @dev This contract is used for storing funds while a crowdsale
129  * is in progress. Supports refunding the money if crowdsale fails,
130  * and forwarding it if crowdsale is successful.
131  */
132 contract RefundVault is Ownable {
133   using SafeMath for uint256;
134 
135   enum State { Active, Refunding, Closed }
136 
137   mapping (address => uint256) public deposited;
138   address public wallet;
139   State public state;
140 
141   event Closed();
142   event RefundsEnabled();
143   event Refunded(address indexed beneficiary, uint256 weiAmount);
144 
145   function RefundVault(address _wallet) public {
146     require(_wallet != address(0));
147     wallet = _wallet;
148     state = State.Active;
149   }
150 
151   function deposit(address investor) onlyOwner public payable {
152     require(state == State.Active);
153     deposited[investor] = deposited[investor].add(msg.value);
154   }
155 
156   function close() onlyOwner public {
157     require(state == State.Active);
158     state = State.Closed;
159     Closed();
160     wallet.transfer(this.balance);
161   }
162 
163   function enableRefunds() onlyOwner public {
164     require(state == State.Active);
165     state = State.Refunding;
166     RefundsEnabled();
167   }
168 
169   function refund(address investor) public {
170     require(state == State.Refunding);
171     uint256 depositedValue = deposited[investor];
172     deposited[investor] = 0;
173     investor.transfer(depositedValue);
174     Refunded(investor, depositedValue);
175   }
176 }
177 
178 
179 
180 
181 /**
182  * @title SafeMath
183  * @dev Math operations with safety checks that throw on error
184  */
185 library SafeMath {
186   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187     if (a == 0) {
188       return 0;
189     }
190     uint256 c = a * b;
191     assert(c / a == b);
192     return c;
193   }
194 
195   function div(uint256 a, uint256 b) internal pure returns (uint256) {
196     // assert(b > 0); // Solidity automatically throws when dividing by 0
197     uint256 c = a / b;
198     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199     return c;
200   }
201 
202   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203     assert(b <= a);
204     return a - b;
205   }
206 
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 
215 
216 
217 contract Controlled {
218     /// @notice The address of the controller is the only address that can call
219     ///  a function with this modifier
220     modifier onlyController { require(msg.sender == controller); _; }
221 
222     address public controller;
223 
224     function Controlled() public { controller = msg.sender;}
225 
226     /// @notice Changes the controller of the contract
227     /// @param _newController The new controller of the contract
228     function changeController(address _newController) public onlyController {
229         controller = _newController;
230     }
231 }
232 
233 
234 
235 
236 
237 
238 
239 
240 
241 
242 contract BTCPaymentI is Ownable, PresaleFallbackReceiver {
243   PaymentFallbackReceiver public presale;
244   PaymentFallbackReceiver public mainsale;
245 
246   function addPayment(address _beneficiary, uint256 _tokens) public;
247   function setPresale(address _presale) external;
248   function setMainsale(address _mainsale) external;
249   function presaleFallBack(uint256) public returns (bool);
250 }
251 
252 
253 contract PaymentFallbackReceiver {
254   BTCPaymentI public payment;
255 
256   enum SaleType { pre, main }
257 
258   function PaymentFallbackReceiver(address _payment) public {
259     require(_payment != address(0));
260     payment = BTCPaymentI(_payment);
261   }
262 
263   modifier onlyPayment() {
264     require(msg.sender == address(payment));
265     _;
266   }
267 
268   event MintByBTC(SaleType _saleType, address indexed _beneficiary, uint256 _tokens);
269 
270   /**
271    * @dev paymentFallBack() is called in BTCPayment.addPayment().
272    * Presale or Mainsale contract should mint token to beneficiary,
273    * and apply corresponding ether amount to max ether cap.
274    * @param _beneficiary ethereum address who receives tokens
275    * @param _tokens amount of FXT to mint
276    */
277   function paymentFallBack(address _beneficiary, uint256 _tokens) external onlyPayment();
278 }
279 
280 
281 
282 
283 
284 
285 /**
286  * @title Sudo
287  * @dev Some functions should be restricted so as not to be available in any situation.
288  * `onlySudoEnabled` modifier controlls it.
289  */
290 contract Sudo is Ownable {
291   bool public sudoEnabled;
292 
293   modifier onlySudoEnabled() {
294     require(sudoEnabled);
295     _;
296   }
297 
298   event SudoEnabled(bool _sudoEnabled);
299 
300   function Sudo(bool _sudoEnabled) public {
301     sudoEnabled = _sudoEnabled;
302   }
303 
304   function enableSudo(bool _sudoEnabled) public onlyOwner {
305     sudoEnabled = _sudoEnabled;
306     SudoEnabled(_sudoEnabled);
307   }
308 }
309 
310 
311 
312 
313 
314 
315 
316 
317 
318 
319 /**
320  * @title ERC20 interface
321  * @dev see https://github.com/ethereum/EIPs/issues/20
322  */
323 contract ERC20 is ERC20Basic {
324   function allowance(address owner, address spender) public view returns (uint256);
325   function transferFrom(address from, address to, uint256 value) public returns (bool);
326   function approve(address spender, uint256 value) public returns (bool);
327   event Approval(address indexed owner, address indexed spender, uint256 value);
328 }
329 
330 
331 contract FXTI is ERC20 {
332   bool public sudoEnabled = true;
333 
334   function transfer(address _to, uint256 _amount) public returns (bool success);
335 
336   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
337 
338   function generateTokens(address _owner, uint _amount) public returns (bool);
339 
340   function destroyTokens(address _owner, uint _amount) public returns (bool);
341 
342   function blockAddress(address _addr) public;
343 
344   function unblockAddress(address _addr) public;
345 
346   function enableSudo(bool _sudoEnabled) public;
347 
348   function enableTransfers(bool _transfersEnabled) public;
349 
350   // byList functions
351 
352   function generateTokensByList(address[] _owners, uint[] _amounts) public returns (bool);
353 }
354 
355 
356 
357 
358 
359 /**
360  * @title KYCInterface
361  */
362 contract KYCI is Ownable {
363   function setAdmin(address _addr, bool _value) public returns (bool);
364   function isRegistered(address _addr, bool _isPresale) public returns (bool);
365   function register(address _addr, bool _isPresale) public;
366   function registerByList(address[] _addrs, bool _isPresale) public;
367   function unregister(address _addr, bool _isPresale)public;
368   function unregisterByList(address[] _addrs, bool _isPresale) public;
369 }
370 
371 
372 /**
373  * @dev This base contract is inherited by FXTPresale and FXTMainsale
374  * and have related contracts address and ether funded in the sale as state.
375  * Main purpose of this base contract is to provide the interface to control
376  * generating / burning token and increase / decrease ether ether funded in the sale.
377  * Those functions are only called in case of emergency situation such as
378  * erroneous action handling Bitcoin payment.
379  */
380 contract SaleBase is Sudo, Pausable, PaymentFallbackReceiver {
381   using SafeMath for uint256;
382 
383   // related contracts
384   FXTI public token;
385   KYCI public kyc;
386   RefundVault public vault;
387 
388   // fuzex account to hold ownership of contracts after sale finalized
389   address public fuzexAccount;
390 
391   // common sale parameters
392   mapping (address => uint256) public beneficiaryFunded;
393   uint256 public weiRaised;
394 
395   bool public isFinalized; // whether sale is finalized
396 
397   /**
398    * @dev After sale finalized, token and other contract ownership is transferred to
399    * another contract or account. So this modifier doesn't effect contract logic, just
400    * make sure of it.
401    */
402   modifier onlyNotFinalized() {
403     require(!isFinalized);
404     _;
405   }
406 
407   function SaleBase(
408     address _token,
409     address _kyc,
410     address _vault,
411     address _payment,
412     address _fuzexAccount)
413     Sudo(false) // sudoEnabled
414     PaymentFallbackReceiver(_payment)
415     public
416   {
417     require(_token != address(0)
418      && _kyc != address(0)
419      && _vault != address(0)
420      && _fuzexAccount != address(0));
421 
422     token = FXTI(_token);
423     kyc = KYCI(_kyc);
424     vault = RefundVault(_vault);
425     fuzexAccount = _fuzexAccount;
426   }
427 
428   /**
429    * @dev Below 4 functions are only called in case of emergency and certain situation.
430    * e.g. Wrong parameters for BTCPayment.addPayment function so that token should be burned and
431    * wei-raised should be modified.
432    */
433   function increaseWeiRaised(uint256 _amount) public onlyOwner onlyNotFinalized onlySudoEnabled {
434     weiRaised = weiRaised.add(_amount);
435   }
436 
437   function decreaseWeiRaised(uint256 _amount) public onlyOwner onlyNotFinalized onlySudoEnabled {
438     weiRaised = weiRaised.sub(_amount);
439   }
440 
441   function generateTokens(address _owner, uint _amount) public onlyOwner onlyNotFinalized onlySudoEnabled returns (bool) {
442     return token.generateTokens(_owner, _amount);
443   }
444 
445   function destroyTokens(address _owner, uint _amount) public onlyOwner onlyNotFinalized onlySudoEnabled returns (bool) {
446     return token.destroyTokens(_owner, _amount);
447   }
448 
449   /**
450    * @dev Prevent token holder from transfer.
451    */
452   function blockAddress(address _addr) public onlyOwner onlyNotFinalized onlySudoEnabled {
453     token.blockAddress(_addr);
454   }
455 
456   function unblockAddress(address _addr) public onlyOwner onlyNotFinalized onlySudoEnabled {
457     token.unblockAddress(_addr);
458   }
459 
460   /**
461    * @dev Transfer ownership of other contract whoes owner is `this` to other address.
462    */
463   function changeOwnership(address _target, address _newOwner) public onlyOwner {
464     Ownable(_target).transferOwnership(_newOwner);
465   }
466 
467   /**
468    * @dev Transfer ownership of MiniMeToken whoes controller is `this` to other address.
469    */
470   function changeController(address _target, address _newOwner) public onlyOwner {
471     Controlled(_target).changeController(_newOwner);
472   }
473 
474   function setFinalize() internal onlyOwner {
475     require(!isFinalized);
476     isFinalized = true;
477   }
478 }
479 
480 
481 
482 /**
483  * @title FXTPresale
484  * @dev Private-sale is finished before this contract is deployed.
485  *
486  */
487 contract FXTPresale is SaleBase {
488   uint256 public baseRate = 12000;    // 1 ETH = 12000 FXT
489   uint256 public PRE_BONUS = 25;     // presale bonus 25%
490   uint256 public BONUS_COEFF = 100;
491 
492   // private-sale parameters
493   uint256 public privateEtherFunded;
494   uint256 public privateMaxEtherCap;
495 
496   // presale parameters
497   uint256 public presaleMaxEtherCap;
498   uint256 public presaleMinPurchase;
499 
500   uint256 public maxEtherCap;   // max ether cap for both private-sale & presale
501 
502   uint64 public startTime;     // when presale starts
503   uint64 public endTime;       // when presale ends
504 
505   event PresaleTokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 toFund, uint256 tokens);
506 
507   /**
508    * @dev only presale registered address can participate presale.
509    * private-sale doesn't require to check address because owner deals with it.
510    */
511   modifier onlyRegistered(address _addr) {
512     require(kyc.isRegistered(_addr, true));
513     _;
514   }
515 
516   function FXTPresale(
517     address _token,
518     address _kyc,
519     address _vault,
520     address _payment,
521     address _fuzexAccount,
522     uint64 _startTime,
523     uint64 _endTime,
524     uint256 _privateEtherFunded,
525     uint256 _privateMaxEtherCap,
526     uint256 _presaleMaxEtherCap,
527     uint256 _presaleMinPurchase)
528     SaleBase(_token, _kyc, _vault, _payment, _fuzexAccount)
529     public
530   {
531     require(now < _startTime && _startTime < _endTime);
532 
533     require(_privateEtherFunded >= 0);
534     require(_privateMaxEtherCap > 0);
535     require(_presaleMaxEtherCap > 0);
536     require(_presaleMinPurchase > 0);
537 
538     require(_presaleMinPurchase < _presaleMaxEtherCap);
539 
540     startTime = _startTime;
541     endTime = _endTime;
542 
543     privateEtherFunded = _privateEtherFunded;
544     privateMaxEtherCap = _privateMaxEtherCap;
545 
546     presaleMaxEtherCap = _presaleMaxEtherCap;
547     presaleMinPurchase = _presaleMinPurchase;
548 
549     maxEtherCap = privateMaxEtherCap.add(presaleMaxEtherCap);
550     weiRaised = _privateEtherFunded; // ether funded during private-sale
551 
552     require(weiRaised <= maxEtherCap);
553   }
554 
555   function () external payable {
556     buyPresale(msg.sender);
557   }
558 
559   /**
560    * @dev paymentFallBack() assumes that paid BTC doesn't exceed the max ether cap.
561    * BTC / ETH price (or rate) is determined using reliable outer resources.
562    * @param _beneficiary ethereum address who receives tokens
563    * @param _tokens amount of FXT to mint
564    */
565   function paymentFallBack(address _beneficiary, uint256 _tokens)
566     external
567     onlyPayment
568   {
569     // only check time and parameters
570     require(startTime <= now && now <= endTime);
571     require(_beneficiary != address(0));
572     require(_tokens > 0);
573 
574     uint256 rate = getRate();
575     uint256 weiAmount = _tokens.div(rate);
576 
577     require(weiAmount >= presaleMinPurchase);
578 
579     // funded ether should not exceed max ether cap.
580     require(weiRaised.add(weiAmount) <= maxEtherCap);
581 
582     weiRaised = weiRaised.add(weiAmount);
583     beneficiaryFunded[_beneficiary] = beneficiaryFunded[_beneficiary].add(weiAmount);
584 
585     token.generateTokens(_beneficiary, _tokens);
586     MintByBTC(SaleType.pre, _beneficiary, _tokens);
587   }
588 
589   function buyPresale(address _beneficiary)
590     public
591     payable
592     onlyRegistered(_beneficiary)
593     whenNotPaused
594   {
595     // check validity
596     require(_beneficiary != address(0));
597     require(msg.value >= presaleMinPurchase);
598     require(validPurchase());
599 
600     uint256 toFund;
601     uint256 tokens;
602 
603     (toFund, tokens) = buy(_beneficiary);
604 
605     PresaleTokenPurchase(msg.sender, _beneficiary, toFund, tokens);
606   }
607 
608   function buy(address _beneficiary)
609     internal
610     returns (uint256 toFund, uint256 tokens)
611   {
612     // calculate eth amount
613     uint256 weiAmount = msg.value;
614     uint256 totalAmount = weiRaised.add(weiAmount);
615 
616     if (totalAmount > maxEtherCap) {
617       toFund = maxEtherCap.sub(weiRaised);
618     } else {
619       toFund = weiAmount;
620     }
621 
622     require(toFund > 0);
623     require(weiAmount >= toFund);
624 
625     uint256 rate = getRate();
626     tokens = toFund.mul(rate);
627     uint256 toReturn = weiAmount.sub(toFund);
628 
629     weiRaised = weiRaised.add(toFund);
630     beneficiaryFunded[_beneficiary] = beneficiaryFunded[_beneficiary].add(toFund);
631 
632     token.generateTokens(_beneficiary, tokens);
633 
634     if (toReturn > 0) {
635       msg.sender.transfer(toReturn);
636     }
637 
638     forwardFunds(toFund);
639   }
640 
641   function validPurchase() internal view returns (bool) {
642     bool nonZeroPurchase = msg.value != 0;
643     bool validTime = now >= startTime && now <= endTime;
644     return nonZeroPurchase && !maxReached() && validTime;
645   }
646 
647   /**
648    * @dev get current rate
649    */
650   function getRate() public view returns (uint256) {
651     return calcRate(PRE_BONUS);
652   }
653 
654   /**
655    * @dev Calculate rate wrt _bonus. if _bonus is 15, this function
656    * returns baseRate * 1.15.
657    * rate = 12000 * (25 + 100) / 100 for 25% bonus
658    */
659   function calcRate(uint256 _bonus) internal view returns (uint256) {
660     return _bonus.add(BONUS_COEFF).mul(baseRate).div(BONUS_COEFF);
661   }
662 
663   /**
664    * @dev Checks whether max ether cap is reached for presale
665    * @return true if max ether cap is reaced
666    */
667   function maxReached() public view  returns (bool) {
668     return weiRaised == maxEtherCap;
669   }
670 
671   function forwardFunds(uint256 _toFund) internal {
672     vault.deposit.value(_toFund)(msg.sender);
673   }
674 
675   function finalizePresale(address _mainsale) public onlyOwner {
676       require(!isFinalized);
677       require(maxReached() || now > endTime);
678 
679       PresaleFallbackReceiver mainsale = PresaleFallbackReceiver(_mainsale);
680 
681       require(mainsale.presaleFallBack(weiRaised));
682       require(payment.presaleFallBack(weiRaised));
683 
684       vault.close();
685 
686       changeController(address(token), _mainsale);
687       changeOwnership(address(vault), fuzexAccount);
688 
689       enableSudo(false);
690       setFinalize();
691   }
692 }