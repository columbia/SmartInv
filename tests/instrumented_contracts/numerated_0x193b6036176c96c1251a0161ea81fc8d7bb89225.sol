1 pragma solidity ^0.5.12;
2 
3 contract HEX {
4     function xfLobbyEnter(address referrerAddr)
5     external
6     payable;
7 
8     function xfLobbyExit(uint256 enterDay, uint256 count)
9     external;
10 
11     function xfLobbyPendingDays(address memberAddr)
12     external
13     view
14     returns (uint256[2] memory words);
15 
16     function balanceOf (address account)
17     external
18     view
19     returns (uint256);
20 
21     function transfer (address recipient, uint256 amount)
22     external
23     returns (bool);
24 
25     function currentDay ()
26     external
27     view
28     returns (uint256);
29 } // TODO: Windows file separator
30 
31 contract AutoLobby {
32 
33     event UserJoined(
34         uint40 timestamp,
35         address indexed memberAddress,
36         uint256 amount
37     );
38 
39     event LobbyJoined(
40         uint40 timestamp,
41         uint16 day,
42         uint256 amount
43     );
44 
45     event LobbyLeft(
46         uint40 timestamp,
47         uint16 day,
48         uint256 hearts
49     );
50 
51     event MissedLobby(
52         uint40 timestamp,
53         uint16 day
54     );
55 
56     struct UserState {
57         uint16 firstDayJoined;
58         uint16 nextPendingDay;
59         uint256 todayAmount;
60         uint256 nextDayAmount;
61     }
62 
63     struct ContractStateCache {
64         uint256 currentDay;
65         uint256 lastDayJoined;
66         uint256 nextPendingDay;
67         uint256 todayAmount;
68     }
69 
70     struct ContractState {
71         uint16 _lastDayJoined;
72         uint16 _nextPendingDay;
73         uint256 _todayAmount;
74         uint256 _nextDayAmount;
75     }
76 
77     struct ParticipationState {
78         uint256 poolSize;
79         uint256 heartsReceived;
80     }
81 
82     HEX internal hx = HEX(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
83 
84     uint16 internal constant LAUNCH_PHASE_DAYS = 350;
85     uint16 internal constant LAUNCH_PHASE_END_DAY = 351;
86     uint256 internal constant XF_LOBBY_DAY_WORDS = (LAUNCH_PHASE_END_DAY + 255) >> 8;
87 
88     uint256 public HEX_LAUNCH_TIME = 1575331200;
89 
90     address payable internal constant REF_ADDRESS = 0xD30BC4859A79852157211E6db19dE159673a67E2;
91 
92     ContractState public state;
93 
94     mapping(address => UserState) public userData;
95     address[] public users;
96 
97     mapping(uint256 => ParticipationState) public dailyData;
98 
99     constructor ()
100     public
101     {
102         state._nextPendingDay = 1;
103     }
104 
105     function nudge ()
106     external
107     {
108         ContractStateCache memory currentState;
109         ContractStateCache memory snapshot;
110         _loadState(currentState, snapshot);
111 
112         _nudge(currentState);
113 
114         _syncState(currentState, snapshot);
115     }
116 
117     function _nudge (ContractStateCache memory currentState)
118     internal
119     {
120         if(currentState.lastDayJoined < currentState.currentDay){
121             _joinLobby(currentState);
122         }
123     }
124 
125     function depositEth ()
126     public
127     payable
128     returns (uint256)
129     {
130         require(msg.value > 0, "Deposited ETH must be greater than 0");
131 
132         ContractStateCache memory currentState;
133         ContractStateCache memory snapshot;
134         _loadState(currentState, snapshot);
135 
136         require(currentState.currentDay < LAUNCH_PHASE_END_DAY, "Launch phase is over");
137         _nudge(currentState);
138         uint256 catchUpHearts = _handleWithdrawal(currentState, currentState.currentDay);
139         _handleDeposit(currentState);
140 
141         emit UserJoined(
142             uint40(block.timestamp),
143             msg.sender,
144             msg.value
145         );
146 
147         _syncState(currentState, snapshot);
148 
149         return catchUpHearts;
150     }
151 
152     function withdrawHex (uint256 beforeDay)
153     external
154     returns (uint256)
155     {
156         ContractStateCache memory currentState;
157         ContractStateCache memory snapshot;
158         _loadState(currentState, snapshot);
159 
160         _nudge(currentState);
161         uint256 _beforeDay = beforeDay;
162         if(beforeDay == 0 || beforeDay > currentState.currentDay){
163             _beforeDay = currentState.currentDay;
164         }
165 
166        uint256 amount = _handleWithdrawal(currentState, _beforeDay);
167 
168         _syncState(currentState, snapshot);
169 
170         return amount;
171     }
172 
173     function ()
174     external
175     payable
176     {
177         depositEth();
178     }
179 
180     function flush ()
181     external
182     {
183         require((LAUNCH_PHASE_END_DAY + 90) < _getHexContractDay(), "Flush is only allowed after 90 days post launch phase");
184         if(address(this).balance != 0){
185             REF_ADDRESS.transfer(address(this).balance);
186         }
187         uint256 hexBalance = hx.balanceOf(address(this));
188         if(hexBalance > 0){
189             hx.transfer(REF_ADDRESS, hexBalance);
190         }
191     }
192 
193     function getHexContractDay()
194     public
195     view
196     returns (uint256)
197     {
198         return _getHexContractDay();
199     }
200 
201     function getUsers()
202     public
203     view
204     returns(uint256) {
205         return users.length;
206     }
207 
208     function getUserId(uint256 idx)
209     public
210     view
211     returns(address) {
212         return users[idx];
213     }
214 
215     function getUserData(address addr)
216     public
217     view
218     returns(uint16,
219         uint16,
220         uint256,
221         uint256) {
222         return (userData[addr].firstDayJoined,
223         userData[addr].nextPendingDay,
224         userData[addr].todayAmount,
225         userData[addr].nextDayAmount);
226     }
227 
228     function _joinLobby (ContractStateCache memory currentState)
229     private
230     {
231         if(currentState.lastDayJoined < currentState.currentDay){
232             uint256 budget = currentState.todayAmount;
233             if(budget > 0){
234                 uint256 remainingFraction = _calcDailyFractionRemaining(budget, currentState.currentDay);
235                 uint256 contribution = budget - remainingFraction;
236                 require(contribution > 0, "daily contribution must be greater than 0");
237                 hx.xfLobbyEnter.value(contribution)(REF_ADDRESS);
238                 currentState.lastDayJoined = currentState.currentDay;
239                 dailyData[currentState.currentDay] = ParticipationState(budget, 0);
240                 currentState.todayAmount -= contribution;
241                 emit LobbyJoined(
242                     uint40(block.timestamp),
243                     uint16(currentState.currentDay),
244                     contribution);
245             }
246         }
247     }
248 
249     function _handleWithdrawal(ContractStateCache memory currentState, uint256 beforeDay)
250     private
251     returns (uint256)
252     {
253         _leaveLobbies(currentState, beforeDay);
254         return _distributeShare(beforeDay);
255     }
256 
257     function _handleDeposit(ContractStateCache memory currentState)
258     private
259     {
260         UserState storage user = userData[msg.sender];
261         // new user
262         if(user.firstDayJoined == 0){
263             uint16 nextDay = uint16(currentState.currentDay + 1);
264             user.firstDayJoined = nextDay;
265             user.nextPendingDay = nextDay;
266             user.todayAmount += msg.value;
267             users.push(msg.sender) -1;
268         } else {
269             user.nextDayAmount += msg.value;
270         }
271 
272         currentState.todayAmount += msg.value;
273     }
274 
275     function _leaveLobbies(ContractStateCache memory currentState, uint256 beforeDay)
276     private
277     {
278         uint256 newBalance = hx.balanceOf(address(this));
279         uint256 oldBalance;
280         if(currentState.nextPendingDay < beforeDay){
281             uint256[XF_LOBBY_DAY_WORDS] memory joinedDays = hx.xfLobbyPendingDays(address(this));
282             while(currentState.nextPendingDay < beforeDay){
283                 if( (joinedDays[currentState.nextPendingDay >> 8] & (1 << (currentState.nextPendingDay & 255))) >>
284                     (currentState.nextPendingDay & 255) == 1){
285                     hx.xfLobbyExit(currentState.nextPendingDay, 0);
286                     oldBalance = newBalance;
287                     newBalance = hx.balanceOf(address(this));
288                     dailyData[currentState.nextPendingDay].heartsReceived = newBalance - oldBalance;
289                     require(dailyData[currentState.nextPendingDay].heartsReceived > 0, "Hearts received for a lobby is 0");
290                     emit LobbyLeft(uint40(block.timestamp),
291                         uint16(currentState.nextPendingDay),
292                         dailyData[currentState.nextPendingDay].heartsReceived);
293                 } else {
294                     emit MissedLobby(uint40(block.timestamp),
295                      uint16(currentState.nextPendingDay));
296                 }
297                 currentState.nextPendingDay++;
298             }
299         }
300     }
301 
302     function _distributeShare(uint256 endDay)
303     private
304     returns (uint256)
305     {
306         uint256 totalShare = 0;
307 
308         UserState storage user = userData[msg.sender];
309 
310         if(user.firstDayJoined > 0 && user.firstDayJoined < endDay){
311             if(user.nextPendingDay < user.firstDayJoined){
312                 user.nextPendingDay = user.firstDayJoined;
313             }
314             uint256 userContribution;
315             while(user.nextPendingDay < endDay){
316                 if(dailyData[user.nextPendingDay].poolSize > 0 && dailyData[user.nextPendingDay].heartsReceived > 0){
317                     require(dailyData[user.nextPendingDay].heartsReceived > 0, "Hearts received must be > 0, leave lobby for day");
318 
319                     userContribution = user.todayAmount - _calcDailyFractionRemaining(user.todayAmount, user.nextPendingDay);
320                     totalShare += user.todayAmount *
321                         dailyData[user.nextPendingDay].heartsReceived /
322                         dailyData[user.nextPendingDay].poolSize;
323                     user.todayAmount -= userContribution;
324                     if(user.nextDayAmount > 0){
325                         user.todayAmount += user.nextDayAmount;
326                         user.nextDayAmount = 0;
327                     }
328                 }
329                 user.nextPendingDay++;
330             }
331             if(totalShare > 0){
332                 require(hx.transfer(msg.sender, totalShare), strConcat("Failed to transfer ",uint2str(totalShare),", insufficient balance"));
333             }
334         }
335 
336         return totalShare;
337     }
338 
339     function _getHexContractDay()
340     private
341     view
342     returns (uint256)
343     {
344         require(HEX_LAUNCH_TIME < block.timestamp, "AutoLobby: Launch time not before current block");
345         return (block.timestamp - HEX_LAUNCH_TIME) / 1 days;
346     }
347 
348     function _calcDailyFractionRemaining(uint256 amount, uint256 day)
349     private
350     pure
351     returns (uint256)
352     {
353         if(day >= LAUNCH_PHASE_DAYS){
354             return 0;
355         }
356         return amount * (LAUNCH_PHASE_END_DAY - day - 1) / (LAUNCH_PHASE_END_DAY - day);
357     }
358 
359     function _calcDailyFractionRemainingAgg(uint256 amount, uint256 day)
360     private
361     pure
362     returns (uint256)
363     {
364         if(day >= LAUNCH_PHASE_DAYS){
365             return 0;
366         } else if( amount >= (LAUNCH_PHASE_END_DAY - day)) {
367             return amount * (LAUNCH_PHASE_END_DAY - day - 1) / (LAUNCH_PHASE_END_DAY - day);
368         } else {
369             return amount / (LAUNCH_PHASE_END_DAY - day) * (LAUNCH_PHASE_END_DAY - day - 1) ;
370         }
371     }
372 
373     function _loadState(ContractStateCache memory c, ContractStateCache memory snapshot)
374     internal
375     view
376     {
377         c.currentDay = _getHexContractDay();
378         c.lastDayJoined = state._lastDayJoined;
379         c.nextPendingDay = state._nextPendingDay;
380         c.todayAmount = state._todayAmount;
381         _takeSnapshot(c, snapshot);
382     }
383 
384     function _takeSnapshot(ContractStateCache memory c, ContractStateCache memory snapshot)
385     internal
386     pure
387     {
388         snapshot.currentDay = c.currentDay;
389         snapshot.lastDayJoined = c.lastDayJoined;
390         snapshot.nextPendingDay = c.nextPendingDay;
391         snapshot.todayAmount = c.todayAmount;
392     }
393 
394     function _syncState(ContractStateCache memory c, ContractStateCache memory snapshot)
395     internal
396     {
397         if(snapshot.currentDay != c.currentDay ||
398         snapshot.lastDayJoined != c.lastDayJoined ||
399         snapshot.nextPendingDay != c.nextPendingDay ||
400         snapshot.todayAmount != c.todayAmount)
401         {
402             _saveState(c);
403         }
404     }
405 
406     function _saveState(ContractStateCache memory c)
407     internal
408     {
409         state._lastDayJoined = uint16(c.lastDayJoined);
410         state._nextPendingDay = uint16(c.nextPendingDay);
411         state._todayAmount = c.todayAmount;
412     }
413 
414     function uint2str(uint i)
415     internal
416     pure returns (string memory _uintAsString)
417     {
418         uint _i = i;
419         if (_i == 0) {
420             return "0";
421         }
422         uint j = _i;
423         uint len;
424         while (j != 0) {
425             len++;
426             j /= 10;
427         }
428         bytes memory bstr = new bytes(len);
429         uint k = len - 1;
430         while (_i != 0) {
431             bstr[k--] = byte(uint8(48 + _i % 10));
432             _i /= 10;
433         }
434         return string(bstr);
435     }
436 
437     function strConcat(string memory _a, string memory _b, string memory _c
438     , string memory _d, string memory _e)
439     private
440     pure
441     returns (string memory){
442     bytes memory _ba = bytes(_a);
443     bytes memory _bb = bytes(_b);
444     bytes memory _bc = bytes(_c);
445     bytes memory _bd = bytes(_d);
446     bytes memory _be = bytes(_e);
447     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
448     bytes memory babcde = bytes(abcde);
449     uint k = 0;
450     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
451     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
452     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
453     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
454     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
455     return string(babcde);
456     }
457 
458     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d)
459     private
460     pure
461     returns (string memory) {
462         return strConcat(_a, _b, _c, _d, "");
463     }
464 
465     function strConcat(string memory _a, string memory _b, string memory _c)
466     private
467     pure
468     returns (string memory) {
469         return strConcat(_a, _b, _c, "", "");
470     }
471 
472     function strConcat(string memory _a, string memory _b)
473     private
474     pure
475     returns (string memory) {
476         return strConcat(_a, _b, "", "", "");
477     }
478 }