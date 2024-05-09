1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     function transfer(address _to, uint256 _value) returns (bool success);
5     function balanceOf(address _owner) constant returns (uint256 balance) ;
6     event Transfer(address indexed _from, address indexed _to, uint256 _value);
7 }
8 
9 
10 /*  ERC 20 token */
11 contract StandardToken is Token {
12 
13 
14     struct LCBalance{
15         uint lcValue;
16         uint lockTime;
17         uint ethValue;
18 
19         uint index;
20         bytes32 indexHash;
21         uint lotteryNum;
22     }
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender].lcValue >= _value && _value > 0&&  balances[msg.sender].lockTime!=0) {       
26             balances[msg.sender].lcValue -= _value;
27             balances[_to].lcValue += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         }
31          else {
32             return false;
33         }
34     }
35 
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner].lcValue;
38     }
39 
40     function balanceOfEth(address _owner) constant returns (uint256 balance) {
41         return balances[_owner].ethValue;
42     }
43 
44     function balanceOfLockTime(address _owner) constant returns (uint256 balance) {
45         return balances[_owner].lockTime;
46     }
47 
48     function balanceOfLotteryNum(address _owner) constant returns (uint256 balance) {
49         return balances[_owner].lotteryNum;
50     }
51 
52     mapping (address => LCBalance) balances;
53 }
54 
55 contract LCToken is StandardToken {
56     // metadata
57     string public constant name = "Bulls and Cows";
58     string public constant symbol = "BAC";
59     uint256 public constant decimals = 18;
60     string public version = "1.0";
61 
62     // constant
63     uint256 val1 = 1 wei;    // 1
64     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
65     uint256 val3 = 1 finney; // 1 * 10 ** 15
66     uint256 val4 = 1 ether;  // 1 * 10 ** 18
67 
68     // contact setting
69     address public creator;
70 
71     uint256 public constant LOCKPERIOD          = 365 days;
72     uint256 public constant ICOPERIOD           = 120 days;
73     uint256 public constant SHAREPERIOD         = 30 days;
74     uint256 public constant LOCKAMOUNT          = 3000000 * 10**decimals;
75     uint256 public constant AMOUNT_ICO          = 5000000 * 10**decimals;
76     uint256 public constant AMOUNT_TeamSupport  = 2000000 * 10**decimals;
77 
78     uint256 public gcStartTime = 0;     //ico begin time, unix timestamp seconds
79     uint256 public gcEndTime = 0;       //ico end time, unix timestamp seconds
80 
81     
82     // LC: 30% lock , 20% for Team, 50% for ico          
83     address account_lock = 0x9AD7aeBe8811b0E3071C627403B38803D91BC1ac;  //30%  lock
84     address account_team = 0xc96c3da8bc6381DB296959Ec3e1Fe1e430a4B65B;  //20%  team
85 
86     uint256 public gcSupply = 5000000 * 10**decimals;                 // ico 50% (5000000) total LC supply
87     uint256 public constant gcExchangeRate=1000;                       // 1000 LC per 1 ETH
88 
89     
90     // Play
91     bytes32[1000]   blockhash;
92     uint            firstIndex;
93     uint            endIndex;
94 
95     uint256 public totalLotteryValue = 0;
96     uint256 public currentLotteryValue = 0;
97     uint256 public currentProfit = 0;
98     uint256 public shareTime = 0;
99     uint256 public shareLimit = 10000*val4;
100 
101 
102     function buyLottery (uint8 _lotteryNum) payable {
103         if ( msg.value >=val3*10 && _lotteryNum>=0 &&  _lotteryNum<=9 )
104         {
105             bytes32 currentHash=block.blockhash(block.number-1);
106             if(blockhash[endIndex]!=currentHash)
107             {
108                 if(endIndex+1==firstIndex)
109                 {
110                     endIndex++;
111                     blockhash[endIndex]=currentHash;
112                     if(firstIndex<999)
113                     {
114                         firstIndex++;
115                     }
116                     else
117                     {
118                         firstIndex=0;
119                     }
120                 }
121                 else
122                 {
123                     if(firstIndex==0 && 999==endIndex)
124                     {
125                         endIndex=0;
126                         blockhash[endIndex]=currentHash;
127                         firstIndex=1;
128                     }
129                     else
130                     {
131                         if(999<=endIndex)
132                         {
133                             endIndex=0;
134                         }
135                         else
136                         {
137                             endIndex++;
138                         }
139                         blockhash[endIndex]=currentHash;
140                     }
141                 }
142             }
143             balances[msg.sender].ethValue+=msg.value;
144             balances[msg.sender].index=endIndex;
145             balances[msg.sender].lotteryNum=_lotteryNum;
146             balances[msg.sender].indexHash=currentHash;
147             totalLotteryValue+=msg.value;
148             currentLotteryValue+=msg.value;
149         }
150         else
151         {
152             revert();
153         }
154     }
155 
156     function openLottery () {
157 
158         bytes32 currentHash=block.blockhash(block.number-1);
159         if(blockhash[endIndex]!=currentHash)
160         {
161             if(endIndex+1==firstIndex)
162             {
163                 endIndex++;
164                 blockhash[endIndex]=currentHash;
165                 if(firstIndex<999)
166                 {
167                     firstIndex++;
168                 }
169                 else
170                 {
171                     firstIndex=0;
172                 }
173             }
174             else
175             {
176                 if(firstIndex==0 && 999==endIndex)
177                 {
178                     endIndex=0;
179                     blockhash[endIndex]=currentHash;
180                     firstIndex=1;
181                 }
182                 else
183                 {
184                     if(999<=endIndex)
185                     {
186                         endIndex=0;
187                     }
188                     else
189                     {
190                         endIndex++;
191                     }
192                     blockhash[endIndex]=currentHash;
193                 }
194             }
195         }
196         if ( balances[msg.sender].ethValue >=val3*10 && balances[msg.sender].indexHash!=currentHash)
197         {
198             currentLotteryValue-=balances[msg.sender].ethValue;
199 
200             uint temuint = balances[msg.sender].index;
201             if(balances[msg.sender].lotteryNum>=0 && balances[msg.sender].lotteryNum<=9 && balances[msg.sender].indexHash==blockhash[temuint])
202             {
203                 temuint++;
204                 if(temuint>999)
205                 {
206                     temuint=0;
207                 }
208                 temuint = uint(blockhash[temuint]);
209                 temuint = temuint%10;
210                 if(temuint==balances[msg.sender].lotteryNum)
211                 {
212                     uint _tosend=balances[msg.sender].ethValue*90/100;
213                     if(_tosend>totalLotteryValue)
214                     {
215                         _tosend=totalLotteryValue;
216                     }
217                     totalLotteryValue-=_tosend;
218                     balances[msg.sender].ethValue=0;
219                     msg.sender.transfer(_tosend);
220                 }
221                 else
222                 {
223                     balances[msg.sender].ethValue=0;
224                 }
225                 balances[msg.sender].lotteryNum=100+temuint;
226             }
227             else
228             {
229                 balances[msg.sender].ethValue=0;
230                 balances[msg.sender].lotteryNum=999;
231             }
232         }
233     }
234 
235     function getShare ()  {
236 
237         if(shareTime+SHAREPERIOD<now)
238         {
239             uint _jumpc=(now - shareTime)/SHAREPERIOD;
240             shareTime += (_jumpc * SHAREPERIOD);
241             
242             if(totalLotteryValue>currentLotteryValue)
243             {
244                 currentProfit=totalLotteryValue-currentLotteryValue;
245             }
246             else
247             {
248                 currentProfit=0;
249             }
250         }
251 
252         if (balances[msg.sender].lockTime!=0 && balances[msg.sender].lockTime+SHAREPERIOD <=shareTime && currentProfit>0 && balances[msg.sender].lcValue >=shareLimit)
253         {
254             uint _sharevalue=balances[msg.sender].lcValue/val4*currentProfit/1000;
255             if(_sharevalue>totalLotteryValue)
256             {
257                 _sharevalue=totalLotteryValue;
258             }
259             totalLotteryValue-=_sharevalue;
260             msg.sender.transfer(_sharevalue);
261             balances[msg.sender].lockTime=shareTime;
262         }
263     }
264 
265 
266     function Add_totalLotteryValue () payable {
267         if(msg.value>0)
268         {
269             totalLotteryValue+=msg.value;
270         }
271     }
272 
273     //
274     function lockAccount ()  {
275         balances[msg.sender].lockTime=now;
276     }
277 
278     function unlockAccount ()  {
279         balances[msg.sender].lockTime=0;
280     }
281 
282     
283     //+ buy lc,1eth=1000lc, 30%eth send to owner, 70% keep in contact
284     function buyLC () payable {
285         if(now < gcEndTime)
286         {
287             uint256 lcAmount;
288             if ( msg.value >=0){
289                 lcAmount = msg.value * gcExchangeRate;
290                 if (gcSupply < lcAmount) revert();
291                 gcSupply -= lcAmount;          
292                 balances[msg.sender].lcValue += lcAmount;
293             }
294             if(!creator.send(msg.value*30/100)) revert();
295         }
296         else
297         {    
298             balances[account_team].lcValue += gcSupply;
299             account_team.transfer((AMOUNT_ICO-gcSupply)*699/1000/gcExchangeRate);
300             gcSupply = 0;     
301         }
302     }
303 
304     // exchange lc to eth, 1000lc =0.7eth, 30% for fee
305     function clearLC ()  {
306         if(now < gcEndTime)
307         {
308             uint256 ethAmount;
309             if ( balances[msg.sender].lcValue >0 && balances[msg.sender].lockTime==0){
310                 if(msg.sender == account_lock && now < gcStartTime + LOCKPERIOD)
311                 {
312                     revert();
313                 }
314                 ethAmount = balances[msg.sender].lcValue *70/100/ gcExchangeRate;
315                 gcSupply += balances[msg.sender].lcValue;          
316                 balances[msg.sender].lcValue = 0;
317                 msg.sender.transfer(ethAmount);
318             }
319         }
320     }
321 
322     //+ transfer
323     function transfer(address _to, uint256 _value) returns (bool success) {
324         if (balances[msg.sender].lcValue >= _value && _value > 0 && balances[msg.sender].lockTime==0 ) { 
325             if(msg.sender == account_lock ){
326                 if(now < gcStartTime + LOCKPERIOD){
327                     return false;
328                 }
329             }
330             else{
331                 balances[msg.sender].lcValue -= _value;
332                 if(address(this)==_to)
333                 {
334                     balances[creator].lcValue += _value;
335                 }
336                 else
337                 {
338                     balances[_to].lcValue += _value;
339                 }
340                 Transfer(msg.sender, _to, _value);
341                 return true;
342             }
343         
344         } 
345         else {
346             return false;
347         }
348     }
349 
350     function endThisContact () {
351         if(msg.sender==creator && balances[msg.sender].lcValue >=9000000 * val4)
352         {
353             if(balances[msg.sender].lcValue >=9000000 * val4 || gcSupply >= 4990000 * 10**decimals)
354             {
355                 selfdestruct(creator);
356             }
357         }
358     }
359 
360     // constructor
361     function LCToken( ) {
362         creator = msg.sender;
363         balances[account_team].lcValue = AMOUNT_TeamSupport;    //for team
364         balances[account_lock].lcValue = LOCKAMOUNT;            //30%   lock 365 days
365         gcStartTime = now;
366         gcEndTime=now+ICOPERIOD;
367 
368 
369         totalLotteryValue=0;
370 
371         firstIndex=0;
372         endIndex=0;
373         blockhash[0] = block.blockhash(block.number-1);
374 
375         shareTime=now+SHAREPERIOD;
376     }
377     
378 
379     
380     // fallback
381     function() payable {
382         buyLC();
383     }
384 
385 }