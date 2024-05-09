1 pragma solidity ^0.4.25;
2 
3 contract EthCrystal
4 {
5 
6     /*
7         EthCrystal.com
8         Thanks for choosing us!
9 
10         ███████╗████████╗██╗  ██╗ ██████╗██████╗ ██╗   ██╗███████╗████████╗ █████╗ ██╗         ██████╗ ██████╗ ███╗   ███╗
11         ██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔══██╗██║        ██╔════╝██╔═══██╗████╗ ████║
12         █████╗     ██║   ███████║██║     ██████╔╝ ╚████╔╝ ███████╗   ██║   ███████║██║        ██║     ██║   ██║██╔████╔██║
13         ██╔══╝     ██║   ██╔══██║██║     ██╔══██╗  ╚██╔╝  ╚════██║   ██║   ██╔══██║██║        ██║     ██║   ██║██║╚██╔╝██║
14         ███████╗   ██║   ██║  ██║╚██████╗██║  ██║   ██║   ███████║   ██║   ██║  ██║███████╗██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
15         ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝
16 
17         #######               #####
18         #       ##### #    # #     # #####  #   #  ####  #####   ##   #           ####   ####  #    #
19         #         #   #    # #       #    #  # #  #        #    #  #  #          #    # #    # ##  ##
20         #####     #   ###### #       #    #   #    ####    #   #    # #          #      #    # # ## #
21         #         #   #    # #       #####    #        #   #   ###### #      ### #      #    # #    #
22         #         #   #    # #     # #   #    #   #    #   #   #    # #      ### #    # #    # #    #
23         #######   #   #    #  #####  #    #   #    ####    #   #    # ###### ###  ####   ####  #    #
24 
25         Telegram: t.me/EthCrystalGame
26 
27     */
28     using SafeMath for *;
29 
30     struct TowersInfoList {
31         string name;
32         uint256 timeLimit; // The maximum time increasement
33         uint256 warriorToTime;
34         uint256 currentRoundID;
35         uint256 timerType;
36         uint256 growthCoefficient;
37         uint256 winnerShare; // % to the winner after the round [Active Fond]
38         uint256 nextRound; // % to the next round pot
39         uint256 dividendShare; // % as dividends to holders after the round
40 
41         mapping (uint256 => TowersInfo) RoundList;
42     }
43 
44     struct TowersInfo {
45         uint256 roundID;
46         uint256 towerBalance; // Balance for distribution in the end
47         uint256 totalBalance; // Total balance with referrer or dev %
48         uint256 totalWarriors;
49         uint256 timeToFinish;
50         uint256 timeLimit; // The maximum increasement
51         uint256 warriorToTime;
52         uint256 bonusPot; // % of tower balance from the previous round
53         address lastPlayer;
54         bool potReceived;
55         bool finished;
56     }
57 
58     struct PlayerInfo {
59         uint256 playerID;
60         address playerAddress;
61         address referralAddress;
62         string nickname;
63         mapping (uint256 => TowersRoundInfo) TowersList;
64     }
65 
66     struct TowersRoundInfo {
67         uint256 _TowerType;
68         mapping (uint256 => PlayerRoundInfo) RoundList;
69     }
70 
71     struct PlayerRoundInfo {
72         uint256 warriors;
73         uint256 cashedOut; // To Allow cashing out before the game finished
74     }
75 
76 
77     struct ReferralInfo {
78         uint256 balance;
79     }
80 
81     uint256 public playerID_counter = 1;
82 
83     uint256 public devShare = 5; // % to devs
84     uint256 public affShare = 10; // bounty % to reffers
85 
86     mapping (uint256 => PlayerInfo) public playersByID;
87     mapping (address => PlayerInfo) public players;
88     mapping (address => ReferralInfo) public aff;
89 
90     mapping (uint256 => TowersInfoList) public GameRounds;
91 
92     address public ownerAddress;
93     
94     event BuyEvent(address player, uint256 TowerID, uint256 RoundID, uint256 TotalWarriors, uint256 WarriorPrice, uint256 TimeLeft);
95 
96     constructor() public {
97         ownerAddress = msg.sender;
98 
99         // Creating different towers
100         GameRounds[0] = TowersInfoList("Crystal Tower", 60*60*24,  30, 0, 2,      10000000000000,     35, 15, 50);
101         GameRounds[1] = TowersInfoList("Red Tower",     60*60*24,  60, 0, 2,      20000000000000,     25,  5, 70);
102         GameRounds[2] = TowersInfoList("Gold Tower",    60*60*12,  60*2, 0, 2,   250000000000000,     40, 10, 50);
103         GameRounds[3] = TowersInfoList("Purple Tower",  60*60*24,  60*10, 0, 2, 5000000000000000,     30, 10, 60);
104         GameRounds[4] = TowersInfoList("Silver Tower",  60*60*12,  60*2, 0, 2,  1000000000000000,     35, 15, 50);
105         GameRounds[5] = TowersInfoList("Black Tower",   60*60*12,  30, 0, 2,    1000000000000000,     65, 10, 25);
106         GameRounds[6] = TowersInfoList("Toxic Tower",   60*60*24,  60, 0, 2,    2000000000000000,     65, 10, 25);
107 
108 
109         newRound(0);
110         newRound(1);
111         newRound(2);
112         newRound(3);
113         newRound(4);
114         newRound(5);
115         newRound(6);
116     }
117 
118     function newRound (uint256 _TowerType) private {
119         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].finished = true;
120         GameRounds[_TowerType].currentRoundID++;
121         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID] = TowersInfo(GameRounds[_TowerType].currentRoundID, 0, 0, 0, now+GameRounds[_TowerType].timeLimit, GameRounds[_TowerType].timeLimit, GameRounds[_TowerType].warriorToTime,
122         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID-1].towerBalance*GameRounds[_TowerType].nextRound/100, // Moving nextRound% of the finished round balance to the next round
123         0x0, false, false); // New round
124     }
125 
126     function buyWarriors (uint256 _TowerType, uint _WarriorsAmount, uint256 _referralID) public payable {
127         require (msg.value > 10000000); // To prevent % abusing
128         require (_WarriorsAmount >= 1 && _WarriorsAmount < 1000000000); // The limitation of the amount of warriors being bought in 1 time
129         require (GameRounds[_TowerType].timeLimit > 0);
130 
131         if (players[msg.sender].playerID == 0){ // this is the new player
132             if (_referralID > 0 && _referralID != players[msg.sender].playerID && _referralID == playersByID[_referralID].playerID){
133             setNickname("", playersByID[_referralID].playerAddress);  // creating the new player...
134             }else{
135             setNickname("", ownerAddress);
136             }
137         }
138 
139         if (GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish < now){
140             // The game was ended. Starting the new game...
141 
142             // Sending pot to the winner
143             aff[GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer].balance += GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].towerBalance*GameRounds[_TowerType].winnerShare/100;
144 
145             // Sending the bonus pot to the winner
146             aff[GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer].balance += GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].bonusPot;
147 
148             newRound(_TowerType);
149             //Event Winner and the new round
150             //return;
151         }
152 
153         // Getting the price of the current warrior
154         uint256 _totalWarriors = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors;
155         uint256 _warriorPrice = (_totalWarriors+1)*GameRounds[_TowerType].growthCoefficient; // Warrior Price
156 
157         uint256 _value = (_WarriorsAmount*_warriorPrice)+(((_WarriorsAmount-1)*(_WarriorsAmount-1)+_WarriorsAmount-1)/2)*GameRounds[_TowerType].growthCoefficient;
158 
159         require (msg.value >= _value); // Player pays enough
160 
161         uint256 _ethToTake = affShare+devShare; // 15%
162 
163 
164         players[msg.sender].TowersList[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].warriors += _WarriorsAmount;
165 
166         if (players[players[msg.sender].referralAddress].playerID > 0 && players[msg.sender].referralAddress != ownerAddress){
167             // To referrer and devs
168             aff[players[msg.sender].referralAddress].balance += _value*affShare/100; // 10%
169             aff[ownerAddress].balance += _value*devShare/100; // 5%
170         } else {
171             // To devs only
172             _ethToTake = affShare;
173             aff[ownerAddress].balance += _value*_ethToTake/100; // 10%
174         }
175 
176         if (msg.value-_value > 0){
177             aff[msg.sender].balance += msg.value-_value; // Returning to player the rest of eth
178         }
179 
180         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].towerBalance += _value*(100-_ethToTake)/100; // 10-15%
181         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalBalance += _value;
182         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors += _WarriorsAmount;
183         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer = msg.sender;
184 
185         // Timer increasement
186         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish += (_WarriorsAmount).mul(GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].warriorToTime);
187 
188         // if the finish time is longer than the finish
189         if (GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish > now+GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeLimit){
190             GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish = now+GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeLimit;
191         }
192         
193         uint256 TotalWarriors = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors;
194         uint256 TimeLeft = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish;
195         
196         // Event about the new potential winner and some Tower Details
197         emit BuyEvent(msg.sender,
198         _TowerType,
199         GameRounds[_TowerType].currentRoundID,
200         TotalWarriors,
201         (TotalWarriors+1)*GameRounds[_TowerType].growthCoefficient,
202         TimeLeft);
203         
204         return;
205     }
206 
207     function dividendCashout (uint256 _TowerType, uint256 _RoundID) public {
208         require (GameRounds[_TowerType].timeLimit > 0);
209 
210         uint256 _warriors = players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].warriors;
211         require (_warriors > 0);
212         uint256 _totalEarned = _warriors*GameRounds[_TowerType].RoundList[_RoundID].towerBalance*GameRounds[_TowerType].dividendShare/GameRounds[_TowerType].RoundList[_RoundID].totalWarriors/100;
213         uint256 _alreadyCashedOut = players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut;
214         uint256 _earnedNow = _totalEarned-_alreadyCashedOut;
215         require (_earnedNow > 0); // The total amount of dividends haven't been received by the player yet
216 
217         players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut = _totalEarned;
218 
219         if (!msg.sender.send(_earnedNow)){
220             players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut = _alreadyCashedOut;
221         }
222         return;
223     }
224 
225     function referralCashout () public {
226         require (aff[msg.sender].balance > 0);
227 
228         uint256 _balance = aff[msg.sender].balance;
229 
230         aff[msg.sender].balance = 0;
231 
232         if (!msg.sender.send(_balance)){
233             aff[msg.sender].balance = _balance;
234         }
235     }
236 
237     function setNickname (string nickname, address _referralAddress)
238     public {
239         if (players[msg.sender].playerID == 0){
240             players[msg.sender] = PlayerInfo (playerID_counter, msg.sender, _referralAddress, nickname);
241             playersByID[playerID_counter] = PlayerInfo (playerID_counter, msg.sender, _referralAddress, nickname);
242             playerID_counter++;
243         }else{
244             players[msg.sender].nickname = nickname;
245             playersByID[players[msg.sender].playerID].nickname = nickname;
246         }
247     }
248 
249     function _playerRoundsInfo (address _playerAddress, uint256 _TowerType, uint256 _RoundID)
250     public
251     view
252     returns (uint256, uint256, uint256, uint256, uint256, bool, address) {
253         uint256 _warriors = players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].warriors;
254         TowersInfo memory r = GameRounds[_TowerType].RoundList[_RoundID];
255         uint256 _totalForCashOut = (_warriors*r.towerBalance*GameRounds[_RoundID].dividendShare/r.totalWarriors/100);
256         bool isFinished = true;
257         if (GameRounds[_TowerType].RoundList[_RoundID].timeToFinish > now){
258             isFinished = false;
259         }
260         return (
261         r.towerBalance*GameRounds[_TowerType].winnerShare/100,
262         _currentPlayerAmountUnclaimed(_playerAddress, _TowerType, _RoundID),
263         _totalForCashOut,
264         _warriors,
265         r.totalWarriors,
266         isFinished,
267         r.lastPlayer);
268     }
269 
270     function _currentWarriorPrice (uint256 _TowerType)
271     public
272     view
273     returns (uint256) {
274         return ((GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors+1)*GameRounds[_TowerType].growthCoefficient);
275     }
276 
277     function _currentPlayerAmountUnclaimed (address _playerAddress, uint256 _TowerType, uint256 _RoundID)
278     public
279     view
280     returns (uint256) {
281         if (_RoundID == 0){
282             _RoundID = GameRounds[_TowerType].currentRoundID;
283         }
284         uint256 _warriors = players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].warriors;
285         uint256 _totalForCashOut = (_warriors*GameRounds[_TowerType].RoundList[_RoundID].towerBalance*GameRounds[_RoundID].dividendShare/GameRounds[_TowerType].RoundList[_RoundID].totalWarriors/100);
286         uint256 _unclaimedAmount = _totalForCashOut-players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].cashedOut;
287         return (_unclaimedAmount);
288     }
289 
290     function _currentPlayerAmountUnclaimedAll (address _playerAddress)
291     public
292     view
293     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
294         return (_currentPlayerAmountUnclaimed(_playerAddress, 0, 1),
295         _currentPlayerAmountUnclaimed(_playerAddress, 1, 1),
296         _currentPlayerAmountUnclaimed(_playerAddress, 2, 1),
297         _currentPlayerAmountUnclaimed(_playerAddress, 3, 1),
298         _currentPlayerAmountUnclaimed(_playerAddress, 4, 1),
299         _currentPlayerAmountUnclaimed(_playerAddress, 5, 1),
300         _currentPlayerAmountUnclaimed(_playerAddress, 6, 1));
301     }
302     /*
303         Gets the player details by IDs
304     */
305 
306     function _playerInfo (uint256 _playerID)
307     public
308     view
309     returns (uint256, address, string, uint256) {
310         return (playersByID[_playerID].playerID,
311         playersByID[_playerID].playerAddress,
312         playersByID[_playerID].nickname,
313         aff[playersByID[_playerID].playerAddress].balance);
314     }
315     
316     function WarriorTotalPrice (uint256 _WarriorsAmount, uint256 _warriorPrice, uint256 coef)
317     public
318     pure
319     returns (uint256) {
320         return (_WarriorsAmount*_warriorPrice)+(((_WarriorsAmount-1)*(_WarriorsAmount-1)+_WarriorsAmount-1)/2)*coef;
321     }
322     
323 
324 
325     function _playerBalance (address _playerAddress)
326     public
327     view
328     returns (uint256) {
329         return aff[_playerAddress].balance;
330     }
331 
332     /*
333         Gets the tower's details by round IDs
334     */
335     function _TowerRoundDetails (uint256 _TowerType, uint256 _RoundID)
336     public
337     view
338     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bool, bool) {
339         TowersInfo memory r = GameRounds[_TowerType].RoundList[_RoundID];
340         return (
341         r.roundID,
342         r.towerBalance,
343         r.totalBalance,
344         r.totalWarriors,
345         r.timeToFinish,
346         r.timeLimit,
347         r.warriorToTime,
348         r.bonusPot,
349         r.lastPlayer,
350         r.potReceived,
351         r.finished
352         );
353     }
354 }
355 
356 library SafeMath {
357 
358     /**
359     * @dev Multiplies two numbers, throws on overflow.
360     */
361     function mul(uint256 a, uint256 b)
362         internal
363         pure
364         returns (uint256 c)
365     {
366         if (a == 0) {
367             return 0;
368         }
369         c = a * b;
370         require(c / a == b, "SafeMath mul failed");
371         return c;
372     }
373 
374     /**
375     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
376     */
377     function sub(uint256 a, uint256 b)
378         internal
379         pure
380         returns (uint256)
381     {
382         require(b <= a, "SafeMath sub failed");
383         return a - b;
384     }
385 
386     /**
387     * @dev Adds two numbers, throws on overflow.
388     */
389     function add(uint256 a, uint256 b)
390         internal
391         pure
392         returns (uint256 c)
393     {
394         c = a + b;
395         require(c >= a, "SafeMath add failed");
396         return c;
397     }
398 
399     /**
400      * @dev gives square root of given x.
401      */
402     function sqrt(uint256 x)
403         internal
404         pure
405         returns (uint256 y)
406     {
407         uint256 z = ((add(x,1)) / 2);
408         y = x;
409         while (z < y)
410         {
411             y = z;
412             z = ((add((x / z),z)) / 2);
413         }
414     }
415 
416     /**
417      * @dev gives square. multiplies x by x
418      */
419     function sq(uint256 x)
420         internal
421         pure
422         returns (uint256)
423     {
424         return (mul(x,x));
425     }
426 
427     /**
428      * @dev x to the power of y
429      */
430     function pwr(uint256 x, uint256 y)
431         internal
432         pure
433         returns (uint256)
434     {
435         if (x==0)
436             return (0);
437         else if (y==0)
438             return (1);
439         else
440         {
441             uint256 z = x;
442             for (uint256 i=1; i < y; i++)
443                 z = mul(z,x);
444             return (z);
445         }
446     }
447 }