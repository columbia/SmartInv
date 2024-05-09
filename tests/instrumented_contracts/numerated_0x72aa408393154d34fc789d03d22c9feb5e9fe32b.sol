1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to relinquish control of the contract.
83    */
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address _newOwner) public onlyOwner {
94     _transferOwnership(_newOwner);
95   }
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address _newOwner) internal {
102     require(_newOwner != address(0));
103     emit OwnershipTransferred(owner, _newOwner);
104     owner = _newOwner;
105   }
106 }
107 
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender)
117     public view returns (uint256);
118 
119   function transferFrom(address from, address to, uint256 value)
120     public returns (bool);
121 
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * @dev https://github.com/ethereum/EIPs/issues/20
179  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(
193     address _from,
194     address _to,
195     uint256 _value
196   )
197     public
198     returns (bool)
199   {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(
234     address _owner,
235     address _spender
236    )
237     public
238     view
239     returns (uint256)
240   {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(
255     address _spender,
256     uint _addedValue
257   )
258     public
259     returns (bool)
260   {
261     allowed[msg.sender][_spender] = (
262       allowed[msg.sender][_spender].add(_addedValue));
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 /**
297  * @title Mintable token
298  * @dev Simple ERC20 Token example, with mintable token creation
299  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
300  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
301  */
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   modifier hasMintPermission() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   /**
320    * @dev Function to mint tokens
321    * @param _to The address that will receive the minted tokens.
322    * @param _amount The amount of tokens to mint.
323    * @return A boolean that indicates if the operation was successful.
324    */
325   function mint(
326     address _to,
327     uint256 _amount
328   )
329     hasMintPermission
330     canMint
331     public
332     returns (bool)
333   {
334     totalSupply_ = totalSupply_.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     emit Mint(_to, _amount);
337     emit Transfer(address(0), _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner canMint public returns (bool) {
346     mintingFinished = true;
347     emit MintFinished();
348     return true;
349   }
350 }
351 
352 
353 /**
354 * @title OneledgerToken
355 * @dev this is the oneledger token
356 */
357 contract OneledgerToken is MintableToken {
358     using SafeMath for uint256;
359 
360     string public name = "Oneledger Token";
361     string public symbol = "OLT";
362     uint8 public decimals = 18;
363     bool public active = false;
364     /**
365      * @dev restrict function to be callable when token is active
366      */
367     modifier activated() {
368         require(active == true);
369         _;
370     }
371 
372     /**
373      * @dev activate token transfers
374      */
375     function activate() public onlyOwner {
376         active = true;
377     }
378 
379     /**
380      * @dev transfer    ERC20 standard transfer wrapped with `activated` modifier
381      */
382     function transfer(address to, uint256 value) public activated returns (bool) {
383         return super.transfer(to, value);
384     }
385 
386     /**
387      * @dev transfer    ERC20 standard transferFrom wrapped with `activated` modifier
388      */
389     function transferFrom(address from, address to, uint256 value) public activated returns (bool) {
390         return super.transferFrom(from, to, value);
391     }
392 }
393 
394 contract ICO is Ownable {
395     using SafeMath for uint256;
396 
397     struct WhiteListRecord {
398         uint256 offeredWei;
399         uint256 lastPurchasedTimestamp;
400     }
401 
402     OneledgerToken public token;
403     address public wallet; // Address where funds are collected
404     uint256 public rate;   // How many token units a buyer gets per eth
405     mapping (address => WhiteListRecord) public whiteList;
406     uint256 public initialTime;
407     bool public saleClosed;
408     uint256 public weiCap;
409     uint256 public weiRaised;
410 
411     uint256 public TOTAL_TOKEN_SUPPLY = 1000000000 * (10 ** 18);
412 
413     event BuyTokens(uint256 weiAmount, uint256 rate, uint256 token, address beneficiary);
414     event UpdateRate(uint256 rate);
415     event UpdateWeiCap(uint256 weiCap);
416     /**
417     * @dev constructor
418     */
419     constructor(address _wallet, uint256 _rate, uint256 _startDate, uint256 _weiCap) public {
420         require(_rate > 0);
421         require(_wallet != address(0));
422         require(_weiCap.mul(_rate) <= TOTAL_TOKEN_SUPPLY);
423 
424         wallet = _wallet;
425         rate = _rate;
426         initialTime = _startDate;
427         saleClosed = false;
428         weiCap = _weiCap;
429         weiRaised = 0;
430 
431         token = new OneledgerToken();
432     }
433 
434     /**
435      * @dev fallback function ***DO NOT OVERRIDE***
436      */
437     function() external payable {
438         buyTokens();
439     }
440 
441     /**
442      * @dev update the rate
443      */
444     function updateRate(uint256 rate_) public onlyOwner {
445       require(now <= initialTime);
446       rate = rate_;
447       emit UpdateRate(rate);
448     }
449 
450     /**
451      * @dev update the weiCap
452      */
453     function updateWeiCap(uint256 weiCap_) public onlyOwner {
454       require(now <= initialTime);
455       weiCap = weiCap_;
456       emit UpdateWeiCap(weiCap_);
457     }
458 
459     /**
460      * @dev buy tokens
461      */
462     function buyTokens() public payable {
463         validatePurchase(msg.value);
464         uint256 tokenToBuy = msg.value.mul(rate);
465         whiteList[msg.sender].lastPurchasedTimestamp = now;
466         weiRaised = weiRaised.add(msg.value);
467         token.mint(msg.sender, tokenToBuy);
468         wallet.transfer(msg.value);
469         emit BuyTokens(msg.value, rate, tokenToBuy, msg.sender);
470     }
471 
472     /**
473     * @dev add to white list
474     * param addresses the list of address added to white list
475     * param weiPerContributor the wei can be transfer per contributor
476     * param capWei for the user in this list
477     */
478     function addToWhiteList(address[] addresses, uint256 weiPerContributor) public onlyOwner {
479         for (uint32 i = 0; i < addresses.length; i++) {
480             whiteList[addresses[i]] = WhiteListRecord(weiPerContributor, 0);
481         }
482     }
483 
484     /**
485      * @dev mint token to new address, either contract or a wallet
486      * param OneledgerTokenVesting vesting contract
487      * param uint256 total token number to mint
488     */
489     function mintToken(address target, uint256 tokenToMint) public onlyOwner {
490       token.mint(target, tokenToMint);
491     }
492 
493     /**
494      * @dev close the ICO
495      */
496     function closeSale() public onlyOwner {
497         saleClosed = true;
498         if (TOTAL_TOKEN_SUPPLY > token.totalSupply()) {
499           token.mint(owner, TOTAL_TOKEN_SUPPLY.sub(token.totalSupply()));
500         }
501         token.finishMinting();
502         token.transferOwnership(owner);
503     }
504 
505     function validatePurchase(uint256 weiPaid) internal view{
506         require(!saleClosed);
507         require(initialTime <= now);
508         require(whiteList[msg.sender].offeredWei > 0);
509         require(weiPaid <= weiCap.sub(weiRaised));
510         // can only purchase once every 24 hours
511         require(now.sub(whiteList[msg.sender].lastPurchasedTimestamp) > 24 hours);
512         uint256 elapsedTime = now.sub(initialTime);
513         // check day 1 buy limit
514         require(elapsedTime > 24 hours || msg.value <= whiteList[msg.sender].offeredWei);
515         // check day 2 buy limit
516         require(elapsedTime > 48 hours || msg.value <= whiteList[msg.sender].offeredWei.mul(2));
517     }
518 }
519 
520 
521 contract OneledgerTokenVesting is Ownable{
522     using SafeMath for uint256;
523 
524     event Released(uint256 amount);
525 
526     // beneficiary of tokens after they are released
527     address public beneficiary;
528 
529     uint256 public startFrom;
530     uint256 public period;
531     uint256 public tokensReleasedPerPeriod;
532 
533     uint256 public elapsedPeriods;
534 
535     OneledgerToken private token;
536 
537     /**
538      * @dev Creates a vesting contract for OneledgerToken
539      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
540      * @param _startFrom Datetime when the vesting will begin
541      * @param _period The preiod to release the token
542      * @param _tokensReleasedPerPeriod the token to release per period
543      */
544     constructor(
545         address _beneficiary,
546         uint256 _startFrom,
547         uint256 _period,
548         uint256 _tokensReleasedPerPeriod,
549         OneledgerToken _token
550     ) public {
551         require(_beneficiary != address(0));
552         require(_startFrom >= now);
553 
554         beneficiary = _beneficiary;
555         startFrom = _startFrom;
556         period = _period;
557         tokensReleasedPerPeriod = _tokensReleasedPerPeriod;
558         elapsedPeriods = 0;
559         token = _token;
560     }
561 
562     /**
563      *  @dev getToken this may be more convinience for user
564      *        to check if their vesting contract is binded with a right token
565      * return OneledgerToken
566      */
567      function getToken() public view returns(OneledgerToken) {
568        return token;
569      }
570 
571     /**
572      * @dev release
573      * param _token Oneledgertoken that will be released to beneficiary
574      */
575     function release() public {
576         require(msg.sender == owner || msg.sender == beneficiary);
577         require(token.balanceOf(this) >= 0 && now >= startFrom);
578         uint256 elapsedTime = now.sub(startFrom);
579         uint256 periodsInCurrentRelease = elapsedTime.div(period).sub(elapsedPeriods);
580         uint256 tokensReadyToRelease = periodsInCurrentRelease.mul(tokensReleasedPerPeriod);
581         uint256 amountToTransfer = tokensReadyToRelease > token.balanceOf(this) ? token.balanceOf(this) : tokensReadyToRelease;
582         require(amountToTransfer > 0);
583         elapsedPeriods = elapsedPeriods.add(periodsInCurrentRelease);
584         token.transfer(beneficiary, amountToTransfer);
585         emit Released(amountToTransfer);
586     }
587 }