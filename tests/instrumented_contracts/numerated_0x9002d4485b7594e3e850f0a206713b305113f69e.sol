1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 
52 
53 contract Token is SafeMath {
54 
55     function totalSupply()public constant returns (uint256 supply) {}
56 
57     function balanceOf(address _owner)public constant returns (uint256 balance) {}
58     
59    
60     
61     function transfer(address _to, uint256 _value)public returns (bool success) {}
62 
63     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {}
64 
65     function approve(address _spender, uint256 _value)public returns (bool success) {}
66 
67     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71     
72 }
73 
74 
75 //ERC20 Compliant
76 contract StandardToken is Token {
77 
78     
79     
80     
81     
82     function transfer(address _to, uint256 _value) public  returns (bool success) {
83         if (balances[msg.sender] >= _value && _value > 0)
84         {
85             if(inflation_complete)
86             {
87               
88                 uint256 CalculatedFee = safeMul(safeDiv(transactionfeeAmount,100000000000000),transactionfeeAmount);
89                 balances[msg.sender] = safeSub(balances[msg.sender],_value);
90                _value = safeSub(_value,CalculatedFee);
91                 totalFeeCollected = safeAdd(totalFeeCollected,CalculatedFee);
92                 balances[_to] = safeAdd(balances[_to],_value);
93                 Transfer(msg.sender, _to, _value);
94                 return true;
95             }
96             else
97             {
98                 balances[msg.sender] = safeSub(balances[msg.sender],_value);
99                 balances[_to] = safeAdd(balances[_to],_value);
100                 Transfer(msg.sender, _to, _value);
101                 return true;
102                 
103             }
104             
105         }
106         else
107         {
108             return false;
109         }
110     }
111 
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
114             balances[_to] =safeAdd(balances[_to],_value);
115             balances[_from] =safeSub(balances[_from],_value);
116             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value); 
117             Transfer(_from, _to, _value);
118             return true;
119         } else { return false; }
120     }
121 
122     function balanceOf(address _owner) public constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125    
126 
127     function approve(address _spender, uint256 _value) public returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
134       return allowed[_owner][_spender];
135     }
136 
137    
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140     uint256 public totalSupply=   0;
141     uint256 public initialSupply= 2500000*10**12;
142     uint256 public rewardsupply= 4500000*10**12;
143     bool public inflation_complete;
144     uint256 public transactionfeeAmount; // This is the percentage per transaction Hawala.Today shall be collecting 
145     uint256 public totalFeeCollected;
146 }
147 
148 
149 
150 contract HawalaToken is StandardToken {
151 
152     
153     uint256 public  totalstakeamount;
154     uint256 public HawalaKickoffTime;
155     address _contractOwner;
156     uint256 public totalFeeCollected;
157   
158     string public name;                  
159     uint8 public decimals;               
160     string public symbol;
161     string public version = 'HAT';       
162 
163   mapping (address => IFSBalance) public IFSBalances;
164    struct IFSBalance
165     {
166         
167          uint256 TotalRewardsCollected; 
168         uint256 Amount; 
169         uint256 IFSLockTime;
170         uint256 LastCollectedReward;
171     }
172     
173    
174     event IFSActive(address indexed _owner, uint256 _value,uint256 _locktime);
175     
176     function () public {
177         //if ether is sent to this address, send it back.
178     
179         throw;
180     }
181 
182   
183 
184       
185 
186       function CalculateReward(uint256 stakingamount,uint256 initialLockTime,uint256 _currenttime) public returns (uint256 _amount) {
187          
188         
189          uint _timesinceStaking =(uint(_currenttime)-uint(initialLockTime))/ 1 days;
190          _timesinceStaking = safeDiv(_timesinceStaking,3);//exploiting non-floating point division
191          _timesinceStaking = safeMul(_timesinceStaking,3);//get to number of days reward shall be distributed
192         
193       
194         
195          if(safeSub(_currenttime,HawalaKickoffTime) <= 1 years)
196          {
197              //_amount = 1;//safeMul(safeDiv(stakingamount,100),15));
198               
199              _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
200              _amount = safeMul(_timesinceStaking,_amount);
201           
202          }
203         else if(safeSub(_currenttime,HawalaKickoffTime) <= 2 years)
204          {
205              _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
206              _amount = safeMul(_timesinceStaking,_amount);
207              
208          }
209         else  if(safeSub(_currenttime,HawalaKickoffTime) <= 3 years)
210          {
211              _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
212              _amount = safeMul(_timesinceStaking,_amount);
213              
214          }
215         else  if(safeSub(_currenttime,HawalaKickoffTime) <= 4 years)
216          {
217              _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
218              _amount = safeMul(_timesinceStaking,_amount);
219              
220          }
221        else   if(safeSub(_currenttime,HawalaKickoffTime) <= 5 years)
222          {
223              _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
224              _amount = safeMul(_timesinceStaking,_amount);
225              
226          }
227        else   if(safeSub(_currenttime,HawalaKickoffTime) <= 6 years)
228          {
229              _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
230              _amount = safeMul(_timesinceStaking,_amount);
231              
232          }
233       else    if(safeSub(_currenttime,HawalaKickoffTime) <= 7 years)
234          {
235              _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10%  safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
236              _amount = safeMul(_timesinceStaking,_amount);
237              
238          }
239        else   if(safeSub(_currenttime,HawalaKickoffTime) <= 8 years)
240          {
241              _amount = safeMul(safeDiv(stakingamount,1000000000000),219178082) ;//8% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
242              _amount = safeMul(_timesinceStaking,_amount);
243              
244          }
245       else    if(safeSub(_currenttime,HawalaKickoffTime) <= 9 years)
246          {
247              _amount = safeMul(safeDiv(stakingamount,1000000000000),205479452) ;//7.50% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
248              _amount = safeMul(_timesinceStaking,_amount);
249              
250          }
251        else   if(safeSub(_currenttime,HawalaKickoffTime) <= 10 years)
252          {
253              _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
254              _amount = safeMul(_timesinceStaking,_amount);
255              
256          }
257         else   if(safeSub(_currenttime,HawalaKickoffTime) > 10 years)
258          {
259              _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
260              _amount = safeMul(_timesinceStaking,_amount);
261              
262          }
263          return _amount;
264          //extract ony the quotient from _timesinceStaking
265         
266      }
267      
268      function changeTransactionFee(uint256 amount) public returns (bool success)
269      {
270           if (msg.sender == _contractOwner) {
271               
272               transactionfeeAmount = amount;
273             return true;
274           }
275        else{
276              return false;
277          }
278      }
279      
280      function canExecute(uint initialLockTime,uint256 _currenttime) public returns (bool success)
281      {
282           if (_currenttime >= initialLockTime + 3 days) {
283               
284             return true;
285           }
286        else{
287              return false;
288          }
289      }
290      
291      
292       function disperseRewards(address toaddress ,uint256 amount) public returns (bool success){
293       
294           if(msg.sender==_contractOwner)
295           {
296              if(inflation_complete)
297               {
298                   if(totalFeeCollected>0 && totalFeeCollected>amount)
299                   {
300                     totalFeeCollected = safeSub(totalFeeCollected,amount);
301                      balances[toaddress] = safeAdd(balances[toaddress],amount);
302                      Transfer(msg.sender, toaddress, amount);
303                      return true;
304                   }
305               
306               }
307               else
308               {
309                   return false;
310                   
311               }
312           }
313           return false;
314           
315       }
316        function claimIFSReward(address _sender) public returns (bool success){
317      
318        
319         if(msg.sender!=_sender)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS
320         {
321             return false;
322         }
323         else
324         {
325             if(IFSBalances[_sender].Amount<=0)
326             {
327                 return false;
328                 
329             }
330             else{
331                 // is IFS balance age minimum 3 day?
332                 uint256 _currenttime = now;
333                 if(canExecute(IFSBalances[_sender].IFSLockTime,_currenttime))
334                 {
335                     //Get Total number of days in multiple of 3's.. Suppose if the staking lock was done 10 days ago
336                     //but the reward shall be allocated and calculated for 9 Days.
337                     uint256 calculatedreward = CalculateReward(IFSBalances[_sender].Amount,IFSBalances[_sender].IFSLockTime,_currenttime);
338                     
339                    if(!inflation_complete)
340                    {
341                     if(rewardsupply>=calculatedreward)
342                     {
343                    
344                    
345                          rewardsupply = safeSub(rewardsupply,calculatedreward);
346                          balances[_sender] =safeAdd(balances[_sender], calculatedreward);
347                          IFSBalances[_sender].IFSLockTime = _currenttime;//reset the clock
348                          IFSBalances[_sender].TotalRewardsCollected = safeAdd( IFSBalances[_sender].TotalRewardsCollected,calculatedreward);
349                           IFSBalances[_sender].LastCollectedReward = rewardsupply;//Set this to see last collected reward
350                     }
351                     else{
352                         
353                         if(rewardsupply>0)//whatever remaining in the supply hand it out to last staking account
354                         {
355                               
356                            balances[_sender] =safeAdd(balances[_sender], rewardsupply);
357                            rewardsupply = 0;
358                             
359                         }
360                         inflation_complete = true;
361                         
362                     }
363                     
364                    }
365                     
366                 }
367                 else{
368                     
369                     // Not time yet to process staking reward 
370                     return false;
371                 }
372                 
373                 
374                 
375             }
376             return true;
377         }
378         
379     }
380    
381     function setIFS(address _sender,uint256 _amount) public returns (bool success){
382         if(msg.sender!=_sender || balances[_sender]<_amount || rewardsupply==0)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS
383         {
384             return false;
385         }
386         balances[_sender] = safeSub(balances[_sender],_amount);
387         IFSBalances[_sender].Amount = safeAdd(IFSBalances[_sender].Amount,_amount);
388         IFSBalances[_sender].IFSLockTime = now;
389         IFSActive(_sender,_amount,IFSBalances[_sender].IFSLockTime);
390         totalstakeamount =  safeAdd(totalstakeamount,_amount);
391         return true;
392         
393     }
394     function reClaimIFS(address _sender)public returns (bool success){
395         if(msg.sender!=_sender || IFSBalances[_sender].Amount<=0 )//Make sure only authorize owner of account and > 0 staking could trigger reClaimIFS  
396         {
397             return false;
398         }
399         
400             balances[_sender] = safeAdd(balances[_sender],IFSBalances[_sender].Amount);
401             totalstakeamount =  safeSub(totalstakeamount,IFSBalances[_sender].Amount);
402             IFSBalances[_sender].Amount = 0;
403             IFSBalances[_sender].IFSLockTime = 0;// 
404             IFSActive(_sender,0,IFSBalances[_sender].IFSLockTime);//Broadcast event ... Our mobile hooks should be listening to release time
405             
406             return true; 
407         
408         
409     }
410     
411     
412     function HawalaToken(
413         )public {
414         //Add initial supply to total supply to make  7M. remaining 4.5M locked in for reward distribution        
415         totalSupply=safeAdd(initialSupply,rewardsupply);
416         balances[msg.sender] = initialSupply;               
417         name = "HawalaToken";                              
418         decimals = 12;                            
419         symbol = "HAT";  
420         inflation_complete = false;
421         HawalaKickoffTime=now;
422         totalstakeamount=0;
423         totalFeeCollected=0;
424         transactionfeeAmount=100000000000;// Initialized with 0.10 Percent per transaction after 10 years
425         _contractOwner = msg.sender;
426     }
427 
428    
429     function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
430         allowed[msg.sender][_spender] = _value;
431         Approval(msg.sender, _spender, _value);
432 
433         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
434         return true;
435     }
436 }