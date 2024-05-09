1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 
44     function min(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a < b ? a : b;
46     }
47 }
48 contract CryptoMiningWarInterface {
49 	uint256 public roundNumber;
50     uint256 public deadline; 
51     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
52     function isMiningWarContract() external pure returns(bool) {}
53 }
54 contract CrystalAirdropGame {
55 	using SafeMath for uint256;
56 
57 	address public administrator;
58 	// mini game
59     uint256 private ROUND_TIME_MINING_WAR = 86400 * 7;
60     uint256 private BONUS_CRYSTAL = 5000000;
61     uint256 public TIME_DAY = 24 hours;
62 
63     address public miningWarAddress;
64     CryptoMiningWarInterface public MiningWar;
65     /** 
66     * @dev player information
67     */
68     mapping(address => Player) public players;
69     mapping(uint256 => Airdrop) public airdrops;
70    
71     struct Player {
72         uint256 miningWarRound;
73         uint256 noJoinAirdrop; 
74         uint256 lastDayJoin;
75     }
76     struct Airdrop {
77         uint256 day;
78         uint256 prizeCrystal;
79     }
80     event AirdropPrize(
81         address playerJoin,
82         uint256 crystalBonus,
83         uint256 noJoinAirdrop,
84         uint256 noDayStartMiningWar
85     );
86 
87     constructor() public {
88         administrator = msg.sender;
89         // set interface main contract
90         setMiningWarInterface(0x65c347702b66ff8f1a28cf9a9768487fbe97765f);
91 
92         initAirdrop();
93     }
94     function initAirdrop() private {
95         //                    day       prize crystals
96         airdrops[0] = Airdrop(1,            5000);   
97         airdrops[1] = Airdrop(2,            10000);   
98         airdrops[2] = Airdrop(3,            20000);   
99         airdrops[3] = Airdrop(4,            40000);   
100         airdrops[4] = Airdrop(5,            60000);   
101         airdrops[5] = Airdrop(6,            100000);   
102         airdrops[6] = Airdrop(7,            200000);   
103     }
104     /** 
105     * @dev MainContract used this function to verify game's contract
106     */
107     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
108     {
109     	_isContractMiniGame = true;
110     }
111     function isAirdropContract() public pure returns(bool)
112     {
113         return true;
114     }
115     function setAirdropPrize(uint256 idx, uint256 value) public 
116     {
117        require( administrator == msg.sender );
118        airdrops[idx].prizeCrystal = value; 
119     }
120      function setMiningWarInterface(address _addr) public 
121     {
122         require( administrator == msg.sender );
123         
124         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
125 
126         require(miningWarInterface.isMiningWarContract() == true);
127         
128         miningWarAddress = _addr;
129         
130         MiningWar = miningWarInterface;
131     }
132 
133     function setupMiniGame(uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public pure
134     {
135 
136     }
137 
138     function joinAirdrop() public 
139     {   
140         require(tx.origin == msg.sender);
141         require(MiningWar.deadline() > now);
142 
143         Player storage p = players[msg.sender];
144         
145         uint256 miningWarRound      = MiningWar.roundNumber();
146         uint256 timeEndMiningWar    = MiningWar.deadline() - now;
147         uint256 noDayEndMiningWar   = SafeMath.div(timeEndMiningWar, TIME_DAY);
148 
149         if (noDayEndMiningWar > 7) revert();
150 
151         uint256 noDayStartMiningWar = SafeMath.sub(7, noDayEndMiningWar);
152  
153         if (p.miningWarRound != miningWarRound) {
154             p.noJoinAirdrop = 1;
155             p.miningWarRound= miningWarRound;
156         } else if (p.lastDayJoin >= noDayStartMiningWar) {
157             revert();
158         } else {
159             p.noJoinAirdrop += 1;
160         }
161         p.lastDayJoin = noDayStartMiningWar;
162 
163         airdropPrize(msg.sender);
164     }
165 
166     function airdropPrize(address _addr) private
167     {
168        Player memory p = players[_addr];
169        
170        uint256 prizeCrystal = 0;
171        if (p.lastDayJoin > 0 && p.lastDayJoin <= 7)
172            prizeCrystal = airdrops[p.lastDayJoin - 1].prizeCrystal;
173        if (p.noJoinAirdrop >= 7) 
174            prizeCrystal = SafeMath.add(prizeCrystal, BONUS_CRYSTAL);  
175        if (prizeCrystal != 0)
176            MiningWar.addCrystal(_addr, prizeCrystal);
177 
178        emit AirdropPrize(_addr, prizeCrystal, p.noJoinAirdrop, p.lastDayJoin);
179     }
180     function getData(address _addr) public view returns(uint256 miningWarRound, uint256 noJoinAirdrop, uint256 lastDayJoin, uint256 nextTimeAirdropJoin)
181     {
182          Player memory p = players[_addr];
183 
184          miningWarRound = p.miningWarRound;
185          noJoinAirdrop  = p.noJoinAirdrop;
186          lastDayJoin    = p.lastDayJoin;
187          nextTimeAirdropJoin = getNextTimeAirdropJoin(_addr);
188 
189         if (miningWarRound != MiningWar.roundNumber()) {
190             noJoinAirdrop = 0;
191             lastDayJoin   = 0;
192         }   
193     }
194     function getNextCrystalReward(address _addr) public view returns(uint256)
195     {
196         Player memory p = players[_addr];
197         uint256 miningWarRound      = MiningWar.roundNumber();
198         uint256 timeStartMiningWar  = SafeMath.sub(MiningWar.deadline(), ROUND_TIME_MINING_WAR); 
199         uint256 timeEndMiningWar    = MiningWar.deadline() - now;
200         uint256 noDayEndMiningWar   = SafeMath.div(timeEndMiningWar, TIME_DAY);
201         uint256 noDayStartMiningWar = SafeMath.sub(7, noDayEndMiningWar);
202 
203         if (noDayStartMiningWar > 7) return 0;
204         if (p.lastDayJoin < noDayStartMiningWar) return airdrops[noDayStartMiningWar - 1].prizeCrystal; 
205         return airdrops[noDayStartMiningWar].prizeCrystal;
206     }
207     function getNextTimeAirdropJoin(address _addr) public view returns(uint256)
208     {
209         Player memory p = players[_addr];
210 
211         uint256 miningWarRound      = MiningWar.roundNumber();
212         uint256 timeStartMiningWar  = SafeMath.sub(MiningWar.deadline(), ROUND_TIME_MINING_WAR); 
213         uint256 timeEndMiningWar    = MiningWar.deadline() - now;
214         uint256 noDayEndMiningWar   = SafeMath.div(timeEndMiningWar, TIME_DAY);
215 
216         uint256 noDayStartMiningWar = SafeMath.sub(7, noDayEndMiningWar);
217 
218         if (p.miningWarRound != miningWarRound) return 0;
219 
220         if (p.lastDayJoin < noDayStartMiningWar) return 0;
221 
222         return SafeMath.add(SafeMath.mul(noDayStartMiningWar, TIME_DAY), timeStartMiningWar);
223     }
224 }