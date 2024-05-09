1 pragma solidity ^0.4.5;
2 
3 contract PPBC_API {
4 
5    /*******************************************************************************
6         PADDYPOWER.BLOCKCHAIN Promo Concept/Proposal, RFP Response / PoC
7         Module PPBC_API - back-end module
8         
9         [private API],  v1.22, 2016 11 27 
10         $Id: add rcs tag $
11         
12         vendor presentation/  @TowerRoom, 12/12/16 10am
13         
14         @MC/KC - Refer to instructions at PP Tech Vendor Portal
15         
16         Abstract: Blockchain Contract API Demo, providing access to 3:5 and 2:5 betting odds 
17         (3:5 for first bet, 2:5 for consecutive bets)
18         
19    ********************************************************************************/
20 
21    // Do not invoke contract directly (API code protected), only via main PPBC contract
22    //       ToDo: protect API with passcode/hash
23 
24     // declare variables
25     address paddyAdmin;          // contract owner          
26     uint256 public gamesPlayed;  // Game Counter
27     
28     mapping ( address => bool ) alreadyPlayed; // Ensure every user can only play ONCE using the 3:5 odds
29                                                // to prevent abuse of benef. odds.
30                                                // Consecutive games from the same account only run at 2:5 odds.
31 
32     /* GetMinimumBet_ether()  ToDo: add doc @MC*/
33     /* GetMaximumBet_ether()  ToDo: add doc @MC*/
34     // Minimum/Maximum Bet (in ETHER) that can be placed: 1%-10% of available Ether Winning Pool       
35     function GetMinimumBet_ether() constant returns (uint256){ return GetMinimumBet() / 1000000000000000000;   }
36     function GetMaximumBet_ether() constant returns (uint256){ return GetMaximumBet() / 1000000000000000000;  } 
37     function GetMinimumBet() returns (uint256) {return this.balance/100;}   // Minimum Bet that can be placed: 1% of available Ether Winning Pool       
38     function GetMaximumBet() returns (uint256) {return this.balance/10;}   // Maximum Bet that can be placed: 10% of available Ether Winning Pool        
39 
40     /* PlaceBet using Access Code, and Mode parameter */
41     /********************************************************************
42         First game for any account will run at 3:5 odds (double win).
43         Consecutive  game for any account will run at 2:5 odds (double win).
44 
45         Cannot be invoked directly, only via PaddyPowerPromo contract     MC
46         
47         Parameters:
48         - Access Code is SHA3 hashed code, provided by PaddyPowerPromo contract (prevents direct call).
49         - modeA selects Lower vs. Upper number range (same odds)
50     *******************************************************************************************/
51     
52     function _api_PlaceBet (bool modeA) payable{
53     //function _api_PlaceBet (uint256 accessCode, bool modeA) payable returns (uint256){
54         //
55         // Note total transaction cost ~ 100-200K Gas    
56         // START Initial checks
57         // use Sha3 for increased API security (cannot be "converted back" to original accessCode) - prevents direct access
58         // if ( sha3( accessCode ) != 19498834600303040700126754596537880312193431075463488515213744382615666721600) throw; 
59         // @MC disabled access check for PoC, ToDo: enable for Prod release, and allow change of hash if compromised
60         
61         // Check if Bet amount is within limits 1-10% of winning pool (account) balance
62         if (msg.value < GetMinimumBet() || msg.value > GetMaximumBet() ) throw; 
63         
64         // Only allow x games per block - to ensure outcome is as random as possible
65         uint256 cntBlockUsed = blockUsed[block.number];  
66         if (cntBlockUsed > maxGamesPerBlock) throw; 
67         blockUsed[block.number] = cntBlockUsed + 1; 
68           
69         gamesPlayed++;            // game counter
70         lastPlayer = msg.sender;  // remember last player, part of seed for random number generator
71         // END initial checks
72         
73         // START - Set winning odds
74         uint winnerOdds = 3;  // 3 out of 5 win (for first game)
75         uint totalPartition  = 5;  
76         
77         if (alreadyPlayed[msg.sender]){  // has user played before? then odds are 2:5, not 3:5
78             winnerOdds = 2; 
79         }
80         
81         alreadyPlayed[msg.sender] = true; // remember that user has already played for next time
82         
83         // expand partitions to % (minimizes rounding), calculate winning change in % (x out of 100)
84         winnerOdds = winnerOdds * 20;  // 3*20 = 60% winning chance, or 2*20 = 40% winning chance
85         totalPartition = totalPartition * 20;    // 5*20 = 100%
86         // END - Set winning odds
87         
88         // Create new random number
89         uint256 random = createRandomNumber(totalPartition); // creates a random number between 0 and 99
90         bool winner = true;
91         
92         // Depending on mode, user wins if numbers are in the lower range or higher range.
93         if (modeA){  // Mode A (default) is: lower numbers win,  0-60, or 0-40, depending on odds
94             if (random > winnerOdds ) winner = false;
95         }
96         else {   // Mode B is: higer numbers win 40-100, or 60-100, depending on odds
97             if (random < (100 - winnerOdds) ) winner = false;
98         }
99 
100         // Pay winner (2 * bet amount)
101         if (winner){
102             if (!msg.sender.send(msg.value * 2)) // winner double
103                 throw; // roll back if there was an error
104         }
105         // GAME FINISHED.
106     }
107 
108 
109       ///////////////////////////////////////////////
110      // Random Number Generator
111     //////////////////////////////////////////////
112 
113     address lastPlayer;
114     uint256 private seed1;
115     uint256 private seed2;
116     uint256 private seed3;
117     uint256 private seed4;
118     uint256 private seed5;
119     uint256 private lastBlock;
120     uint256 private lastRandom;
121     uint256 private lastGas;
122     uint256 private customSeed;
123     
124     function createRandomNumber(uint maxnum) returns (uint256) {
125         uint cnt;
126         for (cnt = 0; cnt < lastRandom % 5; cnt++){lastBlock = lastBlock - block.timestamp;} // randomize gas
127         uint256 random = 
128                   block.difficulty + block.gaslimit + 
129                   block.timestamp + msg.gas + 
130                   msg.value + tx.gasprice + 
131                   seed1 + seed2 + seed3 + seed4 + seed5;
132         random = random + uint256(block.blockhash(block.number - (lastRandom+1))[cnt]) +
133                   (gamesPlayed*1234567890) * lastBlock + customSeed;
134         random = random + uint256(lastPlayer) +  uint256(sha3(msg.sender)[cnt]);
135         lastBlock = block.number;
136         seed5 = seed4; seed4 = seed3; seed3 = seed2;
137         seed2 = seed1; seed1 = (random / 43) + lastRandom; 
138         bytes32 randomsha = sha3(random);
139         lastRandom = (uint256(randomsha[cnt]) * maxnum) / 256;
140         
141         return lastRandom ;
142         
143     }
144     
145     
146     ///////////////////////////////////////////////
147     // Maintenance    ToDo: doc @MC
148     /////////////////////////////
149     uint256 public maxGamesPerBlock;  // Block limit
150     mapping ( uint256 => uint256 ) blockUsed;  // prevent more than 2 games per block; 
151                                                //
152     
153     function PPBC_API()  { // Constructor: ToDo: obfuscate
154         //initialize
155         gamesPlayed = 0;
156         paddyAdmin = msg.sender;
157         lastPlayer = msg.sender;
158         seed1 = 2; seed2 = 3; seed3 = 5; seed4 = 7; seed5 = 11;
159         lastBlock = 0;
160         customSeed = block.number;
161         maxGamesPerBlock = 3;
162     }
163     
164     modifier onlyOwner {
165         if (msg.sender != paddyAdmin) throw;
166         _;
167     }
168 
169     function _maint_withdrawFromPool (uint256 amt) onlyOwner{ // balance to stay below approved limit / comply with regulation
170             if (!paddyAdmin.send(amt)) throw;
171     }
172     
173     function _maint_EndPromo () onlyOwner {
174          selfdestruct(paddyAdmin); 
175     }
176 
177     function _maint_setBlockLimit (uint256 n_limit) onlyOwner {
178          maxGamesPerBlock = n_limit;
179     }
180     
181     function _maint_setCustomSeed(uint256 newSeed) onlyOwner {
182         customSeed = newSeed;
183     }
184     
185     function _maint_updateOwner (address newOwner) onlyOwner {
186         paddyAdmin = newOwner;
187     }
188     
189     function () payable {} // Used by PaddyPower Admin to load Pool
190     
191 }