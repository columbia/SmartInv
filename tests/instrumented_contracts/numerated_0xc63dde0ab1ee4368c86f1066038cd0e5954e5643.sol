1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27   
28 }
29 
30 
31 contract Ownable {
32 
33   address public owner;
34 
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39 }
40 
41 
42 contract EthFactory is Ownable {
43         
44     using SafeMath for uint256;
45     
46     event payEventLog(address indexed _address, uint value, uint periodCount, uint percent, uint time);
47     event payRefEventLog(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);
48     event payJackpotLog(address indexed _address, uint value, uint totalValue, uint userValue, uint time);    
49     
50     uint public basicDayPercent = 300;
51     uint public bonusDayPercent = 330;
52     
53     uint public referrerLevel1Percent = 250;
54     uint public referrerLevel2Percent = 500;
55     uint public referrerLevel3Percent = 1000;    
56     uint public referrerAndOwnerPercent = 2000;
57     
58     uint public referrerLevel2Ether = 1 ether;
59     uint public referrerLevel3Ether = 10 ether;
60     
61     uint public minBet = 0.01  ether;
62     
63     uint public currBetID = 1;
64     uint public period = 24 hours;
65     uint public startTime = 1536580800;
66     
67     
68     
69     
70     struct BetStruct {
71         uint value;
72         uint refValue;
73         uint firstBetTime;
74         uint lastBetTime;
75         uint lastPaymentTime;
76         uint nextPayAfterTime;
77         bool exists;
78         uint id;
79         uint referrerID;
80     }
81     
82     mapping (uint => address) public addressList;
83     mapping (address => BetStruct) public betsDatabase;
84     
85     // Jackpot
86     uint public jackpotPercent = 1000; //10%
87     uint public jackpotBank = 0;
88     uint public jackpotMaxTime = 24 hours;
89     uint public jackpotTime = startTime + jackpotMaxTime;  
90     uint public increaseJackpotTimeAfterBet = 10 minutes;
91     
92     uint public gameRound = 1;   
93     uint public currJackpotBetID = 0;
94     
95     struct BetStructForJackpot {
96         uint value;
97         address user;
98     }
99     mapping (uint => BetStructForJackpot) public betForJackpot;    
100     
101     
102     
103     
104     constructor() public {
105     
106     }
107 
108     
109  function createBet(uint _referrerID) public payable {
110      
111         if( (_referrerID >= currBetID)&&(_referrerID!=0)){
112             revert("Incorrect _referrerID");
113         }
114 
115         if( msg.value < minBet){
116             revert("Amount beyond acceptable limits");
117         }
118         
119             BetStruct memory betStruct;
120             
121             if(betsDatabase[msg.sender].exists){
122                 betStruct = betsDatabase[msg.sender];
123                 
124                 if( (betStruct.nextPayAfterTime < now) && (gameRound==1) ){
125                     getRewardForAddress(msg.sender);    
126                 }            
127                 
128                 betStruct.value += msg.value;
129                 betStruct.lastBetTime = now;
130                 
131                 betsDatabase[msg.sender] = betStruct;
132                 
133             } else {
134                 
135                 uint nextPayAfterTime = startTime+((now.sub(startTime)).div(period)).mul(period)+period;
136     
137                 betStruct = BetStruct({ 
138                     value : msg.value,
139                     refValue : 0,
140                     firstBetTime : now,
141                     lastBetTime : now,
142                     lastPaymentTime : 0,
143                     nextPayAfterTime: nextPayAfterTime,
144                     exists : true,
145                     id : currBetID,
146                     referrerID : _referrerID
147                 });
148             
149                 betsDatabase[msg.sender] = betStruct;
150                 addressList[currBetID] = msg.sender;
151                 
152                 currBetID++;
153             }
154             
155             if(now > jackpotTime){
156                 getJackpot();
157             }            
158             
159             currJackpotBetID++;
160             
161             BetStructForJackpot memory betStructForJackpot;
162             betStructForJackpot.user = msg.sender;
163             betStructForJackpot.value = msg.value;
164             
165             betForJackpot[currJackpotBetID] = betStructForJackpot;
166             
167             jackpotTime += increaseJackpotTimeAfterBet;
168             if( jackpotTime > now + jackpotMaxTime ) {
169                 jackpotTime = now + jackpotMaxTime;
170             }
171             
172             if(gameRound==1){
173                 jackpotBank += msg.value.mul(jackpotPercent).div(10000);
174             }
175             else {
176                 jackpotBank += msg.value.mul(10000-referrerAndOwnerPercent).div(10000);
177             }
178     
179             if(betStruct.referrerID!=0){
180                 betsDatabase[addressList[betStruct.referrerID]].refValue += msg.value;
181                 
182                 uint currReferrerPercent;
183                 uint currReferrerValue = betsDatabase[addressList[betStruct.referrerID]].value.add(betsDatabase[addressList[betStruct.referrerID]].refValue);
184                 
185                 if (currReferrerValue >= referrerLevel3Ether){
186                     currReferrerPercent = referrerLevel3Percent;
187                 } else if (currReferrerValue >= referrerLevel2Ether) {
188                    currReferrerPercent = referrerLevel2Percent; 
189                 } else {
190                     currReferrerPercent = referrerLevel1Percent;
191                 }
192                 
193                 uint refToPay = msg.value.mul(currReferrerPercent).div(10000);
194                 
195                 addressList[betStruct.referrerID].transfer( refToPay );
196                 owner.transfer(msg.value.mul(referrerAndOwnerPercent - currReferrerPercent).div(10000));
197                 
198                 emit payRefEventLog(msg.sender, addressList[betStruct.referrerID], refToPay, currReferrerPercent, now);
199             } else {
200                 owner.transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
201             }
202   }
203     
204   function () public payable {
205         createBet(0);
206   } 
207   
208   
209   function getReward() public {
210         getRewardForAddress(msg.sender);
211   }
212   
213   function getRewardForAddress(address _address) public {
214         if(gameRound!=1){
215              revert("The first round ended");    
216         }        
217       
218         if(!betsDatabase[_address].exists){
219              revert("You are not an investor");    
220         }
221         
222         if(betsDatabase[_address].nextPayAfterTime >= now){
223              revert("The payout time has not yet arrived");    
224         }
225 
226         uint periodCount = now.sub(betsDatabase[_address].nextPayAfterTime).div(period).add(1);
227         uint percent = basicDayPercent;
228         
229         if(betsDatabase[_address].referrerID>0){
230             percent = bonusDayPercent;
231         }
232         
233         uint toPay = periodCount.mul(betsDatabase[_address].value).div(10000).mul(percent);
234         
235         betsDatabase[_address].lastPaymentTime = now;
236         betsDatabase[_address].nextPayAfterTime += periodCount.mul(period); 
237         
238         if(toPay.add(jackpotBank) >= address(this).balance ){
239             toPay = address(this).balance.sub(jackpotBank);
240             gameRound = 2;
241         }
242         
243         _address.transfer(toPay);
244         
245         emit payEventLog(_address, toPay, periodCount, percent, now);
246   }
247   
248   function getJackpot() public {
249         if(now <= jackpotTime){
250             revert("Jackpot isn't here yet");  
251         }
252         
253         jackpotTime = now + jackpotMaxTime;
254         
255         if(currJackpotBetID > 5){
256             uint toPay = jackpotBank;
257             jackpotBank = 0;            
258             
259             uint totalValue = betForJackpot[currJackpotBetID].value + betForJackpot[currJackpotBetID - 1].value + betForJackpot[currJackpotBetID - 2].value + betForJackpot[currJackpotBetID - 3].value + betForJackpot[currJackpotBetID - 4].value;
260             
261             betForJackpot[currJackpotBetID].user.transfer(toPay.mul(betForJackpot[currJackpotBetID].value).div(totalValue) );
262             emit payJackpotLog(betForJackpot[currJackpotBetID].user, toPay.mul(betForJackpot[currJackpotBetID].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID].value, now);
263             
264             betForJackpot[currJackpotBetID-1].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-1].value).div(totalValue) );
265             emit payJackpotLog(betForJackpot[currJackpotBetID-1].user, toPay.mul(betForJackpot[currJackpotBetID-1].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-1].value, now);
266             
267             betForJackpot[currJackpotBetID-2].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-2].value).div(totalValue) );
268             emit payJackpotLog(betForJackpot[currJackpotBetID-2].user, toPay.mul(betForJackpot[currJackpotBetID-2].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-2].value, now);
269             
270             betForJackpot[currJackpotBetID-3].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-3].value).div(totalValue) );
271             emit payJackpotLog(betForJackpot[currJackpotBetID-3].user, toPay.mul(betForJackpot[currJackpotBetID-3].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-3].value, now);
272             
273             betForJackpot[currJackpotBetID-4].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-4].value).div(totalValue) );
274             emit payJackpotLog(betForJackpot[currJackpotBetID-4].user, toPay.mul(betForJackpot[currJackpotBetID-4].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-4].value, now);
275         }
276         
277   }
278     
279 }