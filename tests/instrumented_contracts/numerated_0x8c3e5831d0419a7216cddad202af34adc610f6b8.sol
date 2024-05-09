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
30 
31 contract Betting{
32     using SafeMath for uint256; //using safemath
33 
34     address public owner; //owner address
35     address house_takeout = 0xf783A81F046448c38f3c863885D9e99D10209779;
36 
37     uint public winnerPoolTotal;
38     string public constant version = "0.2.3";
39 
40     struct chronus_info {
41         bool  betting_open; // boolean: check if betting is open
42         bool  race_start; //boolean: check if race has started
43         bool  race_end; //boolean: check if race has ended
44         bool  voided_bet; //boolean: check if race has been voided
45         uint32  starting_time; // timestamp of when the race starts
46         uint32  betting_duration;
47         uint32  race_duration; // duration of the race
48         uint32 voided_timestamp;
49     }
50 
51     struct horses_info{
52         int64  BTC_delta; //horses.BTC delta value
53         int64  ETH_delta; //horses.ETH delta value
54         int64  LTC_delta; //horses.LTC delta value
55         bytes32 BTC; //32-bytes equivalent of horses.BTC
56         bytes32 ETH; //32-bytes equivalent of horses.ETH
57         bytes32 LTC;  //32-bytes equivalent of horses.LTC
58     }
59 
60     struct bet_info{
61         bytes32 horse; // coin on which amount is bet on
62         uint amount; // amount bet by Bettor
63     }
64     struct coin_info{
65         uint256 pre; // locking price
66         uint256 post; // ending price
67         uint160 total; // total coin pool
68         uint32 count; // number of bets
69         bool price_check;
70     }
71     struct voter_info {
72         uint160 total_bet; //total amount of bet placed
73         bool rewarded; // boolean: check for double spending
74         mapping(bytes32=>uint) bets; //array of bets
75     }
76 
77     mapping (bytes32 => coin_info) public coinIndex; // mapping coins with pool information
78     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
79 
80     uint public total_reward; // total reward to be awarded
81     uint32 total_bettors;
82     mapping (bytes32 => bool) public winner_horse;
83 
84 
85     // tracking events
86     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
87     event Withdraw(address _to, uint256 _value);
88     event PriceCallback(bytes32 coin_pointer, uint256 result, bool isPrePrice);
89     event RefundEnabled(string reason);
90 
91     // constructor
92     constructor() public payable {
93         
94         owner = msg.sender;
95         
96         horses.BTC = bytes32("BTC");
97         horses.ETH = bytes32("ETH");
98         horses.LTC = bytes32("LTC");
99         
100     }
101 
102     // data access structures
103     horses_info public horses;
104     chronus_info public chronus;
105 
106     // modifiers for restricting access to methods
107     modifier onlyOwner {
108         require(owner == msg.sender);
109         _;
110     }
111 
112     modifier duringBetting {
113         require(chronus.betting_open);
114         require(now < chronus.starting_time + chronus.betting_duration);
115         _;
116     }
117 
118     modifier beforeBetting {
119         require(!chronus.betting_open && !chronus.race_start);
120         _;
121     }
122 
123     modifier afterRace {
124         require(chronus.race_end);
125         _;
126     }
127 
128     //function to change owner
129     function changeOwnership(address _newOwner) onlyOwner external {
130         owner = _newOwner;
131     }
132 
133     function priceCallback (bytes32 coin_pointer, uint256 result, bool isPrePrice ) external onlyOwner {
134         require (!chronus.race_end);
135         emit PriceCallback(coin_pointer, result, isPrePrice);
136         chronus.race_start = true;
137         chronus.betting_open = false;
138         if (isPrePrice) {
139             if (now >= chronus.starting_time+chronus.betting_duration+ 60 minutes) {
140                 emit RefundEnabled("Late start price");
141                 forceVoidRace();
142             } else {
143                 coinIndex[coin_pointer].pre = result;
144             }
145         } else if (!isPrePrice){
146             if (coinIndex[coin_pointer].pre > 0 ){
147                 if (now >= chronus.starting_time+chronus.race_duration+ 60 minutes) {
148                     emit RefundEnabled("Late end price");
149                     forceVoidRace();
150                 } else {
151                     coinIndex[coin_pointer].post = result;
152                     coinIndex[coin_pointer].price_check = true;
153 
154                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
155                         reward();
156                     }
157                 }
158             } else {
159                 emit RefundEnabled("End price came before start price");
160                 forceVoidRace();
161             }
162         }
163     }
164 
165     // place a bet on a coin(horse) lockBetting
166     function placeBet(bytes32 horse) external duringBetting payable  {
167         require(msg.value >= 0.01 ether);
168         if (voterIndex[msg.sender].total_bet==0) {
169             total_bettors+=1;
170         }
171         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
172         voterIndex[msg.sender].bets[horse] = _newAmount;
173         voterIndex[msg.sender].total_bet += uint160(msg.value);
174         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value);
175         uint32 _newCount = coinIndex[horse].count + 1;
176         coinIndex[horse].total = _newTotal;
177         coinIndex[horse].count = _newCount;
178         emit Deposit(msg.sender, msg.value, horse, now);
179     }
180 
181     // fallback method for accepting payments
182     function () private payable {}
183 
184     // method to place the oraclize queries
185     function setupRace(uint32 _bettingDuration, uint32 _raceDuration) onlyOwner beforeBetting external payable {
186             chronus.starting_time = uint32(block.timestamp);
187             chronus.betting_open = true;
188             chronus.betting_duration = _bettingDuration;
189             chronus.race_duration = _raceDuration;
190     }
191 
192     // method to calculate reward (called internally by callback)
193     function reward() internal {
194         /*
195         calculating the difference in price with a precision of 5 digits
196         not using safemath since signed integers are handled
197         */
198         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
199         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
200         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
201 
202         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
203         if (total_bettors <= 1) {
204             emit RefundEnabled("Not enough participants");
205             forceVoidRace();
206         } else {
207             uint house_fee = total_reward.mul(5).div(100);
208             require(house_fee < address(this).balance);
209             total_reward = total_reward.sub(house_fee);
210             house_takeout.transfer(house_fee);
211         }
212 
213         if (horses.BTC_delta > horses.ETH_delta) {
214             if (horses.BTC_delta > horses.LTC_delta) {
215                 winner_horse[horses.BTC] = true;
216                 winnerPoolTotal = coinIndex[horses.BTC].total;
217             }
218             else if(horses.LTC_delta > horses.BTC_delta) {
219                 winner_horse[horses.LTC] = true;
220                 winnerPoolTotal = coinIndex[horses.LTC].total;
221             } else {
222                 winner_horse[horses.BTC] = true;
223                 winner_horse[horses.LTC] = true;
224                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
225             }
226         } else if(horses.ETH_delta > horses.BTC_delta) {
227             if (horses.ETH_delta > horses.LTC_delta) {
228                 winner_horse[horses.ETH] = true;
229                 winnerPoolTotal = coinIndex[horses.ETH].total;
230             }
231             else if (horses.LTC_delta > horses.ETH_delta) {
232                 winner_horse[horses.LTC] = true;
233                 winnerPoolTotal = coinIndex[horses.LTC].total;
234             } else {
235                 winner_horse[horses.ETH] = true;
236                 winner_horse[horses.LTC] = true;
237                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
238             }
239         } else {
240             if (horses.LTC_delta > horses.ETH_delta) {
241                 winner_horse[horses.LTC] = true;
242                 winnerPoolTotal = coinIndex[horses.LTC].total;
243             } else if(horses.LTC_delta < horses.ETH_delta){
244                 winner_horse[horses.ETH] = true;
245                 winner_horse[horses.BTC] = true;
246                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
247             } else {
248                 winner_horse[horses.LTC] = true;
249                 winner_horse[horses.ETH] = true;
250                 winner_horse[horses.BTC] = true;
251                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
252             }
253         }
254         chronus.race_end = true;
255     }
256 
257     // method to calculate an invidual's reward
258     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
259         voter_info storage bettor = voterIndex[candidate];
260         if(chronus.voided_bet) {
261             winner_reward = bettor.total_bet;
262         } else {
263             uint winning_bet_total;
264             if(winner_horse[horses.BTC]) {
265                 winning_bet_total += bettor.bets[horses.BTC];
266             } if(winner_horse[horses.ETH]) {
267                 winning_bet_total += bettor.bets[horses.ETH];
268             } if(winner_horse[horses.LTC]) {
269                 winning_bet_total += bettor.bets[horses.LTC];
270             }
271             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
272         }
273     }
274 
275     // method to just check the reward amount
276     function checkReward() afterRace external constant returns (uint) {
277         require(!voterIndex[msg.sender].rewarded);
278         return calculateReward(msg.sender);
279     }
280 
281     // method to claim the reward amount
282     function claim_reward() afterRace external {
283         require(!voterIndex[msg.sender].rewarded);
284         uint transfer_amount = calculateReward(msg.sender);
285         require(address(this).balance >= transfer_amount);
286         voterIndex[msg.sender].rewarded = true;
287         msg.sender.transfer(transfer_amount);
288         emit Withdraw(msg.sender, transfer_amount);
289     }
290 
291     function forceVoidRace() internal {
292         chronus.voided_bet=true;
293         chronus.race_end = true;
294         chronus.voided_timestamp=uint32(now);
295     }
296 
297     // exposing the coin pool details for DApp
298     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
299         uint256 coinPrePrice;
300         uint256 coinPostPrice;
301         if (coinIndex[horses.ETH].pre > 0 && coinIndex[horses.BTC].pre > 0 && coinIndex[horses.LTC].pre > 0) {
302             coinPrePrice = coinIndex[index].pre;
303         } 
304         if (coinIndex[horses.ETH].post > 0 && coinIndex[horses.BTC].post > 0 && coinIndex[horses.LTC].post > 0) {
305             coinPostPrice = coinIndex[index].post;
306         }
307         return (coinIndex[index].total, coinPrePrice, coinPostPrice, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
308     }
309 
310     // exposing the total reward amount for DApp
311     function reward_total() external constant returns (uint) {
312         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
313     }
314 
315     // in case of any errors in race, enable full refund for the Bettors to claim
316     function refund() external onlyOwner {
317         require(now > chronus.starting_time + chronus.race_duration);
318         require((chronus.betting_open && !chronus.race_start)
319             || (chronus.race_start && !chronus.race_end));
320         chronus.voided_bet = true;
321         chronus.race_end = true;
322         chronus.voided_timestamp=uint32(now);
323     }
324 
325     // method to claim unclaimed winnings after 30 day notice period
326     function recovery() external onlyOwner{
327         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
328             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
329         house_takeout.transfer(address(this).balance);
330     }
331 }