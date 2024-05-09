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
27         This is the second versoin of our smart-contract.
28         We have fixed all bugs and set the new speed values for Rounds so it is easier for users to play.
29         The first smart-contract address is: 0x5c6d8bb345f4299c76f24fc771ef04dd160c4d36
30         
31         There is no code which can be only executed by the contract creators.
32 
33     */
34     using SafeMath for *;
35 
36     // Tower Type details
37     struct TowersInfoList {
38         string name; // Tower name
39         uint256 timeLimit; // Maximum time increasement
40         uint256 warriorToTime; // Amount of seconds each warrior adds
41         uint256 currentRoundID; // Current Round ID
42         uint256 growthCoefficient; // Each warrior being bought increases the price of the next warrior. 
43         uint256 winnerShare; // % to winner after the round [Active Fond]
44         uint256 nextRound; // % to next round pot
45         uint256 dividendShare; // % as dividends to holders after the round
46 
47         mapping (uint256 => TowersInfo) RoundList; // Here the Rounds for each Tower are stored
48     }
49     
50     // Round details
51     struct TowersInfo {
52         uint256 roundID; // The Current Round ID
53         uint256 towerBalance; // Balance for distribution in the end
54         uint256 totalBalance; // Total balance with referrer or dev %
55         uint256 totalWarriors; // Total warriors being bought
56         uint256 timeToFinish; // The time when the round will be finished
57         uint256 timeLimit; // The maximum increasement
58         uint256 warriorToTime; // Amount of seconds each warrior adds
59         uint256 bonusPot; // % of tower balance from the previous round
60         address lastPlayer; // The last player bought warriors
61     }
62 
63     // Player Details
64     struct PlayerInfo {
65         uint256 playerID; // Player's Unique Identifier
66         address playerAddress; // Player's Ethereum Address
67         address referralAddress; // Store the Ethereum Address of the referrer
68         string nickname; // Player's Nickname
69         mapping (uint256 => TowersRoundInfo) TowersList;
70     }
71 
72     
73     struct TowersRoundInfo {
74         uint256 _TowerType;
75         mapping (uint256 => PlayerRoundInfo) RoundList;
76     }
77     
78     // All player's warriors for a particular Round
79     struct PlayerRoundInfo {
80         uint256 warriors;
81         uint256 cashedOut; // To Allow cashing out before the game finished
82     }
83     
84     // In-Game balance (Returnings + Referral Payings)
85     struct ReferralInfo {
86         uint256 balance;
87     }
88 
89     uint256 public playerID_counter = 1; // The Unique Identifier for the next created player
90 
91     uint256 public devShare = 5; // % to devs
92     uint256 public affShare = 10; // bounty % to reffers
93 
94     mapping (address => PlayerInfo) public players; // Storage for players
95     mapping (uint256 => PlayerInfo) public playersByID; // Duplicate of the storage for players
96 
97     mapping (address => ReferralInfo) public aff; // Storage for player refferal and returnings balances.
98 
99     mapping (uint256 => TowersInfoList) public GameRounds; // Storage for Tower Rounds
100 
101     address public ownerAddress; // The address of the contract creator
102     
103     event BuyEvent(address player, uint256 TowerID, uint256 RoundID, uint256 TotalWarriors, uint256 WarriorPrice, uint256 TimeLeft);
104 
105     constructor() public {
106         ownerAddress = msg.sender; // Setting the address of the contact creator
107 
108         // Creating Tower Types
109         GameRounds[0] = TowersInfoList("Crystal Tower", 60*60*3,  60*3, 0,      10000000000000,     35, 15, 50);
110         GameRounds[1] = TowersInfoList("Red Tower",     60*60*3,  60*3, 0,      20000000000000,     25,  5, 70);
111         GameRounds[2] = TowersInfoList("Gold Tower",    60*60*3,  60*3, 0,     250000000000000,     40, 10, 50);
112         GameRounds[3] = TowersInfoList("Purple Tower",  60*60*6,  60*3, 0,    5000000000000000,     30, 10, 60);
113         GameRounds[4] = TowersInfoList("Silver Tower",  60*60*6,  60*3, 0,    1000000000000000,     35, 15, 50);
114         GameRounds[5] = TowersInfoList("Black Tower",   60*60*6,  60*3, 0,    1000000000000000,     65, 10, 25);
115         GameRounds[6] = TowersInfoList("Toxic Tower",   60*60*6,  60*3, 0,    2000000000000000,     65, 10, 25);
116 
117         // Creating first Rounds for each Tower Type
118         newRound(0);
119         newRound(1);
120         newRound(2);
121         newRound(3);
122         newRound(4);
123         newRound(5);
124         newRound(6);
125     }
126 
127     /**
128      * @dev Creates a new Round of a paricular Tower
129      * @param _TowerType the tower type (0 to 6)
130      */
131     function newRound (uint256 _TowerType) private {
132         GameRounds[_TowerType].currentRoundID++;
133         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID] = TowersInfo(GameRounds[_TowerType].currentRoundID, 0, 0, 0, now+GameRounds[_TowerType].timeLimit, GameRounds[_TowerType].timeLimit, GameRounds[_TowerType].warriorToTime,
134         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID-1].towerBalance*GameRounds[_TowerType].nextRound/100, // Moving nextRound% of the finished round balance to the next round
135         0x0); // New round
136     }
137     
138     
139     /**
140      * @dev Use to buy warriors for the current round of a particular Tower
141      * When the Round ends, somebody have to buy 1 warrior to start the new round.
142      * All ETH the player overpaid will be sent back to his balance ("referralBalance").
143      * @param _TowerType the tower type (0 to 6)
144      * @param _WarriorsAmount the amoun of warriors player would like to buy (at least 1)
145      * @param _referralID Default Value: 0. The ID of the player which will receive the 10% of the warriors cost.
146      */
147     function buyWarriors (uint256 _TowerType, uint _WarriorsAmount, uint256 _referralID) public payable {
148         require (msg.value > 10000000); // To prevent % abusing
149         require (_WarriorsAmount >= 1 && _WarriorsAmount < 1000000000); // The limitation of the amount of warriors being bought in 1 time
150         require (GameRounds[_TowerType].timeLimit > 0); // Checking if the _TowerType exists
151 
152         if (players[msg.sender].playerID == 0){ // this is the new player
153             if (_referralID > 0 && _referralID != players[msg.sender].playerID && _referralID == playersByID[_referralID].playerID){
154                 setNickname("", playersByID[_referralID].playerAddress);  // Creating a new player...
155             }else{
156                 setNickname("", ownerAddress);
157             }
158         }
159 
160         if (GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish < now){
161             // The game was ended. Starting the new game...
162 
163             // Sending pot to the winner
164             aff[GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer].balance += GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].towerBalance*GameRounds[_TowerType].winnerShare/100;
165 
166             // Sending the bonus pot to the winner
167             aff[GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer].balance += GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].bonusPot;
168 
169             newRound(_TowerType);
170             //Event Winner and the new round
171             //return;
172         }
173 
174         // Getting the price of the current warrior
175         uint256 _totalWarriors = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors;
176         uint256 _warriorPrice = (_totalWarriors+1)*GameRounds[_TowerType].growthCoefficient; // Warrior Price
177 
178         uint256 _value = (_WarriorsAmount*_warriorPrice)+(((_WarriorsAmount-1)*(_WarriorsAmount-1)+_WarriorsAmount-1)/2)*GameRounds[_TowerType].growthCoefficient;
179 
180         require (msg.value >= _value); // Player pays enough
181 
182         uint256 _ethToTake = affShare+devShare; // 15%
183 
184 
185         players[msg.sender].TowersList[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].warriors += _WarriorsAmount;
186 
187         if (players[players[msg.sender].referralAddress].playerID > 0 && players[msg.sender].referralAddress != ownerAddress){
188             // To referrer and devs. In this case, referrer gets 10%, devs get 5%
189             aff[players[msg.sender].referralAddress].balance += _value*affShare/100; // 10%
190             aff[ownerAddress].balance += _value*devShare/100; // 5%
191         } else {
192             // To devs only. In this case, devs get 10%
193             _ethToTake = affShare;
194             aff[ownerAddress].balance += _value*_ethToTake/100; // 10%
195         }
196 
197         if (msg.value-_value > 0){
198             aff[msg.sender].balance += msg.value-_value; // Returning to player the rest of eth
199         }
200 
201         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].towerBalance += _value*(100-_ethToTake)/100; // 10-15%
202         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalBalance += _value;
203         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors += _WarriorsAmount;
204         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].lastPlayer = msg.sender;
205 
206         // Timer increasement
207         GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish += (_WarriorsAmount).mul(GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].warriorToTime);
208 
209         // if the finish time is longer than the finish
210         if (GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish > now+GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeLimit){
211             GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish = now+GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeLimit;
212         }
213         
214         uint256 TotalWarriors = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].totalWarriors;
215         uint256 TimeLeft = GameRounds[_TowerType].RoundList[GameRounds[_TowerType].currentRoundID].timeToFinish;
216         
217         // Event about the new potential winner and some Tower Details
218         emit BuyEvent(msg.sender,
219         _TowerType,
220         GameRounds[_TowerType].currentRoundID,
221         TotalWarriors,
222         (TotalWarriors+1)*GameRounds[_TowerType].growthCoefficient,
223         TimeLeft);
224         
225         return;
226     }
227 
228     /**
229      * @dev Claim the player's dividends of any round.
230      * @param _TowerType the tower type (0 to 6)
231      * @param _RoundID the round ID
232      */
233     function dividendCashout (uint256 _TowerType, uint256 _RoundID) public {
234         require (GameRounds[_TowerType].timeLimit > 0);
235 
236         uint256 _warriors = players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].warriors;
237         require (_warriors > 0);
238         uint256 _totalEarned = _warriors*GameRounds[_TowerType].RoundList[_RoundID].towerBalance*GameRounds[_TowerType].dividendShare/GameRounds[_TowerType].RoundList[_RoundID].totalWarriors/100;
239         uint256 _alreadyCashedOut = players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut;
240         uint256 _earnedNow = _totalEarned-_alreadyCashedOut;
241         require (_earnedNow > 0); // The total amount of dividends haven't been received by the player yet
242 
243         players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut = _totalEarned;
244 
245         if (!msg.sender.send(_earnedNow)){
246             players[msg.sender].TowersList[_TowerType].RoundList[_RoundID].cashedOut = _alreadyCashedOut;
247         }
248         return;
249     }
250 
251     /**
252      * @dev Claim the player's In-Game balance such as returnings and referral payings.
253      */
254     function referralCashout () public {
255         require (aff[msg.sender].balance > 0);
256 
257         uint256 _balance = aff[msg.sender].balance;
258 
259         aff[msg.sender].balance = 0;
260 
261         if (!msg.sender.send(_balance)){
262             aff[msg.sender].balance = _balance;
263         }
264     }
265 
266     /**
267      * @dev Creates the new account
268      * @param nickname the nickname player would like to use (better to leave it empty)
269      * @param _referralAddress (the address of the player who invited the user)
270      */
271     function setNickname (string nickname, address _referralAddress)
272     public {
273         if (players[msg.sender].playerID == 0){
274             players[msg.sender] = PlayerInfo (playerID_counter, msg.sender, _referralAddress, nickname);
275             playersByID[playerID_counter] = PlayerInfo (playerID_counter, msg.sender, _referralAddress, nickname);
276             playerID_counter++;
277         }else{
278             players[msg.sender].nickname = nickname;
279             playersByID[players[msg.sender].playerID].nickname = nickname;
280         }
281     }
282 
283 
284     /**
285      * @dev The following functions are for the web-site implementation to get details about Towers, Rounds and Players
286      */
287      
288     function _playerRoundsInfo (address _playerAddress, uint256 _TowerType, uint256 _RoundID)
289     public
290     view
291     returns (uint256, uint256, uint256, uint256, bool, address) {
292         uint256 _warriors = players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].warriors;
293         TowersInfo memory r = GameRounds[_TowerType].RoundList[_RoundID];
294         bool isFinished = true;
295         if (r.timeToFinish > now){
296             isFinished = false;
297         }
298         return (
299         r.towerBalance*GameRounds[_TowerType].winnerShare/100,
300         _currentPlayerAmountUnclaimed(_playerAddress, _TowerType, _RoundID),
301         _warriors,
302         r.totalWarriors,
303         isFinished,
304         r.lastPlayer);
305     }
306 
307 
308     function _currentPlayerAmountUnclaimed (address _playerAddress, uint256 _TowerType, uint256 _RoundID)
309     public
310     view
311     returns (uint256) {
312         if (_RoundID == 0){
313             _RoundID = GameRounds[_TowerType].currentRoundID;
314         }
315         uint256 _warriors = players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].warriors;
316         uint256 _totalForCashOut = (_warriors*GameRounds[_TowerType].RoundList[_RoundID].towerBalance*GameRounds[_TowerType].dividendShare/GameRounds[_TowerType].RoundList[_RoundID].totalWarriors/100);
317         uint256 _unclaimedAmount = _totalForCashOut-players[_playerAddress].TowersList[_TowerType].RoundList[_RoundID].cashedOut;
318         return (_unclaimedAmount);
319     }
320     
321     function _playerInfo (uint256 _playerID)
322     public
323     view
324     returns (uint256, address, string, uint256) {
325         return (playersByID[_playerID].playerID,
326         playersByID[_playerID].playerAddress,
327         playersByID[_playerID].nickname,
328         aff[playersByID[_playerID].playerAddress].balance);
329     }
330 
331     function _playerBalance (address _playerAddress)
332     public
333     view
334     returns (uint256) {
335         return aff[_playerAddress].balance;
336     }
337 
338     function _TowerRoundDetails (uint256 _TowerType, uint256 _RoundID)
339     public
340     view
341     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address) {
342         TowersInfo memory r = GameRounds[_TowerType].RoundList[_RoundID];
343         return (
344         r.roundID,
345         r.towerBalance,
346         r.totalBalance,
347         r.totalWarriors,
348         r.timeToFinish,
349         r.timeLimit,
350         r.warriorToTime,
351         r.bonusPot,
352         r.lastPlayer
353         );
354     }
355 }
356 
357 library SafeMath {
358 
359     /**
360     * @dev Multiplies two numbers, throws on overflow.
361     */
362     function mul(uint256 a, uint256 b)
363         internal
364         pure
365         returns (uint256 c)
366     {
367         if (a == 0) {
368             return 0;
369         }
370         c = a * b;
371         require(c / a == b, "SafeMath mul failed");
372         return c;
373     }
374 
375     /**
376     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
377     */
378     function sub(uint256 a, uint256 b)
379         internal
380         pure
381         returns (uint256)
382     {
383         require(b <= a, "SafeMath sub failed");
384         return a - b;
385     }
386 
387     /**
388     * @dev Adds two numbers, throws on overflow.
389     */
390     function add(uint256 a, uint256 b)
391         internal
392         pure
393         returns (uint256 c)
394     {
395         c = a + b;
396         require(c >= a, "SafeMath add failed");
397         return c;
398     }
399 
400     /**
401      * @dev gives square root of given x.
402      */
403     function sqrt(uint256 x)
404         internal
405         pure
406         returns (uint256 y)
407     {
408         uint256 z = ((add(x,1)) / 2);
409         y = x;
410         while (z < y)
411         {
412             y = z;
413             z = ((add((x / z),z)) / 2);
414         }
415     }
416 
417     /**
418      * @dev gives square. multiplies x by x
419      */
420     function sq(uint256 x)
421         internal
422         pure
423         returns (uint256)
424     {
425         return (mul(x,x));
426     }
427 
428     /**
429      * @dev x to the power of y
430      */
431     function pwr(uint256 x, uint256 y)
432         internal
433         pure
434         returns (uint256)
435     {
436         if (x==0)
437             return (0);
438         else if (y==0)
439             return (1);
440         else
441         {
442             uint256 z = x;
443             for (uint256 i=1; i < y; i++)
444                 z = mul(z,x);
445             return (z);
446         }
447     }
448 }