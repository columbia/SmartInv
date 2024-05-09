1 pragma solidity ^0.4.20;
2 
3 pragma solidity ^0.4.21;
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 interface P3DTakeout {
31     function buyTokens() external payable;
32 }
33 
34 contract Betting{
35     using SafeMath for uint256; //using safemath
36 
37     address public owner; //owner address
38     address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
39     P3DTakeout P3DContract_;
40 
41     uint public winnerPoolTotal;
42     string public constant version = "0.2.4";
43 
44     struct chronus_info {
45         bool  betting_open; // boolean: check if betting is open
46         bool  race_start; //boolean: check if race has started
47         bool  race_end; //boolean: check if race has ended
48         bool  voided_bet; //boolean: check if race has been voided
49         uint32  starting_time; // timestamp of when the race starts
50         uint32  betting_duration;
51         uint32  race_duration; // duration of the race
52         uint32 voided_timestamp;
53     }
54 
55     struct horses_info{
56         int64  BTC_delta; //horses.BTC delta value
57         int64  ETH_delta; //horses.ETH delta value
58         int64  LTC_delta; //horses.LTC delta value
59         bytes32 BTC; //32-bytes equivalent of horses.BTC
60         bytes32 ETH; //32-bytes equivalent of horses.ETH
61         bytes32 LTC;  //32-bytes equivalent of horses.LTC
62     }
63 
64     struct bet_info{
65         bytes32 horse; // coin on which amount is bet on
66         uint amount; // amount bet by Bettor
67     }
68     struct coin_info{
69         uint256 pre; // locking price
70         uint256 post; // ending price
71         uint160 total; // total coin pool
72         uint32 count; // number of bets
73         bool price_check;
74     }
75     struct voter_info {
76         uint160 total_bet; //total amount of bet placed
77         bool rewarded; // boolean: check for double spending
78         mapping(bytes32=>uint) bets; //array of bets
79     }
80 
81     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
82     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
83 
84     uint public total_reward; // total reward to be awarded
85     uint32 total_bettors;
86     mapping (bytes32 => bool) public winner_horse;
87 
88 
89     // tracking events
90     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
91     event Withdraw(address _to, uint256 _value);
92     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
93     event RefundEnabled(string reason);
94 
95     // constructor
96     constructor() public payable {
97         
98         owner = msg.sender;
99         
100         horses.BTC = bytes32("BTC");
101         horses.ETH = bytes32("ETH");
102         horses.LTC = bytes32("LTC");
103         
104         P3DContract_ = P3DTakeout(0x72b2670e55139934D6445348DC6EaB4089B12576);
105     }
106 
107     // data access structures
108     horses_info public horses;
109     chronus_info public chronus;
110 
111     // modifiers for restricting access to methods
112     modifier onlyOwner {
113         require(owner == msg.sender);
114         _;
115     }
116 
117     modifier duringBetting {
118         require(chronus.betting_open);
119         require(now < chronus.starting_time + chronus.betting_duration);
120         _;
121     }
122 
123     modifier beforeBetting {
124         require(!chronus.betting_open && !chronus.race_start);
125         _;
126     }
127 
128     modifier afterRace {
129         require(chronus.race_end);
130         _;
131     }
132 
133     //function to change owner
134     function changeOwnership(address _newOwner) onlyOwner external {
135         require(now > chronus.starting_time + chronus.race_duration + 60 minutes);
136         owner = _newOwner;
137     }
138 
139     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
140         require (!chronus.race_end);
141         emit PriceCallback(coin_pointer, result, isPrePrice);
142         chronus.race_start = true;
143         chronus.betting_open = false;
144         if (isPrePrice) {
145             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
146                 emit RefundEnabled("Late start price");
147                 forceVoidRace();
148             } else {
149                 coinIndex[coin_pointer].pre = result;
150             }
151         } else if (!isPrePrice){
152             if (coinIndex[coin_pointer].pre > 0 ){
153                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
154                     emit RefundEnabled("Late end price");
155                     forceVoidRace();
156                 } else {
157                     coinIndex[coin_pointer].post = result;
158                     coinIndex[coin_pointer].price_check = true;
159 
160                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
161                         reward();
162                     }
163                 }
164             } else {
165                 emit RefundEnabled("End price came before start price");
166                 forceVoidRace();
167             }
168         }
169     }
170 
171     // place a bet on a coin(horse) lockBetting
172     function placeBet(bytes32 horse) external duringBetting payable  {
173         require(msg.value >= 0.01 ether);
174         if (voterIndex[msg.sender].total_bet==0) {
175             total_bettors+=1;
176         }
177         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
178         voterIndex[msg.sender].bets[horse] = _newAmount;
179         voterIndex[msg.sender].total_bet += uint160(msg.value);
180         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
181         uint32 _newCount = coinIndex[horse].count + 1;
182         coinIndex[horse].total = _newTotal;
183         coinIndex[horse].count = _newCount;
184         emit Deposit(msg.sender, msg.value, horse, now);
185     }
186 
187     // fallback method for accepting payments
188     function () private payable {}
189 
190     // method to place the oraclize queries
191     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
192             chronus.starting_time = uint32(block.timestamp);
193             chronus.betting_open = true;
194             chronus.betting_duration = _bettingDuration;
195             chronus.race_duration = _raceDuration;
196     }
197 
198     // method to calculate reward (called internally by callback)
199     function reward() internal {
200         /*
201         calculating the difference in price with a precision of 5 digits
202         not using safemath since signed integers are handled
203         */
204         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
205         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
206         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
207 
208         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
209         if (total_bettors <= 1) {
210             emit RefundEnabled("Not enough participants");
211             forceVoidRace();
212         } else {
213             // house takeout
214             uint house_fee = total_reward.mul(5).div(100);
215             require(house_fee < address(this).balance);
216             total_reward = total_reward.sub(house_fee);
217             house_takeout.transfer(house_fee);
218             
219             // p3d takeout
220             uint p3d_fee = house_fee/2;
221             require(p3d_fee < address(this).balance);
222             total_reward = total_reward.sub(p3d_fee);
223             P3DContract_.buyTokens.value(p3d_fee)();
224         }
225 
226         if (horses.BTC_delta > horses.ETH_delta) {
227             if (horses.BTC_delta > horses.LTC_delta) {
228                 winner_horse[horses.BTC] = true;
229                 winnerPoolTotal = coinIndex[horses.BTC].total;
230             }
231             else if(horses.LTC_delta > horses.BTC_delta) {
232                 winner_horse[horses.LTC] = true;
233                 winnerPoolTotal = coinIndex[horses.LTC].total;
234             } else {
235                 winner_horse[horses.BTC] = true;
236                 winner_horse[horses.LTC] = true;
237                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
238             }
239         } else if(horses.ETH_delta > horses.BTC_delta) {
240             if (horses.ETH_delta > horses.LTC_delta) {
241                 winner_horse[horses.ETH] = true;
242                 winnerPoolTotal = coinIndex[horses.ETH].total;
243             }
244             else if (horses.LTC_delta > horses.ETH_delta) {
245                 winner_horse[horses.LTC] = true;
246                 winnerPoolTotal = coinIndex[horses.LTC].total;
247             } else {
248                 winner_horse[horses.ETH] = true;
249                 winner_horse[horses.LTC] = true;
250                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
251             }
252         } else {
253             if (horses.LTC_delta > horses.ETH_delta) {
254                 winner_horse[horses.LTC] = true;
255                 winnerPoolTotal = coinIndex[horses.LTC].total;
256             } else if(horses.LTC_delta < horses.ETH_delta){
257                 winner_horse[horses.ETH] = true;
258                 winner_horse[horses.BTC] = true;
259                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
260             } else {
261                 winner_horse[horses.LTC] = true;
262                 winner_horse[horses.ETH] = true;
263                 winner_horse[horses.BTC] = true;
264                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
265             }
266         }
267         chronus.race_end = true;
268     }
269 
270     // method to calculate an invidual's reward
271     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
272         voter_info storage bettor = voterIndex[candidate];
273         if(chronus.voided_bet) {
274             winner_reward = bettor.total_bet;
275         } else {
276             uint winning_bet_total;
277             if(winner_horse[horses.BTC]) {
278                 winning_bet_total += bettor.bets[horses.BTC];
279             } if(winner_horse[horses.ETH]) {
280                 winning_bet_total += bettor.bets[horses.ETH];
281             } if(winner_horse[horses.LTC]) {
282                 winning_bet_total += bettor.bets[horses.LTC];
283             }
284             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
285         }
286     }
287 
288     // method to just check the reward amount
289     function checkReward() afterRace external constant returns (uint) {
290         require(!voterIndex[msg.sender].rewarded);
291         return calculateReward(msg.sender);
292     }
293 
294     // method to claim the reward amount
295     function claim_reward() afterRace external {
296         require(!voterIndex[msg.sender].rewarded);
297         uint transfer_amount = calculateReward(msg.sender);
298         require(address(this).balance >= transfer_amount);
299         voterIndex[msg.sender].rewarded = true;
300         msg.sender.transfer(transfer_amount);
301         emit Withdraw(msg.sender, transfer_amount);
302     }
303 
304     function forceVoidRace() internal {
305         require(!chronus.voided_bet);
306         chronus.voided_bet=true;
307         chronus.race_end = true;
308         chronus.voided_timestamp=uint32(now);
309     }
310     
311     //this methohd can only be called by controller contract in case of timestamp errors
312     function forceVoidExternal() external onlyOwner {
313         forceVoidRace();
314         emit RefundEnabled("Inaccurate price timestamp");
315     }
316 
317     // exposing the coin pool details for DApp
318     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
319         uint256 coinPrePrice;
320         uint256 coinPostPrice;
321         if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {
322             coinPrePrice = coinIndex[index].pre;
323         } 
324         if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {
325             coinPostPrice = coinIndex[index].post;
326         }
327         return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
328     }
329 
330     // exposing the total reward amount for DApp
331     function reward_total() external constant returns (uint) {
332         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
333     }
334     
335     function getChronus() external view returns (uint32[]) {
336         uint32[] memory chronusData = new uint32[](3);
337         chronusData[0] = chronus.starting_time;
338         chronusData[1] = chronus.betting_duration;
339         chronusData[2] = chronus.race_duration;
340         return (chronusData);
341         // return (chronus.starting_time, chronus.betting_duration ,chronus.race_duration);
342     }
343 
344     // in case of any errors in race, enable full refund for the Bettors to claim
345     function refund() external onlyOwner {
346         require(now > chronus.starting_time + chronus.race_duration + 60 minutes);
347         require((chronus.betting_open && !chronus.race_start)
348             || (chronus.race_start && !chronus.race_end));
349         chronus.voided_bet = true;
350         chronus.race_end = true;
351         chronus.voided_timestamp=uint32(now);
352     }
353 
354     // method to claim unclaimed winnings after 30 day notice period
355     function recovery() external onlyOwner{
356         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
357             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
358         house_takeout.transfer(address(this).balance);
359     }
360 }