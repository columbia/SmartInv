1 pragma solidity ^0.4.17;
2 
3 contract SafeMath {
4     function safeAdd(uint x, uint y) pure internal returns(uint) {
5       uint z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint x, uint y) pure internal returns(uint) {
11       assert(x >= y);
12       uint z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint x, uint y) pure internal returns(uint) {
17       uint z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21     
22      
23 
24     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
25         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
26         return uint8(genNum % (maxRandom - min + 1)+min);
27     }
28 }
29 
30 contract Enums {
31     enum ResultCode {
32         SUCCESS,
33         ERROR_CLASS_NOT_FOUND,
34         ERROR_LOW_BALANCE,
35         ERROR_SEND_FAIL,
36         ERROR_NOT_OWNER,
37         ERROR_NOT_ENOUGH_MONEY,
38         ERROR_INVALID_AMOUNT
39     }
40 
41     enum AngelAura { 
42         Blue, 
43         Yellow, 
44         Purple, 
45         Orange, 
46         Red, 
47         Green 
48     }
49 }
50 contract AccessControl {
51     address public creatorAddress;
52     uint16 public totalSeraphims = 0;
53     mapping (address => bool) public seraphims;
54 
55     bool public isMaintenanceMode = true;
56  
57     modifier onlyCREATOR() {
58         require(msg.sender == creatorAddress);
59         _;
60     }
61 
62     modifier onlySERAPHIM() {
63         require(seraphims[msg.sender] == true);
64         _;
65     }
66     
67     modifier isContractActive {
68         require(!isMaintenanceMode);
69         _;
70     }
71     
72     // Constructor
73     function AccessControl() public {
74         creatorAddress = msg.sender;
75     }
76     
77 
78     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
79         if (seraphims[_newSeraphim] == false) {
80             seraphims[_newSeraphim] = true;
81             totalSeraphims += 1;
82         }
83     }
84     
85     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
86         if (seraphims[_oldSeraphim] == true) {
87             seraphims[_oldSeraphim] = false;
88             totalSeraphims -= 1;
89         }
90     }
91 
92     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
93         isMaintenanceMode = _isMaintaining;
94     }
95 
96   
97 } 
98 
99 contract IAngelCardData is AccessControl, Enums {
100     uint8 public totalAngelCardSeries;
101     uint64 public totalAngels;
102 
103     
104     // write
105     // angels
106     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
107     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
108     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
109     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
110     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
111     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
112     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
113     function addAngelIdMapping(address _owner, uint64 _angelId) private;
114     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
115     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
116     function updateAngelLock (uint64 _angelId, bool newValue) public;
117     function removeCreator() onlyCREATOR external;
118 
119     // read
120     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
121     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
122     function getOwnerAngelCount(address _owner) constant public returns(uint);
123     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
124     function getTotalAngelCardSeries() constant public returns (uint8);
125     function getTotalAngels() constant public returns (uint64);
126     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
127 }
128 
129 contract ISponsoredLeaderboardData is AccessControl {
130 
131   
132     uint16 public totalLeaderboards;
133     
134     //The reserved balance is the total balance outstanding on all open leaderboards. 
135     //We keep track of this figure to prevent the developers from pulling out money currently pledged
136     uint public contractReservedBalance;
137     
138 
139     function setMinMaxDays(uint8 _minDays, uint8 _maxDays) external ;
140         function openLeaderboard(uint8 numDays, string message) external payable ;
141         function closeLeaderboard(uint16 leaderboardId) onlySERAPHIM external;
142         
143         function setMedalsClaimed(uint16 leaderboardId) onlySERAPHIM external ;
144     function withdrawEther() onlyCREATOR external;
145   function getTeamFromLeaderboard(uint16 leaderboardId, uint8 rank) public constant returns (uint64 angelId, uint64 petId, uint64 accessoryId) ;
146     
147     function getLeaderboard(uint16 id) public constant returns (uint startTime, uint endTime, bool isLive, address sponsor, uint prize, uint8 numTeams, string message, bool medalsClaimed);
148       function newTeamOnEnd(uint16 leaderboardId, uint64 angelId, uint64 petId, uint64 accessoryId) onlySERAPHIM external;
149        function switchRankings (uint16 leaderboardId, uint8 spot,uint64 angel1ID, uint64 pet1ID, uint64 accessory1ID,uint64 angel2ID,uint64 pet2ID,uint64 accessory2ID) onlySERAPHIM external;
150        function verifyPosition(uint16 leaderboardId, uint8 spot, uint64 angelID) external constant returns (bool); 
151         function angelOnLeaderboards(uint64 angelID) external constant returns (bool);
152          function petOnLeaderboards(uint64 petID) external constant returns (bool);
153          function accessoryOnLeaderboards(uint64 accessoryID) external constant returns (bool) ;
154     function safeMult(uint x, uint y) pure internal returns(uint) ;
155      function SafeDiv(uint256 a, uint256 b) internal pure returns (uint256) ;
156     function getTotalLeaderboards() public constant returns (uint16);
157       
158   
159         
160    
161         
162         
163         
164    
165       
166         
167    
168 }
169 contract IMedalData is AccessControl {
170   
171     modifier onlyOwnerOf(uint256 _tokenId) {
172     require(ownerOf(_tokenId) == msg.sender);
173     _;
174   }
175    
176 function totalSupply() public view returns (uint256);
177 function setMaxTokenNumbers()  onlyCREATOR external;
178 function balanceOf(address _owner) public view returns (uint256);
179 function tokensOf(address _owner) public view returns (uint256[]) ;
180 function ownerOf(uint256 _tokenId) public view returns (address);
181 function approvedFor(uint256 _tokenId) public view returns (address) ;
182 function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
183 function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
184 function takeOwnership(uint256 _tokenId) public;
185 function _createMedal(address _to, uint8 _seriesID) onlySERAPHIM public ;
186 function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32);
187 function getMedalType (uint256 _tokenId) public constant returns (uint8);
188 function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external;
189 function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) ;
190 function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal;
191 function clearApproval(address _owner, uint256 _tokenId) private;
192 function addToken(address _to, uint256 _tokenId) private ;
193 function removeToken(address _from, uint256 _tokenId) private;
194 }
195 
196 //INSTURCTIONS: You can access this contract through our webUI at angelbattles.com (preferred)
197 //You can also access this contract directly by sending a transaction the the leaderboardId you wish to claim medals for
198 //Variable names are self explanatory, but contact us if you have any questions. 
199 
200 contract ClaimSponsoredMedals is AccessControl, SafeMath  {
201     // Addresses for other contracts MedalClaim interacts with. 
202     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
203     address public medalDataContract =  0x33A104dCBEd81961701900c06fD14587C908EAa3;
204     address public sponsoredLeaderboardDataContract = 0xAbe64ec568AeB065D0445B9D76F511A7B5eA2d7f;
205     
206     // events
207      event EventMedalSuccessful(address owner,uint64 Medal);
208   
209 
210 
211 
212     // write functions
213     function DataContacts(address _angelCardDataContract,  address _medalDataContract, address _sponsoredLeaderboardDataContract) onlyCREATOR external {
214         angelCardDataContract = _angelCardDataContract;
215         medalDataContract = _medalDataContract;
216         sponsoredLeaderboardDataContract = _sponsoredLeaderboardDataContract;
217     }
218        
219 
220 
221 
222 function claimMedals (uint16 leaderboardId) public  {
223     
224     //Function can be called by anyone, as long as the medals haven't already been claimed, the leaderboard is closed, and it's past the end time. 
225     
226            ISponsoredLeaderboardData sponsoredLeaderboardData = ISponsoredLeaderboardData(sponsoredLeaderboardDataContract);  
227         if ((leaderboardId < 0 ) || (leaderboardId > sponsoredLeaderboardData.getTotalLeaderboards())) {revert();}
228             uint endTime;
229             bool isLive;
230             bool medalsClaimed;
231             uint prize;
232             (,endTime,isLive,,prize,,,medalsClaimed) =  sponsoredLeaderboardData.getLeaderboard(leaderboardId);
233             if (isLive == true) {revert();} 
234             if (now < endTime) {revert();}
235             if (medalsClaimed = true) {revert();}
236             sponsoredLeaderboardData.setMedalsClaimed(leaderboardId);
237             
238             
239              address owner1;
240              address owner2;
241              address owner3;
242              address owner4;
243              
244              uint64 angel;
245              
246              
247             (angel,,) =  sponsoredLeaderboardData.getTeamFromLeaderboard(leaderboardId, 0);
248              (,,,,,,,,,,owner1) = angelCardData.getAngel(angel);
249              (angel,,) =  sponsoredLeaderboardData.getTeamFromLeaderboard(leaderboardId, 1);
250              (,,,,,,,,,,owner2) = angelCardData.getAngel(angel);
251               (angel,,) =  sponsoredLeaderboardData.getTeamFromLeaderboard(leaderboardId, 2);
252              (,,,,,,,,,,owner3) = angelCardData.getAngel(angel);
253               (angel,,) =  sponsoredLeaderboardData.getTeamFromLeaderboard(leaderboardId, 3);
254              (,,,,,,,,,,owner4) = angelCardData.getAngel(angel);
255             
256             IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
257      
258     
259             
260              IMedalData medalData = IMedalData(medalDataContract);  
261             if (prize == 10000000000000000) {
262              medalData._createMedal(owner1, 2);
263              medalData._createMedal(owner2, 1);
264              medalData._createMedal(owner3,0);
265              medalData._createMedal(owner4,0);
266              return;
267             }
268             if ((prize > 10000000000000000) && (prize <= 50000000000000000)) {
269              medalData._createMedal(owner1, 5);
270              medalData._createMedal(owner2, 4);
271              medalData._createMedal(owner3,3);
272              medalData._createMedal(owner4,3);
273              return;
274             }
275                if ((prize > 50000000000000000) && (prize <= 100000000000000000)) {
276              medalData._createMedal(owner1, 6);
277              medalData._createMedal(owner2, 5);
278              medalData._createMedal(owner3,4);
279              medalData._createMedal(owner4,4);
280              return;
281             }
282                  if ((prize > 100000000000000000) && (prize <= 250000000000000000)) {
283              medalData._createMedal(owner1, 9);
284              medalData._createMedal(owner2, 6);
285              medalData._createMedal(owner3,5);
286              medalData._createMedal(owner4,5);
287              return;
288             }
289                 if ((prize > 250000000000000000  ) && (prize <= 500000000000000000)) {
290              medalData._createMedal(owner1,10);
291              medalData._createMedal(owner2, 9);
292              medalData._createMedal(owner3,6);
293              medalData._createMedal(owner4,6);
294             }
295                 if (prize  > 500000000000000000)   {
296              medalData._createMedal(owner1, 11);
297              medalData._createMedal(owner2, 10);
298              medalData._createMedal(owner3,9);
299              medalData._createMedal(owner4,9);
300              
301             }
302             
303 }
304 
305            
306             
307         }