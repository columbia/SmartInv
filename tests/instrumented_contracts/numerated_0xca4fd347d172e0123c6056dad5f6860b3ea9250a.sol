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
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyOwner whenNotPaused public {
309     paused = true;
310     Pause();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() onlyOwner whenPaused public {
317     paused = false;
318     Unpause();
319   }
320 }
321 
322 contract OpportyYearHold is Pausable {
323   using SafeMath for uint256;
324   OpportyToken public token;
325 
326   uint public holdPeriod;
327   address public multisig;
328 
329   // start and end timestamps where investments are allowed
330   uint public startDate;
331   uint public endDate;
332   uint public endSaleDate;
333 
334   uint private price;
335 
336   uint public minimalContribution;
337 
338   // total ETH collected
339   uint public ethRaised;
340 
341   enum SaleState { NEW, SALE, ENDED }
342   SaleState public state;
343 
344   mapping (uint => address) private assetOwners;
345   mapping (address => uint) private assetOwnersIndex;
346   uint public assetOwnersIndexes;
347 
348   struct Bonus {
349     uint minAmount;
350     uint maxAmount;
351     uint8 bonus;
352   }
353 
354   Bonus[]  bonuses;
355 
356   struct Holder {
357     bool isActive;
358     uint tokens;
359     uint holdPeriodTimestamp;
360     bool withdrawed;
361   }
362 
363   mapping(address => Holder) public holderList;
364   mapping(uint => address) private holderIndexes;
365   uint private holderIndex;
366 
367 
368   event TokensTransfered(address contributor , uint amount);
369   event Hold(address sender, address contributor, uint amount, uint8 holdPeriod);
370   event ManualChangeStartDate(uint beforeDate, uint afterDate);
371   event ManualChangeEndDate(uint beforeDate, uint afterDate);
372   event ChangeMinAmount(uint oldMinAmount, uint minAmount);
373   event BonusChanged(uint minAmount, uint maxAmount, uint8 newBonus);
374   event HolderAdded(address addr, uint contribution, uint tokens, uint holdPeriodTimestamp);
375   event FundsTransferredToMultisig(address multisig, uint value);
376   event SaleNew();
377   event SaleStarted();
378   event SaleEnded();
379   event ManualPriceChange(uint beforePrice, uint afterPrice);
380   event HoldChanged(address holder, uint tokens, uint timest);
381   event TokenChanged(address newAddress);
382 
383   modifier onlyAssetsOwners() {
384     require(assetOwnersIndex[msg.sender] > 0 || msg.sender == owner);
385     _;
386   }
387 
388   function OpportyYearHold(address walletAddress, uint start, uint end, uint endSale) public {
389     holdPeriod = 1 years;
390     state = SaleState.NEW;
391 
392     startDate = start;
393     endDate   = end;
394     endSaleDate = endSale;
395     price = 0.0002 * 1 ether;
396     multisig = walletAddress;
397     minimalContribution = 0.3 * 1 ether;
398 
399     bonuses.push(Bonus({minAmount: 0, maxAmount: 50, bonus: 35 }));
400     bonuses.push(Bonus({minAmount: 50, maxAmount: 100, bonus: 40 }));
401     bonuses.push(Bonus({minAmount: 100, maxAmount: 250, bonus: 45 }));
402     bonuses.push(Bonus({minAmount: 250, maxAmount: 500, bonus: 50 }));
403     bonuses.push(Bonus({minAmount: 500, maxAmount: 1000, bonus: 70 }));
404     bonuses.push(Bonus({minAmount: 1000, maxAmount: 5000, bonus: 80 }));
405     bonuses.push(Bonus({minAmount: 5000, maxAmount: 99999999, bonus: 90 }));
406   }
407 
408   function changeBonus(uint minAmount, uint maxAmount, uint8 newBonus) public {
409     bool find = false;
410     for (uint i = 0; i < bonuses.length; ++i) {
411       if (bonuses[i].minAmount == minAmount && bonuses[i].maxAmount == maxAmount ) {
412         bonuses[i].bonus = newBonus;
413         find = true;
414         break;
415       }
416     }
417     if (!find) {
418       bonuses.push(Bonus({minAmount:minAmount, maxAmount: maxAmount, bonus:newBonus}));
419     }
420     BonusChanged(minAmount, maxAmount, newBonus);
421   }
422 
423   function getBonus(uint am) public view returns(uint8) {
424     uint8 bon = 0;
425     am /= 10 ** 18;
426 
427     for (uint i = 0; i < bonuses.length; ++i) {
428       if (am >= bonuses[i].minAmount && am<bonuses[i].maxAmount)
429         bon = bonuses[i].bonus;
430     }
431 
432     return bon;
433   }
434 
435   function() public payable {
436     require(state == SaleState.SALE);
437     require(msg.value >= minimalContribution);
438     require(now >= startDate);
439 
440     if (now > endDate) {
441       state = SaleState.ENDED;
442       msg.sender.transfer(msg.value);
443       SaleEnded();
444       return ;
445     }
446 
447     uint tokenAmount = msg.value.div(price);
448     tokenAmount += tokenAmount.mul(getBonus(msg.value)).div(100);
449     tokenAmount *= 10 ** 18;
450 
451     uint holdTimestamp = endSaleDate.add(holdPeriod);
452     addHolder(msg.sender, tokenAmount, holdTimestamp);
453     HolderAdded(msg.sender, msg.value, tokenAmount, holdTimestamp);
454 
455     forwardFunds();
456 
457   }
458 
459   function addHolder(address holder, uint tokens, uint timest) internal {
460     if (holderList[holder].isActive == false) {
461       holderList[holder].isActive = true;
462       holderList[holder].tokens = tokens;
463       holderList[holder].holdPeriodTimestamp = timest;
464       holderIndexes[holderIndex] = holder;
465       holderIndex++;
466     } else {
467       holderList[holder].tokens += tokens;
468       holderList[holder].holdPeriodTimestamp = timest;
469     }
470   }
471 
472   function changeHold(address holder, uint tokens, uint timest) onlyAssetsOwners public {
473     if (holderList[holder].isActive == true) {
474       holderList[holder].tokens = tokens;
475       holderList[holder].holdPeriodTimestamp = timest;
476       HoldChanged(holder, tokens, timest);
477     }
478   }
479 
480   function forwardFunds() internal {
481     ethRaised += msg.value;
482     multisig.transfer(msg.value);
483     FundsTransferredToMultisig(multisig, msg.value);
484   }
485 
486   function newPresale() public onlyOwner {
487     state = SaleState.NEW;
488     SaleNew();
489   }
490 
491   function startPresale() public onlyOwner {
492     state = SaleState.SALE;
493     SaleStarted();
494   }
495 
496   function endPresale() public onlyOwner {
497     state = SaleState.ENDED;
498     SaleEnded();
499   }
500 
501   function addAssetsOwner(address _owner) public onlyOwner {
502     assetOwnersIndexes++;
503     assetOwners[assetOwnersIndexes] = _owner;
504     assetOwnersIndex[_owner] = assetOwnersIndexes;
505   }
506 
507   function removeAssetsOwner(address _owner) public onlyOwner {
508     uint index = assetOwnersIndex[_owner];
509     delete assetOwnersIndex[_owner];
510     delete assetOwners[index];
511     assetOwnersIndexes--;
512   }
513 
514   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
515     return assetOwners[_index];
516   }
517 
518   function getBalance() public constant returns (uint) {
519     return token.balanceOf(this);
520   }
521 
522   function returnTokens(uint nTokens) public onlyOwner returns (bool) {
523     require(nTokens <= getBalance());
524     token.transfer(msg.sender, nTokens);
525     TokensTransfered(msg.sender, nTokens);
526     return true;
527   }
528 
529   function unlockTokens() public returns (bool) {
530     require(holderList[msg.sender].isActive);
531     require(!holderList[msg.sender].withdrawed);
532     require(now >= holderList[msg.sender].holdPeriodTimestamp);
533 
534     token.transfer(msg.sender, holderList[msg.sender].tokens);
535     holderList[msg.sender].withdrawed = true;
536     TokensTransfered(msg.sender, holderList[msg.sender].tokens);
537     return true;
538   }
539 
540   function setStartDate(uint date) public onlyOwner {
541     uint oldStartDate = startDate;
542     startDate = date;
543     ManualChangeStartDate(oldStartDate, date);
544   }
545 
546   function setEndSaleDate(uint date) public onlyOwner {
547     uint oldEndDate = endSaleDate;
548     endSaleDate = date;
549     ManualChangeEndDate(oldEndDate, date);
550   }
551 
552   function setEndDate(uint date) public onlyOwner {
553     uint oldEndDate = endDate;
554     endDate = date;
555     ManualChangeEndDate(oldEndDate, date);
556   }
557 
558   function setPrice(uint newPrice) public onlyOwner {
559     uint oldPrice = price;
560     price = newPrice;
561     ManualPriceChange(oldPrice, newPrice);
562   }
563 
564   function setMinimalContribution(uint minimumAmount) public onlyOwner {
565     uint oldMinAmount = minimalContribution;
566     minimalContribution = minimumAmount;
567     ChangeMinAmount(oldMinAmount, minimalContribution);
568   }
569 
570   function batchChangeHoldPeriod(uint holdedPeriod) public onlyAssetsOwners {
571     for (uint i = 0; i < holderIndex; ++i) {
572       holderList[holderIndexes[i]].holdPeriodTimestamp = holdedPeriod;
573       HoldChanged(holderIndexes[i], holderList[holderIndexes[i]].tokens, holdedPeriod);
574     }
575   }
576 
577   function setToken(address newToken) public onlyOwner {
578     token = OpportyToken(newToken);
579     TokenChanged(token);
580   }
581 
582   function getTokenAmount() public view returns (uint) {
583     uint tokens = 0;
584     for (uint i = 0; i < holderIndex; ++i) {
585       if (!holderList[holderIndexes[i]].withdrawed) {
586         tokens += holderList[holderIndexes[i]].tokens;
587       }
588     }
589     return tokens;
590   }
591 
592   function getEthRaised() constant external returns (uint) {
593     return ethRaised;
594   }
595 
596 }