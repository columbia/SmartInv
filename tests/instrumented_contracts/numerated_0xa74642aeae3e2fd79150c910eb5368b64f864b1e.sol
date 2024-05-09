1 pragma solidity^0.4.24;
2 
3 /**
4                         MOBIUS 2D
5                      https://m2d.win 
6                                        
7     This game was inspired by FOMO3D. Our code is much cleaner and more efficient (built from scratch).
8     Some useless "features" like the teams were not implemented.
9  
10     The Mobius2D game consists of rounds with guaranteed winners!
11     You buy "shares" (instad of keys) for a given round, and you get returns from investors after you.
12     The sare price is constant until the hard deadline, after which it increases exponentially. 
13     If a round is inactive for a day it can end earlier than the hard deadline.
14     If a round runs longer, it is guaranteed to finish not much after the hard deadline (and the last investor gets the big jackpot).
15     Additionally, if you invest more than 0.1 ETH you get a chance to win an airdrop and you get bonus shares
16     Part of all funds also go to a big final jackpot - the last investor (before a round runs out) wins.
17     Payouts work in REAL TIME - you can withdraw your returns at any time!
18     Additionally, the first round is an ICO, so you'll also get our tokens by participating!
19     !!!!!!!!!!!!!!
20     Token holders will receive part of current and future revenue of this and any other game we develop!
21     !!!!!!!!!!!!!!
22     
23     .................................. LAUGHING MAN sssyyhddmN..........................................
24     ..........................Nmdyyso+/:--.``` :`  `-`:--:/+ossyhdmN....................................
25     ......................Ndhyso/:.`   --.     o.  /+`o::` `` `-:+osyh..................................
26     ..................MNdyso/-` /-`/:+./:/..`  +.  //.o +.+::+ -`  `-/sshdN.............................
27     ................Ndyso:` ` --:+`o//.-:-```  ...  ``` - /::::/ +..-` ./osh............................
28     ..............Nhso/. .-.:/`o--:``   `..-:::oss+::--.``    .:/::/`+-`/../sydN........................
29     ............mhso-``-:+./:-:.   .-/+osssssssssssssssssso+:-`  -//o::+:/` .:oyhN......................
30     ..........Nhso:`  .+-./ `  .:+sssssso+//:-------:://+ossssso/---.`-`/:-o/ `:syd.....................
31     ........Mdyo- +/../`-`  ./osssso/-.`                 ``.:+ossss+:`  `-+`  ` `/sy....................
32     ......MNys/` -:-/:    -+ssss+-`                           `.:+ssss/.  `  -+-. .osh..................
33     ......mys-  :-/+-`  :osss+-`                                  .:osss+.  `//o:- `/syN................
34     ....Mdso. --:-/-  -osss+.                                       `-osss+`  :--://`-sy................
35     ....dso-. ++:+  `/sss+.                                           `:osss:  `:.-+  -sy...............
36     ..Mdso``+///.` .osss:                                               `/sss+`  :/-.. -syN.............
37     ..mss` `+::/  .ssso.                                                  :sss+` `+:/+  -syN............
38     ..ys-   ```  .ssso`                                                    -sss+` `:::+:`/sh............
39     Mds+ `:/..  `osso`                                                      -sss+  -:`.` `ssN...........
40     Mys. `/+::  +sss/........................................................+sss:.....-::+sy..NN.......
41     ds+  :-/-  .ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyhdN...
42     hs: `/+::   :/+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ossssyhNM
43     ss. `:::`                    ````                        ```                               ``-+sssyN
44     ss` /:-+` `o++:           .:+oooo+/.                 `-/ooooo+-`                               -sssy
45     ss  `:/:  `sss/          :ooo++/++os/`              .oso++/++oso.                               osss
46     ss``/:--  `sss/         ./.`      `.::              /-.`     ``-/`                             -sssy
47     ss.:::-:.  ssso         `            `                                                    ``.-+sssyN
48     hs:`:/:/.  /sss.   .++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++oossssyhNM
49     ds+ ``     .sss/   -ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyyyyhmN...
50     Nss.:::::.  +sss.   +sss/........................................osss:...+sss:......../shmNNN.......
51     Mds+..-:::` `osso`  `+sss:                                     `+sss:   -sss+  .:-.` `ssN...........
52     ..ys- .+.::  .ssso`  `/sss+.                                  -osss:   -sss+` `:++-` /sh............
53     ..mss` .-.    .ssso.   :osss/`                              .+ssso.   :sss+` `.:+:` -syN............
54     ..Mdso`  `--:` .osss:   `/ssss/.`                        `-+ssso:`  `/sss+` `++.-. -syN.............
55     ....dso` -//+-` `/sss+.   ./ossso/-``                `.:+sssso:`  `:osss:  .::+/. -sy...............
56     ....Mdso. `-//-`  -osss+.   `-+ssssso+/:-.`````..-:/+osssso/.   `-osss+.` -///-  -sy................
57     ......mys- `/://.`  :osss+-`   `-/+osssssssssssssssssso+:.    .:osss+.  .:`..-``/syN................
58     ......MNys/` ..+-/:   -+ssss+-`    `.-://++oooo++/:-.`    `.:+ssss/.  .`      .osh..................
59     ........Mdyo- `::/.  `  ./osssso/-.`                 ``.:+ossss+:` `  .//`  `/sy....................
60     ..........Nhso-     :+:.`  .:+sssssso+//:--------://+ossssso/:.  `::/: --/.:syd.....................
61     ............mhso-` ./+--+-:    .-/+osssssssssssssssssso+/-.  .+` `//-/ `::oyhN......................
62     ..............Nhso/`   +/:--+.-`    `..-:::////::--.``    .`:/-o`  ./`./sydN........................
63     ................Ndys+:` ``--+++-  .:  `.``      `` -.`/:/`.o./::.  ./osh............................
64     ..................MNdyso/-` ` :`  +-  :+.o`s ::-/++`s`+/o.-:`  `-/sshdN.............................
65     ......................Ndhyso/:.` .+   +/:/ +:/-./:-`+: `` `.:+osyh..................................
66     ..........................Nmdyyso+/:--/.``      ``..-:/+ossyhdmN....................................
67     ..............................MN..dhhyyssssssssssssyyhddmN..........................................
68  */
69  
70 contract DSMath {
71     function add(uint x, uint y) internal pure returns (uint z) {
72         require((z = x + y) >= x);
73     }
74     function sub(uint x, uint y) internal pure returns (uint z) {
75         require((z = x - y) <= x);
76     }
77     function mul(uint x, uint y) internal pure returns (uint z) {
78         require(y == 0 || (z = x * y) / y == x);
79     }
80 
81     function min(uint x, uint y) internal pure returns (uint z) {
82         return x <= y ? x : y;
83     }
84     function max(uint x, uint y) internal pure returns (uint z) {
85         return x >= y ? x : y;
86     }
87     function imin(int x, int y) internal pure returns (int z) {
88         return x <= y ? x : y;
89     }
90     function imax(int x, int y) internal pure returns (int z) {
91         return x >= y ? x : y;
92     }
93 
94     uint constant WAD = 10 ** 18;
95     uint constant RAY = 10 ** 27;
96 
97     function wmul(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, y), WAD / 2) / WAD;
99     }
100     function rmul(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, y), RAY / 2) / RAY;
102     }
103     function wdiv(uint x, uint y) internal pure returns (uint z) {
104         z = add(mul(x, WAD), y / 2) / y;
105     }
106     function rdiv(uint x, uint y) internal pure returns (uint z) {
107         z = add(mul(x, RAY), y / 2) / y;
108     }
109 
110     // This famous algorithm is called "exponentiation by squaring"
111     // and calculates x^n with x as fixed-point and n as regular unsigned.
112     //
113     // It's O(log n), instead of O(n) for naive repeated multiplication.
114     //
115     // These facts are why it works:
116     //
117     //  If n is even, then x^n = (x^2)^(n/2).
118     //  If n is odd,  then x^n = x * x^(n-1),
119     //   and applying the equation for even x gives
120     //    x^n = x * (x^2)^((n-1) / 2).
121     //
122     //  Also, EVM division is flooring and
123     //    floor[(n-1) / 2] = floor[n / 2].
124     //
125     function rpow(uint x, uint n) internal pure returns (uint z) {
126         z = n % 2 != 0 ? x : RAY;
127 
128         for (n /= 2; n != 0; n /= 2) {
129             x = rmul(x, x);
130 
131             if (n % 2 != 0) {
132                 z = rmul(z, x);
133             }
134         }
135     }
136 }
137 
138 contract DSAuthority {
139     function canCall(
140         address src, address dst, bytes4 sig
141     ) public view returns (bool);
142 }
143 
144 contract DSAuthEvents {
145     event LogSetAuthority (address indexed authority);
146     event LogSetOwner     (address indexed owner);
147 }
148 
149 contract DSAuth is DSAuthEvents {
150     DSAuthority  public  authority;
151     address      public  owner;
152 
153     constructor() public {
154         owner = msg.sender;
155         emit LogSetOwner(msg.sender);
156     }
157 
158     function setOwner(address owner_)
159         public
160         auth
161     {
162         owner = owner_;
163         emit LogSetOwner(owner);
164     }
165 
166     function setAuthority(DSAuthority authority_)
167         public
168         auth
169     {
170         authority = authority_;
171         emit LogSetAuthority(authority);
172     }
173 
174     modifier auth {
175         require(isAuthorized(msg.sender, msg.sig));
176         _;
177     }
178 
179     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
180         if (src == address(this)) {
181             return true;
182         } else if (src == owner) {
183             return true;
184         } else if (authority == DSAuthority(0)) {
185             return false;
186         } else {
187             return authority.canCall(src, this, sig);
188         }
189     }
190 }
191 
192 interface MobiusToken {
193     function mint(address _to, uint _amount) external;
194     function finishMinting() external returns (bool);
195     function disburseDividends() external payable;
196 }
197  
198 contract Mobius2D is DSMath, DSAuth {
199     // IPFS hash of the website - can be accessed even if our domain goes down.
200     // Just go to any public IPFS gateway and use this hash - e.g. ipfs.infura.io/ipfs/<ipfsHash>
201     string public ipfsHash;
202     string public ipfsHashType = "ipfs"; // can either be ipfs, or ipns
203 
204     MobiusToken public token;
205 
206     // In case of an upgrade, these variables will be set. An upgrade does not affect a currently running round,
207     // nor does it do anything with investors' vaults.
208     bool public upgraded;
209     address public nextVersion;
210 
211     // Total stats
212     uint public totalSharesSold;
213     uint public totalEarningsGenerated;
214     uint public totalDividendsPaid;
215     uint public totalJackpotsWon;
216 
217     // Fractions for where revenue goes
218     uint public constant DEV_FRACTION = WAD / 20;             // 5% goes to devs
219     uint public constant DEV_DIVISOR = 20;             // 5% 
220 
221     uint public constant RETURNS_FRACTION = 65 * 10**16;      // 65% goes to share holders
222     // 1% if it is a referral purchase, this value will be taken from the above fraction (e.g. if 1% is for refferals, then 64% goes to returns) 
223     uint public constant REFERRAL_FRACTION = 1 * 10**16;  
224     uint public constant JACKPOT_SEED_FRACTION = WAD / 20;    // 5% goes to the next round's jackpot
225     uint public constant JACKPOT_FRACTION = 15 * 10**16;      // 15% goes to the final jackpot
226     uint public constant AIRDROP_FRACTION = WAD / 100;        // 1% goes to airdrops
227     uint public constant DIVIDENDS_FRACTION = 9 * 10**16;     // 9% goes to token holders!
228 
229     uint public constant STARTING_SHARE_PRICE = 1 finney; // a 1000th of an ETH
230     uint public constant PRICE_INCREASE_PERIOD = 1 hours; // how often the price doubles after the hard deadline
231 
232     uint public constant HARD_DEADLINE_DURATION = 30 days; // hard deadline is this much after the round start
233     uint public constant SOFT_DEADLINE_DURATION = 1 days; // max soft deadline
234     uint public constant TIME_PER_SHARE = 5 minutes; // how much time is added to the soft deadline per share purchased
235     
236     uint public jackpotSeed;// Jackpot from previous rounds
237     uint public devBalance; // outstanding balance for devs
238     uint public raisedICO;
239 
240     // Helpers to calculate returns - no funds are ever held on lockdown
241     uint public unclaimedReturns;
242     uint public constant MULTIPLIER = RAY;
243 
244     // This represents an investor. No need to player IDs - they are useless (everyone already has a unique address).
245     // Just use native mappings (duh!)
246     struct Investor {
247         uint lastCumulativeReturnsPoints;
248         uint shares;
249     }
250 
251     // This represents a round
252     struct MobiusRound {
253         uint totalInvested;        
254         uint jackpot;
255         uint airdropPot;
256         uint totalShares;
257         uint cumulativeReturnsPoints; // this is to help calculate returns when the total number of shares changes
258         uint hardDeadline;
259         uint softDeadline;
260         uint price;
261         uint lastPriceIncreaseTime;
262         address lastInvestor;
263         bool finalized;
264         mapping (address => Investor) investors;
265     }
266 
267     struct Vault {
268         uint totalReturns; // Total balance = returns + referral returns + jackpots/airdrops 
269         uint refReturns; // how much of the total is from referrals
270     }
271 
272     mapping (address => Vault) vaults;
273 
274     uint public latestRoundID;// the first round has an ID of 0
275     MobiusRound[] rounds;
276 
277     event SharesIssued(address indexed to, uint shares);
278     event ReturnsWithdrawn(address indexed by, uint amount);
279     event JackpotWon(address by, uint amount);
280     event AirdropWon(address by, uint amount);
281     event RoundStarted(uint indexed ID, uint hardDeadline);
282     event IPFSHashSet(string _type, string _hash);
283 
284     constructor(address _token) public {
285         token = MobiusToken(_token);
286     }
287 
288     // The return values will include all vault balance, but you must specify a roundID because
289     // Returns are not actually calculated in storage until you invest in the round or withdraw them
290     function estimateReturns(address investor, uint roundID) public view 
291     returns (uint totalReturns, uint refReturns) 
292     {
293         MobiusRound storage rnd = rounds[roundID];
294         uint outstanding;
295         if(rounds.length > 1) {
296             if(hasReturns(investor, roundID - 1)) {
297                 MobiusRound storage prevRnd = rounds[roundID - 1];
298                 outstanding = _outstandingReturns(investor, prevRnd);
299             }
300         }
301 
302         outstanding += _outstandingReturns(investor, rnd);
303         
304         totalReturns = vaults[investor].totalReturns + outstanding;
305         refReturns = vaults[investor].refReturns;
306     }
307 
308     function hasReturns(address investor, uint roundID) public view returns (bool) {
309         MobiusRound storage rnd = rounds[roundID];
310         return rnd.cumulativeReturnsPoints > rnd.investors[investor].lastCumulativeReturnsPoints;
311     }
312 
313     function investorInfo(address investor, uint roundID) external view
314     returns(uint shares, uint totalReturns, uint referralReturns) 
315     {
316         MobiusRound storage rnd = rounds[roundID];
317         shares = rnd.investors[investor].shares;
318         (totalReturns, referralReturns) = estimateReturns(investor, roundID);
319     }
320 
321     function roundInfo(uint roundID) external view 
322     returns(
323         address leader, 
324         uint price,
325         uint jackpot, 
326         uint airdrop, 
327         uint shares, 
328         uint totalInvested,
329         uint distributedReturns,
330         uint _hardDeadline,
331         uint _softDeadline,
332         bool finalized
333         )
334     {
335         MobiusRound storage rnd = rounds[roundID];
336         leader = rnd.lastInvestor;
337         price = rnd.price;
338         jackpot = rnd.jackpot;
339         airdrop = rnd.airdropPot;
340         shares = rnd.totalShares;
341         totalInvested = rnd.totalInvested;
342         distributedReturns = wmul(rnd.totalInvested, RETURNS_FRACTION);
343         _hardDeadline = rnd.hardDeadline;
344         _softDeadline = rnd.softDeadline;
345         finalized = rnd.finalized;
346     }
347 
348     function totalsInfo() external view 
349     returns(
350         uint totalReturns,
351         uint totalShares,
352         uint totalDividends,
353         uint totalJackpots
354     ) {
355         MobiusRound storage rnd = rounds[latestRoundID];
356         if(rnd.softDeadline > now) {
357             totalShares = totalSharesSold + rnd.totalShares;
358             totalReturns = totalEarningsGenerated + wmul(rnd.totalInvested, RETURNS_FRACTION);
359             totalDividends = totalDividendsPaid + wmul(rnd.totalInvested, DIVIDENDS_FRACTION);
360         } else {
361             totalShares = totalSharesSold;
362             totalReturns = totalEarningsGenerated;
363             totalDividends = totalDividendsPaid;
364         }
365         totalJackpots = totalJackpotsWon;
366     }
367 
368     function () public payable {
369         buyShares(address(0x0));
370     }
371 
372     /// Function to buy shares in the latest round. Purchase logic is abstracted
373     function buyShares(address ref) public payable {        
374         if(rounds.length > 0) {
375             MobiusRound storage rnd = rounds[latestRoundID];   
376                
377             _purchase(rnd, msg.value, ref);            
378         } else {
379             revert("Not yet started");
380         }
381     }
382 
383     /// Function to purchase with what you have in your vault as returns
384     function reinvestReturns(uint value) public {        
385         reinvestReturns(value, address(0x0));
386     }
387 
388     function reinvestReturns(uint value, address ref) public {        
389         MobiusRound storage rnd = rounds[latestRoundID];
390         _updateReturns(msg.sender, rnd);        
391         require(vaults[msg.sender].totalReturns >= value, "Can't spend what you don't have");        
392         vaults[msg.sender].totalReturns = sub(vaults[msg.sender].totalReturns, value);
393         vaults[msg.sender].refReturns = min(vaults[msg.sender].refReturns, vaults[msg.sender].totalReturns);
394         unclaimedReturns = sub(unclaimedReturns, value);
395         _purchase(rnd, value, ref);
396     }
397 
398     function withdrawReturns() public {
399         MobiusRound storage rnd = rounds[latestRoundID];
400 
401         if(rounds.length > 1) {// check if they also have returns from before
402             if(hasReturns(msg.sender, latestRoundID - 1)) {
403                 MobiusRound storage prevRnd = rounds[latestRoundID - 1];
404                 _updateReturns(msg.sender, prevRnd);
405             }
406         }
407         _updateReturns(msg.sender, rnd);
408         uint amount = vaults[msg.sender].totalReturns;
409         require(amount > 0, "Nothing to withdraw!");
410         unclaimedReturns = sub(unclaimedReturns, amount);
411         vaults[msg.sender].totalReturns = 0;
412         vaults[msg.sender].refReturns = 0;
413         
414         rnd.investors[msg.sender].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
415         msg.sender.transfer(amount);
416 
417         emit ReturnsWithdrawn(msg.sender, amount);
418     }
419 
420     // Manually update your returns for a given round in case you were inactive since before it ended
421     function updateMyReturns(uint roundID) public {
422         MobiusRound storage rnd = rounds[roundID];
423         _updateReturns(msg.sender, rnd);
424     }
425 
426     function finalizeAndRestart() public payable {
427         finalizeLastRound();
428         startNewRound();
429     }
430 
431     /// Anyone can start a new round
432     function startNewRound() public payable {
433         require(!upgraded, "This contract has been upgraded!");
434         if(rounds.length > 0) {
435             require(rounds[latestRoundID].finalized, "Previous round not finalized");
436             require(rounds[latestRoundID].softDeadline < now, "Previous round still running");
437         }
438         uint _rID = rounds.length++;
439         MobiusRound storage rnd = rounds[_rID];
440         latestRoundID = _rID;
441 
442         rnd.lastInvestor = msg.sender;
443         rnd.price = STARTING_SHARE_PRICE;
444         rnd.hardDeadline = now + HARD_DEADLINE_DURATION;
445         rnd.softDeadline = now + SOFT_DEADLINE_DURATION;
446         rnd.jackpot = jackpotSeed;
447         jackpotSeed = 0; 
448 
449         _purchase(rnd, msg.value, address(0x0));
450         emit RoundStarted(_rID, rnd.hardDeadline);
451     }
452 
453     /// Anyone can finalize a finished round
454     function finalizeLastRound() public {
455         MobiusRound storage rnd = rounds[latestRoundID];
456         _finalizeRound(rnd);
457     }
458     
459     /// This is how devs pay the bills
460     function withdrawDevShare() public auth {
461         uint value = devBalance;
462         devBalance = 0;
463         msg.sender.transfer(value);
464     }
465 
466     function setIPFSHash(string _type, string _hash) public auth {
467         ipfsHashType = _type;
468         ipfsHash = _hash;
469         emit IPFSHashSet(_type, _hash);
470     }
471 
472     function upgrade(address _nextVersion) public auth {
473         require(_nextVersion != address(0x0), "Invalid Address!");
474         require(!upgraded, "Already upgraded!");
475         upgraded = true;
476         nextVersion = _nextVersion;
477         if(rounds[latestRoundID].finalized) {
478             //if last round was finalized (and no new round was started), transfer the jackpot seed to the new version
479             vaults[nextVersion].totalReturns = jackpotSeed;
480             jackpotSeed = 0;
481         }
482     }
483 
484     /// Purchase logic
485     function _purchase(MobiusRound storage rnd, uint value, address ref) internal {
486         require(rnd.softDeadline >= now, "After deadline!");
487         require(value >= rnd.price/10, "Not enough Ether!");
488         rnd.totalInvested = add(rnd.totalInvested, value);
489 
490         // Set the last investor (to win the jackpot after the deadline)
491         if(value >= rnd.price)
492             rnd.lastInvestor = msg.sender;
493         // Check out airdrop 
494         _airDrop(rnd, value);
495         // Process revenue in different "buckets"
496         _splitRevenue(rnd, value, ref);
497         // Update returns before issuing shares
498         _updateReturns(msg.sender, rnd);
499         //issue shares for the current round. 1 share = 1 time increase for the deadline
500         uint newShares = _issueShares(rnd, msg.sender, value);
501 
502         //Mint tokens during the first round
503         if(rounds.length == 1) {
504             token.mint(msg.sender, newShares);
505         }
506         uint timeIncreases = newShares/WAD;// since 1 share is represented by 1 * 10^18, divide by 10^18
507         // adjust soft deadline to new soft deadline
508         uint newDeadline = add(rnd.softDeadline, mul(timeIncreases, TIME_PER_SHARE));
509         rnd.softDeadline = min(newDeadline, now + SOFT_DEADLINE_DURATION);
510         // If after hard deadline, double the price every price increase periods
511         if(now > rnd.hardDeadline) {
512             if(now > rnd.lastPriceIncreaseTime + PRICE_INCREASE_PERIOD) {
513                 rnd.price = rnd.price * 2;
514                 rnd.lastPriceIncreaseTime = now;
515             }
516         }
517     }
518 
519     function _finalizeRound(MobiusRound storage rnd) internal {
520         require(!rnd.finalized, "Already finalized!");
521         require(rnd.softDeadline < now, "Round still running!");
522 
523         if(rounds.length == 1) {
524             // After finishing minting tokens they will be transferable and dividends will be available!
525             require(token.finishMinting(), "Couldn't finish minting tokens!");
526         }
527         // Transfer jackpot to winner's vault
528         vaults[rnd.lastInvestor].totalReturns = add(vaults[rnd.lastInvestor].totalReturns, rnd.jackpot);
529         unclaimedReturns = add(unclaimedReturns, rnd.jackpot);
530         
531         emit JackpotWon(rnd.lastInvestor, rnd.jackpot);
532         totalJackpotsWon += rnd.jackpot;
533         // transfer the leftover to the next round's jackpot
534         jackpotSeed = add(jackpotSeed, wmul(rnd.totalInvested, JACKPOT_SEED_FRACTION));
535         //Empty the AD pot if it has a balance.
536         jackpotSeed = add(jackpotSeed, rnd.airdropPot);
537         if(upgraded) {
538             // if upgraded transfer the jackpot seed to the new version
539             vaults[nextVersion].totalReturns = jackpotSeed;
540             jackpotSeed = 0; 
541         }        
542         //Send out dividends to token holders
543         uint _div;
544         if(rounds.length == 1){
545             // 2% during the first round, and the normal fraction otherwise
546             _div = wmul(rnd.totalInvested, 2 * 10**16);            
547         } else {
548             _div = wmul(rnd.totalInvested, DIVIDENDS_FRACTION);            
549         }
550         token.disburseDividends.value(_div)();
551         totalDividendsPaid += _div;
552         totalSharesSold += rnd.totalShares;
553         totalEarningsGenerated += wmul(rnd.totalInvested, RETURNS_FRACTION);
554 
555         rnd.finalized = true;
556     }
557 
558     /** 
559         This is where the magic happens: every investor gets an exact share of all returns proportional to their shares
560         If you're early, you'll have a larger share for longer, so obviously you earn more.
561     */
562     function _updateReturns(address _investor, MobiusRound storage rnd) internal {
563         if(rnd.investors[_investor].shares == 0) {
564             return;
565         }
566         
567         uint outstanding = _outstandingReturns(_investor, rnd);
568 
569         // if there are any returns, transfer them to the investor's vaults
570         if (outstanding > 0) {
571             vaults[_investor].totalReturns = add(vaults[_investor].totalReturns, outstanding);
572         }
573 
574         rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
575     }
576 
577     function _outstandingReturns(address _investor, MobiusRound storage rnd) internal view returns(uint) {
578         if(rnd.investors[_investor].shares == 0) {
579             return 0;
580         }
581         // check if there've been new returns
582         uint newReturns = sub(
583             rnd.cumulativeReturnsPoints, 
584             rnd.investors[_investor].lastCumulativeReturnsPoints
585             );
586 
587         uint outstanding = 0;
588         if(newReturns != 0) { 
589             // outstanding returns = (total new returns points * ivestor shares) / MULTIPLIER
590             // The MULTIPLIER is used also at the point of returns disbursment
591             outstanding = mul(newReturns, rnd.investors[_investor].shares) / MULTIPLIER;
592         }
593 
594         return outstanding;
595     }
596 
597     /// Process revenue according to fractions
598     function _splitRevenue(MobiusRound storage rnd, uint value, address ref) internal {
599         uint roundReturns;
600         uint returnsOffset;
601         if(rounds.length == 1){
602             returnsOffset = 13 * 10**16;// during the first round reduce returns (by 13%) and give more to the ICO
603         }
604         if(ref != address(0x0)) {
605             // if there was a referral
606             roundReturns = wmul(value, RETURNS_FRACTION - REFERRAL_FRACTION - returnsOffset);
607             uint _ref = wmul(value, REFERRAL_FRACTION);
608             vaults[ref].totalReturns = add(vaults[ref].totalReturns, _ref);            
609             vaults[ref].refReturns = add(vaults[ref].refReturns, _ref);
610             unclaimedReturns = add(unclaimedReturns, _ref);
611         } else {
612             roundReturns = wmul(value, RETURNS_FRACTION - returnsOffset);
613         }
614         
615         uint airdrop = wmul(value, AIRDROP_FRACTION);
616         uint jackpot = wmul(value, JACKPOT_FRACTION);
617         
618         uint dev;
619         // During the ICO, devs get 25% (5% originally, 7% from the dividends fraction, 
620         // and 13% from the returns), leaving 2% for dividends, and 52% for returns 
621         // This is only during the first round, and later rounds leave the original fractions:
622         // 5% for devs, 9% dividends, 65% returns 
623         if(rounds.length == 1){
624             // calculate dividends at the end, no need to do it at every purchase
625             dev = value / 4; // 25% 
626             raisedICO += dev;
627         } else {
628             dev = value / DEV_DIVISOR;
629         }
630         // if this is the first purchase, send to jackpot (no one can claim these returns otherwise)
631         if(rnd.totalShares == 0) {
632             rnd.jackpot = add(rnd.jackpot, roundReturns);
633         } else {
634             _disburseReturns(rnd, roundReturns);
635         }
636         
637         rnd.airdropPot = add(rnd.airdropPot, airdrop);
638         rnd.jackpot = add(rnd.jackpot, jackpot);
639         devBalance = add(devBalance, dev);
640     }
641 
642     function _disburseReturns(MobiusRound storage rnd, uint value) internal {
643         unclaimedReturns = add(unclaimedReturns, value);// keep track of unclaimed returns
644         // The returns points represent returns*MULTIPLIER/totalShares (at the point of purchase)
645         // This allows us to keep outstanding balances of shareholders when the total supply changes in real time
646         if(rnd.totalShares == 0) {
647             rnd.cumulativeReturnsPoints = mul(value, MULTIPLIER) / wdiv(value, rnd.price);
648         } else {
649             rnd.cumulativeReturnsPoints = add(
650                 rnd.cumulativeReturnsPoints, 
651                 mul(value, MULTIPLIER) / rnd.totalShares
652             );
653         }
654     }
655 
656     function _issueShares(MobiusRound storage rnd, address _investor, uint value) internal returns(uint) {    
657         if(rnd.investors[_investor].lastCumulativeReturnsPoints == 0) {
658             rnd.investors[_investor].lastCumulativeReturnsPoints = rnd.cumulativeReturnsPoints;
659         }    
660         
661         uint newShares = wdiv(value, rnd.price);
662         
663         //bonuses:
664         if(value >= 100 ether) {
665             newShares = mul(newShares, 2);//get double shares if you paid more than 100 ether
666         } else if(value >= 10 ether) {
667             newShares = add(newShares, newShares/2);//50% bonus
668         } else if(value >= 1 ether) {
669             newShares = add(newShares, newShares/3);//33% bonus
670         } else if(value >= 100 finney) {
671             newShares = add(newShares, newShares/10);//10% bonus
672         }
673 
674         rnd.investors[_investor].shares = add(rnd.investors[_investor].shares, newShares);
675         rnd.totalShares = add(rnd.totalShares, newShares);
676         emit SharesIssued(_investor, newShares);
677         return newShares;
678     }    
679 
680     function _airDrop(MobiusRound storage rnd, uint value) internal {
681         require(msg.sender == tx.origin, "ONLY HOOMANS (or scripts that don't use smart contracts)!");
682         if(value > 100 finney) {
683             /**
684                 Creates a random number from the last block hash and current timestamp.
685                 One could add more seemingly random data like the msg.sender, etc, but that doesn't 
686                 make it harder for a miner to manipulate the result in their favor (if they intended to).
687              */
688             uint chance = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), now)));
689             if(chance % 200 == 0) {// once in 200 times
690                 uint prize = rnd.airdropPot / 2;// win half of the pot, regardless of how much you paid
691                 rnd.airdropPot = rnd.airdropPot / 2;
692                 vaults[msg.sender].totalReturns = add(vaults[msg.sender].totalReturns, prize);
693                 unclaimedReturns = add(unclaimedReturns, prize);
694                 totalJackpotsWon += prize;
695                 emit AirdropWon(msg.sender, prize);
696             }
697         }
698     }
699 }