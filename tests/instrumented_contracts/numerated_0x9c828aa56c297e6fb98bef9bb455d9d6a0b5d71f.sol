1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36     /**
37      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38      * account.
39      */
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51     modifier notOwner() {
52         require(msg.sender != owner);
53         _;
54     }
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         require(newOwner != address(0));
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63     }
64 }
65 
66 contract Pausable is Ownable {
67     event Pause();
68     event Resume();
69 
70     bool public paused = false;
71 
72     /**
73      * @dev Modifier to make a function callable only when the contract is not paused.
74      */
75     modifier whenNotPaused() {
76         require(!paused);
77         _;
78     }
79 
80     /**
81      * @dev Modifier to make a function callable only when the contract is paused.
82      */
83     modifier whenPaused() {
84         require(paused);
85         _;
86     }
87 
88     /**
89      * @dev called by the owner to pause, triggers stopped state
90      */
91     function pause() onlyOwner whenNotPaused public {
92         paused = true;
93         emit Pause();
94     }
95 
96     /**
97      * @dev called by the owner to resume, returns to normal state
98      */
99     function resume() onlyOwner whenPaused public {
100         paused = false;
101         emit Resume();
102     }
103 }
104 
105 contract LuckyYouTokenInterface {
106     function airDrop(address _to, uint256 _value) public returns (bool);
107 
108     function balanceOf(address who) public view returns (uint256);
109 }
110 
111 contract LuckyYouContract is Pausable {
112     using SafeMath for uint256;
113     LuckyYouTokenInterface public luckyYouToken = LuckyYouTokenInterface(0x6D7efEB3DF42e6075fa7Cf04E278d2D69e26a623); //LKY token address
114     bool public airDrop = true;// weather airdrop LKY tokens to participants or not,owner can set it to true or false;
115 
116     //set airDrop flag
117     function setAirDrop(bool _airDrop) public onlyOwner {
118         airDrop = _airDrop;
119     }
120 
121     //if airdrop LKY token to participants , this is airdrop rate per round depends on participated times, owner can set it
122     uint public baseTokenGetRate = 100;
123 
124     // set token get rate
125     function setBaseTokenGetRate(uint _baseTokenGetRate) public onlyOwner {
126         baseTokenGetRate = _baseTokenGetRate;
127     }
128 
129     //if the number of participants less than  minParticipants,game will not be fired.owner can set it
130     uint public minParticipants = 50;
131 
132     function setMinParticipants(uint _minParticipants) public onlyOwner {
133         minParticipants = _minParticipants;
134     }
135 
136     //base price ,owner can set it
137     uint public basePrice = 0.01 ether;
138 
139     function setBasePrice(uint _basePrice) public onlyOwner {
140         basePrice = _basePrice;
141     }
142 
143     uint[5] public times = [1, 5, 5 * 5, 5 * 5 * 5, 5 * 5 * 5 * 5];//1x=0.01 ether;5x=0.05 ether; 5*5x=0.25 ether; 5*5*5x=1.25 ether; 5*5*5*5x=6.25 ether;
144     //at first only enable 1x(0.02ether) ,enable others proper time in future
145     bool[5] public timesEnabled = [true, false, false, false, false];
146 
147     uint[5] public currentCounter = [1, 1, 1, 1, 1];
148     mapping(address => uint[5]) private participatedCounter;
149     mapping(uint8 => address[]) private participants;
150     //todo
151     mapping(uint8 => uint256) public participantsCount;
152     mapping(uint8 => uint256) public fundShareLastRound;
153     mapping(uint8 => uint256) public fundCurrentRound;
154     mapping(uint8 => uint256) public fundShareRemainLastRound;
155     mapping(uint8 => uint256) public fundShareParticipantsTotalTokensLastRound;
156     mapping(uint8 => uint256) public fundShareParticipantsTotalTokensCurrentRound;
157     mapping(uint8 => bytes32) private participantsHashes;
158 
159     mapping(uint8 => uint8) private lastFiredStep;
160     mapping(uint8 => address) public lastWinner;
161     mapping(uint8 => address) public lastFiredWinner;
162     mapping(uint8 => uint256) public lastWinnerReward;
163     mapping(uint8 => uint256) public lastFiredWinnerReward;
164     mapping(uint8 => uint256) public lastFiredFund;
165     mapping(address => uint256) public whitelist;
166     uint256 public notInWhitelistAllow = 1;
167 
168     bytes32  private commonHash = 0x1000;
169 
170     uint256 public randomNumberIncome = 0;
171 
172     event Winner1(address value, uint times, uint counter, uint256 reward);
173     event Winner2(address value, uint times, uint counter, uint256 reward);
174 
175 
176     function setNotInWhitelistAllow(uint _value) public onlyOwner
177     {
178         notInWhitelistAllow = _value;
179     }
180 
181     function setWhitelist(uint _value,address [] _addresses) public onlyOwner
182     {
183         uint256 count = _addresses.length;
184         for (uint256 i = 0; i < count; i++) {
185             whitelist[_addresses [i]] = _value;
186         }
187     }
188 
189     function setTimesEnabled(uint8 _timesIndex, bool _enabled) public onlyOwner
190     {
191         require(_timesIndex < timesEnabled.length);
192         timesEnabled[_timesIndex] = _enabled;
193     }
194 
195     function() public payable whenNotPaused {
196 
197         if(whitelist[msg.sender] | notInWhitelistAllow > 0)
198         {
199             uint8 _times_length = uint8(times.length);
200             uint8 _times = _times_length + 1;
201             for (uint32 i = 0; i < _times_length; i++)
202             {
203                 if (timesEnabled[i])
204                 {
205                     if (times[i] * basePrice == msg.value) {
206                         _times = uint8(i);
207                         break;
208                     }
209                 }
210             }
211             if (_times > _times_length) {
212                 revert();
213             }
214             else
215             {
216                 if (participatedCounter[msg.sender][_times] < currentCounter[_times])
217                 {
218                     participatedCounter[msg.sender][_times] = currentCounter[_times];
219                     if (airDrop)
220                     {
221                         uint256 _value = baseTokenGetRate * 10 ** 18 * times[_times];
222                         uint256 _plus_value = uint256(keccak256(now, msg.sender)) % _value;
223                         luckyYouToken.airDrop(msg.sender, _value + _plus_value);
224                     }
225                     uint256 senderBalance = luckyYouToken.balanceOf(msg.sender);
226                     if (lastFiredStep[_times] > 0)
227                     {
228                         issueLottery(_times);
229                         fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;
230                         senderBalance = senderBalance.mul(2);
231                     } else
232                     {
233                         fundShareParticipantsTotalTokensCurrentRound[_times] += senderBalance;
234                     }
235                     if (participantsCount[_times] == participants[_times].length)
236                     {
237                         participants[_times].length += 1;
238                     }
239                     participants[_times][participantsCount[_times]++] = msg.sender;
240                     participantsHashes[_times] = keccak256(msg.sender, uint256(commonHash));
241                     commonHash = keccak256(senderBalance,commonHash);
242                     fundCurrentRound[_times] += times[_times] * basePrice;
243 
244                     //share last round fund
245                     if (fundShareRemainLastRound[_times] > 0)
246                     {
247                         uint256 _shareFund = fundShareLastRound[_times].mul(senderBalance).div(fundShareParticipantsTotalTokensLastRound[_times]);
248                         if(_shareFund  > 0)
249                         {
250                             if (_shareFund <= fundShareRemainLastRound[_times]) {
251                                 fundShareRemainLastRound[_times] -= _shareFund;
252                                 msg.sender.transfer(_shareFund);
253                             } else {
254                                 uint256 _fundShareRemain = fundShareRemainLastRound[_times];
255                                 fundShareRemainLastRound[_times] = 0;
256                                 msg.sender.transfer(_fundShareRemain);
257                             }
258                         }
259                     }
260 
261                     if (participantsCount[_times] > minParticipants)
262                     {
263                         if (uint256(keccak256(now, msg.sender, commonHash)) % (minParticipants * minParticipants) < minParticipants)
264                         {
265                             fireLottery(_times);
266                         }
267 
268                     }
269                 } else
270                 {
271                     revert();
272                 }
273             }
274         }else{
275             revert();
276         }
277     }
278 
279     function issueLottery(uint8 _times) private {
280         uint256 _totalFundRate = lastFiredFund[_times].div(100);
281         if (lastFiredStep[_times] == 1) {
282             fundShareLastRound[_times] = _totalFundRate.mul(30) + fundShareRemainLastRound[_times];
283             if (randomNumberIncome > 0)
284             {
285                 if (_times == (times.length - 1) || timesEnabled[_times + 1] == false)
286                 {
287                     fundShareLastRound[_times] += randomNumberIncome;
288                     randomNumberIncome = 0;
289                 }
290             }
291             fundShareRemainLastRound[_times] = fundShareLastRound[_times];
292             fundShareParticipantsTotalTokensLastRound[_times] = fundShareParticipantsTotalTokensCurrentRound[_times];
293             fundShareParticipantsTotalTokensCurrentRound[_times] = 0;
294             if(fundShareParticipantsTotalTokensLastRound[_times] == 0)
295             {
296                 fundShareParticipantsTotalTokensLastRound[_times] = 10000 * 10 ** 18;
297             }
298             lastFiredStep[_times]++;
299         } else if (lastFiredStep[_times] == 2) {
300             lastWinner[_times].transfer(_totalFundRate.mul(65));
301             lastFiredStep[_times]++;
302             lastWinnerReward[_times] = _totalFundRate.mul(65);
303             emit Winner1(lastWinner[_times], _times, currentCounter[_times] - 1, _totalFundRate.mul(65));
304         } else if (lastFiredStep[_times] == 3) {
305             if (lastFiredFund[_times] > (_totalFundRate.mul(30) + _totalFundRate.mul(4) + _totalFundRate.mul(65)))
306             {
307                 owner.transfer(lastFiredFund[_times] - _totalFundRate.mul(30) - _totalFundRate.mul(4) - _totalFundRate.mul(65));
308             }
309             lastFiredStep[_times] = 0;
310         }
311     }
312 
313     function fireLottery(uint8 _times) private {
314         lastFiredFund[_times] = fundCurrentRound[_times];
315         fundCurrentRound[_times] = 0;
316         lastWinner[_times] = participants[_times][uint256(participantsHashes[_times]) % participantsCount[_times]];
317         participantsCount[_times] = 0;
318         uint256 winner2Reward = lastFiredFund[_times].div(100).mul(4);
319         msg.sender.transfer(winner2Reward);
320         lastFiredWinner[_times] = msg.sender;
321         lastFiredWinnerReward[_times] = winner2Reward;
322         emit Winner2(msg.sender, _times, currentCounter[_times], winner2Reward);
323         lastFiredStep[_times] = 1;
324         currentCounter[_times]++;
325     }
326 
327     function _getRandomNumber(uint _round) view private returns (uint256){
328         return uint256(keccak256(
329                 participantsHashes[0],
330                 participantsHashes[1],
331                 participantsHashes[2],
332                 participantsHashes[3],
333                 participantsHashes[4],
334                 msg.sender
335             )) % _round;
336     }
337 
338     function getRandomNumber(uint _round) public payable returns (uint256){
339         uint256 tokenBalance = luckyYouToken.balanceOf(msg.sender);
340         if (tokenBalance >= 100000 * 10 ** 18)
341         {
342             return _getRandomNumber(_round);
343         } else if (msg.value >= basePrice) {
344             randomNumberIncome += msg.value;
345             return _getRandomNumber(_round);
346         } else {
347             revert();
348             return 0;
349         }
350     }
351     //in case some bugs
352     function kill() public {//for test
353         if (msg.sender == owner)
354         {
355             selfdestruct(owner);
356         }
357     }
358 }