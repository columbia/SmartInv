1 pragma solidity ^0.4.25;
2 // expansion on original contract from dav's stronghands contract sac3d
3 // the real OG 
4 
5 // expansion Slaughter3D Coded by spielley 
6 
7 // now reworked with new refund line model 
8 //  and able to force someone into a match if they hold enough balance
9 
10 // Thank you for playing Spielleys contract creations.
11 // spielley is not liable for any contract bugs and exploits known or unknown.
12 
13 // this games dev fee gets shared in SPASM
14 // check it out at: https://etherscan.io/address/0xfaae60f2ce6491886c9f7c9356bd92f688ca66a1#code
15 
16 // ----------------------------------------------------------------------------
17 // Owned contract
18 // ----------------------------------------------------------------------------
19 contract Owned {
20     address public owner;
21     address public newOwner;
22 
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25     constructor() public {
26         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address _newOwner) public onlyOwner {
35         newOwner = _newOwner;
36     }
37     function acceptOwnership() public {
38         require(msg.sender == newOwner);
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41         newOwner = address(0);
42     }
43 }
44 contract Slaughter3D is Owned {
45     using SafeMath for uint;
46     struct Stage {
47         uint8 numberOfPlayers;
48         uint256 blocknumber;
49         bool finalized;
50         mapping (uint8 => address) slotXplayer;
51         mapping (address => bool) players;
52         mapping (uint8 => address) setMN;
53         
54     }
55     
56     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
57     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//spielley's profit sharing payout
58     Slaughter3DInterface constant old = Slaughter3DInterface(0xA76daa02C1A6411c6c368f3A59f4f2257a460006);
59     //a small part of every winners share of the sacrificed players offer is used to purchase p3d instead
60     uint256 constant private P3D_SHARE = 0.005 ether;
61     
62     uint8 constant public MAX_PLAYERS_PER_STAGE = 2;
63     uint256 constant public OFFER_SIZE = 0.1 ether;
64     uint256 public Refundpot;
65     
66     uint256 private p3dPerStage = P3D_SHARE * (MAX_PLAYERS_PER_STAGE - 1);
67     //not sacrificed players receive their offer back and also a share of the sacrificed players offer 
68     uint256 public winningsPerRound = 0.185 ether;
69     
70     mapping(address => uint256) public playerVault;
71     mapping(uint256 => Stage) public stages;
72     mapping(uint256 => address) public RefundWaitingLine;
73     mapping(uint256 => address) public Loser;
74     uint256 public  NextInLine;//next person to be refunded
75     uint256 public  NextAtLineEnd;//next spot to add loser
76     uint256 private numberOfFinalizedStages;
77     
78     uint256 public numberOfStages;
79     
80     event SacrificeOffered(address indexed player);
81     event SacrificeChosen(address indexed sarifice);
82     event EarningsWithdrawn(address indexed player, uint256 indexed amount);
83     event StageInvalidated(uint256 indexed stage);
84     
85     uint256 public NextInLineOld;
86     uint256 public lastToPayOld;
87     // UI view functions
88     function previousstageloser()
89         public
90         view
91         returns(address)
92     {
93         return (Loser[numberOfFinalizedStages]);
94     }
95     function previousstageplayer1()
96         public
97         view
98         returns(address)
99     {
100         return (stages[numberOfFinalizedStages].slotXplayer[0]);
101     }
102     function previousstageplayer2()
103         public
104         view
105         returns(address)
106     {
107         return (stages[numberOfFinalizedStages].slotXplayer[1]);
108     }
109     function currentstageplayer1()
110         public
111         view
112         returns( address )
113     {
114         return (stages[numberOfStages].slotXplayer[0]);
115     }
116     function currentstageplayer2()
117         public
118         view
119         returns( address )
120     {
121         return (stages[numberOfStages].slotXplayer[1]);
122     }
123 
124     function checkstatus()// true = ready to vallidate
125         public
126         view
127         returns(bool )
128     {
129         bool check;
130         if(numberOfStages >= numberOfFinalizedStages)
131         {
132             if(!stages[numberOfFinalizedStages].finalized && stages[numberOfFinalizedStages].numberOfPlayers < MAX_PLAYERS_PER_STAGE && stages[numberOfFinalizedStages].blocknumber != 0)
133             {
134                 check = true;
135             }
136         }
137         return (check);
138     }
139     
140     function nextonetogetpaid()
141         public
142         view
143         returns(address)
144     {
145         
146         return (RefundWaitingLine[NextInLine]);
147     }
148    function contractownsthismanyP3D()
149         public
150         view
151         returns(uint256)
152     {
153         return (p3dContract.balanceOf(address(this)));
154     }
155     // expansion functions
156     // new refundline model
157     uint256 public pointMultiplier = 10e18;
158 struct Account {
159   uint balance;
160   uint lastDividendPoints;
161 }
162 mapping(address => uint256) public balances;
163 uint256 public _totalSupply;
164 mapping(address=>Account) public accounts;
165 uint public ethtotalSupply;
166 uint public totalDividendPoints;
167 uint public unclaimedDividends;
168 
169 function dividendsOwing(address account) public view returns(uint256) {
170   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
171   return (balances[account] * newDividendPoints) / pointMultiplier;
172 }
173 modifier updateAccount(address account) {
174   uint256 owing = dividendsOwing(account);
175   if(owing > balances[account]){balances[account] = owing;}
176   if(owing > 0 ) {
177     unclaimedDividends = unclaimedDividends.sub(owing);
178     
179     playerVault[account] = playerVault[account].add(owing);
180     balances[account] = balances[account].sub(owing);
181     _totalSupply = _totalSupply.sub(owing);
182   }
183   accounts[account].lastDividendPoints = totalDividendPoints;
184   _;
185 }
186 function () external payable{}
187 function fetchdivs(address toUpdate) public updateAccount(toUpdate){}
188 
189 function disburse() public  payable {
190     uint256 amount = msg.value;
191     
192   totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
193   //ethtotalSupply = ethtotalSupply.add(amount);
194  unclaimedDividends = unclaimedDividends.add(amount);
195 }
196 
197     //fetch P3D divs
198     function DivsToRefundpot ()public
199     {
200         //allocate p3d dividends to contract 
201             uint256 dividends = p3dContract.myDividends(true);
202             require(dividends > 0);
203             uint256 base = dividends.div(100);
204             p3dContract.withdraw();
205             SPASM_.disburse.value(base.mul(5));// to dev fee sharing contract SPASM
206             Refundpot = Refundpot.add(base.mul(95));
207             
208     }
209     //Donate to losers
210     function DonateToLosers ()public payable
211     {
212             require(msg.value > 0);
213             Refundpot = Refundpot.add(msg.value);
214 
215     }
216     // legacystarting refunds from old contract
217     function legacyStart(uint256 amountProgress) onlyOwner public{
218         uint256 nextUp = NextInLineOld;
219         for(uint i=0; i< amountProgress; i++)
220         {
221         address torefund = old.RefundWaitingLine(nextUp + i);
222         i++;
223         balances[torefund] = balances[torefund].add(0.1 ether);
224         }
225         NextInLineOld += i;
226         _totalSupply = _totalSupply.add(i.mul(0.1 ether));
227     }
228     // next loser payout distribution
229     function Payoutnextrefund ()public
230     {
231          
232         require(Refundpot > 0.00001 ether);
233         uint256 amount = Refundpot;
234     Refundpot = 0;
235     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
236     unclaimedDividends = unclaimedDividends.add(amount);
237     }
238     
239     // Sac dep
240     modifier isValidOffer()
241     {
242         require(msg.value == OFFER_SIZE);
243         _;
244     }
245     
246     modifier canPayFromVault()
247     {
248         require(playerVault[msg.sender] >= OFFER_SIZE);
249         _;
250     }
251     
252     modifier hasEarnings()
253     {
254         require(playerVault[msg.sender] > 0);
255         _;
256     }
257     
258     modifier prepareStage()
259     {
260         //create a new stage if current has reached max amount of players
261         if(stages[numberOfStages - 1].numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
262            stages[numberOfStages] = Stage(0, 0, false );
263            numberOfStages++;
264         }
265         _;
266     }
267     
268     modifier isNewToStage()
269     {
270         require(stages[numberOfStages - 1].players[msg.sender] == false);
271         _;
272     }
273     
274     constructor()
275         public
276     {
277         stages[numberOfStages] = Stage(0, 0, false);
278         numberOfStages++;
279         NextInLineOld = old.NextInLine();
280         lastToPayOld = 525;
281     }
282     
283     //function() external payable {}
284     
285     function offerAsSacrifice(address MN)
286         external
287         payable
288         isValidOffer
289         prepareStage
290         isNewToStage
291     {
292         acceptOffer(MN);
293         
294         //try to choose a sacrifice in an already full stage (finalize a stage)
295         tryFinalizeStage();
296     }
297     
298     function offerAsSacrificeFromVault(address MN)
299         external
300         canPayFromVault
301         prepareStage
302         isNewToStage
303     {
304         playerVault[msg.sender] -= OFFER_SIZE;
305         
306         acceptOffer(MN);
307         
308         tryFinalizeStage();
309     }
310     function offerAsSacrificeFromVaultForce(address MN, address forcedToFight)
311         external
312         payable
313         prepareStage
314         
315     {
316         uint256 value = msg.value;
317         require(value >= 0.005 ether);
318         require(playerVault[forcedToFight] >= OFFER_SIZE);
319         require(stages[numberOfStages - 1].players[forcedToFight] == false);
320         playerVault[forcedToFight] -= OFFER_SIZE;
321         playerVault[forcedToFight] += 0.003 ether;
322         SPASM_.disburse.value(0.002 ether);
323         //
324         Stage storage currentStage = stages[numberOfStages - 1];
325         
326         assert(currentStage.numberOfPlayers < MAX_PLAYERS_PER_STAGE);
327         
328         address player = forcedToFight;
329         
330         //add player to current stage
331         currentStage.slotXplayer[currentStage.numberOfPlayers] = player;
332         currentStage.numberOfPlayers++;
333         currentStage.players[player] = true;
334         currentStage.setMN[currentStage.numberOfPlayers] = MN;
335         emit SacrificeOffered(player);
336         
337         //add blocknumber to current stage when the last player is added
338         if(currentStage.numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
339             currentStage.blocknumber = block.number;
340         }
341         //
342         tryFinalizeStage();
343         
344 
345     }
346     function withdraw()
347         external
348         hasEarnings
349     {
350         tryFinalizeStage();
351         
352         uint256 amount = playerVault[msg.sender];
353         playerVault[msg.sender] = 0;
354         
355         emit EarningsWithdrawn(msg.sender, amount); 
356         
357         msg.sender.transfer(amount);
358     }
359     
360     function myEarnings()
361         external
362         view
363         hasEarnings
364         returns(uint256)
365     {
366         return playerVault[msg.sender];
367     }
368     
369     function currentPlayers()
370         external
371         view
372         returns(uint256)
373     {
374         return stages[numberOfStages - 1].numberOfPlayers;
375     }
376     
377     function acceptOffer(address MN)
378         private
379     {
380         Stage storage currentStage = stages[numberOfStages - 1];
381         
382         assert(currentStage.numberOfPlayers < MAX_PLAYERS_PER_STAGE);
383         
384         address player = msg.sender;
385         
386         //add player to current stage
387         currentStage.slotXplayer[currentStage.numberOfPlayers] = player;
388         currentStage.numberOfPlayers++;
389         currentStage.players[player] = true;
390         currentStage.setMN[currentStage.numberOfPlayers] = MN;
391         emit SacrificeOffered(player);
392         
393         //add blocknumber to current stage when the last player is added
394         if(currentStage.numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
395             currentStage.blocknumber = block.number;
396         }
397         
398     }
399     
400     function tryFinalizeStage()
401         public
402     {
403         assert(numberOfStages >= numberOfFinalizedStages);
404         
405         //there are no stages to finalize
406         if(numberOfStages == numberOfFinalizedStages) {return;}
407         
408         Stage storage stageToFinalize = stages[numberOfFinalizedStages];
409         
410         assert(!stageToFinalize.finalized);
411         
412         //stage is not ready to be finalized
413         if(stageToFinalize.numberOfPlayers < MAX_PLAYERS_PER_STAGE) {return;}
414         
415         assert(stageToFinalize.blocknumber != 0);
416         
417         //check if blockhash can be determined
418         if(block.number - 256 <= stageToFinalize.blocknumber) {
419             //blocknumber of stage can not be equal to current block number -> blockhash() won't work
420             if(block.number == stageToFinalize.blocknumber) {return;}
421                 
422             //determine sacrifice
423             uint8 sacrificeSlot = uint8(blockhash(stageToFinalize.blocknumber)) % MAX_PLAYERS_PER_STAGE;
424            
425             address sacrifice = stageToFinalize.slotXplayer[sacrificeSlot];
426             Loser[numberOfFinalizedStages] = sacrifice;
427             emit SacrificeChosen(sacrifice);
428             
429             //allocate winnings to survivors
430             allocateSurvivorWinnings(sacrifice);
431            
432             //add sacrifice to refund waiting line
433             fetchdivs(sacrifice);
434             balances[sacrifice] = balances[sacrifice].add(0.1 ether);
435             _totalSupply += 0.1 ether;
436             
437             
438             //add 0.005 ether to Refundpot
439             Refundpot = Refundpot.add(0.005 ether);
440             //purchase p3d (using ref) 
441             p3dContract.buy.value(0.004 ether)(stageToFinalize.setMN[1]);
442             p3dContract.buy.value(0.004 ether)(stageToFinalize.setMN[2]);
443             SPASM_.disburse.value(0.002 ether);
444             
445         } else {
446             invalidateStage(numberOfFinalizedStages);
447             
448             emit StageInvalidated(numberOfFinalizedStages);
449         }
450         //finalize stage
451         stageToFinalize.finalized = true;
452         numberOfFinalizedStages++;
453     }
454     
455     function allocateSurvivorWinnings(address sacrifice)
456         private
457     {
458         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
459             address survivor = stages[numberOfFinalizedStages].slotXplayer[i];
460             if(survivor != sacrifice) {
461                 playerVault[survivor] += winningsPerRound;
462             }
463         }
464     }
465     
466     function invalidateStage(uint256 stageIndex)
467         private
468     {
469         Stage storage stageToInvalidate = stages[stageIndex];
470         
471         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
472             address player = stageToInvalidate.slotXplayer[i];
473             playerVault[player] += OFFER_SIZE;
474         }
475     }
476 }
477 
478 interface HourglassInterface {
479     function buy(address _playerAddress) payable external returns(uint256);
480     function withdraw() external;
481     function myDividends(bool _includeReferralBonus) external view returns(uint256);
482     function balanceOf(address _playerAddress) external view returns(uint256);
483 }
484 interface SPASMInterface  {
485     function() payable external;
486     function disburse() external  payable;
487 }
488 interface Slaughter3DInterface {
489     function RefundWaitingLine(uint256 index) external view returns(address);
490     function NextInLine() external view returns(uint256);
491     function NextAtLineEnd() external view returns(uint256);
492 }
493 // ----------------------------------------------------------------------------
494 // Safe maths
495 // ----------------------------------------------------------------------------
496 library SafeMath {
497     function add(uint a, uint b) internal pure returns (uint c) {
498         c = a + b;
499         require(c >= a);
500     }
501     function sub(uint a, uint b) internal pure returns (uint c) {
502         require(b <= a);
503         c = a - b;
504     }
505     function mul(uint a, uint b) internal pure returns (uint c) {
506         c = a * b;
507         require(a == 0 || c / a == b);
508     }
509     function div(uint a, uint b) internal pure returns (uint c) {
510         require(b > 0);
511         c = a / b;
512     }
513 }