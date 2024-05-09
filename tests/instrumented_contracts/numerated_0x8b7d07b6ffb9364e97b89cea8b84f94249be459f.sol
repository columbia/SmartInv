1 pragma solidity ^0.4.18;
2 
3 // FUTR, but time is shorter and less ether / tokens.
4 
5 contract FUTX {
6 
7     uint256 constant MAX_UINT256 = 2**256 - 1;
8     
9     uint256 MAX_SUBMITTED = 5000671576194550000000;
10 
11     // (no premine)
12     uint256 _totalSupply = 0;
13     
14     // The following 2 variables are essentially a lookup table.
15     // They are not constant because they are memory.
16     // I came up with this because calculating it was expensive,
17     // especially so when crossing tiers.
18     
19     // Sum of each tier by ether submitted.
20    uint256[] levels = [ 
21       87719298245614000000,
22      198955253301794000000,
23      373500707847248000000,
24      641147766670778000000,
25      984004909527921000000,
26     1484004909527920000000,
27     2184004909527920000000,
28     3084004909527920000000,
29     4150671576194590000000,
30     5000671576194550000000
31     ];
32     
33     // Token amounts for each tier.
34     uint256[] ratios = [
35       114,
36       89,
37       55,
38       34,
39       21,
40       13,
41        8,
42        5,
43        3,
44        2 ];
45      
46     // total ether submitted before fees.
47     uint256 _submitted = 0;
48     
49     uint256 public tier = 0;
50     
51     // ERC20 events.
52     event Transfer(address indexed _from, address indexed _to, uint _value);
53     event Approval(address indexed _owner, address indexed _spender, uint _value);
54     
55     // FUTR events.
56     event Mined(address indexed _miner, uint _value);
57     event WaitStarted(uint256 endTime);
58     event SwapStarted(uint256 endTime);
59     event MiningStart(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
60     event MiningExtended(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
61 
62  
63     // Optional ERC20 values.
64     string public name = "Futereum X";
65     uint8 public decimals = 18;
66     string public symbol = "FUTX";
67     
68     // Public variables so the curious can check the state.
69     bool public swap = false;
70     bool public wait = false;
71     bool public extended = false;
72     
73     // Public end time for the current state.
74     uint256 public endTime;
75     
76     // These are calculated at mining start.
77     uint256 swapTime;
78     uint256 swapEndTime;
79     uint256 endTimeExtended;
80     uint256 swapTimeExtended;
81     uint256 swapEndTimeExtended;
82     
83     // Pay rate calculated from balance later.
84     uint256 public payRate = 0;
85     
86     // Fee variables.  Fees are reserved and then withdrawn  later.
87     uint256 submittedFeesPaid = 0;
88     uint256 penalty = 0;
89     uint256 reservedFees = 0;
90     
91     // Storage.
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 
95 
96    // Fallback function mines the tokens.
97    // Send from a wallet you control.
98    // DON'T send from an exchange wallet!
99    // We recommend sending using a method that calculates gas for you.
100    // Here are some estimates (not guaranteed to be accurate):
101    // It usually costs around 90k gas.  It cost more if you cross a tier.
102    // Maximum around 190k gas.
103    function () external payable {
104    
105        require(msg.sender != address(0) &&
106                 tier != 10 &&
107                 swap == false &&
108                 wait == false);
109     
110         uint256 issued = mint(msg.sender, msg.value);
111         
112         Mined(msg.sender, issued);
113         Transfer(this, msg.sender, issued);
114     }
115     
116     // Constructor.
117     function FUTX() public {
118         _start();
119     }
120     
121     // This gets called by constructor AND after the swap to restart evertying.
122     function _start() internal 
123     {
124         swap = false;
125         wait = false;
126         extended = false;
127     
128         endTime = now + 90 days;
129         swapTime = endTime + 30 days;
130         swapEndTime = swapTime + 5 days;
131         endTimeExtended = now + 270 days;
132         swapTimeExtended = endTimeExtended + 90 days;
133         swapEndTimeExtended = swapTimeExtended + 5 days;
134         
135         submittedFeesPaid = 0;
136         _submitted = 0;
137         
138         reservedFees = 0;
139         
140         payRate = 0;
141         
142         tier = 0;
143                 
144         MiningStart(endTime, swapTime, swapEndTime);
145     }
146     
147     // Restarts everything after swap.
148     // This is expensive, so we make someone call it and pay for the gas.
149     // Any holders that miss the swap get to keep their tokens.
150     // Ether stays in contract, minus 20% penalty fee.
151     function restart() public {
152         require(swap && now >= endTime);
153         
154         penalty = this.balance * 2000 / 10000;
155         
156         payFees();
157         
158         _start();
159     }
160     
161     // ERC20 standard supply function.
162     function totalSupply() public constant returns (uint)
163     {
164         return _totalSupply;
165     }
166     
167     // Mints new tokens when they are mined.
168     function mint(address _to, uint256 _value) internal returns (uint256) 
169     {
170         uint256 total = _submitted + _value;
171         
172         if (total > MAX_SUBMITTED)
173         {
174             uint256 refund = total - MAX_SUBMITTED - 1;
175             _value = _value - refund;
176             
177             // refund money and continue.
178             _to.transfer(refund);
179         }
180         
181         _submitted += _value;
182         
183         total -= refund;
184         
185         uint256 tokens = calculateTokens(total, _value);
186         
187         balances[_to] += tokens;
188        
189         _totalSupply += tokens;
190         
191         return tokens;
192     }
193     
194     // Calculates the tokens mined based on the tier.
195     function calculateTokens(uint256 total, uint256 _value) internal returns (uint256)
196     {
197         if (tier == 10) 
198         {
199             // This just rounds it off to an even number.
200             return 74000000;
201         }
202         
203         uint256 tokens = 0;
204         
205         if (total > levels[tier])
206         {
207             uint256 remaining = total - levels[tier];
208             _value -= remaining;
209             tokens = (_value) * ratios[tier];
210            
211             tier += 1;
212             
213             tokens += calculateTokens(total, remaining);
214         }
215         else
216         {
217             tokens = _value * ratios[tier];
218         }
219         
220         return tokens;
221     }
222     
223     // This is basically so you don't have to add 1 to the last completed tier.
224     //  You're welcome.
225     function currentTier() public view returns (uint256) {
226         if (tier == 10)
227         {
228             return 10;
229         }
230         else
231         {
232             return tier + 1;
233         }
234     }
235     
236     // Ether remaining for tier.
237     function leftInTier() public view returns (uint256) {
238         if (tier == 10) {
239             return 0;
240         }
241         else
242         {
243             return levels[tier] - _submitted;
244         }
245     }
246     
247     // Total sumbitted for mining.
248     function submitted() public view returns (uint256) {
249         return _submitted;
250     }
251     
252     // Balance minus oustanding fees.
253     function balanceMinusFeesOutstanding() public view returns (uint256) {
254         return this.balance - (penalty + (_submitted - submittedFeesPaid) * 1530 / 10000);  // fees are 15.3 % total.
255     }
256     
257     // Calculates the amount of ether per token from the balance.
258     // This is calculated once by the first account to swap.
259     function calulateRate() internal {
260         reservedFees = penalty + (_submitted - submittedFeesPaid) * 1530 / 10000;  // fees are 15.3 % total.
261         
262         uint256 tokens = _totalSupply / 1 ether;
263         payRate = (this.balance - reservedFees);
264 
265         payRate = payRate / tokens;
266     }
267     
268     // This function is called on token transfer and fee payment.
269     // It checks the next deadline and then updates the deadline and state.
270     // 
271     // It uses the block time, but the time periods are days and months,
272     // so it should be pretty safe  ¯\_(ツ)_/¯ 
273     function _updateState() internal {
274         // Most of the time, this will just be skipped.
275         if (now >= endTime)
276         {
277             // We are not currently swapping or waiting to swap
278             if(!swap && !wait)
279             {
280                 if (extended)
281                 {
282                     // It's been 36 months.
283                     wait = true;
284                     endTime = swapTimeExtended;
285                     WaitStarted(endTime);
286                 }
287                 else if (tier == 10)
288                 {
289                     // Tiers filled
290                     wait = true;
291                     endTime = swapTime;
292                     WaitStarted(endTime);
293                 } 
294                 else
295                 {
296                     // Extended to 36 months
297                     endTime = endTimeExtended;
298                     extended = true;
299                     
300                     MiningExtended(endTime, swapTime, swapEndTime);
301                 }
302             } 
303             else if (wait)
304             {
305                 // It's time to swap.
306                 swap = true;
307                 wait = false;
308                 
309                 if (extended) 
310                 {
311                     endTime = swapEndTimeExtended;
312                 }
313                 else
314                 {
315                     endTime = swapEndTime;
316                 }
317                 
318                 SwapStarted(endTime);
319             }
320         }
321     }
322    
323     // Standard ERC20 transfer plus state check and token swap logic.
324     //
325     // We recommend sending using a method that calculates gas for you.
326     //
327     // Here are some estimates (not guaranteed to be accurate):
328     // It usually costs around 37k gas.  It cost more if the state changes.
329     // State change means around 55k - 65k gas.
330     // Swapping tokens for ether costs around 46k gas. (around 93k for the first account to swap)
331     function transfer(address _to, uint256 _value) public returns (bool success) {
332         
333         require(balances[msg.sender] >= _value);
334         
335          // Normal transfers check if time is expired.  
336         _updateState();
337 
338         // Check if sending in for swap.
339         if (_to == address(this)) 
340         {
341             // throw if they can't swap yet.
342             require(swap);
343             
344             if (payRate == 0)
345             {
346                 calulateRate(); // Gas to calc the rate paid by first unlucky soul.
347             }
348             
349             uint256 amount = _value * payRate;
350             // Adjust for decimals
351             amount /= 1 ether;
352             
353             // Burn tokens.
354             balances[msg.sender] -= _value;
355              _totalSupply -= _value;
356             Transfer(msg.sender, _to, _value);
357             
358             //send ether
359             msg.sender.transfer(amount);
360         } else
361         {
362             balances[msg.sender] -= _value;
363             balances[_to] += _value;
364             Transfer(msg.sender, _to, _value);
365         }
366         return true;
367     }
368     
369     // Standard ERC20.
370     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
371        
372         uint256 allowance = allowed[_from][msg.sender];
373         require(balances[_from] >= _value && allowance >= _value);
374         balances[_to] += _value;
375         balances[_from] -= _value;
376         if (allowance < MAX_UINT256) {
377             allowed[_from][msg.sender] -= _value;
378         }
379         Transfer(_from, _to, _value);
380         return true;
381     }
382 
383     // Standard ERC20.
384     function balanceOf(address _owner) view public returns (uint256 balance) {
385         return balances[_owner];
386     }
387 
388     // Standard ERC20.
389     function approve(address _spender, uint256 _value) public returns (bool success) {
390 
391         allowed[msg.sender][_spender] = _value;
392         Approval(msg.sender, _spender, _value);
393         return true;
394     }
395 
396     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
397       return allowed[_owner][_spender];
398     }
399     
400     // ********************
401     // Fee stuff.
402 
403     // Addresses for fees.
404     address public foundation = 0x950ec4ef693d90f8519c4213821e462426d30905;
405     address public owner = 0x78BFCA5E20B0D710EbEF98249f68d9320eE423be;
406     address public dev = 0x5d2b9f5345e69e2390ce4c26ccc9c2910a097520;
407     
408     // Pays fees to the foundation, the owner, and the dev.
409     // It also updates the state.  Anyone can call this.
410     function payFees() public {
411          // Check state to see if swap needs to happen.
412          _updateState();
413          
414         uint256 fees = penalty + (_submitted - submittedFeesPaid) * 1530 / 10000;  // fees are 15.3 % total.
415         submittedFeesPaid = _submitted;
416         
417         reservedFees = 0;
418         penalty = 0;
419         
420         if (fees > 0) 
421         {
422             foundation.transfer(fees / 3);
423             owner.transfer(fees / 3);
424             dev.transfer(fees / 3);
425         }
426     }
427     
428     function changeFoundation (address _receiver) public
429     {
430         require(msg.sender == foundation);
431         foundation = _receiver;
432     }
433     
434     
435     function changeOwner (address _receiver) public
436     {
437         require(msg.sender == owner);
438         owner = _receiver;
439     }
440     
441     function changeDev (address _receiver) public
442     {
443         require(msg.sender == dev);
444         dev = _receiver;
445     }    
446 
447 }