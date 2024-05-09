1 pragma solidity ^0.4.24;
2 
3 contract Sacrific3d {
4     
5     struct Stage {
6         uint8 numberOfPlayers;
7         uint256 blocknumber;
8         bool finalized;
9         mapping (uint8 => address) slotXplayer;
10         mapping (address => bool) players;
11     }
12     
13     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
14    
15     //a small part of every winners share of the sacrificed players offer is used to purchase p3d instead
16     uint256 constant private P3D_SHARE = 0.005 ether;
17     
18     uint8 constant public MAX_PLAYERS_PER_STAGE = 5;
19     uint256 constant public OFFER_SIZE = 0.1 ether;
20     
21     uint256 private p3dPerStage = P3D_SHARE * (MAX_PLAYERS_PER_STAGE - 1);
22     //not sacrificed players receive their offer back and also a share of the sacrificed players offer 
23     uint256 public winningsPerRound = OFFER_SIZE + OFFER_SIZE / (MAX_PLAYERS_PER_STAGE - 1) - P3D_SHARE;
24     
25     mapping(address => uint256) private playerVault;
26     mapping(uint256 => Stage) private stages;
27     uint256 private numberOfFinalizedStages;
28     
29     uint256 public numberOfStages;
30     
31     event SacrificeOffered(address indexed player);
32     event SacrificeChosen(address indexed sarifice);
33     event EarningsWithdrawn(address indexed player, uint256 indexed amount);
34     event StageInvalidated(uint256 indexed stage);
35     
36     modifier isValidOffer()
37     {
38         require(msg.value == OFFER_SIZE);
39         _;
40     }
41     
42     modifier canPayFromVault()
43     {
44         require(playerVault[msg.sender] >= OFFER_SIZE);
45         _;
46     }
47     
48     modifier hasEarnings()
49     {
50         require(playerVault[msg.sender] > 0);
51         _;
52     }
53     
54     modifier prepareStage()
55     {
56         //create a new stage if current has reached max amount of players
57         if(stages[numberOfStages - 1].numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
58            stages[numberOfStages] = Stage(0, 0, false);
59            numberOfStages++;
60         }
61         _;
62     }
63     
64     modifier isNewToStage()
65     {
66         require(stages[numberOfStages - 1].players[msg.sender] == false);
67         _;
68     }
69     
70     constructor()
71         public
72     {
73         stages[numberOfStages] = Stage(0, 0, false);
74         numberOfStages++;
75     }
76     
77     function() external payable {}
78     
79     function offerAsSacrifice()
80         external
81         payable
82         isValidOffer
83         prepareStage
84         isNewToStage
85     {
86         acceptOffer();
87         
88         //try to choose a sacrifice in an already full stage (finalize a stage)
89         tryFinalizeStage();
90     }
91     
92     function offerAsSacrificeFromVault()
93         external
94         canPayFromVault
95         prepareStage
96         isNewToStage
97     {
98         playerVault[msg.sender] -= OFFER_SIZE;
99         
100         acceptOffer();
101         
102         tryFinalizeStage();
103     }
104     
105     function withdraw()
106         external
107         hasEarnings
108     {
109         tryFinalizeStage();
110         
111         uint256 amount = playerVault[msg.sender];
112         playerVault[msg.sender] = 0;
113         
114         emit EarningsWithdrawn(msg.sender, amount); 
115         
116         msg.sender.transfer(amount);
117     }
118     
119     function myEarnings()
120         external
121         view
122         hasEarnings
123         returns(uint256)
124     {
125         return playerVault[msg.sender];
126     }
127     
128     function currentPlayers()
129         external
130         view
131         returns(uint256)
132     {
133         return stages[numberOfStages - 1].numberOfPlayers;
134     }
135     
136     function acceptOffer()
137         private
138     {
139         Stage storage currentStage = stages[numberOfStages - 1];
140         
141         assert(currentStage.numberOfPlayers < MAX_PLAYERS_PER_STAGE);
142         
143         address player = msg.sender;
144         
145         //add player to current stage
146         currentStage.slotXplayer[currentStage.numberOfPlayers] = player;
147         currentStage.numberOfPlayers++;
148         currentStage.players[player] = true;
149         
150         emit SacrificeOffered(player);
151         
152         //add blocknumber to current stage when the last player is added
153         if(currentStage.numberOfPlayers == MAX_PLAYERS_PER_STAGE) {
154             currentStage.blocknumber = block.number;
155         }
156     }
157     
158     function tryFinalizeStage()
159         private
160     {
161         assert(numberOfStages >= numberOfFinalizedStages);
162         
163         //there are no stages to finalize
164         if(numberOfStages == numberOfFinalizedStages) {return;}
165         
166         Stage storage stageToFinalize = stages[numberOfFinalizedStages];
167         
168         assert(!stageToFinalize.finalized);
169         
170         //stage is not ready to be finalized
171         if(stageToFinalize.numberOfPlayers < MAX_PLAYERS_PER_STAGE) {return;}
172         
173         assert(stageToFinalize.blocknumber != 0);
174         
175         //check if blockhash can be determined
176         if(block.number - 256 <= stageToFinalize.blocknumber) {
177             //blocknumber of stage can not be equal to current block number -> blockhash() won't work
178             if(block.number == stageToFinalize.blocknumber) {return;}
179                 
180             //determine sacrifice
181             uint8 sacrificeSlot = uint8(blockhash(stageToFinalize.blocknumber)) % MAX_PLAYERS_PER_STAGE;
182             address sacrifice = stageToFinalize.slotXplayer[sacrificeSlot];
183             
184             emit SacrificeChosen(sacrifice);
185             
186             //allocate winnings to survivors
187             allocateSurvivorWinnings(sacrifice);
188             
189             //allocate p3d dividends to sacrifice if existing
190             uint256 dividends = p3dContract.myDividends(true);
191             if(dividends > 0) {
192                 p3dContract.withdraw();
193                 playerVault[sacrifice]+= dividends;
194             }
195             
196             //purchase p3d (using ref)
197             p3dContract.buy.value(p3dPerStage)(address(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef));
198         } else {
199             invalidateStage(numberOfFinalizedStages);
200             
201             emit StageInvalidated(numberOfFinalizedStages);
202         }
203         //finalize stage
204         stageToFinalize.finalized = true;
205         numberOfFinalizedStages++;
206     }
207     
208     function allocateSurvivorWinnings(address sacrifice)
209         private
210     {
211         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
212             address survivor = stages[numberOfFinalizedStages].slotXplayer[i];
213             if(survivor != sacrifice) {
214                 playerVault[survivor] += winningsPerRound;
215             }
216         }
217     }
218     
219     function invalidateStage(uint256 stageIndex)
220         private
221     {
222         Stage storage stageToInvalidate = stages[stageIndex];
223         
224         for (uint8 i = 0; i < MAX_PLAYERS_PER_STAGE; i++) {
225             address player = stageToInvalidate.slotXplayer[i];
226             playerVault[player] += OFFER_SIZE;
227         }
228     }
229 }
230 
231 interface HourglassInterface {
232     function buy(address _playerAddress) payable external returns(uint256);
233     function withdraw() external;
234     function myDividends(bool _includeReferralBonus) external view returns(uint256);
235 }