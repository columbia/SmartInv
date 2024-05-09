1 pragma solidity 0.4.24;
2 
3 contract AccessControl {
4      /// @dev Emited when contract is upgraded - See README.md for updgrade plan
5     event ContractUpgrade(address newContract);
6 
7     // The addresses of the accounts (or contracts) that can execute actions within each roles.
8     address public ceoAddress;
9 
10     uint public totalTipForDeveloper = 0;
11 
12     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
13     bool public paused = false;
14 
15     /// @dev Access modifier for CEO-only functionality
16     modifier onlyCEO() {
17         require(msg.sender == ceoAddress, "You're not a CEO!");
18         _;
19     }
20 
21     /// @dev Wrong send eth! It's will tip for developer
22     function () public payable{
23         totalTipForDeveloper = totalTipForDeveloper + msg.value;
24     }
25 
26     /// @dev Add tip for developer
27     /// @param valueTip The value of tip
28     function addTipForDeveloper(uint valueTip) internal {
29         totalTipForDeveloper += valueTip;
30     }
31 
32     /// @dev Developer can withdraw tip.
33     function withdrawTipForDeveloper() external onlyCEO {
34         require(totalTipForDeveloper > 0, "Need more tip to withdraw!");
35         msg.sender.transfer(totalTipForDeveloper);
36         totalTipForDeveloper = 0;
37     }
38 
39     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
40     /// @param _newCEO The address of the new CEO
41     function setCEO(address _newCEO) external onlyCEO {
42         require(_newCEO != address(0), "Address to set CEO wrong!");
43 
44         ceoAddress = _newCEO;
45     }
46 
47     /*Pausable functionality adapted from OpenZeppelin */
48 
49     /// @dev Modifier to allow actions only when the contract IS NOT paused
50     modifier whenNotPaused() {
51         require(!paused, "Paused!");
52         _;
53     }
54 
55     /// @dev Modifier to allow actions only when the contract IS paused
56     modifier whenPaused {
57         require(paused, "Not paused!");
58         _;
59     }
60 
61     /// @dev Called by any "C-level" role to pause the contract. Used only when
62     ///  a bug or exploit is detected and we need to limit damage.
63     function pause() external onlyCEO whenNotPaused {
64         paused = true;
65     }
66 
67     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
68     ///  one reason we may pause the contract is when CFO or COO accounts are
69     ///  compromised.
70     /// @notice This is public rather than external so it can be called by
71     ///  derived contracts.
72     function unpause() public onlyCEO whenPaused {
73         // can't unpause if contract was upgraded
74         paused = false;
75     }
76 }
77 
78 contract RPSCore is AccessControl {
79     uint constant ROCK = 1000;
80     uint constant PAPER = 2000;
81     uint constant SCISSOR = 3000;
82 
83     uint constant GAME_RESULT_DRAW = 1;
84     uint constant GAME_RESULT_HOST_WIN = 2;
85     uint constant GAME_RESULT_GUEST_WIN = 3;
86 
87     uint constant GAME_STATE_AVAILABLE_TO_JOIN = 1;
88     uint constant GAME_STATE_WAITING_HOST_REVEAL = 2;
89 
90     uint constant DEVELOPER_TIP_PERCENT = 1;
91     uint constant DEVELOPER_TIP_MIN = 0.0005 ether;
92 
93     uint constant VALUE_BET_MIN = 0.02 ether;
94     uint constant VALUE_BET_MAX = 2 ether;
95 
96     uint constant TIME_GAME_EXPIRE = 1 hours;
97 
98     struct Game {
99         uint id;
100         uint state;
101         uint timeExpire;
102         uint valueBet;
103         uint gestureGuest;
104         address addressHost;
105         address addressGuest;
106         bytes32 hashGestureHost;
107     }
108 
109     event LogCloseGameSuccessed(uint _id, uint _valueReturn);
110     event LogCreateGameSuccessed(uint _id, uint _valuePlayerHostBid);
111     event LogJoinGameSuccessed(uint _id);
112     event LogRevealGameSuccessed(uint _id,
113                                     uint _result,
114                                     address indexed _addressPlayerWin,
115                                     address indexed _addressPlayerLose,
116                                     uint _valuePlayerWin,
117                                     uint _valuePlayerLose,
118                                     uint _gesturePlayerWin,
119                                     uint _gesturePlayerLose);
120  
121     uint public totalCreatedGame;
122     uint public totalAvailableGames;
123     Game[] public arrAvailableGames;
124 
125     mapping(uint => uint) idToIndexAvailableGames;
126 
127 
128     constructor() public {
129         ceoAddress = msg.sender;
130 
131         totalCreatedGame = 0;
132         totalAvailableGames = 0;
133     }
134 
135     function createGame(bytes32 _hashGestureHost)
136         external
137         payable
138         verifiedValueBetWithRule(msg.value)
139     {
140         Game memory game = Game({
141             id: totalCreatedGame + 1,
142             state: GAME_STATE_AVAILABLE_TO_JOIN,
143             timeExpire: 0,
144             valueBet: msg.value,
145             addressHost: msg.sender,
146             hashGestureHost: _hashGestureHost,
147             addressGuest: 0,
148             gestureGuest: 0
149         });
150 
151         arrAvailableGames.push(game);
152         idToIndexAvailableGames[game.id] = arrAvailableGames.length - 1;
153 
154         totalCreatedGame++;
155         totalAvailableGames++;
156 
157         emit LogCreateGameSuccessed(game.id, game.valueBet);
158     }
159 
160     function joinGame(uint _id, uint _gestureGuest)
161         external
162         payable
163         verifiedValueBetWithRule(msg.value)
164         verifiedGameAvailable(_id)
165         verifiedGameExist(_id)
166     {
167         Game storage game = arrAvailableGames[idToIndexAvailableGames[_id]];
168 
169         require(msg.sender != game.addressHost, "Can't join game cretead by host");
170         require(msg.value == game.valueBet, "Value bet to battle not extractly with value bet of host");
171        
172         game.addressGuest = msg.sender;
173         game.gestureGuest = _gestureGuest;
174         game.state = GAME_STATE_WAITING_HOST_REVEAL;
175         game.timeExpire = now + TIME_GAME_EXPIRE;
176 
177         emit LogJoinGameSuccessed(_id);
178     }
179 
180     function revealGameByHost(uint _id, uint _gestureHost, bytes32 _secretKey) external payable verifiedGameExist(_id) {
181         bytes32 proofHashGesture = getProofGesture(_gestureHost, _secretKey);
182         Game storage game = arrAvailableGames[idToIndexAvailableGames[_id]];
183         Game memory gameCached = arrAvailableGames[idToIndexAvailableGames[_id]];
184 
185         require(gameCached.state == GAME_STATE_WAITING_HOST_REVEAL, "Game not in state waiting reveal");
186         require(now <= gameCached.timeExpire, "Host time reveal ended");
187         require(gameCached.addressHost == msg.sender, "You're not host this game");
188         require(gameCached.hashGestureHost == proofHashGesture, "Can't verify gesture and secret key of host");
189         require(verifyGesture(_gestureHost) && verifyGesture(gameCached.gestureGuest), "Can't verify gesture of host or guest");
190 
191         uint result = GAME_RESULT_DRAW;
192 
193         //Result: [Draw] => Return money to host and guest players (No fee)
194         if(_gestureHost == gameCached.gestureGuest) {
195             result = GAME_RESULT_DRAW;
196             sendPayment(gameCached.addressHost, gameCached.valueBet);
197             sendPayment(gameCached.addressGuest, gameCached.valueBet);
198             game.valueBet = 0;
199             destroyGame(_id);
200             emit LogRevealGameSuccessed(_id,
201                                         GAME_RESULT_DRAW,
202                                         gameCached.addressHost,
203                                         gameCached.addressGuest,
204                                         0,
205                                         0,
206                                         _gestureHost, 
207                                         gameCached.gestureGuest);
208         }
209         else {
210             if(_gestureHost == ROCK) 
211                 result = gameCached.gestureGuest == SCISSOR ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN;
212             else
213                 if(_gestureHost == PAPER) 
214                     result = (gameCached.gestureGuest == ROCK ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN);
215                 else
216                     if(_gestureHost == SCISSOR) 
217                         result = (gameCached.gestureGuest == PAPER ? GAME_RESULT_HOST_WIN : GAME_RESULT_GUEST_WIN);
218 
219             //Result: [Win] => Return money to winner (Winner will pay 1% fee)
220             uint valueTip = getValueTip(gameCached.valueBet);
221             addTipForDeveloper(valueTip);
222             
223             if(result == GAME_RESULT_HOST_WIN) {
224                 sendPayment(gameCached.addressHost, gameCached.valueBet * 2 - valueTip);
225                 game.valueBet = 0;
226                 destroyGame(_id);    
227                 emit LogRevealGameSuccessed(_id,
228                                             GAME_RESULT_HOST_WIN,
229                                             gameCached.addressHost,
230                                             gameCached.addressGuest,
231                                             gameCached.valueBet - valueTip,
232                                             gameCached.valueBet,
233                                             _gestureHost, 
234                                             gameCached.gestureGuest);
235             }
236             else {
237                 sendPayment(gameCached.addressGuest, gameCached.valueBet * 2 - valueTip);
238                 game.valueBet = 0;
239                 destroyGame(_id);
240                 emit LogRevealGameSuccessed(_id,
241                                             GAME_RESULT_GUEST_WIN,
242                                             gameCached.addressGuest,
243                                             gameCached.addressHost,
244                                             gameCached.valueBet - valueTip,
245                                             gameCached.valueBet,
246                                             gameCached.gestureGuest, 
247                                             _gestureHost);
248             }          
249         }
250     }
251 
252     function revealGameByGuest(uint _id) external payable verifiedGameExist(_id) {
253         Game storage game = arrAvailableGames[idToIndexAvailableGames[_id]];
254         Game memory gameCached = arrAvailableGames[idToIndexAvailableGames[_id]];
255 
256         require(gameCached.state == GAME_STATE_WAITING_HOST_REVEAL, "Game not in state waiting reveal");
257         require(now > gameCached.timeExpire, "Host time reveal not ended");
258         require(gameCached.addressGuest == msg.sender, "You're not guest this game");
259 
260         uint valueTip = getValueTip(gameCached.valueBet);
261         addTipForDeveloper(valueTip);
262 
263         sendPayment(gameCached.addressGuest, gameCached.valueBet * 2 - valueTip);
264         game.valueBet = 0;
265         destroyGame(_id);
266         emit LogRevealGameSuccessed(_id,
267                                     GAME_RESULT_GUEST_WIN,
268                                     gameCached.addressGuest,
269                                     gameCached.addressHost,
270                                     gameCached.valueBet - valueTip,
271                                     gameCached.valueBet,
272                                     gameCached.gestureGuest, 
273                                     0);
274     }
275 
276     function closeMyGame(uint _id) external payable verifiedHostOfGame(_id) verifiedGameAvailable(_id) {
277         Game storage game = arrAvailableGames[idToIndexAvailableGames[_id]];
278 
279         require(game.state == GAME_STATE_AVAILABLE_TO_JOIN, "Battle already! Waiting your reveal! Refesh page");
280 
281         uint valueBetCached = game.valueBet;
282         sendPayment(game.addressHost, valueBetCached);
283         game.valueBet = 0;
284         destroyGame(_id);
285         emit LogCloseGameSuccessed(_id, valueBetCached);
286     }
287 
288     function getAvailableGameWithID(uint _id) 
289         public
290         view
291         verifiedGameExist(_id) 
292         returns (uint id, uint state, uint valueBest, uint timeExpireRemaining, address addressHost, address addressGuest) 
293     {
294         Game storage game = arrAvailableGames[idToIndexAvailableGames[_id]];
295         timeExpireRemaining = game.timeExpire - now;
296         timeExpireRemaining = (timeExpireRemaining < 0 ? 0 : timeExpireRemaining);
297 
298         return(game.id, game.state, game.valueBet, game.timeExpire, game.addressHost, game.addressGuest);
299     }
300 
301     function destroyGame(uint _id) private {
302         removeGameInfoFromArray(idToIndexAvailableGames[_id]);
303         delete idToIndexAvailableGames[_id];
304         totalAvailableGames--;
305     }
306 
307     function removeGameInfoFromArray(uint _index) private {
308         if(_index >= 0 && arrAvailableGames.length > 0) {
309             if(_index == arrAvailableGames.length - 1)
310             arrAvailableGames.length--;
311             else {
312                 arrAvailableGames[_index] = arrAvailableGames[arrAvailableGames.length - 1];
313                 idToIndexAvailableGames[arrAvailableGames[_index].id] = _index;
314                 arrAvailableGames.length--;
315             }
316         }
317     }
318 
319     function getValueTip(uint _valueWin) private pure returns(uint) {
320         uint valueTip = _valueWin * DEVELOPER_TIP_PERCENT / 100;
321 
322         if(valueTip < DEVELOPER_TIP_MIN)
323             valueTip = DEVELOPER_TIP_MIN;
324 
325         return valueTip;
326     }
327 
328     function sendPayment(address _receiver, uint _amount) private {
329         _receiver.transfer(_amount);
330     }
331 
332     function getProofGesture(uint _gesture, bytes32 _secretKey) private pure returns (bytes32) {
333         return keccak256(abi.encodePacked(_gesture, _secretKey));
334     }
335 
336     function verifyGesture(uint _gesture) private pure returns (bool) {
337         return (_gesture == ROCK || _gesture == PAPER || _gesture == SCISSOR);
338     }
339 
340     modifier verifiedGameAvailable(uint _id) {
341         require(arrAvailableGames[idToIndexAvailableGames[_id]].addressGuest == 0, "Have guest already");
342         _;
343     }
344 
345     modifier verifiedGameExist(uint _id) {
346         require(idToIndexAvailableGames[_id] >= 0, "Game ID not exist!");
347         _;
348     }
349 
350     modifier verifiedHostOfGame(uint _id) {
351         require(msg.sender == arrAvailableGames[idToIndexAvailableGames[_id]].addressHost, "Verify host of game failed");
352         _;
353     }
354 
355     modifier verifiedValueBetWithRule(uint _valueBet) {
356         require(_valueBet >= VALUE_BET_MIN && _valueBet <= VALUE_BET_MAX, "Your value bet out of rule");
357         _;
358     }
359 
360 }