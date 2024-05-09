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
64     function previousstagedata()
65         public
66         view
67         returns(address loser , address player1, string van1 ,address player2, string van2 )
68     {
69         return (Loser[numberOfFinalizedStages],stages[numberOfFinalizedStages].slotXplayer[0],Vanity[stages[numberOfFinalizedStages].slotXplayer[0]],stages[numberOfFinalizedStages].slotXplayer[1],Vanity[stages[numberOfFinalizedStages].slotXplayer[1]]);
70     }
71     function currentstagedata()
72         public
73         view
74         returns( address player1, string van1 ,address player2, string van2 )
75     {
76         return (stages[numberOfStages].slotXplayer[0],Vanity[stages[numberOfStages].slotXplayer[0]],stages[numberOfStages].slotXplayer[1],Vanity[stages[numberOfStages].slotXplayer[1]]);
77     }
78     function jackpotinfo()
79         public
80         view
81         returns(uint256 SizeOfJackpot )
82     {
83         return (Jackpot);
84     }
85     function checkstatus()
86         public
87         view
88         returns(bool CanStartBattle )
89     {
90         bool check;
91         if(numberOfStages >= numberOfFinalizedStages)
92         {
93             if(!stages[numberOfFinalizedStages].finalized && stages[numberOfFinalizedStages].numberOfPlayers < MAX_PLAYERS_PER_STAGE && stages[numberOfFinalizedStages].blocknumber != 0)
94             {
95                 check = true;
96             }
97         }
98         return (check);
99     }
100     function Refundlineinfo()
101         public
102         view
103         returns(address NextAdresstoRefund, uint256 LengthUnpaidLine,uint256 divsunfetched, uint256 refundpot , string vanityofnexttoberefunded)
104     {
105         LengthUnpaidLine = NextAtLineEnd - NextInLine;
106         uint256 dividends = p3dContract.myDividends(true);
107         return (RefundWaitingLine[NextInLine],LengthUnpaidLine, dividends , Refundpot ,Vanity[RefundWaitingLine[NextInLine]]);
108     }
109     // expansion functions
110     
111     // Buy P3D by masternode 
112     function Expand(address masternode) public 
113     {
114     uint256 amt = ETHtoP3Dbymasternode[masternode];
115     ETHtoP3Dbymasternode[masternode] = 0;
116     if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
117     p3dContract.buy.value(amt)(masternode);
118     
119     }
120     //fetch P3D divs
121     function DivsToRefundpot ()public
122     {
123         //allocate p3d dividends to contract 
124             uint256 dividends = p3dContract.myDividends(true);
125             require(dividends > 0);
126             uint256 base = dividends.div(100);
127             p3dContract.withdraw();
128             SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
129             Refundpot = Refundpot.add(base.mul(94));
130             Jackpot = Jackpot.add(base.mul(5)); // allocation to jackpot
131             //
132     }
133     //Donate to losers
134     function DonateToLosers ()public payable
135     {
136             require(msg.value > 0);
137             Refundpot = Refundpot.add(msg.value);
138 
139     }
140     // next loser payout
141     function Payoutnextrefund ()public
142     {
143         //allocate p3d dividends to sacrifice if existing
144             uint256 Pot = Refundpot;
145             require(Pot > 0.1 ether);
146             Refundpot -= 0.1 ether;
147             RefundWaitingLine[NextInLine].transfer(0.1 ether);
148             NextInLine++;
149             //
150     }
151     //changevanity
152     function changevanity(string van , address masternode) public payable
153     {
154     require(msg.value >= 1  finney);
155     Vanity[msg.sender] = van;
156     uint256 amt = ETHtoP3Dbymasternode[masternode].add(msg.value);
157     ETHtoP3Dbymasternode[masternode] = 0;
158     if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
159     p3dContract.buy.value(amt)(masternode);
160     }
161     // Sac dep
162     modifier isValidOffer()
163     {
164         require(msg.value == OFFER_SIZE);
165         _;
166     }
167     
168     modifier canPayFromVault()
169     {
170         require(playerVault[msg.sender] >= OFFER_SIZE);
171         _;
172     }
173     
174     modifier hasEarnings()
175     {
176         require(playerVault[msg.sender] > 0);
177         _;
178     }
179     
180     modifier prepareStage()
181     {
182         //create a new stage if current has reached max amount of players
183         if(stages[numberOfStages - 1].numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
184            stages[numberOfStages] = Stage(0, 0, false );
185            numberOfStages++;
186         }
187         _;
188     }
189     
190     modifier isNewToStage()
191     {
192         require(stages[numberOfStages - 1].players[msg.sender] == false);
193         _;
194     }
195     
196     constructor()
197         public
198     {
199         stages[numberOfStages] = Stage(0, 0, false);
200         numberOfStages++;
201     }
202     
203     function() external payable {}
204     
205     function offerAsSacrifice(address MN)
206         external
207         payable
208         isValidOffer
209         prepareStage
210         isNewToStage
211     {
212         acceptOffer(MN);
213         
214         //try to choose a sacrifice in an already full stage (finalize a stage)
215         tryFinalizeStage();
216     }
217     
218     function offerAsSacrificeFromVault(address MN)
219         external
220         canPayFromVault
221         prepareStage
222         isNewToStage
223     {
224         playerVault[msg.sender] -= OFFER_SIZE;
225         
226         acceptOffer(MN);
227         
228         tryFinalizeStage();
229     }
230     
231     function withdraw()
232         external
233         hasEarnings
234     {
235         tryFinalizeStage();
236         
237         uint256 amount = playerVault[msg.sender];
238         playerVault[msg.sender] = 0;
239         
240         emit EarningsWithdrawn(msg.sender, amount); 
241         
242         msg.sender.transfer(amount);
243     }
244     
245     function myEarnings()
246         external
247         view
248         hasEarnings
249         returns(uint256)
250     {
251         return playerVault[msg.sender];
252     }
253     
254     function currentPlayers()
255         external
256         view
257         returns(uint256)
258     {
259         return stages[numberOfStages - 1].numberOfPlayers;
260     }
261     
262     function acceptOffer(address MN)
263         private
264     {
265         Stage storage currentStage = stages[numberOfStages - 1];
266         
267         assert(currentStage.numberOfPlayers < MAX_PLAYERS_PER_STAGE);
268         
269         address player = msg.sender;
270         
271         //add player to current stage
272         currentStage.slotXplayer[currentStage.numberOfPlayers] = player;
273         currentStage.numberOfPlayers++;
274         currentStage.players[player] = true;
275         currentStage.setMN[currentStage.numberOfPlayers] = MN;
276         emit SacrificeOffered(player);
277         
278         //add blocknumber to current stage when the last player is added
279         if(currentStage.numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
280             currentStage.blocknumber = block.number;
281         }
282         
283     }
284     
285     function tryFinalizeStage()
286         public
287     {
288         assert(numberOfStages >= numberOfFinalizedStages);
289         
290         //there are no stages to finalize
291         if(numberOfStages == numberOfFinalizedStages) {return;}
292         
293         Stage storage stageToFinalize = stages[numberOfFinalizedStages];
294         
295         assert(!stageToFinalize.finalized);
296         
297         //stage is not ready to be finalized
298         if(stageToFinalize.numberOfPlayers < MAX_PLAYERS_PER_STAGE) {return;}
299         
300         assert(stageToFinalize.blocknumber != 0);
301         
302         //check if blockhash can be determined
303         if(block.number - 256 <= stageToFinalize.blocknumber) {
304             //blocknumber of stage can not be equal to current block number -> blockhash() won't work
305             if(block.number == stageToFinalize.blocknumber) {return;}
306                 
307             //determine sacrifice
308             uint8 sacrificeSlot = uint8(blockhash(stageToFinalize.blocknumber)) % MAX_PLAYERS_PER_STAGE;
309             uint256 jackpot = uint256(blockhash(stageToFinalize.blocknumber)) % 1000;
310             address sacrifice = stageToFinalize.slotXplayer[sacrificeSlot];
311             Loser[numberOfFinalizedStages] = sacrifice;
312             emit SacrificeChosen(sacrifice);
313             
314             //allocate winnings to survivors
315             allocateSurvivorWinnings(sacrifice);
316             
317             //check jackpot win
318             if(jackpot == 777){
319                 sacrifice.transfer(Jackpot);
320                 emit JackpotWon ( sacrifice, Jackpot);
321                 Jackpot = 0;
322             }
323             
324             
325             //add sacrifice to refund waiting line
326             RefundWaitingLine[NextAtLineEnd] = sacrifice;
327             NextAtLineEnd++;
328             
329             //set eth to MN for buying P3D 
330             ETHtoP3Dbymasternode[stageToFinalize.setMN[1]] = ETHtoP3Dbymasternode[stageToFinalize.setMN[1]].add(0.005 ether);
331             ETHtoP3Dbymasternode[stageToFinalize.setMN[1]] = ETHtoP3Dbymasternode[stageToFinalize.setMN[2]].add(0.005 ether);
332             
333             //add 0.005 ether to Refundpot
334             Refundpot = Refundpot.add(0.005 ether);
335             //purchase p3d (using ref) deprecated
336             //p3dContract.buy.value(p3dPerStage)(address(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef));
337         } else {
338             invalidateStage(numberOfFinalizedStages);
339             
340             emit StageInvalidated(numberOfFinalizedStages);
341         }
342         //finalize stage
343         stageToFinalize.finalized = true;
344         numberOfFinalizedStages++;
345     }
346     
347     function allocateSurvivorWinnings(address sacrifice)
348         private
349     {
350         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
351             address survivor = stages[numberOfFinalizedStages].slotXplayer[i];
352             if(survivor != sacrifice) {
353                 playerVault[survivor] += winningsPerRound;
354             }
355         }
356     }
357     
358     function invalidateStage(uint256 stageIndex)
359         private
360     {
361         Stage storage stageToInvalidate = stages[stageIndex];
362         
363         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
364             address player = stageToInvalidate.slotXplayer[i];
365             playerVault[player] += OFFER_SIZE;
366         }
367     }
368 }
369 
370 interface HourglassInterface {
371     function buy(address _playerAddress) payable external returns(uint256);
372     function withdraw() external;
373     function myDividends(bool _includeReferralBonus) external view returns(uint256);
374     function balanceOf(address _playerAddress) external view returns(uint256);
375 }
376 interface SPASMInterface  {
377     function() payable external;
378     function disburse() external  payable;
379 }
380 // ----------------------------------------------------------------------------
381 // Safe maths
382 // ----------------------------------------------------------------------------
383 library SafeMath {
384     function add(uint a, uint b) internal pure returns (uint c) {
385         c = a + b;
386         require(c >= a);
387     }
388     function sub(uint a, uint b) internal pure returns (uint c) {
389         require(b <= a);
390         c = a - b;
391     }
392     function mul(uint a, uint b) internal pure returns (uint c) {
393         c = a * b;
394         require(a == 0 || c / a == b);
395     }
396     function div(uint a, uint b) internal pure returns (uint c) {
397         require(b > 0);
398         c = a / b;
399     }
400 }