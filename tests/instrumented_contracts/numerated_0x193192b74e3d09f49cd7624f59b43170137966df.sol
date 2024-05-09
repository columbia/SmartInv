1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address who) public view returns (uint256);
12 
13     function transfer(address to, uint256 value) public returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24     function allowance(address owner, address spender) public view returns (uint256);
25 
26     function transferFrom(address from, address to, uint256 value) public returns (bool);
27 
28     function approve(address spender, uint256 value) public returns (bool);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         // uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return a / b;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86     using SafeMath for uint256;
87 
88     mapping(address => uint256) balances;
89 
90     uint256 totalSupply_;
91 
92     /**
93     * @dev total number of tokens in existence
94     */
95     function totalSupply() public view returns (uint256) {
96         return totalSupply_;
97     }
98 
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     /**
115     * @dev Gets the balance of the specified address.
116     * @param _owner The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119     function balanceOf(address _owner) public view returns (uint256 balance) {
120         return balances[_owner];
121     }
122 
123 }
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135     mapping(address => mapping(address => uint256)) internal allowed;
136 
137 
138     /**
139      * @dev Transfer tokens from one address to another
140      * @param _from address The address which you want to send tokens from
141      * @param _to address The address which you want to transfer to
142      * @param _value uint256 the amount of tokens to be transferred
143      */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      *
159      * Beware that changing an allowance with this method brings the risk that someone may use both the old
160      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      * @param _spender The address which will spend the funds.
164      * @param _value The amount of tokens to be spent.
165      */
166     function approve(address _spender, uint256 _value) public returns (bool) {
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173      * @dev Function to check the amount of tokens that an owner allowed to a spender.
174      * @param _owner address The address which owns the funds.
175      * @param _spender address The address which will spend the funds.
176      * @return A uint256 specifying the amount of tokens still available for the spender.
177      */
178     function allowance(address _owner, address _spender) public view returns (uint256) {
179         return allowed[_owner][_spender];
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      *
185      * approve should be called when allowed[_spender] == 0. To increment
186      * allowed value is better to use this function to avoid 2 calls (and wait until
187      * the first transaction is mined)
188      * From MonolithDAO Token.sol
189      * @param _spender The address which will spend the funds.
190      * @param _addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198     /**
199      * @dev Decrease the amount of tokens that an owner allowed to a spender.
200      *
201      * approve should be called when allowed[_spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * @param _spender The address which will spend the funds.
206      * @param _subtractedValue The amount of tokens to decrease the allowance by.
207      */
208     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209         uint oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue > oldValue) {
211             allowed[msg.sender][_spender] = 0;
212         } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219 }
220 
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228 
229     address public owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     /**
234      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235      * account.
236      */
237     function Ownable() public {
238         owner = msg.sender;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(msg.sender == owner);
246         _;
247     }
248 
249     /**
250      * @dev Allows the current owner to transfer control of the contract to a newOwner.
251      * @param newOwner The address to transfer ownership to.
252      */
253     function transferOwnership(address newOwner) public onlyOwner {
254         require(newOwner != address(0));
255         OwnershipTransferred(owner, newOwner);
256         owner = newOwner;
257     }
258 
259 }
260 
261 
262 /**
263  * @title Mintable token
264  * @dev Simple ERC20 Token example, with mintable token creation
265  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
266  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
267  */
268 contract MintableToken is StandardToken, Ownable {
269 
270     event Mint(address indexed to, uint256 amount);
271     event MintFinished();
272 
273     bool public mintingFinished = false;
274 
275     modifier canMint() {
276         require(!mintingFinished);
277         _;
278     }
279 
280     /**
281      * @dev Function to mint tokens
282      * @param _to The address that will receive the minted tokens.
283      * @param _amount The amount of tokens to mint.
284      * @return A boolean that indicates if the operation was successful.
285      */
286     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
287         totalSupply_ = totalSupply_.add(_amount);
288         balances[_to] = balances[_to].add(_amount);
289         Mint(_to, _amount);
290         Transfer(address(0), _to, _amount);
291         return true;
292     }
293 
294     /**
295      * @dev Function to stop minting new tokens.
296      * @return True if the operation was successful.
297      */
298     function finishMinting() onlyOwner canMint public returns (bool) {
299         mintingFinished = true;
300         MintFinished();
301         return true;
302     }
303 
304 }
305 
306 
307 /**
308  * @title Burnable Token
309  * @dev Token that can be irreversibly burned (destroyed).
310  */
311 contract BurnableToken is BasicToken {
312 
313     event Burn(address indexed burner, uint256 value);
314 
315     function _burn(address _burner, uint256 _value) internal {
316         require(_value <= balances[_burner]);
317         // no need to require value <= totalSupply, since that would imply the
318         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
319 
320         balances[_burner] = balances[_burner].sub(_value);
321         totalSupply_ = totalSupply_.sub(_value);
322         Burn(_burner, _value);
323         Transfer(_burner, address(0), _value);
324     }
325 
326 }
327 
328 
329 contract DividendPayoutToken is BurnableToken, MintableToken {
330 
331     // Dividends already claimed by investor
332     mapping(address => uint256) public dividendPayments;
333     // Total dividends claimed by all investors
334     uint256 public totalDividendPayments;
335 
336     // invoke this function after each dividend payout
337     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
338         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
339         totalDividendPayments = totalDividendPayments.add(_amount);
340     }
341 
342     //When transfer tokens decrease dividendPayments for sender and increase for receiver
343     function transfer(address _to, uint256 _value) public returns (bool) {
344         // balance before transfer
345         uint256 oldBalanceFrom = balances[msg.sender];
346 
347         // invoke super function with requires
348         bool isTransferred = super.transfer(_to, _value);
349 
350         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
351         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
352         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
353 
354         return isTransferred;
355     }
356 
357     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
358         // balance before transfer
359         uint256 oldBalanceFrom = balances[_from];
360 
361         // invoke super function with requires
362         bool isTransferred = super.transferFrom(_from, _to, _value);
363 
364         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
365         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
366         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
367 
368         return isTransferred;
369     }
370 
371     function burn() public {
372         address burner = msg.sender;
373 
374         // balance before burning tokens
375         uint256 oldBalance = balances[burner];
376 
377         super._burn(burner, oldBalance);
378 
379         uint256 burnedClaims = dividendPayments[burner];
380         dividendPayments[burner] = dividendPayments[burner].sub(burnedClaims);
381         totalDividendPayments = totalDividendPayments.sub(burnedClaims);
382 
383         SaleInterface(owner).refund(burner);
384     }
385 
386 }
387 
388 contract RicoToken is DividendPayoutToken {
389 
390     string public constant name = "Rico";
391 
392     string public constant symbol = "Rico";
393 
394     uint8 public constant decimals = 18;
395 
396 }
397 
398 
399 // Interface for PreSale and CrowdSale contracts with refund function
400 contract SaleInterface {
401 
402     function refund(address _to) public;
403 
404 }
405 
406 
407 contract ReentrancyGuard {
408 
409     /**
410      * @dev We use a single lock for the whole contract.
411      */
412     bool private reentrancy_lock = false;
413 
414     /**
415      * @dev Prevents a contract from calling itself, directly or indirectly.
416      * @notice If you mark a function `nonReentrant`, you should also
417      * mark it `external`. Calling one nonReentrant function from
418      * another is not supported. Instead, you can implement a
419      * `private` function doing the actual work, and a `external`
420      * wrapper marked as `nonReentrant`.
421      */
422     modifier nonReentrant() {
423         require(!reentrancy_lock);
424         reentrancy_lock = true;
425         _;
426         reentrancy_lock = false;
427     }
428 
429 }
430 
431 contract PreSale is Ownable, ReentrancyGuard {
432     using SafeMath for uint256;
433 
434     // The token being sold
435     RicoToken public token;
436     address tokenContractAddress;
437 
438     // start and end timestamps where investments are allowed (both inclusive)
439     uint256 public startTime;
440     uint256 public endTime;
441 
442     // Address where funds are transferred after success end of PreSale
443     address public wallet;
444 
445     // How many token units a buyer gets per wei
446     uint256 public rate;
447 
448     uint256 public minimumInvest; // in wei
449 
450     uint256 public softCap; // in wei
451     uint256 public hardCap; // in wei
452 
453     // investors => amount of money
454     mapping(address => uint) public balances;
455 
456     // Amount of wei raised
457     uint256 public weiRaised;
458 
459     // PreSale bonus in percent
460     uint256 bonusPercent;
461 
462     /**
463      * event for token purchase logging
464      * @param purchaser who paid for the tokens
465      * @param beneficiary who got the tokens
466      * @param value weis paid for purchase
467      * @param amount amount of tokens purchased
468      */
469     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
470 
471     function PreSale() public
472     {
473         startTime = 1524303600;
474         endTime = startTime + 20 * 1 minutes;
475 
476         wallet = 0x34FCc63E538f39a0E68E0f01A901713eF9Dd235c;
477         token = new RicoToken();
478 
479         // minimumInvest in wei
480         minimumInvest = 0.0001 ether;
481 
482         // 1 token for approximately 0.00015 eth
483         rate = 6667;
484 
485         softCap = 0.0150 ether;
486         hardCap = 0.1500 ether;
487         bonusPercent = 50;
488     }
489 
490     // @return true if the transaction can buy tokens
491     modifier saleIsOn() {
492         bool withinPeriod = now >= startTime && now <= endTime;
493         require(withinPeriod);
494         _;
495     }
496 
497     modifier isUnderHardCap() {
498         require(weiRaised < hardCap);
499         _;
500     }
501 
502     modifier refundAllowed() {
503         require(weiRaised < softCap && now > endTime);
504         _;
505     }
506 
507     // @return true if PreSale event has ended
508     function hasEnded() public view returns (bool) {
509         return now > endTime;
510     }
511 
512     // Refund ether to the investors (invoke from only token)
513     function refund(address _to) public refundAllowed {
514         require(msg.sender == tokenContractAddress);
515 
516         uint256 valueToReturn = balances[_to];
517 
518         // update states
519         balances[_to] = 0;
520         weiRaised = weiRaised.sub(valueToReturn);
521 
522         _to.transfer(valueToReturn);
523     }
524 
525     // Get amount of tokens
526     // @param value weis paid for tokens
527     function getTokenAmount(uint256 _value) internal view returns (uint256) {
528         return _value.mul(rate);
529     }
530 
531     // Send weis to the wallet
532     function forwardFunds(uint256 _value) internal {
533         wallet.transfer(_value);
534     }
535 
536     // Success finish of PreSale
537     function finishPreSale() public onlyOwner {
538         require(weiRaised >= softCap);
539         require(weiRaised >= hardCap || now > endTime);
540 
541         if (now < endTime) {
542             endTime = now;
543         }
544 
545         forwardFunds(this.balance);
546         token.transferOwnership(owner);
547     }
548 
549     // Change owner of token after end of PreSale if Soft Cap has not raised
550     function changeTokenOwner() public onlyOwner {
551         require(now > endTime && weiRaised < softCap);
552         token.transferOwnership(owner);
553     }
554 
555     // low level token purchase function
556     function buyTokens(address _beneficiary) saleIsOn isUnderHardCap nonReentrant public payable {
557         require(_beneficiary != address(0));
558         require(msg.value >= minimumInvest);
559 
560         uint256 weiAmount = msg.value;
561         uint256 tokens = getTokenAmount(weiAmount);
562         tokens = tokens.add(tokens.mul(bonusPercent).div(100));
563 
564         token.mint(_beneficiary, tokens);
565 
566         // update states
567         weiRaised = weiRaised.add(weiAmount);
568         balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
569 
570         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
571     }
572 
573     function() external payable {
574         buyTokens(msg.sender);
575     }
576 }