1 /*
2 This software code is prohibited for copying and distribution. 
3 The violation of this requirement will be punished by law. 
4 
5 Contact e-mail: thebigbangonline@protonmail.com
6 
7 Project site: http://thebigbang.online/
8 
9 Calling the methods of this smart contract you accept the rules of the "The Big Bang" game, described by this program code.
10 */
11 
12 pragma solidity ^0.4.25;
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
45   address public manager;
46   address public ownerWallet;
47 
48   constructor() public {
49     owner = msg.sender;
50     manager = msg.sender;
51     ownerWallet = msg.sender;
52   }
53   
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }  
58   
59   modifier onlyOwnerOrManager() {
60      require((msg.sender == owner)||(msg.sender == manager));
61       _;
62   }  
63   
64   function transferOwnership(address newOwner) public onlyOwner {
65     owner = newOwner;
66   }
67   
68   function setManager(address _manager) public onlyOwnerOrManager {
69       require(_manager != address(0));
70       manager = _manager;
71   }  
72   
73   function setOwnerWallet(address _ownerWallet) public onlyOwner {
74       require(_ownerWallet != address(0));
75       ownerWallet = _ownerWallet;
76   }   
77 
78 }
79 
80 
81 
82 
83 contract TheBigBangOnline is Ownable {
84         
85     using SafeMath for uint256;
86     
87     bool contractProtection = true;
88     
89     modifier notFromContract() {
90       if ( (msg.sender != tx.origin) && (contractProtection == true)){
91           revert("call from contract");
92       }        
93         _;
94     }     
95     
96     event payEventLog(address indexed _address, uint value, uint periodCount, uint percent, uint time, bool result);
97     event payRefEventLog(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time, bool result);
98     event payJackpotLog(address indexed _address, uint value, uint totalValue, uint userValue, uint time, bool result);   
99     
100     uint public period = 24 hours;
101     uint public startTime = 1537488000; // Fri, 21 Sep 2018 00:00:00 GMT
102     
103     uint public basicDayPercent = 300; //3%
104     uint public bonusDayPercent = 330; //3.3%
105     
106     uint public referrerLevel1Percent = 250; //2.5%
107     uint public referrerLevel2Percent = 500; //5%
108     uint public referrerLevel3Percent = 1000; //10%    
109     
110     uint public referrerLevel2Ether = 1 ether;
111     uint public referrerLevel3Ether = 10 ether;
112     
113     uint public minBetLevel1_2 = 0.01  ether;
114     uint public minBetLevel3 = 0.02  ether;
115     uint public minBetLevel4 = 0.05  ether;  //If more than 100 ETH in Jackpot Bank  
116     
117     uint public referrerAndOwnerPercent = 2000; //20%    
118     
119     uint public currBetID = 1;
120     
121     
122     struct BetStruct {
123         uint value;
124         uint refValue;
125         uint firstBetTime;
126         uint lastBetTime;
127         uint lastPaymentTime;
128         uint nextPayAfterTime;
129         bool isExist;
130         uint id;
131         uint referrerID;
132     }
133     
134     mapping (address => BetStruct) public betsDatabase;
135     mapping (uint => address) public addressList;
136     
137     // Jackpot
138     uint public jackpotLevel2Amount = 1 ether;
139     uint public jackpotLevel3Amount = 10 ether;
140     uint public jackpotLevel4Amount = 100 ether;    
141     uint public jackpotPercent = 1000; //10%
142     uint public jackpotBank = 0;
143     uint public jackpotMaxTime = 24 hours;
144     uint public jackpotTime = startTime + jackpotMaxTime; 
145     uint public increaseJackpotTimeAfterBetLevel1 = 5 minutes; 
146     uint public increaseJackpotTimeAfterBetLevel2_3 = 1 minutes;  
147     uint public increaseJackpotTimeAfterBetLevel4 = 30 seconds;  //If more than 100 ETH in Jackpot Bank 
148     
149     uint public gameRound = 1;   
150     uint public currJackpotBetID = 0;
151     
152     struct BetStructForJackpot {
153         uint value;
154         address user;
155     }
156     mapping (uint => BetStructForJackpot) public betForJackpot;    
157     
158     
159          
160     
161     function setContractProtection(bool _contractProtection) public onlyOwner {
162           contractProtection = _contractProtection;
163      }
164      
165     function bytesToAddress(bytes bys) private pure returns (address addr) {
166         assembly {
167             addr := mload(add(bys, 20))
168         }
169      } 
170     
171     function allBalance() public constant returns (uint) {
172          return address(this).balance;
173      }    
174       
175     function addToJackpot() public payable onlyOwnerOrManager {
176          jackpotBank += msg.value;
177     }
178     
179     function addToBank() public payable onlyOwnerOrManager {
180         
181     }     
182     
183         
184     function createBet(uint _referrerID) public payable notFromContract {
185          
186             if( (_referrerID >= currBetID)){  
187                 revert("Incorrect _referrerID");
188             }
189     
190             if(  (msg.value < minBetLevel1_2)||(msg.value < minBetLevel3 && jackpotBank >= jackpotLevel3Amount)||(msg.value < minBetLevel4 && jackpotBank >= jackpotLevel4Amount)  ){
191                 
192                     revert("Amount beyond acceptable limits");
193             }
194                 
195                 if(betsDatabase[msg.sender].isExist){ 
196                     
197                     if( (betsDatabase[msg.sender].nextPayAfterTime < now) && (gameRound==1) ){
198                         payRewardForAddress(msg.sender);    
199                     }            
200                     betsDatabase[msg.sender].value += msg.value;
201                     betsDatabase[msg.sender].lastBetTime = now;
202                     
203                     
204                 } else {
205                     BetStruct memory betStruct;
206                     
207                     uint nextPayAfterTime = startTime+((now.sub(startTime)).div(period)).mul(period)+period;
208         
209                     betStruct = BetStruct({ 
210                         value : msg.value,
211                         refValue : 0,
212                         firstBetTime : now,
213                         lastBetTime : now,
214                         lastPaymentTime : 0,
215                         nextPayAfterTime: nextPayAfterTime,
216                         isExist : true,
217                         id : currBetID,
218                         referrerID : _referrerID
219                     });
220                 
221                     betsDatabase[msg.sender] = betStruct;
222                     addressList[currBetID] = msg.sender;
223                     
224                     currBetID++;
225                 }
226                 
227                 if(now > jackpotTime){
228                     getJackpot();
229                 }            
230                 
231                 currJackpotBetID++;
232                 
233                 BetStructForJackpot memory betStructForJackpot;
234                 betStructForJackpot.user = msg.sender;
235                 betStructForJackpot.value = msg.value;
236                 
237                 betForJackpot[currJackpotBetID] = betStructForJackpot;
238                 
239                 if(jackpotBank >= jackpotLevel4Amount){
240                     jackpotTime += increaseJackpotTimeAfterBetLevel4;
241                 }else if(jackpotBank >= jackpotLevel2Amount){
242                     jackpotTime += increaseJackpotTimeAfterBetLevel2_3;
243                 }else {
244                     jackpotTime += increaseJackpotTimeAfterBetLevel1;
245                 }
246                 
247                 
248                 if( jackpotTime > now + jackpotMaxTime ) {
249                     jackpotTime = now + jackpotMaxTime;
250                 } 
251                 
252                 if(gameRound==1){
253                     jackpotBank += msg.value.mul(jackpotPercent).div(10000);
254                 }
255                 else {
256                     jackpotBank += msg.value.mul(10000-referrerAndOwnerPercent).div(10000);
257                 }
258         
259                 if(betsDatabase[msg.sender].referrerID!=0){
260                     betsDatabase[addressList[betsDatabase[msg.sender].referrerID]].refValue += msg.value;
261                     
262                     uint currReferrerPercent;
263                     uint currReferrerValue = betsDatabase[addressList[betsDatabase[msg.sender].referrerID]].value.add(betsDatabase[addressList[betsDatabase[msg.sender].referrerID]].refValue);
264                     
265                     if (currReferrerValue >= referrerLevel3Ether){
266                         currReferrerPercent = referrerLevel3Percent;
267                     } else if (currReferrerValue >= referrerLevel2Ether) {
268                        currReferrerPercent = referrerLevel2Percent; 
269                     } else {
270                         currReferrerPercent = referrerLevel1Percent;
271                     }
272                     
273                     uint refToPay = msg.value.mul(currReferrerPercent).div(10000);
274                     
275                     bool result = addressList[betsDatabase[msg.sender].referrerID].send( refToPay );
276                     ownerWallet.transfer(msg.value.mul(referrerAndOwnerPercent - currReferrerPercent).div(10000));
277                     
278                     emit payRefEventLog(msg.sender, addressList[betsDatabase[msg.sender].referrerID], refToPay, currReferrerPercent, now, result);
279                 } else {
280                     ownerWallet.transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
281                 }
282     }
283         
284     function () public payable notFromContract {
285           
286           if(msg.value == 0){
287                 payRewardForAddress(msg.sender);         
288           }else{
289           
290                 uint refId = 1;
291                 address referrer = bytesToAddress(msg.data);
292                 
293                 if (betsDatabase[referrer].isExist){
294                     refId = betsDatabase[referrer].id;
295                 }
296         
297               
298                 createBet(refId);
299           }
300     } 
301       
302       
303     function getReward() public notFromContract {
304             payRewardForAddress(msg.sender);
305     }
306       
307     function getRewardForAddress(address _address) public onlyOwnerOrManager {
308             payRewardForAddress(_address);
309     }  
310       
311     function payRewardForAddress(address _address) internal  {
312             if(gameRound!=1){
313                  revert("The first round end");    
314             }        
315           
316             if(!betsDatabase[_address].isExist){
317                  revert("Address are not an investor");    
318             }
319             
320             if(betsDatabase[_address].nextPayAfterTime >= now){
321                  revert("The payout time has not yet come");    
322             }
323             
324             bool result;
325             uint periodCount = now.sub(betsDatabase[_address].nextPayAfterTime).div(period).add(1);
326             uint percent = basicDayPercent;
327             
328             if(betsDatabase[_address].referrerID>0){
329                 percent = bonusDayPercent;
330             }
331             
332             uint toPay = periodCount.mul(betsDatabase[_address].value).div(10000).mul(percent);
333             
334             betsDatabase[_address].lastPaymentTime = now;
335             betsDatabase[_address].nextPayAfterTime += periodCount.mul(period); 
336             
337             if(toPay.add(jackpotBank) >= address(this).balance.sub(msg.value) ){
338                 toPay = address(this).balance.sub(jackpotBank).sub(msg.value);
339                 gameRound = 2;
340             }
341             
342             result = _address.send(toPay);
343             
344             emit payEventLog(_address, toPay, periodCount, percent, now, result);
345     }
346       
347     function getJackpot() public notFromContract {
348             if(now <= jackpotTime){
349                 revert("Jackpot did not come");  
350             }
351             jackpotTime = now + jackpotMaxTime;
352             
353             if(currJackpotBetID >= 5){
354                 uint toPay = jackpotBank;
355                 jackpotBank = 0;            
356                 
357                 if(toPay>address(this).balance){
358                    toPay = address(this).balance; 
359                 }
360                 
361                 bool result;
362                 uint totalValue = betForJackpot[currJackpotBetID].value + betForJackpot[currJackpotBetID - 1].value + betForJackpot[currJackpotBetID - 2].value + betForJackpot[currJackpotBetID - 3].value + betForJackpot[currJackpotBetID - 4].value;
363                 uint winner1ToPay = toPay.mul(betForJackpot[currJackpotBetID].value).div(totalValue); 
364                 uint winner2ToPay = toPay.mul(betForJackpot[currJackpotBetID-1].value).div(totalValue);
365                 uint winner3ToPay = toPay.mul(betForJackpot[currJackpotBetID-2].value).div(totalValue);
366                 uint winner4ToPay = toPay.mul(betForJackpot[currJackpotBetID-3].value).div(totalValue);
367                 uint winner5ToPay = toPay.sub(winner1ToPay + winner2ToPay + winner3ToPay + winner4ToPay);
368                 
369                 result = betForJackpot[currJackpotBetID].user.send( winner1ToPay );
370                 emit payJackpotLog(betForJackpot[currJackpotBetID].user, winner1ToPay, totalValue, betForJackpot[currJackpotBetID].value, now, result);
371                 
372                 result = betForJackpot[currJackpotBetID-1].user.send( winner2ToPay );
373                 emit payJackpotLog(betForJackpot[currJackpotBetID-1].user, winner2ToPay, totalValue, betForJackpot[currJackpotBetID-1].value, now, result);
374                 
375                 result = betForJackpot[currJackpotBetID-2].user.send( winner3ToPay );
376                 emit payJackpotLog(betForJackpot[currJackpotBetID-2].user, winner3ToPay, totalValue, betForJackpot[currJackpotBetID-2].value, now, result);
377                 
378                 result = betForJackpot[currJackpotBetID-3].user.send( winner4ToPay );
379                 emit payJackpotLog(betForJackpot[currJackpotBetID-3].user, winner4ToPay, totalValue, betForJackpot[currJackpotBetID-3].value, now, result);
380                 
381                 result = betForJackpot[currJackpotBetID-4].user.send( winner5ToPay );
382                 emit payJackpotLog(betForJackpot[currJackpotBetID-4].user, winner5ToPay, totalValue, betForJackpot[currJackpotBetID-4].value, now, result);
383                 
384             }
385     }
386   
387  
388 }