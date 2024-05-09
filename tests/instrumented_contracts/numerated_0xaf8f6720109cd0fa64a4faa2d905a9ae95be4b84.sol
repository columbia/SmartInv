1 pragma solidity ^0.4.15;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal constant returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 // File: zeppelin-solidity/contracts/token/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 // File: zeppelin-solidity/contracts/token/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public constant returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 // File: zeppelin-solidity/contracts/token/StandardToken.sol
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     uint256 _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval (address _spender, uint _addedValue)
211     returns (bool success) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval (address _spender, uint _subtractedValue)
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 // File: contracts/BurnableToken.sol
232 
233 /**
234 * @title Customized Burnable Token
235 * @dev Token that can be irreversibly burned (destroyed).
236 */
237 contract BurnableToken is StandardToken, Ownable {
238 
239     event Burn(address indexed burner, uint256 amount);
240 
241     /**
242     * @dev Anybody can burn a specific amount of their tokens.
243     * @param _amount The amount of token to be burned.
244     */
245     function burn(uint256 _amount) public {
246         require(_amount > 0);
247         require(_amount <= balances[msg.sender]);
248         // no need to require _amount <= totalSupply, since that would imply the
249         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
250 
251         address burner = msg.sender;
252         balances[burner] = balances[burner].sub(_amount);
253         totalSupply = totalSupply.sub(_amount);
254         Transfer(burner, address(0), _amount);
255         Burn(burner, _amount);
256     }
257 
258     /**
259     * @dev Owner can burn a specific amount of tokens of other token holders.
260     * @param _from The address of token holder whose tokens to be burned.
261     * @param _amount The amount of token to be burned.
262     */
263     function burnFrom(address _from, uint256 _amount) onlyOwner public {
264         require(_from != address(0));
265         require(_amount > 0);
266         require(_amount <= balances[_from]);
267         // no need to require _amount <= totalSupply, since that would imply the
268         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
269 
270         balances[_from] = balances[_from].sub(_amount);
271         totalSupply = totalSupply.sub(_amount);
272         Transfer(_from, address(0), _amount);
273         Burn(_from, _amount);
274     }
275 
276 }
277 
278 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
279 
280 /**
281  * @title Pausable
282  * @dev Base contract which allows children to implement an emergency stop mechanism.
283  */
284 contract Pausable is Ownable {
285   event Pause();
286   event Unpause();
287 
288   bool public paused = false;
289 
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is not paused.
293    */
294   modifier whenNotPaused() {
295     require(!paused);
296     _;
297   }
298 
299   /**
300    * @dev Modifier to make a function callable only when the contract is paused.
301    */
302   modifier whenPaused() {
303     require(paused);
304     _;
305   }
306 
307   /**
308    * @dev called by the owner to pause, triggers stopped state
309    */
310   function pause() onlyOwner whenNotPaused public {
311     paused = true;
312     Pause();
313   }
314 
315   /**
316    * @dev called by the owner to unpause, returns to normal state
317    */
318   function unpause() onlyOwner whenPaused public {
319     paused = false;
320     Unpause();
321   }
322 }
323 
324 // File: contracts/GiftToken.sol
325 
326 contract GiftToken is BurnableToken, Pausable {
327     string constant public name = "Giftcoin";
328     string constant public symbol = "GIFT";
329     uint8 constant public decimals = 18;
330 
331     uint256 constant public INITIAL_TOTAL_SUPPLY = 2e7 * (uint256(10) ** decimals);
332 
333     address private addressIco;
334 
335     modifier onlyIco() {
336         require(msg.sender == addressIco);
337         _;
338     }
339 
340     /**
341     * @dev Create GiftToken contract and set pause
342     * @param _ico The address of ICO contract.
343     */
344     function GiftToken (address _ico) {
345         require(_ico != address(0));
346 
347         addressIco = _ico;
348 
349         totalSupply = totalSupply.add(INITIAL_TOTAL_SUPPLY);
350         balances[_ico] = balances[_ico].add(INITIAL_TOTAL_SUPPLY);
351         Transfer(address(0), _ico, INITIAL_TOTAL_SUPPLY);
352 
353         pause();
354     }
355 
356     /**
357     * @dev Transfer token for a specified address with pause feature for owner.
358     * @dev Only applies when the transfer is allowed by the owner.
359     * @param _to The address to transfer to.
360     * @param _value The amount to be transferred.
361     */
362     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
363         super.transfer(_to, _value);
364     }
365 
366     /**
367     * @dev Transfer tokens from one address to another with pause feature for owner.
368     * @dev Only applies when the transfer is allowed by the owner.
369     * @param _from address The address which you want to send tokens from
370     * @param _to address The address which you want to transfer to
371     * @param _value uint256 the amount of tokens to be transferred
372     */
373     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
374         super.transferFrom(_from, _to, _value);
375     }
376 
377     /**
378     * @dev Transfer tokens from ICO address to another address.
379     * @param _to The address to transfer to.
380     * @param _value The amount to be transferred.
381     */
382     function transferFromIco(address _to, uint256 _value) onlyIco public returns (bool) {
383         super.transfer(_to, _value);
384     }
385 }
386 
387 // File: contracts/Whitelist.sol
388 
389 /**
390  * @title Whitelist contract
391  * @dev Whitelist for wallets, with additional data for every wallet.
392 */
393 contract Whitelist is Ownable {
394     struct WalletInfo {
395         string data;
396         bool whitelisted;
397     }
398 
399     address private addressApi;
400 
401     mapping(address => WalletInfo) public whitelist;
402 
403     uint256 public whitelistLength = 0;
404 
405     modifier onlyPrivilegeAddresses {
406         require(msg.sender == addressApi || msg.sender == owner);
407         _;
408     }
409 
410     /**
411     * @dev Set backend Api address.
412     * @dev Accept request from owner only.
413     * @param _api The address of backend API.
414     */
415     function setApiAddress(address _api) onlyOwner public {
416         require(_api != address(0));
417 
418         addressApi = _api;
419     }
420 
421     /**
422     * @dev Add wallet to whitelist.
423     * @dev Accept request from privilege adresses only.
424     * @param _wallet The address of wallet to add.
425     * @param _data The checksum of additional wallet data.
426     */  
427     function addWallet(address _wallet, string _data) onlyPrivilegeAddresses public {
428         require(_wallet != address(0));
429         require(!isWhitelisted(_wallet));
430         whitelist[_wallet].data = _data;
431         whitelist[_wallet].whitelisted = true;
432         whitelistLength++;
433     }
434 
435     /**
436     * @dev Update additional data for whitelisted wallet.
437     * @dev Accept request from privilege adresses only.
438     * @param _wallet The address of whitelisted wallet to update.
439     * @param _data The checksum of new additional wallet data.
440     */      
441     function updateWallet(address _wallet, string _data) onlyPrivilegeAddresses public {
442         require(_wallet != address(0));
443         require(isWhitelisted(_wallet));
444         whitelist[_wallet].data = _data;
445     }
446 
447     /**
448     * @dev Remove wallet from whitelist.
449     * @dev Accept request from privilege adresses only.
450     * @param _wallet The address of whitelisted wallet to remove.
451     */  
452     function removeWallet(address _wallet) onlyPrivilegeAddresses public {
453         require(_wallet != address(0));
454         require(isWhitelisted(_wallet));
455         delete whitelist[_wallet];
456         whitelistLength--;
457     }
458 
459     /**
460     * @dev Check the specified wallet whether it is in the whitelist.
461     * @param _wallet The address of wallet to check.
462     */ 
463     function isWhitelisted(address _wallet) constant public returns (bool) {
464         return whitelist[_wallet].whitelisted;
465     }
466 
467     /**
468     * @dev Get the checksum of additional data for the specified whitelisted wallet.
469     * @param _wallet The address of wallet to get.
470     */ 
471     function walletData(address _wallet) constant public returns (string) {
472         return whitelist[_wallet].data;
473     }
474 
475 }
476 
477 // File: contracts/Whitelistable.sol
478 
479 contract Whitelistable {
480     Whitelist public whitelist;
481 
482     modifier whenWhitelisted(address _wallet) {
483         require(whitelist.isWhitelisted(_wallet));
484         _;
485     }
486 
487     function Whitelistable () public {
488         whitelist = new Whitelist();
489 
490         whitelist.transferOwnership(msg.sender);
491     }
492 }
493 
494 // File: contracts/GiftCrowdsale.sol
495 
496 contract GiftCrowdsale is Pausable, Whitelistable {
497     using SafeMath for uint256;
498 
499     uint256 public startTimestamp = 0;
500 
501     uint256 public endTimestamp = 0;
502 
503     uint256 public exchangeRate = 0;
504 
505     uint256 public tokensSold = 0;
506 
507     uint256 constant public minimumInvestment = 25e16; // 0.25 ETH
508 
509     uint256 public minCap = 0;
510 
511     uint256 public endFirstPeriodTimestamp = 0;
512 
513     uint256 public endSecondPeriodTimestamp = 0;
514 
515     uint256 public endThirdPeriodTimestamp = 0;
516 
517     GiftToken public token = new GiftToken(this);
518 
519     mapping(address => uint256) public investments;
520 
521     modifier whenSaleIsOpen () {
522         require(now >= startTimestamp && now < endTimestamp);
523         _;
524     }
525 
526     modifier whenSaleHasEnded () {
527         require(now >= endTimestamp);
528         _;
529     }
530 
531     /**
532     * @dev Constructor for GiftCrowdsale contract.
533     * @dev Set first owner who can manage whitelist.
534     * @param _startTimestamp uint256 The start time ico.
535     * @param _endTimestamp uint256 The end time ico.
536     * @param _exchangeRate uint256 The price of the Gift token.
537     * @param _minCap The minimum amount of tokens sold required for the ICO to be considered successful.
538     */
539     function GiftCrowdsale (
540         uint256 _startTimestamp,
541         uint256 _endTimestamp,
542         uint256 _exchangeRate,
543         uint256 _minCap
544     ) public
545     {
546         require(_startTimestamp >= now && _endTimestamp > _startTimestamp);
547         require(_exchangeRate > 0);
548 
549         startTimestamp = _startTimestamp;
550         endTimestamp = _endTimestamp;
551 
552         exchangeRate = _exchangeRate;
553 
554         endFirstPeriodTimestamp = _startTimestamp.add(1 days);
555 
556         endSecondPeriodTimestamp = _startTimestamp.add(1 weeks);
557 
558         endThirdPeriodTimestamp = _startTimestamp.add(2 weeks);
559 
560         minCap = _minCap;
561     }
562 
563     function discount() constant public returns (uint256) {
564         if (now > endThirdPeriodTimestamp)
565             return 0;
566         if (now > endSecondPeriodTimestamp)
567             return 15;
568         if (now > endFirstPeriodTimestamp)
569             return 25;
570         return 35;
571     }
572 
573     function bonus() constant public returns (uint256) {
574         if (now > endSecondPeriodTimestamp)
575             return 0;
576         if (now > endFirstPeriodTimestamp)
577             return 3;
578         return 5;
579     }
580 
581     /**
582     * @dev Function for sell tokens.
583     * @dev Sells tokens only for wallets from Whitelist while ICO lasts
584     */
585     function sellTokens () whenSaleIsOpen whenWhitelisted(msg.sender) whenNotPaused public payable {
586         require(msg.value > minimumInvestment);
587         uint256 _bonus = bonus();
588         uint256 _discount = discount();
589         uint256 tokensAmount = (msg.value).mul(exchangeRate).mul(_bonus.add(100)).div((100 - _discount));
590 
591         token.transferFromIco(msg.sender, tokensAmount);
592 
593         tokensSold = tokensSold.add(tokensAmount);
594 
595         addInvestment(msg.sender, msg.value);
596     }
597 
598     /**
599     * @dev Fallback function allowing the contract to receive funds
600     */
601     function () public payable {
602         sellTokens();
603     }
604 
605     /**
606     * @dev Function for funds withdrawal
607     * @dev transfers funds to specified wallet once ICO is ended
608     * @param _wallet address wallet address, to  which funds  will be transferred
609     */
610     function withdrawal (address _wallet) onlyOwner whenSaleHasEnded external {
611         require(_wallet != address(0));
612         _wallet.transfer(this.balance);
613 
614         token.transferOwnership(msg.sender);
615     }
616 
617     /**
618     * @dev Function for manual token assignment (token transfer from ICO to requested wallet)
619     * @param _to address The address which you want transfer to
620     * @param _value uint256 the amount of tokens to be transferred
621     */
622     function assignTokens (address _to, uint256 _value) onlyOwner external {
623         token.transferFromIco(_to, _value);
624     }
625 
626     /**
627     * @dev Add new investment to the ICO investments storage.
628     * @param _from The address of a ICO investor.
629     * @param _value The investment received from a ICO investor.
630     */
631     function addInvestment(address _from, uint256 _value) internal {
632         investments[_from] = investments[_from].add(_value);
633     }
634 
635     /**
636     * @dev Function to return money to one customer, if mincap has not been reached
637     */
638     function refundPayment() whenWhitelisted(msg.sender) whenSaleHasEnded external {
639         require(tokensSold < minCap);
640         require(investments[msg.sender] > 0);
641 
642         token.burnFrom(msg.sender, token.balanceOf(msg.sender));
643 
644         uint256 investment = investments[msg.sender];
645         investments[msg.sender] = 0;
646         (msg.sender).transfer(investment);
647     }
648 
649     /**
650     * @dev Allows the current owner to transfer control of the token contract from ICO to a newOwner.
651     * @param _newOwner The address to transfer ownership to.
652     */
653     function transferTokenOwnership(address _newOwner) onlyOwner public {
654         token.transferOwnership(_newOwner);
655     }
656 
657     function updateIcoEnding(uint256 _endTimestamp) onlyOwner public {
658         endTimestamp = _endTimestamp;
659     }
660 }
661 
662 // File: contracts/GiftFactory.sol
663 
664 contract GiftFactory {
665     GiftCrowdsale public crowdsale;
666 
667     function createCrowdsale (
668         uint256 _startTimestamp,
669         uint256 _endTimestamp,
670         uint256 _exchangeRate,
671         uint256 _minCap
672     ) public
673     {
674         crowdsale = new GiftCrowdsale(
675             _startTimestamp,
676             _endTimestamp,
677             _exchangeRate,
678             _minCap
679         );
680 
681         Whitelist whitelist = crowdsale.whitelist();
682 
683         crowdsale.transferOwnership(msg.sender);
684         whitelist.transferOwnership(msg.sender);
685     }
686 }