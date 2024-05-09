1 pragma solidity ^0.4.19;
2 
3 /*************************************************************************
4  * import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol" : start
5  *************************************************************************/
6 
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
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
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     emit OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 /*************************************************************************
48  * import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol" : end
49  *************************************************************************/
50 /*************************************************************************
51  * import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol" : start
52  *************************************************************************/
53 
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   /**
84   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 /*************************************************************************
101  * import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol" : end
102  *************************************************************************/
103 /*************************************************************************
104  * import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol" : start
105  *************************************************************************/
106 
107 /*************************************************************************
108  * import "./StandardToken.sol" : start
109  *************************************************************************/
110 
111 /*************************************************************************
112  * import "./BasicToken.sol" : start
113  *************************************************************************/
114 
115 
116 /*************************************************************************
117  * import "./ERC20Basic.sol" : start
118  *************************************************************************/
119 
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 /*************************************************************************
133  * import "./ERC20Basic.sol" : end
134  *************************************************************************/
135 
136 
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   uint256 totalSupply_;
148 
149   /**
150   * @dev total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     emit Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public view returns (uint256 balance) {
178     return balances[_owner];
179   }
180 
181 }
182 /*************************************************************************
183  * import "./BasicToken.sol" : end
184  *************************************************************************/
185 /*************************************************************************
186  * import "./ERC20.sol" : start
187  *************************************************************************/
188 
189 
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender) public view returns (uint256);
198   function transferFrom(address from, address to, uint256 value) public returns (bool);
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 /*************************************************************************
203  * import "./ERC20.sol" : end
204  *************************************************************************/
205 
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * @dev https://github.com/ethereum/EIPs/issues/20
212  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  */
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    *
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(address _owner, address _spender) public view returns (uint256) {
260     return allowed[_owner][_spender];
261   }
262 
263   /**
264    * @dev Increase the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _addedValue The amount of tokens to increase the allowance by.
272    */
273   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
274     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    *
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 /*************************************************************************
302  * import "./StandardToken.sol" : end
303  *************************************************************************/
304 
305 
306 
307 /**
308  * @title Mintable token
309  * @dev Simple ERC20 Token example, with mintable token creation
310  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
311  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
312  */
313 contract MintableToken is StandardToken, Ownable {
314   event Mint(address indexed to, uint256 amount);
315   event MintFinished();
316 
317   bool public mintingFinished = false;
318 
319 
320   modifier canMint() {
321     require(!mintingFinished);
322     _;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
332     totalSupply_ = totalSupply_.add(_amount);
333     balances[_to] = balances[_to].add(_amount);
334     emit Mint(_to, _amount);
335     emit Transfer(address(0), _to, _amount);
336     return true;
337   }
338 
339   /**
340    * @dev Function to stop minting new tokens.
341    * @return True if the operation was successful.
342    */
343   function finishMinting() onlyOwner canMint public returns (bool) {
344     mintingFinished = true;
345     emit MintFinished();
346     return true;
347   }
348 }
349 /*************************************************************************
350  * import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol" : end
351  *************************************************************************/
352 
353 /*************************************************************************
354  * import "../node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol" : start
355  *************************************************************************/
356 
357 
358 /*************************************************************************
359  * import "../../lifecycle/Pausable.sol" : start
360  *************************************************************************/
361 
362 
363 
364 
365 
366 /**
367  * @title Pausable
368  * @dev Base contract which allows children to implement an emergency stop mechanism.
369  */
370 contract Pausable is Ownable {
371   event Pause();
372   event Unpause();
373 
374   bool public paused = false;
375 
376 
377   /**
378    * @dev Modifier to make a function callable only when the contract is not paused.
379    */
380   modifier whenNotPaused() {
381     require(!paused);
382     _;
383   }
384 
385   /**
386    * @dev Modifier to make a function callable only when the contract is paused.
387    */
388   modifier whenPaused() {
389     require(paused);
390     _;
391   }
392 
393   /**
394    * @dev called by the owner to pause, triggers stopped state
395    */
396   function pause() onlyOwner whenNotPaused public {
397     paused = true;
398     emit Pause();
399   }
400 
401   /**
402    * @dev called by the owner to unpause, returns to normal state
403    */
404   function unpause() onlyOwner whenPaused public {
405     paused = false;
406     emit Unpause();
407   }
408 }
409 /*************************************************************************
410  * import "../../lifecycle/Pausable.sol" : end
411  *************************************************************************/
412 
413 
414 /**
415  * @title Pausable token
416  * @dev StandardToken modified with pausable transfers.
417  **/
418 contract PausableToken is StandardToken, Pausable {
419 
420   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
421     return super.transfer(_to, _value);
422   }
423 
424   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
429     return super.approve(_spender, _value);
430   }
431 
432   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
433     return super.increaseApproval(_spender, _addedValue);
434   }
435 
436   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
437     return super.decreaseApproval(_spender, _subtractedValue);
438   }
439 }
440 /*************************************************************************
441  * import "../node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol" : end
442  *************************************************************************/
443 /*************************************************************************
444  * import "../node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol" : start
445  *************************************************************************/
446 
447 
448 
449 /*************************************************************************
450  * import "../token/ERC20/SafeERC20.sol" : start
451  *************************************************************************/
452 
453 
454 
455 
456 
457 /**
458  * @title SafeERC20
459  * @dev Wrappers around ERC20 operations that throw on failure.
460  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
461  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
462  */
463 library SafeERC20 {
464   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
465     assert(token.transfer(to, value));
466   }
467 
468   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
469     assert(token.transferFrom(from, to, value));
470   }
471 
472   function safeApprove(ERC20 token, address spender, uint256 value) internal {
473     assert(token.approve(spender, value));
474   }
475 }
476 /*************************************************************************
477  * import "../token/ERC20/SafeERC20.sol" : end
478  *************************************************************************/
479 
480 
481 /**
482  * @title Contracts that should be able to recover tokens
483  * @author SylTi
484  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
485  * This will prevent any accidental loss of tokens.
486  */
487 contract CanReclaimToken is Ownable {
488   using SafeERC20 for ERC20Basic;
489 
490   /**
491    * @dev Reclaim all ERC20Basic compatible tokens
492    * @param token ERC20Basic The address of the token contract
493    */
494   function reclaimToken(ERC20Basic token) external onlyOwner {
495     uint256 balance = token.balanceOf(this);
496     token.safeTransfer(owner, balance);
497   }
498 
499 }
500 /*************************************************************************
501  * import "../node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol" : end
502  *************************************************************************/
503 
504 
505 contract CanReclaimEther is Ownable {
506   function claim() public onlyOwner {
507     owner.transfer(this.balance);
508   }
509 }
510 
511 
512 contract ZNA is StandardToken, Ownable, PausableToken {
513 
514     using SafeMath for uint256;
515 
516     uint256 public MAX_TOTAL;
517 
518     function ZNA (uint256 maxAmount) public {
519       MAX_TOTAL = maxAmount;
520     }
521 
522    /**
523     * @dev Function to mint tokens
524     * @param _to The address that will receive the minted tokens.
525     * @param _amount The amount of tokens to mint.
526     * @return A boolean that indicates if the operation was successful.
527     */
528    function mint(address _to, uint256 _amount)
529    public onlyOwner returns (bool) {
530      totalSupply_ = totalSupply_.add(_amount);
531      require(totalSupply_ <= MAX_TOTAL);
532      balances[_to] = balances[_to].add(_amount);
533      emit Transfer(address(0), _to, _amount);
534      return true;
535    }
536 
537    string public name = "ZNA Token";
538    string public symbol = "ZNA";
539    uint8  public decimals = 18;
540 }
541 
542 
543 contract ZenomeCrowdsale is Ownable, CanReclaimToken, CanReclaimEther {
544 
545   using SafeMath for uint256;
546 
547   struct TokenPool {
548     address minter;
549     uint256 amount;
550     uint256 safecap;
551     uint256 total;
552   }
553 
554   ZNA public token;
555 
556   TokenPool public for_sale;
557   TokenPool public for_rewards;
558   TokenPool public for_longterm;
559   /* solhint-disable */
560   /* solhint-enable */
561 
562   function ZenomeCrowdsale () public {
563     for_sale.total = 1575*10**22;
564     for_rewards.total = 1050*10**22;
565     for_longterm.total = 875*10**22;
566 
567     uint256 MAX_TOTAL = for_sale.total
568       .add(for_rewards.total)
569       .add(for_longterm.total);
570 
571     token = new ZNA(MAX_TOTAL);
572   }
573 
574  /**
575   *  Setting Minter interface
576   */
577   function setSaleMinter (address minter, uint safecap) public onlyOwner { setMinter(for_sale, minter, safecap); }
578 
579   function setRewardMinter (address minter, uint safecap) public onlyOwner {
580     require(safecap <= for_sale.amount);
581     setMinter(for_rewards, minter, safecap);
582   }
583 
584   function setLongtermMinter (address minter, uint safecap) public onlyOwner {
585     require(for_sale.amount > 1400*10**22);
586     setMinter(for_longterm, minter, safecap);
587   }
588 
589   function transferTokenOwnership (address newOwner) public onlyOwner {
590     require(newOwner != address(0));
591     token.transferOwnership(newOwner);
592   }
593 
594   function pauseToken() public onlyOwner { token.pause(); }
595   function unpauseToken() public onlyOwner { token.unpause(); }
596 
597   /**
598    *  Minter's interface
599    */
600   function mintSoldTokens (address to, uint256 amount) public {
601     mintTokens(for_sale, to, amount);
602   }
603 
604   function mintRewardTokens (address to, uint256 amount) public {
605     mintTokens(for_rewards, to, amount);
606   }
607 
608   function mintLongTermTokens (address to, uint256 amount) public {
609     mintTokens(for_longterm, to, amount);
610   }
611 
612   /**
613    * INTERNAL FUNCTIONS
614 
615    "Of course, calls to internal functions use the internal calling convention,
616     which means that all internal types can be passed and memory types will be
617     passed by reference and not copied."
618 
619     https://solidity.readthedocs.io/en/develop/contracts.html#libraries
620   */
621   /**
622    *  Set minter and a safe cap in a single call.
623    *  IT MUST NOT BE VIEW!
624    */
625   function setMinter (TokenPool storage pool, address minter, uint256 safecap)
626   internal onlyOwner {
627     require(safecap <= pool.total);
628     pool.minter = minter;
629     pool.safecap = safecap;
630   }
631 
632   /**
633    *
634    */
635   function mintTokens (TokenPool storage pool, address to, uint256 amount )
636   internal {
637     require(msg.sender == pool.minter);
638     uint256 new_amount = pool.amount.add(amount);
639     require(new_amount <= pool.safecap);
640 
641     pool.amount = new_amount;
642     token.mint(to, amount);
643   }
644 
645 }