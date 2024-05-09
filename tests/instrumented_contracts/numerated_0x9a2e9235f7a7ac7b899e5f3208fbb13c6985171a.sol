1 pragma solidity ^0.4.0;
2 
3 // Visit ethersphere.io for more information
4 
5 contract EtherSphere {
6     mapping(address => uint) bidPool;
7     address[] public bidders;
8     address highestBidder;
9     uint bidderArraySize;
10     uint public numBidders;
11     uint public minBid;
12     uint public interval = 1 days;
13     uint public rewardPool;
14     uint public todaysBidTotal;
15     uint public endOfDay;
16     uint public previousRoundJackpot;
17     uint public highestBid;
18     uint public minBidMultiplier = 10;
19     //Jackpot triggers when todaysBidTotal > rewardPool * 1.05
20     uint public jackpotConditionPercent = 105;
21     //Max bid as a proportion of reward pool pre-jackpot. Disabled by default
22     uint public maxBidPercent; 
23     
24     function EtherSphere(){
25         etherSphereHost = msg.sender;
26         minBid = 0.01 ether;
27         rewardPool = 0;
28         cost = 0;
29         numBidders = 0;
30         todaysBidTotal = 0;
31         previousRoundJackpot = 0;
32         highestBid = 0;
33         bidderArraySize = 0;
34         maxBidPercent = 100; 
35         endOfDay = now + interval;
36     }
37     
38     function inject() ismain payable{
39         rewardPool += msg.value;
40     }
41     
42     function addEtherToSphere() private{
43         if (msg.value < minBid) throw;
44         if (triggerPreJackpotLimit()) throw;
45         
46         bidPool[msg.sender] += msg.value;
47         if (bidPool[msg.sender] > highestBid) {
48             highestBid = bidPool[msg.sender];
49             highestBidder = msg.sender;
50         }
51         todaysBidTotal += msg.value;
52     }
53     
54     function triggerPreJackpotLimit() private returns(bool){
55         if (maxBidPercent == 100) return false;
56         bool willBidExceedPreJackpotLimit = rewardPool * maxBidPercent / 100 < msg.value + bidPool[msg.sender];
57         bool willBePostJackpot = (todaysBidTotal + msg.value) >= (rewardPool * jackpotConditionPercent / 100);
58         return willBidExceedPreJackpotLimit && !willBePostJackpot;
59     }
60     
61     function () payable{
62         if (shouldCompleteDay()) completeDay();
63         recordSenderIfNecessary();
64         addEtherToSphere();
65     }
66     
67     function recordSenderIfNecessary() private{
68        if (bidPool[msg.sender] == 0){
69             setMinBid();
70             if (msg.value < minBid) throw;
71             if (numBidders >= bidderArraySize){
72                 bidders.push(msg.sender);
73                 numBidders++;
74                 bidderArraySize++;
75             }
76             else {
77                 bidders[numBidders] = msg.sender;
78                 numBidders++;
79             }
80             setMinBid();
81         }
82     }
83     
84     function completeDay() private{
85         if (doTriggerJackpot()) {
86             triggerJackpot();
87         }
88         else {
89             previousRoundJackpot = 0;
90         }
91         if (numBidders > 0) {
92             distributeReward();
93             fees();
94             endOfDay = endOfDay + interval;
95         }
96         else {
97             endOfDay = endOfDay + interval;
98             return;
99         }
100         uint poolReserved = todaysBidTotal / 20;
101         rewardPool = todaysBidTotal - poolReserved;
102         cost += poolReserved;
103         todaysBidTotal = 0;
104         highestBid = 0;
105         numBidders = 0;
106     }
107     
108     //Jackpot condition, happens when today's total bids is more than or equals to current pool * condition percent
109     function doTriggerJackpot() private constant returns (bool){
110         return numBidders > 0 && todaysBidTotal > (rewardPool * jackpotConditionPercent / 100);
111     }
112     
113     //Reward all participants
114     function distributeReward() private{
115         uint portion = 0;
116         uint distributed = 0;
117         for (uint i = 0; i < numBidders; i++){
118             address bidderAddress = bidders[i];
119             if (i < numBidders - 1){
120                 portion = bidPool[bidderAddress] * rewardPool / todaysBidTotal;
121             }
122             else {
123                 portion = rewardPool - distributed;
124             }
125             distributed += portion;
126             bidPool[bidderAddress] = 0;
127             sendPortion(portion, bidderAddress);
128         }
129     }
130     
131     function triggerJackpot() private{
132         uint rewardAmount = rewardPool * 35 / 100;
133         rewardPool -= rewardAmount;
134         previousRoundJackpot = rewardAmount;
135         sendPortion(rewardAmount, highestBidder);
136     }
137     
138     function sendPortion(uint amount, address target) private{
139         target.send(amount);
140     }
141     
142     function shouldCompleteDay() private returns (bool){
143         return now > endOfDay;
144     }
145     
146     function containsSender() private constant returns (bool){
147         for (uint i = 0; i < numBidders; i++){
148             if (bidders[i] == msg.sender)
149                 return true;
150         }
151         return false; 
152     }
153     
154     //Change minimum bids as more bidders enter. minBidMultiplier default = 10
155     function setMinBid() private{
156         uint bid = 0.001 ether;
157         if (numBidders > 5){
158             bid = 0.01 ether;
159             if (numBidders > 50){
160                 bid = 0.02 ether;
161                 if (numBidders > 100){
162                     bid = 0.05 ether;
163                     if (numBidders > 150){
164                         bid = 0.1 ether;
165                         if (numBidders > 200){
166                             bid = 0.5 ether;
167                             if (numBidders > 250){
168                                 bid = 2.5 ether;
169                                 if (numBidders > 300){
170                                     bid = 5 ether;
171                                     if (numBidders > 350){
172                                         bid = 10 ether;
173                                     }
174                                 }
175                             }
176                         }
177                     }
178                 }
179             }
180         }
181         minBid = minBidMultiplier * bid;
182     }
183     
184     //administrative functionalities
185     address etherSphereHost;
186     uint cost;
187     
188     //In case we run out of gas
189     function manualEndDay() ismain payable{
190         if (shouldCompleteDay()) completeDay();
191     }
192     //Change bid multiplier to manage volume
193     function changeMinBidMultiplier(uint bidMultiplier) ismain payable{
194         minBidMultiplier = bidMultiplier;
195     }
196     
197     //Change prejackpot cap to prevent game rigging
198     function changePreJackpotBidLimit(uint bidLimit) ismain payable{
199         if (bidLimit == 0) throw;
200         maxBidPercent = bidLimit;
201     }
202     
203     modifier ismain() {
204         if (msg.sender != etherSphereHost) throw;
205         _;
206     }
207     
208     //Clear fees to EtherSphereHost
209     function fees() private {
210         if (cost == 0) return;
211         etherSphereHost.send(cost);
212         cost = 0;
213     }
214     
215     //Manual claim
216     function _fees() ismain payable{
217         fees();
218     }
219     
220     function end() ismain payable{
221         //Allow for termination if game is inactive for more than 7 days
222         if (now > endOfDay + 7 * interval && msg.sender == etherSphereHost)
223             suicide(etherSphereHost);
224     }
225 }