1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 /**
112  * @title ERC20Basic
113  * @dev Simpler version of ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/179
115  */
116 contract ERC20Basic {
117   function totalSupply() public view returns (uint256);
118   function balanceOf(address who) public view returns (uint256);
119   function transfer(address to, uint256 value) public returns (bool);
120   event Transfer(address indexed from, address indexed to, uint256 value);
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender)
129     public view returns (uint256);
130 
131   function transferFrom(address from, address to, uint256 value)
132     public returns (bool);
133 
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(
205     address _from,
206     address _to,
207     uint256 _value
208   )
209     public
210     returns (bool)
211   {
212     require(_to != address(0));
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     emit Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    *
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(
246     address _owner,
247     address _spender
248    )
249     public
250     view
251     returns (uint256)
252   {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(
267     address _spender,
268     uint _addedValue
269   )
270     public
271     returns (bool)
272   {
273     allowed[msg.sender][_spender] = (
274       allowed[msg.sender][_spender].add(_addedValue));
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
289   function decreaseApproval(
290     address _spender,
291     uint _subtractedValue
292   )
293     public
294     returns (bool)
295   {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     hasMintPermission
342     canMint
343     public
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() onlyOwner canMint public returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 /**
365 * @title OneledgerToken
366 * @dev this is the oneledger token
367 */
368 contract OneledgerToken is MintableToken {
369     using SafeMath for uint256;
370 
371     string public name = "Oneledger Token";
372     string public symbol = "OLT";
373     uint8 public decimals = 18;
374     bool public active = false;
375     /**
376      * @dev restrict function to be callable when token is active
377      */
378     modifier activated() {
379         require(active == true);
380         _;
381     }
382 
383     /**
384      * @dev activate token transfers
385      */
386     function activate() public onlyOwner {
387         active = true;
388     }
389 
390     /**
391      * @dev transfer    ERC20 standard transfer wrapped with `activated` modifier
392      */
393     function transfer(address to, uint256 value) public activated returns (bool) {
394         return super.transfer(to, value);
395     }
396 
397     /**
398      * @dev transfer    ERC20 standard transferFrom wrapped with `activated` modifier
399      */
400     function transferFrom(address from, address to, uint256 value) public activated returns (bool) {
401         return super.transferFrom(from, to, value);
402     }
403 }
404 
405 contract ICO is Ownable {
406     using SafeMath for uint256;
407 
408     struct WhiteListRecord {
409         uint256 offeredWei;
410         uint256 lastPurchasedTimestamp;
411     }
412 
413     OneledgerToken public token;
414     address public wallet; // Address where funds are collected
415     uint256 public rate;   // How many token units a buyer gets per eth
416     mapping (address => WhiteListRecord) public whiteList;
417     uint256 public initialTime;
418     bool public saleClosed;
419     uint256 public weiCap;
420     uint256 public weiRaised;
421 
422     uint256 public TOTAL_TOKEN_SUPPLY = 1000000000 * (10 ** 18);
423 
424     event BuyTokens(uint256 weiAmount, uint256 rate, uint256 token, address beneficiary);
425     event UpdateRate(uint256 rate);
426 
427     /**
428     * @dev constructor
429     */
430     constructor(address _wallet, uint256 _rate, uint256 _startDate, uint256 _weiCap) public {
431         require(_rate > 0);
432         require(_wallet != address(0));
433         require(_weiCap.mul(_rate) <= TOTAL_TOKEN_SUPPLY);
434 
435         wallet = _wallet;
436         rate = _rate;
437         initialTime = _startDate;
438         saleClosed = false;
439         weiCap = _weiCap;
440         weiRaised = 0;
441 
442         token = new OneledgerToken();
443     }
444 
445     /**
446      * @dev fallback function ***DO NOT OVERRIDE***
447      */
448     function() external payable {
449         buyTokens();
450     }
451 
452     /**
453      * @dev update the rate
454      */
455     function updateRate(uint256 rate_) public onlyOwner {
456       require(now <= initialTime);
457       rate = rate_;
458       emit UpdateRate(rate);
459     }
460 
461     /**
462      * @dev buy tokens
463      */
464     function buyTokens() public payable {
465         validatePurchase(msg.value);
466         uint256 tokenToBuy = msg.value.mul(rate);
467         whiteList[msg.sender].lastPurchasedTimestamp = now;
468         weiRaised = weiRaised.add(msg.value);
469         token.mint(msg.sender, tokenToBuy);
470         wallet.transfer(msg.value);
471         emit BuyTokens(msg.value, rate, tokenToBuy, msg.sender);
472     }
473 
474     /**
475     * @dev add to white list
476     * param addresses the list of address added to white list
477     * param weiPerContributor the wei can be transfer per contributor
478     * param capWei for the user in this list
479     */
480     function addToWhiteList(address[] addresses, uint256 weiPerContributor) public onlyOwner {
481         for (uint32 i = 0; i < addresses.length; i++) {
482             whiteList[addresses[i]] = WhiteListRecord(weiPerContributor, 0);
483         }
484     }
485 
486     /**
487      * @dev mint token to new address, either contract or a wallet
488      * param OneledgerTokenVesting vesting contract
489      * param uint256 total token number to mint
490     */
491     function mintToken(address target, uint256 tokenToMint) public onlyOwner {
492       token.mint(target, tokenToMint);
493     }
494 
495     /**
496      * @dev close the ICO
497      */
498     function closeSale() public onlyOwner {
499         saleClosed = true;
500         token.mint(owner, TOTAL_TOKEN_SUPPLY.sub(token.totalSupply()));
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
519 contract OneledgerTokenVesting is Ownable{
520     using SafeMath for uint256;
521 
522     event Released(uint256 amount);
523 
524     // beneficiary of tokens after they are released
525     address public beneficiary;
526 
527     uint256 public startFrom;
528     uint256 public period;
529     uint256 public tokensReleasedPerPeriod;
530 
531     uint256 public elapsedPeriods;
532 
533     OneledgerToken private token;
534 
535     /**
536      * @dev Creates a vesting contract for OneledgerToken
537      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
538      * @param _startFrom Datetime when the vesting will begin
539      * @param _period The preiod to release the token
540      * @param _tokensReleasedPerPeriod the token to release per period
541      */
542     constructor(
543         address _beneficiary,
544         uint256 _startFrom,
545         uint256 _period,
546         uint256 _tokensReleasedPerPeriod,
547         OneledgerToken _token
548     ) public {
549         require(_beneficiary != address(0));
550         require(_startFrom >= now);
551 
552         beneficiary = _beneficiary;
553         startFrom = _startFrom;
554         period = _period;
555         tokensReleasedPerPeriod = _tokensReleasedPerPeriod;
556         elapsedPeriods = 0;
557         token = _token;
558     }
559 
560     /**
561      *  @dev getToken this may be more convinience for user
562      *        to check if their vesting contract is binded with a right token
563      * return OneledgerToken
564      */
565      function getToken() public view returns(OneledgerToken) {
566        return token;
567      }
568 
569     /**
570      * @dev release
571      * param _token Oneledgertoken that will be released to beneficiary
572      */
573     function release() public {
574         require(msg.sender == owner || msg.sender == beneficiary);
575         require(token.balanceOf(this) >= 0 && now >= startFrom);
576         uint256 elapsedTime = now.sub(startFrom);
577         uint256 periodsInCurrentRelease = elapsedTime.div(period).sub(elapsedPeriods);
578         uint256 tokensReadyToRelease = periodsInCurrentRelease.mul(tokensReleasedPerPeriod);
579         uint256 amountToTransfer = tokensReadyToRelease > token.balanceOf(this) ? token.balanceOf(this) : tokensReadyToRelease;
580         require(amountToTransfer > 0);
581         elapsedPeriods = elapsedPeriods.add(periodsInCurrentRelease);
582         token.transfer(beneficiary, amountToTransfer);
583         emit Released(amountToTransfer);
584     }
585 }