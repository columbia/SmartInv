1 pragma solidity 0.5.12;
2 
3 interface HexMoneyInterface{
4     function mintHXY(uint hearts, address receiver) external returns (bool);
5 }
6 
7 contract HEX {
8     function xfLobbyEnter(address referrerAddr)
9     external
10     payable;
11 
12     function xfLobbyExit(uint256 enterDay, uint256 count)
13     external;
14 
15     function xfLobbyPendingDays(address memberAddr)
16     external
17     view
18     returns (uint256[2] memory words);
19 
20     function balanceOf (address account)
21     external
22     view
23     returns (uint256);
24 
25     function transfer (address recipient, uint256 amount)
26     external
27     returns (bool);
28 
29     function currentDay ()
30     external
31     view
32     returns (uint256);
33 }
34 
35 contract Router {
36 
37     struct CustomerState {
38         uint16 nextPendingDay;
39         mapping(uint256 => uint256) contributionByDay;
40     }
41 
42     struct LobbyContributionState {
43         uint256 totalValue;
44         uint256 heartsReceived;
45     }
46 
47     struct ContractStateCache {
48         uint256 currentDay;
49         uint256 nextPendingDay;
50     }
51 
52     event LobbyJoined(
53         uint40 timestamp,
54         uint16 day,
55         uint256 amount,
56         address indexed customer,
57         address indexed affiliate
58     );
59 
60     event LobbyLeft(
61         uint40 timestamp,
62         uint16 day,
63         uint256 hearts
64     );
65 
66     event MissedLobby(
67         uint40 timestamp,
68         uint16 day
69     );
70 
71     address internal hexMoneyAddress = address(0x44F00918A540774b422a1A340B75e055fF816d83);
72     HexMoneyInterface internal hexMoney = HexMoneyInterface(hexMoneyAddress);
73     // from HEX
74     uint16 private constant LAUNCH_PHASE_DAYS = 350;
75     uint16 private constant LAUNCH_PHASE_END_DAY = 351;
76     uint256 private constant XF_LOBBY_DAY_WORDS = (LAUNCH_PHASE_END_DAY + 255) >> 8;
77 
78     // constants & mappings we need
79     HEX private constant hx = HEX(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
80     address private operatorOne;
81     address private operatorTwo;
82     address private operatorThree;
83     address private operatorFour;
84     address private operatorFive;
85     address private constant SPLITTER = address(0x889c65411DeA4df35eF6F62252944409FD78054C);
86     uint256 private contractNextPendingDay;
87     uint256 public constant HEX_LAUNCH_TIME = 1575331200;
88     mapping(address => uint8) private registeredAffiliates;
89     mapping(uint256 => LobbyContributionState) private totalValueByDay;
90     mapping(address => CustomerState) private customerData;
91     mapping(uint8 => uint8) public affiliateRankPercentages;
92 
93     modifier operatorOnly() {
94         require(msg.sender == operatorOne ||
95                 msg.sender == operatorTwo ||
96                 msg.sender == operatorThree ||
97                 msg.sender == operatorFour ||
98                 msg.sender == operatorFive,
99                  "This operation is only allowed to be performed by the contract operator");
100         _;
101     }
102 
103     constructor()
104     public
105     {
106         operatorOne = msg.sender;//SWIFT
107         operatorTwo = address(0xD30BC4859A79852157211E6db19dE159673a67E2);//KYLE
108         operatorThree = address(0x3487b398546C9b757921df6dE78EC308203f5830);//KEVIN
109         operatorFour = address(0xbf1984B12878c6A25f0921535c76C05a60bdEf39);//MARCO
110         operatorFive = msg.sender;//TBD
111         contractNextPendingDay = _getHexContractDay(); // today is the next day to resolve
112         affiliateRankPercentages[0] = 0;
113         affiliateRankPercentages[1] = 50;
114         affiliateRankPercentages[2] = 100;
115     }
116     
117     function enterLobby(address customer, address affiliate)
118     public
119     payable
120     {
121         require(msg.value > 0, "invalid eth value");
122         bool isAffiliate = false;
123         uint8 affiliateLevel = registeredAffiliates[msg.sender];
124         uint8 affiliateSplit = affiliateRankPercentages[affiliateLevel];
125         if(affiliate != address(0) && affiliateSplit > 0){
126             // real affiliate, use them for ref
127             uint256 affiliateValue = msg.value * affiliateSplit / 100;
128             isAffiliate = true;
129             hx.xfLobbyEnter.value(affiliateValue)(affiliate);
130             if(msg.value - affiliateValue > 0){
131                 hx.xfLobbyEnter.value(msg.value - affiliateValue)(SPLITTER);
132             }
133         } else {
134             hx.xfLobbyEnter.value(msg.value)(SPLITTER);
135         }
136 
137         // record customer contribution
138         uint256 currentDay = _getHexContractDay();
139         totalValueByDay[currentDay].totalValue += msg.value;
140         customerData[customer].contributionByDay[currentDay] += msg.value;
141         if(customerData[customer].nextPendingDay == 0){
142             // new user
143             customerData[customer].nextPendingDay = uint16(currentDay);
144         }
145 
146         //if the splitter is used as referral, set the zero address as affiliate
147         address referrerAddr = isAffiliate ? affiliate : address(0);
148         emit LobbyJoined(
149             uint40(block.timestamp),
150             uint16(currentDay),
151             msg.value,
152             customer,
153             referrerAddr
154           );
155     }
156 
157     function exitLobbiesBeforeDay(address customer, uint256 day)
158     public
159     {
160         ContractStateCache memory state = ContractStateCache(_getHexContractDay(), contractNextPendingDay);
161         uint256 _day = day > 0 ? day : state.currentDay;
162         require(customerData[customer].nextPendingDay < _day,
163             "Customer has no active lobby entries for this time period");
164         _leaveLobbies(state, _day);
165         // next pending day was updated as part of leaveLobbies
166         contractNextPendingDay = state.nextPendingDay;
167         _distributeShare(customer, _day);
168     }
169 
170     function updateOperatorOne(address newOperator)
171     public
172     {
173         require(msg.sender == operatorOne, "Operator may only update themself");
174         require(newOperator != address(0),"New operator must be a non-zero address");
175         operatorOne = newOperator;
176     }
177 
178     function updateOperatorTwo(address newOperator)
179     public
180     {
181         require(msg.sender == operatorTwo, "Operator may only update themself");
182         require(newOperator != address(0),"New operator must be a non-zero address");
183         operatorTwo = newOperator;
184     }
185 
186     function updateOperatorThree(address newOperator)
187     public
188     {
189         require(msg.sender == operatorThree, "Operator may only update themself");
190         require(newOperator != address(0),"New operator must be a non-zero address");
191         operatorThree = newOperator;
192     }
193 
194     function updateOperatorFour(address newOperator)
195     public
196     {
197         require(msg.sender == operatorFour, "Operator may only update themself");
198         require(newOperator != address(0),"New operator must be a non-zero address");
199         operatorFour = newOperator;
200     }
201     
202     function updateOperatorFive(address newOperator)
203     public
204     {
205         require(msg.sender == operatorFive, "Operator may only update themself");
206         require(newOperator != address(0),"New operator must be a non-zero address");
207         operatorFive = newOperator;
208     }
209     
210     function registerAffiliate(address affiliateContract, uint8 affiliateRank)
211     public
212     operatorOnly
213     {
214         require(registeredAffiliates[affiliateContract] == 0, "Affiliate contract is already registered");
215         registeredAffiliates[affiliateContract] = affiliateRank;
216     }
217 
218     function updateAffiliateRank(address affiliateContract, uint8 affiliateRank)
219     public
220     operatorOnly
221     {
222         require(affiliateRank != registeredAffiliates[affiliateContract], "New Affiliate rank must be different than previous");
223         require(affiliateRankPercentages[affiliateRank] >= affiliateRankPercentages[registeredAffiliates[affiliateContract]],
224                 "Cannot set an affiliateRank with lower percentage than previous");
225         registeredAffiliates[affiliateContract] = affiliateRank;
226     }
227 
228     function addAffiliateRank(uint8 affiliateRank, uint8 rankSplitPercentage)
229     public
230     operatorOnly
231     {
232         require(affiliateRankPercentages[affiliateRank] == 0, "Affiliate rank already exists");
233         require(rankSplitPercentage > 0 && rankSplitPercentage <= 100,
234             "Affiliate Split must be between 0-100%");
235         affiliateRankPercentages[affiliateRank] = rankSplitPercentage;
236     }
237 
238     function verifyAffiliate(address affiliateContract)
239     public
240     view
241     returns (bool, uint8)
242     {
243         return (registeredAffiliates[affiliateContract] > 0, registeredAffiliates[affiliateContract]);
244     }
245 
246     function batchLeaveLobby(uint256 day, uint256 batchSize)
247     public
248     {
249         require(day < _getHexContractDay(), "You must only leave lobbies that have ended");
250         uint256[XF_LOBBY_DAY_WORDS] memory joinedDays = hx.xfLobbyPendingDays(address(this));
251         require((joinedDays[day >> 8] & (1 << (day & 255))) >> (day & 255) == 1, "You may only leave lobbies with active entries");
252 
253         uint256 balance = hx.balanceOf(address(this));
254         _leaveLobby(day, batchSize, balance);
255     }
256 
257     function ()
258     external
259     payable
260     {
261         if(msg.value > 0)
262         {
263           // If someone just sends eth, get them in a lobby with no affiliate, i.e. splitter
264           enterLobby(msg.sender, address(0));
265         }
266           else
267         {
268           //if the transaction value is 0, exit lobbies instead
269           exitLobbiesBeforeDay(msg.sender, 0);
270         }
271     }
272 
273     function _getHexContractDay()
274     private
275     view
276     returns (uint256)
277     {
278         require(HEX_LAUNCH_TIME < block.timestamp, "Launch time not before current block");
279         return (block.timestamp - HEX_LAUNCH_TIME) / 1 days;
280     }
281 
282     function _leaveLobbies(ContractStateCache memory currentState, uint256 beforeDay)
283     private
284     {
285         uint256 newBalance = hx.balanceOf(address(this));
286         //uint256 oldBalance;
287         if(currentState.nextPendingDay < beforeDay){
288             uint256[XF_LOBBY_DAY_WORDS] memory joinedDays = hx.xfLobbyPendingDays(address(this));
289             while(currentState.nextPendingDay < beforeDay){
290                 if( (joinedDays[currentState.nextPendingDay >> 8] & (1 << (currentState.nextPendingDay & 255))) >>
291                     (currentState.nextPendingDay & 255) == 1){
292                     // leaving 0 means leave "all"
293                     newBalance = _leaveLobby(currentState.nextPendingDay, 0, newBalance);
294                     emit LobbyLeft(uint40(block.timestamp),
295                         uint16(currentState.nextPendingDay),
296                         totalValueByDay[currentState.nextPendingDay].heartsReceived);
297                 } else {
298                     emit MissedLobby(uint40(block.timestamp),
299                      uint16(currentState.nextPendingDay));
300                 }
301                 currentState.nextPendingDay++;
302             }
303         }
304     }
305 
306     function _leaveLobby(uint256 lobby, uint256 numEntries, uint256 balance)
307     private
308     returns (uint256)
309     {
310         hx.xfLobbyExit(lobby, numEntries);
311         uint256 oldBalance = balance;
312         balance = hx.balanceOf(address(this));
313         totalValueByDay[lobby].heartsReceived += balance - oldBalance;
314         require(totalValueByDay[lobby].heartsReceived > 0, "Hearts received for a lobby is 0");
315         return balance;
316     }
317 
318     function _distributeShare(address customer, uint256 endDay)
319     private
320     returns (uint256)
321     {
322         uint256 totalShare = 0;
323         CustomerState storage user = customerData[customer];
324         uint256 nextDay = user.nextPendingDay;
325         if(nextDay > 0 && nextDay < endDay){
326             while(nextDay < endDay){
327                 if(totalValueByDay[nextDay].totalValue > 0 && totalValueByDay[nextDay].heartsReceived > 0){
328                     require(totalValueByDay[nextDay].heartsReceived > 0, "Hearts received must be > 0, leave lobby for day");
329                     totalShare += user.contributionByDay[nextDay] *
330                         totalValueByDay[nextDay].heartsReceived /
331                         totalValueByDay[nextDay].totalValue;
332                 }
333                 nextDay++;
334             }
335             if(totalShare > 0){
336                 require(hx.transfer(customer, totalShare), strConcat("Failed to transfer ",uint2str(totalShare),", insufficient balance"));
337                 //mint HEX Money
338                 if(hexMoneyAddress != address(0) && totalShare >= 1000 && customer != SPLITTER){
339                    require(hexMoney.mintHXY(totalShare, customer), "could not mint HXY");
340                 }
341             }
342         }
343         if(nextDay != user.nextPendingDay){
344             user.nextPendingDay = uint16(nextDay);
345         }
346 
347         return totalShare;
348     }
349     
350     function setHexMoneyAddress(address _hexMoneyAddress)
351     operatorOnly
352     public
353     {
354         hexMoneyAddress = _hexMoneyAddress;
355         hexMoney = HexMoneyInterface(hexMoneyAddress);
356     }
357     
358     
359     function uint2str(uint i)
360     internal
361     pure returns (string memory _uintAsString)
362     {
363         uint _i = i;
364         if (_i == 0) {
365             return "0";
366         }
367         uint j = _i;
368         uint len;
369         while (j != 0) {
370             len++;
371             j /= 10;
372         }
373         bytes memory bstr = new bytes(len);
374         uint k = len - 1;
375         while (_i != 0) {
376             bstr[k--] = byte(uint8(48 + _i % 10));
377             _i /= 10;
378         }
379         return string(bstr);
380     }
381 
382     function strConcat(string memory _a, string memory _b, string memory _c
383     , string memory _d, string memory _e)
384     private
385     pure
386     returns (string memory){
387     bytes memory _ba = bytes(_a);
388     bytes memory _bb = bytes(_b);
389     bytes memory _bc = bytes(_c);
390     bytes memory _bd = bytes(_d);
391     bytes memory _be = bytes(_e);
392     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
393     bytes memory babcde = bytes(abcde);
394     uint k = 0;
395     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
396     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
397     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
398     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
399     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
400     return string(babcde);
401     }
402 
403     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d)
404     private
405     pure
406     returns (string memory) {
407         return strConcat(_a, _b, _c, _d, "");
408     }
409 
410     function strConcat(string memory _a, string memory _b, string memory _c)
411     private
412     pure
413     returns (string memory) {
414         return strConcat(_a, _b, _c, "", "");
415     }
416 
417     function strConcat(string memory _a, string memory _b)
418     private
419     pure
420     returns (string memory) {
421         return strConcat(_a, _b, "", "", "");
422     }
423 }