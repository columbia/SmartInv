1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
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
152    * @dev Increase the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _addedValue The amount of tokens to increase the allowance by.
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   /**
168    * @dev Decrease the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197 
198 
199   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   function Ownable() public {
207     owner = msg.sender;
208   }
209 
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(msg.sender == owner);
216     _;
217   }
218 
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226     OwnershipTransferred(owner, newOwner);
227     owner = newOwner;
228   }
229 
230 }
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
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 /**
277  * @title Crowdsale
278  * @dev Crowdsale is a base contract for managing a token crowdsale.
279  * Crowdsales have a start and end timestamps, where investors can make
280  * token purchases and the crowdsale will assign them tokens based
281  * on a token per ETH rate. Funds collected are forwarded to a wallet
282  * as they arrive.
283  */
284 contract Crowdsale {
285   using SafeMath for uint256;
286 
287   // The token being sold
288   MintableToken public token;
289 
290   // start and end timestamps where investments are allowed (both inclusive)
291   uint256 public startTime;
292   uint256 public endTime;
293 
294   // address where funds are collected
295   address public wallet;
296 
297   // how many token units a buyer gets per wei
298   uint256 public rate;
299 
300   // amount of raised money in wei
301   uint256 public weiRaised;
302 
303   /**
304    * event for token purchase logging
305    * @param purchaser who paid for the tokens
306    * @param beneficiary who got the tokens
307    * @param value weis paid for purchase
308    * @param amount amount of tokens purchased
309    */
310   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
311 
312 
313   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
314     require(_startTime >= now);
315     require(_endTime >= _startTime);
316     require(_rate > 0);
317     require(_wallet != address(0));
318 
319     token = createTokenContract();
320     startTime = _startTime;
321     endTime = _endTime;
322     rate = _rate;
323     wallet = _wallet;
324   }
325 
326   // creates the token to be sold.
327   // override this method to have crowdsale of a specific mintable token.
328   function createTokenContract() internal returns (MintableToken) {
329     return new MintableToken();
330   }
331 
332 
333   // fallback function can be used to buy tokens
334   function () external payable {
335     buyTokens(msg.sender);
336   }
337 
338   // low level token purchase function
339   function buyTokens(address beneficiary) public payable {
340     require(beneficiary != address(0));
341     require(validPurchase());
342 
343     uint256 weiAmount = msg.value;
344 
345     // calculate token amount to be created
346     uint256 tokens = weiAmount.mul(rate);
347 
348     // update state
349     weiRaised = weiRaised.add(weiAmount);
350 
351     token.mint(beneficiary, tokens);
352     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
353 
354     forwardFunds();
355   }
356 
357   // send ether to the fund collection wallet
358   // override to create custom fund forwarding mechanisms
359   function forwardFunds() internal {
360     wallet.transfer(msg.value);
361   }
362 
363   // @return true if the transaction can buy tokens
364   function validPurchase() internal view returns (bool) {
365     bool withinPeriod = now >= startTime && now <= endTime;
366     bool nonZeroPurchase = msg.value != 0;
367     return withinPeriod && nonZeroPurchase;
368   }
369 
370   // @return true if crowdsale event has ended
371   function hasEnded() public view returns (bool) {
372     return now > endTime;
373   }
374 
375 
376 }
377 
378 contract DetailedERC20 is ERC20 {
379   string public name;
380   string public symbol;
381   uint8 public decimals;
382 
383   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
384     name = _name;
385     symbol = _symbol;
386     decimals = _decimals;
387   }
388 }
389 
390 /**
391  * @title Capped token
392  * @dev Mintable token with a token cap.
393  */
394 
395 contract CappedToken is MintableToken {
396 
397   uint256 public cap;
398 
399   function CappedToken(uint256 _cap) public {
400     require(_cap > 0);
401     cap = _cap;
402   }
403 
404   /**
405    * @dev Function to mint tokens
406    * @param _to The address that will receive the minted tokens.
407    * @param _amount The amount of tokens to mint.
408    * @return A boolean that indicates if the operation was successful.
409    */
410   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
411     require(totalSupply.add(_amount) <= cap);
412 
413     return super.mint(_to, _amount);
414   }
415 
416 }
417 
418 /**
419  * @title Burnable Token
420  * @dev Token that can be irreversibly burned (destroyed).
421  */
422 contract BurnableToken is BasicToken {
423 
424     event Burn(address indexed burner, uint256 value);
425 
426     /**
427      * @dev Burns a specific amount of tokens.
428      * @param _value The amount of token to be burned.
429      */
430     function burn(uint256 _value) public {
431         require(_value <= balances[msg.sender]);
432         // no need to require value <= totalSupply, since that would imply the
433         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
434 
435         address burner = msg.sender;
436         balances[burner] = balances[burner].sub(_value);
437         totalSupply = totalSupply.sub(_value);
438         Burn(burner, _value);
439     }
440 }
441 
442 /**
443  * @title SafeERC20
444  * @dev Wrappers around ERC20 operations that throw on failure.
445  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
446  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
447  */
448 library SafeERC20 {
449   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
450     assert(token.transfer(to, value));
451   }
452 
453   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
454     assert(token.transferFrom(from, to, value));
455   }
456 
457   function safeApprove(ERC20 token, address spender, uint256 value) internal {
458     assert(token.approve(spender, value));
459   }
460 }
461 
462 //it mimic the TokenTimelock
463 
464 contract HTLC {
465 
466     using SafeERC20 for ERC20Basic;
467 
468     // ERC20 basic token contract being held
469     ERC20Basic public token;
470 
471     // beneficiary of tokens being released by hashing
472     address public beneficiary;
473 
474     // timestamp when lock is timeout
475     uint256 public releaseTime;
476 
477     // sha256 hash to release
478     bytes32 sha256hash;
479 
480     function HTLC(ERC20Basic _token, bytes32 _hash, address _beneficiary, uint256 _releaseTime) public {
481         require(_releaseTime > now);
482         token = _token;
483         beneficiary = _beneficiary;
484         releaseTime = _releaseTime;
485         sha256hash = _hash;
486     }
487 
488     /**
489      * @notice Transfer to the specified address if anyone can provide the correct preimage.
490      */
491     function redeem(bytes preimage) public {
492         require(sha256(preimage) == sha256hash);
493 
494         uint256 amount = token.balanceOf(this);
495         require(amount > 0);
496 
497         token.safeTransfer(beneficiary, amount);
498         selfdestruct(msg.sender);
499     }
500 
501     /** 
502      * @notice Default action when timeout: override this.
503      */
504     function onTimeout(uint256) internal {
505         selfdestruct(msg.sender);
506     }
507 
508     /**
509      * @notice When timeout. for default action, the token in it will lost forever
510      */
511     function release() public {
512         require(now >= releaseTime);
513 
514         uint256 amount = token.balanceOf(this);
515         require(amount > 0);
516 
517         onTimeout(amount);
518     }
519 
520 }
521 
522 contract VCBToken is CappedToken, BurnableToken, DetailedERC20 {
523 
524     using SafeMath for uint256;
525 
526     uint8 constant DECIMALS = 18;
527     uint  constant TOTALTOKEN = 1 * 10 ** (8 + uint(DECIMALS));
528     string constant NAME = "ValueCyber Token";
529     string constant SYM = "VCT";
530 
531     address constant PRESALE = 0x638a3C7dF9D1B3A56E19B92bE07eCC84b6475BD6;
532     uint  constant PRESALETOKEN = 55 * 10 ** (6 + uint(DECIMALS));
533 
534     function VCBToken() CappedToken(TOTALTOKEN) DetailedERC20 (NAME, SYM, DECIMALS) public {
535         
536         balances[PRESALE] = PRESALETOKEN;
537         totalSupply = totalSupply.add(PRESALETOKEN);
538     }
539 
540 }
541 
542 contract VCBCrowdSale is Crowdsale, Ownable {
543 
544     using SafeMath for uint256;
545 
546     uint  constant RATIO = 800;
547     uint8 constant RATIODENO = 100;
548     uint constant SALELASTFOR = 50 days;
549     address constant FUNDWALLET = 0x622969e0928fa6bEeda9f26F8a60D0b22Db7E6f1;
550 
551     mapping(address => uint8) giftList;
552 
553     event CrowdsaleFinalized();
554     /**
555     * event for token gift logging
556     * @param beneficiary who got the gifted tokens
557     * @param amount amount of tokens gifted
558     */
559     event TokenGift(address indexed beneficiary, uint256 amount);
560 
561     function VCBCrowdSale() Crowdsale(now, now + SALELASTFOR, RATIO, FUNDWALLET) public {
562     }
563 
564     function createTokenContract() internal returns (MintableToken) {
565         return new VCBToken();
566     }
567 
568     //our crowdsale can stop at anytime, and then the totally crowsale contract is disappear
569     function finalize(address _finaladdr) onlyOwner public {
570         token.finishMinting();
571         CrowdsaleFinalized();
572 
573         address finaladdr = FUNDWALLET;
574         if (_finaladdr != address(0)) {
575             finaladdr = _finaladdr;
576         }
577 
578         selfdestruct(finaladdr);
579     }  
580 
581     function giftTokens(address beneficiary) internal {
582         uint256 weiAmount = msg.value;
583 
584         // calculate token amount to be created
585         uint256 gifttokens = weiAmount.mul(giftList[beneficiary]).mul(rate).div(RATIODENO);
586         if (gifttokens > 0) {
587 
588             //if gift token can't be sent, contract still fails
589             token.mint(beneficiary, gifttokens);
590             TokenGift(beneficiary, gifttokens);
591         }
592 
593     }
594 
595     // override token purchase to send additional token for registered address
596     function buyTokens(address beneficiary) public payable {
597 
598         super.buyTokens(beneficiary);
599 
600         //if address is in discount list, we gift it more tokens according to the ratio (in percentage)
601         giftTokens(beneficiary);
602     }
603 
604     function addGift(address beneficiary, uint8 giftratio) onlyOwner public {
605         require(giftratio < RATIODENO);
606         giftList[beneficiary] = giftratio;
607     }
608 
609     /**
610     * @dev Gets the gift ratio of the specified address.
611     * @param _owner The address to query the gift ratio of.
612     * @return An uint8 representing the ratio obtained by the passed address.
613     */
614     function giftRatioOf(address _owner) public view returns (uint8 ratio) {
615         return giftList[_owner];
616     }
617 
618     // directly mint tokens to a HTLC contract
619     function preserveTokens(address preservecontract, uint256 amount) onlyOwner public {        
620         token.mint(preservecontract, amount);
621     }    
622 
623 }
624 
625 contract CrowdSaleHTLC is HTLC {
626     function CrowdSaleHTLC(ERC20Basic _token, bytes32 _hash, address _beneficiary, uint256 _releaseTime) HTLC(_token, _hash, _beneficiary, _releaseTime) public {
627     }
628 
629     function onTimeout(uint256 amount) internal {
630         BurnableToken t = BurnableToken (token);
631         t.burn(amount);
632         super.onTimeout(amount);
633     }
634 
635 }