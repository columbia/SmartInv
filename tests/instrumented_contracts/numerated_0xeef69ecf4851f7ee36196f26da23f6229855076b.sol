1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function transfer(address _to, uint256 _value) returns (bool success);
6     function balanceOf(address _owner) constant returns (uint256 balance) ;
7     event Transfer(address indexed _from, address indexed _to, uint256 _value);
8 }
9 
10 
11 /*  ERC 20 token */
12 contract StandardToken is Token {
13 
14 
15     struct LCBalance{
16         uint lcValue;
17         uint lockTime;
18         uint ethValue;
19 
20         uint index;
21         bytes32 indexHash;
22         uint8 lotteryNum;
23     }
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender].lcValue >= _value && _value > 0&&  balances[msg.sender].lockTime!=0) {       
27             balances[msg.sender].lcValue -= _value;
28             balances[_to].lcValue += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         }
32          else {
33             return false;
34         }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner].lcValue;
39     }
40 
41     function balanceOfEth(address _owner) constant returns (uint256 balance) {
42         return balances[_owner].ethValue;
43     }
44 
45     function balanceOfLockTime(address _owner) constant returns (uint256 balance) {
46         return balances[_owner].lockTime;
47     }
48 
49     mapping (address => LCBalance) balances;
50 }
51 
52 contract LCToken is StandardToken {
53     // metadata
54     string public constant name = "Lottery Coin";
55     string public constant symbol = "SaberLC";
56     uint256 public constant decimals = 18;
57     string public version = "1.0";
58 
59     // constant
60     uint256 val1 = 1 wei;    // 1
61     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
62     uint256 val3 = 1 finney; // 1 * 10 ** 15
63     uint256 val4 = 1 ether;  // 1 * 10 ** 18
64 
65     // contact setting
66     address public creator;
67 
68     uint256 public constant LOCKPERIOD          = 365 days;
69     uint256 public constant ICOPERIOD           = 120 days;
70     uint256 public constant SHAREPERIOD           = 30 days;
71     uint256 public constant LOCKAMOUNT          = 3000000 * 10**decimals;
72     uint256 public constant AMOUNT_ICO          = 5000000 * 10**decimals;
73     uint256 public constant AMOUNT_TeamSupport  = 2000000 * 10**decimals;
74 
75     uint256 public gcStartTime = 0;     //ico begin time, unix timestamp seconds
76     uint256 public gcEndTime = 0;       //ico end time, unix timestamp seconds
77 
78     
79     // LC: 30% lock , 20% for Team, 50% for ico          
80     address account_lock = 0x9AD7aeBe8811b0E3071C627403B38803D91BC1ac;  //30%  lock
81     address account_team = 0xc96c3da8bc6381DB296959Ec3e1Fe1e430a4B65B;  //20%  team
82 
83     uint256 public gcSupply = 5000000 * 10**decimals;                 // ico 50% (5000000) total LC supply
84     uint256 public constant gcExchangeRate=1000;                       // 1000 LC per 1 ETH
85 
86     
87     // Play
88     bytes32[1000]   blockhash;
89     uint            firstIndex;
90     uint            endIndex;
91 
92     uint256 public totalLotteryValue = 0;
93     uint256 public currentLotteryValue = 0;
94     uint256 public currentProfit = 0;
95     uint256 public shareTime = 0;
96     uint256 public shareLimit = 10000*val4;
97 
98 
99     function addHash (bytes32 _hashValue) {
100         if(endIndex+1==firstIndex)
101         {
102             endIndex++;
103             blockhash[endIndex]=_hashValue;
104             if(firstIndex<999)
105             {
106                 firstIndex++;
107             }
108             else
109             {
110                 firstIndex=0;
111             }
112         }
113         else
114         {
115             if(firstIndex==0 && 999==endIndex)
116             {
117                 endIndex=0;
118                 blockhash[endIndex]=_hashValue;
119                 firstIndex=1;
120             }
121             else
122             {
123                 if(999<=endIndex)
124                 {
125                     endIndex=0;
126                 }
127                 else
128                 {
129                     endIndex++;
130                 }
131                 blockhash[endIndex]=_hashValue;
132             }
133         }
134     }
135 
136     function buyLottery (uint8 _lotteryNum) payable {
137         if ( msg.value >=val3*10 && _lotteryNum>=0 &&  _lotteryNum<=9 )
138         {
139             bytes32 currentHash=block.blockhash(block.number-1);
140             if(blockhash[endIndex]!=currentHash)
141             {
142                 addHash(currentHash);
143             }
144             balances[msg.sender].ethValue+=msg.value;
145             balances[msg.sender].index=endIndex;
146             balances[msg.sender].lotteryNum=_lotteryNum;
147             balances[msg.sender].indexHash=currentHash;
148             totalLotteryValue+=msg.value;
149             currentLotteryValue+=msg.value;
150         }
151         else
152         {
153             revert();
154         }
155     }
156 
157     function openLottery () {
158 
159         bytes32 currentHash=block.blockhash(block.number-1);
160         if(blockhash[endIndex]!=currentHash)
161         {
162             addHash(currentHash);
163         }
164         if ( balances[msg.sender].ethValue >=val3*10 && balances[msg.sender].indexHash!=currentHash)
165         {
166             currentLotteryValue-=balances[msg.sender].ethValue;
167 
168             uint temuint = balances[msg.sender].index;
169             if(balances[msg.sender].lotteryNum>=0 && balances[msg.sender].lotteryNum<=9 && balances[msg.sender].indexHash==blockhash[temuint])
170             {
171                 temuint++;
172                 if(temuint>999)
173                 {
174                     temuint=0;
175                 }
176                 temuint = uint(blockhash[temuint]);
177                 temuint = temuint%10;
178                 if(temuint==balances[msg.sender].lotteryNum)
179                 {
180                     uint _tosend=balances[msg.sender].ethValue*90/100;
181                     if(_tosend>totalLotteryValue)
182                     {
183                         _tosend=totalLotteryValue;
184                     }
185                     totalLotteryValue-=_tosend;
186                     balances[msg.sender].ethValue=0;
187                     msg.sender.transfer(_tosend);
188                 }
189                 else
190                 {
191                     balances[msg.sender].ethValue=0;
192                 }
193             }
194             else
195             {
196                 balances[msg.sender].ethValue=0;
197             }
198         }
199     }
200 
201     function getShare ()  {
202 
203         if(shareTime+SHAREPERIOD<now)
204         {
205             while(shareTime+SHAREPERIOD<now)
206             {
207                 shareTime+=SHAREPERIOD;
208             }
209             if(totalLotteryValue>currentLotteryValue)
210             {
211                 currentProfit=totalLotteryValue-currentLotteryValue;
212             }
213             else
214             {
215                 currentProfit=0;
216             }
217         }
218 
219         if (balances[msg.sender].lockTime!=0 && balances[msg.sender].lockTime+SHAREPERIOD <=shareTime && currentLotteryValue<totalLotteryValue && balances[msg.sender].lcValue >=shareLimit)
220         {
221             uint _sharevalue=balances[msg.sender].lcValue/val4*currentProfit/1000;
222             if(_sharevalue>totalLotteryValue)
223             {
224                 _sharevalue=totalLotteryValue;
225             }
226             totalLotteryValue-=_sharevalue;
227             msg.sender.transfer(_sharevalue);
228             balances[msg.sender].lockTime=now;
229         }
230     }
231 
232 
233     function Add_totalLotteryValue () payable {
234         if(msg.value>0)
235         {
236             totalLotteryValue+=msg.value;
237         }
238     }
239 
240     //
241     function lockAccount ()  {
242         balances[msg.sender].lockTime=now;
243     }
244 
245     function unlockAccount ()  {
246         balances[msg.sender].lockTime=0;
247     }
248 
249     
250     //+ buy lc,1eth=1000lc, 30%eth send to owner, 70% keep in contact
251     function buyLC () payable {
252         if(now < gcEndTime)
253         {
254             uint256 lcAmount;
255             if ( msg.value >=0){
256                 lcAmount = msg.value * gcExchangeRate;
257                 if (gcSupply < lcAmount) revert();
258                 gcSupply -= lcAmount;          
259                 balances[msg.sender].lcValue += lcAmount;
260             }
261             if(!creator.send(msg.value*30/100)) revert();
262         }
263         else
264         {    
265             balances[account_team].lcValue += gcSupply;
266             account_team.transfer((AMOUNT_ICO-gcSupply)*699/1000/gcExchangeRate);
267             gcSupply = 0;     
268         }
269     }
270 
271     // exchange lc to eth, 1000lc =0.7eth, 30% for fee
272     function clearLC ()  {
273         if(now < gcEndTime)
274         {
275             uint256 ethAmount;
276             if ( balances[msg.sender].lcValue >0 && balances[msg.sender].lockTime==0){
277                 if(msg.sender == account_lock && now < gcStartTime + LOCKPERIOD)
278                 {
279                     revert();
280                 }
281                 ethAmount = balances[msg.sender].lcValue *70/100/ gcExchangeRate;
282                 gcSupply += balances[msg.sender].lcValue;          
283                 balances[msg.sender].lcValue = 0;
284                 msg.sender.transfer(ethAmount);
285             }
286         }
287     }
288 
289     //+ transfer
290     function transfer(address _to, uint256 _value) returns (bool success) {
291         if (balances[msg.sender].lcValue >= _value && _value > 0 && balances[msg.sender].lockTime==0 ) { 
292             if(msg.sender == account_lock ){
293                 if(now < gcStartTime + LOCKPERIOD){
294                     return false;
295                 }
296             }
297             else{
298                 balances[msg.sender].lcValue -= _value;
299                 if(address(this)==_to)
300                 {
301                     balances[creator].lcValue += _value;
302                 }
303                 else
304                 {
305                     balances[_to].lcValue += _value;
306                 }
307                 Transfer(msg.sender, _to, _value);
308                 return true;
309             }
310         
311         } 
312         else {
313             return false;
314         }
315     }
316 
317     function endThisContact () {
318         if(msg.sender==creator && balances[msg.sender].lcValue >=9000000 * val4)
319         {
320             selfdestruct(creator);
321         }
322     }
323 
324     // constructor
325     function LCToken( ) {
326         creator = msg.sender;
327         balances[account_team].lcValue = AMOUNT_TeamSupport;    //for team
328         balances[account_lock].lcValue = LOCKAMOUNT;            //30%   lock 365 days
329         gcStartTime = now;
330         gcEndTime=now+ICOPERIOD;
331 
332 
333         totalLotteryValue=0;
334 
335         firstIndex=0;
336         endIndex=0;
337         blockhash[0] = block.blockhash(block.number-1);
338 
339         shareTime=now+SHAREPERIOD;
340     }
341     
342 
343     
344     // fallback
345     function() payable {
346         buyLC();
347     }
348 
349 }