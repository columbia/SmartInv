1 // CryptoRabbit Source code
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /// @title A base contract to control ownership
7 /// @author cuilichen
8 contract OwnerBase {
9 
10     // The addresses of the accounts that can execute actions within each roles.
11     address public ceoAddress;
12     address public cfoAddress;
13     address public cooAddress;
14 
15     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
16     bool public paused = false;
17     
18     /// constructor
19     function OwnerBase() public {
20        ceoAddress = msg.sender;
21        cfoAddress = msg.sender;
22        cooAddress = msg.sender;
23     }
24 
25     /// @dev Access modifier for CEO-only functionality
26     modifier onlyCEO() {
27         require(msg.sender == ceoAddress);
28         _;
29     }
30 
31     /// @dev Access modifier for CFO-only functionality
32     modifier onlyCFO() {
33         require(msg.sender == cfoAddress);
34         _;
35     }
36     
37     /// @dev Access modifier for COO-only functionality
38     modifier onlyCOO() {
39         require(msg.sender == cooAddress);
40         _;
41     }
42 
43     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
44     /// @param _newCEO The address of the new CEO
45     function setCEO(address _newCEO) external onlyCEO {
46         require(_newCEO != address(0));
47 
48         ceoAddress = _newCEO;
49     }
50 
51 
52     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
53     /// @param _newCFO The address of the new COO
54     function setCFO(address _newCFO) external onlyCEO {
55         require(_newCFO != address(0));
56 
57         cfoAddress = _newCFO;
58     }
59     
60     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
61     /// @param _newCOO The address of the new COO
62     function setCOO(address _newCOO) external onlyCEO {
63         require(_newCOO != address(0));
64 
65         cooAddress = _newCOO;
66     }
67 
68     /// @dev Modifier to allow actions only when the contract IS NOT paused
69     modifier whenNotPaused() {
70         require(!paused);
71         _;
72     }
73 
74     /// @dev Modifier to allow actions only when the contract IS paused
75     modifier whenPaused {
76         require(paused);
77         _;
78     }
79 
80     /// @dev Called by any "C-level" role to pause the contract. Used only when
81     ///  a bug or exploit is detected and we need to limit damage.
82     function pause() external onlyCOO whenNotPaused {
83         paused = true;
84     }
85 
86     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
87     ///  one reason we may pause the contract is when CFO or COO accounts are
88     ///  compromised.
89     /// @notice This is public rather than external so it can be called by
90     ///  derived contracts.
91     function unpause() public onlyCOO whenPaused {
92         // can't unpause if contract was upgraded
93         paused = false;
94     }
95 }
96 
97 
98 
99 /**
100  * 
101  * @title Interface for contracts conforming to fighters camp
102  * @author cuilichen
103  */
104 contract FighterCamp {
105     
106     //
107     function isCamp() public pure returns (bool);
108     
109     // Required methods
110     function getFighter(uint _tokenId) external view returns (uint32);
111     
112 }
113 
114 
115 /// @title Base contract for combat
116 /// @author cuilichen
117 contract RabbitArena is OwnerBase {
118     
119 	event FightersReady(uint32 season);
120     event SeasonWinner(uint32 season, uint winnerID);
121     
122 	
123     struct Fighter {
124         uint tokenID;
125         uint32 strength;
126     }
127 	
128     //where are fighters from
129     FighterCamp public theCamp; 
130 	
131 	
132 	mapping (uint => Fighter) soldiers;
133 	
134 	
135 	uint32[] public seasons;
136     
137     
138 	uint32 public matchDay;
139 	
140 	
141 	/// @dev constructor
142 	function RabbitArena(address _camp) public {
143 		FighterCamp tmp = FighterCamp(_camp);
144         require(tmp.isCamp());
145         theCamp = tmp;
146 	}
147     
148     
149     
150     /// @dev set camp for this contract
151     function setBaseInfo(address _camp) external onlyCOO {
152         FighterCamp tmp = FighterCamp(_camp);
153         require(tmp.isCamp());
154         theCamp = tmp;
155     }
156 	
157 	
158 	/// @dev release storaged data, to save gas fee.
159 	function releaseOldData() internal {
160 		for (uint i = 0; i < seasons.length; i++) {
161             uint _season = seasons[i];
162 			for (uint j = 0; j < 8; j++) {
163 				uint key = _season * 1000 + j;
164 				delete soldiers[key];
165 			}
166         }
167 		delete seasons;// seasons.length --> 0
168 	}
169 
170     
171     /// @dev set 8 fighters for a season, prepare for combat.
172     function setFighters(uint32 _today, uint32 _season, uint[] _tokenIDs) external onlyCOO {
173 		require(_tokenIDs.length == 8);
174 		
175 		if (matchDay != _today) {
176 			releaseOldData();
177 			matchDay = _today;
178 		}
179 		seasons.push(_season);// a new season
180 		
181         //record fighter datas
182         for(uint i = 0; i < 8; i++) {
183             uint tmpID = _tokenIDs[i];
184             
185             Fighter memory soldier = Fighter({
186                 tokenID: tmpID,
187 				strength: theCamp.getFighter(tmpID)
188             });
189 			
190 			uint key = _season * 1000 + i;
191             soldiers[key] = soldier;
192         }
193         
194         //fire the event
195         emit FightersReady(_season);
196     }
197     
198     
199     /// @dev get fighter property
200     function getFighterInfo(uint32 _season, uint32 _index) external view returns (
201         uint outTokenID,
202         uint32 outStrength
203     ) {
204 		require(_index < 8);
205 		uint key = _season * 1000 + _index;
206         
207         Fighter storage soldier = soldiers[key];
208 		require(soldier.strength > 0);
209         
210         outTokenID = soldier.tokenID;
211         outStrength = soldier.strength;
212     }
213     
214     
215     /// @dev process a combat
216     /// @param _season The round for combat
217     /// @param _seed The seed from the users
218     function processOneCombat(uint32 _season, uint32 _seed) external onlyCOO 
219     {
220         uint[] memory powers = new uint[](8);
221         
222 		uint sumPower = 0;
223         uint i = 0;
224 		uint key = 0;
225         for (i = 0; i < 8; i++) {
226 			key = _season * 1000 + i;
227             Fighter storage soldier = soldiers[key];
228             powers[i] = soldier.strength;
229             sumPower = sumPower + soldier.strength;
230         }
231         
232         uint sumValue = 0;
233 		uint tmpPower = 0;
234         for (i = 0; i < 8; i++) {
235             tmpPower = powers[i] ** 5;//
236             sumValue += tmpPower;
237             powers[i] = sumValue;
238         }
239         uint singleDeno = sumPower ** 5;
240         uint randomVal = _getRandom(_seed);
241         
242         uint winner = 0;
243         uint shoot = sumValue * randomVal * 10000000000 / singleDeno / 0xffffffff;
244         for (i = 0; i < 8; i++) {
245             tmpPower = powers[i];
246             if (shoot <= tmpPower * 10000000000 / singleDeno) {
247                 winner = i;
248                 break;
249             }
250         }
251 		
252 		key = _season * 1000 + winner;
253 		Fighter storage tmp = soldiers[key];        
254         emit SeasonWinner(_season, tmp.tokenID);
255     }
256     
257     
258     /// @dev give a seed and get a random value between 0 and 0xffffffff.
259     /// @param _seed an uint32 value from users
260     function _getRandom(uint32 _seed) pure internal returns(uint32) {
261         return uint32(keccak256(_seed));
262     }
263 }