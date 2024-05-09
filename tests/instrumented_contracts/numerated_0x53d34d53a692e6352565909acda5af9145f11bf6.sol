1 pragma solidity ^0.4.21;
2 
3 library BWUtility {
4     
5     // -------- UTILITY FUNCTIONS ----------
6 
7 
8     // Return next higher even _multiple for _amount parameter (e.g used to round up to even finneys).
9     function ceil(uint _amount, uint _multiple) pure public returns (uint) {
10         return ((_amount + _multiple - 1) / _multiple) * _multiple;
11     }
12 
13     // Checks if two coordinates are adjacent:
14     // xxx
15     // xox
16     // xxx
17     // All x (_x2, _xy2) are adjacent to o (_x1, _y1) in this ascii image. 
18     // Adjacency does not wrapp around map edges so if y2 = 255 and y1 = 0 then they are not ajacent
19     function isAdjacent(uint8 _x1, uint8 _y1, uint8 _x2, uint8 _y2) pure public returns (bool) {
20         return ((_x1 == _x2 &&      (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Same column
21                ((_y1 == _y2 &&      (_x2 - _x1 == 1 || _x1 - _x2 == 1))) ||      // Same row
22                ((_x2 - _x1 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Right upper or lower diagonal
23                ((_x1 - _x2 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1)));        // Left upper or lower diagonal
24     }
25 
26     // Converts (x, y) to tileId xy
27     function toTileId(uint8 _x, uint8 _y) pure public returns (uint16) {
28         return uint16(_x) << 8 | uint16(_y);
29     }
30 
31     // Converts _tileId to (x, y)
32     function fromTileId(uint16 _tileId) pure public returns (uint8, uint8) {
33         uint8 y = uint8(_tileId);
34         uint8 x = uint8(_tileId >> 8);
35         return (x, y);
36     }
37     
38     function getBoostFromTile(address _claimer, address _attacker, address _defender, uint _blockValue) pure public returns (uint, uint) {
39         if (_claimer == _attacker) {
40             return (_blockValue, 0);
41         } else if (_claimer == _defender) {
42             return (0, _blockValue);
43         }
44     }
45 }
46 
47 contract BWData {
48     address public owner;
49     address private bwService;
50     address private bw;
51     address private bwMarket;
52 
53     uint private blockValueBalance = 0;
54     uint private feeBalance = 0;
55     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
56     
57     mapping (address => User) private users; // user address -> user information
58     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
59     
60     // Info about the users = those who have purchased tiles.
61     struct User {
62         uint creationTime;
63         bool censored;
64         uint battleValue;
65     }
66 
67     // Info about a tile ownership
68     struct Tile {
69         address claimer;
70         uint blockValue;
71         uint creationTime;
72         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
73     }
74 
75     struct Boost {
76         uint8 numAttackBoosts;
77         uint8 numDefendBoosts;
78         uint attackBoost;
79         uint defendBoost;
80     }
81 
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     // Can't send funds straight to this contract. Avoid people sending by mistake.
87     function () payable public {
88         revert();
89     }
90 
91     function kill() public isOwner {
92         selfdestruct(owner);
93     }
94 
95     modifier isValidCaller {
96         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
97             revert();
98         }
99         _;
100     }
101     
102     modifier isOwner {
103         if (msg.sender != owner) {
104             revert();
105         }
106         _;
107     }
108     
109     function setBwServiceValidCaller(address _bwService) public isOwner {
110         bwService = _bwService;
111     }
112 
113     function setBwValidCaller(address _bw) public isOwner {
114         bw = _bw;
115     }
116 
117     function setBwMarketValidCaller(address _bwMarket) public isOwner {
118         bwMarket = _bwMarket;
119     }    
120     
121     // ----------USER-RELATED GETTER FUNCTIONS------------
122     
123     //function getUser(address _user) view public returns (bytes32) {
124         //BWUtility.User memory user = users[_user];
125         //require(user.creationTime != 0);
126         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
127     //}
128     
129     function addUser(address _msgSender) public isValidCaller {
130         User storage user = users[_msgSender];
131         require(user.creationTime == 0);
132         user.creationTime = block.timestamp;
133     }
134 
135     function hasUser(address _user) view public isValidCaller returns (bool) {
136         return users[_user].creationTime != 0;
137     }
138     
139 
140     // ----------TILE-RELATED GETTER FUNCTIONS------------
141 
142     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
143         Tile storage currentTile = tiles[_tileId];
144         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
145     }
146     
147     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
148         Tile storage currentTile = tiles[_tileId];
149         return (currentTile.claimer, currentTile.blockValue);
150     }
151     
152     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
153         Tile storage currentTile = tiles[_tileId];
154         return currentTile.creationTime == 0;
155     }
156     
157     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
158         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
159     }
160 
161     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
162         tiles[_tileId].blockValue = _blockValue;
163     }
164 
165     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
166         tiles[_tileId].claimer = _claimer;
167     }
168 
169     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
170         tiles[_tileId].creationTime = block.timestamp;
171     }
172     
173     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
174         Tile storage currentTile = tiles[_tileId];
175         if (currentTile.creationTime == 0) {
176             return 0;
177         }
178         return currentTile.claimer;
179     }
180 
181     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
182         Tile storage currentTile = tiles[_tileId];
183         if (currentTile.creationTime == 0) {
184             return (0, 0);
185         }
186         return (currentTile.blockValue, currentTile.sellPrice);
187     }
188     
189     function getBlockValueBalance() view public isValidCaller returns (uint){
190         return blockValueBalance;
191     }
192 
193     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
194         blockValueBalance = _blockValueBalance;
195     }
196 
197     function getFeeBalance() view public isValidCaller returns (uint) {
198         return feeBalance;
199     }
200 
201     function setFeeBalance(uint _feeBalance) public isValidCaller {
202         feeBalance = _feeBalance;
203     }
204     
205     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
206         return users[_userId].battleValue;
207     }
208     
209     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
210         users[_userId].battleValue = _battleValue;
211     }
212     
213     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
214         User storage user = users[_msgSender];
215         require(user.creationTime != 0);
216 
217         if (_useBattleValue) {
218             require(_msgValue == 0);
219             require(user.battleValue >= _amount);
220         } else {
221             require(_amount == _msgValue);
222         }
223     }
224     
225     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
226         if (_tile.claimer == _attacker) {
227             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
228             _boost.attackBoost += _tile.blockValue;
229             _boost.numAttackBoosts += 1;
230         } else if (_tile.claimer == _defender) {
231             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
232             _boost.defendBoost += _tile.blockValue;
233             _boost.numDefendBoosts += 1;
234         }
235     }
236 
237     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
238         uint8 x;
239         uint8 y;
240 
241         (x, y) = BWUtility.fromTileId(_tileId);
242 
243         Boost memory boost = Boost(0, 0, 0, 0);
244         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
245         // Go through all adjacent tiles to (x, y).
246         if (y != 255) {
247             if (x != 255) {
248                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
249             }
250             
251             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
252 
253             if (x != 0) {
254                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
255             }
256         }
257 
258         if (x != 255) {
259             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
260         }
261 
262         if (x != 0) {
263             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
264         }
265 
266         if (y != 0) {
267             if(x != 255) {
268                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
269             }
270 
271             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
272 
273             if(x != 0) {
274                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
275             }
276         }
277         // The benefit of boosts is multiplicative (quadratic):
278         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
279         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
280         // Example:
281         //   A) I boost attack with 1 single tile worth 10 finney
282         //      -> Total boost is 10 * 1 / 10 = 1 finney
283         //   B) I boost attack with 3 tiles worth 1 finney each
284         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
285         //   C) I boost attack with 8 tiles worth 2 finney each
286         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
287         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
288         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
289         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
290         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
291         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
292         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
293 
294         return (boost.attackBoost, boost.defendBoost);
295     }
296     
297     function censorUser(address _userAddress, bool _censored) public isValidCaller {
298         User storage user = users[_userAddress];
299         require(user.creationTime != 0);
300         user.censored = _censored;
301     }
302     
303     function deleteTile(uint16 _tileId) public isValidCaller {
304         delete tiles[_tileId];
305     }
306     
307     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
308         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
309     }
310 
311     function deleteOffer(uint16 _tileId) public isValidCaller {
312         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
313     }
314 }