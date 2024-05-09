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
17         (3:5 for FIRST bet only, 2:5 for consecutive bets)
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
34     // Minimum/Maximum Bet (in ETHER) that can be placed: 1 ether - 10% of available Ether Winning Pool       
35     function GetMinimumBet_Ether() constant returns (uint256){ return 1;   }
36     function GetMaximumBet_Ether() constant returns (uint256){ return GetMaximumBet() / 1000000000000000000;  } 
37     function GetMinimumBet() returns (uint256) { return 1 ether; }   // Minimum Bet that can be placed: 1 ether       
38     function GetMaximumBet() returns (uint256) { return this.balance/10; }   // Maximum Bet that can be placed: 10% of available Ether Winning Pool        
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
49     *******************************************************************************************/
50     
51     function _api_PlaceBet () payable {
52     //function _api_PlaceBet (uint256 accessCode, bool modeA) payable {
53         //
54         // Note total transaction cost ~ 100-200K Gas    
55         // START Initial checks
56         // use Sha3 for increased API security (cannot be "converted back" to original accessCode) - prevents direct access
57         // if ( sha3( accessCode ) != 19498834600303040700126754596537880312193431075463488515213744382615666721600) throw; 
58         // @MC disabled access check for PoC, ToDo: enable for Prod release, and allow change of hash if compromised
59         
60         // Check if Bet amount is within limits 1 ether to 10% of winning pool (account) balance
61         if (msg.value < GetMinimumBet() || (msg.value + 1) > GetMaximumBet() ) throw; 
62         
63         // Only allow x games per block - to ensure outcome is as random as possible
64         uint256 cntBlockUsed = blockUsed[block.number];  
65         if (cntBlockUsed > maxGamesPerBlock) throw; 
66         blockUsed[block.number] = cntBlockUsed + 1; 
67           
68         gamesPlayed++;            // game counter
69         lastPlayer = msg.sender;  // remember last player, part of seed for random number generator
70         // END initial checks
71         
72         // START - Set winning odds
73         uint winnerOdds = 3;  // 3 out of 5 win (for first game)
74         uint totalPartition  = 5;  
75         
76         if (alreadyPlayed[msg.sender]){  // has user played before? then odds are 2:5, not 3:5
77             winnerOdds = 2; 
78         }
79         
80         alreadyPlayed[msg.sender] = true; // remember that user has already played for next time
81         
82         // expand partitions to % (minimizes rounding), calculate winning change in % (x out of 100)
83         winnerOdds = winnerOdds * 20;  // 3*20 = 60% winning chance, or 2*20 = 40% winning chance
84         totalPartition = totalPartition * 20;    // 5*20 = 100%
85         // END - Set winning odds
86         
87         // Create new random number
88         uint256 random = createRandomNumber(totalPartition); // creates a random number between 0 and 99
89 
90         // check if user won
91         if (random <= winnerOdds ){
92             if (!msg.sender.send(msg.value * 2)) // winner double
93                 throw; // roll back if there was an error
94         }
95         // GAME FINISHED.
96     }
97 
98 
99       ///////////////////////////////////////////////
100      // Random Number Generator
101     //////////////////////////////////////////////
102 
103     address lastPlayer;
104     uint256 private seed1;
105     uint256 private seed2;
106     uint256 private seed3;
107     uint256 private seed4;
108     uint256 private seed5;
109     uint256 private lastBlock;
110     uint256 private lastRandom;
111     uint256 private lastGas;
112     uint256 private customSeed;
113     
114     function createRandomNumber(uint maxnum) payable returns (uint256) {
115         uint cnt;
116         for (cnt = 0; cnt < lastRandom % 5; cnt++){lastBlock = lastBlock - block.timestamp;} // randomize gas
117         uint256 random = 
118                   block.difficulty + block.gaslimit + 
119                   block.timestamp + msg.gas + 
120                   msg.value + tx.gasprice + 
121                   seed1 + seed2 + seed3 + seed4 + seed5;
122         random = random + uint256(block.blockhash(block.number - (lastRandom+1))[cnt]) +
123                   (gamesPlayed*1234567890) * lastBlock + customSeed;
124         random = random + uint256(lastPlayer) +  uint256(sha3(msg.sender)[cnt]);
125         lastBlock = block.number;
126         seed5 = seed4; seed4 = seed3; seed3 = seed2;
127         seed2 = seed1; seed1 = (random / 43) + lastRandom; 
128         bytes32 randomsha = sha3(random);
129         lastRandom = (uint256(randomsha[cnt]) * maxnum) / 256;
130         
131         return lastRandom ;
132         
133     }
134     
135     
136     ///////////////////////////////////////////////
137     // Maintenance    ToDo: doc @MC
138     /////////////////////////////
139     uint256 public maxGamesPerBlock;  // Block limit
140     mapping ( uint256 => uint256 ) blockUsed;  // prevent more than X games per block; 
141                                                //
142     
143     function PPBC_API()  { // Constructor: ToDo: obfuscate
144         //initialize
145         gamesPlayed = 0;
146         paddyAdmin = msg.sender;
147         lastPlayer = msg.sender;
148         seed1 = 2; seed2 = 3; seed3 = 5; seed4 = 7; seed5 = 11;
149         lastBlock = 0;
150         customSeed = block.number;
151         maxGamesPerBlock = 3;
152     }
153     
154     modifier onlyOwner {
155         if (msg.sender != paddyAdmin) throw;
156         _;
157     }
158 
159     function _maint_withdrawFromPool (uint256 amt) onlyOwner{ // balance to stay below approved limit / comply with regulation
160             if (!paddyAdmin.send(amt)) throw;
161     }
162     
163     function () payable onlyOwner { // default function, used by PaddyAdmin to deposit into winning pool, only owner can do this
164     }
165     
166     function _maint_EndPromo () onlyOwner {
167          selfdestruct(paddyAdmin); 
168     }
169 
170     function _maint_setBlockLimit (uint256 n_limit) onlyOwner {
171          maxGamesPerBlock = n_limit;
172     }
173     
174     function _maint_setCustomSeed(uint256 newSeed) onlyOwner {
175         customSeed = newSeed;
176     }
177     
178     function _maint_updateOwner (address newOwner) onlyOwner {
179         paddyAdmin = newOwner;
180     }
181     
182 }