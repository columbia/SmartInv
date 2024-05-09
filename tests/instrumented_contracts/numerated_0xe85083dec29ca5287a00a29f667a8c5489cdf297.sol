1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 /**
214  * @title SimpleToken
215  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
216  * Note they can later distribute these tokens as they wish using `transfer` and other
217  * `StandardToken` functions.
218  */
219 contract OpportyToken is StandardToken {
220 
221   string public constant name = "OpportyToken";
222   string public constant symbol = "OPP";
223   uint8 public constant decimals = 18;
224 
225   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
226 
227   /**
228    * @dev Contructor that gives msg.sender all of existing tokens.
229    */
230   function OpportyToken() public {
231     totalSupply_ = INITIAL_SUPPLY;
232     balances[msg.sender] = INITIAL_SUPPLY;
233     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
234   }
235 
236 }
237 
238 /**
239  * @title Ownable
240  * @dev The Ownable contract has an owner address, and provides basic authorization control
241  * functions, this simplifies the implementation of "user permissions".
242  */
243 contract Ownable {
244   address public owner;
245 
246 
247   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249 
250   /**
251    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252    * account.
253    */
254   function Ownable() public {
255     owner = msg.sender;
256   }
257 
258   /**
259    * @dev Throws if called by any account other than the owner.
260    */
261   modifier onlyOwner() {
262     require(msg.sender == owner);
263     _;
264   }
265 
266   /**
267    * @dev Allows the current owner to transfer control of the contract to a newOwner.
268    * @param newOwner The address to transfer ownership to.
269    */
270   function transferOwnership(address newOwner) public onlyOwner {
271     require(newOwner != address(0));
272     OwnershipTransferred(owner, newOwner);
273     owner = newOwner;
274   }
275 
276 }
277 
278 contract OpportyWhiteListHold is Ownable {
279   using SafeMath for uint256;
280   // Addresses and contracts
281   OpportyToken public OppToken;
282 
283   struct Holder {
284     bool isActive;
285     uint tokens;
286     uint8 holdPeriod;
287     uint holdPeriodTimestamp;
288     bool withdrawed;
289   }
290 
291   mapping(address => Holder) public holderList;
292   mapping(uint => address) private holderIndexes;
293 
294   mapping (uint => address) private assetOwners;
295   mapping (address => uint) private assetOwnersIndex;
296   uint public assetOwnersIndexes;
297 
298   uint private holderIndex;
299 
300   event TokensTransfered(address contributor , uint amount);
301   event Hold(address sender, address contributor, uint amount, uint8 holdPeriod);
302   event ChangeHold(address sender, address contributor, uint amount, uint8 holdPeriod);
303   event TokenChanged(address newAddress);
304   event ManualPriceChange(uint beforePrice, uint afterPrice);
305 
306   modifier onlyAssetsOwners() {
307     require(assetOwnersIndex[msg.sender] > 0 || msg.sender == owner);
308     _;
309   }
310 
311   function getBalanceContract() view internal returns (uint) {
312     return OppToken.balanceOf(this);
313   }
314 
315   function setToken(address newToken) public onlyOwner {
316     OppToken = OpportyToken(newToken);
317     TokenChanged(newToken);
318   }
319 
320   function changeHold(address holder, uint tokens, uint8 period, uint holdTimestamp, bool withdrawed ) public onlyAssetsOwners {
321     if (holderList[holder].isActive == true) {
322       holderList[holder].tokens = tokens;
323       holderList[holder].holdPeriod = period;
324       holderList[holder].holdPeriodTimestamp = holdTimestamp;
325       holderList[holder].withdrawed = withdrawed;
326       ChangeHold(msg.sender, holder, tokens, period);
327     }
328   }
329 
330   function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external {
331     if (holderList[holder].isActive == false) {
332       holderList[holder].isActive = true;
333       holderList[holder].tokens = tokens;
334       holderList[holder].holdPeriod = timed;
335       holderList[holder].holdPeriodTimestamp = timest;
336       holderIndexes[holderIndex] = holder;
337       holderIndex++;
338     } else {
339       holderList[holder].tokens += tokens;
340       holderList[holder].holdPeriod = timed;
341       holderList[holder].holdPeriodTimestamp = timest;
342     }
343     Hold(msg.sender, holder, tokens, timed);
344   }
345 
346   function getBalance() public constant returns (uint) {
347     return OppToken.balanceOf(this);
348   }
349 
350   function returnTokens(uint nTokens) public onlyOwner returns (bool) {
351     require(nTokens <= getBalance());
352     OppToken.transfer(msg.sender, nTokens);
353     TokensTransfered(msg.sender, nTokens);
354     return true;
355   }
356 
357   function unlockTokens() public returns (bool) {
358     require(holderList[msg.sender].isActive);
359     require(!holderList[msg.sender].withdrawed);
360     require(now >= holderList[msg.sender].holdPeriodTimestamp);
361 
362     OppToken.transfer(msg.sender, holderList[msg.sender].tokens);
363     holderList[msg.sender].withdrawed = true;
364     TokensTransfered(msg.sender, holderList[msg.sender].tokens);
365     return true;
366   }
367 
368   function addAssetsOwner(address _owner) public onlyOwner {
369     assetOwnersIndexes++;
370     assetOwners[assetOwnersIndexes] = _owner;
371     assetOwnersIndex[_owner] = assetOwnersIndexes;
372   }
373   function removeAssetsOwner(address _owner) public onlyOwner {
374     uint index = assetOwnersIndex[_owner];
375     delete assetOwnersIndex[_owner];
376     delete assetOwners[index];
377     assetOwnersIndexes--;
378   }
379   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
380     return assetOwners[_index];
381   }
382 }
383 
384 /**
385  * @title Pausable
386  * @dev Base contract which allows children to implement an emergency stop mechanism.
387  */
388 contract Pausable is Ownable {
389   event Pause();
390   event Unpause();
391 
392   bool public paused = false;
393 
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is not paused.
397    */
398   modifier whenNotPaused() {
399     require(!paused);
400     _;
401   }
402 
403   /**
404    * @dev Modifier to make a function callable only when the contract is paused.
405    */
406   modifier whenPaused() {
407     require(paused);
408     _;
409   }
410 
411   /**
412    * @dev called by the owner to pause, triggers stopped state
413    */
414   function pause() onlyOwner whenNotPaused public {
415     paused = true;
416     Pause();
417   }
418 
419   /**
420    * @dev called by the owner to unpause, returns to normal state
421    */
422   function unpause() onlyOwner whenPaused public {
423     paused = false;
424     Unpause();
425   }
426 }
427 
428 contract OpportyWhiteList is Pausable {
429   using SafeMath for uint256;
430 
431   OpportyToken public token;
432 
433   OpportyWhiteListHold public holdContract;
434 
435   enum SaleState  { NEW, SALE, ENDED }
436   SaleState public state;
437 
438   uint public endDate;
439   uint public endSaleDate;
440   uint public minimalContribution;
441 
442   // address where funds are collected
443   address private wallet;
444 
445   address private preSaleOld;
446 
447   // total ETH collected
448   uint public ethRaised;
449 
450   uint private price;
451 
452   uint public tokenRaised;
453   bool public tokensTransferredToHold;
454 
455   /* Events */
456   event SaleStarted(uint blockNumber);
457   event SaleEnded(uint blockNumber);
458   event FundTransfered(address contrib, uint amount);
459   event WithdrawedEthToWallet(uint amount);
460   event ManualChangeEndDate(uint beforeDate, uint afterDate);
461   event TokensTransferedToHold(address hold, uint amount);
462   event AddedToWhiteList(address inv, uint amount, uint8 holdPeriod, uint8 bonus);
463   event AddedToHolder(address sender, uint tokenAmount, uint8 holdPeriod, uint holdTimestamp);
464   event ManualPriceChange(uint beforePrice, uint afterPrice);
465   event ChangeMinAmount(uint oldMinAmount, uint minAmount);
466 
467   event TokenChanged(address newAddress);
468 
469   struct WhitelistContributor {
470     bool isActive;
471     uint invAmount;
472     uint8 holdPeriod;
473     uint holdTimestamp;
474     uint8 bonus;
475     bool payed;
476   }
477 
478   mapping(address => WhitelistContributor) public whiteList;
479   mapping(uint => address) private whitelistIndexes;
480   uint private whitelistIndex;
481 
482   mapping (uint => address) private assetOwners;
483   mapping (address => uint) private assetOwnersIndex;
484   uint public assetOwnersIndexes;
485 
486   modifier onlyAssetsOwners() {
487     require(assetOwnersIndex[msg.sender] > 0);
488     _;
489   }
490 
491   /* constructor */
492   function OpportyWhiteList(
493     address walletAddress,
494     uint end,
495     uint endSale,
496     address holdCont) public
497   {
498     state = SaleState.NEW;
499     endDate = end;
500     endSaleDate = endSale;
501     price = 0.0002 * 1 ether;
502     wallet = walletAddress;
503     minimalContribution = 0.3 * 1 ether;
504 
505     holdContract = OpportyWhiteListHold(holdCont);
506     addAssetsOwner(msg.sender);
507   }
508 
509   function setToken(address newToken) public onlyOwner {
510     token = OpportyToken(newToken);
511     TokenChanged(token);
512   }
513 
514   function startPresale() public onlyOwner {
515     state = SaleState.SALE;
516     SaleStarted(block.number);
517   }
518 
519   function endPresale() public onlyOwner {
520     state = SaleState.ENDED;
521     SaleEnded(block.number);
522   }
523 
524   function addToWhitelist(address inv, uint amount, uint8 holdPeriod, uint8 bonus) public onlyAssetsOwners {
525     require(state == SaleState.NEW || state == SaleState.SALE);
526     require(holdPeriod >= 1);
527     require(amount >= minimalContribution);
528 
529     if (whiteList[inv].isActive == false) {
530       whiteList[inv].isActive = true;
531       whiteList[inv].payed = false;
532       whitelistIndexes[whitelistIndex] = inv;
533       whitelistIndex++;
534     }
535 
536     whiteList[inv].invAmount = amount;
537     whiteList[inv].holdPeriod = holdPeriod;
538     whiteList[inv].bonus = bonus;
539 
540     whiteList[inv].holdTimestamp = endSaleDate.add(whiteList[inv].holdPeriod * 30 days); 
541     
542     AddedToWhiteList(inv, whiteList[inv].invAmount, whiteList[inv].holdPeriod,  whiteList[inv].bonus);
543   }
544 
545   function() whenNotPaused public payable {
546     require(state == SaleState.SALE);
547     require(msg.value >= minimalContribution);
548     require(whiteList[msg.sender].isActive);
549 
550     if (now > endDate) {
551       state = SaleState.ENDED;
552       msg.sender.transfer(msg.value);
553       return;
554     }
555 
556     WhitelistContributor memory contrib = whiteList[msg.sender];
557     require(contrib.invAmount <= msg.value || contrib.payed);
558 
559     if (whiteList[msg.sender].payed == false) {
560       whiteList[msg.sender].payed = true;
561     }
562 
563     ethRaised += msg.value;
564 
565     uint tokenAmount = msg.value.div(price);
566     tokenAmount += tokenAmount.mul(contrib.bonus).div(100);
567     tokenAmount *= 10 ** 18;
568 
569     tokenRaised += tokenAmount;
570 
571     holdContract.addHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
572     AddedToHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
573     FundTransfered(msg.sender, msg.value);
574 
575     // forward the funds to the wallet
576     forwardFunds();
577   }
578 
579   /**
580      * send ether to the fund collection wallet
581      * override to create custom fund forwarding mechanisms
582      */
583   function forwardFunds() internal {
584     wallet.transfer(msg.value);
585   }
586 
587 
588   function getBalanceContract() view internal returns (uint) {
589     return token.balanceOf(this);
590   }
591 
592   function sendTokensToHold() public onlyOwner {
593     require(state == SaleState.ENDED);
594 
595     require(getBalanceContract() >= tokenRaised);
596 
597     if (token.transfer(holdContract, tokenRaised)) {
598       tokensTransferredToHold = true;
599       TokensTransferedToHold(holdContract, tokenRaised);
600     }
601   }
602 
603   function getTokensBack() public onlyOwner {
604     require(state == SaleState.ENDED);
605     require(tokensTransferredToHold == true);
606     uint balance;
607     balance = getBalanceContract() ;
608     token.transfer(msg.sender, balance);
609   }
610 
611   function withdrawEth() public {
612     require(this.balance != 0);
613     require(state == SaleState.ENDED);
614     require(msg.sender == wallet);
615     require(tokensTransferredToHold == true);
616     uint bal = this.balance;
617     wallet.transfer(bal);
618     WithdrawedEthToWallet(bal);
619   }
620 
621   function setPrice(uint newPrice) public onlyOwner {
622     uint oldPrice = price;
623     price = newPrice;
624     ManualPriceChange(oldPrice, newPrice);
625   }
626 
627   function setEndSaleDate(uint date) public onlyOwner {
628     uint oldEndDate = endSaleDate;
629     endSaleDate = date;
630     ManualChangeEndDate(oldEndDate, date);
631   }
632 
633   function setEndDate(uint date) public onlyOwner {
634     uint oldEndDate = endDate;
635     endDate = date;
636     ManualChangeEndDate(oldEndDate, date);
637   }
638 
639   function setMinimalContribution(uint minimumAmount) public onlyOwner {
640     uint oldMinAmount = minimalContribution;
641     minimalContribution = minimumAmount;
642     ChangeMinAmount(oldMinAmount, minimalContribution);
643   }
644 
645   function getTokenBalance() public constant returns (uint) {
646     return token.balanceOf(this);
647   }
648 
649   function getEthRaised() constant external returns (uint) {
650     return ethRaised;
651   }
652 
653   function addAssetsOwner(address _owner) public onlyOwner {
654     assetOwnersIndexes++;
655     assetOwners[assetOwnersIndexes] = _owner;
656     assetOwnersIndex[_owner] = assetOwnersIndexes;
657   }
658   function removeAssetsOwner(address _owner) public onlyOwner {
659     uint index = assetOwnersIndex[_owner];
660     delete assetOwnersIndex[_owner];
661     delete assetOwners[index];
662     assetOwnersIndexes--;
663   }
664   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
665     return assetOwners[_index];
666   }
667 }