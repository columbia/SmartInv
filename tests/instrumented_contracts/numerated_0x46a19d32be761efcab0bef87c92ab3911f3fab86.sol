1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMaths
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract HotLot {
35     using SafeMath for uint256;
36 
37     uint256 public INTERVAL_TIME = 8 hours;
38     uint256 public JACKPOT_INTERVAL_TIME = 72 hours;
39     uint256 public constant PERCENT_REWARD_TO_JACKPOT = 20;
40     uint256 public constant PERCENT_REWARD_TOP_RANK = 30;
41     uint256 public constant PERCENT_REWARD_TOP1 = 60;
42     uint256 public constant PERCENT_REWARD_TOP2 = 30;
43     uint256 public constant PERCENT_REWARD_TOP3 = 10;
44     uint256 public DEPOSIT_AMOUNT = 0.02 * (10 ** 18);
45 
46     address public owner;
47     address public winner1;
48     uint256 public winnerAmount1 = 0;
49     address public winner2;
50     uint256 public winnerAmount2 = 0;
51     address public winner3;
52     uint256 public winnerAmount3 = 0;
53 
54     address public winnerJackpot1;
55     uint256 public winnerJackpotAmount1 = 0;
56     address public winnerJackpot2;
57     uint256 public winnerJackpotAmount2 = 0;
58     address public winnerJackpot3;
59     uint256 public winnerJackpotAmount3 = 0;
60 
61     uint256 public amountRound = 0;
62     uint256 public amountJackpot = 0;
63     uint256 public roundTime;
64     uint256 public jackpotTime;
65     uint256 public countPlayerRound = 0;
66     uint256 public countPlayerJackpot = 0;
67     uint256 public countRound = 0;
68     uint256 public countJackpot = 0;
69     uint256 private _seed;
70 
71     struct Player {
72         address wallet;
73         bool playing;
74         bool playingJackpot;
75     }
76 
77     Player[] public players;
78 
79     event DepositSuccess(address _from, uint256 _amount, uint256 countRound, uint256 countJackpot);
80     event RewardRoundWinner(
81         address wallet1, 
82         uint256 amount1, 
83         address wallet2, 
84         uint256 amount2, 
85         address wallet3, 
86         uint256 amount3, 
87         uint256 rewardRank
88     );
89     event RewardJackpotWinner(
90         address wallet1, uint256 amount1, 
91         address wallet2, uint256 amount2, 
92         address wallet3, uint256 amount3, 
93         uint256 rewardRank
94     );
95 
96     function HotLot() public {
97         owner = msg.sender;
98         roundTime = now.add(INTERVAL_TIME);
99         jackpotTime = now.add(JACKPOT_INTERVAL_TIME);
100     }
101 
102     /**
103     * Throws if called by any account other than the owner.
104     */
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     function () payable {
111         deposit();
112     }
113 
114     /**
115     * Deposit from player
116     */
117     function deposit() public payable {
118         require(msg.value >= DEPOSIT_AMOUNT);
119 
120         players.push(Player({
121             wallet: msg.sender,
122             playing: true,
123             playingJackpot: true
124         }));
125 
126         amountRound = amountRound.add(msg.value);
127         countPlayerRound = countPlayerRound.add(1);
128         countPlayerJackpot = countPlayerJackpot.add(1);
129 
130         emit DepositSuccess(msg.sender, msg.value, countRound, countJackpot);
131 
132         if (now >= roundTime && amountRound > 0 && countPlayerRound > 1) {
133             roundTime = now.add(INTERVAL_TIME);
134             executeRound();
135 
136             if (now >= jackpotTime && amountJackpot > 0 && countPlayerJackpot > 1) {
137                 jackpotTime = now.add(JACKPOT_INTERVAL_TIME);
138                 executeJackpot();
139             }
140         }
141     }
142 
143     function executeRound() private {
144         uint256 count = 0;
145         address wallet1;
146         address wallet2;
147         address wallet3;
148         uint256 luckyNumber1 = generateLuckyNumber(countPlayerRound);
149         uint256 luckyNumber2 = generateLuckyNumber(countPlayerRound);
150         uint256 luckyNumber3 = generateLuckyNumber(countPlayerRound);
151 
152         for (uint256 i = 0; i < players.length; i++) {
153             if (players[i].playing) {
154                 count = count.add(1);
155                 if (count == luckyNumber1) {
156                     wallet1 = players[i].wallet;
157                 }
158                 if (count == luckyNumber2) {
159                     wallet2 = players[i].wallet;
160                 }
161                 if (count == luckyNumber3) {
162                     wallet3 = players[i].wallet;
163                 }
164                 players[i].playing = false;
165             }
166         }
167 
168         countRound = countRound.add(1);
169         uint256 rewardRank = amountRound.mul(PERCENT_REWARD_TOP_RANK).div(100);
170         uint256 amountToJackpot = amountRound.mul(PERCENT_REWARD_TO_JACKPOT).div(100);
171         uint256 reward = amountRound.sub(rewardRank.add(amountToJackpot));
172 
173         amountJackpot = amountJackpot.add(amountToJackpot);
174 
175         winnerAmount1 = reward.mul(PERCENT_REWARD_TOP1).div(100);
176         winner1 = wallet1;
177         winnerAmount2 = reward.mul(PERCENT_REWARD_TOP2).div(100);
178         winner2 = wallet2;
179         winnerAmount3 = reward.sub(winnerAmount1.add(winnerAmount2));
180         winner3 = wallet3;
181 
182         amountRound = 0;
183         countPlayerRound = 0;
184 
185         winner1.transfer(winnerAmount1);
186         winner2.transfer(winnerAmount2);
187         winner3.transfer(winnerAmount3);
188         owner.transfer(rewardRank);
189 
190         emit RewardRoundWinner(
191             winner1, 
192             winnerAmount1, 
193             winner2, 
194             winnerAmount2, 
195             winner3, 
196             winnerAmount3, 
197             rewardRank
198         );
199     }
200 
201     function executeJackpot() private {
202         uint256 count = 0;
203         address wallet1;
204         address wallet2;
205         address wallet3;
206         uint256 luckyNumber1 = generateLuckyNumber(countPlayerJackpot);
207         uint256 luckyNumber2 = generateLuckyNumber(countPlayerJackpot);
208         uint256 luckyNumber3 = generateLuckyNumber(countPlayerJackpot);
209 
210         for (uint256 i = 0; i < players.length; i++) {
211             if (players[i].playingJackpot) {
212                 count = count.add(1);
213                 if (count == luckyNumber1) {
214                     wallet1 = players[i].wallet;
215                 }
216                 if (count == luckyNumber2) {
217                     wallet2 = players[i].wallet;
218                 }
219                 if (count == luckyNumber3) {
220                     wallet3 = players[i].wallet;
221                 }
222                 players[i].playing = false;
223             }
224         }
225 
226         uint256 rewardRank = amountJackpot.mul(PERCENT_REWARD_TOP_RANK).div(100);
227         uint256 reward = amountJackpot.sub(rewardRank);
228 
229         winnerJackpotAmount1 = reward.mul(PERCENT_REWARD_TOP1).div(100);
230         winnerJackpot1 = wallet1;
231         winnerJackpotAmount2 = reward.mul(PERCENT_REWARD_TOP2).div(100);
232         winnerJackpot2 = wallet2;
233         winnerJackpotAmount3 = reward.sub(winnerJackpotAmount1.add(winnerJackpotAmount2));
234         winnerJackpot3 = wallet3;
235 
236         countJackpot = countJackpot.add(1);
237         amountJackpot = 0;
238         countPlayerJackpot = 0;
239         delete players;
240 
241         owner.transfer(rewardRank);
242         winnerJackpot1.transfer(winnerJackpotAmount1);
243         winnerJackpot2.transfer(winnerJackpotAmount2);
244         winnerJackpot3.transfer(winnerJackpotAmount3);
245 
246         emit RewardJackpotWinner(
247             winnerJackpot1, 
248             winnerJackpotAmount1, 
249             winnerJackpot2, 
250             winnerJackpotAmount2, 
251             winnerJackpot3, 
252             winnerJackpotAmount3, 
253             rewardRank
254         );
255     }
256 
257     function maxRandom() public returns (uint256 number) {
258         _seed = uint256(keccak256(
259             _seed,
260             block.blockhash(block.number - 1),
261             block.coinbase,
262             block.difficulty,
263             players.length,
264             countPlayerJackpot,
265             countPlayerRound,
266             winnerJackpot1,
267             winnerJackpotAmount1,
268             winnerAmount1,
269             winner1,
270             now
271         ));
272 
273         return _seed;
274     }
275 
276     function generateLuckyNumber(uint256 maxNumber) private returns (uint256 number) {
277         return (maxRandom() % maxNumber) + 1;
278     }
279 
280     /**
281     * Allows the current owner to transfer control of the contract to a newOwner.
282     * _newOwner The address to transfer ownership to.
283     */
284     function transferOwnership(address _newOwner) public onlyOwner {
285         require(_newOwner != owner);
286         require(_newOwner != address(0x0));
287 
288         owner = _newOwner;
289     }
290     
291     function setIntervalTime(uint256 _time) public onlyOwner {
292         require(_time > 0);
293         INTERVAL_TIME = _time;
294     }
295     
296     function setIntervalJackpotTime(uint256 _time) public onlyOwner {
297         require(_time > 0);
298         JACKPOT_INTERVAL_TIME = _time;
299     }
300     
301     function setMinAmountDeposit(uint256 _amount) public onlyOwner {
302         require(_amount > 0);
303         DEPOSIT_AMOUNT = _amount;
304     }
305 }