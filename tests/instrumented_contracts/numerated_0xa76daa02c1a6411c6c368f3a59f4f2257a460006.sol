1 pragma solidity ^0.4.25;
2 // expansion on original contract from dav's stronghands contract
3 
4 // introducing features:
5 // Jackpot - 1 in 1000 chance to get jackpot upon losing
6 // Refund line for loser to get their initial eth back
7 
8 // eth distribution:
9 // each game seeds 0.01 eth to buy P3D with
10 // each game seeds 0.005 eth to the refund line making a minimum payback each 20 games played
11 // 0.1 eth to play per player each round
12 
13 
14 // expansion Coded by spielley 
15 
16 // Thank you for playing Spielleys contract creations.
17 // spielley is not liable for any contract bugs and exploits known or unknown.
18 contract Slaughter3D {
19     using SafeMath for uint;
20     struct Stage {
21         uint8 numberOfPlayers;
22         uint256 blocknumber;
23         bool finalized;
24         mapping (uint8 => address) slotXplayer;
25         mapping (address => bool) players;
26         mapping (uint8 => address) setMN;
27         
28     }
29     
30     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
31     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//spielley's profit sharing payout
32     //a small part of every winners share of the sacrificed players offer is used to purchase p3d instead
33     uint256 constant private P3D_SHARE = 0.005 ether;
34     
35     uint8 constant public MAX_PLAYERS_PER_STAGE = 2;
36     uint256 constant public OFFER_SIZE = 0.1 ether;
37     uint256 public Refundpot;
38     uint256 public Jackpot;// 1% of P3D divs to be allocated to the Jackpot
39     uint256 public SPASMfee;//1% of P3D divs to be shared with SPASM holders
40     mapping(address => uint256) public ETHtoP3Dbymasternode; //eth to buy P3D masternode
41     
42     uint256 private p3dPerStage = P3D_SHARE * (MAX_PLAYERS_PER_STAGE - 1);
43     //not sacrificed players receive their offer back and also a share of the sacrificed players offer 
44     uint256 public winningsPerRound = 0.185 ether;
45     
46     mapping(address => string) public Vanity;
47     mapping(address => uint256) private playerVault;
48     mapping(uint256 => Stage) public stages;
49     mapping(uint256 => address) public RefundWaitingLine;
50     mapping(uint256 => address) public Loser;
51     uint256 public  NextInLine;//next person to be refunded
52     uint256 public  NextAtLineEnd;//next spot to add loser
53     uint256 private numberOfFinalizedStages;
54     
55     uint256 public numberOfStages;
56     
57     event JackpotWon(address indexed winner, uint256 SizeOfJackpot);
58     event SacrificeOffered(address indexed player);
59     event SacrificeChosen(address indexed sarifice);
60     event EarningsWithdrawn(address indexed player, uint256 indexed amount);
61     event StageInvalidated(uint256 indexed stage);
62     // UI view functions
63     
64     
65     function previousstageloser()
66         public
67         view
68         returns(address)
69     {
70         return (Loser[numberOfFinalizedStages]);
71     }
72     function previousstageplayer1()
73         public
74         view
75         returns(address)
76     {
77         return (stages[numberOfFinalizedStages].slotXplayer[0]);
78     }
79     function previousstageplayer2()
80         public
81         view
82         returns(address)
83     {
84         return (stages[numberOfFinalizedStages].slotXplayer[2]);
85     }
86     function currentstageplayer1()
87         public
88         view
89         returns( address )
90     {
91         return (stages[numberOfStages].slotXplayer[0]);
92     }
93     function currentstageplayer2()
94         public
95         view
96         returns( address )
97     {
98         return (stages[numberOfStages].slotXplayer[1]);
99     }
100     function playervanity(address theplayer)
101         public
102         view
103         returns( string )
104     {
105         return (Vanity[theplayer]);
106     }
107     function jackpotinfo()
108         public
109         view
110         returns(uint256 SizeOfJackpot )
111     {
112         return (Jackpot);
113     }
114     function checkstatus()// true = ready to vallidate
115         public
116         view
117         returns(bool  )
118     {
119         bool check;
120         if(numberOfStages >= numberOfFinalizedStages)
121         {
122             if(!stages[numberOfFinalizedStages].finalized && stages[numberOfFinalizedStages].numberOfPlayers < MAX_PLAYERS_PER_STAGE && stages[numberOfFinalizedStages].blocknumber != 0)
123             {
124                 check = true;
125             }
126         }
127         return (check);
128     }
129     
130     function nextonetogetpaid()
131         public
132         view
133         returns(address)
134     {
135         
136         return (RefundWaitingLine[NextInLine]);
137     }
138    function contractownsthismanyP3D()
139         public
140         view
141         returns(uint256)
142     {
143         
144         return (p3dContract.balanceOf(address(this)));
145     }
146     // expansion functions
147     
148     // Buy P3D by masternode 
149     function Expand(address masternode) public 
150     {
151     uint256 amt = ETHtoP3Dbymasternode[masternode];
152     ETHtoP3Dbymasternode[masternode] = 0;
153     if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
154     p3dContract.buy.value(amt)(masternode);
155     
156     }
157     //fetch P3D divs
158     function DivsToRefundpot ()public
159     {
160         //allocate p3d dividends to contract 
161             uint256 dividends = p3dContract.myDividends(true);
162             require(dividends > 0);
163             uint256 base = dividends.div(100);
164             p3dContract.withdraw();
165             SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
166             Refundpot = Refundpot.add(base.mul(94));
167             Jackpot = Jackpot.add(base.mul(5)); // allocation to jackpot
168             //
169     }
170     //Donate to losers
171     function DonateToLosers ()public payable
172     {
173             require(msg.value > 0);
174             Refundpot = Refundpot.add(msg.value);
175 
176     }
177     // next loser payout
178     function Payoutnextrefund ()public
179     {
180         //allocate p3d dividends to sacrifice if existing
181             uint256 Pot = Refundpot;
182             require(Pot > 0.1 ether);
183             Refundpot -= 0.1 ether;
184             RefundWaitingLine[NextInLine].transfer(0.1 ether);
185             NextInLine++;
186             //
187     }
188     //changevanity
189     function changevanity(string van , address masternode) public payable
190     {
191     require(msg.value >= 1  finney);
192     Vanity[msg.sender] = van;
193     uint256 amt = ETHtoP3Dbymasternode[masternode].add(msg.value);
194     ETHtoP3Dbymasternode[masternode] = 0;
195     if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
196     p3dContract.buy.value(amt)(masternode);
197     }
198     // Sac dep
199     modifier isValidOffer()
200     {
201         require(msg.value == OFFER_SIZE);
202         _;
203     }
204     
205     modifier canPayFromVault()
206     {
207         require(playerVault[msg.sender] >= OFFER_SIZE);
208         _;
209     }
210     
211     modifier hasEarnings()
212     {
213         require(playerVault[msg.sender] > 0);
214         _;
215     }
216     
217     modifier prepareStage()
218     {
219         //create a new stage if current has reached max amount of players
220         if(stages[numberOfStages - 1].numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
221            stages[numberOfStages] = Stage(0, 0, false );
222            numberOfStages++;
223         }
224         _;
225     }
226     
227     modifier isNewToStage()
228     {
229         require(stages[numberOfStages - 1].players[msg.sender] == false);
230         _;
231     }
232     
233     constructor()
234         public
235     {
236         stages[numberOfStages] = Stage(0, 0, false);
237         numberOfStages++;
238     }
239     
240     function() external payable {}
241     
242     function offerAsSacrifice(address MN)
243         external
244         payable
245         isValidOffer
246         prepareStage
247         isNewToStage
248     {
249         acceptOffer(MN);
250         
251         //try to choose a sacrifice in an already full stage (finalize a stage)
252         tryFinalizeStage();
253     }
254     
255     function offerAsSacrificeFromVault(address MN)
256         external
257         canPayFromVault
258         prepareStage
259         isNewToStage
260     {
261         playerVault[msg.sender] -= OFFER_SIZE;
262         
263         acceptOffer(MN);
264         
265         tryFinalizeStage();
266     }
267     
268     function withdraw()
269         external
270         hasEarnings
271     {
272         tryFinalizeStage();
273         
274         uint256 amount = playerVault[msg.sender];
275         playerVault[msg.sender] = 0;
276         
277         emit EarningsWithdrawn(msg.sender, amount); 
278         
279         msg.sender.transfer(amount);
280     }
281     
282     function myEarnings()
283         external
284         view
285         hasEarnings
286         returns(uint256)
287     {
288         return playerVault[msg.sender];
289     }
290     
291     function currentPlayers()
292         external
293         view
294         returns(uint256)
295     {
296         return stages[numberOfStages - 1].numberOfPlayers;
297     }
298     
299     function acceptOffer(address MN)
300         private
301     {
302         Stage storage currentStage = stages[numberOfStages - 1];
303         
304         assert(currentStage.numberOfPlayers < MAX_PLAYERS_PER_STAGE);
305         
306         address player = msg.sender;
307         
308         //add player to current stage
309         currentStage.slotXplayer[currentStage.numberOfPlayers] = player;
310         currentStage.numberOfPlayers++;
311         currentStage.players[player] = true;
312         currentStage.setMN[currentStage.numberOfPlayers] = MN;
313         emit SacrificeOffered(player);
314         
315         //add blocknumber to current stage when the last player is added
316         if(currentStage.numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
317             currentStage.blocknumber = block.number;
318         }
319         
320     }
321     
322     function tryFinalizeStage()
323         public
324     {
325         assert(numberOfStages >= numberOfFinalizedStages);
326         
327         //there are no stages to finalize
328         if(numberOfStages == numberOfFinalizedStages) {return;}
329         
330         Stage storage stageToFinalize = stages[numberOfFinalizedStages];
331         
332         assert(!stageToFinalize.finalized);
333         
334         //stage is not ready to be finalized
335         if(stageToFinalize.numberOfPlayers < MAX_PLAYERS_PER_STAGE) {return;}
336         
337         assert(stageToFinalize.blocknumber != 0);
338         
339         //check if blockhash can be determined
340         if(block.number - 256 <= stageToFinalize.blocknumber) {
341             //blocknumber of stage can not be equal to current block number -> blockhash() won't work
342             if(block.number == stageToFinalize.blocknumber) {return;}
343                 
344             //determine sacrifice
345             uint8 sacrificeSlot = uint8(blockhash(stageToFinalize.blocknumber)) % MAX_PLAYERS_PER_STAGE;
346             uint256 jackpot = uint256(blockhash(stageToFinalize.blocknumber)) % 1000;
347             address sacrifice = stageToFinalize.slotXplayer[sacrificeSlot];
348             Loser[numberOfFinalizedStages] = sacrifice;
349             emit SacrificeChosen(sacrifice);
350             
351             //allocate winnings to survivors
352             allocateSurvivorWinnings(sacrifice);
353             
354             //check jackpot win
355             if(jackpot == 777){
356                 sacrifice.transfer(Jackpot);
357                 emit JackpotWon ( sacrifice, Jackpot);
358                 Jackpot = 0;
359             }
360             
361             
362             //add sacrifice to refund waiting line
363             RefundWaitingLine[NextAtLineEnd] = sacrifice;
364             NextAtLineEnd++;
365             
366             //set eth to MN for buying P3D deprecated
367             //ETHtoP3Dbymasternode[stageToFinalize.setMN[1]] = ETHtoP3Dbymasternode[stageToFinalize.setMN[1]].add(0.005 ether);
368             //ETHtoP3Dbymasternode[stageToFinalize.setMN[1]] = ETHtoP3Dbymasternode[stageToFinalize.setMN[2]].add(0.005 ether);
369             
370             //add 0.005 ether to Refundpot
371             Refundpot = Refundpot.add(0.005 ether);
372             //purchase p3d (using ref) 
373             p3dContract.buy.value(0.005 ether)(stageToFinalize.setMN[1]);
374             p3dContract.buy.value(0.005 ether)(stageToFinalize.setMN[2]);
375             
376         } else {
377             invalidateStage(numberOfFinalizedStages);
378             
379             emit StageInvalidated(numberOfFinalizedStages);
380         }
381         //finalize stage
382         stageToFinalize.finalized = true;
383         numberOfFinalizedStages++;
384     }
385     
386     function allocateSurvivorWinnings(address sacrifice)
387         private
388     {
389         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
390             address survivor = stages[numberOfFinalizedStages].slotXplayer[i];
391             if(survivor != sacrifice) {
392                 playerVault[survivor] += winningsPerRound;
393             }
394         }
395     }
396     
397     function invalidateStage(uint256 stageIndex)
398         private
399     {
400         Stage storage stageToInvalidate = stages[stageIndex];
401         
402         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
403             address player = stageToInvalidate.slotXplayer[i];
404             playerVault[player] += OFFER_SIZE;
405         }
406     }
407 }
408 
409 interface HourglassInterface {
410     function buy(address _playerAddress) payable external returns(uint256);
411     function withdraw() external;
412     function myDividends(bool _includeReferralBonus) external view returns(uint256);
413     function balanceOf(address _playerAddress) external view returns(uint256);
414 }
415 interface SPASMInterface  {
416     function() payable external;
417     function disburse() external  payable;
418 }
419 // ----------------------------------------------------------------------------
420 // Safe maths
421 // ----------------------------------------------------------------------------
422 library SafeMath {
423     function add(uint a, uint b) internal pure returns (uint c) {
424         c = a + b;
425         require(c >= a);
426     }
427     function sub(uint a, uint b) internal pure returns (uint c) {
428         require(b <= a);
429         c = a - b;
430     }
431     function mul(uint a, uint b) internal pure returns (uint c) {
432         c = a * b;
433         require(a == 0 || c / a == b);
434     }
435     function div(uint a, uint b) internal pure returns (uint c) {
436         require(b > 0);
437         c = a / b;
438     }
439 }