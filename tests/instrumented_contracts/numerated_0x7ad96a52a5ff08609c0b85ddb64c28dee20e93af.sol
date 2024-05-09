1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 /**
177  * @title SimpleToken
178  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
179  * Note they can later distribute these tokens as they wish using `transfer` and other
180  * `StandardToken` functions.
181  */
182 contract OpportyToken is StandardToken {
183 
184   string public constant name = "OpportyToken";
185   string public constant symbol = "OPP";
186   uint8 public constant decimals = 18;
187 
188   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
189 
190   /**
191    * @dev Contructor that gives msg.sender all of existing tokens.
192    */
193   function OpportyToken() public {
194     totalSupply = INITIAL_SUPPLY;
195     balances[msg.sender] = INITIAL_SUPPLY;
196   }
197 
198 }
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211 
212   /**
213    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
214    * account.
215    */
216   function Ownable() public {
217     owner = msg.sender;
218   }
219 
220 
221   /**
222    * @dev Throws if called by any account other than the owner.
223    */
224   modifier onlyOwner() {
225     require(msg.sender == owner);
226     _;
227   }
228 
229 
230   /**
231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) public onlyOwner {
235     require(newOwner != address(0));
236     OwnershipTransferred(owner, newOwner);
237     owner = newOwner;
238   }
239 
240 }
241 
242 /**
243  * @title Pausable
244  * @dev Base contract which allows children to implement an emergency stop mechanism.
245  */
246 contract Pausable is Ownable {
247   event Pause();
248   event Unpause();
249 
250   bool public paused = false;
251 
252 
253   /**
254    * @dev Modifier to make a function callable only when the contract is not paused.
255    */
256   modifier whenNotPaused() {
257     require(!paused);
258     _;
259   }
260 
261   /**
262    * @dev Modifier to make a function callable only when the contract is paused.
263    */
264   modifier whenPaused() {
265     require(paused);
266     _;
267   }
268 
269   /**
270    * @dev called by the owner to pause, triggers stopped state
271    */
272   function pause() onlyOwner whenNotPaused public {
273     paused = true;
274     Pause();
275   }
276 
277   /**
278    * @dev called by the owner to unpause, returns to normal state
279    */
280   function unpause() onlyOwner whenPaused public {
281     paused = false;
282     Unpause();
283   }
284 }
285 
286 contract HoldSaleContract is Ownable {
287   using SafeMath for uint256;
288   // Addresses and contracts
289   OpportyToken public OppToken;
290 
291   struct Holder {
292     bool isActive;
293     uint tokens;
294     uint holdPeriodTimestamp;
295     bool withdrawed;
296   }
297 
298   mapping(address => Holder) public holderList;
299   mapping(uint => address) private holderIndexes;
300 
301   mapping (uint => address) private assetOwners;
302   mapping (address => uint) private assetOwnersIndex;
303   uint private assetOwnersIndexes;
304 
305   uint private holderIndex;
306   uint private holderWithdrawIndex;
307 
308   uint private tokenAddHold;
309   uint private tokenWithdrawHold;
310 
311   event TokensTransfered(address contributor , uint amount);
312   event Hold(address sender, address contributor, uint amount, uint holdPeriod);
313 
314   modifier onlyAssetsOwners() {
315     require(assetOwnersIndex[msg.sender] > 0);
316     _;
317   }
318 
319   /* constructor */
320   function HoldSaleContract(address _OppToken) public {
321     OppToken = OpportyToken(_OppToken);
322     addAssetsOwner(msg.sender);
323   }
324 
325   function addHolder(address holder, uint tokens, uint timest) onlyAssetsOwners external {
326     if (holderList[holder].isActive == false) {
327       holderList[holder].isActive = true;
328       holderList[holder].tokens = tokens;
329       holderList[holder].holdPeriodTimestamp = timest;
330       holderIndexes[holderIndex] = holder;
331       holderIndex++;
332     } else {
333       holderList[holder].tokens += tokens;
334       holderList[holder].holdPeriodTimestamp = timest;
335     }
336     tokenAddHold += tokens;
337     Hold(msg.sender, holder, tokens, timest);
338   }
339 
340   function getBalance() public constant returns (uint) {
341     return OppToken.balanceOf(this);
342   }
343 
344   function unlockTokens() external {
345     address contributor = msg.sender;
346 
347     if (holderList[contributor].isActive && !holderList[contributor].withdrawed) {
348       if (now >= holderList[contributor].holdPeriodTimestamp) {
349         if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) {
350           TokensTransfered(contributor,  holderList[contributor].tokens);
351           tokenWithdrawHold += holderList[contributor].tokens;
352           holderList[contributor].withdrawed = true;
353           holderWithdrawIndex++;
354         }
355       } else {
356         revert();
357       }
358     } else {
359       revert();
360     }
361   }
362 
363   function addAssetsOwner(address _owner) public onlyOwner {
364     assetOwnersIndexes++;
365     assetOwners[assetOwnersIndexes] = _owner;
366     assetOwnersIndex[_owner] = assetOwnersIndexes;
367   }
368   function removeAssetsOwner(address _owner) public onlyOwner {
369     uint index = assetOwnersIndex[_owner];
370     delete assetOwnersIndex[_owner];
371     delete assetOwners[index];
372     assetOwnersIndexes--;
373   }
374   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
375     return assetOwners[_index];
376   }
377 
378   function getOverTokens() public onlyOwner {
379     require(getBalance() > (tokenAddHold - tokenWithdrawHold));
380     uint balance = getBalance() - (tokenAddHold - tokenWithdrawHold);
381     if(balance > 0) {
382       if(OppToken.transfer(msg.sender, balance)) {
383         TokensTransfered(msg.sender,  balance);
384       }
385     }
386   }
387 
388   function getTokenAddHold() onlyOwner public constant returns (uint) {
389     return tokenAddHold;
390   }
391   function getTokenWithdrawHold() onlyOwner public constant returns (uint) {
392     return tokenWithdrawHold;
393   }
394   function getHolderIndex() onlyOwner public constant returns (uint) {
395     return holderIndex;
396   }
397   function getHolderWithdrawIndex() onlyOwner public constant returns (uint) {
398     return holderWithdrawIndex;
399   }
400 }
401 
402 contract TokenSale is Pausable {
403   using SafeMath for uint256;
404 
405   OpportyToken public token;
406 
407   HoldSaleContract public holdContract;
408 
409   enum SaleState  { NEW, SALE, ENDED }
410   SaleState public state;
411 
412   uint public endDate;
413   uint public unholdDate;
414   uint public minimalContribution;
415 
416   // address where funds are collected
417   address private wallet;
418 
419   // total ETH collected
420   uint private ethRaised;
421 
422   uint private price;
423   uint8 private bonus;
424 
425   uint private tokenRaised;
426   bool public tokensTransferredToHold;
427 
428   /* Events */
429   event SaleStarted(uint blockNumber);
430   event SaleEnded(uint blockNumber);
431   event FundTransfered(address contrib, uint amount);
432   event WithdrawedEthToWallet(uint amount);
433   event ManualChangeEndDate(uint beforeDate, uint afterDate);
434   event ManualChangeUnholdDate(uint beforeDate, uint afterDate);
435   event TokensTransferedToHold(address hold, uint amount);
436   event AddedToHolder(address sender, uint tokenAmount, uint holdTimestamp);
437   event ChangeMinAmount(uint oldMinAmount, uint minAmount);
438 
439   mapping (uint => address) private assetOwners;
440   mapping (address => uint) private assetOwnersIndex;
441   uint private assetOwnersIndexes;
442 
443   modifier onlyAssetsOwners() {
444     require(assetOwnersIndex[msg.sender] > 0);
445     _;
446   }
447 
448   /* constructor */
449   function TokenSale(address tokenAddress, address walletAddress, uint end, uint endHoldDate, address holdCont) public {
450     token = OpportyToken(tokenAddress);
451     state = SaleState.NEW;
452 
453     endDate     = end;
454     unholdDate  = endHoldDate;
455     price       = 0.0002 * 1 ether;
456     wallet      = walletAddress;
457     minimalContribution = 0.1 * 1 ether;
458     bonus = 0;
459 
460     holdContract = HoldSaleContract(holdCont);
461     addAssetsOwner(msg.sender);
462   }
463 
464   function() whenNotPaused public payable {
465     require(state == SaleState.SALE);
466     require(msg.value >= minimalContribution);
467 
468     if (now > endDate) {
469       state = SaleState.ENDED;
470       SaleEnded(block.number);
471       msg.sender.transfer(msg.value);
472       return ;
473     }
474 
475     ethRaised += msg.value;
476 
477     uint tokenAmount  = msg.value.div(price);
478     tokenAmount += tokenAmount.mul(bonus).div(100);
479     tokenAmount *= 1 ether;
480 
481     tokenRaised += tokenAmount;
482 
483     holdContract.addHolder(msg.sender, tokenAmount, unholdDate);
484     AddedToHolder(msg.sender, tokenAmount, unholdDate);
485     FundTransfered(msg.sender, msg.value);
486 
487     // forward the funds to the wallet
488     forwardFunds();
489   }
490 
491   /**
492      * send ether to the fund collection wallet
493      * override to create custom fund forwarding mechanisms
494      */
495   function forwardFunds() internal {
496     wallet.transfer(msg.value);
497   }
498 
499   function getBalanceContract() view internal returns (uint) {
500     return token.balanceOf(this);
501   }
502 
503   function startSale() public onlyOwner {
504     require(state == SaleState.NEW);
505     state = SaleState.SALE;
506     SaleStarted(block.number);
507   }
508   function endSale() public onlyOwner {
509     require(state == SaleState.SALE);
510     state = SaleState.ENDED;
511     SaleEnded(block.number);
512   }
513 
514   function sendTokensToHold() public onlyOwner {
515     require(state == SaleState.ENDED);
516 
517     require(getBalanceContract() >= tokenRaised);
518 
519     if (token.transfer(holdContract, tokenRaised )) {
520       tokensTransferredToHold = true;
521       TokensTransferedToHold(holdContract, tokenRaised );
522     }
523   }
524   function getTokensBack() public onlyOwner {
525     require(state == SaleState.ENDED);
526     require(tokensTransferredToHold == true);
527     uint balance;
528     balance = getBalanceContract() ;
529     token.transfer(msg.sender, balance);
530   }
531   function withdrawEth() public {
532     require(this.balance != 0);
533     require(state == SaleState.ENDED);
534     require(msg.sender == wallet);
535     require(tokensTransferredToHold == true);
536     uint bal = this.balance;
537     wallet.transfer(bal);
538     WithdrawedEthToWallet(bal);
539   }
540 
541   function setUnholdDate(uint date) public onlyOwner {
542     require(state == SaleState.NEW || state == SaleState.SALE);
543     uint oldEndDate = unholdDate;
544     unholdDate = date;
545     ManualChangeUnholdDate(oldEndDate, date);
546   }
547   function setEndDate(uint date) public onlyOwner {
548     require(state == SaleState.NEW || state == SaleState.SALE);
549     require(date > now);
550     uint oldEndDate = endDate;
551     endDate = date;
552     ManualChangeEndDate(oldEndDate, date);
553   }
554   function setMinimalContribution(uint minimumAmount) public onlyOwner {
555     uint oldMinAmount = minimalContribution;
556     minimalContribution = minimumAmount;
557     ChangeMinAmount(oldMinAmount, minimalContribution);
558   }
559   function setBonus(uint8 newBonus) public onlyOwner {
560     require(newBonus >= 0);
561     bonus = newBonus;
562   }
563 
564   function addAssetsOwner(address _owner) public onlyOwner {
565     assetOwnersIndexes++;
566     assetOwners[assetOwnersIndexes] = _owner;
567     assetOwnersIndex[_owner] = assetOwnersIndexes;
568   }
569   function removeAssetsOwner(address _owner) public onlyOwner {
570     uint index = assetOwnersIndex[_owner];
571     delete assetOwnersIndex[_owner];
572     delete assetOwners[index];
573     assetOwnersIndexes--;
574   }
575   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
576     return assetOwners[_index];
577   }
578 
579   function getTokenBalance() onlyAssetsOwners public constant returns (uint) {
580     return token.balanceOf(this);
581   }
582   function getEthRaised() onlyAssetsOwners public constant returns (uint) {
583     return ethRaised;
584   }
585   function getBonus() onlyAssetsOwners public constant returns (uint) {
586     return bonus;
587   }
588   function getTokenRaised() onlyAssetsOwners public constant returns (uint) {
589     return tokenRaised;
590   }
591 }