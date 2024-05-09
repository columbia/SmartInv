1 pragma solidity 0.4.24;
2 
3 contract AccessControl {
4      /// @dev Emited when contract is upgraded - See README.md for updgrade plan
5     event ContractUpgrade(address newContract);
6 
7     // The addresses of the accounts (or contracts) that can execute actions within each roles.
8     address public ceoAddress;
9     address public cfoAddress;
10     address public cooAddress;
11 
12     address newContractAddress;
13 
14     uint public totalTipForDeveloper = 0;
15 
16     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
17     bool public paused = false;
18 
19     /// @dev Access modifier for CEO-only functionality
20     modifier onlyCEO() {
21         require(msg.sender == ceoAddress, "You're not a CEO!");
22         _;
23     }
24 
25     /// @dev Access modifier for CFO-only functionality
26     modifier onlyCFO() {
27         require(msg.sender == cfoAddress, "You're not a CFO!");
28         _;
29     }
30 
31     /// @dev Access modifier for COO-only functionality
32     modifier onlyCOO() {
33         require(msg.sender == cooAddress, "You're not a COO!");
34         _;
35     }
36 
37     modifier onlyCLevel() {
38         require((msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress), "You're not C-Level");
39         _;
40     }
41 
42     /// @dev Wrong send eth! It's will tip for developer
43     function () public payable{
44         totalTipForDeveloper = totalTipForDeveloper + msg.value;
45     }
46 
47     /// @dev Add tip for developer
48     /// @param valueTip The value of tip
49     function addTipForDeveloper(uint valueTip) internal {
50         totalTipForDeveloper += valueTip;
51     }
52 
53     /// @dev Developer can withdraw tip.
54     function withdrawTipForDeveloper() external onlyCEO {
55         require(totalTipForDeveloper > 0, "Need more tip to withdraw!");
56         msg.sender.transfer(totalTipForDeveloper);
57         totalTipForDeveloper = 0;
58     }
59 
60     // updgrade
61     function setNewAddress(address newContract) external onlyCEO whenPaused {
62         newContractAddress = newContract;
63         emit ContractUpgrade(newContract);
64     }
65 
66     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
67     /// @param _newCEO The address of the new CEO
68     function setCEO(address _newCEO) external onlyCEO {
69         require(_newCEO != address(0), "Address to set CEO wrong!");
70 
71         ceoAddress = _newCEO;
72     }
73 
74     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
75     /// @param _newCFO The address of the new CFO
76     function setCFO(address _newCFO) external onlyCEO {
77         require(_newCFO != address(0), "Address to set CFO wrong!");
78 
79         cfoAddress = _newCFO;
80     }
81 
82     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
83     /// @param _newCOO The address of the new COO
84     function setCOO(address _newCOO) external onlyCEO {
85         require(_newCOO != address(0), "Address to set COO wrong!");
86 
87         cooAddress = _newCOO;
88     }
89 
90     /*Pausable functionality adapted from OpenZeppelin */
91 
92     /// @dev Modifier to allow actions only when the contract IS NOT paused
93     modifier whenNotPaused() {
94         require(!paused, "Paused!");
95         _;
96     }
97 
98     /// @dev Modifier to allow actions only when the contract IS paused
99     modifier whenPaused {
100         require(paused, "Not paused!");
101         _;
102     }
103 
104     /// @dev Called by any "C-level" role to pause the contract. Used only when
105     ///  a bug or exploit is detected and we need to limit damage.
106     function pause() external onlyCLevel whenNotPaused {
107         paused = true;
108     }
109 
110     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
111     ///  one reason we may pause the contract is when CFO or COO accounts are
112     ///  compromised.
113     /// @notice This is public rather than external so it can be called by
114     ///  derived contracts.
115     function unpause() public onlyCEO whenPaused {
116         // can't unpause if contract was upgraded
117         paused = false;
118     }
119 }
120 
121 contract RPSCore is AccessControl {
122     uint constant ROCK = 1000;
123     uint constant PAPER = 2000;
124     uint constant SCISSOR = 3000;
125 
126     uint constant GAME_RESULT_DRAW = 1;
127     uint constant GAME_RESULT_HOST_WIN = 2;
128     uint constant GAME_RESULT_GUEST_WIN = 3;
129 
130     uint constant DEVELOPER_TIP_PERCENT = 1;
131     uint constant DEVELOPER_TIP_MIN = 0.0005 ether;
132 
133     uint constant VALUE_BET_MIN = 0.01 ether;
134     uint constant VALUE_BET_MAX = 5 ether;
135 
136     struct GameInfo {
137         uint id;
138         uint valueBet;
139         address addressHost;  
140     }
141 
142     struct GameSecret {
143         uint gestureHost;
144     }
145 
146     event LogCloseGameSuccessed(uint _id, uint _valueReturn);
147     event LogCreateGameSuccessed(uint _id, uint _valuePlayerHostBid);
148     event LogJoinAndBattleSuccessed(uint _id,
149                                     uint _result,
150                                     address indexed _addressPlayerWin,
151                                     address indexed _addressPlayerLose,
152                                     uint _valuePlayerWin,
153                                     uint _valuePlayerLose,
154                                     uint _gesturePlayerWin,
155                                     uint _gesturePlayerLose);
156  
157     uint public totalCreatedGame;
158     uint public totalAvailableGames;
159     GameInfo[] public arrAvailableGames;
160     mapping(uint => uint) idToIndexAvailableGames;
161     mapping(uint => GameSecret) idToGameSecret;
162 
163     constructor() public {
164         ceoAddress = msg.sender;
165         cfoAddress = msg.sender;
166         cooAddress = msg.sender;
167 
168         totalCreatedGame = 0;
169         totalAvailableGames = 0;
170     }
171 
172     function createGame(uint _gestureHost)
173         external
174         payable
175         verifiedGesture(_gestureHost)
176         verifiedValueBet(msg.value)
177     {
178         GameInfo memory gameInfo = GameInfo({
179             id: totalCreatedGame + 1,
180             addressHost: msg.sender,
181             valueBet: msg.value
182         });
183 
184         GameSecret memory gameSecret = GameSecret({
185             gestureHost: _gestureHost
186         });
187 
188         arrAvailableGames.push(gameInfo);
189         idToIndexAvailableGames[gameInfo.id] = arrAvailableGames.length - 1;
190         idToGameSecret[gameInfo.id] = gameSecret;
191 
192         totalCreatedGame++;
193         totalAvailableGames++;
194 
195         emit LogCreateGameSuccessed(gameInfo.id, gameInfo.valueBet);
196     }
197 
198     function joinGameAndBattle(uint _id, uint _gestureGuest)
199         external
200         payable 
201         verifiedGesture(_gestureGuest)
202         verifiedValueBet(msg.value)
203         verifiedGameAvailable(_id)
204     {
205         uint result = GAME_RESULT_DRAW;
206         uint gestureHostCached = 0;
207 
208         GameInfo memory gameInfo = arrAvailableGames[idToIndexAvailableGames[_id]];
209        
210         require(gameInfo.addressHost != msg.sender, "Don't play with yourself");
211         require(msg.value == gameInfo.valueBet, "Value bet to battle not extractly with value bet of host");
212         
213         gestureHostCached = idToGameSecret[gameInfo.id].gestureHost;
214 
215         //Result: [Draw] => Return money to host and guest players (No fee)
216         if(gestureHostCached == _gestureGuest) {
217             result = GAME_RESULT_DRAW;
218             sendPayment(msg.sender, msg.value);
219             sendPayment(gameInfo.addressHost, gameInfo.valueBet);
220             destroyGame(_id);
221             emit LogJoinAndBattleSuccessed(_id,
222                                             GAME_RESULT_DRAW,
223                                             gameInfo.addressHost,
224                                             msg.sender,
225                                             0,
226                                             0,
227                                             gestureHostCached, 
228                                             _gestureGuest);
229         }
230         else {
231             if(gestureHostCached == ROCK) 
232                 result = _gestureGuest == SCISSOR ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN;
233             else
234                 if(gestureHostCached == PAPER) 
235                     result = (_gestureGuest == ROCK ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN);
236                 else
237                     if(gestureHostCached == SCISSOR) 
238                         result = (_gestureGuest == PAPER ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN);
239 
240             //Result: [Win] => Return money to winner (Winner will pay 1% fee)
241             uint valueTip = getValueTip(gameInfo.valueBet);
242             addTipForDeveloper(valueTip);
243             
244             if(result == GAME_RESULT_HOST_WIN) {
245                 sendPayment(gameInfo.addressHost, gameInfo.valueBet * 2 - valueTip);
246                 destroyGame(_id);    
247                 emit LogJoinAndBattleSuccessed(_id,
248                                                 result,
249                                                 gameInfo.addressHost,
250                                                 msg.sender,
251                                                 gameInfo.valueBet - valueTip,
252                                                 gameInfo.valueBet,
253                                                 gestureHostCached,
254                                                 _gestureGuest);
255             }
256             else {
257                 sendPayment(msg.sender, gameInfo.valueBet * 2 - valueTip);
258                 destroyGame(_id);
259                 emit LogJoinAndBattleSuccessed(_id,
260                                                 result,
261                                                 msg.sender,
262                                                 gameInfo.addressHost,
263                                                 gameInfo.valueBet - valueTip,
264                                                 gameInfo.valueBet,
265                                                 _gestureGuest,
266                                                 gestureHostCached);
267             }          
268         }
269 
270     }
271 
272     function closeMyGame(uint _id) external payable verifiedHostOfGame(_id) verifiedGameAvailable(_id) {
273         GameInfo storage gameInfo = arrAvailableGames[idToIndexAvailableGames[_id]];
274 
275         require(gameInfo.valueBet > 0, "Can't close game!");
276 
277         uint valueBet = gameInfo.valueBet;
278         gameInfo.valueBet = 0;
279         sendPayment(gameInfo.addressHost, valueBet);
280         destroyGame(_id);
281         emit LogCloseGameSuccessed(_id, valueBet);
282     }
283 
284     function () public payable {
285     }
286 
287     function destroyGame(uint _id) private {
288         uint indexGameInfo = idToIndexAvailableGames[_id];
289         delete idToIndexAvailableGames[_id];
290         delete idToGameSecret[_id];
291         removeGameInfoFromArray(indexGameInfo);
292         totalAvailableGames--;
293     }
294 
295     function removeGameInfoFromArray(uint _index) private {
296         if(_index >= 0 && arrAvailableGames.length > 0) {
297             if(_index == arrAvailableGames.length - 1)
298             arrAvailableGames.length--;
299             else {
300                 arrAvailableGames[_index] = arrAvailableGames[arrAvailableGames.length - 1];
301                 idToIndexAvailableGames[arrAvailableGames[_index].id] = _index;
302                 arrAvailableGames.length--;
303             }
304         }
305     }
306 
307     function getValueTip(uint _valueWin) private pure returns(uint) {
308         uint valueTip = _valueWin * DEVELOPER_TIP_PERCENT / 100;
309 
310         if(valueTip < DEVELOPER_TIP_MIN)
311             valueTip = DEVELOPER_TIP_MIN;
312 
313         return valueTip;
314     }
315 
316     function sendPayment(address _receiver, uint _amount) private {
317         _receiver.transfer(_amount);
318     }
319 
320     modifier verifiedGameAvailable(uint _id) {
321         require(idToIndexAvailableGames[_id] >= 0, "Game ID not exist!");
322         _;
323     }
324 
325     modifier verifiedGesture(uint _resultSelect) {
326         require((_resultSelect == ROCK || _resultSelect == PAPER || _resultSelect == SCISSOR), "Gesture can't verify");
327         _;
328     }
329 
330     modifier verifiedHostOfGame(uint _id) {
331         require(msg.sender == arrAvailableGames[idToIndexAvailableGames[_id]].addressHost, "Verify host of game failed");
332         _;
333     }
334 
335     modifier verifiedValueBet(uint _valueBet) {
336         require(_valueBet >= VALUE_BET_MIN && _valueBet <= VALUE_BET_MAX, "Your value bet out of rule");
337         _;
338     }
339 
340 }