1 pragma solidity 0.4.21;
2 
3 interface TokenToken {
4     function pause() public;
5     function unpause() public;
6     function mint(address _to, uint256 _amount) public returns (bool);
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     function getTotalSupply() public view returns(uint);
10     function finishMinting() public returns (bool);
11 }
12 
13 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21     address public owner;
22 
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27     /**
28      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29      * account.
30      */
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to a newOwner.
47      * @param newOwner The address to transfer ownership to.
48      */
49     function transferOwnership(address newOwner) public onlyOwner {
50         require(newOwner != address(0));
51         OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53     }
54 
55 }
56 
57 // File: zeppelin-solidity/contracts/math/SafeMath.sol
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         assert(c / a == b);
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99     event Pause();
100     event Unpause();
101 
102     bool public paused = false;
103 
104 
105     /**
106      * @dev Modifier to make a function callable only when the contract is not paused.
107      */
108     modifier whenNotPaused() {
109         require(!paused);
110         _;
111     }
112 
113     /**
114      * @dev Modifier to make a function callable only when the contract is paused.
115      */
116     modifier whenPaused() {
117         require(paused);
118         _;
119     }
120 
121     /**
122      * @dev called by the owner to pause, triggers stopped state
123      */
124     function pause() onlyOwner whenNotPaused public {
125         paused = true;
126         Pause();
127     }
128 
129     /**
130      * @dev called by the owner to unpause, returns to normal state
131      */
132     function unpause() onlyOwner whenPaused public {
133         paused = false;
134         Unpause();
135     }
136 }
137 
138 // File: contracts/TeamAndAdvisorsAllocation.sol
139 
140 /**
141  * @title Team and Advisors Token Allocation contract
142  */
143 
144 contract TeamAndAdvisorsAllocation is Ownable {
145     using SafeMath for uint;
146 
147     uint256 public unlockedAt;
148     uint256 public canSelfDestruct;
149     uint256 public tokensCreated;
150     uint256 public allocatedTokens;
151     uint256 private totalTeamAndAdvisorsAllocation = 4000000e18; // 4 mm
152 
153     mapping (address => uint256) public teamAndAdvisorsAllocations;
154 
155     TokenToken public token;
156 
157     /**
158      * @dev constructor function that sets owner and token for the TeamAndAdvisorsAllocation contract
159      * @param _token Token contract address for TokenToken
160      */
161     function TeamAndAdvisorsAllocation(address _token) public {
162         token = TokenToken(_token);
163         unlockedAt = now.add(3 days);
164         canSelfDestruct = now.add(4 days);
165     }
166 
167     /**
168      * @dev Adds founders' token allocation
169      * @param teamOrAdvisorsAddress Address of a founder
170      * @param allocationValue Number of tokens allocated to a founder
171      * @return true if address is correctly added
172      */
173     function addTeamAndAdvisorsAllocation(address teamOrAdvisorsAddress, uint256 allocationValue)
174     external
175     onlyOwner
176     returns(bool)
177     {
178         assert(teamAndAdvisorsAllocations[teamOrAdvisorsAddress] == 0); // can only add once.
179 
180         allocatedTokens = allocatedTokens.add(allocationValue);
181         require(allocatedTokens <= totalTeamAndAdvisorsAllocation);
182 
183         teamAndAdvisorsAllocations[teamOrAdvisorsAddress] = allocationValue;
184         return true;
185     }
186 
187     /**
188      * @dev Allow company to unlock allocated tokens by transferring them whitelisted addresses.
189      * Need to be called by each address
190      */
191     function unlock() external {
192         assert(now >= unlockedAt);
193 
194         // During first unlock attempt fetch total number of locked tokens.
195         if (tokensCreated == 0) {
196             tokensCreated = token.balanceOf(this);
197         }
198 
199         uint256 transferAllocation = teamAndAdvisorsAllocations[msg.sender];
200         teamAndAdvisorsAllocations[msg.sender] = 0;
201 
202         // Will fail if allocation (and therefore toTransfer) is 0.
203         require(token.transfer(msg.sender, transferAllocation));
204     }
205 
206     /**
207      * @dev allow for selfdestruct possibility and sending funds to owner
208      */
209     function kill() public onlyOwner {
210         assert(now >= canSelfDestruct);
211         uint256 balance = token.balanceOf(this);
212 
213         if (balance > 0) {
214             token.transfer(owner, balance);
215         }
216 
217         selfdestruct(owner);
218     }
219 }
220 
221 // File: contracts/Whitelist.sol
222 
223 contract Whitelist is Ownable {
224     mapping(address => bool) public allowedAddresses;
225 
226     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
227 
228     function addToWhitelist(address[] _addresses) public onlyOwner {
229         for (uint256 i = 0; i < _addresses.length; i++) {
230             allowedAddresses[_addresses[i]] = true;
231             WhitelistUpdated(now, "Added", _addresses[i]);
232         }
233     }
234 
235     function removeFromWhitelist(address[] _addresses) public onlyOwner {
236         for (uint256 i = 0; i < _addresses.length; i++) {
237             allowedAddresses[_addresses[i]] = false;
238             WhitelistUpdated(now, "Removed", _addresses[i]);
239         }
240     }
241 
242     function isWhitelisted(address _address) public view returns (bool) {
243         return allowedAddresses[_address];
244     }
245 }
246 
247 // File: zeppelin-solidity/contracts/crowdsale/TokenCrowdsale.sol
248 
249 /**
250  * @title Crowdsale
251  * @dev Crowdsale is a base contract for managing a token crowdsale.
252  * Crowdsales have a start and end timestamps, where investors can make
253  * token purchases and the crowdsale will assign them tokens based
254  * on a token per ETH rate. Funds collected are forwarded to a wallet
255  * as they arrive.
256  */
257 contract Crowdsale {
258     using SafeMath for uint256;
259 
260     // start and end timestamps where investments are allowed (both inclusive)
261     uint256 public startTime;
262     uint256 public endTime;
263 
264     // address where funds are collected
265     address public wallet;
266 
267     // how many token units a buyer gets per wei
268     uint256 public rate;
269 
270     // amount of raised money in wei
271     uint256 public weiRaised;
272 
273     // token contract to be set
274     TokenToken public token;
275 
276     /**
277      * event for token purchase logging
278      * @param purchaser who paid for the tokens
279      * @param beneficiary who got the tokens
280      * @param value weis paid for purchase
281      * @param amount amount of tokens purchased
282      */
283     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
284 
285 
286     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
287         require(_startTime >= now);
288         require(_endTime > _startTime);
289         require(_rate > 0);
290         require(_wallet != address(0));
291 
292         startTime = _startTime;
293         endTime = _endTime;
294         rate = _rate;
295         wallet = _wallet;
296     }
297 
298     // fallback function can be used to buy tokens
299     function () external payable {
300         buyTokens(msg.sender);
301     }
302 
303     // low level token purchase function
304     function buyTokens(address beneficiary) public payable {
305         require(beneficiary != address(0));
306         require(validPurchase());
307 
308         uint256 weiAmount = msg.value;
309 
310         // calculate token amount to be created
311         uint256 tokens = weiAmount.mul(rate);
312 
313         // update state
314         weiRaised = weiRaised.add(weiAmount);
315 
316         token.mint(beneficiary, tokens);
317         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
318 
319         forwardFunds();
320     }
321 
322     // send ether to the fund collection wallet
323     // override to create custom fund forwarding mechanisms
324     function forwardFunds() internal {
325         wallet.transfer(msg.value);
326     }
327 
328     // @return true if the transaction can buy tokens
329     function validPurchase() internal view returns (bool) {
330         bool withinPeriod = now >= startTime && now <= endTime;
331         bool nonZeroPurchase = msg.value != 0;
332         return withinPeriod && nonZeroPurchase;
333     }
334 
335     // @return true if crowdsale event has ended
336     function hasEnded() public view returns (bool) {
337         return now > endTime;
338     }
339 
340 
341 }
342 
343 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
344 
345 /**
346  * @title FinalizableCrowdsale
347  * @dev Extension of Crowdsale where an owner can do extra work
348  * after finishing.
349  */
350 contract FinalizableCrowdsale is Crowdsale, Ownable {
351     using SafeMath for uint256;
352 
353     bool public isFinalized = false;
354 
355     event Finalized();
356 
357     /**
358      * @dev Must be called after crowdsale ends, to do some extra finalization
359      * work. Calls the contract's finalization function.
360      */
361     function finalize() onlyOwner public {
362         require(!isFinalized);
363         require(hasEnded());
364 
365         finalization();
366         Finalized();
367 
368         isFinalized = true;
369     }
370 
371     /**
372      * @dev Can be overridden to add finalization logic. The overriding function
373      * should call super.finalization() to ensure the chain of finalization is
374      * executed entirely.
375      */
376     function finalization() internal {
377     }
378 }
379 
380 // File: contracts/TokenCrowdsale.sol
381 
382 /**
383  * @title Token Crowdsale contract - crowdsale contract for the Token tokens.
384  */
385 
386 contract TokenCrowdsale is FinalizableCrowdsale, Pausable {
387     uint256 constant public REWARD_SHARE =                   4500000e18; // 4.5 mm
388     uint256 constant public NON_VESTED_TEAM_ADVISORS_SHARE = 37500000e18; //  37.5 mm
389     uint256 constant public PRE_CROWDSALE_CAP =              500000e18; //  0.5 mm
390     uint256 constant public PUBLIC_CROWDSALE_CAP =           7500000e18; // 7.5 mm
391     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = PRE_CROWDSALE_CAP + PUBLIC_CROWDSALE_CAP;
392     uint256 constant public TOTAL_TOKENS_SUPPLY =            50000000e18; // 50 mm
393     uint256 constant public PERSONAL_CAP =                   2500000e18; //   2.5 mm
394 
395     address public rewardWallet;
396     address public teamAndAdvisorsAllocation;
397 
398     // remainderPurchaser and remainderTokens info saved in the contract
399     // used for reference for contract owner to send refund if any to last purchaser after end of crowdsale
400     address public remainderPurchaser;
401     uint256 public remainderAmount;
402 
403     mapping (address => uint256) public trackBuyersPurchases;
404 
405     // external contracts
406     Whitelist public whitelist;
407 
408     event PrivateInvestorTokenPurchase(address indexed investor, uint256 tokensPurchased);
409     event TokenRateChanged(uint256 previousRate, uint256 newRate);
410 
411     /**
412      * @dev Contract constructor function
413      * @param _startTime The timestamp of the beginning of the crowdsale
414      * @param _endTime Timestamp when the crowdsale will finish
415      * @param _whitelist contract containing the whitelisted addresses
416      * @param _rate The token rate per ETH
417      * @param _wallet Multisig wallet that will hold the crowdsale funds.
418      * @param _rewardWallet wallet that will hold tokens bounty and rewards campaign
419      */
420     function TokenCrowdsale
421     (
422         uint256 _startTime,
423         uint256 _endTime,
424         address _whitelist,
425         uint256 _rate,
426         address _wallet,
427         address _rewardWallet
428     )
429     public
430     FinalizableCrowdsale()
431     Crowdsale(_startTime, _endTime, _rate, _wallet)
432     {
433 
434         require(_whitelist != address(0) && _wallet != address(0) && _rewardWallet != address(0));
435         whitelist = Whitelist(_whitelist);
436         rewardWallet = _rewardWallet;
437 
438     }
439 
440     function setTokenContractAddress(address _token) onlyOwner {
441         token = TokenToken(_token);
442     }
443 
444     modifier whitelisted(address beneficiary) {
445         require(whitelist.isWhitelisted(beneficiary));
446         _;
447     }
448 
449     /**
450      * @dev change crowdsale rate
451      * @param newRate Figure that corresponds to the new rate per token
452      */
453     function setRate(uint256 newRate) external onlyOwner {
454         require(newRate != 0);
455 
456         TokenRateChanged(rate, newRate);
457         rate = newRate;
458     }
459 
460     /**
461      * @dev Mint tokens for pre crowdsale putchases before crowdsale starts
462      * @param investorsAddress Purchaser's address
463      * @param tokensPurchased Tokens purchased during pre crowdsale
464      */
465     function mintTokenForPreCrowdsale(address investorsAddress, uint256 tokensPurchased)
466     external
467     onlyOwner
468     {
469         require(now < startTime && investorsAddress != address(0));
470         require(token.getTotalSupply().add(tokensPurchased) <= PRE_CROWDSALE_CAP);
471 
472         token.mint(investorsAddress, tokensPurchased);
473         PrivateInvestorTokenPurchase(investorsAddress, tokensPurchased);
474     }
475 
476     /**
477      * @dev Set the address which should receive the vested team tokens share on finalization
478      * @param _teamAndAdvisorsAllocation address of team and advisor allocation contract
479      */
480     function setTeamWalletAddress(address _teamAndAdvisorsAllocation) public onlyOwner {
481         require(_teamAndAdvisorsAllocation != address(0x0));
482         teamAndAdvisorsAllocation = _teamAndAdvisorsAllocation;
483     }
484 
485 
486     /**
487      * @dev payable function that allow token purchases
488      * @param beneficiary Address of the purchaser
489      */
490     function buyTokens(address beneficiary)
491     public
492     whenNotPaused
493     whitelisted(beneficiary)
494     payable
495     {
496         require(beneficiary != address(0));
497         require(msg.sender == beneficiary);
498         require(validPurchase() && token.getTotalSupply() < TOTAL_TOKENS_FOR_CROWDSALE);
499 
500         uint256 weiAmount = msg.value;
501 
502         // calculate token amount to be created
503         uint256 tokens = weiAmount.mul(rate);
504 
505         require(trackBuyersPurchases[msg.sender].add(tokens) <= PERSONAL_CAP);
506 
507         trackBuyersPurchases[beneficiary] = trackBuyersPurchases[beneficiary].add(tokens);
508 
509         //remainder logic
510         if (token.getTotalSupply().add(tokens) > TOTAL_TOKENS_FOR_CROWDSALE) {
511             tokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.getTotalSupply());
512             weiAmount = tokens.div(rate);
513 
514             // save info so as to refund purchaser after crowdsale's end
515             remainderPurchaser = msg.sender;
516             remainderAmount = msg.value.sub(weiAmount);
517         }
518 
519         // update state
520         weiRaised = weiRaised.add(weiAmount);
521 
522         token.mint(beneficiary, tokens);
523         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
524 
525         forwardFunds();
526     }
527 
528     // overriding Crowdsale#hasEnded to add cap logic
529     // @return true if crowdsale event has ended
530     function hasEnded() public view returns (bool) {
531         if (token.getTotalSupply() == TOTAL_TOKENS_FOR_CROWDSALE) {
532             return true;
533         }
534 
535         return super.hasEnded();
536     }
537 
538     /**
539      * @dev finalizes crowdsale
540      */
541     function finalization() internal {
542         // This must have been set manually prior to finalize().
543         require(teamAndAdvisorsAllocation != address(0x0));
544 
545         // final minting
546         token.mint(teamAndAdvisorsAllocation, NON_VESTED_TEAM_ADVISORS_SHARE);
547         token.mint(rewardWallet, REWARD_SHARE);
548 
549         if (TOTAL_TOKENS_SUPPLY > token.getTotalSupply()) {
550             uint256 remainingTokens = TOTAL_TOKENS_SUPPLY.sub(token.getTotalSupply());
551 
552             token.mint(wallet, remainingTokens);
553         }
554 
555         token.finishMinting();
556         TokenToken(token).unpause();
557         super.finalization();
558     }
559 }