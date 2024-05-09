1 pragma solidity^0.4.24;
2 
3 /**
4 *                          MOBIUS RED
5 *                     https://mobius.red/
6 *                                       
7 *    This game was inspired by FOMO3D. Our code is much cleaner and more efficient (built from scratch).
8 *    Some useless "features" like the teams were not implemented.
9 * 
10 *    The Mobius RED game consists of rounds with guaranteed winners!
11 *    You buy "shares" (instad of keys) for a given round, and you get returns from investors after you.
12 *    The share price is constant until the hard deadline, after which it increases exponentially. 
13 *    If a round is inactive for a day it can end earlier than the hard deadline.
14 *    If a round runs longer, it is guaranteed to finish not much after the hard deadline (and the last investor gets the big jackpot).
15 *    Additionally, if you invest more than 0.1 ETH you get a chance to win an airdrop and you get bonus shares
16 *    Part of all funds also go to a big final jackpot - the last investor (before a round runs out) wins.
17 *    Payouts work in REAL TIME - you can withdraw your returns at any time!
18 *    Additionally, the first round is an ICO, so you'll also get our tokens by participating!
19 *    !!!!!!!!!!!!!!
20 *    Token holders will receive part of current and future revenue of this and any other game we develop!
21 *    !!!!!!!!!!!!!!
22 */
23  
24  
25 contract DSMath {
26     function add(uint x, uint y) internal pure returns (uint z) {
27         require((z = x + y) >= x);
28     }
29     function sub(uint x, uint y) internal pure returns (uint z) {
30         require((z = x - y) <= x);
31     }
32     function mul(uint x, uint y) internal pure returns (uint z) {
33         require(y == 0 || (z = x * y) / y == x);
34     }
35 
36     function min(uint x, uint y) internal pure returns (uint z) {
37         return x <= y ? x : y;
38     }
39     function max(uint x, uint y) internal pure returns (uint z) {
40         return x >= y ? x : y;
41     }
42     function imin(int x, int y) internal pure returns (int z) {
43         return x <= y ? x : y;
44     }
45     function imax(int x, int y) internal pure returns (int z) {
46         return x >= y ? x : y;
47     }
48 
49     uint constant WAD = 10 ** 18;
50     uint constant RAY = 10 ** 27;
51 
52     function wmul(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, y), WAD / 2) / WAD;
54     }
55     function rmul(uint x, uint y) internal pure returns (uint z) {
56         z = add(mul(x, y), RAY / 2) / RAY;
57     }
58     function wdiv(uint x, uint y) internal pure returns (uint z) {
59         z = add(mul(x, WAD), y / 2) / y;
60     }
61     function rdiv(uint x, uint y) internal pure returns (uint z) {
62         z = add(mul(x, RAY), y / 2) / y;
63     }
64 
65     // This famous algorithm is called "exponentiation by squaring"
66     // and calculates x^n with x as fixed-point and n as regular unsigned.
67     //
68     // It's O(log n), instead of O(n) for naive repeated multiplication.
69     //
70     // These facts are why it works:
71     //
72     //  If n is even, then x^n = (x^2)^(n/2).
73     //  If n is odd,  then x^n = x * x^(n-1),
74     //   and applying the equation for even x gives
75     //    x^n = x * (x^2)^((n-1) / 2).
76     //
77     //  Also, EVM division is flooring and
78     //    floor[(n-1) / 2] = floor[n / 2].
79     //
80     function rpow(uint x, uint n) internal pure returns (uint z) {
81         z = n % 2 != 0 ? x : RAY;
82 
83         for (n /= 2; n != 0; n /= 2) {
84             x = rmul(x, x);
85 
86             if (n % 2 != 0) {
87                 z = rmul(z, x);
88             }
89         }
90     }
91 }
92 
93 contract DSAuthority {
94     function canCall(
95         address src, address dst, bytes4 sig
96     ) public view returns (bool);
97 }
98 
99 contract DSAuthEvents {
100     event LogSetAuthority (address indexed authority);
101     event LogSetOwner     (address indexed owner);
102 }
103 
104 contract DSAuth is DSAuthEvents {
105     DSAuthority  public  authority;
106     address      public  owner;
107 
108     constructor() public {
109         owner = msg.sender;
110         emit LogSetOwner(msg.sender);
111     }
112 
113     function setOwner(address owner_)
114         public
115         auth
116     {
117         owner = owner_;
118         emit LogSetOwner(owner);
119     }
120 
121     function setAuthority(DSAuthority authority_)
122         public
123         auth
124     {
125         authority = authority_;
126         emit LogSetAuthority(authority);
127     }
128 
129     modifier auth {
130         require(isAuthorized(msg.sender, msg.sig));
131         _;
132     }
133 
134     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
135         if (src == address(this)) {
136             return true;
137         } else if (src == owner) {
138             return true;
139         } else if (authority == DSAuthority(0)) {
140             return false;
141         } else {
142             return authority.canCall(src, this, sig);
143         }
144     }
145 }
146 
147 interface MobiusRedToken {
148     function mint(address _to, uint _amount) external;
149     function finishMinting() external returns (bool);
150     function disburseDividends() external payable;
151 }
152  
153 contract MobiusRED is DSMath, DSAuth {
154     // IPFS hash of the website - can be accessed even if our domain goes down.
155     // Just go to any public IPFS gateway and use this hash - e.g. ipfs.infura.io/ipfs/<ipfsHash>
156     string public ipfsHash;
157     string public ipfsHashType = "ipfs"; // can either be ipfs, or ipns
158 
159     MobiusRedToken public token;
160 
161     // In case of an upgrade, these variables will be set. An upgrade does not affect a currently running round,
162     // nor does it do anything with investors' vaults.
163     bool public upgraded;
164     address public nextVersion;
165 
166     // Total stats
167     uint public totalSharesSold;
168     uint public totalEarningsGenerated;
169     uint public totalDividendsPaid;
170     uint public totalJackpotsWon;
171 
172     // Fractions for where revenue goes
173     uint public constant DEV_FRACTION = WAD / 20;             // 5% goes to devs
174     uint public constant DEV_DIVISOR = 20;             // 5% 
175 
176     uint public constant RETURNS_FRACTION = 65 * 10**16;      // 65% goes to share holders
177     // 1% if it is a referral purchase, this value will be taken from the above fraction (e.g. if 1% is for refferals, then 64% goes to returns) 
178     uint public constant REFERRAL_FRACTION = 1 * 10**16;  
179     uint public constant JACKPOT_SEED_FRACTION = WAD / 20;    // 5% goes to the next round's jackpot
180     uint public constant JACKPOT_FRACTION = 15 * 10**16;      // 15% goes to the final jackpot
181     uint public constant AIRDROP_FRACTION = WAD / 100;        // 1% goes to airdrops
182     uint public constant DIVIDENDS_FRACTION = 9 * 10**16;     // 9% goes to token holders!
183 
184     uint public constant STARTING_SHARE_PRICE = 1 finney; // a 1000th of an ETH
185     uint public constant PRICE_INCREASE_PERIOD = 1 hours; // how often the price doubles after the hard deadline
186 
187     uint public constant HARD_DEADLINE_DURATION = 10 days; // hard deadline is this much after the round start
188     uint public constant SOFT_DEADLINE_DURATION = 1 days; // max soft deadline
189     uint public constant TIME_PER_SHARE = 5 minutes; // how much time is added to the soft deadline per share purchased
190     
191     uint public jackpotSeed;// Jackpot from previous rounds
192     uint public devBalance; // outstanding balance for devs
193     uint public raisedICO;
194 
195     // Helpers to calculate returns - no funds are ever held on lockdown
196     uint public unclaimedReturns;
197     uint public constant MULTIPLIER = RAY;
198 
199     // This represents an investor. No need to player IDs - they are useless (everyone already has a unique address).
200     // Just use native mappings (duh!)
201     struct Investor {
202         uint lastCumulativeReturnsPoints;
203         uint shares;
204     }
205 
206     // This represents a round
207     struct MobiusRound {
208         uint totalInvested;        
209         uint jackpot;
210         uint airdropPot;
211         uint totalShares;
212         uint cumulativeReturnsPoints; // this is to help calculate returns when the total number of shares changes
213         uint hardDeadline;
214         uint softDeadline;
215         uint price;
216         uint lastPriceIncreaseTime;
217         address lastInvestor;
218         bool finalized;
219         mapping (address => Investor) investors;
220     }
221 
222     struct Vault {
223         uint totalReturns; // Total balance = returns + referral returns + jackpots/airdrops 
224         uint refReturns; // how much of the total is from referrals
225     }
226 
227     mapping (address => Vault) vaults;
228 
229     uint public latestRoundID;// the first round has an ID of 0
230     MobiusRound[] rounds;
231 
232     event SharesIssued(address indexed to, uint shares);
233     event ReturnsWithdrawn(address indexed by, uint amount);
234     event JackpotWon(address by, uint amount);
235     event AirdropWon(address by, uint amount);
236     event RoundStarted(uint indexed ID, uint hardDeadline);
237     event IPFSHashSet(string _type, string _hash);
238 
239     constructor(address _token) public {
240         token = MobiusRedToken(_token);
241     }
242 
243     // The return values will include all vault balance, but you must specify a roundID because
244     // Returns are not actually calculated in storage until you invest in the round or withdraw them
245     function estimateReturns(address investor, uint roundID) public view 
246     returns (uint totalReturns, uint refReturns) 
247     {
248         MobiusRound storage rnd = rounds[roundID];
249         uint outstanding;
250         if(rounds.length > 1) {
251             if(hasReturns(investor, roundID - 1)) {
252                 MobiusRound storage prevRnd = rounds[roundID - 1];
253                 outstanding = _outstandingReturns(investor, prevRnd);
254             }
255         }
256 
257         outstanding += _outstandingReturns(investor, rnd);
258         
259         totalReturns = vaults[investor].totalReturns + outstanding;
260         refReturns = vaults[investor].refReturns;
261     }
262 
263     function hasReturns(address investor, uint roundID) public view returns (bool) {
264         MobiusRound storage rnd = rounds[roundID];
265         return rnd.cumulativeReturnsPoints > rnd.investors[investor].lastCumulativeReturnsPoints;
266     }
267 
268     function investorInfo(address investor, uint roundID) external view
269     returns(uint shares, uint totalReturns, uint referralReturns) 
270     {
271         MobiusRound storage rnd = rounds[roundID];
272         shares = rnd.investors[investor].shares;
273         (totalReturns, referralReturns) = estimateReturns(investor, roundID);
274     }
275 
276     function roundInfo(uint roundID) external view 
277     returns(
278         address leader, 
279         uint price,
280         uint jackpot, 
281         uint airdrop, 
282         uint shares, 
283         uint totalInvested,
284         uint distributedReturns,
285         uint _hardDeadline,
286         uint _softDeadline,
287         bool finalized
288         )
289     {
290         MobiusRound storage rnd = rounds[roundID];
291         leader = rnd.lastInvestor;
292         price = rnd.price;
293         jackpot = rnd.jackpot;
294         airdrop = rnd.airdropPot;
295         shares = rnd.totalShares;
296         totalInvested = rnd.totalInvested;
297         distributedReturns = wmul(rnd.totalInvested, RETURNS_FRACTION);
298         _hardDeadline = rnd.hardDeadline;
299         _softDeadline = rnd.softDeadline;
300         finalized = rnd.finalized;
301     }
302 
303     function totalsInfo() external view 
304     returns(
305         uint totalReturns,
306         uint totalShares,
307         uint totalDividends,
308         uint totalJackpots
309     ) {
310         MobiusRound storage rnd = rounds[latestRoundID];
311         if(rnd.softDeadline > now) {
312             totalShares = totalSharesSold + rnd.totalShares;
313             totalReturns = totalEarningsGenerated + wmul(rnd.totalInvested, RETURNS_FRACTION);
314             totalDividends = totalDividendsPaid + wmul(rnd.totalInvested, DIVIDENDS_FRACTION);
315         } else {
316             totalShares = totalSharesSold;
317             totalReturns = totalEarningsGenerated;
318             totalDividends = totalDividendsPaid;
319         }
320         totalJackpots = totalJackpotsWon;
321     }
322 
323     function () public payable {
324         buyShares(address(0x0));
325     }
326 
327     /// Function to buy shares in the latest round. Purchase logic is abstracted
328     function buyShares(address ref) public payable {        
329         if(rounds.length > 0) {
330             MobiusRound storage rnd = rounds[latestRoundID];   
331                
332             _purchase(rnd, msg.value, ref);            
333         } else {
334             revert("Not yet started");
335         }
336     }
337 
338     /// Function to purchase with what you have in your vault as returns
339     function reinvestReturns(uint value) public {        
340         reinvestReturns(value, address(0x0));
341     }
342 
343     function reinvestReturns(uint value, address ref) public {        
344         MobiusRound storage rnd = rounds[latestRoundID];
345         _updateReturns(msg.sender, rnd);        
346         require(vaults[msg.sender].totalReturns >= value, "Can't spend what you don't have");        
347         vaults[msg.sender].totalReturns = sub(vaults[msg.sender].totalReturns, value);
348         vaults[msg.sender].refReturns = min(vaults[msg.sender].refReturns, vaults[msg.sender].totalReturns);
349         unclaimedReturns = sub(unclaimedReturns, value);
350         _purchase(rnd, value, ref);
351     }
352 
353     function withdrawReturns() public {
354         MobiusRound storage rnd = rounds[latestRoundID];
355 
356         if(rounds.length > 1) {// check if they also have returns from before
357             if(hasReturns(msg.sender, latestRoundID - 1)) {
358                 MobiusRound storage prevRnd = rounds[latestRoundID - 1];
359                 _updateReturns(msg.sender, prevRnd);
360             }
361         }
362         _updateReturns(msg.sender, rnd);
363         uint amount = vaults[msg.sender].totalReturns;
364         require(amount > 0, "Nothing to withdraw!");
365         unclaimedReturns = sub(unclaimedReturns, amount);
366         vaults[msg.sender].totalReturns = 0;
367         vaults[msg.sender].refReturns = 0;
368         
369         rnd.investors[msg.sender].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
370         msg.sender.transfer(amount);
371 
372         emit ReturnsWithdrawn(msg.sender, amount);
373     }
374 
375     // Manually update your returns for a given round in case you were inactive since before it ended
376     function updateMyReturns(uint roundID) public {
377         MobiusRound storage rnd = rounds[roundID];
378         _updateReturns(msg.sender, rnd);
379     }
380 
381     function finalizeAndRestart() public payable {
382         finalizeLastRound();
383         startNewRound();
384     }
385 
386     /// Anyone can start a new round
387     function startNewRound() public payable {
388         require(!upgraded, "This contract has been upgraded!");
389         if(rounds.length > 0) {
390             require(rounds[latestRoundID].finalized, "Previous round not finalized");
391             require(rounds[latestRoundID].softDeadline < now, "Previous round still running");
392         }
393         uint _rID = rounds.length++;
394         MobiusRound storage rnd = rounds[_rID];
395         latestRoundID = _rID;
396 
397         rnd.lastInvestor = msg.sender;
398         rnd.price = STARTING_SHARE_PRICE;
399         rnd.hardDeadline = now + HARD_DEADLINE_DURATION;
400         rnd.softDeadline = now + SOFT_DEADLINE_DURATION;
401         rnd.jackpot = jackpotSeed;
402         jackpotSeed = 0; 
403 
404         _purchase(rnd, msg.value, address(0x0));
405         emit RoundStarted(_rID, rnd.hardDeadline);
406     }
407 
408     /// Anyone can finalize a finished round
409     function finalizeLastRound() public {
410         MobiusRound storage rnd = rounds[latestRoundID];
411         _finalizeRound(rnd);
412     }
413     
414     /// This is how devs pay the bills
415     function withdrawDevShare() public auth {
416         uint value = devBalance;
417         devBalance = 0;
418         msg.sender.transfer(value);
419     }
420 
421     function setIPFSHash(string _type, string _hash) public auth {
422         ipfsHashType = _type;
423         ipfsHash = _hash;
424         emit IPFSHashSet(_type, _hash);
425     }
426 
427     function upgrade(address _nextVersion) public auth {
428         require(_nextVersion != address(0x0), "Invalid Address!");
429         require(!upgraded, "Already upgraded!");
430         upgraded = true;
431         nextVersion = _nextVersion;
432         if(rounds[latestRoundID].finalized) {
433             //if last round was finalized (and no new round was started), transfer the jackpot seed to the new version
434             vaults[nextVersion].totalReturns = jackpotSeed;
435             jackpotSeed = 0;
436         }
437     }
438 
439     /// Purchase logic
440     function _purchase(MobiusRound storage rnd, uint value, address ref) internal {
441         require(rnd.softDeadline >= now, "After deadline!");
442         require(value >= rnd.price/10, "Not enough Ether!");
443         rnd.totalInvested = add(rnd.totalInvested, value);
444 
445         // Set the last investor (to win the jackpot after the deadline)
446         if(value >= rnd.price)
447             rnd.lastInvestor = msg.sender;
448         // Check out airdrop 
449         _airDrop(rnd, value);
450         // Process revenue in different "buckets"
451         _splitRevenue(rnd, value, ref);
452         // Update returns before issuing shares
453         _updateReturns(msg.sender, rnd);
454         //issue shares for the current round. 1 share = 1 time increase for the deadline
455         uint newShares = _issueShares(rnd, msg.sender, value);
456 
457         //Mint tokens during the first round
458         if(rounds.length == 1) {
459             token.mint(msg.sender, newShares);
460         }
461         uint timeIncreases = newShares/WAD;// since 1 share is represented by 1 * 10^18, divide by 10^18
462         // adjust soft deadline to new soft deadline
463         uint newDeadline = add(rnd.softDeadline, mul(timeIncreases, TIME_PER_SHARE));
464         rnd.softDeadline = min(newDeadline, now + SOFT_DEADLINE_DURATION);
465         // If after hard deadline, double the price every price increase periods
466         if(now > rnd.hardDeadline) {
467             if(now > rnd.lastPriceIncreaseTime + PRICE_INCREASE_PERIOD) {
468                 rnd.price = rnd.price * 2;
469                 rnd.lastPriceIncreaseTime = now;
470             }
471         }
472     }
473 
474     function _finalizeRound(MobiusRound storage rnd) internal {
475         require(!rnd.finalized, "Already finalized!");
476         require(rnd.softDeadline < now, "Round still running!");
477 
478         if(rounds.length == 1) {
479             // After finishing minting tokens they will be transferable and dividends will be available!
480             require(token.finishMinting(), "Couldn't finish minting tokens!");
481         }
482         // Transfer jackpot to winner's vault
483         vaults[rnd.lastInvestor].totalReturns = add(vaults[rnd.lastInvestor].totalReturns, rnd.jackpot);
484         unclaimedReturns = add(unclaimedReturns, rnd.jackpot);
485         
486         emit JackpotWon(rnd.lastInvestor, rnd.jackpot);
487         totalJackpotsWon += rnd.jackpot;
488         // transfer the leftover to the next round's jackpot
489         jackpotSeed = add(jackpotSeed, wmul(rnd.totalInvested, JACKPOT_SEED_FRACTION));
490         //Empty the AD pot if it has a balance.
491         jackpotSeed = add(jackpotSeed, rnd.airdropPot);
492         if(upgraded) {
493             // if upgraded transfer the jackpot seed to the new version
494             vaults[nextVersion].totalReturns = jackpotSeed;
495             jackpotSeed = 0; 
496         }        
497         //Send out dividends to token holders
498         uint _div;
499         if(rounds.length == 1){
500             // 2% during the first round, and the normal fraction otherwise
501             _div = wmul(rnd.totalInvested, 2 * 10**16);            
502         } else {
503             _div = wmul(rnd.totalInvested, DIVIDENDS_FRACTION);            
504         }
505         token.disburseDividends.value(_div)();
506         totalDividendsPaid += _div;
507         totalSharesSold += rnd.totalShares;
508         totalEarningsGenerated += wmul(rnd.totalInvested, RETURNS_FRACTION);
509 
510         rnd.finalized = true;
511     }
512 
513     /** 
514         This is where the magic happens: every investor gets an exact share of all returns proportional to their shares
515         If you're early, you'll have a larger share for longer, so obviously you earn more.
516     */
517     function _updateReturns(address _investor, MobiusRound storage rnd) internal {
518         if(rnd.investors[_investor].shares == 0) {
519             return;
520         }
521         
522         uint outstanding = _outstandingReturns(_investor, rnd);
523 
524         // if there are any returns, transfer them to the investor's vaults
525         if (outstanding > 0) {
526             vaults[_investor].totalReturns = add(vaults[_investor].totalReturns, outstanding);
527         }
528 
529         rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
530     }
531 
532     function _outstandingReturns(address _investor, MobiusRound storage rnd) internal view returns(uint) {
533         if(rnd.investors[_investor].shares == 0) {
534             return 0;
535         }
536         // check if there've been new returns
537         uint newReturns = sub(
538             rnd.cumulativeReturnsPoints, 
539             rnd.investors[_investor].lastCumulativeReturnsPoints
540             );
541 
542         uint outstanding = 0;
543         if(newReturns != 0) { 
544             // outstanding returns = (total new returns points * ivestor shares) / MULTIPLIER
545             // The MULTIPLIER is used also at the point of returns disbursment
546             outstanding = mul(newReturns, rnd.investors[_investor].shares) / MULTIPLIER;
547         }
548 
549         return outstanding;
550     }
551 
552     /// Process revenue according to fractions
553     function _splitRevenue(MobiusRound storage rnd, uint value, address ref) internal {
554         uint roundReturns;
555         uint returnsOffset;
556         if(rounds.length == 1){
557             returnsOffset = 13 * 10**16;// during the first round reduce returns (by 13%) and give more to the ICO
558         }
559         if(ref != address(0x0)) {
560             // if there was a referral
561             roundReturns = wmul(value, RETURNS_FRACTION - REFERRAL_FRACTION - returnsOffset);
562             uint _ref = wmul(value, REFERRAL_FRACTION);
563             vaults[ref].totalReturns = add(vaults[ref].totalReturns, _ref);            
564             vaults[ref].refReturns = add(vaults[ref].refReturns, _ref);
565             unclaimedReturns = add(unclaimedReturns, _ref);
566         } else {
567             roundReturns = wmul(value, RETURNS_FRACTION - returnsOffset);
568         }
569         
570         uint airdrop = wmul(value, AIRDROP_FRACTION);
571         uint jackpot = wmul(value, JACKPOT_FRACTION);
572         
573         uint dev;
574         // During the ICO, devs get 25% (5% originally, 7% from the dividends fraction, 
575         // and 13% from the returns), leaving 2% for dividends, and 52% for returns 
576         // This is only during the first round, and later rounds leave the original fractions:
577         // 5% for devs, 9% dividends, 65% returns 
578         if(rounds.length == 1){
579             // calculate dividends at the end, no need to do it at every purchase
580             dev = value / 4; // 25% 
581             raisedICO += dev;
582         } else {
583             dev = value / DEV_DIVISOR;
584         }
585         // if this is the first purchase, send to jackpot (no one can claim these returns otherwise)
586         if(rnd.totalShares == 0) {
587             rnd.jackpot = add(rnd.jackpot, roundReturns);
588         } else {
589             _disburseReturns(rnd, roundReturns);
590         }
591         
592         rnd.airdropPot = add(rnd.airdropPot, airdrop);
593         rnd.jackpot = add(rnd.jackpot, jackpot);
594         devBalance = add(devBalance, dev);
595     }
596 
597     function _disburseReturns(MobiusRound storage rnd, uint value) internal {
598         unclaimedReturns = add(unclaimedReturns, value);// keep track of unclaimed returns
599         // The returns points represent returns*MULTIPLIER/totalShares (at the point of purchase)
600         // This allows us to keep outstanding balances of shareholders when the total supply changes in real time
601         if(rnd.totalShares == 0) {
602             rnd.cumulativeReturnsPoints = mul(value, MULTIPLIER) / wdiv(value, rnd.price);
603         } else {
604             rnd.cumulativeReturnsPoints = add(
605                 rnd.cumulativeReturnsPoints, 
606                 mul(value, MULTIPLIER) / rnd.totalShares
607             );
608         }
609     }
610 
611     function _issueShares(MobiusRound storage rnd, address _investor, uint value) internal returns(uint) {    
612         if(rnd.investors[_investor].lastCumulativeReturnsPoints == 0) {
613             rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
614         }    
615         
616         uint newShares = wdiv(value, rnd.price);
617         
618         //bonuses:
619         if(value >= 100 ether) {
620             newShares = mul(newShares, 2);//get double shares if you paid more than 100 ether
621         } else if(value >= 10 ether) {
622             newShares = add(newShares, newShares/2);//50% bonus
623         } else if(value >= 1 ether) {
624             newShares = add(newShares, newShares/3);//33% bonus
625         } else if(value >= 100 finney) {
626             newShares = add(newShares, newShares/10);//10% bonus
627         }
628 
629         rnd.investors[_investor].shares = add(rnd.investors[_investor].shares, newShares);
630         rnd.totalShares = add(rnd.totalShares, newShares);
631         emit SharesIssued(_investor, newShares);
632         return newShares;
633     }    
634 
635     function _airDrop(MobiusRound storage rnd, uint value) internal {
636         require(msg.sender == tx.origin, "ONLY HOOMANS (or scripts that don't use smart contracts)!");
637         if(value > 100 finney) {
638             /**
639                 Creates a random number from the last block hash and current timestamp.
640                 One could add more seemingly random data like the msg.sender, etc, but that doesn't 
641                 make it harder for a miner to manipulate the result in their favor (if they intended to).
642              */
643             uint chance = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), now)));
644             if(chance % 200 == 0) {// once in 200 times
645                 uint prize = rnd.airdropPot / 2;// win half of the pot, regardless of how much you paid
646                 rnd.airdropPot = rnd.airdropPot / 2;
647                 vaults[msg.sender].totalReturns = add(vaults[msg.sender].totalReturns, prize);
648                 unclaimedReturns = add(unclaimedReturns, prize);
649                 totalJackpotsWon += prize;
650                 emit AirdropWon(msg.sender, prize);
651             }
652         }
653     }
654 }