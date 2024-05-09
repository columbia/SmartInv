1 pragma solidity^0.4.24;
2 
3 
4 contract DSAuthority {
5     function canCall(
6         address src, address dst, bytes4 sig
7     ) public view returns (bool); 
8 }
9 
10 contract DSAuthEvents {
11     event LogSetAuthority (address indexed authority);
12     event LogSetOwner     (address indexed owner);
13 }
14 
15 contract DSAuth is DSAuthEvents {
16     DSAuthority  public  authority;
17     address      public  owner;
18 
19     function DSAuth() public {
20         owner = msg.sender;
21         emit LogSetOwner(msg.sender);
22     }
23 
24     function setOwner(address owner_)
25         public
26         auth
27     {
28         owner = owner_;
29         emit LogSetOwner(owner);
30     }
31 
32     function setAuthority(DSAuthority authority_)
33         public
34         auth
35     {
36         authority = authority_;
37         emit LogSetAuthority(authority);
38     }
39 
40     modifier auth {
41         require(isAuthorized(msg.sender, msg.sig));
42         _;
43     }
44 
45     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
46         if (src == address(this)) {
47             return true;
48         } else if (src == owner) {
49             return true;
50         } else if (authority == DSAuthority(0)) {
51             return false;
52         } else {
53             return authority.canCall(src, this, sig);
54         }
55     }
56 }
57 
58 library DSMath {
59     function add(uint x, uint y) internal pure returns (uint z) {
60         require((z = x + y) >= x);
61     }
62     function sub(uint x, uint y) internal pure returns (uint z) {
63         require((z = x - y) <= x);
64     }
65     function mul(uint x, uint y) internal pure returns (uint z) {
66         require(y == 0 || (z = x * y) / y == x);
67     }
68 
69     function min(uint x, uint y) internal pure returns (uint z) {
70         return x <= y ? x : y;
71     }
72     function max(uint x, uint y) internal pure returns (uint z) {
73         return x >= y ? x : y;
74     }
75     function imin(int x, int y) internal pure returns (int z) {
76         return x <= y ? x : y;
77     }
78     function imax(int x, int y) internal pure returns (int z) {
79         return x >= y ? x : y;
80     }
81 
82     uint constant WAD = 10 ** 18;
83     uint constant RAY = 10 ** 27;
84 
85     function wmul(uint x, uint y) internal pure returns (uint z) {
86         z = add(mul(x, y), WAD / 2) / WAD;
87     }
88     function rmul(uint x, uint y) internal pure returns (uint z) {
89         z = add(mul(x, y), RAY / 2) / RAY;
90     }
91     function wdiv(uint x, uint y) internal pure returns (uint z) {
92         z = add(mul(x, WAD), y / 2) / y;
93     }
94     function rdiv(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, RAY), y / 2) / y;
96     }
97 
98     // This famous algorithm is called "exponentiation by squaring"
99     // and calculates x^n with x as fixed-point and n as regular unsigned.
100     //
101     // It's O(log n), instead of O(n) for naive repeated multiplication.
102     //
103     // These facts are why it works:
104     //
105     //  If n is even, then x^n = (x^2)^(n/2).
106     //  If n is odd,  then x^n = x * x^(n-1),
107     //   and applying the equation for even x gives
108     //    x^n = x * (x^2)^((n-1) / 2).
109     //
110     //  Also, EVM division is flooring and
111     //    floor[(n-1) / 2] = floor[n / 2].
112     //
113     function rpow(uint x, uint n) internal pure returns (uint z) {
114         z = n % 2 != 0 ? x : RAY;
115 
116         for (n /= 2; n != 0; n /= 2) {
117             x = rmul(x, x);
118 
119             if (n % 2 != 0) {
120                 z = rmul(z, x);
121             }
122         }
123     }
124 }
125 
126 interface ERC20 {
127     function balanceOf(address src) external view returns (uint);
128     function totalSupply() external view returns (uint);
129     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
130     function transfer(address to, uint tokens) external returns (bool success);
131     function approve(address spender, uint tokens) external returns (bool success);
132     function transferFrom(address from, address to, uint tokens) external returns (bool success);
133 }
134 
135 contract Accounting {
136 
137     using DSMath for uint;
138 
139     bool internal _in;
140     
141     modifier noReentrance() {
142         require(!_in);
143         _in = true;
144         _;
145         _in = false;
146     }
147     
148     //keeping track of total ETH and token balances
149     uint public totalETH;
150     mapping (address => uint) public totalTokenBalances;
151 
152     struct Account {
153         bytes32 name;
154         uint balanceETH;
155         mapping (address => uint) tokenBalances;
156     }
157 
158     Account base = Account({
159         name: "Base",
160         balanceETH: 0       
161     });
162 
163     event ETHDeposited(bytes32 indexed account, address indexed from, uint value);
164     event ETHSent(bytes32 indexed account, address indexed to, uint value);
165     event ETHTransferred(bytes32 indexed fromAccount, bytes32 indexed toAccount, uint value);
166     event TokenTransferred(bytes32 indexed fromAccount, bytes32 indexed toAccount, address indexed token, uint value);
167     event TokenDeposited(bytes32 indexed account, address indexed token, address indexed from, uint value);    
168     event TokenSent(bytes32 indexed account, address indexed token, address indexed to, uint value);
169 
170     function baseETHBalance() public constant returns(uint) {
171         return base.balanceETH;
172     }
173 
174     function baseTokenBalance(address token) public constant returns(uint) {
175         return base.tokenBalances[token];
176     }
177 
178     function depositETH(Account storage a, address _from, uint _value) internal {
179         a.balanceETH = a.balanceETH.add(_value);
180         totalETH = totalETH.add(_value);
181         emit ETHDeposited(a.name, _from, _value);
182     }
183 
184     function depositToken(Account storage a, address _token, address _from, uint _value) 
185     internal noReentrance 
186     {        
187         require(ERC20(_token).transferFrom(_from, address(this), _value));
188         totalTokenBalances[_token] = totalTokenBalances[_token].add(_value);
189         a.tokenBalances[_token] = a.tokenBalances[_token].add(_value);
190         emit TokenDeposited(a.name, _token, _from, _value);
191     }
192 
193     function sendETH(Account storage a, address _to, uint _value) 
194     internal noReentrance 
195     {
196         require(a.balanceETH >= _value);
197         require(_to != address(0));
198         
199         a.balanceETH = a.balanceETH.sub(_value);
200         totalETH = totalETH.sub(_value);
201 
202         _to.transfer(_value);
203         
204         emit ETHSent(a.name, _to, _value);
205     }
206 
207     function transact(Account storage a, address _to, uint _value, bytes data) 
208     internal noReentrance 
209     {
210         require(a.balanceETH >= _value);
211         require(_to != address(0));
212         
213         a.balanceETH = a.balanceETH.sub(_value);
214         totalETH = totalETH.sub(_value);
215 
216         require(_to.call.value(_value)(data));
217         
218         emit ETHSent(a.name, _to, _value);
219     }
220 
221     function sendToken(Account storage a, address _token, address _to, uint _value) 
222     internal noReentrance 
223     {
224         require(a.tokenBalances[_token] >= _value);
225         require(_to != address(0));
226         
227         a.tokenBalances[_token] = a.tokenBalances[_token].sub(_value);
228         totalTokenBalances[_token] = totalTokenBalances[_token].sub(_value);
229 
230         require(ERC20(_token).transfer(_to, _value));
231         emit TokenSent(a.name, _token, _to, _value);
232     }
233 
234     function transferETH(Account storage _from, Account storage _to, uint _value) 
235     internal 
236     {
237         require(_from.balanceETH >= _value);
238         _from.balanceETH = _from.balanceETH.sub(_value);
239         _to.balanceETH = _to.balanceETH.add(_value);
240         emit ETHTransferred(_from.name, _to.name, _value);
241     }
242 
243     function transferToken(Account storage _from, Account storage _to, address _token, uint _value)
244     internal
245     {
246         require(_from.tokenBalances[_token] >= _value);
247         _from.tokenBalances[_token] = _from.tokenBalances[_token].sub(_value);
248         _to.tokenBalances[_token] = _to.tokenBalances[_token].add(_value);
249         emit TokenTransferred(_from.name, _to.name, _token, _value);
250     }
251 
252     function balanceETH(Account storage toAccount,  uint _value) internal {
253         require(address(this).balance >= totalETH.add(_value));
254         depositETH(toAccount, address(this), _value);
255     }
256 
257     function balanceToken(Account storage toAccount, address _token, uint _value) internal noReentrance {
258         uint balance = ERC20(_token).balanceOf(this);
259         require(balance >= totalTokenBalances[_token].add(_value));
260 
261         toAccount.tokenBalances[_token] = toAccount.tokenBalances[_token].add(_value);
262         emit TokenDeposited(toAccount.name, _token, address(this), _value);
263     }
264     
265 }
266 
267 
268 ///Base contract with all the events, getters, and simple logic
269 contract ButtonBase is DSAuth, Accounting {
270     ///Using a the original DSMath as a library
271     using DSMath for uint;
272 
273     uint constant ONE_PERCENT_WAD = 10 ** 16;// 1 wad is 10^18, so 1% in wad is 10^16
274     uint constant ONE_WAD = 10 ** 18;
275 
276     uint public totalRevenue;
277     uint public totalCharity;
278     uint public totalWon;
279 
280     uint public totalPresses;
281 
282     ///Button parameters - note that these can change
283     uint public startingPrice = 2 finney;
284     uint internal _priceMultiplier = 106 * 10 **16;
285     uint32 internal _n = 4; //increase the price after every n presses
286     uint32 internal _period = 30 minutes;// what's the period for pressing the button
287     uint internal _newCampaignFraction = ONE_PERCENT_WAD; //1%
288     uint internal _devFraction = 10 * ONE_PERCENT_WAD - _newCampaignFraction; //9%
289     uint internal _charityFraction = 5 * ONE_PERCENT_WAD; //5%
290     uint internal _jackpotFraction = 85 * ONE_PERCENT_WAD; //85%
291     
292     address public charityBeneficiary;
293 
294     ///Internal accounts to hold value:
295     Account revenue = 
296     Account({
297         name: "Revenue",
298         balanceETH: 0
299     });
300 
301     Account nextCampaign = 
302     Account({
303         name: "Next Campaign",
304         balanceETH: 0       
305     });
306 
307     Account charity = 
308     Account({
309         name: "Charity",
310         balanceETH: 0
311     });
312 
313     ///Accounts of winners
314     mapping (address => Account) winners;
315 
316     /// Function modifier to put limits on how values can be set
317     modifier limited(uint value, uint min, uint max) {
318         require(value >= min && value <= max);
319         _;
320     }
321 
322     /// A function modifier which limits how often a function can be executed
323     mapping (bytes4 => uint) internal _lastExecuted;
324     modifier timeLimited(uint _howOften) {
325         require(_lastExecuted[msg.sig].add(_howOften) <= now);
326         _lastExecuted[msg.sig] = now;
327         _;
328     }
329 
330     ///Button events
331     event Pressed(address by, uint paid, uint64 timeLeft);
332     event Started(uint startingETH, uint32 period, uint i);
333     event Winrar(address guy, uint jackpot);
334     ///Settings changed events
335     event CharityChanged(address newCharityBeneficiary);
336     event ButtonParamsChanged(uint startingPrice, uint32 n, uint32 period, uint priceMul);
337     event AccountingParamsChanged(uint devFraction, uint charityFraction, uint jackpotFraction);
338 
339     ///Struct that represents a button champaign
340     struct ButtonCampaign {
341         uint price; ///Every campaign starts with some price  
342         uint priceMultiplier;/// Price will be increased by this much every n presses
343         uint devFraction; /// this much will go to the devs (10^16 = 1%)
344         uint charityFraction;/// This much will go to charity
345         uint jackpotFraction;/// This much will go to the winner (last presser)
346         uint newCampaignFraction;/// This much will go to the next campaign starting balance
347 
348         address lastPresser;
349         uint64 deadline;
350         uint40 presses;
351         uint32 n;
352         uint32 period;
353         bool finalized;
354 
355         Account total;/// base account to hold all the value until the campaign is finalized 
356     }
357 
358     uint public lastCampaignID;
359     ButtonCampaign[] campaigns;
360 
361     /// implemented in the child contract
362     function press() public payable;
363     
364     function () public payable {
365         press();
366     }
367 
368     ///Getters:
369 
370     ///Check if there's an active campaign
371     function active() public view returns(bool) {
372         if(campaigns.length == 0) { 
373             return false;
374         } else {
375             return campaigns[lastCampaignID].deadline >= now;
376         }
377     }
378 
379     ///Get information about the latest campaign or the next campaign if the last campaign has ended, but no new one has started
380     function latestData() external view returns(
381         uint price, uint jackpot, uint char, uint64 deadline, uint presses, address lastPresser
382         ) {
383         price = this.price();
384         jackpot = this.jackpot();
385         char = this.charityBalance();
386         deadline = this.deadline();
387         presses = this.presses();
388         lastPresser = this.lastPresser();
389     }
390 
391     ///Get the latest parameters
392     function latestParams() external view returns(
393         uint jackF, uint revF, uint charF, uint priceMul, uint nParam
394     ) {
395         jackF = this.jackpotFraction();
396         revF = this.revenueFraction();
397         charF = this.charityFraction();
398         priceMul = this.priceMultiplier();
399         nParam = this.n();
400     }
401 
402     ///Get the last winner address
403     function lastWinner() external view returns(address) {
404         if(campaigns.length == 0) {
405             return address(0x0);
406         } else {
407             if(active()) {
408                 return this.winner(lastCampaignID - 1);
409             } else {
410                 return this.winner(lastCampaignID);
411             }
412         }
413     }
414 
415     ///Get the total stats (cumulative for all campaigns)
416     function totalsData() external view returns(uint _totalWon, uint _totalCharity, uint _totalPresses) {
417         _totalWon = this.totalWon();
418         _totalCharity = this.totalCharity();
419         _totalPresses = this.totalPresses();
420     }
421    
422    /// The latest price for pressing the button
423     function price() external view returns(uint) {
424         if(active()) {
425             return campaigns[lastCampaignID].price;
426         } else {
427             return startingPrice;
428         }
429     }
430 
431     /// The latest jackpot fraction - note the fractions can be changed, but they don't affect any currently running campaign
432     function jackpotFraction() public view returns(uint) {
433         if(active()) {
434             return campaigns[lastCampaignID].jackpotFraction;
435         } else {
436             return _jackpotFraction;
437         }
438     }
439 
440     /// The latest revenue fraction
441     function revenueFraction() public view returns(uint) {
442         if(active()) {
443             return campaigns[lastCampaignID].devFraction;
444         } else {
445             return _devFraction;
446         }
447     }
448 
449     /// The latest charity fraction
450     function charityFraction() public view returns(uint) {
451         if(active()) {
452             return campaigns[lastCampaignID].charityFraction;
453         } else {
454             return _charityFraction;
455         }
456     }
457 
458     /// The latest price multiplier
459     function priceMultiplier() public view returns(uint) {
460         if(active()) {
461             return campaigns[lastCampaignID].priceMultiplier;
462         } else {
463             return _priceMultiplier;
464         }
465     }
466 
467     /// The latest preiod
468     function period() public view returns(uint) {
469         if(active()) {
470             return campaigns[lastCampaignID].period;
471         } else {
472             return _period;
473         }
474     }
475 
476     /// The latest N - the price will increase every Nth presses
477     function n() public view returns(uint) {
478         if(active()) {
479             return campaigns[lastCampaignID].n;
480         } else {
481             return _n;
482         }
483     }
484 
485     /// How much time is left in seconds if there's a running campaign
486     function timeLeft() external view returns(uint) {
487         if (active()) {
488             return campaigns[lastCampaignID].deadline - now;
489         } else {
490             return 0;
491         }
492     }
493 
494     /// What is the latest campaign's deadline
495     function deadline() external view returns(uint64) {
496         return campaigns[lastCampaignID].deadline;
497     }
498 
499     /// The number of presses for the current campaign
500     function presses() external view returns(uint) {
501         if(active()) {
502             return campaigns[lastCampaignID].presses;
503         } else {
504             return 0;
505         }
506     }
507 
508     /// Last presser
509     function lastPresser() external view returns(address) {
510         return campaigns[lastCampaignID].lastPresser;
511     }
512 
513     /// Returns the winner for any given campaign ID
514     function winner(uint campaignID) external view returns(address) {
515         return campaigns[campaignID].lastPresser;
516     }
517 
518     /// The current (or next) campaign's jackpot
519     function jackpot() external view returns(uint) {
520         if(active()){
521             return campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].jackpotFraction);
522         } else {
523             if(!campaigns[lastCampaignID].finalized) {
524                 return campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].jackpotFraction)
525                     .wmul(campaigns[lastCampaignID].newCampaignFraction);
526             } else {
527                 return nextCampaign.balanceETH.wmul(_jackpotFraction);
528             }
529         }
530     }
531 
532     /// Current/next campaign charity balance
533     function charityBalance() external view returns(uint) {
534         if(active()){
535             return campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].charityFraction);
536         } else {
537             if(!campaigns[lastCampaignID].finalized) {
538                 return campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].charityFraction)
539                     .wmul(campaigns[lastCampaignID].newCampaignFraction);
540             } else {
541                 return nextCampaign.balanceETH.wmul(_charityFraction);
542             }
543         }
544     }
545 
546     /// Revenue account current balance
547     function revenueBalance() external view returns(uint) {
548         return revenue.balanceETH;
549     }
550 
551     /// The starting balance of the next campaign
552     function nextCampaignBalance() external view returns(uint) {        
553         if(!campaigns[lastCampaignID].finalized) {
554             return campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].newCampaignFraction);
555         } else {
556             return nextCampaign.balanceETH;
557         }
558     }
559 
560     /// Total cumulative presses for all campaigns
561     function totalPresses() external view returns(uint) {
562         if (!campaigns[lastCampaignID].finalized) {
563             return totalPresses.add(campaigns[lastCampaignID].presses);
564         } else {
565             return totalPresses;
566         }
567     }
568 
569     /// Total cumulative charity for all campaigns
570     function totalCharity() external view returns(uint) {
571         if (!campaigns[lastCampaignID].finalized) {
572             return totalCharity.add(campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].charityFraction));
573         } else {
574             return totalCharity;
575         }
576     }
577 
578     /// Total cumulative revenue for all campaigns
579     function totalRevenue() external view returns(uint) {
580         if (!campaigns[lastCampaignID].finalized) {
581             return totalRevenue.add(campaigns[lastCampaignID].total.balanceETH.wmul(campaigns[lastCampaignID].devFraction));
582         } else {
583             return totalRevenue;
584         }
585     }
586 
587     /// Returns the balance of any winner
588     function hasWon(address _guy) external view returns(uint) {
589         return winners[_guy].balanceETH;
590     }
591 
592     /// Functions for handling value
593 
594     /// Withdrawal function for winners
595     function withdrawJackpot() public {
596         require(winners[msg.sender].balanceETH > 0, "Nothing to withdraw!");
597         sendETH(winners[msg.sender], msg.sender, winners[msg.sender].balanceETH);
598     }
599 
600     /// Any winner can chose to donate their jackpot
601     function donateJackpot() public {
602         require(winners[msg.sender].balanceETH > 0, "Nothing to donate!");
603         transferETH(winners[msg.sender], charity, winners[msg.sender].balanceETH);
604     }
605 
606     /// Dev revenue withdrawal function
607     function withdrawRevenue() public auth {
608         sendETH(revenue, owner, revenue.balanceETH);
609     }
610 
611     /// Dev charity transfer function - sends all of the charity balance to the pre-set charity address
612     /// Note that there's nothing stopping the devs to wait and set the charity beneficiary to their own address
613     /// and drain the charity balance for themselves. We would not do that as it would not make sense and it would
614     /// damage our reputation, but this is the only "weak" spot of the contract where it requires trust in the devs
615     function sendCharityETH(bytes callData) public auth {
616         // donation receiver might be a contract, so transact instead of a simple send
617         transact(charity, charityBeneficiary, charity.balanceETH, callData);
618     }
619 
620     /// This allows the owner to withdraw surplus ETH
621     function redeemSurplusETH() public auth {
622         uint surplus = address(this).balance.sub(totalETH);
623         balanceETH(base, surplus);
624         sendETH(base, msg.sender, base.balanceETH);
625     }
626 
627     /// This allows the owner to withdraw surplus Tokens
628     function redeemSurplusERC20(address token) public auth {
629         uint realTokenBalance = ERC20(token).balanceOf(this);
630         uint surplus = realTokenBalance.sub(totalTokenBalances[token]);
631         balanceToken(base, token, surplus);
632         sendToken(base, token, msg.sender, base.tokenBalances[token]);
633     }
634 
635     /// withdraw surplus ETH
636     function withdrawBaseETH() public auth {
637         sendETH(base, msg.sender, base.balanceETH);
638     }
639 
640     /// withdraw surplus tokens
641     function withdrawBaseERC20(address token) public auth {
642         sendToken(base, token, msg.sender, base.tokenBalances[token]);
643     }
644 
645     ///Setters
646 
647     /// Set button parameters
648     function setButtonParams(uint startingPrice_, uint priceMul_, uint32 period_, uint32 n_) public 
649     auth
650     limited(startingPrice_, 1 szabo, 10 ether) ///Parameters are limited
651     limited(priceMul_, ONE_WAD, 10 * ONE_WAD) // 100% to 10000% (1x to 10x)
652     limited(period_, 30 seconds, 1 weeks)
653     {
654         startingPrice = startingPrice_;
655         _priceMultiplier = priceMul_;
656         _period = period_;
657         _n = n_;
658         emit ButtonParamsChanged(startingPrice_, n_, period_, priceMul_);
659     }
660 
661     /// Fractions must add up to 100%, and can only be set every 2 weeks
662     function setAccountingParams(uint _devF, uint _charityF, uint _newCampF) public 
663     auth
664     limited(_devF.add(_charityF).add(_newCampF), 0, ONE_WAD) // up to 100% - charity fraction could be set to 100% for special occasions
665     timeLimited(2 weeks) { // can only be changed once every 4 weeks
666         require(_charityF <= ONE_WAD); // charity fraction can be up to 100%
667         require(_devF <= 20 * ONE_PERCENT_WAD); //can't set the dev fraction to more than 20%
668         require(_newCampF <= 10 * ONE_PERCENT_WAD);//less than 10%
669         _devFraction = _devF;
670         _charityFraction = _charityF;
671         _newCampaignFraction = _newCampF;
672         _jackpotFraction = ONE_WAD.sub(_devF).sub(_charityF).sub(_newCampF);
673         emit AccountingParamsChanged(_devF, _charityF, _jackpotFraction);
674     }
675 
676     ///Charity beneficiary can only be changed every 13 weeks
677     function setCharityBeneficiary(address _charity) public 
678     auth
679     timeLimited(13 weeks) 
680     {   
681         require(_charity != address(0));
682         charityBeneficiary = _charity;
683         emit CharityChanged(_charity);
684     }
685 
686 }
687 
688 /// Main contract with key logic
689 contract TheButton is ButtonBase {
690     
691     using DSMath for uint;
692 
693     ///If the contract is stopped no new campaigns can be started, but any running campaing is not affected
694     bool public stopped;
695 
696     constructor() public {
697         stopped = true;
698     }
699 
700     /// Press logic
701     function press() public payable {
702         //the last campaign
703         ButtonCampaign storage c = campaigns[lastCampaignID];
704         if (active()) {// if active
705             _press(c);//register press
706             depositETH(c.total, msg.sender, msg.value);// handle ETH
707         } else { //if inactive (after deadline)
708             require(!stopped, "Contract stopped!");//make sure we're not stopped
709             if(!c.finalized) {//if not finalized
710                 _finalizeCampaign(c);// finalize last campaign
711             } 
712             _newCampaign();// start new campaign
713             c = campaigns[lastCampaignID];
714                     
715             _press(c);//resigter press
716             depositETH(c.total, msg.sender, msg.value);//handle ETH
717         } 
718     }
719 
720     function start() external payable auth {
721         require(stopped, "Already started!");
722         stopped = false;
723         
724         if(campaigns.length != 0) {//if there was a past campaign
725             ButtonCampaign storage c = campaigns[lastCampaignID];
726             require(c.finalized, "Last campaign not finalized!");//make sure it was finalized
727         }             
728         _newCampaign();//start new campaign
729         c = campaigns[lastCampaignID];
730         _press(c);
731         depositETH(c.total, msg.sender, msg.value);// deposit ETH        
732     }
733 
734     ///Stopping will only affect new campaigns, not already running ones
735     function stop() external auth {
736         require(!stopped, "Already stopped!");
737         stopped = true;
738     }
739     
740     /// Anyone can finalize campaigns in case the devs stop the contract
741     function finalizeLastCampaign() external {
742         require(stopped);
743         ButtonCampaign storage c = campaigns[lastCampaignID];
744         _finalizeCampaign(c);
745     }
746 
747     function finalizeCampaign(uint id) external {
748         require(stopped);
749         ButtonCampaign storage c = campaigns[id];
750         _finalizeCampaign(c);
751     }
752 
753     //Press logic
754     function _press(ButtonCampaign storage c) internal {
755         require(c.deadline >= now, "After deadline!");//must be before the deadline
756         require(msg.value >= c.price, "Not enough value!");// must have at least the price value
757         c.presses += 1;//no need for safe math, as it is not a critical calculation
758         c.lastPresser = msg.sender;
759              
760         if(c.presses % c.n == 0) {// increase the price every n presses
761             c.price = c.price.wmul(c.priceMultiplier);
762         }           
763 
764         emit Pressed(msg.sender, msg.value, c.deadline - uint64(now));
765         c.deadline = uint64(now.add(c.period)); // set the new deadline
766     }
767 
768     /// starting a new campaign
769     function _newCampaign() internal {
770         require(!active(), "A campaign is already running!");
771         require(_devFraction.add(_charityFraction).add(_jackpotFraction).add(_newCampaignFraction) == ONE_WAD, "Accounting is incorrect!");
772         
773         uint _campaignID = campaigns.length++;
774         ButtonCampaign storage c = campaigns[_campaignID];
775         lastCampaignID = _campaignID;
776 
777         c.price = startingPrice;
778         c.priceMultiplier = _priceMultiplier;
779         c.devFraction = _devFraction;
780         c.charityFraction = _charityFraction;
781         c.jackpotFraction = _jackpotFraction;
782         c.newCampaignFraction = _newCampaignFraction;
783         c.deadline = uint64(now.add(_period));
784         c.n = _n;
785         c.period = _period;
786         c.total.name = keccak256(abi.encodePacked("Total", lastCampaignID));//setting the name of the campaign's accaount     
787         transferETH(nextCampaign, c.total, nextCampaign.balanceETH);
788         emit Started(c.total.balanceETH, _period, lastCampaignID); 
789     }
790 
791     /// Finalize campaign logic
792     function _finalizeCampaign(ButtonCampaign storage c) internal {
793         require(c.deadline < now, "Before deadline!");
794         require(!c.finalized, "Already finalized!");
795         
796         if(c.presses != 0) {//If there were presses
797             uint totalBalance = c.total.balanceETH;
798             //Handle all of the accounting            
799             transferETH(c.total, winners[c.lastPresser], totalBalance.wmul(c.jackpotFraction));
800             winners[c.lastPresser].name = bytes32(c.lastPresser);
801             totalWon = totalWon.add(totalBalance.wmul(c.jackpotFraction));
802 
803             transferETH(c.total, revenue, totalBalance.wmul(c.devFraction));
804             totalRevenue = totalRevenue.add(totalBalance.wmul(c.devFraction));
805 
806             transferETH(c.total, charity, totalBalance.wmul(c.charityFraction));
807             totalCharity = totalCharity.add(totalBalance.wmul(c.charityFraction));
808 
809             //avoiding rounding errors - just transfer the leftover
810             // transferETH(c.total, nextCampaign, c.total.balanceETH);
811 
812             totalPresses = totalPresses.add(c.presses);
813 
814             emit Winrar(c.lastPresser, totalBalance.wmul(c.jackpotFraction));
815         } 
816         // if there will be no next campaign
817         if(stopped) {
818             //transfer leftover to devs' base account
819             transferETH(c.total, base, c.total.balanceETH);
820         } else {
821             //otherwise transfer to next campaign
822             transferETH(c.total, nextCampaign, c.total.balanceETH);
823         }
824         c.finalized = true;
825     }
826 }