1 pragma solidity ^0.4.17;
2 
3 contract AccessControl {
4     address public creatorAddress;
5     uint16 public totalSeraphims = 0;
6     mapping (address => bool) public seraphims;
7 
8     bool public isMaintenanceMode = true;
9  
10     modifier onlyCREATOR() {
11         require(msg.sender == creatorAddress);
12         _;
13     }
14 
15     modifier onlySERAPHIM() {
16         require(seraphims[msg.sender] == true);
17         _;
18     }
19     
20     modifier isContractActive {
21         require(!isMaintenanceMode);
22         _;
23     }
24     
25     // Constructor
26     function AccessControl() public {
27         creatorAddress = msg.sender;
28     }
29     
30 
31     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
32         if (seraphims[_newSeraphim] == false) {
33             seraphims[_newSeraphim] = true;
34             totalSeraphims += 1;
35         }
36     }
37     
38     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
39         if (seraphims[_oldSeraphim] == true) {
40             seraphims[_oldSeraphim] = false;
41             totalSeraphims -= 1;
42         }
43     }
44 
45     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
46         isMaintenanceMode = _isMaintaining;
47     }
48 
49   
50 } 
51 contract SafeMath {
52     function safeAdd(uint x, uint y) pure internal returns(uint) {
53       uint z = x + y;
54       assert((z >= x) && (z >= y));
55       return z;
56     }
57 
58     function safeSubtract(uint x, uint y) pure internal returns(uint) {
59       assert(x >= y);
60       uint z = x - y;
61       return z;
62     }
63 
64     function safeMult(uint x, uint y) pure internal returns(uint) {
65       uint z = x * y;
66       assert((x == 0)||(z/x == y));
67       return z;
68     }
69     
70      function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
78         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
79         return uint8(genNum % (maxRandom - min + 1)+min);
80     }
81 }
82 
83 contract Enums {
84     enum ResultCode {
85         SUCCESS,
86         ERROR_CLASS_NOT_FOUND,
87         ERROR_LOW_BALANCE,
88         ERROR_SEND_FAIL,
89         ERROR_NOT_OWNER,
90         ERROR_NOT_ENOUGH_MONEY,
91         ERROR_INVALID_AMOUNT
92     }
93 
94     enum AngelAura { 
95         Blue, 
96         Yellow, 
97         Purple, 
98         Orange, 
99         Red, 
100         Green 
101     }
102 }
103 
104 
105 contract IBattleboardData is AccessControl  {
106 
107   
108 
109       // write functions
110   
111 function createBattleboard(uint prize, uint8 restrictions) onlySERAPHIM external returns (uint16);
112 function killMonster(uint16 battleboardId, uint8 monsterId)  onlySERAPHIM external;
113 function createNullTile(uint16 _battleboardId) private ;
114 function createTile(uint16 _battleboardId, uint8 _tileType, uint8 _value, uint8 _position, uint32 _hp, uint16 _petPower, uint64 _angelId, uint64 _petId, address _owner, uint8 _team) onlySERAPHIM external  returns (uint8);
115 function killTile(uint16 battleboardId, uint8 tileId) onlySERAPHIM external ;
116 function addTeamtoBoard(uint16 battleboardId, address owner, uint8 team) onlySERAPHIM external;
117 function setTilePosition (uint16 battleboardId, uint8 tileId, uint8 _positionTo) onlySERAPHIM public ;
118 function setTileHp(uint16 battleboardId, uint8 tileId, uint32 _hp) onlySERAPHIM external ;
119 function addMedalBurned(uint16 battleboardId) onlySERAPHIM external ;
120 function setLastMoveTime(uint16 battleboardId) onlySERAPHIM external ;
121 function iterateTurn(uint16 battleboardId) onlySERAPHIM external ;
122 function killBoard(uint16 battleboardId) onlySERAPHIM external ;
123 function clearAngelsFromBoard(uint16 battleboardId) private;
124 //Read functions
125      
126 function getTileHp(uint16 battleboardId, uint8 tileId) constant external returns (uint32) ;
127 function getMedalsBurned(uint16 battleboardId) constant external returns (uint8) ;
128 function getTeam(uint16 battleboardId, uint8 tileId) constant external returns (uint8) ;
129 function getMaxFreeTeams() constant public returns (uint8);
130 function getBarrierNum(uint16 battleboardId) public constant returns (uint8) ;
131 function getTileFromBattleboard(uint16 battleboardId, uint8 tileId) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint16 petPower, uint64 angelId, uint64 petId, bool isLive, address owner)   ;
132 function getTileIDByOwner(uint16 battleboardId, address _owner) constant public returns (uint8) ;
133 function getPetbyTileId( uint16 battleboardId, uint8 tileId) constant public returns (uint64) ;
134 function getOwner (uint16 battleboardId, uint8 team,  uint8 ownerNumber) constant external returns (address);
135 function getTileIDbyPosition(uint16 battleboardId, uint8 position) public constant returns (uint8) ;
136 function getPositionFromBattleboard(uint16 battleboardId, uint8 _position) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint32 petPower, uint64 angelId, uint64 petId, bool isLive)  ;
137 function getBattleboard(uint16 id) public constant returns (uint8 turn, bool isLive, uint prize, uint8 numTeams, uint8 numTiles, uint8 createdBarriers, uint8 restrictions, uint lastMoveTime, uint8 numTeams1, uint8 numTeams2, uint8 monster1, uint8 monster2) ;
138 function isBattleboardLive(uint16 battleboardId) constant public returns (bool);
139 function isTileLive(uint16 battleboardId, uint8 tileId) constant  external returns (bool) ;
140 function getLastMoveTime(uint16 battleboardId) constant public returns (uint) ;
141 function getNumTilesFromBoard (uint16 _battleboardId) constant public returns (uint8) ; 
142 function angelOnBattleboards(uint64 angelID) external constant returns (bool) ;
143 function getTurn(uint16 battleboardId) constant public returns (address) ;
144 function getNumTeams(uint16 battleboardId, uint8 team) public constant returns (uint8);
145 function getMonsters(uint16 BattleboardId) external constant returns (uint8 monster1, uint8 monster2) ;
146 function getTotalBattleboards() public constant returns (uint16) ;
147   
148         
149  
150    
151 }
152 contract IMedalData is AccessControl {
153   
154     modifier onlyOwnerOf(uint256 _tokenId) {
155     require(ownerOf(_tokenId) == msg.sender);
156     _;
157   }
158    
159 function totalSupply() public view returns (uint256);
160 function setMaxTokenNumbers()  onlyCREATOR external;
161 function balanceOf(address _owner) public view returns (uint256);
162 function tokensOf(address _owner) public view returns (uint256[]) ;
163 function ownerOf(uint256 _tokenId) public view returns (address);
164 function approvedFor(uint256 _tokenId) public view returns (address) ;
165 function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
166 function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
167 function takeOwnership(uint256 _tokenId) public;
168 function _createMedal(address _to, uint8 _seriesID) onlySERAPHIM public ;
169 function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32);
170 function getMedalType (uint256 _tokenId) public constant returns (uint8);
171 function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external;
172 function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) ;
173 function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal;
174 function clearApproval(address _owner, uint256 _tokenId) private;
175 function addToken(address _to, uint256 _tokenId) private ;
176 function removeToken(address _from, uint256 _tokenId) private;
177 }
178 contract BattleboardsSupport is AccessControl, SafeMath  {
179 
180     /*** DATA TYPES ***/
181 
182     address public medalDataContract =  0x33A104dCBEd81961701900c06fD14587C908EAa3;
183     address public battleboardDataContract =0xE60fC4632bD6713E923FE93F8c244635E6d5009e;
184 
185     
186     
187     uint8 public medalBoost = 50;
188     uint8 public numBarriersPerBoard = 6;
189     uint public barrierPrice = 1000000000000000;
190     uint8 public maxMedalsBurned = 3;
191     uint8 public barrierStrength = 75;
192     
193       
194           // Utility Functions
195     function DataContacts(address _medalDataContract, address _battleboardDataContract) onlyCREATOR external {
196       
197         medalDataContract = _medalDataContract;
198         battleboardDataContract = _battleboardDataContract;
199     }
200     
201     function setVariables( uint8 _medalBoost, uint8 _numBarriersPerBoard, uint8 _maxMedalsBurned, uint8 _barrierStrength, uint _barrierPrice) onlyCREATOR external {
202         medalBoost = _medalBoost;
203         numBarriersPerBoard = _numBarriersPerBoard;
204         maxMedalsBurned = _maxMedalsBurned;
205         barrierStrength = _barrierStrength;
206         barrierPrice = _barrierPrice;
207         
208     }
209     
210       
211       
212         //Can be called by anyone at anytime,    
213        function erectBarrier(uint16 battleboardId, uint8 _barrierType, uint8 _position) external payable {
214            IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
215            uint8 numBarriers = battleboardData.getBarrierNum(battleboardId);
216            if (battleboardData.getTileIDbyPosition(battleboardId, _position) != 0 ) {revert();}  //Can't put a barrier on top of another tile
217            if (numBarriers >= numBarriersPerBoard) {revert();} //can't put too many barriers on one board. 
218            if (msg.value < barrierPrice) {revert();}
219            if ((_barrierType <2) || (_barrierType >4)) {revert();} //can't create another tile instead of a barrier. 
220           battleboardData.createTile(battleboardId,_barrierType, barrierStrength, _position, 0, 0, 0, 0, address(this),0);
221        }
222        
223        
224                 
225           function checkExistsOwnedMedal (uint64 medalId) public constant returns (bool) {
226           IMedalData medalData = IMedalData(medalDataContract);
227        
228         if ((medalId < 0) || (medalId > medalData.totalSupply())) {return false;}
229         if (medalData.ownerOf(medalId) == msg.sender) {return true;}
230         
231        else  return false;
232 }
233        
234              function medalBoostAndBurn(uint16 battleboardId, uint64 medalId) public  {
235                
236                //IMPORTANT: Before burning a medal in this function, you must APPROVE this address
237                //in the medal data contract to unlock it. 
238                
239                 IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
240 
241                 uint8 tileId = battleboardData.getTileIDByOwner(battleboardId,msg.sender);
242                 //can't resurrect yourself. 
243                 if (battleboardData.isTileLive(battleboardId,tileId) == false) {revert();}
244                 
245                if  (checkExistsOwnedMedal(medalId)== false) {revert();}
246                
247                //make sure the max number of medals haven't already been burned. 
248                if (battleboardData.getMedalsBurned(battleboardId) >= maxMedalsBurned) {revert();}
249               battleboardData.addMedalBurned(battleboardId);
250                  //this first takes and then burns the medal. 
251                IMedalData medalData = IMedalData(medalDataContract);
252                uint8 medalType = medalData.getMedalType(medalId);
253                medalData.takeOwnership(medalId);
254                medalData._burn(medalId);
255             uint32 hp = battleboardData.getTileHp(battleboardId, tileId);
256            
257           battleboardData.setTileHp(battleboardId, tileId, hp + (medalType * medalBoost));
258        }
259        
260          
261            function kill() onlyCREATOR external {
262         selfdestruct(creatorAddress);
263     }
264  
265         
266 function withdrawEther()  onlyCREATOR external {
267     creatorAddress.transfer(this.balance);
268 }
269        
270        
271 }