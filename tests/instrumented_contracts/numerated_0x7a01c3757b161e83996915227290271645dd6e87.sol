1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function min(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 contract CryptoEngineerOldInterface {
55     address public gameSponsor;
56     uint256 public gameSponsorPrice;
57     
58     function getBoosterData(uint256 /*idx*/) public view returns (address /*_owner*/,uint256 /*_boostRate*/, uint256 /*_basePrice*/) {}
59     function calculateCurrentVirus(address /*_addr*/) external view returns(uint256 /*_currentVirus*/) {}
60     function getPlayerData(address /*_addr*/) external view returns(uint256 /*_engineerRoundNumber*/, uint256 /*_virusNumber*/, uint256 /*_virusDefence*/, uint256 /*_research*/, uint256 /*_researchPerDay*/, uint256 /*_lastUpdateTime*/, uint256[8] /*_engineersCount*/, uint256 /*_nextTimeAtk*/, uint256 /*_endTimeUnequalledDef*/) {}
61 }
62 interface CryptoArenaOldInterface {
63     function getData(address _addr) 
64     external
65     view
66     returns(
67         uint256 /*_virusDef*/,
68         uint256 /*_nextTimeAtk*/,
69         uint256 /*_endTimeUnequalledDef*/,
70         bool    /*_canAtk*/,
71         // engineer
72         uint256 /*_currentVirus*/, 
73         // mingin war
74         uint256 /*_currentCrystals*/
75     );
76 }
77 
78 contract CryptoEngineerNewInterface {
79     mapping(uint256 => EngineerData) public engineers;
80      struct EngineerData {
81             uint256 basePrice;
82             uint256 baseETH;
83             uint256 baseResearch;
84             uint256 limit;
85      }
86 
87     function setBoostData(uint256 /*idx*/, address /*owner*/, uint256 /*boostRate*/, uint256 /*basePrice*/ ) external pure {}
88     function setPlayerEngineersCount( address /*_addr*/, uint256 /*idx*/, uint256 /*_value*/ ) external pure {}
89     function setGameSponsorInfo( address /*_addr*/, uint256 /*_value*/ ) external pure {}
90     function setPlayerResearch( address /*_addr*/, uint256 /*_value*/ ) external pure {}
91     function setPlayerVirusNumber( address /*_addr*/, uint256 /*_value*/ ) external pure {}
92     function setPlayerLastUpdateTime( address /*_addr*/) external pure {}
93 }
94 interface CryptoArenaNewInterface {
95     function setPlayerVirusDef(address /*_addr*/, uint256 /*_value*/) external pure; 
96 }
97 contract CryptoLoadEngineerOldData {
98     // engineer info
99 	address public administrator;
100     bool public loaded;
101 
102     mapping(address => bool) public playersLoadOldData;
103    
104     CryptoEngineerNewInterface public EngineerNew;
105     CryptoEngineerOldInterface public EngineerOld;    
106     CryptoArenaNewInterface    public ArenaNew;
107     CryptoArenaOldInterface    public ArenaOld;
108 
109     modifier isAdministrator()
110     {
111         require(msg.sender == administrator);
112         _;
113     }
114 
115     //--------------------------------------------------------------------------
116     // INIT CONTRACT 
117     //--------------------------------------------------------------------------
118     constructor() public {
119         administrator = msg.sender;
120         // set interface main contract
121        EngineerNew = CryptoEngineerNewInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);
122        EngineerOld = CryptoEngineerOldInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
123        ArenaNew    = CryptoArenaNewInterface(0x77c9acc811e4cf4b51dc3a3e05dc5d62fa887767);
124        ArenaOld    = CryptoArenaOldInterface(0xce6c5ef2ed8f6171331830c018900171dcbd65ac);
125 
126     }
127 
128     function () public payable
129     {
130     }
131     /**
132         * @dev MainContract used this function to verify game's contract
133         */
134         function isContractMiniGame() public pure returns(bool _isContractMiniGame)
135         {
136         	_isContractMiniGame = true;
137         }
138     //@dev use this function in case of bug
139     function upgrade(address addr) public isAdministrator
140     {
141         selfdestruct(addr);
142     }
143     function loadEngineerOldData() public isAdministrator 
144     {
145         require(loaded == false);
146         loaded = true;
147         address gameSponsor      = EngineerOld.gameSponsor();
148         uint256 gameSponsorPrice = EngineerOld.gameSponsorPrice();
149         EngineerNew.setGameSponsorInfo(gameSponsor, gameSponsorPrice);
150         for(uint256 idx = 0; idx < 5; idx++) {
151             mergeBoostData(idx);
152         }
153     }
154     function mergeBoostData(uint256 idx) private
155     {
156         address owner;
157         uint256 boostRate;
158         uint256 basePrice;
159         (owner, boostRate, basePrice) = EngineerOld.getBoosterData(idx);
160 
161         if (owner != 0x0) EngineerNew.setBoostData(idx, owner, boostRate, basePrice);
162     }
163     function loadOldData() public 
164     {
165         require(tx.origin == msg.sender);
166         require(playersLoadOldData[msg.sender] == false);
167 
168         playersLoadOldData[msg.sender] = true;
169 
170         uint256[8] memory engineersCount; 
171         uint256 virusDef;
172         uint256 researchPerDay;
173         
174         uint256 virusNumber = EngineerOld.calculateCurrentVirus(msg.sender);
175         // /function getPlayerData(address /*_addr*/) external view returns(uint256 /*_engineerRoundNumber*/, uint256 /*_virusNumber*/, uint256 /*_virusDefence*/, uint256 /*_research*/, uint256 /*_researchPerDay*/, uint256 /*_lastUpdateTime*/, uint256[8] /*_engineersCount*/, uint256 /*_nextTimeAtk*/, uint256 /*_endTimeUnequalledDef*/) 
176         (, , , , researchPerDay, , engineersCount, , ) = EngineerOld.getPlayerData(msg.sender);
177 
178         (virusDef, , , , , ) = ArenaOld.getData(msg.sender);
179 
180         virusNumber = SafeMath.sub(virusNumber, SafeMath.mul(researchPerDay, 432000));
181         uint256 research = 0;
182         uint256 baseResearch = 0;
183 
184         for (uint256 idx = 0; idx < 8; idx++) {
185             if (engineersCount[idx] > 0) {
186                 (, , baseResearch, ) = EngineerNew.engineers(idx);
187                 EngineerNew.setPlayerEngineersCount(msg.sender, idx, engineersCount[idx]);
188                 research = SafeMath.add(research, SafeMath.mul(engineersCount[idx], baseResearch));
189             }    
190         }
191         EngineerNew.setPlayerLastUpdateTime(msg.sender);
192         if (research > 0)    EngineerNew.setPlayerResearch(msg.sender, research);
193         
194         if (virusNumber > 0) EngineerNew.setPlayerVirusNumber(msg.sender, virusNumber);
195 
196         if (virusDef > 0)    ArenaNew.setPlayerVirusDef(msg.sender, virusDef);
197     }
198 
199 }