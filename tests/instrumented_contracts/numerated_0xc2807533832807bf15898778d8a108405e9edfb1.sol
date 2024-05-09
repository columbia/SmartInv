1 pragma solidity ^0.4.18;
2 
3 /*
4  * Ponzi Trust Token Smart Contracts 
5  * Code is published on https://github.com/PonziTrust/Token
6  * Ponzi Trust https://ponzitrust.com/
7 */
8 
9 
10 // see: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 
41 // see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
42 contract ERC20 {
43   function name() public view returns (string);
44   function symbol() public view returns (string);
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   function transferFrom(address from, address to, uint256 value) public returns (bool);
49   function approve(address spender, uint256 value) public returns (bool);
50   function allowance(address owner, address spender) public view returns (uint256);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 // see: https://github.com/ethereum/EIPs/issues/677
57 contract ERC677Token {
58   function transferAndCall(address receiver, uint amount, bytes data) public returns (bool success);
59   function contractFallback(address to, uint value, bytes data) internal;
60   function isContract(address addr) internal view returns (bool hasCode);
61   event Transfer(address indexed from, address indexed to, uint value, bytes data);
62 }
63 
64 
65 // see: https://github.com/ethereum/EIPs/issues/677
66 contract ERC677Recipient {
67   function tokenFallback(address from, uint256 amount, bytes data) public returns (bool success);
68 }  
69 
70 
71 /**
72 * @dev The token implement ERC20 and ERC677 standarts(see above).
73 * use Withdrawal, Restricting Access, State Machine patterns.
74 * see: http://solidity.readthedocs.io/en/develop/common-patterns.html
75 * use SafeMath library, see above.
76 * The owner can intervene in the work of the token only before the expiration
77 * DURATION_TO_ACCESS_FOR_OWNER = 144 days. Contract has thee state of working:
78 * 1.PreSale - only owner can access to transfer tokens. 2.Sale - contract to sale
79 * tokens by func byToken() of fallback, contact and owner can access to transfer tokens. 
80 * Token price setting by owner or price setter. 3.PublicUse - anyone can transfer tokens.
81 */
82 contract PonziToken is ERC20, ERC677Token {
83   using SafeMath for uint256;
84 
85   enum State {
86     PreSale,   //PRE_SALE_STR
87     Sale,      //SALE_STR
88     PublicUse  //PUBLIC_USE_STR
89   }
90   // we need returns string representation of state
91   // because enums are not supported by the ABI, they are just supported by Solidity.
92   // see: http://solidity.readthedocs.io/en/develop/frequently-asked-questions.html#if-i-return-an-enum-i-only-get-integer-values-in-web3-js-how-to-get-the-named-values
93   string private constant PRE_SALE_STR = "PreSale";
94   string private constant SALE_STR = "Sale";
95   string private constant PUBLIC_USE_STR = "PublicUse";
96   State private m_state;
97 
98   uint256 private constant DURATION_TO_ACCESS_FOR_OWNER = 144 days;
99   
100   uint256 private m_maxTokensPerAddress;
101   uint256 private m_firstEntranceToSaleStateUNIX;
102   address private m_owner;
103   address private m_priceSetter;
104   address private m_bank;
105   uint256 private m_tokenPriceInWei;
106   uint256 private m_totalSupply;
107   uint256 private m_myDebtInWei;
108   string private m_name;
109   string private m_symbol;
110   uint8 private m_decimals;
111   bool private m_isFixedTokenPrice;
112   
113   mapping(address => mapping (address => uint256)) private m_allowed;
114   mapping(address => uint256) private m_balances;
115   mapping(address => uint256) private m_pendingWithdrawals;
116 
117 ////////////////
118 // EVENTS
119 //
120   event StateChanged(address indexed who, State newState);
121   event PriceChanged(address indexed who, uint newPrice, bool isFixed);
122   event TokensSold(uint256 numberOfTokens, address indexed purchasedBy, uint256 indexed priceInWei);
123   event Withdrawal(address indexed to, uint sumInWei);
124 
125 ////////////////
126 // MODIFIERS - Restricting Access and State Machine patterns
127 //
128   modifier atState(State state) {
129     require(m_state == state);
130     _;
131   }
132 
133   modifier onlyOwner() {
134     require(msg.sender == m_owner);
135     _;
136   }
137 
138   modifier onlyOwnerOrAtState(State state) {
139     require(msg.sender == m_owner || m_state == state); 
140     _;
141   }
142   
143   modifier checkAccess() {
144     require(m_firstEntranceToSaleStateUNIX == 0 // solium-disable-line indentation, operator-whitespace
145       || now.sub(m_firstEntranceToSaleStateUNIX) <= DURATION_TO_ACCESS_FOR_OWNER 
146       || m_state != State.PublicUse
147     ); 
148     _;
149     // owner has not access if duration To Access For Owner was passed 
150     // and (&&) contract in PublicUse state.
151   }
152   
153   modifier validRecipient(address recipient) {
154     require(recipient != address(0) && recipient != address(this));
155     _;
156   }
157 
158 ///////////////
159 // CONSTRUCTOR
160 //  
161   /**
162   * @dev Constructor PonziToken.
163   */
164   function PonziToken() public {
165     m_owner = msg.sender;
166     m_bank = msg.sender;
167     m_state = State.PreSale;
168     m_decimals = 8;
169     m_name = "Ponzi";
170     m_symbol = "PT";
171   }
172 
173   /**
174   * do not forget about:
175   * https://medium.com/codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
176   * 
177   * @dev Initialize the contract, only owner can call and only once.
178   * @return Whether successful or not.
179   */
180   function initContract() 
181     public 
182     onlyOwner() 
183     returns (bool)
184   {
185     require(m_maxTokensPerAddress == 0 && m_decimals > 0);
186     m_maxTokensPerAddress = uint256(1000).mul(uint256(10)**uint256(m_decimals));
187 
188     m_totalSupply = uint256(100000000).mul(uint256(10)**uint256(m_decimals));
189     // 70% for owner
190     m_balances[msg.sender] = m_totalSupply.mul(uint256(70)).div(uint256(100));
191     // 30% for sale
192     m_balances[address(this)] = m_totalSupply.sub(m_balances[msg.sender]);
193 
194     // allow owner to transfer token from this  
195     m_allowed[address(this)][m_owner] = m_balances[address(this)];
196     return true;
197   }
198 
199 ///////////////////
200 // ERC20 Methods
201 // get from https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
202 //
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address owner) public view returns (uint256) {
209     return m_balances[owner];
210   }
211   
212   /**
213   * @dev The name of the token.
214   * @return The name of the token.
215   */
216   function name() public view returns (string) {
217     return m_name;
218   }
219 
220   /**
221   * @dev The symbol of the token.
222   * @return The symbol of the token.
223   */
224   function symbol() public view returns (string) {
225     return m_symbol;
226   }
227 
228   /**
229   * @dev The number of decimals the token.
230   * @return The number of decimals the token.
231   * @notice Uses - e.g. 8, means to divide the token.
232   * amount by 100000000 to get its user representation.
233   */
234   function decimals() public view returns (uint8) {
235     return m_decimals;
236   }
237 
238   /**
239   * @dev Total number of tokens in existence.
240   * @return Total number of tokens in existence.
241   */
242   function totalSupply() public view returns (uint256) {
243     return m_totalSupply;
244   }
245 
246   /**
247   * @dev Transfer token for a specified address.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   * @return Whether successful or not.
251   */
252   function transfer(address to, uint256 value) 
253     public 
254     onlyOwnerOrAtState(State.PublicUse)
255     validRecipient(to)
256     returns (bool) 
257   {
258     // require(value <= m_balances[msg.sender]);
259     // SafeMath.sub will already throw if this condition is not met
260     m_balances[msg.sender] = m_balances[msg.sender].sub(value);
261     m_balances[to] = m_balances[to].add(value);
262     Transfer(msg.sender, to, value);
263     return true;
264   }
265 
266   /**
267    * @dev Transfer tokens from one address to another.
268    * @param from Address The address which you want to send tokens from.
269    * @param to Address The address which you want to transfer to.
270    * @param value Uint256 the amount of tokens to be transferred.
271    * @return Whether successful or not.
272    */
273   function transferFrom(address from, address to, uint256 value) 
274     public
275     onlyOwnerOrAtState(State.PublicUse)
276     validRecipient(to)
277     returns (bool) 
278   {
279     // require(value <= m_balances[from]);
280     // require(value <= m_allowed[from][msg.sender]);
281     // SafeMath.sub will already throw if this condition is not met
282     m_balances[from] = m_balances[from].sub(value);
283     m_balances[to] = m_balances[to].add(value);
284     m_allowed[from][msg.sender] = m_allowed[from][msg.sender].sub(value);
285     Transfer(from, to, value);
286     return true;
287   }
288 
289   /**
290    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291    * @param spender The address which will spend the funds.
292    * @param value The amount of tokens to be spent.
293    * @return Whether successful or not.
294    */
295   function approve(address spender, uint256 value) 
296     public
297     onlyOwnerOrAtState(State.PublicUse)
298     validRecipient(spender)
299     returns (bool) 
300   {
301     // To change the approve amount you first have to reduce the addresses`
302     // allowance to zero by calling `approve(spender,0)` if it is not
303     // already 0 to mitigate the race condition described here:
304     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305     require((value == 0) || (m_allowed[msg.sender][spender] == 0));
306 
307     m_allowed[msg.sender][spender] = value;
308     Approval(msg.sender, spender, value);
309     return true;
310   }
311 
312   /**
313    * @dev Function to check the amount of tokens that an owner allowed to a spender.
314    * @param owner Address The address which owns the funds.
315    * @param spender Address The address which will spend the funds.
316    * @return A uint256 specifying the amount of tokens still available for the spender.
317    */
318   function allowance(address owner, address spender) 
319     public 
320     view
321     returns (uint256) 
322   {
323     return m_allowed[owner][spender];
324   }
325   
326   /**
327    * approve should be called when allowed[spender] == 0. To increment
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol.
331    *
332    * @dev Increase the amount of tokens that an owner allowed to a spender.
333    * @param spender The address which will spend the funds.
334    * @param addedValue The amount of tokens to increase the allowance by.
335    * @return Whether successful or not.
336    */
337   function increaseApproval(address spender, uint addedValue) 
338     public 
339     onlyOwnerOrAtState(State.PublicUse)
340     validRecipient(spender)
341     returns (bool) 
342   {
343     m_allowed[msg.sender][spender] = m_allowed[msg.sender][spender].add(addedValue);
344     Approval(msg.sender, spender, m_allowed[msg.sender][spender]);
345     return true;
346   }
347 
348    /**
349    * Approve should be called when allowed[spender] == 0. To decrement
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol.
353    *
354    * @dev Decrease the amount of tokens that an owner allowed to a spender.
355    * @param spender The address which will spend the funds.
356    * @param subtractedValue The amount of tokens to decrease the allowance by.
357    * @return Whether successful or not.
358    */
359   function decreaseApproval(address spender, uint subtractedValue) 
360     public
361     onlyOwnerOrAtState(State.PublicUse)
362     validRecipient(spender)
363     returns (bool) 
364   {
365     uint oldValue = m_allowed[msg.sender][spender];
366     if (subtractedValue > oldValue) {
367       m_allowed[msg.sender][spender] = 0;
368     } else {
369       m_allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
370     }
371     Approval(msg.sender, spender, m_allowed[msg.sender][spender]);
372     return true;
373   }
374 
375 ///////////////////
376 // ERC677 Methods
377 //
378   /**
379   * @dev Transfer token to a contract address with additional data if the recipient is a contact.
380   * @param to The address to transfer to.
381   * @param value The amount to be transferred.
382   * @param extraData The extra data to be passed to the receiving contract.
383   * @return Whether successful or not.
384   */
385   function transferAndCall(address to, uint256 value, bytes extraData) 
386     public
387     onlyOwnerOrAtState(State.PublicUse)
388     validRecipient(to)
389     returns (bool)
390   {
391     // require(value <= m_balances[msg.sender]);
392     // SafeMath.sub will throw if there is not enough balance.
393     m_balances[msg.sender] = m_balances[msg.sender].sub(value);
394     m_balances[to] = m_balances[to].add(value);
395     Transfer(msg.sender, to, value);
396     if (isContract(to)) {
397       contractFallback(to, value, extraData);
398       Transfer(msg.sender, to, value, extraData);
399     }
400     return true;
401   }
402 
403   /**
404   * @dev transfer token all tokens to a contract address with additional data if the recipient is a contact.
405   * @param to The address to transfer all to.
406   * @param extraData The extra data to be passed to the receiving contract.
407   * @return Whether successful or not.
408   */
409   function transferAllAndCall(address to, bytes extraData) 
410     external
411     onlyOwnerOrAtState(State.PublicUse)
412     returns (bool) 
413   {
414     return transferAndCall(to, m_balances[msg.sender], extraData);
415   }
416   
417   /**
418   * @dev Call ERC677 tokenFallback for ERC677Recipient contract.
419   * @param to The address of ERC677Recipient.
420   * @param value Amount of tokens with was sended
421   * @param data Sended to ERC677Recipient.
422   * @return Whether contract or not.
423   */
424   function contractFallback(address to, uint value, bytes data)
425     internal
426   {
427     ERC677Recipient recipient = ERC677Recipient(to);
428     recipient.tokenFallback(msg.sender, value, data);
429   }
430 
431   /**
432   * @dev Check addr if is contract.
433   * @param addr The address that checking.
434   * @return Whether contract or not.
435   */
436   function isContract(address addr) internal view returns (bool) {
437     uint length;
438     assembly { length := extcodesize(addr) }
439     return length > 0;
440   }
441   
442   
443 ///////////////////
444 // payable Methods
445 // use withdrawal pattern 
446 // see: http://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
447 // see: https://consensys.github.io/smart-contract-best-practices/known_attacks/
448 //
449   /**
450   * Recived ETH converted to tokens amount for price. sender has max limit for tokens 
451   * amount as m_maxTokensPerAddress - balanceOf(sender). if amount <= max limit
452   * then transfer amount from this to sender and 95%ETH to bank, 5%ETH to owner.
453   * else amount > max limit then we calc cost of max limit of tokens,
454   * store this cost in m_pendingWithdrawals[sender] and m_myDebtInWei and 
455   * transfer max limit of tokens from this to sender and 95% max limit cost to bank
456   * 5% max limit cost to owner.
457   *
458   * @dev Contract receive ETH (payable) from sender and transfer some amount of tokens to him.
459   */
460   function byTokens() public payable atState(State.Sale) {
461     // check if msg.sender can to by tokens 
462     require(m_balances[msg.sender] < m_maxTokensPerAddress);
463 
464     // get actual token price and set it
465     m_tokenPriceInWei = calcTokenPriceInWei();
466     
467     // check if msg.value has enough for by 1 token
468     require(msg.value >= m_tokenPriceInWei);
469     
470     // calc max available tokens for sender
471     uint256 maxAvailableTokens = m_maxTokensPerAddress.sub(m_balances[msg.sender]);
472     
473     // convert msg.value(wei) to tokens
474     uint256 tokensAmount = weiToTokens(msg.value, m_tokenPriceInWei);
475     
476     if (tokensAmount > maxAvailableTokens) {
477       // we CANT transfer all tokens amount, ONLY max available tokens 
478       // calc cost in wei of max available tokens
479       // subtract cost from msg.value and store it as debt for sender
480       tokensAmount = maxAvailableTokens;  
481       // calc cost
482       uint256 tokensAmountCostInWei = tokensToWei(tokensAmount, m_tokenPriceInWei);
483       // calc debt
484       uint256 debt = msg.value.sub(tokensAmountCostInWei);
485       // Withdrawal pattern avoid Re-Entrancy (dont use transfer to unknow address)
486       // update pending withdrawals
487       m_pendingWithdrawals[msg.sender] = m_pendingWithdrawals[msg.sender].add(debt);
488       // update my debt
489       m_myDebtInWei = m_myDebtInWei.add(debt);
490     }
491     // transfer tokensAmount tokens form this to sender
492     // SafeMath.sub will already throw if this condition is not met
493     m_balances[address(this)] = m_balances[address(this)].sub(tokensAmount);
494     m_balances[msg.sender] = m_balances[msg.sender].add(tokensAmount);
495 
496     // we can transfer eth to owner and bank, because we know that they 
497     // dont use Re-Entrancy and other attacks.
498     // transfer 5% of eht-myDebt to owner
499     // owner cant be equal address(0) because this function to be accessible
500     // only in State.Sale but owner can be equal address(0), only in State.PublicUse
501     // State.Sale not equal State.PublicUse!
502     m_owner.transfer(this.balance.sub(m_myDebtInWei).mul(uint256(5)).div(uint256(100)));
503     // transfer 95% of eht-myDebt to bank
504     // bank cant be equal address(0) see setBank() and PonziToken()
505     m_bank.transfer(this.balance.sub(m_myDebtInWei));
506     checkValidityOfBalance(); // this.balance >= m_myDebtInWei
507     Transfer(address(this), msg.sender, tokensAmount);
508     TokensSold(tokensAmount, msg.sender, m_tokenPriceInWei); 
509   }
510   
511   /**
512   * @dev Sender receive his pending withdrawals(if > 0).
513   */
514   function withdraw() external {
515     uint amount = m_pendingWithdrawals[msg.sender];
516     require(amount > 0);
517     // set zero the pending refund before
518     // sending to prevent Re-Entrancy 
519     m_pendingWithdrawals[msg.sender] = 0;
520     m_myDebtInWei = m_myDebtInWei.sub(amount);
521     msg.sender.transfer(amount);
522     checkValidityOfBalance(); // this.balance >= m_myDebtInWei
523     Withdrawal(msg.sender, amount);
524   }
525 
526   /**
527   * @notice http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
528   * we dont need recieve ETH always, only in State.Sale from externally accounts.
529   *
530   * @dev Fallback func, call byTokens().
531   */
532   function() public payable atState(State.Sale) {
533     byTokens();
534   }
535     
536   
537 ////////////////////////
538 // external view methods
539 // everyone outside has access 
540 //
541   /**
542   * @dev Gets the pending withdrawals of the specified address.
543   * @param owner The address to query the pending withdrawals of.
544   * @return An uint256 representing the amount withdrawals owned by the passed address.
545   */
546   function pendingWithdrawals(address owner) external view returns (uint256) {
547     return m_pendingWithdrawals[owner];
548   }
549   
550   /**
551   * @dev Get contract work state.
552   * @return Contract work state via string.
553   */
554   function state() external view returns (string stateString) {
555     if (m_state == State.PreSale) {
556       stateString = PRE_SALE_STR;
557     } else if (m_state == State.Sale) {
558       stateString = SALE_STR;
559     } else if (m_state == State.PublicUse) {
560       stateString = PUBLIC_USE_STR;
561     }
562   }
563   
564   /**
565   * @dev Get price of one token in wei.
566   * @return Price of one token in wei.
567   */
568   function tokenPriceInWei() public view returns (uint256) {
569     return calcTokenPriceInWei();
570   }
571   
572   /**
573   * @dev Get address of the bank.
574   * @return Address of the bank. 
575   */
576   function bank() external view returns(address) {
577     return m_bank;
578   }
579   
580   /**
581   * @dev Get timestamp of first entrance to sale state.
582   * @return Timestamp of first entrance to sale state.
583   */
584   function firstEntranceToSaleStateUNIX() 
585     external
586     view 
587     returns(uint256) 
588   {
589     return m_firstEntranceToSaleStateUNIX;
590   }
591   
592   /**
593   * @dev Get address of the price setter.
594   * @return Address of the price setter.
595   */
596   function priceSetter() external view returns (address) {
597     return m_priceSetter;
598   }
599 
600 ////////////////////
601 // public methods
602 // only for owner
603 //
604   /**
605   * @dev Owner do disown.
606   */ 
607   function disown() external atState(State.PublicUse) onlyOwner() {
608     delete m_owner;
609   }
610   
611   /**
612   * @dev Set state of contract working.
613   * @param newState String representation of new state.
614   */ 
615   function setState(string newState) 
616     external 
617     onlyOwner()
618     checkAccess()
619   {
620     if (keccak256(newState) == keccak256(PRE_SALE_STR)) {
621       m_state = State.PreSale;
622     } else if (keccak256(newState) == keccak256(SALE_STR)) {
623       if (m_firstEntranceToSaleStateUNIX == 0) 
624         m_firstEntranceToSaleStateUNIX = now;
625         
626       m_state = State.Sale;
627     } else if (keccak256(newState) == keccak256(PUBLIC_USE_STR)) {
628       m_state = State.PublicUse;
629     } else {
630       // if newState not valid string
631       revert();
632     }
633     StateChanged(msg.sender, m_state);
634   }
635 
636   /**
637   * If token price not fix then actual price 
638   * always will be tokenPriceInWeiForDay(day).
639   *
640   * @dev Set price of one token in wei and fix it.
641   * @param newTokenPriceInWei Price of one token in wei.
642   */ 
643   function setAndFixTokenPriceInWei(uint256 newTokenPriceInWei) 
644     external
645     checkAccess()
646   {
647     require(msg.sender == m_owner || msg.sender == m_priceSetter);
648     m_isFixedTokenPrice = true;
649     m_tokenPriceInWei = newTokenPriceInWei;
650     PriceChanged(msg.sender, m_tokenPriceInWei, m_isFixedTokenPrice);
651   }
652   
653   /**
654   * If token price is unfixed then actual will be tokenPriceInWeiForDay(day).
655   * 
656   * @dev Set unfix token price to true.
657   */
658   function unfixTokenPriceInWei() 
659     external
660     checkAccess()
661   {
662     require(msg.sender == m_owner || msg.sender == m_priceSetter);
663     m_isFixedTokenPrice = false;
664     PriceChanged(msg.sender, m_tokenPriceInWei, m_isFixedTokenPrice);
665   }
666   
667   /**
668   * @dev Set the PriceSetter address, which has access to set one token price in wei.
669   * @param newPriceSetter The address of new PriceSetter.
670   */
671   function setPriceSetter(address newPriceSetter) 
672     external 
673     onlyOwner() 
674     checkAccess()
675   {
676     m_priceSetter = newPriceSetter;
677   }
678 
679   /**
680   * @dev Set the bank, which receive 95%ETH from tokens sale.
681   * @param newBank The address of new bank.
682   */
683   function setBank(address newBank) 
684     external
685     validRecipient(newBank) 
686     onlyOwner()
687     checkAccess()
688   {
689     require(newBank != address(0));
690     m_bank = newBank;
691   }
692 
693 ////////////////////////
694 // internal pure methods
695 //
696   /**
697   * @dev Convert token to wei.
698   * @param tokensAmount Amout of tokens.
699   * @param tokenPrice One token price in wei.
700   * @return weiAmount Result amount of convertation. 
701   */
702   function tokensToWei(uint256 tokensAmount, uint256 tokenPrice) 
703     internal
704     pure
705     returns(uint256 weiAmount)
706   {
707     weiAmount = tokensAmount.mul(tokenPrice); 
708   }
709   
710   /**
711   * @dev Conver wei to token.
712   * @param weiAmount Wei amout.
713   * @param tokenPrice One token price in wei.
714   * @return tokensAmount Result amount of convertation.
715   */
716   function weiToTokens(uint256 weiAmount, uint256 tokenPrice) 
717     internal 
718     pure 
719     returns(uint256 tokensAmount) 
720   {
721     tokensAmount = weiAmount.div(tokenPrice);
722   }
723  
724 ////////////////////////
725 // private view methods
726 //
727   /**
728   * @dev Get actual token price.
729   * @return price One token price in wei. 
730   */
731   function calcTokenPriceInWei() 
732     private 
733     view 
734     returns(uint256 price) 
735   {
736     if (m_isFixedTokenPrice) {
737       // price is fixed, return current val
738       price = m_tokenPriceInWei;
739     } else {
740       // price not fixed, we must to calc price
741       if (m_firstEntranceToSaleStateUNIX == 0) {
742         // if contract dont enter to SaleState then price = 0 
743         price = 0;
744       } else {
745         // calculate day after first Entrance To Sale State
746         uint256 day = now.sub(m_firstEntranceToSaleStateUNIX).div(1 days);
747         // use special formula for calcutation price
748         price = tokenPriceInWeiForDay(day);
749       }
750     } 
751   }
752   
753   /**
754   * @dev Get token price for specific day after starting sale tokens.
755   * @param day Secific day.
756   * @return price One token price in wei for specific day. 
757   */
758   function tokenPriceInWeiForDay(uint256 day) 
759     private 
760     view 
761     returns(uint256 price)
762   {
763     // day 1:   price 1*10^(decimals) TOKEN = 0.001 ETH
764     //          price 1 TOKEN = 1 * 10^(-3) ETH / 10^(decimals), in ETH
765     //          convert to wei:
766     //          price 1 TOKEN = 1 * 10^(-3) * wei * 10^(-decimals)
767     //          price 1 TOKEN = 1 * 10^(-3) * 10^(18) * 10^(-decimals)
768     //          price 1 TOKEN = 1 * 10^(15) * 10^(-decimals), in WEI
769     
770     // day 2:   price 1*10^(decimals) TOKEN = 0.002 ETH;
771     //          price 1 TOKEN = 2 * 10^(15) * 10^(-decimals), in WEI
772     // ...
773     // day 12:  price 1*10^(decimals) TOKEN = 0.012 ETH;
774     //          price 1 TOKEN = 12 * 10^(15) * 10^(-decimals), in WEI
775     
776     // day >12: price 1*10^(decimals) TOKEN = 0.012 ETH;
777     //          price 1 TOKEN = 12 * 10^(15) * 10^(-decimals), in WEI
778 
779     // from 0 to 11 - sum is 12 days
780     if (day <= 11) 
781       price = day.add(1);// because from >0h to <24h after start day will be 0, 
782     else                 // but for calc price it must be 1;
783       price = 12;
784     // convert to WEI
785     price = price.mul(uint256(10**15)).div(10**uint256(m_decimals));
786   }
787   
788   /**
789   * @notice It is always must be true, for correct withdrawals and receivers ETH.
790   *
791   * Check if this.balance >= m_myDebtInWei.
792   */
793   function checkValidityOfBalance() private view {
794     // assertion is not a strict equality of the balance because the contract 
795     // can be forcibly sent ether without going through the byTokens() func.
796     // selfdestruct does not trigger a contract's fallback function. 
797     // see: http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
798     assert(this.balance >= m_myDebtInWei);
799   }
800 }