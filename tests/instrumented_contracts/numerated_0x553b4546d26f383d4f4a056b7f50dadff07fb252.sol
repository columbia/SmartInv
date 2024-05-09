1 /*******************************************************************************
2 *********************    BATTLE OF THERMOPYLAE v1.1  ***************************
3 ********************************************************************************
4 
5 Battle smart contract is a platform/ecosystem for gaming built on top of a
6 decentralized smart contract, allowing anyone to use a Warrior tokens: entities
7 which exists on the Ethereum Network, which can be traded or used to enter the
8 battle with other Warrior tokens holders, for profit or just for fun!
9 
10 ********************************************************************************
11 **************************           RULES           ***************************
12 ********************************************************************************
13 
14 - This first battle contract accepts Persians, Spartans (300 Tokens), Immortals
15   and Athenians as warriors.
16 - Every warrior token has a proper value in **Battle Point (BP)** that represent
17   his strength on the battle contract.
18 - Persians and Immortals represent the Persian faction, Spartans and Athenians
19   the Greek one.
20 - During the first phase players send tokens to the battle contract
21   (NOTE: before calling the proper contract's function that assigning warriors
22   to the battlefiled, players NEED TO CALL APPROVE on their token contract to
23   allow Battle contract to move their tokens.
24 - Once sent, troops can't be retired form the battlefield
25 - The battle will last for several days
26 - When the battle period is over, following results can happpen:
27     -- When the battle ends in a draw:
28         (*) 10% of main troops of both sides lie on the ground
29         (*) 90% of them can be retrieved by each former owner
30         (*) No slaves are assigned
31     -- When the battle ends with a winning factions:
32         (*) 10% of main troops of both sides lie on the ground
33         (*) 90% of them can be retrieved by each former owner
34         (*) Surviving warriors of the loosing faction are assigned as slaves
35             to winners
36         (*) Slaves are computed based on the BP contributed by each sender
37 - Persians and Spartans are main troops.
38 - Immortals and Athenians are support troops: there will be no casualties in
39   their row, and they will be retrieved without losses by original senders.
40 - Only Persians and Spartans can be slaves. Immortals and Athenians WILL NOT
41   be sent back as slaves to winners.
42 
43 ********************************************************************************
44 **************************      TOKEN ADDRESSES      ***************************
45 ********************************************************************************
46 
47         Persians    (PRS)   0x163733bcc28dbf26B41a8CfA83e369b5B3af741b
48         Immortals   (IMT)   0x22E5F62D0FA19974749faa194e3d3eF6d89c08d7
49         Spartans    (300)   0xaEc98A708810414878c3BCDF46Aad31dEd4a4557
50         Athenians   (ATH)   0x17052d51E954592C1046320c2371AbaB6C73Ef10
51         Battles     (BTL)   Set after the deployment of this contract
52 
53 *******************************************************************************/
54 pragma solidity ^0.4.15;
55 
56 contract TokenEIP20 {
57 
58     function balanceOf(address _owner) constant returns (uint256 balance);
59     function transfer(address _to, uint256 _value) returns (bool success);
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
61     function approve(address _spender, uint256 _value) returns (bool success);
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     
67 }
68 
69 contract Timed {
70     
71     uint256 public startTime;           //seconds since Unix epoch time
72     uint256 public endTime;             //seconds since Unix epoch time
73     uint256 public avarageBlockTime;    //seconds
74 
75     // This check is an helper function for ÐApp to check the effect of the NEXT transaction, NOT simply the current state of the contract
76     function isInTime() constant returns (bool inTime) {
77         return block.timestamp >= (startTime - avarageBlockTime) && !isTimeExpired();
78     }
79 
80     // This check is an helper function for ÐApp to check the effect of the NEXT transacion, NOT simply the current state of the contract
81     function isTimeExpired() constant returns (bool timeExpired) {
82         return block.timestamp + avarageBlockTime >= endTime;
83     }
84 
85     modifier onlyIfInTime {
86         require(block.timestamp >= startTime && block.timestamp <= endTime); _;
87     }
88 
89     modifier onlyIfTimePassed {
90         require(block.timestamp > endTime); _;
91     }
92 
93     function Timed(uint256 _startTime, uint256 life, uint8 _avarageBlockTime) {
94         startTime = _startTime;
95         endTime = _startTime + life;
96         avarageBlockTime = _avarageBlockTime;
97     }
98 }
99 
100 library SafeMathLib {
101 
102     uint constant WAD = 10 ** 18;
103     uint constant RAY = 10 ** 27;
104 
105     function add(uint x, uint y) internal returns (uint z) {
106         require((z = x + y) >= x);
107     }
108 
109     function sub(uint x, uint y) internal returns (uint z) {
110         require((z = x - y) <= x);
111     }
112 
113     function mul(uint x, uint y) internal returns (uint z) {
114         require(y == 0 || (z = x * y) / y == x);
115     }
116 
117     function per(uint x, uint y) internal constant returns (uint z) {
118         return mul((x / 100), y);
119     }
120 
121     function min(uint x, uint y) internal returns (uint z) {
122         return x <= y ? x : y;
123     }
124 
125     function max(uint x, uint y) internal returns (uint z) {
126         return x >= y ? x : y;
127     }
128 
129     function imin(int x, int y) internal returns (int z) {
130         return x <= y ? x : y;
131     }
132 
133     function imax(int x, int y) internal returns (int z) {
134         return x >= y ? x : y;
135     }
136 
137     function wmul(uint x, uint y) internal returns (uint z) {
138         z = add(mul(x, y), WAD / 2) / WAD;
139     }
140 
141     function rmul(uint x, uint y) internal returns (uint z) {
142         z = add(mul(x, y), RAY / 2) / RAY;
143     }
144 
145     function wdiv(uint x, uint y) internal returns (uint z) {
146         z = add(mul(x, WAD), y / 2) / y;
147     }
148 
149     function rdiv(uint x, uint y) internal returns (uint z) {
150         z = add(mul(x, RAY), y / 2) / y;
151     }
152 
153     function wper(uint x, uint y) internal constant returns (uint z) {
154         return wmul(wdiv(x, 100), y);
155     }
156 
157     // This famous algorithm is called "exponentiation by squaring"
158     // and calculates x^n with x as fixed-point and n as regular unsigned.
159     //
160     // It's O(log n), instead of O(n) for naive repeated multiplication.
161     //
162     // These facts are why it works:
163     //
164     //  If n is even, then x^n = (x^2)^(n/2).
165     //  If n is odd,  then x^n = x * x^(n-1),
166     //   and applying the equation for even x gives
167     //    x^n = x * (x^2)^((n-1) / 2).
168     //
169     //  Also, EVM division is flooring and
170     //    floor[(n-1) / 2] = floor[n / 2].
171     //
172     function rpow(uint x, uint n) internal returns (uint z) {
173         z = n % 2 != 0 ? x : RAY;
174 
175         for (n /= 2; n != 0; n /= 2) {
176             x = rmul(x, x);
177 
178             if (n % 2 != 0) {
179                 z = rmul(z, x);
180             }
181         }
182     }
183 
184 }
185 
186 contract Owned {
187 
188     address owner;
189     
190     function Owned() { owner = msg.sender; }
191 
192     modifier onlyOwner {
193         require(msg.sender == owner);
194         _;
195     }
196 }
197 
198 contract Upgradable is Owned {
199 
200     string  public VERSION;
201     bool    public deprecated;
202     string  public newVersion;
203     address public newAddress;
204 
205     function Upgradable(string _version) {
206         VERSION = _version;
207     }
208 
209     function setDeprecated(string _newVersion, address _newAddress) onlyOwner returns (bool success) {
210         require(!deprecated);
211         deprecated = true;
212         newVersion = _newVersion;
213         newAddress = _newAddress;
214         return true;
215     }
216 }
217 
218 contract BattleOfThermopylae is Timed, Upgradable {
219     using SafeMathLib for uint;
220   
221     uint    public constant MAX_PERSIANS            = 300000 * 10**18;  // 300.000
222     uint    public constant MAX_SPARTANS            = 300 * 10**18;     // 300
223     uint    public constant MAX_IMMORTALS           = 100;              // 100
224     uint    public constant MAX_ATHENIANS           = 100 * 10**18;     // 100
225 
226     uint8   public constant BP_PERSIAN              = 1;                // Each Persian worths 1 Battle Point
227     uint8   public constant BP_IMMORTAL             = 100;              // Each Immortal worths 100 Battle Points
228     uint16  public constant BP_SPARTAN              = 1000;             // Each Spartan worths 1000 Battle Points
229     uint8   public constant BP_ATHENIAN             = 100;              // Each Athenians worths 100 Battle Points
230 
231     uint8   public constant BTL_PERSIAN              = 1;               // Each Persian worths 1 Battle Token
232     uint16  public constant BTL_IMMORTAL             = 2000;            // Each Immortal worths 2000 Battle Tokens
233     uint16  public constant BTL_SPARTAN              = 1000;            // Each Spartan worths 1000 Battle Tokens
234     uint16  public constant BTL_ATHENIAN             = 2000;            // Each Athenians worths 2000 Battle Tokens
235 
236     uint    public constant WAD                     = 10**18;           // Shortcut for 1.000.000.000.000.000.000
237     uint8   public constant BATTLE_POINT_DECIMALS   = 18;               // Battle points decimal positions
238     uint8   public constant BATTLE_CASUALTIES       = 10;               // Percentage of Persian and Spartan casualties
239     
240     address public persians;                                            // Address of the Persian Tokens
241     address public immortals;                                           // Address of the Immortal Tokens
242     address public spartans;                                            // Address of the 300 Tokens
243     address public athenians;                                           // Address of the Athenian Tokens
244     address public battles;                                             // Address of the Battle Tokens
245     address public battlesOwner;                                        // Owner of the Battle Token contract
246 
247     mapping (address => mapping (address => uint))   public  warriorsByPlayer;               // Troops currently allocated by each player
248     mapping (address => uint)                        public  warriorsOnTheBattlefield;       // Total troops fighting in the battle
249 
250     event WarriorsAssignedToBattlefield (address indexed _from, address _faction, uint _battlePointsIncrementForecast);
251     event WarriorsBackToHome            (address indexed _to, address _faction, uint _survivedWarriors);
252 
253     function BattleOfThermopylae(uint _startTime, uint _life, uint8 _avarageBlockTime, address _persians, address _immortals, address _spartans, address _athenians) Timed(_startTime, _life, _avarageBlockTime) Upgradable("1.0.0") {
254         persians = _persians;
255         immortals = _immortals;
256         spartans = _spartans;
257         athenians = _athenians;
258     }
259 
260     function setBattleTokenAddress(address _battleTokenAddress, address _battleTokenOwner) onlyOwner {
261         battles = _battleTokenAddress;
262         battlesOwner = _battleTokenOwner;
263     }
264 
265     function assignPersiansToBattle(uint _warriors) onlyIfInTime external returns (bool success) {
266         assignWarriorsToBattle(msg.sender, persians, _warriors, MAX_PERSIANS);
267         sendBattleTokens(msg.sender, _warriors.mul(BTL_PERSIAN));
268         // Persians are divisible with 18 decimals and their value is 1 BP
269         WarriorsAssignedToBattlefield(msg.sender, persians, _warriors / WAD);
270         return true;
271     }
272 
273     function assignImmortalsToBattle(uint _warriors) onlyIfInTime external returns (bool success) {
274         assignWarriorsToBattle(msg.sender, immortals, _warriors, MAX_IMMORTALS);
275         sendBattleTokens(msg.sender, _warriors.mul(WAD).mul(BTL_IMMORTAL));
276         // Immortals are not divisible and their value is 100 BP
277         WarriorsAssignedToBattlefield(msg.sender, immortals, _warriors.mul(BP_IMMORTAL));
278         return true;
279     }
280 
281     function assignSpartansToBattle(uint _warriors) onlyIfInTime external returns (bool success) {
282         assignWarriorsToBattle(msg.sender, spartans, _warriors, MAX_SPARTANS);
283         sendBattleTokens(msg.sender, _warriors.mul(BTL_SPARTAN));
284         // Spartans are divisible with 18 decimals and their value is 1.000 BP
285         WarriorsAssignedToBattlefield(msg.sender, spartans, (_warriors / WAD).mul(BP_SPARTAN));
286         return true;
287     }
288 
289     function assignAtheniansToBattle(uint _warriors) onlyIfInTime external returns (bool success) {
290         assignWarriorsToBattle(msg.sender, athenians, _warriors, MAX_ATHENIANS);
291         sendBattleTokens(msg.sender, _warriors.mul(BTL_ATHENIAN));
292         // Athenians are divisible with 18 decimals and their value is 100 BP
293         WarriorsAssignedToBattlefield(msg.sender, athenians, (_warriors / WAD).mul(BP_ATHENIAN));
294         return true;
295     }
296 
297     function redeemWarriors() onlyIfTimePassed external returns (bool success) {
298         if (getPersiansBattlePoints() > getGreeksBattlePoints()) {
299             // Persians won, compute slaves
300             uint spartanSlaves = computeSlaves(msg.sender, spartans);
301             if (spartanSlaves > 0) {
302                 // Send back Spartan slaves to winner
303                 sendWarriors(msg.sender, spartans, spartanSlaves);
304             }
305             // Send back Persians but casualties
306             retrieveWarriors(msg.sender, persians, BATTLE_CASUALTIES);
307         } else if (getPersiansBattlePoints() < getGreeksBattlePoints()) {
308             //Greeks won, send back Persian slaves
309             uint persianSlaves = computeSlaves(msg.sender, persians);
310             if (persianSlaves > 0) {
311                 // Send back Persians slaves to winner
312                 sendWarriors(msg.sender, persians, persianSlaves);                
313             }
314             // Send back Spartans but casualties
315             retrieveWarriors(msg.sender, spartans, BATTLE_CASUALTIES);
316         } else {
317             // It's a draw, send back Persians and Spartans but casualties
318             retrieveWarriors(msg.sender, persians, BATTLE_CASUALTIES);
319             retrieveWarriors(msg.sender, spartans, BATTLE_CASUALTIES);
320         }
321         // Send back Immortals untouched
322         retrieveWarriors(msg.sender, immortals, 0);
323         // Send back Athenians untouched
324         retrieveWarriors(msg.sender, athenians, 0);
325         return true;
326     }
327 
328     function assignWarriorsToBattle(address _player, address _faction, uint _warriors, uint _maxWarriors) private {
329         require(warriorsOnTheBattlefield[_faction].add(_warriors) <= _maxWarriors);
330         require(TokenEIP20(_faction).transferFrom(_player, address(this), _warriors));
331         warriorsByPlayer[_player][_faction] = warriorsByPlayer[_player][_faction].add(_warriors);
332         warriorsOnTheBattlefield[_faction] = warriorsOnTheBattlefield[_faction].add(_warriors);
333     }
334 
335     function retrieveWarriors(address _player, address _faction, uint8 _deadPercentage) private {
336         if (warriorsByPlayer[_player][_faction] > 0) {
337             uint _warriors = warriorsByPlayer[_player][_faction];
338             if (_deadPercentage > 0) {
339                 _warriors = _warriors.sub(_warriors.wper(_deadPercentage));
340             }
341             warriorsByPlayer[_player][_faction] = 0;
342             sendWarriors(_player, _faction, _warriors);
343             WarriorsBackToHome(_player, _faction, _warriors);
344         }
345     }
346 
347     function sendWarriors(address _player, address _faction, uint _warriors) private {
348         require(TokenEIP20(_faction).transfer(_player, _warriors));
349     }
350 
351     function sendBattleTokens(address _player, uint _value) private {
352         require(TokenEIP20(battles).transferFrom(battlesOwner, _player, _value));
353     }
354 
355     function getPersiansOnTheBattlefield(address _player) constant returns (uint persiansOnTheBattlefield) {
356         return warriorsByPlayer[_player][persians];
357     }
358 
359     function getImmortalsOnTheBattlefield(address _player) constant returns (uint immortalsOnTheBattlefield) {
360         return warriorsByPlayer[_player][immortals];
361     }
362 
363     function getSpartansOnTheBattlefield(address _player) constant returns (uint spartansOnTheBattlefield) {
364         return warriorsByPlayer[_player][spartans];
365     }
366 
367     function getAtheniansOnTheBattlefield(address _player) constant returns (uint atheniansOnTheBattlefield) {
368         return warriorsByPlayer[_player][athenians];
369     }
370 
371     function getPersiansBattlePoints() constant returns (uint persiansBattlePoints) {
372         return (warriorsOnTheBattlefield[persians].mul(BP_PERSIAN) + warriorsOnTheBattlefield[immortals].mul(WAD).mul(BP_IMMORTAL));
373     }
374 
375     function getGreeksBattlePoints() constant returns (uint greeksBattlePoints) {
376         return (warriorsOnTheBattlefield[spartans].mul(BP_SPARTAN) + warriorsOnTheBattlefield[athenians].mul(BP_ATHENIAN));
377     }
378 
379     function getPersiansBattlePointsBy(address _player) constant returns (uint playerBattlePoints) {
380         return (getPersiansOnTheBattlefield(_player).mul(BP_PERSIAN) + getImmortalsOnTheBattlefield(_player).mul(WAD).mul(BP_IMMORTAL));
381     }
382 
383     function getGreeksBattlePointsBy(address _player) constant returns (uint playerBattlePoints) {
384         return (getSpartansOnTheBattlefield(_player).mul(BP_SPARTAN) + getAtheniansOnTheBattlefield(_player).mul(BP_ATHENIAN));
385     }
386 
387     function computeSlaves(address _player, address _loosingMainTroops) constant returns (uint slaves) {
388         if (_loosingMainTroops == spartans) {
389             return getPersiansBattlePointsBy(_player).wdiv(getPersiansBattlePoints()).wmul(getTotalSlaves(spartans));
390         } else {
391             return getGreeksBattlePointsBy(_player).wdiv(getGreeksBattlePoints()).wmul(getTotalSlaves(persians));
392         }
393     }
394 
395     function getTotalSlaves(address _faction) constant returns (uint slaves) {
396         return warriorsOnTheBattlefield[_faction].sub(warriorsOnTheBattlefield[_faction].wper(BATTLE_CASUALTIES));
397     }
398 
399     function isInProgress() constant returns (bool inProgress) {
400         return !isTimeExpired();
401     }
402 
403     function isEnded() constant returns (bool ended) {
404         return isTimeExpired();
405     }
406 
407     function isDraw() constant returns (bool draw) {
408         return (getPersiansBattlePoints() == getGreeksBattlePoints());
409     }
410 
411     function getTemporaryWinningFaction() constant returns (string temporaryWinningFaction) {
412         if (isDraw()) {
413             return "It's currently a draw, but the battle is still in progress!";
414         }
415         return getPersiansBattlePoints() > getGreeksBattlePoints() ?
416             "Persians are winning, but the battle is still in progress!" : "Greeks are winning, but the battle is still in progress!";
417     }
418 
419     function getWinningFaction() constant returns (string winningFaction) {
420         if (isInProgress()) {
421             return "The battle is still in progress";
422         }
423         if (isDraw()) {
424             return "The battle ended in a draw!";
425         }
426         return getPersiansBattlePoints() > getGreeksBattlePoints() ? "Persians" : "Greeks";
427     }
428 
429 }