1 /*
2 This software code is prohibited for copying and distribution. 
3 The violation of this requirement will be punished by law. 
4 
5 Contact e-mail: maridendier@openmailbox.org
6 
7 Project site: http://thebigbang.online/
8 
9 Developed by "Naumov Lab" http://smart-contracts.ru/
10 */
11 
12 pragma solidity ^0.4.24;
13 
14 
15 library SafeMath {
16     
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38   
39 }
40 
41 
42 contract Ownable {
43 
44   address public owner;
45 
46   constructor() public {
47     owner = msg.sender;
48   }
49 
50 }
51 
52 
53 contract TheBigBangOnline is Ownable {
54         
55     using SafeMath for uint256;
56     
57     event payEventLog(address indexed _address, uint value, uint periodCount, uint percent, uint time);
58     event payRefEventLog(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);
59     event payJackpotLog(address indexed _address, uint value, uint totalValue, uint userValue, uint time);    
60     
61     uint public period = 24 hours;
62     uint public startTime = 1536537600; //  Mon, 10 Sep 2018 00:00:00 GMT
63     
64     uint public basicDayPercent = 300; //3%
65     uint public bonusDayPercent = 330; //3.3%
66     
67     uint public referrerLevel1Percent = 250; //2.5%
68     uint public referrerLevel2Percent = 500; //5%
69     uint public referrerLevel3Percent = 1000; //10%    
70     
71     uint public referrerLevel2Ether = 1 ether;
72     uint public referrerLevel3Ether = 10 ether;
73     
74     uint public minBet = 0.01  ether;
75     
76     uint public referrerAndOwnerPercent = 2000; //20%    
77     
78     uint public currBetID = 1;
79     
80     
81     struct BetStruct {
82         uint value;
83         uint refValue;
84         uint firstBetTime;
85         uint lastBetTime;
86         uint lastPaymentTime;
87         uint nextPayAfterTime;
88         bool isExist;
89         uint id;
90         uint referrerID;
91     }
92     
93     mapping (address => BetStruct) public betsDatabase;
94     mapping (uint => address) public addressList;
95     
96     // Jackpot
97     uint public jackpotPercent = 1000; //10%
98     uint public jackpotBank = 0;
99     uint public jackpotMaxTime = 24 hours;
100     uint public jackpotTime = startTime + jackpotMaxTime;  
101     uint public increaseJackpotTimeAfterBet = 10 minutes;
102     
103     uint public gameRound = 1;   
104     uint public currJackpotBetID = 0;
105     
106     struct BetStructForJackpot {
107         uint value;
108         address user;
109     }
110     mapping (uint => BetStructForJackpot) public betForJackpot;    
111     
112     
113     
114     
115     constructor() public {
116     
117     }
118 
119     
120  function createBet(uint _referrerID) public payable {
121      
122         if( (_referrerID >= currBetID)&&(_referrerID!=0)){
123             revert("Incorrect _referrerID");
124         }
125 
126         if( msg.value < minBet){
127             revert("Amount beyond acceptable limits");
128         }
129         
130             BetStruct memory betStruct;
131             
132             if(betsDatabase[msg.sender].isExist){
133                 betStruct = betsDatabase[msg.sender];
134                 
135                 if( (betStruct.nextPayAfterTime < now) && (gameRound==1) ){
136                     getRewardForAddress(msg.sender);    
137                 }            
138                 
139                 betStruct.value += msg.value;
140                 betStruct.lastBetTime = now;
141                 
142                 betsDatabase[msg.sender] = betStruct;
143                 
144             } else {
145                 
146                 uint nextPayAfterTime = startTime+((now.sub(startTime)).div(period)).mul(period)+period;
147     
148                 betStruct = BetStruct({ 
149                     value : msg.value,
150                     refValue : 0,
151                     firstBetTime : now,
152                     lastBetTime : now,
153                     lastPaymentTime : 0,
154                     nextPayAfterTime: nextPayAfterTime,
155                     isExist : true,
156                     id : currBetID,
157                     referrerID : _referrerID
158                 });
159             
160                 betsDatabase[msg.sender] = betStruct;
161                 addressList[currBetID] = msg.sender;
162                 
163                 currBetID++;
164             }
165             
166             if(now > jackpotTime){
167                 getJackpot();
168             }            
169             
170             currJackpotBetID++;
171             
172             BetStructForJackpot memory betStructForJackpot;
173             betStructForJackpot.user = msg.sender;
174             betStructForJackpot.value = msg.value;
175             
176             betForJackpot[currJackpotBetID] = betStructForJackpot;
177             
178             jackpotTime += increaseJackpotTimeAfterBet;
179             if( jackpotTime > now + jackpotMaxTime ) {
180                 jackpotTime = now + jackpotMaxTime;
181             }
182             
183             if(gameRound==1){
184                 jackpotBank += msg.value.mul(jackpotPercent).div(10000);
185             }
186             else {
187                 jackpotBank += msg.value.mul(10000-referrerAndOwnerPercent).div(10000);
188             }
189     
190             if(betStruct.referrerID!=0){
191                 betsDatabase[addressList[betStruct.referrerID]].refValue += msg.value;
192                 
193                 uint currReferrerPercent;
194                 uint currReferrerValue = betsDatabase[addressList[betStruct.referrerID]].value.add(betsDatabase[addressList[betStruct.referrerID]].refValue);
195                 
196                 if (currReferrerValue >= referrerLevel3Ether){
197                     currReferrerPercent = referrerLevel3Percent;
198                 } else if (currReferrerValue >= referrerLevel2Ether) {
199                    currReferrerPercent = referrerLevel2Percent; 
200                 } else {
201                     currReferrerPercent = referrerLevel1Percent;
202                 }
203                 
204                 uint refToPay = msg.value.mul(currReferrerPercent).div(10000);
205                 
206                 addressList[betStruct.referrerID].transfer( refToPay );
207                 owner.transfer(msg.value.mul(referrerAndOwnerPercent - currReferrerPercent).div(10000));
208                 
209                 emit payRefEventLog(msg.sender, addressList[betStruct.referrerID], refToPay, currReferrerPercent, now);
210             } else {
211                 owner.transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
212             }
213   }
214     
215   function () public payable {
216         createBet(0);
217   } 
218   
219   
220   function getReward() public {
221         getRewardForAddress(msg.sender);
222   }
223   
224   function getRewardForAddress(address _address) public {
225         if(gameRound!=1){
226              revert("The first round end");    
227         }        
228       
229         if(!betsDatabase[_address].isExist){
230              revert("Address are not an investor");    
231         }
232         
233         if(betsDatabase[_address].nextPayAfterTime >= now){
234              revert("The payout time has not yet come");    
235         }
236 
237         uint periodCount = now.sub(betsDatabase[_address].nextPayAfterTime).div(period).add(1);
238         uint percent = basicDayPercent;
239         
240         if(betsDatabase[_address].referrerID>0){
241             percent = bonusDayPercent;
242         }
243         
244         uint toPay = periodCount.mul(betsDatabase[_address].value).div(10000).mul(percent);
245         
246         betsDatabase[_address].lastPaymentTime = now;
247         betsDatabase[_address].nextPayAfterTime += periodCount.mul(period); 
248         
249         if(toPay.add(jackpotBank) >= address(this).balance ){
250             toPay = address(this).balance.sub(jackpotBank);
251             gameRound = 2;
252         }
253         
254         _address.transfer(toPay);
255         
256         emit payEventLog(_address, toPay, periodCount, percent, now);
257   }
258   
259   function getJackpot() public {
260         if(now <= jackpotTime){
261             revert("Jackpot did not come");  
262         }
263         
264         jackpotTime = now + jackpotMaxTime;
265         
266         if(currJackpotBetID > 5){
267             uint toPay = jackpotBank;
268             jackpotBank = 0;            
269             
270             uint totalValue = betForJackpot[currJackpotBetID].value + betForJackpot[currJackpotBetID - 1].value + betForJackpot[currJackpotBetID - 2].value + betForJackpot[currJackpotBetID - 3].value + betForJackpot[currJackpotBetID - 4].value;
271             
272             betForJackpot[currJackpotBetID].user.transfer(toPay.mul(betForJackpot[currJackpotBetID].value).div(totalValue) );
273             emit payJackpotLog(betForJackpot[currJackpotBetID].user, toPay.mul(betForJackpot[currJackpotBetID].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID].value, now);
274             
275             betForJackpot[currJackpotBetID-1].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-1].value).div(totalValue) );
276             emit payJackpotLog(betForJackpot[currJackpotBetID-1].user, toPay.mul(betForJackpot[currJackpotBetID-1].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-1].value, now);
277             
278             betForJackpot[currJackpotBetID-2].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-2].value).div(totalValue) );
279             emit payJackpotLog(betForJackpot[currJackpotBetID-2].user, toPay.mul(betForJackpot[currJackpotBetID-2].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-2].value, now);
280             
281             betForJackpot[currJackpotBetID-3].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-3].value).div(totalValue) );
282             emit payJackpotLog(betForJackpot[currJackpotBetID-3].user, toPay.mul(betForJackpot[currJackpotBetID-3].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-3].value, now);
283             
284             betForJackpot[currJackpotBetID-4].user.transfer(toPay.mul(betForJackpot[currJackpotBetID-4].value).div(totalValue) );
285             emit payJackpotLog(betForJackpot[currJackpotBetID-4].user, toPay.mul(betForJackpot[currJackpotBetID-4].value).div(totalValue), totalValue, betForJackpot[currJackpotBetID-4].value, now);
286         }
287         
288   }
289     
290 }