1 pragma solidity^0.4.24;
2 
3 /**
4 *
5 *    
6 *       ▄▄▄▄███▄▄▄▄    ▄██████▄  ▀█████████▄   ▄█  ███    █▄     ▄████████      
7 *     ▄██▀▀▀███▀▀▀██▄ ███    ███   ███    ███ ███  ███    ███   ███    ███      
8 *     ███   ███   ███ ███    ███   ███    ███ ███▌ ███    ███   ███    █▀       
9 *     ███   ███   ███ ███    ███  ▄███▄▄▄██▀  ███▌ ███    ███   ███             
10 *     ███   ███   ███ ███    ███ ▀▀███▀▀▀██▄  ███▌ ███    ███ ▀███████████      
11 *     ███   ███   ███ ███    ███   ███    ██▄ ███  ███    ███          ███      
12 *     ███   ███   ███ ███    ███   ███    ███ ███  ███    ███    ▄█    ███      
13 *      ▀█   ███   █▀   ▀██████▀  ▄█████████▀  █▀   ████████▀   ▄████████▀       
14 *                                                                               
15 *    ▀█████████▄   ▄█       ███    █▄     ▄████████                             
16 *      ███    ███ ███       ███    ███   ███    ███                             
17 *      ███    ███ ███       ███    ███   ███    █▀                              
18 *     ▄███▄▄▄██▀  ███       ███    ███  ▄███▄▄▄                                 
19 *    ▀▀███▀▀▀██▄  ███       ███    ███ ▀▀███▀▀▀                                 
20 *      ███    ██▄ ███       ███    ███   ███    █▄                              
21 *      ███    ███ ███▌    ▄ ███    ███   ███    ███                             
22 *    ▄█████████▀  █████▄▄██ ████████▀    ██████████                             
23 *                 ▀                                                             
24 *    
25 *                     https://mobius.blue/
26 *                                       
27 *    This game was inspired by FOMO3D. Our code is much cleaner and more efficient (built from scratch).
28 *
29 *    Some useless "features" like the teams were not implemented.
30 *
31 *    The outrageous dev fees from M2D were also fixed.
32 * 
33 *    The Mobius BLUE game consists of rounds with guaranteed winners!
34 *    You buy "shares" (instad of keys) for a given round, and you get returns from investors after you.
35 *    The share price is constant until the 3 day hard deadline, after which it increases exponentially. 
36 *    It is guaranteed to finish not much after the hard deadline (and the last investor gets the big jackpot)
37 *    Payouts work in REAL TIME - you can withdraw your returns at any time!
38 *
39 *    Structure
40 *    15% Jackpot
41 *    70% Dividends
42 *    10% Tokens
43 *    4% Dev Fund
44 *    0.5% Jackpot Seed
45 *    0.5% Airdrop
46 *
47 *    Additionally, the first round is an ICO, so you'll also get our BLU tokens by participating!
48 *    
49 *    BLU Token holders will receive part of current and future revenue of this and any other game we develop!
50 *    !!!!!!!!!!!!!!
51 *
52 */
53  
54  
55 contract DSMath {
56     function add(uint x, uint y) internal pure returns (uint z) {
57         require((z = x + y) >= x);
58     }
59     function sub(uint x, uint y) internal pure returns (uint z) {
60         require((z = x - y) <= x);
61     }
62     function mul(uint x, uint y) internal pure returns (uint z) {
63         require(y == 0 || (z = x * y) / y == x);
64     }
65 
66     function min(uint x, uint y) internal pure returns (uint z) {
67         return x <= y ? x : y;
68     }
69     function max(uint x, uint y) internal pure returns (uint z) {
70         return x >= y ? x : y;
71     }
72     function imin(int x, int y) internal pure returns (int z) {
73         return x <= y ? x : y;
74     }
75     function imax(int x, int y) internal pure returns (int z) {
76         return x >= y ? x : y;
77     }
78 
79     uint constant WAD = 10 ** 18;
80     uint constant RAY = 10 ** 27;
81 
82     function wmul(uint x, uint y) internal pure returns (uint z) {
83         z = add(mul(x, y), WAD / 2) / WAD;
84     }
85     function rmul(uint x, uint y) internal pure returns (uint z) {
86         z = add(mul(x, y), RAY / 2) / RAY;
87     }
88     function wdiv(uint x, uint y) internal pure returns (uint z) {
89         z = add(mul(x, WAD), y / 2) / y;
90     }
91     function rdiv(uint x, uint y) internal pure returns (uint z) {
92         z = add(mul(x, RAY), y / 2) / y;
93     }
94 
95     // This famous algorithm is called "exponentiation by squaring"
96     // and calculates x^n with x as fixed-point and n as regular unsigned.
97     //
98     // It's O(log n), instead of O(n) for naive repeated multiplication.
99     //
100     // These facts are why it works:
101     //
102     //  If n is even, then x^n = (x^2)^(n/2).
103     //  If n is odd,  then x^n = x * x^(n-1),
104     //   and applying the equation for even x gives
105     //    x^n = x * (x^2)^((n-1) / 2).
106     //
107     //  Also, EVM division is flooring and
108     //    floor[(n-1) / 2] = floor[n / 2].
109     //
110     function rpow(uint x, uint n) internal pure returns (uint z) {
111         z = n % 2 != 0 ? x : RAY;
112 
113         for (n /= 2; n != 0; n /= 2) {
114             x = rmul(x, x);
115 
116             if (n % 2 != 0) {
117                 z = rmul(z, x);
118             }
119         }
120     }
121 }
122 
123 contract DSAuthority {
124     function canCall(
125         address src, address dst, bytes4 sig
126     ) public view returns (bool);
127 }
128 
129 contract DSAuthEvents {
130     event LogSetAuthority (address indexed authority);
131     event LogSetOwner     (address indexed owner);
132 }
133 
134 contract DSAuth is DSAuthEvents {
135     DSAuthority  public  authority;
136     address      public  owner;
137 
138     constructor() public {
139         owner = msg.sender;
140         emit LogSetOwner(msg.sender);
141     }
142 
143     function setOwner(address owner_)
144         public
145         auth
146     {
147         owner = owner_;
148         emit LogSetOwner(owner);
149     }
150 
151     function setAuthority(DSAuthority authority_)
152         public
153         auth
154     {
155         authority = authority_;
156         emit LogSetAuthority(authority);
157     }
158 
159     modifier auth {
160         require(isAuthorized(msg.sender, msg.sig));
161         _;
162     }
163 
164     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
165         if (src == address(this)) {
166             return true;
167         } else if (src == owner) {
168             return true;
169         } else if (authority == DSAuthority(0)) {
170             return false;
171         } else {
172             return authority.canCall(src, this, sig);
173         }
174     }
175 }
176 
177 interface MobiusBlueToken {
178     function mint(address _to, uint _amount) external;
179     function finishMinting() external returns (bool);
180     function disburseDividends() external payable;
181 }
182  
183 contract MobiusBLUE is DSMath, DSAuth {
184     // IPFS hash of the website - can be accessed even if our domain goes down.
185     // Just go to any public IPFS gateway and use this hash - e.g. ipfs.infura.io/ipfs/<ipfsHash>
186     string public ipfsHash;
187     string public ipfsHashType = "ipfs"; // can either be ipfs, or ipns
188 
189     MobiusBlueToken public token;
190 
191     // In case of an upgrade, these variables will be set. An upgrade does not affect a currently running round,
192     // nor does it do anything with investors' vaults.
193     bool public upgraded;
194     address public nextVersion;
195 
196     // Total stats
197     uint public totalSharesSold;
198     uint public totalEarningsGenerated;
199     uint public totalDividendsPaid;
200     uint public totalJackpotsWon;
201 
202     // Fractions for where revenue goes
203     uint public constant DEV_FRACTION = WAD / 25;             // 4% goes to devs
204     uint public constant DEV_DIVISOR = 25;             // 4% 
205 
206     uint public constant RETURNS_FRACTION = 70 * 10**16;      // 70% goes to share holders
207     // 1% if it is a referral purchase, this value will be taken from the above fraction (e.g. if 1% is for refferals, then 64% goes to returns) 
208     uint public constant REFERRAL_FRACTION = 1 * 10**16;  
209     uint public constant JACKPOT_SEED_FRACTION = WAD / 200;    // .5% goes to the next round's jackpot
210     uint public constant JACKPOT_FRACTION = 15 * 10**16;      // 15% goes to the final jackpot
211     uint public constant AIRDROP_FRACTION = WAD / 200;        // .5% goes to airdrops
212     uint public constant DIVIDENDS_FRACTION = 10 * 10**16;     // 10% goes to token holders!
213 
214     uint public constant STARTING_SHARE_PRICE = 1 finney; // a 1000th of an ETH
215     uint public constant PRICE_INCREASE_PERIOD = 1 hours; // how often the price doubles after the hard deadline
216 
217     uint public constant HARD_DEADLINE_DURATION = 1 days; // hard deadline is this much after the round start
218     uint public constant SOFT_DEADLINE_DURATION = 1 days; // max soft deadline
219     uint public constant TIME_PER_SHARE = 2 minutes; // how much time is added to the soft deadline per share purchased
220     
221     uint public jackpotSeed;// Jackpot from previous rounds
222     uint public devBalance; // outstanding balance for devs
223     uint public raisedICO;
224 
225     // Helpers to calculate returns - no funds are ever held on lockdown
226     uint public unclaimedReturns;
227     uint public constant MULTIPLIER = RAY;
228 
229     // This represents an investor. No need to player IDs - they are useless (everyone already has a unique address).
230     // Just use native mappings (duh!)
231     struct Investor {
232         uint lastCumulativeReturnsPoints;
233         uint shares;
234     }
235 
236     // This represents a round
237     struct MobiusRound {
238         uint totalInvested;        
239         uint jackpot;
240         uint airdropPot;
241         uint totalShares;
242         uint cumulativeReturnsPoints; // this is to help calculate returns when the total number of shares changes
243         uint hardDeadline;
244         uint softDeadline;
245         uint price;
246         uint lastPriceIncreaseTime;
247         address lastInvestor;
248         bool finalized;
249         mapping (address => Investor) investors;
250     }
251 
252     struct Vault {
253         uint totalReturns; // Total balance = returns + referral returns + jackpots/airdrops 
254         uint refReturns; // how much of the total is from referrals
255     }
256 
257     mapping (address => Vault) vaults;
258 
259     uint public latestRoundID;// the first round has an ID of 0
260     MobiusRound[] rounds;
261 
262     event SharesIssued(address indexed to, uint shares);
263     event ReturnsWithdrawn(address indexed by, uint amount);
264     event JackpotWon(address by, uint amount);
265     event AirdropWon(address by, uint amount);
266     event RoundStarted(uint indexed ID, uint hardDeadline);
267     event IPFSHashSet(string _type, string _hash);
268 
269     constructor(address _token) public {
270         token = MobiusBlueToken(_token);
271     }
272 
273     // The return values will include all vault balance, but you must specify a roundID because
274     // Returns are not actually calculated in storage until you invest in the round or withdraw them
275     function estimateReturns(address investor, uint roundID) public view 
276     returns (uint totalReturns, uint refReturns) 
277     {
278         MobiusRound storage rnd = rounds[roundID];
279         uint outstanding;
280         if(rounds.length > 1) {
281             if(hasReturns(investor, roundID - 1)) {
282                 MobiusRound storage prevRnd = rounds[roundID - 1];
283                 outstanding = _outstandingReturns(investor, prevRnd);
284             }
285         }
286 
287         outstanding += _outstandingReturns(investor, rnd);
288         
289         totalReturns = vaults[investor].totalReturns + outstanding;
290         refReturns = vaults[investor].refReturns;
291     }
292 
293     function hasReturns(address investor, uint roundID) public view returns (bool) {
294         MobiusRound storage rnd = rounds[roundID];
295         return rnd.cumulativeReturnsPoints > rnd.investors[investor].lastCumulativeReturnsPoints;
296     }
297 
298     function investorInfo(address investor, uint roundID) external view
299     returns(uint shares, uint totalReturns, uint referralReturns) 
300     {
301         MobiusRound storage rnd = rounds[roundID];
302         shares = rnd.investors[investor].shares;
303         (totalReturns, referralReturns) = estimateReturns(investor, roundID);
304     }
305 
306     function roundInfo(uint roundID) external view 
307     returns(
308         address leader, 
309         uint price,
310         uint jackpot, 
311         uint airdrop, 
312         uint shares, 
313         uint totalInvested,
314         uint distributedReturns,
315         uint _hardDeadline,
316         uint _softDeadline,
317         bool finalized
318         )
319     {
320         MobiusRound storage rnd = rounds[roundID];
321         leader = rnd.lastInvestor;
322         price = rnd.price;
323         jackpot = rnd.jackpot;
324         airdrop = rnd.airdropPot;
325         shares = rnd.totalShares;
326         totalInvested = rnd.totalInvested;
327         distributedReturns = wmul(rnd.totalInvested, RETURNS_FRACTION);
328         _hardDeadline = rnd.hardDeadline;
329         _softDeadline = rnd.softDeadline;
330         finalized = rnd.finalized;
331     }
332 
333     function totalsInfo() external view 
334     returns(
335         uint totalReturns,
336         uint totalShares,
337         uint totalDividends,
338         uint totalJackpots
339     ) {
340         MobiusRound storage rnd = rounds[latestRoundID];
341         if(rnd.softDeadline > now) {
342             totalShares = totalSharesSold + rnd.totalShares;
343             totalReturns = totalEarningsGenerated + wmul(rnd.totalInvested, RETURNS_FRACTION);
344             totalDividends = totalDividendsPaid + wmul(rnd.totalInvested, DIVIDENDS_FRACTION);
345         } else {
346             totalShares = totalSharesSold;
347             totalReturns = totalEarningsGenerated;
348             totalDividends = totalDividendsPaid;
349         }
350         totalJackpots = totalJackpotsWon;
351     }
352 
353     function () public payable {
354         buyShares(address(0x0));
355     }
356 
357     /// Function to buy shares in the latest round. Purchase logic is abstracted
358     function buyShares(address ref) public payable {        
359         if(rounds.length > 0) {
360             MobiusRound storage rnd = rounds[latestRoundID];   
361                
362             _purchase(rnd, msg.value, ref);            
363         } else {
364             revert("Not yet started");
365         }
366     }
367 
368     /// Function to purchase with what you have in your vault as returns
369     function reinvestReturns(uint value) public {        
370         reinvestReturns(value, address(0x0));
371     }
372 
373     function reinvestReturns(uint value, address ref) public {        
374         MobiusRound storage rnd = rounds[latestRoundID];
375         _updateReturns(msg.sender, rnd);        
376         require(vaults[msg.sender].totalReturns >= value, "Can't spend what you don't have");        
377         vaults[msg.sender].totalReturns = sub(vaults[msg.sender].totalReturns, value);
378         vaults[msg.sender].refReturns = min(vaults[msg.sender].refReturns, vaults[msg.sender].totalReturns);
379         unclaimedReturns = sub(unclaimedReturns, value);
380         _purchase(rnd, value, ref);
381     }
382 
383     function withdrawReturns() public {
384         MobiusRound storage rnd = rounds[latestRoundID];
385 
386         if(rounds.length > 1) {// check if they also have returns from before
387             if(hasReturns(msg.sender, latestRoundID - 1)) {
388                 MobiusRound storage prevRnd = rounds[latestRoundID - 1];
389                 _updateReturns(msg.sender, prevRnd);
390             }
391         }
392         _updateReturns(msg.sender, rnd);
393         uint amount = vaults[msg.sender].totalReturns;
394         require(amount > 0, "Nothing to withdraw!");
395         unclaimedReturns = sub(unclaimedReturns, amount);
396         vaults[msg.sender].totalReturns = 0;
397         vaults[msg.sender].refReturns = 0;
398         
399         rnd.investors[msg.sender].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
400         msg.sender.transfer(amount);
401 
402         emit ReturnsWithdrawn(msg.sender, amount);
403     }
404 
405     // Manually update your returns for a given round in case you were inactive since before it ended
406     function updateMyReturns(uint roundID) public {
407         MobiusRound storage rnd = rounds[roundID];
408         _updateReturns(msg.sender, rnd);
409     }
410 
411     function finalizeAndRestart() public payable {
412         finalizeLastRound();
413         startNewRound();
414     }
415 
416     /// Anyone can start a new round
417     function startNewRound() public payable {
418         require(!upgraded, "This contract has been upgraded!");
419         if(rounds.length > 0) {
420             require(rounds[latestRoundID].finalized, "Previous round not finalized");
421             require(rounds[latestRoundID].softDeadline < now, "Previous round still running");
422         }
423         uint _rID = rounds.length++;
424         MobiusRound storage rnd = rounds[_rID];
425         latestRoundID = _rID;
426 
427         rnd.lastInvestor = msg.sender;
428         rnd.price = STARTING_SHARE_PRICE;
429         rnd.hardDeadline = now + HARD_DEADLINE_DURATION;
430         rnd.softDeadline = now + SOFT_DEADLINE_DURATION;
431         rnd.jackpot = jackpotSeed;
432         jackpotSeed = 0; 
433 
434         _purchase(rnd, msg.value, address(0x0));
435         emit RoundStarted(_rID, rnd.hardDeadline);
436     }
437 
438     /// Anyone can finalize a finished round
439     function finalizeLastRound() public {
440         MobiusRound storage rnd = rounds[latestRoundID];
441         _finalizeRound(rnd);
442     }
443     
444     /// This is how devs pay the bills
445     function withdrawDevShare() public auth {
446         uint value = devBalance;
447         devBalance = 0;
448         msg.sender.transfer(value);
449     }
450 
451     function setIPFSHash(string _type, string _hash) public auth {
452         ipfsHashType = _type;
453         ipfsHash = _hash;
454         emit IPFSHashSet(_type, _hash);
455     }
456 
457     function upgrade(address _nextVersion) public auth {
458         require(_nextVersion != address(0x0), "Invalid Address!");
459         require(!upgraded, "Already upgraded!");
460         upgraded = true;
461         nextVersion = _nextVersion;
462         if(rounds[latestRoundID].finalized) {
463             //if last round was finalized (and no new round was started), transfer the jackpot seed to the new version
464             vaults[nextVersion].totalReturns = jackpotSeed;
465             jackpotSeed = 0;
466         }
467     }
468 
469     /// Purchase logic
470     function _purchase(MobiusRound storage rnd, uint value, address ref) internal {
471         require(rnd.softDeadline >= now, "After deadline!");
472         require(value >= rnd.price/10, "Not enough Ether!");
473         rnd.totalInvested = add(rnd.totalInvested, value);
474 
475         // Set the last investor (to win the jackpot after the deadline)
476         if(value >= rnd.price)
477             rnd.lastInvestor = msg.sender;
478         // Check out airdrop 
479         _airDrop(rnd, value);
480         // Process revenue in different "buckets"
481         _splitRevenue(rnd, value, ref);
482         // Update returns before issuing shares
483         _updateReturns(msg.sender, rnd);
484         //issue shares for the current round. 1 share = 1 time increase for the deadline
485         uint newShares = _issueShares(rnd, msg.sender, value);
486 
487         //Mint tokens during the first round
488         if(rounds.length == 1) {
489             token.mint(msg.sender, newShares);
490         }
491         uint timeIncreases = newShares/WAD;// since 1 share is represented by 1 * 10^18, divide by 10^18
492         // adjust soft deadline to new soft deadline
493         uint newDeadline = add(rnd.softDeadline, mul(timeIncreases, TIME_PER_SHARE));
494         rnd.softDeadline = min(newDeadline, now + SOFT_DEADLINE_DURATION);
495         // If after hard deadline, double the price every price increase periods
496         if(now > rnd.hardDeadline) {
497             if(now > rnd.lastPriceIncreaseTime + PRICE_INCREASE_PERIOD) {
498                 rnd.price = rnd.price * 2;
499                 rnd.lastPriceIncreaseTime = now;
500             }
501         }
502     }
503 
504     function _finalizeRound(MobiusRound storage rnd) internal {
505         require(!rnd.finalized, "Already finalized!");
506         require(rnd.softDeadline < now, "Round still running!");
507 
508         if(rounds.length == 1) {
509             // After finishing minting tokens they will be transferable and dividends will be available!
510             require(token.finishMinting(), "Couldn't finish minting tokens!");
511         }
512         // Transfer jackpot to winner's vault
513         vaults[rnd.lastInvestor].totalReturns = add(vaults[rnd.lastInvestor].totalReturns, rnd.jackpot);
514         unclaimedReturns = add(unclaimedReturns, rnd.jackpot);
515         
516         emit JackpotWon(rnd.lastInvestor, rnd.jackpot);
517         totalJackpotsWon += rnd.jackpot;
518         // transfer the leftover to the next round's jackpot
519         jackpotSeed = add(jackpotSeed, wmul(rnd.totalInvested, JACKPOT_SEED_FRACTION));
520         //Empty the AD pot if it has a balance.
521         jackpotSeed = add(jackpotSeed, rnd.airdropPot);
522         if(upgraded) {
523             // if upgraded transfer the jackpot seed to the new version
524             vaults[nextVersion].totalReturns = jackpotSeed;
525             jackpotSeed = 0; 
526         }        
527         //Send out dividends to token holders
528         uint _div;
529         if(rounds.length == 1){
530             // 5% during the first round, and the normal fraction otherwise
531             _div = wmul(rnd.totalInvested, 5 * 10**16);            
532         } else {
533             _div = wmul(rnd.totalInvested, DIVIDENDS_FRACTION);            
534         }
535         token.disburseDividends.value(_div)();
536         totalDividendsPaid += _div;
537         totalSharesSold += rnd.totalShares;
538         totalEarningsGenerated += wmul(rnd.totalInvested, RETURNS_FRACTION);
539 
540         rnd.finalized = true;
541     }
542 
543     /** 
544         This is where the magic happens: every investor gets an exact share of all returns proportional to their shares
545         If you're early, you'll have a larger share for longer, so obviously you earn more.
546     */
547     function _updateReturns(address _investor, MobiusRound storage rnd) internal {
548         if(rnd.investors[_investor].shares == 0) {
549             return;
550         }
551         
552         uint outstanding = _outstandingReturns(_investor, rnd);
553 
554         // if there are any returns, transfer them to the investor's vaults
555         if (outstanding > 0) {
556             vaults[_investor].totalReturns = add(vaults[_investor].totalReturns, outstanding);
557         }
558 
559         rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
560     }
561 
562     function _outstandingReturns(address _investor, MobiusRound storage rnd) internal view returns(uint) {
563         if(rnd.investors[_investor].shares == 0) {
564             return 0;
565         }
566         // check if there've been new returns
567         uint newReturns = sub(
568             rnd.cumulativeReturnsPoints, 
569             rnd.investors[_investor].lastCumulativeReturnsPoints
570             );
571 
572         uint outstanding = 0;
573         if(newReturns != 0) { 
574             // outstanding returns = (total new returns points * ivestor shares) / MULTIPLIER
575             // The MULTIPLIER is used also at the point of returns disbursment
576             outstanding = mul(newReturns, rnd.investors[_investor].shares) / MULTIPLIER;
577         }
578 
579         return outstanding;
580     }
581 
582     /// Process revenue according to fractions
583     function _splitRevenue(MobiusRound storage rnd, uint value, address ref) internal {
584         uint roundReturns;
585         uint returnsOffset;
586         if(rounds.length == 1){
587             returnsOffset = 5 * 10**16;// during the first round reduce returns (by 5%) and give more to the ICO
588         }
589         if(ref != address(0x0)) {
590             // if there was a referral
591             roundReturns = wmul(value, RETURNS_FRACTION - REFERRAL_FRACTION - returnsOffset);
592             uint _ref = wmul(value, REFERRAL_FRACTION);
593             vaults[ref].totalReturns = add(vaults[ref].totalReturns, _ref);            
594             vaults[ref].refReturns = add(vaults[ref].refReturns, _ref);
595             unclaimedReturns = add(unclaimedReturns, _ref);
596         } else {
597             roundReturns = wmul(value, RETURNS_FRACTION - returnsOffset);
598         }
599         
600         uint airdrop = wmul(value, AIRDROP_FRACTION);
601         uint jackpot = wmul(value, JACKPOT_FRACTION);
602         
603         uint dev;
604         // During the ICO, devs get 12% 
605         // leaving 5% for dividends, and 65% for returns 
606         // This is only during the first round, and later rounds leave the original fractions:
607         // 4% for devs, 10% dividends, 70% returns 
608         if(rounds.length == 1){
609             // calculate dividends at the end, no need to do it at every purchase
610             dev = value / 12; // 12
611             raisedICO += dev;
612         } else {
613             dev = value / DEV_DIVISOR;
614         }
615         // if this is the first purchase, send to jackpot (no one can claim these returns otherwise)
616         if(rnd.totalShares == 0) {
617             rnd.jackpot = add(rnd.jackpot, roundReturns);
618         } else {
619             _disburseReturns(rnd, roundReturns);
620         }
621         
622         rnd.airdropPot = add(rnd.airdropPot, airdrop);
623         rnd.jackpot = add(rnd.jackpot, jackpot);
624         devBalance = add(devBalance, dev);
625     }
626 
627     function _disburseReturns(MobiusRound storage rnd, uint value) internal {
628         unclaimedReturns = add(unclaimedReturns, value);// keep track of unclaimed returns
629         // The returns points represent returns*MULTIPLIER/totalShares (at the point of purchase)
630         // This allows us to keep outstanding balances of shareholders when the total supply changes in real time
631         if(rnd.totalShares == 0) {
632             rnd.cumulativeReturnsPoints = mul(value, MULTIPLIER) / wdiv(value, rnd.price);
633         } else {
634             rnd.cumulativeReturnsPoints = add(
635                 rnd.cumulativeReturnsPoints, 
636                 mul(value, MULTIPLIER) / rnd.totalShares
637             );
638         }
639     }
640 
641     function _issueShares(MobiusRound storage rnd, address _investor, uint value) internal returns(uint) {    
642         if(rnd.investors[_investor].lastCumulativeReturnsPoints == 0) {
643             rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
644         }    
645         
646         uint newShares = wdiv(value, rnd.price);
647         
648         //bonuses:
649         if(value >= 100 ether) {
650             newShares = mul(newShares, 2);//get double shares if you paid more than 100 ether
651         } else if(value >= 10 ether) {
652             newShares = add(newShares, newShares/2);//50% bonus
653         } else if(value >= 1 ether) {
654             newShares = add(newShares, newShares/3);//33% bonus
655         } else if(value >= 100 finney) {
656             newShares = add(newShares, newShares/10);//10% bonus
657         }
658 
659         rnd.investors[_investor].shares = add(rnd.investors[_investor].shares, newShares);
660         rnd.totalShares = add(rnd.totalShares, newShares);
661         emit SharesIssued(_investor, newShares);
662         return newShares;
663     }    
664 
665     function _airDrop(MobiusRound storage rnd, uint value) internal {
666         require(msg.sender == tx.origin, "ONLY HOOMANS (or scripts that don't use smart contracts)!");
667         if(value > 100 finney) {
668             /**
669                 Creates a random number from the last block hash and current timestamp.
670                 One could add more seemingly random data like the msg.sender, etc, but that doesn't 
671                 make it harder for a miner to manipulate the result in their favor (if they intended to).
672              */
673             uint chance = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), now)));
674             if(chance % 200 == 0) {// once in 200 times
675                 uint prize = rnd.airdropPot / 2;// win half of the pot, regardless of how much you paid
676                 rnd.airdropPot = rnd.airdropPot / 2;
677                 vaults[msg.sender].totalReturns = add(vaults[msg.sender].totalReturns, prize);
678                 unclaimedReturns = add(unclaimedReturns, prize);
679                 totalJackpotsWon += prize;
680                 emit AirdropWon(msg.sender, prize);
681             }
682         }
683     }
684 }