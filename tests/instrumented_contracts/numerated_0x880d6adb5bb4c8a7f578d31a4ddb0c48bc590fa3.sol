1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  *
6  *  STEAK TOKEN (BOV)
7  *
8  *  Make bank by eating flank. See https://steaktoken.com.
9  *
10  */
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17  library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50  contract Ownable {
51   address public owner;
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   function transferOwnership(address newOwner) onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 
66 
67 
68 
69 contract SteakToken is Ownable {
70 
71   using SafeMath for uint256;
72 
73   string public name = "Steak Token";
74   string public symbol = "BOV";
75   uint public decimals = 18;
76   uint public totalSupply;      // Total BOV in circulation.
77 
78   mapping(address => uint256) balances;
79   mapping (address => mapping (address => uint256)) allowed;
80 
81   event Transfer(address indexed from, address indexed to, uint256 value);
82   event Approval(address indexed ownerAddress, address indexed spenderAddress, uint256 value);
83   event Mint(address indexed to, uint256 amount);
84   event MineFinished();
85 
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90   function transfer(address _to, uint256 _value) returns (bool) {
91     if(msg.data.length < (2 * 32) + 4) { revert(); } // protect against short address attack
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98 
99   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
100     var _allowance = allowed[_from][msg.sender];
101 
102     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
103     // require (_value <= _allowance);
104 
105     balances[_to] = balances[_to].add(_value);
106     balances[_from] = balances[_from].sub(_value);
107     allowed[_from][msg.sender] = _allowance.sub(_value);
108     Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
114    * @param _spender The address which will spend the funds.
115    * @param _value The amount of tokens to be spent.
116    */
117    function approve(address _spender, uint256 _value) returns (bool) {
118 
119     // To change the approve amount you first have to reduce the addresses`
120     //  allowance to zero by calling `approve(_spender, 0)` if it is not
121     //  already 0 to mitigate the race condition described here:
122     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
124 
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param _owner address The address which owns the funds.
133    * @param _spender address The address which will spend the funds.
134    * @return A uint256 specifing the amount of tokens still avaible for the spender.
135    */
136    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140     /**
141    * @dev Function to mint tokens
142    * @param _to The address that will recieve the minted tokens.
143    * @param _amount The amount of tokens to mint.
144    * @return A boolean that indicates if the operation was successful.
145    */
146    function mint(address _to, uint256 _amount) internal returns (bool) {
147     totalSupply = totalSupply.add(_amount);
148     balances[_to] = balances[_to].add(_amount);
149     Mint(_to, _amount);
150     return true;
151   }
152 
153 
154 }
155 
156 
157 
158 
159 
160 
161 
162 
163 /**
164  * @title AuctionCrowdsale 
165  * @dev The owner starts and ends the crowdsale manually.
166  * Players can make token purchases during the crowdsale
167  * and their tokens can be claimed after the sale ends.
168  * Players receive an amount proportional to their investment.
169  */
170  contract AuctionCrowdsale is SteakToken {
171   using SafeMath for uint;
172 
173   uint public initialSale;                  // Amount of BOV tokens being sold during crowdsale.
174 
175   bool public saleStarted;
176   bool public saleEnded;
177 
178   uint public absoluteEndBlock;             // Anybody can end the crowdsale and trigger token distribution if beyond this block number.
179 
180   uint256 public weiRaised;                 // Total amount raised in crowdsale.
181 
182   address[] public investors;               // Investor addresses
183   uint public numberOfInvestors;
184   mapping(address => uint256) public investments; // How much each address has invested.
185 
186   mapping(address => bool) public claimed;      // Keep track of whether each investor has been awarded their BOV tokens.
187 
188 
189   bool public bovBatchDistributed;              // TODO: this can be removed with manual crowdsale end-time
190 
191   uint public initialPrizeWeiValue;             // The first steaks mined will be awarded BOV equivalent to this ETH value. Set in Steak() initializer.
192   uint public initialPrizeBov;                  // Initial mining prize in BOV units. Set in endCrowdsale() or endCrowdsalePublic().
193 
194   uint public dailyHashExpires;        // When the dailyHash expires. Will be roughly around 3am EST.
195 
196 
197 
198 
199 
200   /**
201    * event for token purchase logging
202    * @param purchaser who paid for the tokens
203    * @param beneficiary who got the tokens
204    * @param value weis paid for purchase
205    */ 
206    event TokenInvestment(address indexed purchaser, address indexed beneficiary, uint256 value);
207 
208 
209 
210    // Sending ETH to this contract's address registers the investment.
211    function () payable {
212     invest(msg.sender);
213   }
214 
215 
216   // Participate in the crowdsale.
217   // Records how much each address has invested.
218   function invest(address beneficiary) payable {
219     require(beneficiary != 0x0);
220     require(validInvestment());
221 
222     uint256 weiAmount = msg.value;
223 
224     uint investedAmount = investments[beneficiary];
225 
226     forwardFunds();
227 
228     if (investedAmount > 0) { // If they've already invested, increase their balance.
229       investments[beneficiary] = investedAmount + weiAmount; // investedAmount.add(weiAmount);
230     } else { // If new investor
231       investors.push(beneficiary);
232       numberOfInvestors += 1;
233       investments[beneficiary] = weiAmount;
234     }
235     weiRaised = weiRaised.add(weiAmount);
236     TokenInvestment(msg.sender, beneficiary, weiAmount);
237   }
238 
239 
240 
241   // @return true if the transaction can invest
242   function validInvestment() internal constant returns (bool) {
243     bool withinPeriod = saleStarted && !saleEnded;
244     bool nonZeroPurchase = (msg.value > 0);
245     return withinPeriod && nonZeroPurchase;
246   }
247 
248 
249 
250 
251   // Distribute 10M tokens proportionally amongst all investors. Can be called by anyone after the crowdsale ends.
252   // ClaimTokens() can be run by individuals to claim their tokens.
253   function distributeAllTokens() public {
254 
255     require(!bovBatchDistributed);
256     require(crowdsaleHasEnded());
257 
258     // Allocate BOV proportionally to each investor.
259 
260     for (uint i=0; i < numberOfInvestors; i++) {
261       address investorAddr = investors[i];
262       if (!claimed[investorAddr]) { // If the investor hasn't already claimed their BOV.
263         claimed[investorAddr] = true;
264         uint amountInvested = investments[investorAddr];
265         uint bovEarned = amountInvested.mul(initialSale).div(weiRaised);
266         mint(investorAddr, bovEarned);
267       }
268     }
269 
270     bovBatchDistributed = true;
271   }
272 
273 
274   // Claim your BOV; allocates BOV proportionally to this investor.
275   // Can be called by investors to claim their BOV after the crowdsale ends.
276   // distributeAllTokens() is a batch alternative to this.
277   function claimTokens(address origAddress) public {
278     require(crowdsaleHasEnded());
279     require(claimed[origAddress] == false);
280     uint amountInvested = investments[origAddress];
281     uint bovEarned = amountInvested.mul(initialSale).div(weiRaised);
282     claimed[origAddress] = true;
283     mint(origAddress, bovEarned);
284   }
285 
286 
287   // Investors: see how many BOV you are currently entitled to (before the end of the crowdsale and distribution of tokens).
288   function getCurrentShare(address addr) public constant returns (uint) {
289     require(!bovBatchDistributed && !claimed[addr]); // Tokens cannot have already been distributed.
290     uint amountInvested = investments[addr];
291     uint currentBovShare = amountInvested.mul(initialSale).div(weiRaised);
292     return currentBovShare;
293   }
294 
295 
296 
297   // send ether to the fund collection wallet
298   function forwardFunds() internal {
299     owner.transfer(msg.value);
300   }
301 
302 
303   // The owner manually starts the crowdsale at a pre-determined time.
304   function startCrowdsale() onlyOwner {
305     require(!saleStarted && !saleEnded);
306     saleStarted = true;
307   }
308 
309   // endCrowdsale() and endCrowdsalePublic() moved to Steak contract
310     // Normally, the owner will end the crowdsale at the pre-determined time.
311   function endCrowdsale() onlyOwner {
312     require(saleStarted && !saleEnded);
313     dailyHashExpires = now; // Will end crowdsale at 3am EST, so expiration time will roughly be around 3am.
314     saleEnded = true;
315     setInitialPrize();
316   }
317 
318   // Normally, Madame BOV ends the crowdsale at the pre-determined time, but if Madame BOV fails to do so, anybody can trigger endCrowdsalePublic() after absoluteEndBlock.
319   function endCrowdsalePublic() public {
320     require(block.number > absoluteEndBlock);
321     require(saleStarted && !saleEnded);
322     dailyHashExpires = now;
323     saleEnded = true;
324     setInitialPrize();
325   }
326 
327 
328   // Calculate initial mining prize (0.0357 ether's worth of BOV). This is called in endCrowdsale().
329   function setInitialPrize() internal returns (uint) {
330     require(crowdsaleHasEnded());
331     require(initialPrizeBov == 0); // Can only be set once
332     uint tokenUnitsPerWei = initialSale.div(weiRaised);
333     initialPrizeBov = tokenUnitsPerWei.mul(initialPrizeWeiValue);
334     return initialPrizeBov;
335   }
336 
337 
338   // @return true if crowdsale event has ended
339   function crowdsaleHasEnded() public constant returns (bool) {
340     return saleStarted && saleEnded;
341   }
342 
343   function getInvestors() public returns (address[]) {
344     return investors;
345   }
346 
347 
348 }
349 
350 
351 
352 
353 
354 
355 
356 contract Steak is AuctionCrowdsale {
357   // using SafeMath for uint;
358 
359   bytes32 public dailyHash;            // The last five digits of the dailyHash must be included in steak pictures.
360 
361 
362   Submission[] public submissions;          // All steak pics
363   uint public numSubmissions;
364 
365   Submission[] public approvedSubmissions;
366   mapping (address => uint) public memberId;    // Get member ID from address.
367   Member[] public members;                      // Index is memberId
368 
369   uint public halvingInterval;                  // BOV award is halved every x steaks
370   uint public numberOfHalvings;                 // How many times the BOV reward per steak is halved before it returns 0. 
371 
372 
373 
374   uint public lastMiningBlock;                  // No mining after this block. Set in initializer.
375 
376   bool public ownerCredited;    // Has the owner been credited BOV yet?
377 
378   event PicAdded(address msgSender, uint submissionID, address recipient, bytes32 propUrl); // Need msgSender so we can watch for this event.
379   event Judged(uint submissionID, bool position, address voter, bytes32 justification);
380   event MembershipChanged(address member, bool isMember);
381 
382   struct Submission {
383     address recipient;    // Would-be BOV recipient
384     bytes32 url;           // IMGUR url; 32-char max
385     bool judged;          // Has an admin voted?
386     bool submissionApproved;// Has it been approved?
387     address judgedBy;     // Admin who judged this steak
388     bytes32 adminComments; // Admin should leave feedback on non-approved steaks. 32-char max.
389     bytes32 todaysHash;   // The hash in the image should match this hash.
390     uint awarded;         // Amount awarded
391   }
392 
393   // Members can vote on steak
394   struct Member {
395     address member;
396     bytes32 name;
397     uint memberSince;
398   }
399 
400 
401   modifier onlyMembers {
402     require(memberId[msg.sender] != 0); // member id must be in the mapping
403     _;
404   }
405 
406 
407   function Steak() {
408 
409     owner = msg.sender;
410     initialSale = 10000000 * 1000000000000000000; // 10M BOV units are awarded in the crowdsale.
411 
412     // Normally, the owner both starts and ends the crowdsale.
413     // To guarantee that the crowdsale ends at some maximum point (at that tokens are distributed),
414     // we calculate the absoluteEndBlock, the block beyond which anybody can end the crowdsale and distribute tokens.
415     uint blocksPerHour = 212;
416     uint maxCrowdsaleLifeFromLaunchDays = 40; // After about this many days from launch, anybody can end the crowdsale and distribute / claim their tokens. 
417     absoluteEndBlock = block.number + (blocksPerHour * 24 * maxCrowdsaleLifeFromLaunchDays);
418 
419     uint miningDays = 365; // Approximately how many days BOV can be mined from the launch of the contract.
420     lastMiningBlock = block.number + (blocksPerHour * 24 * miningDays);
421 
422     dailyHashExpires = now;
423 
424     halvingInterval = 500;    // How many steaks get awarded the given getSteakPrize() amount before the reward is halved.
425     numberOfHalvings = 8;      // How many times the steak prize gets halved before no more prize is awarded.
426 
427     // initialPrizeWeiValue = 50 finney; // 0.05 ether == 50 finney == 2.80 USD * 5 == 14 USD
428     initialPrizeWeiValue = (357 finney / 10); // 0.0357 ether == 35.7 finney == 2.80 USD * 3.57 == 9.996 USD
429 
430     // To finish initializing, owner calls initMembers() and creditOwner() after launch.
431   }
432 
433 
434   // Add Madame BOV as a beef judge.
435   function initMembers() onlyOwner {
436     addMember(0, '');                        // Must add an empty first member
437     addMember(msg.sender, 'Madame BOV');
438   }
439 
440 
441 
442   // Send 1M BOV to Madame BOV. 
443   function creditOwner() onlyOwner {
444     require(!ownerCredited);
445     uint ownerAward = initialSale / 10;  // 10% of the crowdsale amount.
446     ownerCredited = true;   // Can only be run once.
447     mint(owner, ownerAward);
448   }
449 
450 
451 
452 
453 
454 
455   /* Add beef judge */
456   function addMember(address targetMember, bytes32 memberName) onlyOwner {
457     uint id;
458     if (memberId[targetMember] == 0) {
459       memberId[targetMember] = members.length;
460       id = members.length++;
461       members[id] = Member({member: targetMember, memberSince: now, name: memberName});
462     } else {
463       id = memberId[targetMember];
464       // Member m = members[id];
465     }
466     MembershipChanged(targetMember, true);
467   }
468 
469   function removeMember(address targetMember) onlyOwner {
470     if (memberId[targetMember] == 0) revert();
471 
472     memberId[targetMember] = 0;
473 
474     for (uint i = memberId[targetMember]; i<members.length-1; i++){
475       members[i] = members[i+1];
476     }
477     delete members[members.length-1];
478     members.length--;
479   }
480 
481 
482 
483   /* Submit a steak picture. (After crowdsale has ended.)
484   *  WARNING: Before taking the picture, call getDailyHash() and  minutesToPost()
485   *  so you can be sure that you have the correct dailyHash and that it won't expire before you post it.
486   */
487   function submitSteak(address addressToAward, bytes32 steakPicUrl)  returns (uint submissionID) {
488     require(crowdsaleHasEnded());
489     require(block.number <= lastMiningBlock); // Cannot submit beyond this block.
490     submissionID = submissions.length++; // Increase length of array
491     Submission storage s = submissions[submissionID];
492     s.recipient = addressToAward;
493     s.url = steakPicUrl;
494     s.judged = false;
495     s.submissionApproved = false;
496     s.todaysHash = getDailyHash(); // Each submission saves the hash code the user should take picture of in steak picture.
497 
498     PicAdded(msg.sender, submissionID, addressToAward, steakPicUrl);
499     numSubmissions = submissionID+1;
500 
501     return submissionID;
502   }
503 
504   // Retrieving any Submission must be done via this function, not `submissions()`
505   function getSubmission(uint submissionID) public constant returns (address recipient, bytes32 url, bool judged, bool submissionApproved, address judgedBy, bytes32 adminComments, bytes32 todaysHash, uint awarded) {
506     Submission storage s = submissions[submissionID];
507     recipient = s.recipient;
508     url = s.url;                 // IMGUR url
509     judged = s.judged;           // Has an admin voted?
510     submissionApproved = s.submissionApproved;  // Has it been approved?
511     judgedBy = s.judgedBy;           // Admin who judged this steak
512     adminComments = s.adminComments; // Admin should leave feedback on non-approved steaks
513     todaysHash = s.todaysHash;       // The hash in the image should match this hash.
514     awarded = s.awarded;         // Amount awarded   // return (users[index].salaryId, users[index].name, users[index].userAddress, users[index].salary);
515     // return (recipient, url, judged, submissionApproved, judgedBy, adminComments, todaysHash, awarded);
516   }
517 
518 
519 
520   // Members judge steak pics, providing justification if necessary.
521   function judge(uint submissionNumber, bool supportsSubmission, bytes32 justificationText) onlyMembers {
522     Submission storage s = submissions[submissionNumber];         // Get the submission.
523     require(!s.judged);                                     // Musn't be judged.
524 
525     s.judged = true;
526     s.judgedBy = msg.sender;
527     s.submissionApproved = supportsSubmission;
528     s.adminComments = justificationText;    // Admin can add comments whether approved or not
529 
530     if (supportsSubmission) { // If it passed muster, credit the user and admin.
531       uint prizeAmount = getSteakPrize(); // Calculate BOV prize
532       s.awarded = prizeAmount;            // Record amount in the Submission
533       mint(s.recipient, prizeAmount);     // Credit the user's account
534 
535       // Credit the member one-third of the prize amount.
536       uint adminAward = prizeAmount.div(3);
537       mint(msg.sender, adminAward);
538 
539       approvedSubmissions.push(s);
540     }
541 
542     Judged(submissionNumber, supportsSubmission, msg.sender, justificationText);
543   }
544 
545 
546   // Calculate how many BOV are rewarded per approved steak pic.
547   function getSteakPrize() public constant returns (uint) {
548     require(initialPrizeBov > 0); // crowdsale must be over (endCrowdsale() calls setInitialPrize())
549     uint halvings = numberOfApprovedSteaks().div(halvingInterval);
550     if (halvings > numberOfHalvings) {  // After 8 halvings, no more BOV is awarded.
551       return 0;
552     }
553 
554     uint prize = initialPrizeBov;
555 
556     prize = prize >> halvings; // Halve the initial prize "halvings"-number of times.
557     return prize;
558   }
559 
560 
561   function numberOfApprovedSteaks() public constant returns (uint) {
562     return approvedSubmissions.length;
563   }
564 
565 
566   // Always call this before calling dailyHash and submitting a steak.
567   // If expired, the new hash is set to the last block's hash.
568   function getDailyHash() public returns (bytes32) {
569     if (dailyHashExpires > now) { // If the hash hasn't expired yet, return it.
570       return dailyHash;
571     } else { // Udderwise, set the new dailyHash and dailyHashExpiration.
572 
573       // Get hash from the last block.
574       bytes32 newHash = block.blockhash(block.number-1);
575       dailyHash = newHash;
576 
577       // Set the new expiration, jumping ahead in 24-hour increments so the expiration time remains roughly constant from day to day (e.g. 3am).
578       uint nextExpiration = dailyHashExpires + 24 hours; // It will already be expired, so set it to next possible date.
579       while (nextExpiration < now) { // if it's still in the past, advance by 24 hours.
580         nextExpiration += 24 hours;
581       }
582       dailyHashExpires = nextExpiration;
583       return newHash;
584     }
585   }
586 
587   // Returns the amount of minutes to post with the current dailyHash
588   function minutesToPost() public constant returns (uint) {
589     if (dailyHashExpires > now) {
590       return (dailyHashExpires - now) / 60; // returns minutes
591     } else {
592       return 0;
593     }
594   }
595 
596   function currentBlock() public constant returns (uint) {
597     return block.number;
598   }
599 }