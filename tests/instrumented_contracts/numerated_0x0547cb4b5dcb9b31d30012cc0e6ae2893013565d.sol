1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5     address public owner;
6     address public newOwnerCandidate;
7 
8     event OwnershipRequested(address indexed _by, address indexed _to);
9     event OwnershipTransferred(address indexed _from, address indexed _to);
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() { require(msg.sender == owner); _;}
16 
17     /// Proposes to transfer control of the contract to a newOwnerCandidate.
18     /// @param _newOwnerCandidate address The address to transfer ownership to.
19     function transferOwnership(address _newOwnerCandidate) external onlyOwner {
20         require(_newOwnerCandidate != address(0));
21 
22         newOwnerCandidate = _newOwnerCandidate;
23 
24         emit OwnershipRequested(msg.sender, newOwnerCandidate);
25     }
26 
27     /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.
28     function acceptOwnership() external {
29         if (msg.sender == newOwnerCandidate) {
30             owner = newOwnerCandidate;
31             newOwnerCandidate = address(0);
32 
33             emit OwnershipTransferred(owner, newOwnerCandidate);
34         }
35     }
36 }
37 
38 
39 contract Serverable is Ownable {
40     address public server;
41 
42     modifier onlyServer() { require(msg.sender == server); _;}
43 
44     function setServerAddress(address _newServerAddress) external onlyOwner {
45         server = _newServerAddress;
46     }
47 }
48 
49 
50 contract ERC223 {
51   uint public totalSupply;
52   function balanceOf(address who) public view returns (uint);
53   
54   function name() public view returns (string _name);
55   function symbol() public view returns (string _symbol);
56   function decimals() public view returns (uint8 _decimals);
57   function totalSupply() public view returns (uint256 _supply);
58 
59   function transfer(address to, uint value) public returns (bool ok);
60   function transfer(address to, uint value, bytes data) public returns (bool ok);
61   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
62   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
63   
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 contract BalanceManager is Serverable {
68     /** player balances **/
69     mapping(uint32 => uint64) public balances;
70     /** player blocked tokens number **/
71     mapping(uint32 => uint64) public blockedBalances;
72     /** wallet balances **/
73     mapping(address => uint64) public walletBalances;
74     /** adress users **/
75     mapping(address => uint32) public userIds;
76 
77     /** Dispatcher contract address **/
78     address public dispatcher;
79     /** service reward can be withdraw by owners **/
80     uint serviceReward;
81     /** service reward can be withdraw by owners **/
82     uint sentBonuses;
83     /** Token used to pay **/
84     ERC223 public gameToken;
85 
86     modifier onlyDispatcher() {require(msg.sender == dispatcher);
87         _;}
88 
89     event Withdraw(address _user, uint64 _amount);
90     event Deposit(address _user, uint64 _amount);
91 
92     constructor(address _gameTokenAddress) public {
93         gameToken = ERC223(_gameTokenAddress);
94     }
95 
96     function setDispatcherAddress(address _newDispatcherAddress) external onlyOwner {
97         dispatcher = _newDispatcherAddress;
98     }
99 
100     /**
101      * Deposits from user
102      */
103     function tokenFallback(address _from, uint256 _amount, bytes _data) public {
104         if (userIds[_from] > 0) {
105             balances[userIds[_from]] += uint64(_amount);
106         } else {
107             walletBalances[_from] += uint64(_amount);
108         }
109 
110         emit Deposit(_from, uint64(_amount));
111     }
112 
113     /**
114      * Register user
115      */
116     function registerUserWallet(address _user, uint32 _id) external onlyServer {
117         require(userIds[_user] == 0);
118         require(_user != owner);
119 
120         userIds[_user] = _id;
121         if (walletBalances[_user] > 0) {
122             balances[_id] += walletBalances[_user];
123             walletBalances[_user] = 0;
124         }
125     }
126 
127     /**
128      * Deposits tokens in game to some user
129      */
130     function sendTo(address _user, uint64 _amount) external {
131         require(walletBalances[msg.sender] >= _amount);
132         walletBalances[msg.sender] -= _amount;
133         if (userIds[_user] > 0) {
134             balances[userIds[_user]] += _amount;
135         } else {
136             walletBalances[_user] += _amount;
137         }
138         emit Deposit(_user, _amount);
139     }
140 
141     /**
142      * User can withdraw tokens manually in any time
143      */
144     function withdraw(uint64 _amount) external {
145         uint32 userId = userIds[msg.sender];
146         if (userId > 0) {
147             require(balances[userId] - blockedBalances[userId] >= _amount);
148             if (gameToken.transfer(msg.sender, _amount)) {
149                 balances[userId] -= _amount;
150                 emit Withdraw(msg.sender, _amount);
151             }
152         } else {
153             require(walletBalances[msg.sender] >= _amount);
154             if (gameToken.transfer(msg.sender, _amount)) {
155                 walletBalances[msg.sender] -= _amount;
156                 emit Withdraw(msg.sender, _amount);
157             }
158         }
159     }
160 
161     /**
162      * Server can withdraw tokens to user
163      */
164     function systemWithdraw(address _user, uint64 _amount) external onlyServer {
165         uint32 userId = userIds[_user];
166         require(balances[userId] - blockedBalances[userId] >= _amount);
167 
168         if (gameToken.transfer(_user, _amount)) {
169             balances[userId] -= _amount;
170             emit Withdraw(_user, _amount);
171         }
172     }
173 
174     /**
175      * Dispatcher can change user balance
176      */
177     function addUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {
178         balances[_userId] += _amount;
179     }
180 
181     /**
182      * Dispatcher can change user balance
183      */
184     function spendUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {
185         require(balances[_userId] >= _amount);
186         balances[_userId] -= _amount;
187         if (blockedBalances[_userId] > 0) {
188             if (blockedBalances[_userId] <= _amount)
189                 blockedBalances[_userId] = 0;
190             else
191                 blockedBalances[_userId] -= _amount;
192         }
193     }
194 
195     /**
196      * Server can add bonuses to users, they will take from owner balance
197      */
198     function addBonus(uint32[] _userIds, uint64[] _amounts) external onlyServer {
199         require(_userIds.length == _amounts.length);
200 
201         uint64 sum = 0;
202         for (uint32 i = 0; i < _amounts.length; i++)
203             sum += _amounts[i];
204 
205         require(walletBalances[owner] >= sum);
206         for (i = 0; i < _userIds.length; i++) {
207             balances[_userIds[i]] += _amounts[i];
208             blockedBalances[_userIds[i]] += _amounts[i];
209         }
210 
211         sentBonuses += sum;
212         walletBalances[owner] -= sum;
213     }
214 
215     /**
216      * Dispatcher can change user balance
217      */
218     function addServiceReward(uint _amount) external onlyDispatcher {
219         serviceReward += _amount;
220     }
221 
222     /**
223      * Owner withdraw service fee tokens 
224      */
225     function serviceFeeWithdraw() external onlyOwner {
226         require(serviceReward > 0);
227         if (gameToken.transfer(msg.sender, serviceReward))
228             serviceReward = 0;
229     }
230 
231     function viewSentBonuses() public view returns (uint) {
232         require(msg.sender == owner || msg.sender == server);
233         return sentBonuses;
234     }
235 
236     function viewServiceReward() public view returns (uint) {
237         require(msg.sender == owner || msg.sender == server);
238         return serviceReward;
239     }
240 }
241 
242 
243 contract BrokerManager is Ownable {
244 
245 	struct InvestTerm {
246 		uint64 amount;
247 		uint16 userFee;
248 	}
249 	/** server address **/
250 	address public server;
251 	/** invesor fees **/
252 	mapping (uint32 => mapping (uint32 => InvestTerm)) public investTerms;
253 
254 	modifier onlyServer() {require(msg.sender == server); _;}
255 
256 	function setServerAddress(address _newServerAddress) external onlyOwner {
257 		server = _newServerAddress;
258 	}
259 
260 	/**
261      * Create investition 
262      */
263 	function invest(uint32 _playerId, uint32 _investorId, uint64 _amount, uint16 _userFee) external onlyServer {
264 		require(_amount > 0 && _userFee > 0);
265 		investTerms[_investorId][_playerId] = InvestTerm(_amount, _userFee);
266 	}
267 
268 	/**
269      * Delete investition 
270      */
271 	function deleteInvest(uint32 _playerId, uint32 _investorId) external onlyServer {
272 		delete investTerms[_investorId][_playerId];
273 	}
274 }
275 
276 
277 contract Dispatcher is BrokerManager {
278 
279     enum GameState {Initialized, Started, Finished, Cancelled}
280 
281     struct GameTeam {
282         uint32 userId;
283         uint32 sponsorId;
284         uint64 prizeSum;
285         uint16 userFee;
286     }
287 
288     struct Game {
289         GameState state;
290         uint64 entryFee;
291         uint32 serviceFee;
292         uint32 registrationDueDate;
293 
294         bytes32 teamsHash;
295         bytes32 statsHash;
296 
297         uint32 teamsNumber;
298         uint64 awardSent;
299     }
300 
301     /** balance manager **/
302     BalanceManager public balanceManager;
303     /** player teams **/
304     mapping(uint32 => mapping(uint48 => GameTeam)) public teams;
305     /** games **/
306     mapping(uint32 => Game) public games;
307 
308     constructor(address _balanceManagerAddress) public {
309         balanceManager = BalanceManager(_balanceManagerAddress);
310     }
311 
312     /**
313      * Create new game
314      */
315     function createGame(
316         uint32 _gameId,
317         uint64 _entryFee,
318         uint32 _serviceFee,
319         uint32 _registrationDueDate
320     )
321     external
322     onlyServer
323     {
324         require(
325             games[_gameId].entryFee == 0
326             && _gameId > 0
327             && _entryFee > 0
328             && _registrationDueDate > 0
329         );
330         games[_gameId] = Game(GameState.Initialized, _entryFee, _serviceFee, _registrationDueDate, 0x0, 0x0, 0, 0);
331     }
332 
333     /**
334      * Participate game
335      */
336     function participateGame(
337         uint32 _gameId,
338         uint32 _teamId,
339         uint32 _userId,
340         uint32 _sponsorId
341     )
342     external
343     onlyServer
344     {
345         Game storage game = games[_gameId];
346         require(
347             _gameId > 0
348             && game.state == GameState.Initialized
349             && _teamId > 0
350             && _userId > 0
351             && teams[_gameId][_teamId].userId == 0
352             && game.registrationDueDate > uint32(now)
353         );
354 
355         uint16 userFee = 0;
356         if (_sponsorId > 0) {
357             require(balanceManager.balances(_sponsorId) >= game.entryFee && investTerms[_sponsorId][_userId].amount > game.entryFee);
358             balanceManager.spendUserBalance(_sponsorId, game.entryFee);
359             investTerms[_sponsorId][_userId].amount -= game.entryFee;
360             userFee = investTerms[_sponsorId][_userId].userFee;
361         }
362         else {
363             require(balanceManager.balances(_userId) >= game.entryFee);
364             balanceManager.spendUserBalance(_userId, game.entryFee);
365         }
366 
367         teams[_gameId][_teamId] = GameTeam(_userId, _sponsorId, 0, userFee);
368         game.teamsNumber++;
369     }
370 
371     /**
372      * Stop participate game, store teams hash
373      */
374     function startGame(uint32 _gameId, bytes32 _hash) external onlyServer {
375         Game storage game = games[_gameId];
376         require(
377             game.state == GameState.Initialized
378             && _gameId > 0
379         && _hash != 0x0
380         );
381 
382         game.teamsHash = _hash;
383         game.state = GameState.Started;
384     }
385 
386     /**
387      * Cancel game
388      */
389     function cancelGame(uint32 _gameId) external onlyServer {
390         Game storage game = games[_gameId];
391         require(
392             _gameId > 0
393             && game.state < GameState.Finished
394         );
395         game.state = GameState.Cancelled;
396     }
397 
398     /**
399      * Finish game, store stats hash
400      */
401     function finishGame(uint32 _gameId, bytes32 _hash) external onlyServer {
402         Game storage game = games[_gameId];
403         require(
404             _gameId > 0
405             && game.state < GameState.Finished
406         && _hash != 0x0
407         );
408         game.statsHash = _hash;
409         game.state = GameState.Finished;
410     }
411 
412     /**
413      * Reward winners
414      */
415     function winners(uint32 _gameId, uint32[] _teamIds, uint64[] _teamPrizes) external onlyServer {
416         Game storage game = games[_gameId];
417         require(game.state == GameState.Finished);
418 
419         uint64 sumPrize = 0;
420         for (uint32 i = 0; i < _teamPrizes.length; i++)
421             sumPrize += _teamPrizes[i];
422 
423         require(uint(sumPrize + game.awardSent) <= uint(game.entryFee * game.teamsNumber));
424 
425         for (i = 0; i < _teamIds.length; i++) {
426             uint32 teamId = _teamIds[i];
427             GameTeam storage team = teams[_gameId][teamId];
428             uint32 userId = team.userId;
429 
430             if (team.prizeSum == 0) {
431                 if (team.sponsorId > 0) {
432                     uint64 userFee = team.userFee * _teamPrizes[i] / 100;
433                     balanceManager.addUserBalance(team.sponsorId, userFee);
434                     balanceManager.addUserBalance(userId, _teamPrizes[i] - userFee);
435                     team.prizeSum = _teamPrizes[i];
436                 } else {
437                     balanceManager.addUserBalance(userId, _teamPrizes[i]);
438                     team.prizeSum = _teamPrizes[i];
439                 }
440             }
441         }
442     }
443 
444     /**
445      * Refund money for cancelled game
446      */
447     function refundCancelledGame(uint32 _gameId, uint32[] _teamIds) external onlyServer {
448         Game storage game = games[_gameId];
449         require(game.state == GameState.Cancelled);
450 
451         for (uint32 i = 0; i < _teamIds.length; i++) {
452             uint32 teamId = _teamIds[i];
453             GameTeam storage team = teams[_gameId][teamId];
454 
455             require(teams[_gameId][teamId].prizeSum == 0);
456 
457             if (team.prizeSum == 0) {
458                 if (team.sponsorId > 0) {
459                     balanceManager.addUserBalance(team.sponsorId, game.entryFee);
460                 } else {
461                     balanceManager.addUserBalance(team.userId, game.entryFee);
462                 }
463                 team.prizeSum = game.entryFee;
464             }
465         }
466     }
467 }