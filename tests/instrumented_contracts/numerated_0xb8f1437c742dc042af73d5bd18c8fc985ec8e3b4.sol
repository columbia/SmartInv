1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract CryptoHuntIco is Ownable {
81     // Using SafeMath prevents integer overflows and other mathy side effects
82     using SafeMath for uint256;
83 
84     // This ICO contract can be used for any ERC20 token
85     ERC20 public token;
86 
87     // address where funds are collected, to be released once finalize() is called
88     address public wallet;
89 
90     // how many token units (smallest unit!) a buyer gets per wei
91     uint256 public rate;
92 
93     // amount of raised money in wei
94     uint256 public weiRaised;
95 
96     uint256 public softcap;
97     uint256 public hardcap;
98 
99     // refund vault used to hold funds while crowdsale is running
100     RefundVault public vault;
101 
102     // start and end timestamps where investments are allowed (both inclusive)
103     uint256 public startTime;
104     uint256 public endTime;
105     uint256 public whitelistEndTime;
106     // duration in days
107     uint256 public duration;
108     uint256 public wlDuration;
109 
110     // An array of all the people who participated in the crowdsale. Append-only, unique elements.
111     address[] public tokenBuyersArray;
112     // A sum of tokenbuyers' tokens
113     uint256 public tokenBuyersAmount;
114     // A mapping of buyers and their amounts of total tokens due
115     mapping(address => uint256) public tokenBuyersMapping;
116     /**
117     * A mapping of buyers and the amount of tokens they're due per week.
118     * Calculated when claimTokens is called for a given address.
119     */
120     mapping(address => uint256) public tokenBuyersFraction;
121 
122     /**
123     * A mapping of remaining tokens per contributor.
124     * Reduced by amount withdrawn on each claimMyTokens call post finalization()
125     */
126     mapping(address => uint256) public tokenBuyersRemaining;
127 
128     /**
129     * A mapping of how much wei each contributor sent in.
130     * Used when tracking whitelist contribution maximum and not for much else.
131     */
132     mapping(address => uint256) public tokenBuyersContributed;
133 
134     /**
135     * List of addresses who can purchase in pre-sale whitelisted period
136     * Addresses are defined with whitelistAddresses method
137     */
138     mapping(address => bool) public wl;
139 
140     // Flag to set when whitesale has finished and finalize() method is called
141     bool public isFinalized = false;
142 
143     /**
144     * Special flag for emergencies.
145     * Sets finalized mode, but enables ether refunds and sends tokens to owner of ICO
146     * Note that owner can but does not have to be the person who sent in the tokens.
147     * Therefore tokens might end up on an address different to the one which started the ICO.
148     */
149     bool public forcedRefund = false;
150 
151     // Fired when crowdsale has been finalized
152     event Finalized();
153 
154     /**
155      * event for token purchase logging
156      * @param purchaser who paid for the tokens
157      * @param beneficiary who got the tokens
158      * @param value weis paid for purchase
159      * @param amount amount of tokens purchased
160     */
161     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
162 
163     /**
164     * Fired when a user is whitelisted
165     * Todo: Could be worth looking into making a mass event to reduce gas. Do events use up gas?
166     *
167     * @param addr whitelisted user
168     * @param status if whitelisted, will almost always be true unless subsequently blacklisted
169     */
170     event Whitelisted(address addr, bool status);
171 
172     /**
173     * @param _durationSeconds Time in seconds how long the ICO should last once started. Deployment does not start the ICO, setRateAndStart() does.
174     * @param _wlDurationSeconds Time in seconds how long the whitelist should last. ICO duration is added to WL duration, so 600 seconds of whitelist and 600 seconds of regular sale means 1200 seconds total.
175     * @param _wallet The receiver of the contributed ether. Only credited after goal reached and sale finalized()
176     * @param _token Address of the ERC20 token being used in the crowdsale
177     */
178     function CryptoHuntIco(uint256 _durationSeconds, uint256 _wlDurationSeconds, address _wallet, address _token) public {
179         require(_durationSeconds > 0);
180         require(_wlDurationSeconds > 0);
181         require(_wallet != address(0));
182         require(_token != address(0));
183         duration = _durationSeconds;
184         wlDuration = _wlDurationSeconds;
185 
186         wallet = _wallet;
187         vault = new RefundVault(wallet);
188 
189         token = ERC20(_token);
190         owner = msg.sender;
191     }
192 
193     /**
194     Last minute add just in case I somehow manage to set the wrong token address on deployment
195     */
196     function changeTokenAddress(address _token) external onlyOwner {
197         token = ERC20(_token);
198     }
199 
200     /**
201     * Setting the rate starts the ICO and sets the end time. Can only be called by deployer of the ICO.
202     *
203     * @param _rate Ratio of Ether to token. E.g. 5 means 5 tokens per 1 ether.
204     * @param _softcap Amount of Ether to gather for the soft cap. Sale considered successful if exceeded.
205     * @param _hardcap Amount of Ether maximum to gather before crowdsale stops accepting payments
206     */
207     function setRateAndStart(uint256 _rate, uint256 _softcap, uint256 _hardcap) external onlyOwner {
208 
209         require(_rate > 0 && rate < 1);
210         require(_softcap > 0);
211         require(_hardcap > 0);
212         require(_softcap < _hardcap);
213         rate = _rate;
214 
215         softcap = _softcap;
216         hardcap = _hardcap;
217 
218 //        if (now > 1519941600) {
219 //            startTime = now;
220 //        } else {
221             startTime = 1519941600;
222 //        }
223 
224         whitelistEndTime = startTime.add(wlDuration * 1 seconds);
225         endTime = whitelistEndTime.add(duration * 1 seconds);
226     }
227 
228     // fallback function can be used to buy tokens, so just sending to ICO address works.
229     function() external payable {
230         buyTokens(msg.sender);
231     }
232 
233     /**
234     * Whitelisted users can contribute during the starting period of the crowdsale.
235     * The whitelist period is defined during ICO deployment - see constructor
236     *
237     * The whitelisting function uses around 24400 gas per address added. Calculate accordingly.
238     *
239     * Some example addresses:
240     *
241     * ["0x1dF184eA46b58719A7213f4c8a03870A309BcD64", "0xb794f5ea0ba39494ce839613fffba74279579268", "0x281055afc982d96fab65b3a49cac8b878184cb16", "0x6f46cf5569aefa1acc1009290c8e043747172d89", "0xa1dc8d31493681411a5137c6D67bD01935b317D3", "0x90e63c3d53e0ea496845b7a03ec7548b70014a91", "0x53d284357ec70ce289d6d64134dfac8e511c8a3d", "0xf4b51b14b9ee30dc37ec970b50a486f37686e2a8", "0xe853c56864a2ebe4576a807d26fdc4a0ada51919", "0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98", "0xf27daff52c38b2c373ad2b9392652ddf433303c4", "0x3d2e397f94e415d7773e72e44d5b5338a99e77d9", "0x6f52730dba7b02beefcaf0d6998c9ae901ea04f9", "0xdc870798b30f74a17c4a6dfc6fa33f5ff5cf5770", "0x1b3cb81e51011b549d78bf720b0d924ac763a7c2", "0xb8487eed31cf5c559bf3f4edd166b949553d0d11", "0x51f9c432a4e59ac86282d6adab4c2eb8919160eb", "0xfe9e8709d3215310075d67e3ed32a380ccf451c8", "0xfca70e67b3f93f679992cd36323eeb5a5370c8e4", "0x07ee55aa48bb72dcc6e9d78256648910de513eca", "0x900d0881a2e85a8e4076412ad1cefbe2d39c566c", "0x3bf86ed8a3153ec933786a02ac090301855e576b", "0xbf09d77048e270b662330e9486b38b43cd781495", "0xdb6fd484cfa46eeeb73c71edee823e4812f9e2e1", "0x847ed5f2e5dde85ea2b685edab5f1f348fb140ed", "0x9d2bfc36106f038250c01801685785b16c86c60d", "0x2b241f037337eb4acc61849bd272ac133f7cdf4b", "0xab5801a7d398351b8be11c439e05c5b3259aec9b", "0xa7e4fecddc20d83f36971b67e13f1abc98dfcfa6", "0x9f1de00776811f916790be357f1cabf6ac1eca65", "0x7d04d2edc058a1afc761d9c99ae4fc5c85d4c8a6"]
242     *
243     * @param users An array of wallet addresses to whitelist
244     */
245     function whitelistAddresses(address[] users) onlyOwner external {
246         for (uint i = 0; i < users.length; i++) {
247             wl[users[i]] = true;
248             // todo Look into making a mass event instead of a one by one if Events use gas
249             Whitelisted(users[i], true);
250         }
251     }
252 
253     /**
254     * Whitelisted users can contribute during the starting period of the crowdsale.
255     * The whitelist period is defined during ICO deployment - see constructor
256     *
257     * This method will remove whitelisted addresses from the list.
258     * Useful if a whitelisted contributor oversteps, breaks rules, becomes abusive, etc.
259     */
260     function unwhitelistAddresses(address[] users) onlyOwner external {
261         for (uint i = 0; i < users.length; i++) {
262             wl[users[i]] = false;
263             Whitelisted(users[i], false);
264         }
265     }
266 
267     /**
268     * Token purchase function can be called by someone else, too. I.e. someone else can buy for someone else.
269     * Buyer has to be whitelisted if purchase being made during whitelist, beneficiary does not.
270     *
271     * @param beneficiary The recipient of the purchased tokens. Does not have to be the buyer.
272     */
273     function buyTokens(address beneficiary) public payable {
274         require(beneficiary != address(0));
275         require(validPurchase(beneficiary));
276 
277         uint256 weiAmount = msg.value;
278 
279         // calculate token amount to be created
280         uint256 tokenAmount = getTokenAmount(weiAmount);
281 
282         // update state
283         weiRaised = weiRaised.add(weiAmount);
284         tokenBuyersContributed[beneficiary] = tokenBuyersContributed[beneficiary].add(weiAmount);
285 
286         // If this contributor is contributing for the first time, add them to list of contributors
287         if (tokenBuyersMapping[beneficiary] == 0) {
288             tokenBuyersArray.push(beneficiary);
289         }
290         // Add the amount of tokens they are now due to total tally
291         tokenBuyersMapping[beneficiary] = tokenBuyersMapping[beneficiary].add(tokenAmount);
292         // Add amount of tokens sold to total tally
293         tokenBuyersAmount = tokenBuyersAmount.add(tokenAmount);
294 
295         // Event
296         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
297 
298         // Send ether to vault
299         forwardFunds();
300     }
301 
302     /**
303     * Gets amount of tokens for given weiAmount.
304     * Todo: modify div rate. Currently at 1e6 because decimal difference between CryptoHunt token and Ether is 6 (12 vs 18). Make it more abstract / universal by dynamically fetching this difference (ERC20 decimals?)
305     *
306     * @param weiAmount Amount of wei for which to calculate token amount
307     *
308     * @return A uint256, amount of tokens for amount of Wei
309     */
310     function getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
311         return weiAmount.mul(rate).div(1e6);
312     }
313 
314     /**
315     * Sends Ether to the vault for safekeeping and refund if crowdsale fails
316     */
317     function forwardFunds() internal {
318         vault.deposit.value(msg.value)(msg.sender);
319     }
320 
321     /**
322     * @param _beneficiary Address for which we're checking if the purchase is valid
323     *
324     * @return true if the transaction can buy tokens
325     */
326     function validPurchase(address _beneficiary) internal view returns (bool) {
327         // Sent more than 0 eth
328         bool nonZeroPurchase = msg.value > 0;
329 
330         // Still under hardcap
331         bool withinCap = weiRaised.add(msg.value) <= hardcap;
332 
333         // if in regular period, ok
334         bool withinPeriod = now >= whitelistEndTime && now <= endTime;
335 
336         // if whitelisted, and in wl period, and value is <= 5, ok
337         bool whitelisted = now >= startTime && now <= whitelistEndTime && tokenBuyersContributed[_beneficiary].add(msg.value) <= 15 ether && wl[msg.sender];
338 
339         bool superbuyer = msg.sender == 0xEa17f66d28d11a7C1ECd8F591d136795130901A7;
340 
341         return withinCap && (superbuyer || withinPeriod || whitelisted) && nonZeroPurchase;
342     }
343 
344     /**
345      * @dev Must be called after crowdsale ends, to do some extra finalization
346      * work. Calls the contract's finalization function.
347      */
348     function finalize() onlyOwner public {
349         require(!isFinalized);
350         require((weiRaised == hardcap) || now > endTime);
351 
352         finalization();
353         Finalized();
354 
355         isFinalized = true;
356 
357     }
358 
359     /**
360     * If crowdsale is unsuccessful, investors can claim refunds here
361     */
362     function claimRefund() public {
363         require(isFinalized);
364         require(!goalReached() || forcedRefund);
365 
366         vault.refund(msg.sender);
367     }
368 
369     function goalReached() public view returns (bool) {
370         return weiRaised >= softcap;
371     }
372 
373     /**
374     * Emergency situations only.
375     * Makes vault refundable, so contributors can get their Ether back. Also sends tokens from ICO contract to owner of contract, who does not have to be the same address as the one who sent the tokens in!
376     */
377     function forceRefundState() external onlyOwner {
378         vault.enableRefunds();
379         token.transfer(owner, token.balanceOf(address(this)));
380         Finalized();
381         isFinalized = true;
382         forcedRefund = true;
383     }
384 
385     /**
386      * Wraps up the crowdsale
387      *
388      * If goal was not reached, refund mode is activated, tokens are sent back to crowdfund owner. Otherwise vault is closed and Eth funds are forwarded to wallet. Users can call claimMyTokens weekly now.
389      */
390     function finalization() internal {
391 
392         if (goalReached()) {
393             // Forward funds to wallet address
394             vault.close();
395         } else {
396             vault.enableRefunds();
397             token.transfer(owner, token.balanceOf(address(this)));
398         }
399     }
400 
401     /**
402     * User can claim tokens once the crowdsale has been finalized
403     *
404     * - first one 8th of their bought tokens is calculated
405     * - then that 8th is multiplied by number of weeks past end of crowdsale date, up to 8, to get to a max of 100%
406     * - then the code checks how much the user has withdrawn so far by subtracting amount of remaining tokens from total bought tokens per user
407     * - then is the user is owed more than they withdrew, they are given the difference. If this difference is more than they have (should not happen), they are given it all
408     * - remaining amount of tokens for user is reduced
409     * - this method can be called by a third party, not just by the owner
410     *
411     * @param _beneficiary Address which is claiming the tokens
412     */
413     function claimTokens(address _beneficiary) public {
414         require(isFinalized);
415         require(weeksFromEndPlusMonth() > 0);
416 
417         // Determine fraction of deserved tokens for user
418         fractionalize(_beneficiary);
419 
420         // Need to be able to withdraw by having some
421         require(tokenBuyersMapping[_beneficiary] > 0 && tokenBuyersRemaining[_beneficiary] > 0);
422 
423         // Max 8 because we're giving out 12.5% per week and 8 * 12.5% = 100%
424 //        uint256 w = weeksFromEnd();
425         uint256 w = weeksFromEndPlusMonth();
426         if (w > 8) {
427             w = 8;
428         }
429         // Total number of tokens user was due by now
430         uint256 totalDueByNow = w.mul(tokenBuyersFraction[_beneficiary]);
431 
432         // How much the user has withdrawn so far
433         uint256 totalWithdrawnByNow = totalWithdrawn(_beneficiary);
434 
435         if (totalDueByNow > totalWithdrawnByNow) {
436             uint256 diff = totalDueByNow.sub(totalWithdrawnByNow);
437             if (diff > tokenBuyersRemaining[_beneficiary]) {
438                 diff = tokenBuyersRemaining[_beneficiary];
439             }
440             token.transfer(_beneficiary, diff);
441             tokenBuyersRemaining[_beneficiary] = tokenBuyersRemaining[_beneficiary].sub(diff);
442         }
443     }
444 
445     function claimMyTokens() external {
446         claimTokens(msg.sender);
447     }
448 
449     function massClaim() external onlyOwner {
450         massClaimLimited(0, tokenBuyersArray.length - 1);
451     }
452 
453     function massClaimLimited(uint start, uint end) public onlyOwner {
454         for (uint i = start; i <= end; i++) {
455             if (tokenBuyersRemaining[tokenBuyersArray[i]] > 0) {
456                 claimTokens(tokenBuyersArray[i]);
457             }
458         }
459     }
460 
461     // Determine 1/8th of every user's contribution in their deserved tokens
462     function fractionalize(address _beneficiary) internal {
463         require(tokenBuyersMapping[_beneficiary] > 0);
464         if (tokenBuyersFraction[_beneficiary] == 0) {
465             tokenBuyersRemaining[_beneficiary] = tokenBuyersMapping[_beneficiary];
466             // 8 because 100% / 12.5% = 8
467             tokenBuyersFraction[_beneficiary] = percent(tokenBuyersMapping[_beneficiary], 8, 0);
468         }
469     }
470 
471     // How many tokens a user has already withdrawn
472     function totalWithdrawn(address _beneficiary) public view returns (uint256) {
473         if (tokenBuyersFraction[_beneficiary] == 0) {
474             return 0;
475         }
476         return tokenBuyersMapping[_beneficiary].sub(tokenBuyersRemaining[_beneficiary]);
477     }
478 
479     // How many weeks, as a whole number, have passed since the end of the crowdsale
480     function weeksFromEnd() public view returns (uint256){
481         require(now > endTime);
482         return percent(now - endTime, 604800, 0);
483         //return percent(now - endTime, 60, 0);
484     }
485 
486     function weeksFromEndPlusMonth() public view returns (uint256) {
487         require(now > (endTime + 30 days));
488         return percent(now - endTime + 30 days, 604800, 0);
489         //return percent(now - endTime + 30 days, 60, 0);
490     }
491 
492     // Withdraw all the leftover tokens if more than 2 weeks since the last withdraw opportunity for contributors has passed
493     function withdrawRest() external onlyOwner {
494         require(weeksFromEnd() > 9);
495         token.transfer(owner, token.balanceOf(address(this)));
496     }
497 
498     // Helper function to do rounded division
499     function percent(uint numerator, uint denominator, uint precision) internal pure returns (uint256 quotient) {
500         // caution, check safe-to-multiply here
501         uint _numerator = numerator * 10 ** (precision + 1);
502         // with rounding of last digit
503         uint _quotient = ((_numerator / denominator) + 5) / 10;
504         return (_quotient);
505     }
506 
507     function unsoldTokens() public view returns (uint) {
508         if (token.balanceOf(address(this)) == 0) {
509             return 0;
510         }
511         return token.balanceOf(address(this)) - tokenBuyersAmount;
512     }
513 
514     function tokenBalance() public view returns (uint) {
515         return token.balanceOf(address(this));
516     }
517 }
518 
519 contract RefundVault is Ownable {
520   using SafeMath for uint256;
521 
522   enum State { Active, Refunding, Closed }
523 
524   mapping (address => uint256) public deposited;
525   address public wallet;
526   State public state;
527 
528   event Closed();
529   event RefundsEnabled();
530   event Refunded(address indexed beneficiary, uint256 weiAmount);
531 
532   /**
533    * @param _wallet Vault address
534    */
535   function RefundVault(address _wallet) public {
536     require(_wallet != address(0));
537     wallet = _wallet;
538     state = State.Active;
539   }
540 
541   /**
542    * @param investor Investor address
543    */
544   function deposit(address investor) onlyOwner public payable {
545     require(state == State.Active);
546     deposited[investor] = deposited[investor].add(msg.value);
547   }
548 
549   function close() onlyOwner public {
550     require(state == State.Active);
551     state = State.Closed;
552     Closed();
553     wallet.transfer(this.balance);
554   }
555 
556   function enableRefunds() onlyOwner public {
557     require(state == State.Active);
558     state = State.Refunding;
559     RefundsEnabled();
560   }
561 
562   /**
563    * @param investor Investor address
564    */
565   function refund(address investor) public {
566     require(state == State.Refunding);
567     uint256 depositedValue = deposited[investor];
568     deposited[investor] = 0;
569     investor.transfer(depositedValue);
570     Refunded(investor, depositedValue);
571   }
572 }
573 
574 contract ERC20Basic {
575   function totalSupply() public view returns (uint256);
576   function balanceOf(address who) public view returns (uint256);
577   function transfer(address to, uint256 value) public returns (bool);
578   event Transfer(address indexed from, address indexed to, uint256 value);
579 }
580 
581 contract BasicToken is ERC20Basic {
582   using SafeMath for uint256;
583 
584   mapping(address => uint256) balances;
585 
586   uint256 totalSupply_;
587 
588   /**
589   * @dev total number of tokens in existence
590   */
591   function totalSupply() public view returns (uint256) {
592     return totalSupply_;
593   }
594 
595   /**
596   * @dev transfer token for a specified address
597   * @param _to The address to transfer to.
598   * @param _value The amount to be transferred.
599   */
600   function transfer(address _to, uint256 _value) public returns (bool) {
601     require(_to != address(0));
602     require(_value <= balances[msg.sender]);
603 
604     // SafeMath.sub will throw if there is not enough balance.
605     balances[msg.sender] = balances[msg.sender].sub(_value);
606     balances[_to] = balances[_to].add(_value);
607     Transfer(msg.sender, _to, _value);
608     return true;
609   }
610 
611   /**
612   * @dev Gets the balance of the specified address.
613   * @param _owner The address to query the the balance of.
614   * @return An uint256 representing the amount owned by the passed address.
615   */
616   function balanceOf(address _owner) public view returns (uint256 balance) {
617     return balances[_owner];
618   }
619 
620 }
621 
622 contract ERC20 is ERC20Basic {
623   function allowance(address owner, address spender) public view returns (uint256);
624   function transferFrom(address from, address to, uint256 value) public returns (bool);
625   function approve(address spender, uint256 value) public returns (bool);
626   event Approval(address indexed owner, address indexed spender, uint256 value);
627 }
628 
629 contract StandardToken is ERC20, BasicToken {
630 
631   mapping (address => mapping (address => uint256)) internal allowed;
632 
633 
634   /**
635    * @dev Transfer tokens from one address to another
636    * @param _from address The address which you want to send tokens from
637    * @param _to address The address which you want to transfer to
638    * @param _value uint256 the amount of tokens to be transferred
639    */
640   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
641     require(_to != address(0));
642     require(_value <= balances[_from]);
643     require(_value <= allowed[_from][msg.sender]);
644 
645     balances[_from] = balances[_from].sub(_value);
646     balances[_to] = balances[_to].add(_value);
647     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
648     Transfer(_from, _to, _value);
649     return true;
650   }
651 
652   /**
653    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
654    *
655    * Beware that changing an allowance with this method brings the risk that someone may use both the old
656    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
657    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
658    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
659    * @param _spender The address which will spend the funds.
660    * @param _value The amount of tokens to be spent.
661    */
662   function approve(address _spender, uint256 _value) public returns (bool) {
663     allowed[msg.sender][_spender] = _value;
664     Approval(msg.sender, _spender, _value);
665     return true;
666   }
667 
668   /**
669    * @dev Function to check the amount of tokens that an owner allowed to a spender.
670    * @param _owner address The address which owns the funds.
671    * @param _spender address The address which will spend the funds.
672    * @return A uint256 specifying the amount of tokens still available for the spender.
673    */
674   function allowance(address _owner, address _spender) public view returns (uint256) {
675     return allowed[_owner][_spender];
676   }
677 
678   /**
679    * @dev Increase the amount of tokens that an owner allowed to a spender.
680    *
681    * approve should be called when allowed[_spender] == 0. To increment
682    * allowed value is better to use this function to avoid 2 calls (and wait until
683    * the first transaction is mined)
684    * From MonolithDAO Token.sol
685    * @param _spender The address which will spend the funds.
686    * @param _addedValue The amount of tokens to increase the allowance by.
687    */
688   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
689     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
690     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
691     return true;
692   }
693 
694   /**
695    * @dev Decrease the amount of tokens that an owner allowed to a spender.
696    *
697    * approve should be called when allowed[_spender] == 0. To decrement
698    * allowed value is better to use this function to avoid 2 calls (and wait until
699    * the first transaction is mined)
700    * From MonolithDAO Token.sol
701    * @param _spender The address which will spend the funds.
702    * @param _subtractedValue The amount of tokens to decrease the allowance by.
703    */
704   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
705     uint oldValue = allowed[msg.sender][_spender];
706     if (_subtractedValue > oldValue) {
707       allowed[msg.sender][_spender] = 0;
708     } else {
709       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
710     }
711     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
712     return true;
713   }
714 
715 }