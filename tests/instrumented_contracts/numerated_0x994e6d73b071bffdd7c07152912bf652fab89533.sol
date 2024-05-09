1 pragma solidity ^0.4.15;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120 
121     uint256 _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
124     // require (_value <= _allowance);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    */
165   function increaseApproval (address _spender, uint _addedValue)
166     returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval (address _spender, uint _subtractedValue)
173     returns (bool success) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184 }
185 
186 
187 /**
188  * @title Ownable
189  * @dev The Ownable contract has an owner address, and provides basic authorization control
190  * functions, this simplifies the implementation of "user permissions".
191  */
192 contract Ownable {
193   address public owner;
194 
195 
196   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() {
204     owner = msg.sender;
205   }
206 
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216 
217   /**
218    * @dev Allows the current owner to transfer control of the contract to a newOwner.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) onlyOwner public {
222     require(newOwner != address(0));
223     OwnershipTransferred(owner, newOwner);
224     owner = newOwner;
225   }
226 
227 }
228 
229 
230 
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(0x0, _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 
277 /**
278  * @title Pausable
279  * @dev Base contract which allows children to implement an emergency stop mechanism.
280  */
281 contract Pausable is Ownable {
282   event Pause();
283   event Unpause();
284 
285   bool public paused = false;
286 
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is not paused.
290    */
291   modifier whenNotPaused() {
292     require(!paused);
293     _;
294   }
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is paused.
298    */
299   modifier whenPaused() {
300     require(paused);
301     _;
302   }
303 
304   /**
305    * @dev called by the owner to pause, triggers stopped state
306    */
307   function pause() onlyOwner whenNotPaused public {
308     paused = true;
309     Pause();
310   }
311 
312   /**
313    * @dev called by the owner to unpause, returns to normal state
314    */
315   function unpause() onlyOwner whenPaused public {
316     paused = false;
317     Unpause();
318   }
319 }
320 
321 
322 /**
323  * @title PreSale ZNA token
324  * @dev The minting functionality is reimplemented, as opposed to inherited
325  *   from MintableToken, to allow for giving right to mint to arbitery account.
326  */
327 contract PreSaleZNA is StandardToken, Ownable, Pausable {
328 
329   // Disable transfer unless explicitly enabled
330   function PreSaleZNA(){ paused = true; }
331 
332   // The address of the contract or user that is allowed to mint tokens.
333   address public minter;
334 
335   /**
336    * @dev Set the address of the minter
337    * @param _minter address to be set as minter.
338    *
339    * Note: We also need to implement "mint" method.
340    */
341   function setMinter(address _minter) onlyOwner {
342       minter = _minter;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(address _to, uint256 _amount) public returns (bool) {
352     require(msg.sender == minter);
353 
354     totalSupply = totalSupply.add(_amount);
355     balances[_to] = balances[_to].add(_amount);
356 
357     Transfer(0x0, _to, _amount);
358     return true;
359   }
360 
361 
362   /**
363    * @dev account for paused/unpaused-state.
364    */
365   function transfer(address _to, uint256 _value)
366   public whenNotPaused returns (bool) {
367     return super.transfer(_to, _value);
368   }
369 
370   function transferFrom(address _from, address _to, uint256 _value)
371   public whenNotPaused returns (bool) {
372     return super.transferFrom(_from, _to, _value);
373   }
374 
375 
376   /**
377    * @dev Token meta-information
378    * @param name of the token as it's shown to user
379    * @param symbol of the token
380    * @param decimals number
381    * Number of indivisible tokens that make up 1 ZNA = 10^{decimals}
382    */
383   string public constant name = "Presale ZNA Token";
384   string public constant symbol = "pZNA";
385   uint8  public constant decimals = 18;
386 }
387 
388 
389 /**
390  * @title Zenome Crowdsale contract
391  * @dev Govern the presale:
392  *   1) Taking place in a specific limited period of time.
393  *   2) Having HARDCAP value set --- a number of sold tokens to end the pre-sale
394  *
395  * Owner can change time parameters at any time --- just in case of emergency
396  * Owner can change minter at any time --- just in case of emergency
397  *
398  * !!! There is no way to change the address of the wallet !!!
399  */
400 contract ZenomeCrowdSale is Ownable {
401 
402     // Use SafeMath library to provide methods for uint256-type vars.
403     using SafeMath for uint256;
404 
405     // The hardcoded address of wallet
406     address public wallet;
407 
408     // The address of presale token
409     PreSaleZNA public token;// = new PreSaleZNA();
410 
411     // The accounting mapping to store information on the amount of
412     // bonus tokens that should be given in case of successful presale.
413     mapping(address => uint256) bonuses;
414 
415     /**
416      * @dev Variables
417      *
418      * @public START_TIME uint the time of the start of the sale
419      * @public CLOSE_TIME uint the time of the end of the sale
420      * @public HARDCAP uint256 if @HARDCAP is reached, presale stops
421      * @public the amount of indivisible quantities (=10^18 ZBA) given for 1 wie
422      */
423     uint public START_TIME = 1508256000;
424     uint public CLOSE_TIME = 1508860800;
425     uint256 public HARDCAP = 3200000000000000000000000;
426     uint256 public exchangeRate = 966;
427 
428 
429     /**
430      * Fallback function
431      * @dev The contracts are prevented from using fallback function.
432      *   That prevents loosing control of tokens that will eventually get
433      *      attributed to the contract, not the user
434      *   To buy tokens from the wallet (that is a contract)
435      *      user has to specify beneficiary of tokens using buyTokens method.
436      */
437     function () payable {
438       require(msg.sender == tx.origin);
439       buyTokens(msg.sender);
440     }
441 
442     /**
443      * @dev A function to withdraw all funds.
444      *   Normally, contract should not have ether at all.
445      */
446     function withdraw() onlyOwner {
447       wallet.transfer(this.balance);
448     }
449 
450     /**
451      * @dev The constructor sets the tokens address
452      * @param _token address
453      */
454     function ZenomeCrowdSale(address _token, address _wallet) {
455       token  = PreSaleZNA(_token);
456       wallet = _wallet;
457     }
458 
459 
460     /**
461      * event for token purchase logging
462      * @param purchaser who paid for the tokens
463      * @param beneficiary who got the tokens
464      * @param value weis paid for purchase
465      * @param amount amount of tokens purchased
466      */
467     event TokenPurchase(
468       address indexed purchaser,
469       address indexed beneficiary,
470       uint256 value,
471       uint256 amount
472      );
473 
474     /**
475      * event for bonus processing logging
476      * @param beneficiary a user to get bonuses
477      * @param amount bonus tokens given
478      */
479     event TokenBonusGiven(
480       address indexed beneficiary,
481       uint256 amount
482      );
483 
484 
485     /**
486      * @dev Sets the start and end of the sale.
487      * @param _start uint256 start of the sale.
488      * @param _close uint256 end of the sale.
489      */
490     function setTime(uint _start, uint _close) public onlyOwner {
491       require( _start < _close );
492       START_TIME = _start;
493       CLOSE_TIME = _close;
494     }
495 
496     /**
497      * @dev Sets exhange rate, ie amount of tokens (10^{-18}ZNA) for 1 wie.
498      * @param _exchangeRate uint256 new exhange rate.
499      */
500     function setExchangeRate(uint256 _exchangeRate) public onlyOwner  {
501       require(now < START_TIME);
502       exchangeRate = _exchangeRate;
503     }
504 
505 
506     /**
507      * @dev Buy tokens for all sent ether.
508      *      Tokens will be added to beneficiary's account
509      * @param beneficiary address the owner of bought tokens.
510      */
511     function buyTokens(address beneficiary) payable {
512 
513       uint256 total = token.totalSupply();
514       uint256 amount = msg.value;
515       require(amount > 0);
516 
517       // Check that hardcap not reached, and sale-time.
518       require(total < HARDCAP);
519       require(now >= START_TIME);
520       require(now <  CLOSE_TIME);
521 
522       // Mint tokens bought for all sent ether to beneficiary
523       uint256 tokens = amount.mul(exchangeRate);
524       token.mint(beneficiary, tokens);
525       TokenPurchase(msg.sender, beneficiary,amount, tokens);
526 
527       // Calcualate the corresponding bonus tokens,
528       //  that can be given in case of successful pre-sale
529       uint256 _bonus = tokens.div(4);
530       bonuses[beneficiary] = bonuses[beneficiary].add(_bonus);
531 
532       // Finally, sent all the money to wallet
533       wallet.transfer(amount);
534     }
535 
536 
537     /**
538      * @dev Process bonus tokens for beneficiary in case of all tokens sold.
539      * @param beneficiary address the user's address to process.
540      *
541      * Everyone can call this method for any beneficiary:
542      *  1) Method (code) does not depend on msg.sender =>
543      *         => side effects don't depend on the caller
544      *  2) Calling method for beneficiary is either positive or neutral.
545      */
546     function transferBonuses(address beneficiary) {
547       // Checks that sale has successfully ended by having all tokens sold.
548       uint256 total = token.totalSupply();
549       require( total >= HARDCAP );
550 
551       // Since the number of bonus tokens that are intended for beneficiary
552       //    was pre-calculated beforehand, set variable "tokens" to this value.
553       uint256 tokens = bonuses[beneficiary];
554       // Chech if there are tokens to give as bonuses
555       require( tokens > 0 );
556 
557       // If so, make changes the accounting mapping. Then mint bonus tokens
558       bonuses[beneficiary] = 0;
559       token.mint(beneficiary, tokens);
560 
561       // After all, log event.
562       TokenBonusGiven(beneficiary, tokens);
563     }
564 }