1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 
58 
59 
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68     /**
69     * @dev Multiplies two numbers, throws on overflow.
70     */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72         if (a == 0) {
73             return 0;
74         }
75         c = a * b;
76         assert(c / a == b);
77         return c;
78     }
79 
80     /**
81     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82     */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         assert(b <= a);
85         return a - b;
86     }
87 
88     /**
89     * @dev Adds two numbers, throws on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92         c = a + b;
93         assert(c >= a);
94         return c;
95     }
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract ToorToken is ERC20Basic, Ownable {
103     using SafeMath for uint256;
104 
105     struct Account {
106         uint balance;
107         uint lastInterval;
108     }
109 
110     mapping(address => Account) public accounts;
111     mapping(uint256 => uint256) ratesByYear;
112     mapping (address => mapping (address => uint256)) internal allowed;
113     uint256 private rateMultiplier;
114 
115     uint256 initialSupply_;
116     uint256 totalSupply_;
117     uint256 public maxSupply;
118     uint256 public startTime;
119     uint256 public pendingRewardsToMint;
120 
121     string public name;
122     uint public decimals;
123     string public symbol;
124 
125     uint256 private tokenGenInterval; // This defines the frequency at which we calculate rewards
126     uint256 private vestingPeriod; // Defines how often tokens vest to team
127     uint256 private cliff; // Defines the minimum amount of time required before tokens vest
128     uint256 public pendingInstallments; // Defines the number of pending vesting installments for team
129     uint256 public paidInstallments; // Defines the number of paid vesting installments for team
130     uint256 private totalVestingPool; //  Defines total vesting pool set aside for team
131     uint256 public pendingVestingPool; // Defines pending tokens in pool set aside for team
132     uint256 public finalIntervalForTokenGen; // The last instance of reward calculation, after which rewards will cease
133     uint256 private totalRateWindows; // This specifies the number of rate windows over the total period of time
134     uint256 private intervalsPerWindow; // Total number of times we calculate rewards within 1 rate window
135 
136     // Variable to define once reward generation is complete
137     bool public rewardGenerationComplete;
138 
139     // Ether addresses of founders and company
140     mapping(uint256 => address) public distributionAddresses;
141 
142     // Events section
143     event Mint(address indexed to, uint256 amount);
144     event Burn(address indexed burner, uint256 value);
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 
147     function ToorToken() public {
148         name = "ToorCoin";
149         decimals = 18;
150         symbol = "TOOR";
151 
152         // Setup the token staking reward percentage per year
153         rateMultiplier = 10**9;
154         ratesByYear[1] = 1.00474436 * 10**9;
155         ratesByYear[2] = 1.003278088 * 10**9;
156         ratesByYear[3] = 1.002799842 * 10**9;
157         ratesByYear[4] = 1.002443535 * 10**9;
158         ratesByYear[5] = 1.002167763 * 10**9;
159         ratesByYear[6] = 1.001947972 * 10**9;
160         ratesByYear[7] = 1.001768676 * 10**9;
161         ratesByYear[8] = 1.001619621 * 10**9;
162         ratesByYear[9] = 1.001493749 * 10**9;
163         ratesByYear[10] = 1.001386038 * 10**9;
164         ratesByYear[11] = 1.001292822 * 10**9;
165         ratesByYear[12] = 1.001211358 * 10**9;
166         ratesByYear[13] = 1.001139554 * 10**9;
167         ratesByYear[14] = 1.001075789 * 10**9;
168         ratesByYear[15] = 1.001018783 * 10**9;
169         ratesByYear[16] = 1.000967516 * 10**9;
170         ratesByYear[17] = 1.000921162 * 10**9;
171         ratesByYear[18] = 1.000879048 * 10**9;
172         ratesByYear[19] = 1.000840616 * 10**9;
173         ratesByYear[20] = 1.000805405 * 10**9;
174 
175         totalRateWindows = 20;
176         
177         maxSupply = 100000000 * 10**18;
178         initialSupply_ = 13500000 * 10**18;
179         pendingInstallments = 7;
180         paidInstallments = 0;
181         totalVestingPool = 4500000 * 10**18;
182         startTime = now;
183 
184         distributionAddresses[1] = 0x7d3BC9bb69dAB0544d34b7302DED8806bCF715e6; // founder 1
185         distributionAddresses[2] = 0x34Cf9afae3f926B9D040CA7A279C411355c5C480; // founder 2
186         distributionAddresses[3] = 0x059Cbd8A57b1dD944Da020a0D0a18D8dD7e78E04; // founder 3
187         distributionAddresses[4] = 0x4F8bC705827Fb8A781b27B9F02d2491F531f8962; // founder 4
188         distributionAddresses[5] = 0x532d370a98a478714625E9148D1205be061Df3bf; // founder 5
189         distributionAddresses[6] = 0xDe485bB000fA57e73197eF709960Fb7e32e0380E; // company
190         distributionAddresses[7] = 0xd562f635c75D2d7f3BE0005FBd3808a5cfb896bd; // bounty
191         
192         // This is for 20 years
193         tokenGenInterval = 603936;  // This is roughly 1 week in seconds
194         uint256 timeToGenAllTokens = 628093440; // This is close to 20 years in seconds
195 
196         rewardGenerationComplete = false;
197         
198         // Mint initial tokens
199         accounts[distributionAddresses[6]].balance = (initialSupply_ * 60) / 100; // 60% of initial balance goes to Company
200         accounts[distributionAddresses[6]].lastInterval = 0;
201         generateMintEvents(distributionAddresses[6],accounts[distributionAddresses[6]].balance);
202         accounts[distributionAddresses[7]].balance = (initialSupply_ * 40) / 100; // 40% of inital balance goes to Bounty
203         accounts[distributionAddresses[7]].lastInterval = 0;
204         generateMintEvents(distributionAddresses[7],accounts[distributionAddresses[7]].balance);
205 
206         pendingVestingPool = totalVestingPool;
207         pendingRewardsToMint = maxSupply - initialSupply_ - totalVestingPool;
208         totalSupply_ = initialSupply_;
209         vestingPeriod = timeToGenAllTokens / (totalRateWindows * 12); // One vesting period is a month
210         cliff = vestingPeriod * 6; // Cliff is six vesting periods aka 6 months roughly
211         finalIntervalForTokenGen = timeToGenAllTokens / tokenGenInterval;
212         intervalsPerWindow = finalIntervalForTokenGen / totalRateWindows;
213     }
214 
215     // This gives the total supply of actual minted coins. Does not take rewards pending minting into consideration
216     function totalSupply() public view returns (uint256) {
217         return totalSupply_;
218     }
219 
220     // This function is called directly by users who wish to transfer tokens
221     function transfer(address _to, uint256 _value) canTransfer(_to) public returns (bool) {
222         // Call underlying transfer method and pass in the sender address
223         transferBasic(msg.sender, _to, _value);
224         return true;
225     }
226 
227     // This function is called by both transfer and transferFrom
228     function transferBasic(address _from, address _to, uint256 _value) internal {
229         uint256 tokensOwedSender = 0;
230         uint256 tokensOwedReceiver = 0;
231         uint256 balSender = balanceOfBasic(_from);
232 
233         // Distribute rewards tokens first
234         if (!rewardGenerationComplete) {
235             tokensOwedSender = tokensOwed(_from);
236             require(_value <= (balSender.add(tokensOwedSender))); // Sender should have the number of tokens they want to send
237 
238             tokensOwedReceiver = tokensOwed(_to);
239 
240             // If there were tokens owed, increase total supply accordingly
241             if ((tokensOwedSender.add(tokensOwedReceiver)) > 0) {
242                 increaseTotalSupply(tokensOwedSender.add(tokensOwedReceiver)); // This will break if total exceeds max cap
243                 pendingRewardsToMint = pendingRewardsToMint.sub(tokensOwedSender.add(tokensOwedReceiver));
244             }
245 
246             // If there were tokens owed, raise mint events for them
247             raiseEventIfMinted(_from, tokensOwedSender);
248             raiseEventIfMinted(_to, tokensOwedReceiver);
249         } else {
250             require(_value <= balSender);
251         }
252         
253         // Update balances of sender and receiver
254         accounts[_from].balance = (balSender.add(tokensOwedSender)).sub(_value);
255         accounts[_to].balance = (accounts[_to].balance.add(tokensOwedReceiver)).add(_value);
256 
257         // Update last intervals for sender and receiver
258         uint256 currInt = intervalAtTime(now);
259         accounts[_from].lastInterval = currInt;
260         accounts[_to].lastInterval = currInt;
261 
262         emit Transfer(_from, _to, _value);
263     }
264 
265     // If you want to transfer tokens to multiple receivers at once
266     function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
267         uint256 cnt = _receivers.length;
268         uint256 amount = cnt.mul(_value);
269         
270         // Check that the value to send is more than 0
271         require(_value > 0);
272 
273         // Add pending rewards for sender first
274         if (!rewardGenerationComplete) {
275             addReward(msg.sender);
276         }
277 
278         // Get current balance of sender
279         uint256 balSender = balanceOfBasic(msg.sender);
280 
281         // Check that the sender has the required amount
282         require(balSender >= amount);
283 
284         // Update balance and lastInterval of sender
285         accounts[msg.sender].balance = balSender.sub(amount);
286         uint256 currInt = intervalAtTime(now);
287         accounts[msg.sender].lastInterval = currInt;
288         
289         
290         for (uint i = 0; i < cnt; i++) {
291             // Add pending rewards for receiver first
292             if (!rewardGenerationComplete) {
293                 address receiver = _receivers[i];
294                 
295                 addReward(receiver);
296             }
297 
298             // Update balance and lastInterval of receiver
299             accounts[_receivers[i]].balance = (accounts[_receivers[i]].balance).add(_value);
300             accounts[_receivers[i]].lastInterval = currInt;
301             emit Transfer(msg.sender, _receivers[i], _value);
302         }
303 
304         return true;
305     }
306 
307     // This function allows someone to withdraw tokens from someone's address
308     // For this to work, the person needs to have been approved by the account owner (via the approve function)
309     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_to) public returns (bool)
310     {
311         // Check that function caller has been approved to withdraw tokens
312         require(_value <= allowed[_from][msg.sender]);
313 
314         // Call out base transfer method
315         transferBasic(_from, _to, _value);
316 
317         // Subtract withdrawn tokens from allowance
318         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
319 
320         return true;
321     }
322 
323   /**
324    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325    *
326    * Beware that changing an allowance with this method brings the risk that someone may use both the old
327    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
328    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
329    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330    * @param _spender The address which will spend the funds.
331    * @param _value The amount of tokens to be spent.
332    */
333     function approve(address _spender, uint256 _value) public returns (bool) {
334         allowed[msg.sender][_spender] = _value;
335         emit Approval(msg.sender, _spender, _value);
336         return true;
337     }
338 
339       /**
340    * @dev Function to check the amount of tokens that an owner allowed to a spender.
341    * @param _owner address The address which owns the funds.
342    * @param _spender address The address which will spend the funds.
343    * @return A uint256 specifying the amount of tokens still available for the spender.
344    */
345     function allowance(address _owner, address _spender) public view returns (uint256)
346     {
347         return allowed[_owner][_spender];
348     }
349 
350   
351    // Increase the amount of tokens that an owner allowed to a spender.
352    // approve should be called when allowed[_spender] == 0. To increment
353    // allowed value is better to use this function to avoid 2 calls (and wait until the first transaction is mined)
354     function increaseApproval(address _spender, uint _addedValue) public returns (bool)
355     {
356         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
357         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358         return true;
359     }
360 
361    // Decrease the amount of tokens that an owner allowed to a spender.
362    // approve should be called when allowed[_spender] == 0. To decrement
363    // allowed value is better to use this function to avoid 2 calls (and wait until the first transaction is mined)
364     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
365     {
366         uint oldValue = allowed[msg.sender][_spender];
367         if (_subtractedValue > oldValue) {
368             allowed[msg.sender][_spender] = 0;
369         } else {
370             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
371         }
372         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373         return true;
374     }
375 
376     function raiseEventIfMinted(address owner, uint256 tokensToReward) private returns (bool) {
377         if (tokensToReward > 0) {
378             generateMintEvents(owner, tokensToReward);
379         }
380     }
381 
382     function addReward(address owner) private returns (bool) {
383         uint256 tokensToReward = tokensOwed(owner);
384 
385         if (tokensToReward > 0) {
386             increaseTotalSupply(tokensToReward); // This will break if total supply exceeds max cap. Should never happen though as tokensOwed checks for this condition
387             accounts[owner].balance = accounts[owner].balance.add(tokensToReward);
388             accounts[owner].lastInterval = intervalAtTime(now);
389             pendingRewardsToMint = pendingRewardsToMint.sub(tokensToReward); // This helps track rounding errors when computing rewards
390             generateMintEvents(owner, tokensToReward);
391         }
392 
393         return true;
394     }
395 
396     // This function is to vest tokens to the founding team
397     // This deliberately doesn't use SafeMath as all the values are controlled without risk of overflow
398     function vestTokens() public returns (bool) {
399         require(pendingInstallments > 0);
400         require(paidInstallments < 7);
401         require(pendingVestingPool > 0);
402         require(now - startTime > cliff);
403 
404         // If they have rewards pending, allocate those first
405         if (!rewardGenerationComplete) {
406             for (uint256 i = 1; i <= 5; i++) {
407                 addReward(distributionAddresses[i]);
408             }
409         }
410 
411         uint256 currInterval = intervalAtTime(now);
412         uint256 tokensToVest = 0;
413         uint256 totalTokensToVest = 0;
414         uint256 totalPool = totalVestingPool;
415 
416         uint256[2] memory founderCat;
417         founderCat[0] = 0;
418         founderCat[1] = 0;
419 
420         uint256[5] memory origFounderBal;
421         origFounderBal[0] = accounts[distributionAddresses[1]].balance;
422         origFounderBal[1] = accounts[distributionAddresses[2]].balance;
423         origFounderBal[2] = accounts[distributionAddresses[3]].balance;
424         origFounderBal[3] = accounts[distributionAddresses[4]].balance;
425         origFounderBal[4] = accounts[distributionAddresses[5]].balance;
426 
427         uint256[2] memory rewardCat;
428         rewardCat[0] = 0;
429         rewardCat[1] = 0;
430 
431         // Pay out cliff
432         if (paidInstallments < 1) {
433             uint256 intervalAtCliff = intervalAtTime(cliff + startTime);
434             tokensToVest = totalPool / 4;
435 
436             founderCat[0] = tokensToVest / 4;
437             founderCat[1] = tokensToVest / 8;
438 
439             // Update vesting pool
440             pendingVestingPool -= tokensToVest;
441 
442             // This condition checks if there are any rewards to pay after the cliff
443             if (currInterval > intervalAtCliff && !rewardGenerationComplete) {
444                 rewardCat[0] = tokensOwedByInterval(founderCat[0], intervalAtCliff, currInterval);
445                 rewardCat[1] = rewardCat[0] / 2;
446 
447                 // Add rewards to founder tokens being vested
448                 founderCat[0] += rewardCat[0];
449                 founderCat[1] += rewardCat[1];
450 
451                 // Increase total amount of tokens to vest
452                 tokensToVest += ((3 * rewardCat[0]) + (2 * rewardCat[1]));
453 
454                 // Reduce pending rewards
455                 pendingRewardsToMint -= ((3 * rewardCat[0]) + (2 * rewardCat[1]));
456             }
457 
458             // Vest tokens for each of the founders, this includes any rewards pending since cliff passed
459             accounts[distributionAddresses[1]].balance += founderCat[0];
460             accounts[distributionAddresses[2]].balance += founderCat[0];
461             accounts[distributionAddresses[3]].balance += founderCat[0];
462             accounts[distributionAddresses[4]].balance += founderCat[1];
463             accounts[distributionAddresses[5]].balance += founderCat[1];
464 
465             totalTokensToVest = tokensToVest;
466 
467             // Update pending and paid installments
468             pendingInstallments -= 1;
469             paidInstallments += 1;
470         }
471 
472         // Calculate the pending non-cliff installments to pay based on current time
473         uint256 installments = ((currInterval * tokenGenInterval) - cliff) / vestingPeriod;
474         uint256 installmentsToPay = installments + 1 - paidInstallments;
475 
476         // If there are no installments to pay, skip this
477         if (installmentsToPay > 0) {
478             if (installmentsToPay > pendingInstallments) {
479                 installmentsToPay = pendingInstallments;
480             }
481 
482             // 12.5% vesting monthly after the cliff
483             tokensToVest = (totalPool * 125) / 1000;
484 
485             founderCat[0] = tokensToVest / 4;
486             founderCat[1] = tokensToVest / 8;
487 
488             uint256 intervalsAtVest = 0;
489 
490             // Loop through installments to pay, so that we can add token holding rewards as we go along
491             for (uint256 installment = paidInstallments; installment < (installmentsToPay + paidInstallments); installment++) {
492                 intervalsAtVest = intervalAtTime(cliff + (installment * vestingPeriod) + startTime);
493 
494                 // This condition checks if there are any rewards to pay after the cliff
495                 if (currInterval >= intervalsAtVest && !rewardGenerationComplete) {
496                     rewardCat[0] = tokensOwedByInterval(founderCat[0], intervalsAtVest, currInterval);
497                     rewardCat[1] = rewardCat[0] / 2;
498 
499                     // Increase total amount of tokens to vest
500                     totalTokensToVest += tokensToVest;
501                     totalTokensToVest += ((3 * rewardCat[0]) + (2 * rewardCat[1]));
502 
503                     // Reduce pending rewards
504                     pendingRewardsToMint -= ((3 * rewardCat[0]) + (2 * rewardCat[1]));
505 
506                     // Vest tokens for each of the founders, this includes any rewards pending since vest interval passed
507                     accounts[distributionAddresses[1]].balance += (founderCat[0] + rewardCat[0]);
508                     accounts[distributionAddresses[2]].balance += (founderCat[0] + rewardCat[0]);
509                     accounts[distributionAddresses[3]].balance += (founderCat[0] + rewardCat[0]);
510                     accounts[distributionAddresses[4]].balance += (founderCat[1] + rewardCat[1]);
511                     accounts[distributionAddresses[5]].balance += (founderCat[1] + rewardCat[1]);
512                 }
513             }
514 
515             // Reduce pendingVestingPool and update pending and paid installments
516             pendingVestingPool -= (installmentsToPay * tokensToVest);
517             pendingInstallments -= installmentsToPay;
518             paidInstallments += installmentsToPay;
519         }
520 
521         // Increase total supply by the number of tokens being vested
522         increaseTotalSupply(totalTokensToVest);
523             
524         accounts[distributionAddresses[1]].lastInterval = currInterval;
525         accounts[distributionAddresses[2]].lastInterval = currInterval;
526         accounts[distributionAddresses[3]].lastInterval = currInterval;
527         accounts[distributionAddresses[4]].lastInterval = currInterval;
528         accounts[distributionAddresses[5]].lastInterval = currInterval;
529 
530         // Create events for token generation
531         generateMintEvents(distributionAddresses[1], (accounts[distributionAddresses[1]].balance - origFounderBal[0]));
532         generateMintEvents(distributionAddresses[2], (accounts[distributionAddresses[2]].balance - origFounderBal[1]));
533         generateMintEvents(distributionAddresses[3], (accounts[distributionAddresses[3]].balance - origFounderBal[2]));
534         generateMintEvents(distributionAddresses[4], (accounts[distributionAddresses[4]].balance - origFounderBal[3]));
535         generateMintEvents(distributionAddresses[5], (accounts[distributionAddresses[5]].balance - origFounderBal[4]));
536     }
537 
538     function increaseTotalSupply (uint256 tokens) private returns (bool) {
539         require ((totalSupply_.add(tokens)) <= maxSupply);
540         totalSupply_ = totalSupply_.add(tokens);
541 
542         return true;
543     }
544 
545     function tokensOwed(address owner) public view returns (uint256) {
546         // This array is introduced to circumvent stack depth issues
547         uint256 currInterval = intervalAtTime(now);
548         uint256 lastInterval = accounts[owner].lastInterval;
549         uint256 balance = accounts[owner].balance;
550 
551         return tokensOwedByInterval(balance, lastInterval, currInterval);
552     }
553 
554     function tokensOwedByInterval(uint256 balance, uint256 lastInterval, uint256 currInterval) public view returns (uint256) {
555         // Once the specified address has received all possible rewards, don't calculate anything
556         if (lastInterval >= currInterval || lastInterval >= finalIntervalForTokenGen) {
557             return 0;
558         }
559 
560         uint256 tokensHeld = balance; //tokensHeld
561         uint256 intPerWin = intervalsPerWindow;
562         uint256 totalRateWinds = totalRateWindows;
563 
564         // Defines the number of intervals we compute rewards for at a time
565         uint256 intPerBatch = 5; // Hardcoded here instead of storing on blockchain to save gas
566 
567         mapping(uint256 => uint256) ratByYear = ratesByYear;
568         uint256 ratMultiplier = rateMultiplier;
569 
570         uint256 minRateWindow = (lastInterval / intPerWin).add(1);
571         uint256 maxRateWindow = (currInterval / intPerWin).add(1);
572         if (maxRateWindow > totalRateWinds) {
573             maxRateWindow = totalRateWinds;
574         }
575 
576         // Loop through pending periods of rewards, and calculate the total balance user should hold
577         for (uint256 rateWindow = minRateWindow; rateWindow <= maxRateWindow; rateWindow++) {
578             uint256 intervals = getIntervalsForWindow(rateWindow, lastInterval, currInterval, intPerWin);
579 
580             // This part is to ensure we don't overflow when rewards are pending for a large number of intervals
581             // Loop through interval in batches
582             while (intervals > 0) {
583                 if (intervals >= intPerBatch) {
584                     tokensHeld = (tokensHeld.mul(ratByYear[rateWindow] ** intPerBatch)) / (ratMultiplier ** intPerBatch);
585                     intervals = intervals.sub(intPerBatch);
586                 } else {
587                     tokensHeld = (tokensHeld.mul(ratByYear[rateWindow] ** intervals)) / (ratMultiplier ** intervals);
588                     intervals = 0;
589                 }
590             }            
591         }
592 
593         // Rewards owed are the total balance that user SHOULD have minus what they currently have
594         return (tokensHeld.sub(balance));
595     }
596 
597     function intervalAtTime(uint256 time) public view returns (uint256) {
598         // Check to see that time passed in is not before contract generation time, as that would cause a negative value in the next step
599         if (time <= startTime) {
600             return 0;
601         }
602 
603         // Based on time passed in, check how many intervals have elapsed
604         uint256 interval = (time.sub(startTime)) / tokenGenInterval;
605         uint256 finalInt = finalIntervalForTokenGen; // Assign to local to reduce gas
606         
607         // Return max intervals if it's greater than that time
608         if (interval > finalInt) {
609             return finalInt;
610         } else {
611             return interval;
612         }
613     }
614 
615     // This function checks how many intervals for a given window do we owe tokens to someone for 
616     function getIntervalsForWindow(uint256 rateWindow, uint256 lastInterval, uint256 currInterval, uint256 intPerWind) public pure returns (uint256) {
617         // If lastInterval for holder falls in a window previous to current one, the lastInterval for the window passed into the function would be the window start interval
618         if (lastInterval < ((rateWindow.sub(1)).mul(intPerWind))) {
619             lastInterval = ((rateWindow.sub(1)).mul(intPerWind));
620         }
621 
622         // If currentInterval for holder falls in a window higher than current one, the currentInterval for the window passed into the function would be the window end interval
623         if (currInterval > rateWindow.mul(intPerWind)) {
624             currInterval = rateWindow.mul(intPerWind);
625         }
626 
627         return currInterval.sub(lastInterval);
628     }
629 
630     // This function tells the balance of tokens at a particular address
631     function balanceOf(address _owner) public view returns (uint256 balance) {
632         if (rewardGenerationComplete) {
633             return accounts[_owner].balance;
634         } else {
635             return (accounts[_owner].balance).add(tokensOwed(_owner));
636         }
637     }
638 
639     function balanceOfBasic(address _owner) public view returns (uint256 balance) {
640         return accounts[_owner].balance;
641     }
642 
643     // This functions returns the last time at which rewards were transferred to a particular address
644     function lastTimeOf(address _owner) public view returns (uint256 interval, uint256 time) {
645         return (accounts[_owner].lastInterval, ((accounts[_owner].lastInterval).mul(tokenGenInterval)).add(startTime));
646     }
647 
648     // This function is not meant to be used. It's only written as a fail-safe against potential unforeseen issues
649     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
650         // Add pending rewards for recipient of minted tokens
651         if (!rewardGenerationComplete) {
652             addReward(_to);
653         }
654 
655         // Increase total supply by minted amount
656         increaseTotalSupply(_amount);
657 
658         // Update balance and last interval
659         accounts[_to].lastInterval = intervalAtTime(now);
660         accounts[_to].balance = (accounts[_to].balance).add(_amount);
661 
662         generateMintEvents(_to, _amount);
663         return true;
664     }
665 
666     function generateMintEvents(address _to, uint256 _amount) private returns (bool) {
667         emit Mint(_to, _amount);
668         emit Transfer(address(0), _to, _amount);
669 
670         return true;
671     }
672 
673     // Allows the burning of tokens
674     function burn(uint256 _value) public {
675         require(_value <= balanceOf(msg.sender));
676 
677         // First add any rewards pending for the person burning tokens
678         if (!rewardGenerationComplete) {
679             addReward(msg.sender);
680         }
681 
682         // Update balance and lastInterval of person burning tokens
683         accounts[msg.sender].balance = (accounts[msg.sender].balance).sub(_value);
684         accounts[msg.sender].lastInterval = intervalAtTime(now);
685 
686         // Update total supply
687         totalSupply_ = totalSupply_.sub(_value);
688 
689         // Raise events
690         emit Burn(msg.sender, _value);
691         emit Transfer(msg.sender, address(0), _value);
692     }
693 
694     // These set of functions allow changing of founder and company addresses
695     function setFounder(uint256 id, address _to) onlyOwner public returns (bool) {
696         require(_to != address(0));
697         distributionAddresses[id] = _to;
698         return true;
699     }
700 
701     // This is a setter for rewardGenerationComplete. It will be used to see if token rewards need to be computed, and can only be set by owner
702     function setRewardGenerationComplete(bool _value) onlyOwner public returns (bool) {
703         rewardGenerationComplete = _value;
704         return true;
705     }
706 
707     // This function is added to get a state of where the token is in term of reward generation
708     function getNow() public view returns (uint256, uint256, uint256) {
709         return (now, block.number, intervalAtTime(now));
710     }
711 
712     // This modifier is used on the transfer method and defines where tokens CANNOT be sent
713     modifier canTransfer(address _to) {
714         require(_to != address(0)); // Transfer should not be allowed to burn tokens
715         _;
716     }
717 }