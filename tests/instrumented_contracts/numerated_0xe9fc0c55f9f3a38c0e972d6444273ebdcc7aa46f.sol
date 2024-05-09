1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Math
50  * @dev Math operations with safety checks that throw on error
51  */
52 library Math {
53     function min(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a < b ? a : b;
55     }
56 
57     function max(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a > b ? a : b;
59     }
60 }
61 
62 contract Ownable {
63     address internal owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69      * account.
70      */
71     function Ownable() public {
72         owner = msg.sender;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84      * @dev Allows the current owner to transfer control of the contract to a newOwner.
85      * @param newOwner The address to transfer ownership to.
86      */
87     function transferOwnership(address newOwner) onlyOwner public returns (bool) {
88         require(newOwner != address(0x0));
89         emit OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91 
92         return true;
93     }
94 }
95 
96 contract Pausable is Ownable {
97     event Pause();
98     event Unpause();
99 
100     bool public paused = false;
101 
102     /**
103      * @dev Modifier to make a function callable only when the contract is not paused.
104      */
105     modifier whenNotPaused() {
106         require(!paused);
107         _;
108     }
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is paused.
112      */
113     modifier whenPaused() {
114         require(paused);
115         _;
116     }
117 
118     /**
119      * @dev called by the owner to pause, triggers stopped state
120      */
121     function pause() onlyOwner whenNotPaused public {
122         paused = true;
123         emit Pause();
124     }
125 
126     /**
127      * @dev called by the owner to unpause, returns to normal state
128      */
129     function unpause() onlyOwner whenPaused public {
130         paused = false;
131         emit Unpause();
132     }
133 }
134 
135 /**
136  * @title RefundVault
137  * @dev This contract is used for storing funds while a crowdsale
138  * is in progress. Supports refunding the money if crowdsale fails,
139  * and forwarding it if crowdsale is successful.
140  */
141 contract RefundVault is Ownable {
142     using SafeMath for uint256;
143 
144     enum State { Active, Refunding, Unlocked }
145 
146     mapping (address => uint256) public deposited;
147     address public wallet;
148     State public state;
149 
150     event RefundsEnabled();
151     event Refunded(address indexed beneficiary, uint256 weiAmount);
152 
153     function RefundVault(address _wallet) public {
154         require(_wallet != 0x0);
155         wallet = _wallet;
156         state = State.Active;
157     }
158 
159     function deposit(address investor) onlyOwner public payable {
160         require(state != State.Refunding);
161         deposited[investor] = deposited[investor].add(msg.value);
162     }
163 
164     function unlock() onlyOwner public {
165         require(state == State.Active);
166         state = State.Unlocked;
167     }
168 
169     function withdraw(address beneficiary, uint256 amount) onlyOwner public {
170         require(beneficiary != 0x0);
171         require(state == State.Unlocked);
172 
173         beneficiary.transfer(amount);
174     }
175 
176     function enableRefunds() onlyOwner public {
177         require(state == State.Active);
178         state = State.Refunding;
179         emit RefundsEnabled();
180     }
181 
182     function refund(address investor) public {
183         require(state == State.Refunding);
184         uint256 depositedValue = deposited[investor];
185         deposited[investor] = 0;
186         investor.transfer(depositedValue);
187         emit Refunded(investor, depositedValue);
188     }
189 }
190 
191 interface MintableToken {
192     function mint(address _to, uint256 _amount) external returns (bool);
193     function transferOwnership(address newOwner) external returns (bool);
194 }
195 
196 /**
197     This contract will handle the KYC contribution caps and the AML whitelist.
198     The crowdsale contract checks this whitelist everytime someone tries to buy tokens.
199 */
200 contract BitNauticWhitelist is Ownable {
201     using SafeMath for uint256;
202 
203     uint256 public usdPerEth;
204 
205     function BitNauticWhitelist(uint256 _usdPerEth) public {
206         usdPerEth = _usdPerEth;
207     }
208 
209     mapping(address => bool) public AMLWhitelisted;
210     mapping(address => uint256) public contributionCap;
211 
212     /**
213      * @dev sets the KYC contribution cap for one address
214      * @param addr address
215      * @param level uint8
216      * @return true if the operation was successful
217      */
218     function setKYCLevel(address addr, uint8 level) onlyOwner public returns (bool) {
219         if (level >= 3) {
220             contributionCap[addr] = 50000 ether; // crowdsale hard cap
221         } else if (level == 2) {
222             contributionCap[addr] = SafeMath.div(500000 * 10 ** 18, usdPerEth); // KYC Tier 2 - 500k USD
223         } else if (level == 1) {
224             contributionCap[addr] = SafeMath.div(3000 * 10 ** 18, usdPerEth); // KYC Tier 1 - 3k USD
225         } else {
226             contributionCap[addr] = 0;
227         }
228 
229         return true;
230     }
231 
232     function setKYCLevelsBulk(address[] addrs, uint8[] levels) onlyOwner external returns (bool success) {
233         require(addrs.length == levels.length);
234 
235         for (uint256 i = 0; i < addrs.length; i++) {
236             assert(setKYCLevel(addrs[i], levels[i]));
237         }
238 
239         return true;
240     }
241 
242     /**
243      * @dev adds the specified address to the AML whitelist
244      * @param addr address
245      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
246      */
247     function setAMLWhitelisted(address addr, bool whitelisted) onlyOwner public returns (bool) {
248         AMLWhitelisted[addr] = whitelisted;
249 
250         return true;
251     }
252 
253     function setAMLWhitelistedBulk(address[] addrs, bool[] whitelisted) onlyOwner external returns (bool) {
254         require(addrs.length == whitelisted.length);
255 
256         for (uint256 i = 0; i < addrs.length; i++) {
257             assert(setAMLWhitelisted(addrs[i], whitelisted[i]));
258         }
259 
260         return true;
261     }
262 }
263 
264 contract NewBitNauticCrowdsale is Ownable, Pausable {
265     using SafeMath for uint256;
266 
267     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
268 
269     uint256 public ICOStartTime = 1531267200; // 11 Jul 2018 00:00 GMT
270     uint256 public ICOEndTime = 1537056000; // 16 Sep 2018 00:00 GMT
271 
272     uint256 public constant tokenBaseRate = 500; // 1 ETH = 500 BTNT
273 
274     bool public manualBonusActive = false;
275     uint256 public manualBonus = 0;
276 
277     uint256 public constant crowdsaleSupply = 35000000 * 10 ** 18;
278     uint256 public tokensSold = 0;
279 
280     uint256 public constant softCap = 2500000 * 10 ** 18;
281 
282     uint256 public teamSupply =     3000000 * 10 ** 18; // 6% of token cap
283     uint256 public bountySupply =   2500000 * 10 ** 18; // 5% of token cap
284     uint256 public reserveSupply =  5000000 * 10 ** 18; // 10% of token cap
285     uint256 public advisorSupply =  2500000 * 10 ** 18; // 5% of token cap
286     uint256 public founderSupply =  2000000 * 10 ** 18; // 4% of token cap
287 
288     // amount of tokens each address will receive at the end of the crowdsale
289     mapping (address => uint256) public creditOf;
290 
291     // amount of ether invested by each address
292     mapping (address => uint256) public weiInvestedBy;
293 
294     // refund vault used to hold funds while crowdsale is running
295     RefundVault private vault;
296 
297     MintableToken public token;
298     BitNauticWhitelist public whitelist;
299 
300     constructor(MintableToken _token, BitNauticWhitelist _whitelist, address _beneficiary) public {
301         token = _token;
302         whitelist = _whitelist;
303         vault = new RefundVault(_beneficiary);
304     }
305 
306     function() public payable {
307         buyTokens(msg.sender);
308     }
309 
310     function buyTokens(address beneficiary) whenNotPaused public payable {
311         require(beneficiary != 0x0);
312         require(validPurchase());
313 
314         // checks if the ether amount invested by the buyer is lower than his contribution cap
315         require(SafeMath.add(weiInvestedBy[msg.sender], msg.value) <= whitelist.contributionCap(msg.sender));
316 
317         // compute the amount of tokens given the baseRate
318         uint256 tokens = SafeMath.mul(msg.value, tokenBaseRate);
319         // add the bonus tokens depending on current time
320         tokens = tokens.add(SafeMath.mul(tokens, getCurrentBonus()).div(1000));
321 
322         // check hardcap
323         require(SafeMath.add(tokensSold, tokens) <= crowdsaleSupply);
324 
325         // update total token sold counter
326         tokensSold = SafeMath.add(tokensSold, tokens);
327 
328         // keep track of the token credit and ether invested by the buyer
329         creditOf[beneficiary] = creditOf[beneficiary].add(tokens);
330         weiInvestedBy[msg.sender] = SafeMath.add(weiInvestedBy[msg.sender], msg.value);
331 
332         emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
333 
334         vault.deposit.value(msg.value)(msg.sender);
335     }
336 
337     function privateSale(address beneficiary, uint256 tokenAmount) onlyOwner public {
338         require(beneficiary != 0x0);
339         require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap
340 
341         tokensSold = SafeMath.add(tokensSold, tokenAmount);
342 
343         assert(token.mint(beneficiary, tokenAmount));
344     }
345 
346     // for payments in other currencies
347     function offchainSale(address beneficiary, uint256 tokenAmount) onlyOwner public {
348         require(beneficiary != 0x0);
349         require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap
350 
351         tokensSold = SafeMath.add(tokensSold, tokenAmount);
352 
353         // keep track of the token credit of the buyer
354         creditOf[beneficiary] = creditOf[beneficiary].add(tokenAmount);
355 
356         emit TokenPurchase(beneficiary, beneficiary, 0, tokenAmount);
357     }
358 
359     // this function can be called by the contributor to claim his BTNT tokens at the end of the ICO
360     function claimBitNauticTokens() public returns (bool) {
361         return grantContributorTokens(msg.sender);
362     }
363 
364     // if the ICO is finished and the goal has been reached, this function will be used to mint and transfer BTNT tokens to each contributor
365     function grantContributorTokens(address contributor) public returns (bool) {
366         require(creditOf[contributor] > 0);
367         require(whitelist.AMLWhitelisted(contributor));
368         require(now > ICOEndTime && tokensSold >= softCap);
369 
370         assert(token.mint(contributor, creditOf[contributor]));
371         creditOf[contributor] = 0;
372 
373         return true;
374     }
375 
376     // returns the token sale bonus permille depending on the current time
377     function getCurrentBonus() public view returns (uint256) {
378         if (manualBonusActive) return manualBonus;
379 
380         return Math.min(340, Math.max(100, (340 - (now - ICOStartTime) / (60 * 60 * 24) * 4)));
381     }
382 
383     function setManualBonus(uint256 newBonus, bool isActive) onlyOwner public returns (bool) {
384         manualBonus = newBonus;
385         manualBonusActive = isActive;
386 
387         return true;
388     }
389 
390     function setICOEndTime(uint256 newEndTime) onlyOwner public returns (bool) {
391         ICOEndTime = newEndTime;
392 
393         return true;
394     }
395 
396     function validPurchase() internal view returns (bool) {
397         bool duringICO = ICOStartTime <= now && now <= ICOEndTime;
398         bool minimumContribution = msg.value >= 0.05 ether;
399         return duringICO && minimumContribution;
400     }
401 
402     function hasEnded() public view returns (bool) {
403         return now > ICOEndTime;
404     }
405 
406     function unlockVault() onlyOwner public {
407         if (tokensSold >= softCap) {
408             vault.unlock();
409         }
410     }
411 
412     function withdraw(address beneficiary, uint256 amount) onlyOwner public {
413         vault.withdraw(beneficiary, amount);
414     }
415 
416     bool isFinalized = false;
417     function finalizeCrowdsale() onlyOwner public {
418         require(!isFinalized);
419         require(now > ICOEndTime);
420 
421         if (tokensSold < softCap) {
422             vault.enableRefunds();
423         }
424 
425         isFinalized = true;
426     }
427 
428     // if crowdsale is unsuccessful, investors can claim refunds here
429     function claimRefund() public {
430         require(isFinalized);
431         require(tokensSold < softCap);
432 
433         vault.refund(msg.sender);
434     }
435 
436     function transferTokenOwnership(address newTokenOwner) onlyOwner public returns (bool) {
437         return token.transferOwnership(newTokenOwner);
438     }
439 
440     function grantBountyTokens(address beneficiary) onlyOwner public {
441         require(bountySupply > 0);
442 
443         token.mint(beneficiary, bountySupply);
444         bountySupply = 0;
445     }
446 
447     function grantReserveTokens(address beneficiary) onlyOwner public {
448         require(reserveSupply > 0);
449 
450         token.mint(beneficiary, reserveSupply);
451         reserveSupply = 0;
452     }
453 
454     function grantAdvisorsTokens(address beneficiary) onlyOwner public {
455         require(advisorSupply > 0);
456 
457         token.mint(beneficiary, advisorSupply);
458         advisorSupply = 0;
459     }
460 
461     function grantFoundersTokens(address beneficiary) onlyOwner public {
462         require(founderSupply > 0);
463 
464         token.mint(beneficiary, founderSupply);
465         founderSupply = 0;
466     }
467 
468     function grantTeamTokens(address beneficiary) onlyOwner public {
469         require(teamSupply > 0);
470 
471         token.mint(beneficiary, teamSupply);
472         teamSupply = 0;
473     }
474 }