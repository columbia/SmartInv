1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address previousOwner);
14   event OwnershipTransferred(
15     address previousOwner,
16     address newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (_a == 0) {
80       return 0;
81     }
82 
83     c = _a * _b;
84     assert(c / _a == _b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     // assert(_b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95     return _a / _b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
102     assert(_b <= _a);
103     return _a - _b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
110     c = _a + _b;
111     assert(c >= _a);
112     return c;
113   }
114 }
115 
116 interface IERC20 {
117   function totalSupply() external view returns (uint256);
118 
119   function balanceOf(address who) external view returns (uint256);
120 
121   function allowance(address owner, address spender)
122     external view returns (uint256);
123 
124   function transfer(address to, uint256 value) external returns (bool);
125 
126   function approve(address spender, uint256 value)
127     external returns (bool);
128 
129   function transferFrom(address from, address to, uint256 value)
130     external returns (bool);
131 
132   event Transfer(
133     address from,
134     address to,
135     uint256 value
136   );
137 
138   event Approval(
139     address owner,
140     address spender,
141     uint256 value
142   );
143 }
144 
145 contract ERC20 is IERC20 {
146   using SafeMath for uint256;
147 
148   mapping (address => uint256) private _balances;
149 
150   mapping (address => mapping (address => uint256)) private _allowed;
151 
152   uint256 private _totalSupply;
153   bool public isPaused;
154 
155   /**
156   * @dev Total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return _totalSupply;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param owner The address to query the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address owner) public view returns (uint256) {
168     return _balances[owner];
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param owner address The address which owns the funds.
174    * @param spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(
178     address owner,
179     address spender
180    )
181     public
182     view
183     returns (uint256)
184   {
185     return _allowed[owner][spender];
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param to The address to transfer to.
191   * @param value The amount to be transferred.
192   */
193   function transfer(address to, uint256 value) public returns (bool) {
194     _transfer(msg.sender, to, value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param spender The address which will spend the funds.
205    * @param value The amount of tokens to be spent.
206    */
207   function approve(address spender, uint256 value) public returns (bool) {
208     require(isPaused == false, "transactions on pause");
209     require(spender != address(0));
210 
211     _allowed[msg.sender][spender] = value;
212     emit Approval(msg.sender, spender, value);
213     return true;
214   }
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param from address The address which you want to send tokens from
219    * @param to address The address which you want to transfer to
220    * @param value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(
223     address from,
224     address to,
225     uint256 value
226   )
227     public
228     returns (bool)
229   {
230     require(value <= _allowed[from][msg.sender]);
231 
232     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
233     _transfer(from, to, value);
234     return true;
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed_[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param spender The address which will spend the funds.
244    * @param addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseAllowance(
247     address spender,
248     uint256 addedValue
249   )
250     public
251     returns (bool)
252   {
253     require(spender != address(0));
254     require(isPaused == false, "transactions on pause");
255 
256     _allowed[msg.sender][spender] = (
257       _allowed[msg.sender][spender].add(addedValue));
258     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed_[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param spender The address which will spend the funds.
269    * @param subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseAllowance(
272     address spender,
273     uint256 subtractedValue
274   )
275     public
276     returns (bool)
277   {
278     require(spender != address(0));
279     require(isPaused == false, "transactions on pause");
280 
281     _allowed[msg.sender][spender] = (
282       _allowed[msg.sender][spender].sub(subtractedValue));
283     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
284     return true;
285   }
286 
287   /**
288   * @dev Transfer token for a specified addresses
289   * @param from The address to transfer from.
290   * @param to The address to transfer to.
291   * @param value The amount to be transferred.
292   */
293   function _transfer(address from, address to, uint256 value) internal {
294     require(value <= _balances[from]);
295     require(to != address(0));
296     require(isPaused == false, "transactions on pause");
297 
298     _balances[from] = _balances[from].sub(value);
299     _balances[to] = _balances[to].add(value);
300     emit Transfer(from, to, value);
301   }
302 
303   /**
304    * @dev Internal function that mints an amount of the token and assigns it to
305    * an account. This encapsulates the modification of balances such that the
306    * proper events are emitted.
307    * @param account The account that will receive the created tokens.
308    * @param value The amount that will be created.
309    */
310   function _mint(address account, uint256 value) internal {
311     require(account != 0);
312     require(isPaused == false, "transactions on pause");
313     _totalSupply = _totalSupply.add(value);
314     _balances[account] = _balances[account].add(value);
315     emit Transfer(address(0), account, value);
316   }
317 
318   /**
319    * @dev Internal function that burns an amount of the token of a given
320    * account.
321    * @param account The account whose tokens will be burnt.
322    * @param value The amount that will be burnt.
323    */
324   function _burn(address account, uint256 value) internal {
325     require(account != 0);
326     require(value <= _balances[account]);
327 
328     _totalSupply = _totalSupply.sub(value);
329     _balances[account] = _balances[account].sub(value);
330     emit Transfer(account, address(0), value);
331   }
332 
333   /**
334    * @dev Internal function that burns an amount of the token of a given
335    * account, deducting from the sender's allowance for said account. Uses the
336    * internal burn function.
337    * @param account The account whose tokens will be burnt.
338    * @param value The amount that will be burnt.
339    */
340   function _burnFrom(address account, uint256 value) internal {
341     require(value <= _allowed[account][msg.sender]);
342 
343     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
344     // this function needs to emit an event with the updated approval.
345     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
346       value);
347     _burn(account, value);
348   }
349 }
350 
351 contract FabgCoin is ERC20, Ownable {
352     string public name;
353     string public symbol;
354     uint8 public decimals;
355 
356     //tokens per one eth
357     uint256 public rate;
358     uint256 public minimalPayment;
359 
360     bool public isBuyBlocked;
361     address saleAgent;
362     uint256 public totalEarnings;
363 
364     event TokensCreatedWithoutPayment(address Receiver, uint256 Amount);
365     event BoughtTokens(address Receiver, uint256 Amount, uint256 sentWei);
366     event BuyPaused();
367     event BuyUnpaused();
368     event UsagePaused();
369     event UsageUnpaused();
370     event Payment(address payer, uint256 weiAmount);
371 
372     modifier onlySaleAgent() {
373         require(msg.sender == saleAgent);
374         _;
375     }
376 
377     function changeRate(uint256 _rate) public onlyOwner {
378         rate = _rate;
379     }
380 
381     function pauseCustomBuying() public onlyOwner {
382         require(isBuyBlocked == false);
383         isBuyBlocked = true;
384         emit BuyPaused();
385     }
386 
387     function resumeCustomBuy() public onlyOwner {
388         require(isBuyBlocked == true);
389         isBuyBlocked = false;
390         emit BuyUnpaused();
391     }
392 
393     function pauseUsage() public onlyOwner {
394         require(isPaused == false);
395         isPaused = true;
396         emit UsagePaused();
397     }
398 
399     function resumeUsage() public onlyOwner {
400         require(isPaused == true);
401         isPaused = false;
402         emit UsageUnpaused();
403     }
404 
405     function setSaleAgent(address _saleAgent) public onlyOwner {
406         require(saleAgent == address(0));
407         saleAgent = _saleAgent;
408     }
409 
410     function createTokenWithoutPayment(address _receiver, uint256 _amount) public onlyOwner {
411         _mint(_receiver, _amount);
412 
413         emit TokensCreatedWithoutPayment(_receiver, _amount);
414     }
415 
416     function createTokenViaSaleAgent(address _receiver, uint256 _amount) public onlySaleAgent {
417         _mint(_receiver, _amount);
418     }
419 
420     function buyTokens() public payable {
421         require(msg.value >= minimalPayment);
422         require(isBuyBlocked == false);
423 
424         uint256 amount = msg.value.mul(rate); 
425         _mint(msg.sender, amount);
426 
427         totalEarnings = totalEarnings.add(amount.div(rate));
428 
429         emit BoughtTokens(msg.sender, amount, msg.value);
430     }
431 }
432 
433 contract FabgCoinMarketPack is FabgCoin {
434     using SafeMath for uint256;
435 
436     bool isPausedForSale;
437 
438     /**
439      * maping for store amount of tokens to amount of wei per that pack
440      */
441     mapping(uint256 => uint256) packsToWei;
442     uint256[] packs;
443     uint256 public totalEarningsForPackSale;
444     address adminsWallet;
445 
446     event MarketPaused();
447     event MarketUnpaused();
448     event PackCreated(uint256 TokensAmount, uint256 WeiAmount);
449     event PackDeleted(uint256 TokensAmount);
450     event PackBought(address Buyer, uint256 TokensAmount, uint256 WeiAmount);
451     event Withdrawal(address receiver, uint256 weiAmount);
452 
453     constructor() public {  
454         name = "FabgCoin";
455         symbol = "FABG";
456         decimals = 18;
457         rate = 100;
458         minimalPayment = 1 ether / 100;
459         isBuyBlocked = true;
460     }
461 
462     /**
463      * @dev set address for wallet for withdrawal
464      * @param _newMultisig new address for withdrawals
465      */
466     function setAddressForPayment(address _newMultisig) public onlyOwner {
467         adminsWallet = _newMultisig;
468     }
469 
470     /**
471      * @dev fallback function which can receive ether with no actions
472      */
473     function() public payable {
474        emit Payment(msg.sender, msg.value);
475     }
476 
477     /**
478      * @dev pause possibility of buying pack of tokens
479      */
480     function pausePackSelling() public onlyOwner {
481         require(isPausedForSale == false);
482         isPausedForSale = true;
483         emit MarketPaused();
484     }
485 
486     /**
487      * @dev return possibility of buying pack of tokens
488      */
489     function unpausePackSelling() public onlyOwner {
490         require(isPausedForSale == true);
491         isPausedForSale = false;
492         emit MarketUnpaused();
493     }    
494 
495     /**
496      * @dev add pack to list of possible to buy
497      * @param _amountOfTokens amount of tokens in pack
498      * @param _amountOfWei amount of wei for buying 1 pack
499      */
500     function addPack(uint256 _amountOfTokens, uint256 _amountOfWei) public onlyOwner {
501         require(packsToWei[_amountOfTokens] == 0);
502         require(_amountOfTokens != 0);
503         require(_amountOfWei != 0);
504         
505         packs.push(_amountOfTokens);
506         packsToWei[_amountOfTokens] = _amountOfWei;
507 
508         emit PackCreated(_amountOfTokens, _amountOfWei);
509     }
510 
511     /**
512      * @dev buying existing pack of tokens
513      * @param _amountOfTokens amount of tokens in pack for buying
514      */
515     function buyPack(uint256 _amountOfTokens) public payable {
516         require(packsToWei[_amountOfTokens] > 0);
517         require(msg.value >= packsToWei[_amountOfTokens]);
518         require(isPausedForSale == false);
519 
520         _mint(msg.sender, _amountOfTokens * 1 ether);
521         (msg.sender).transfer(msg.value.sub(packsToWei[_amountOfTokens]));
522 
523         totalEarnings = totalEarnings.add(packsToWei[_amountOfTokens]);
524         totalEarningsForPackSale = totalEarningsForPackSale.add(packsToWei[_amountOfTokens]);
525 
526         emit PackBought(msg.sender, _amountOfTokens, packsToWei[_amountOfTokens]);
527     }
528 
529     /**
530      * @dev withdraw all ether from this contract to sender's wallet
531      */
532     function withdraw() public onlyOwner {
533         require(adminsWallet != address(0), "admins wallet couldn't be 0x0");
534 
535         uint256 amount = address(this).balance;  
536         (adminsWallet).transfer(amount);
537         emit Withdrawal(adminsWallet, amount);
538     }
539 
540     /**
541      * @dev delete pack from selling
542      * @param _amountOfTokens which pack delete
543      */
544     function deletePack(uint256 _amountOfTokens) public onlyOwner {
545         require(packsToWei[_amountOfTokens] != 0);
546         require(_amountOfTokens != 0);
547 
548         packsToWei[_amountOfTokens] = 0;
549 
550         uint256 index;
551 
552         for(uint256 i = 0; i < packs.length; i++) {
553             if(packs[i] == _amountOfTokens) {
554                 index = i;
555                 break;
556             }
557         }
558 
559         for(i = index; i < packs.length - 1; i++) {
560             packs[i] = packs[i + 1];
561         }
562         packs.length--;
563 
564         emit PackDeleted(_amountOfTokens);
565     }
566 
567     /**
568      * @dev get list of all available packs
569      * @return uint256 array of packs
570      */
571     function getAllPacks() public view returns (uint256[]) {
572         return packs;
573     }
574 
575     /**
576      * @dev get price of current pack in wei
577      * @param _amountOfTokens current pack for price
578      * @return uint256 amount of wei for buying
579      */
580     function getPackPrice(uint256 _amountOfTokens) public view returns (uint256) {
581         return packsToWei[_amountOfTokens];
582     }
583 }