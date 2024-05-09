1 pragma solidity ^0.4.21;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal pure returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 interface P3DTakeout {
29     function buyTokens() external payable;
30 }
31 
32 contract Betting {
33     using SafeMath for uint256; //using safemath
34 
35     address public owner; //owner address
36     address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
37     P3DTakeout P3DContract_;
38 
39     uint public winnerPoolTotal;
40     string public constant version = "0.2.3";
41 
42     struct chronus_info {
43         bool  betting_open; // boolean: check if betting is open
44         bool  race_start; //boolean: check if race has started
45         bool  race_end; //boolean: check if race has ended
46         bool  voided_bet; //boolean: check if race has been voided
47         uint32  starting_time; // timestamp of when the race starts
48         uint32  betting_duration;
49         uint32  race_duration; // duration of the race
50         uint32 voided_timestamp;
51     }
52 
53     struct horses_info{
54         int64  BTC_delta; //horses.BTC delta value
55         int64  ETH_delta; //horses.ETH delta value
56         int64  LTC_delta; //horses.LTC delta value
57         bytes32 BTC; //32-bytes equivalent of horses.BTC
58         bytes32 ETH; //32-bytes equivalent of horses.ETH
59         bytes32 LTC;  //32-bytes equivalent of horses.LTC
60     }
61 
62     struct bet_info{
63         bytes32 horse; // coin on which amount is bet on
64         uint amount; // amount bet by Bettor
65     }
66     struct coin_info{
67         uint256 pre; // locking price
68         uint256 post; // ending price
69         uint160 total; // total coin pool
70         uint32 count; // number of bets
71         bool price_check;
72     }
73     struct voter_info {
74         uint160 total_bet; //total amount of bet placed
75         bool rewarded; // boolean: check for double spending
76         mapping(bytes32=>uint) bets; //array of bets
77     }
78 
79     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
80     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
81 
82     uint public total_reward; // total reward to be awarded
83     uint32 total_bettors;
84     mapping (bytes32 => bool) public winner_horse;
85 
86 
87     // tracking events
88     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
89     event Withdraw(address _to, uint256 _value);
90     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
91     event RefundEnabled(string reason);
92 
93     // constructor
94     constructor() public payable {
95         
96         owner = msg.sender;
97         
98         horses.BTC = bytes32("BTC");
99         horses.ETH = bytes32("ETH");
100         horses.LTC = bytes32("LTC");
101         
102         P3DContract_ = P3DTakeout(0x72b2670e55139934D6445348DC6EaB4089B12576);
103     }
104 
105     // data access structures
106     horses_info public horses;
107     chronus_info public chronus;
108 
109     // modifiers for restricting access to methods
110     modifier onlyOwner {
111         require(owner == msg.sender);
112         _;
113     }
114 
115     modifier duringBetting {
116         require(chronus.betting_open);
117         require(now < chronus.starting_time + chronus.betting_duration);
118         _;
119     }
120 
121     modifier beforeBetting {
122         require(!chronus.betting_open && !chronus.race_start);
123         _;
124     }
125 
126     modifier afterRace {
127         require(chronus.race_end);
128         _;
129     }
130 
131     //function to change owner
132     function changeOwnership(address _newOwner) onlyOwner external {
133         owner = _newOwner;
134     }
135 
136     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
137         require (!chronus.race_end);
138         emit PriceCallback(coin_pointer, result, isPrePrice);
139         chronus.race_start = true;
140         chronus.betting_open = false;
141         if (isPrePrice) {
142             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
143                 emit RefundEnabled("Late start price");
144                 forceVoidRace();
145             } else {
146                 coinIndex[coin_pointer].pre = result;
147             }
148         } else if (!isPrePrice){
149             if (coinIndex[coin_pointer].pre > 0 ){
150                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
151                     emit RefundEnabled("Late end price");
152                     forceVoidRace();
153                 } else {
154                     coinIndex[coin_pointer].post = result;
155                     coinIndex[coin_pointer].price_check = true;
156 
157                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
158                         reward();
159                     }
160                 }
161             } else {
162                 emit RefundEnabled("End price came before start price");
163                 forceVoidRace();
164             }
165         }
166     }
167 
168     // place a bet on a coin(horse) lockBetting
169     function placeBet(bytes32 horse) external duringBetting payable  {
170         require(msg.value >= 0.01 ether);
171         if (voterIndex[msg.sender].total_bet==0) {
172             total_bettors+=1;
173         }
174         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
175         voterIndex[msg.sender].bets[horse] = _newAmount;
176         voterIndex[msg.sender].total_bet += uint160(msg.value);
177         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
178         uint32 _newCount = coinIndex[horse].count + 1;
179         coinIndex[horse].total = _newTotal;
180         coinIndex[horse].count = _newCount;
181         emit Deposit(msg.sender, msg.value, horse, now);
182     }
183 
184     // fallback method for accepting payments
185     function () private payable {}
186 
187     // method to place the oraclize queries
188     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
189             chronus.starting_time = uint32(block.timestamp);
190             chronus.betting_open = true;
191             chronus.betting_duration = _bettingDuration;
192             chronus.race_duration = _raceDuration;
193     }
194 
195     // method to calculate reward (called internally by callback)
196     function reward() internal {
197         /*
198         calculating the difference in price with a precision of 5 digits
199         not using safemath since signed integers are handled
200         */
201         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
202         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
203         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
204 
205         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
206         if (total_bettors <= 1) {
207             emit RefundEnabled("Not enough participants");
208             forceVoidRace();
209         } else {
210             // house takeout
211             uint house_fee = total_reward.mul(5).div(100);
212             require(house_fee < address(this).balance);
213             total_reward = total_reward.sub(house_fee);
214             house_takeout.transfer(house_fee);
215             
216             // p3d takeout
217             uint p3d_fee = house_fee/2;
218             require(p3d_fee < address(this).balance);
219             total_reward = total_reward.sub(p3d_fee);
220             P3DContract_.buyTokens.value(p3d_fee)();
221         }
222 
223         if (horses.BTC_delta > horses.ETH_delta) {
224             if (horses.BTC_delta > horses.LTC_delta) {
225                 winner_horse[horses.BTC] = true;
226                 winnerPoolTotal = coinIndex[horses.BTC].total;
227             }
228             else if(horses.LTC_delta > horses.BTC_delta) {
229                 winner_horse[horses.LTC] = true;
230                 winnerPoolTotal = coinIndex[horses.LTC].total;
231             } else {
232                 winner_horse[horses.BTC] = true;
233                 winner_horse[horses.LTC] = true;
234                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
235             }
236         } else if(horses.ETH_delta > horses.BTC_delta) {
237             if (horses.ETH_delta > horses.LTC_delta) {
238                 winner_horse[horses.ETH] = true;
239                 winnerPoolTotal = coinIndex[horses.ETH].total;
240             }
241             else if (horses.LTC_delta > horses.ETH_delta) {
242                 winner_horse[horses.LTC] = true;
243                 winnerPoolTotal = coinIndex[horses.LTC].total;
244             } else {
245                 winner_horse[horses.ETH] = true;
246                 winner_horse[horses.LTC] = true;
247                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
248             }
249         } else {
250             if (horses.LTC_delta > horses.ETH_delta) {
251                 winner_horse[horses.LTC] = true;
252                 winnerPoolTotal = coinIndex[horses.LTC].total;
253             } else if(horses.LTC_delta < horses.ETH_delta){
254                 winner_horse[horses.ETH] = true;
255                 winner_horse[horses.BTC] = true;
256                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
257             } else {
258                 winner_horse[horses.LTC] = true;
259                 winner_horse[horses.ETH] = true;
260                 winner_horse[horses.BTC] = true;
261                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
262             }
263         }
264         chronus.race_end = true;
265     }
266 
267     // method to calculate an invidual's reward
268     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
269         voter_info storage bettor = voterIndex[candidate];
270         if(chronus.voided_bet) {
271             winner_reward = bettor.total_bet;
272         } else {
273             uint winning_bet_total;
274             if(winner_horse[horses.BTC]) {
275                 winning_bet_total += bettor.bets[horses.BTC];
276             } if(winner_horse[horses.ETH]) {
277                 winning_bet_total += bettor.bets[horses.ETH];
278             } if(winner_horse[horses.LTC]) {
279                 winning_bet_total += bettor.bets[horses.LTC];
280             }
281             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
282         }
283     }
284 
285     // method to just check the reward amount
286     function checkReward() afterRace external constant returns (uint) {
287         require(!voterIndex[msg.sender].rewarded);
288         return calculateReward(msg.sender);
289     }
290 
291     // method to claim the reward amount
292     function claim_reward() afterRace external {
293         require(!voterIndex[msg.sender].rewarded);
294         uint transfer_amount = calculateReward(msg.sender);
295         require(address(this).balance >= transfer_amount);
296         voterIndex[msg.sender].rewarded = true;
297         msg.sender.transfer(transfer_amount);
298         emit Withdraw(msg.sender, transfer_amount);
299     }
300 
301     function forceVoidRace() internal {
302         chronus.voided_bet=true;
303         chronus.race_end = true;
304         chronus.voided_timestamp=uint32(now);
305     }
306 
307     // exposing the coin pool details for DApp
308     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
309         uint256 coinPrePrice;
310         uint256 coinPostPrice;
311         if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {
312             coinPrePrice = coinIndex[index].pre;
313         } 
314         if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {
315             coinPostPrice = coinIndex[index].post;
316         }
317         return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
318     }
319 
320     // exposing the total reward amount for DApp
321     function reward_total() external constant returns (uint) {
322         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
323     }
324 
325     // in case of any errors in race, enable full refund for the Bettors to claim
326     function refund() external onlyOwner {
327         require(now > chronus.starting_time + chronus.race_duration);
328         require((chronus.betting_open && !chronus.race_start)
329             || (chronus.race_start && !chronus.race_end));
330         chronus.voided_bet = true;
331         chronus.race_end = true;
332         chronus.voided_timestamp=uint32(now);
333     }
334 
335     // method to claim unclaimed winnings after 30 day notice period
336     function recovery() external onlyOwner{
337         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
338             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
339         house_takeout.transfer(address(this).balance);
340     }
341 }