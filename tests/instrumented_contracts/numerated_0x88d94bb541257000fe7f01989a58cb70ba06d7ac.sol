1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73     using SafeMath for uint256;
74 
75     mapping(address => uint256) balances;
76 
77     /**
78     * @dev transfer token for a specified address
79     * @param _to The address to transfer to.
80     * @param _value The amount to be transferred.
81     */
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         require(_to != address(0));
84         require(_value <= balances[msg.sender]);
85 
86         // SafeMath.sub will throw if there is not enough balance.
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     /**
94     * @dev Gets the balance of the specified address.
95     * @param _owner The address to query the the balance of.
96     * @return An uint256 representing the amount owned by the passed address.
97     */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102 }
103 
104 
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * @dev https://github.com/ethereum/EIPs/issues/20
111  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20, BasicToken {
114 
115     mapping (address => mapping (address => uint256)) internal allowed;
116 
117 
118     /**
119      * @dev Transfer tokens from one address to another
120      * @param _from address The address which you want to send tokens from
121      * @param _to address The address which you want to transfer to
122      * @param _value uint256 the amount of tokens to be transferred
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138      *
139      * Beware that changing an allowance with this method brings the risk that someone may use both the old
140      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      * @param _spender The address which will spend the funds.
144      * @param _value The amount of tokens to be spent.
145      */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param _owner address The address which owns the funds.
155      * @param _spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163      * approve should be called when allowed[_spender] == 0. To increment
164      * allowed value is better to use this function to avoid 2 calls (and wait until
165      * the first transaction is mined)
166      * From MonolithDAO Token.sol
167      */
168     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175         uint oldValue = allowed[msg.sender][_spender];
176         if (_subtractedValue > oldValue) {
177             allowed[msg.sender][_spender] = 0;
178         } else {
179             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180         }
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185 }
186 
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param _value The amount of token to be burned.
199      */
200     function burn(uint256 _value) public {
201         require(_value > 0);
202         require(_value <= balances[msg.sender]);
203         // no need to require value <= totalSupply, since that would imply the
204         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 }
212 
213 
214 
215 /**
216  * @title Ownable
217  * @dev The Ownable contract has an owner address, and provides basic authorization control
218  * functions, this simplifies the implementation of "user permissions".
219  */
220 contract Ownable {
221     address public owner;
222 
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226 
227     /**
228      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229      * account.
230      */
231     function Ownable() public {
232         owner = msg.sender;
233     }
234 
235 
236     /**
237      * @dev Throws if called by any account other than the owner.
238      */
239     modifier onlyOwner() {
240         require(msg.sender == owner);
241         _;
242     }
243 
244 
245     /**
246      * @dev Allows the current owner to transfer control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function transferOwnership(address newOwner) public onlyOwner {
250         require(newOwner != address(0));
251         OwnershipTransferred(owner, newOwner);
252         owner = newOwner;
253     }
254 
255 }
256 
257 
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
263  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264  */
265 
266 contract MintableToken is StandardToken, Ownable {
267     event Mint(address indexed to, uint256 amount);
268     event MintFinished();
269 
270     bool public mintingFinished = false;
271 
272 
273     modifier canMint() {
274         require(!mintingFinished);
275         _;
276     }
277 
278     /**
279      * @dev Function to mint tokens
280      * @param _to The address that will receive the minted tokens.
281      * @param _amount The amount of tokens to mint.
282      * @return A boolean that indicates if the operation was successful.
283      */
284     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
285         totalSupply = totalSupply.add(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         Mint(_to, _amount);
288         Transfer(address(0), _to, _amount);
289         return true;
290     }
291 
292     /**
293      * @dev Function to stop minting new tokens.
294      * @return True if the operation was successful.
295      */
296     function finishMinting() onlyOwner canMint public returns (bool) {
297         mintingFinished = true;
298         MintFinished();
299         return true;
300     }
301 }
302 
303 
304 
305 contract HireGoToken is MintableToken, BurnableToken {
306 
307     string public constant name = "HireGo";
308     string public constant symbol = "HGO";
309     uint32 public constant decimals = 18;
310 
311     function HireGoToken() public {
312         totalSupply = 100000000E18;  //100m
313         balances[owner] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
314     }
315 
316 }
317 
318 
319 
320 
321 /*
322  * ICO Start time - 1520164800 - March 4, 2018 12:00:00 PM
323  * Default ICO End time - 1527379199 - May 26, 2018 11:59:59 AM
324 */
325 contract HireGoCrowdsale is Ownable {
326 
327     using SafeMath for uint;
328 
329     HireGoToken public token = new HireGoToken();
330     uint totalSupply = token.totalSupply();
331 
332     bool public isRefundAllowed;
333 
334     uint public presaleStartTime;
335     uint public presaleEndTime;
336     uint public icoStartTime;
337     uint public icoEndTime;
338 
339     uint public totalWeiRaised;
340     uint internal weiRaised;
341     uint public hardCap; // amount of ETH collected, which marks end of crowd sale
342     uint public tokensDistributed; // amount of bought tokens
343     uint public foundersTokensUnlockTime;
344 
345 
346     /*         Bonus variables          */
347     uint internal presaleBonus = 135;
348     /* * * * * * * * * * * * * * * * * * */
349 
350     uint public rate; // how many token units a buyer gets per wei
351     uint private icoMinPurchase; // In ETH
352 
353     address[] public investors_number;
354     address private wallet; // address where funds are collected
355 
356     mapping (address => uint) public orderedTokens;
357     mapping (address => uint) contributors;
358 
359     event FundsWithdrawn(address _who, uint256 _amount);
360 
361     modifier hardCapNotReached() {
362         require(totalWeiRaised < hardCap);
363         _;
364     }
365 
366     modifier crowdsaleEnded() {
367         require(now > icoEndTime);
368         _;
369     }
370 
371     modifier foundersTokensUnlocked() {
372         require(now > foundersTokensUnlockTime);
373         _;
374     }
375 
376     modifier crowdsaleInProgress() {
377         bool withinPeriod = ((now >= presaleStartTime && now <=presaleEndTime) || (now >= icoStartTime && now <= icoEndTime));
378         require(withinPeriod);
379         _;
380     }
381 
382     function HireGoCrowdsale(uint _presaleStartTime,  address _wallet) public {
383         require (
384           _presaleStartTime > now
385         );
386 
387         presaleStartTime = _presaleStartTime;
388         presaleEndTime = presaleStartTime.add(4 weeks);
389         icoStartTime = presaleEndTime.add(1 minutes);
390         setIcoEndTime();
391 
392         wallet = _wallet;
393 
394         rate = 250 szabo; // wei per 1 token (0.00025ETH)
395 
396         hardCap = 15000 ether;
397         icoMinPurchase = 50 finney; // 0.05 ETH
398         isRefundAllowed = false;
399     }
400 
401     function setIcoEndTime() internal {
402           icoEndTime = icoStartTime.add(6 weeks);
403           foundersTokensUnlockTime = icoEndTime.add(180 days);
404     }
405 
406     // fallback function can be used to buy tokens
407     function() public payable {
408         buyTokens();
409     }
410 
411     // low level token purchase function
412     function buyTokens() public payable crowdsaleInProgress hardCapNotReached {
413         require(msg.value > 0);
414 
415         // check if the buyer exceeded the funding goal
416         calculatePurchaseAndBonuses(msg.sender, msg.value);
417     }
418 
419     // Returns number of investors
420     function getInvestorCount() public view returns (uint) {
421         return investors_number.length;
422     }
423 
424     // Owner can allow or disallow refunds even if soft cap is reached. Should be used in case KYC is not passed.
425     // WARNING: owner should transfer collected ETH back to contract before allowing to refund, if he already withdrawn ETH.
426     function toggleRefunds() public onlyOwner {
427         isRefundAllowed = !isRefundAllowed;
428     }
429 
430     // Sends ordered tokens to investors after ICO end if soft cap is reached
431     // tokens can be send only if ico has ended
432     function sendOrderedTokens() public onlyOwner crowdsaleEnded {
433         address investor;
434         uint tokensCount;
435         for(uint i = 0; i < investors_number.length; i++) {
436             investor = investors_number[i];
437             tokensCount = orderedTokens[investor];
438             assert(tokensCount > 0);
439             orderedTokens[investor] = 0;
440             token.transfer(investor, tokensCount);
441         }
442     }
443 
444     // Owner can send back collected ETH if soft cap is not reached or KYC is not passed
445     // WARNING: crowdsale contract should have all received funds to return them.
446     // If you have already withdrawn them, send them back to crowdsale contract
447     function refundInvestors() public onlyOwner {
448         require(now >= icoEndTime);
449         require(isRefundAllowed);
450         require(msg.sender.balance > 0);
451 
452         address investor;
453         uint contributedWei;
454         uint tokens;
455         for(uint i = 0; i < investors_number.length; i++) {
456             investor = investors_number[i];
457             contributedWei = contributors[investor];
458             tokens = orderedTokens[investor];
459             if(contributedWei > 0) {
460                 totalWeiRaised = totalWeiRaised.sub(contributedWei);
461                 weiRaised = weiRaised.sub(contributedWei);
462                 if(weiRaised<0){
463                   weiRaised = 0;
464                 }
465                 contributors[investor] = 0;
466                 orderedTokens[investor] = 0;
467                 tokensDistributed = tokensDistributed.sub(tokens);
468                 investor.transfer(contributedWei); // return funds back to contributor
469             }
470         }
471     }
472 
473     // Owner of contract can withdraw collected ETH by calling this function
474     function withdraw() public onlyOwner {
475         uint to_send = weiRaised;
476         weiRaised = 0;
477         FundsWithdrawn(msg.sender, to_send);
478         wallet.transfer(to_send);
479     }
480 
481     function burnUnsold() public onlyOwner crowdsaleEnded {
482         uint tokensLeft = totalSupply.sub(tokensDistributed);
483         token.burn(tokensLeft);
484     }
485 
486     function finishIco() public onlyOwner {
487         icoEndTime = now;
488         foundersTokensUnlockTime = icoEndTime.add(180 days);
489     }
490 
491     function finishPresale() public onlyOwner {
492         presaleEndTime = now;
493     }
494 
495     function distributeForFoundersAndTeam() public onlyOwner foundersTokensUnlocked {
496         uint to_send = 25000000E18; //25m
497         checkAndMint(to_send);
498         token.transfer(wallet, to_send);
499     }
500 
501     function distributeForBountiesAndAdvisors() public onlyOwner {
502         uint to_send = 15000000E18; //15m
503         checkAndMint(to_send);
504         token.transfer(wallet, to_send);
505     }
506 
507     // Used to delay start of ICO
508     function updateIcoStartTime(uint _startTime) public onlyOwner {
509       require (
510         icoStartTime > now &&
511         _startTime > now &&
512         presaleEndTime < _startTime
513       );
514 
515       icoStartTime = _startTime;
516       setIcoEndTime();
517     }
518 
519     // After pre-sale made need to reduced hard cap depending on tokens sold
520     function updateHardCap(uint _newHardCap) public onlyOwner hardCapNotReached {
521         require (
522           _newHardCap < hardCap
523         );
524 
525         hardCap = _newHardCap;
526     }
527 
528     function transferOwnershipToken(address _to) public onlyOwner {
529         token.transferOwnership(_to);
530     }
531 
532     /***************************
533     **  Internal functions    **
534     ***************************/
535 
536     // Calculates purchase conditions and token bonuses
537     function calculatePurchaseAndBonuses(address _beneficiary, uint _weiAmount) internal {
538         if (now >= icoStartTime && now < icoEndTime) require(_weiAmount >= icoMinPurchase);
539 
540         uint cleanWei; // amount of wei to use for purchase excluding change and hardcap overflows
541         uint change;
542         uint _tokens;
543 
544         //check for hardcap overflow
545         if (_weiAmount.add(totalWeiRaised) > hardCap) {
546             cleanWei = hardCap.sub(totalWeiRaised);
547             change = _weiAmount.sub(cleanWei);
548         }
549         else cleanWei = _weiAmount;
550 
551         assert(cleanWei > 4); // 4 wei is a price of minimal fracture of token
552 
553         _tokens = cleanWei.div(rate).mul(1 ether);
554 
555         if (contributors[_beneficiary] == 0) investors_number.push(_beneficiary);
556 
557         _tokens = calculateBonus(_tokens);
558         checkAndMint(_tokens);
559 
560         contributors[_beneficiary] = contributors[_beneficiary].add(cleanWei);
561         weiRaised = weiRaised.add(cleanWei);
562         totalWeiRaised = totalWeiRaised.add(cleanWei);
563         tokensDistributed = tokensDistributed.add(_tokens);
564         orderedTokens[_beneficiary] = orderedTokens[_beneficiary].add(_tokens);
565 
566         if (change > 0) _beneficiary.transfer(change);
567     }
568 
569     // Calculates bonuses based on current stage
570     function calculateBonus(uint _baseAmount) internal returns (uint) {
571         require(_baseAmount > 0);
572 
573         if (now >= presaleStartTime && now < presaleEndTime) {
574             return _baseAmount.mul(presaleBonus).div(100);
575         }
576         else return _baseAmount;
577     }
578 
579     // Checks if more tokens should be minted based on amount of sold tokens, required additional tokens and total supply.
580     // If there are not enough tokens, mint missing tokens
581     function checkAndMint(uint _amount) internal {
582         uint required = tokensDistributed.add(_amount);
583         if(required > totalSupply) token.mint(this, required.sub(totalSupply));
584     }
585 }