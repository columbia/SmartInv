1 pragma solidity ^0.4.18;
2 
3 
4 contract FUTR {
5 
6     uint256 constant MAX_UINT256 = 2**256 - 1;
7     
8     uint256 MAX_SUBMITTED = 500067157619455000000000;
9 
10     // (no premine)
11     uint256 _totalSupply = 0;
12     
13     // The following 2 variables are essentially a lookup table.
14     // They are not constant because they are memory.
15     // I came up with this because calculating it was expensive,
16     // especially so when crossing tiers.
17     
18     // Sum of each tier by ether submitted.
19    uint256[] levels = [ 
20       8771929824561400000000,
21      19895525330179400000000,
22      37350070784724800000000,
23      64114776667077800000000,
24      98400490952792100000000,
25     148400490952792000000000,
26     218400490952792000000000,
27     308400490952792000000000,
28     415067157619459000000000,
29     500067157619455000000000
30     ];
31     
32     // Token amounts for each tier.
33     uint256[] ratios = [
34       114,
35       89,
36       55,
37       34,
38       21,
39       13,
40        8,
41        5,
42        3,
43        2 ];
44      
45     // total ether submitted before fees.
46     uint256 _submitted = 0;
47     
48     uint256 public tier = 0;
49     
50     // ERC20 events.
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53     
54     // FUTR events.
55     event Mined(address indexed _miner, uint _value);
56     event WaitStarted(uint256 endTime);
57     event SwapStarted(uint256 endTime);
58     event MiningStart(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
59     event MiningExtended(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
60 
61  
62     // Optional ERC20 values.
63     string public name = "Futereum Token";
64     uint8 public decimals = 18;
65     string public symbol = "FUTR";
66     
67     // Public variables so the curious can check the state.
68     bool public swap = false;
69     bool public wait = false;
70     bool public extended = false;
71     
72     // Public end time for the current state.
73     uint256 public endTime;
74     
75     // These are calculated at mining start.
76     uint256 swapTime;
77     uint256 swapEndTime;
78     uint256 endTimeExtended;
79     uint256 swapTimeExtended;
80     uint256 swapEndTimeExtended;
81     
82     // Pay rate calculated from balance later.
83     uint256 public payRate = 0;
84     
85     // Fee variables.  Fees are reserved and then withdrawn  later.
86     uint256 submittedFeesPaid = 0;
87     uint256 penalty = 0;
88     uint256 reservedFees = 0;
89     
90     // Storage.
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93 
94 
95    // Fallback function mines the tokens.
96    // Send from a wallet you control.
97    // DON'T send from an exchange wallet!
98    // We recommend sending using a method that calculates gas for you.
99    // Here are some estimates (not guaranteed to be accurate):
100    // It usually costs around 90k gas.  It cost more if you cross a tier.
101    // Maximum around 190k gas.
102    function () external payable {
103    
104        require(msg.sender != address(0) &&
105                 tier != 10 &&
106                 swap == false &&
107                 wait == false);
108     
109         uint256 issued = mint(msg.sender, msg.value);
110         
111         Mined(msg.sender, issued);
112         Transfer(this, msg.sender, issued);
113     }
114     
115     // Constructor.
116     function FUTR() public {
117         _start();
118     }
119     
120     // This gets called by constructor AND after the swap to restart evertying.
121     function _start() internal 
122     {
123         swap = false;
124         wait = false;
125         extended = false;
126     
127         endTime = now + 366 days;
128         swapTime = endTime + 30 days;
129         swapEndTime = swapTime + 5 days;
130         endTimeExtended = now + 1096 days;
131         swapTimeExtended = endTimeExtended + 30 days;
132         swapEndTimeExtended = swapTimeExtended + 5 days;
133         
134         submittedFeesPaid = 0;
135         _submitted = 0;
136         
137         reservedFees = 0;
138         
139         payRate = 0;
140         
141         tier = 0;
142                 
143         MiningStart(endTime, swapTime, swapEndTime);
144     }
145     
146     // Restarts everything after swap.
147     // This is expensive, so we make someone call it and pay for the gas.
148     // Any holders that miss the swap get to keep their tokens.
149     // Ether stays in contract, minus 20% penalty fee.
150     function restart() public {
151         require(swap && now >= endTime);
152         
153         penalty = this.balance * 2000 / 10000;
154         
155         payFees();
156         
157         _start();
158     }
159     
160     // ERC20 standard supply function.
161     function totalSupply() public constant returns (uint)
162     {
163         return _totalSupply;
164     }
165     
166     // Mints new tokens when they are mined.
167     function mint(address _to, uint256 _value) internal returns (uint256) 
168     {
169         uint256 total = _submitted + _value;
170         
171         if (total > MAX_SUBMITTED)
172         {
173             uint256 refund = total - MAX_SUBMITTED - 1;
174             _value = _value - refund;
175             
176             // refund money and continue.
177             _to.transfer(refund);
178         }
179         
180         _submitted += _value;
181         
182         total -= refund;
183         
184         uint256 tokens = calculateTokens(total, _value);
185         
186         balances[_to] += tokens;
187        
188         _totalSupply += tokens;
189         
190         return tokens;
191     }
192     
193     // Calculates the tokens mined based on the tier.
194     function calculateTokens(uint256 total, uint256 _value) internal returns (uint256)
195     {
196         if (tier == 10) 
197         {
198             // This just rounds it off to an even number.
199             return 7400000000;
200         }
201         
202         uint256 tokens = 0;
203         
204         if (total > levels[tier])
205         {
206             uint256 remaining = total - levels[tier];
207             _value -= remaining;
208             tokens = (_value) * ratios[tier];
209            
210             tier += 1;
211             
212             tokens += calculateTokens(total, remaining);
213         }
214         else
215         {
216             tokens = _value * ratios[tier];
217         }
218         
219         return tokens;
220     }
221     
222     // This is basically so you don't have to add 1 to the last completed tier.
223     //  You're welcome.
224     function currentTier() public view returns (uint256) {
225         if (tier == 10)
226         {
227             return 10;
228         }
229         else
230         {
231             return tier + 1;
232         }
233     }
234     
235     // Ether remaining for tier.
236     function leftInTier() public view returns (uint256) {
237         if (tier == 10) {
238             return 0;
239         }
240         else
241         {
242             return levels[tier] - _submitted;
243         }
244     }
245     
246     // Total sumbitted for mining.
247     function submitted() public view returns (uint256) {
248         return _submitted;
249     }
250     
251     // Balance minus oustanding fees.
252     function balanceMinusFeesOutstanding() public view returns (uint256) {
253         return this.balance - (penalty + (_submitted - submittedFeesPaid) * 1530 / 10000);  // fees are 15.3 % total.
254     }
255     
256     // Calculates the amount of ether per token from the balance.
257     // This is calculated once by the first account to swap.
258     function calulateRate() internal {
259         reservedFees = penalty + (_submitted - submittedFeesPaid) * 1530 / 10000;  // fees are 15.3 % total.
260         
261         uint256 tokens = _totalSupply / 1 ether;
262         payRate = (this.balance - reservedFees);
263 
264         payRate = payRate / tokens;
265     }
266     
267     // This function is called on token transfer and fee payment.
268     // It checks the next deadline and then updates the deadline and state.
269     // 
270     // It uses the block time, but the time periods are days and months,
271     // so it should be pretty safe  ¯\_(ツ)_/¯ 
272     function _updateState() internal {
273         // Most of the time, this will just be skipped.
274         if (now >= endTime)
275         {
276             // We are not currently swapping or waiting to swap
277             if(!swap && !wait)
278             {
279                 if (extended)
280                 {
281                     // It's been 36 months.
282                     wait = true;
283                     endTime = swapTimeExtended;
284                     WaitStarted(endTime);
285                 }
286                 else if (tier == 10)
287                 {
288                     // Tiers filled
289                     wait = true;
290                     endTime = swapTime;
291                     WaitStarted(endTime);
292                 } 
293                 else
294                 {
295                     // Extended to 36 months
296                     endTime = endTimeExtended;
297                     extended = true;
298                     
299                     MiningExtended(endTime, swapTime, swapEndTime);
300                 }
301             } 
302             else if (wait)
303             {
304                 // It's time to swap.
305                 swap = true;
306                 wait = false;
307                 
308                 if (extended) 
309                 {
310                     endTime = swapEndTimeExtended;
311                 }
312                 else
313                 {
314                     endTime = swapEndTime;
315                 }
316                 
317                 SwapStarted(endTime);
318             }
319         }
320     }
321    
322     // Standard ERC20 transfer plus state check and token swap logic.
323     //
324     // We recommend sending using a method that calculates gas for you.
325     //
326     // Here are some estimates (not guaranteed to be accurate):
327     // It usually costs around 37k gas.  It cost more if the state changes.
328     // State change means around 55k - 65k gas.
329     // Swapping tokens for ether costs around 46k gas. (around 93k for the first account to swap)
330     function transfer(address _to, uint256 _value) public returns (bool success) {
331         
332         require(balances[msg.sender] >= _value);
333         
334          // Normal transfers check if time is expired.  
335         _updateState();
336 
337         // Check if sending in for swap.
338         if (_to == address(this)) 
339         {
340             // throw if they can't swap yet.
341             require(swap);
342             
343             if (payRate == 0)
344             {
345                 calulateRate(); // Gas to calc the rate paid by first unlucky soul.
346             }
347             
348             uint256 amount = _value * payRate;
349             // Adjust for decimals
350             amount /= 1 ether;
351             
352             // Burn tokens.
353             balances[msg.sender] -= _value;
354              _totalSupply -= _value;
355             Transfer(msg.sender, _to, _value);
356             
357             //send ether
358             msg.sender.transfer(amount);
359         } else
360         {
361             balances[msg.sender] -= _value;
362             balances[_to] += _value;
363             Transfer(msg.sender, _to, _value);
364         }
365         return true;
366     }
367     
368     // Standard ERC20.
369     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
370        
371         uint256 allowance = allowed[_from][msg.sender];
372         require(balances[_from] >= _value && allowance >= _value);
373         balances[_to] += _value;
374         balances[_from] -= _value;
375         if (allowance < MAX_UINT256) {
376             allowed[_from][msg.sender] -= _value;
377         }
378         Transfer(_from, _to, _value);
379         return true;
380     }
381 
382     // Standard ERC20.
383     function balanceOf(address _owner) view public returns (uint256 balance) {
384         return balances[_owner];
385     }
386 
387     // Standard ERC20.
388     function approve(address _spender, uint256 _value) public returns (bool success) {
389 
390         allowed[msg.sender][_spender] = _value;
391         Approval(msg.sender, _spender, _value);
392         return true;
393     }
394 
395     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
396       return allowed[_owner][_spender];
397     }
398     
399     // ********************
400     // Fee stuff.
401 
402     // Addresses for fees.
403     address public foundation = 0x950ec4ef693d90f8519c4213821e462426d30905;
404     address public owner = 0x78BFCA5E20B0D710EbEF98249f68d9320eE423be;
405     address public dev = 0x5d2b9f5345e69e2390ce4c26ccc9c2910a097520;
406     
407     // Pays fees to the foundation, the owner, and the dev.
408     // It also updates the state.  Anyone can call this.
409     function payFees() public {
410          // Check state to see if swap needs to happen.
411          _updateState();
412          
413         uint256 fees = penalty + (_submitted - submittedFeesPaid) * 1530 / 10000;  // fees are 15.3 % total.
414         submittedFeesPaid = _submitted;
415         
416         reservedFees = 0;
417         penalty = 0;
418         
419         if (fees > 0) 
420         {
421             foundation.transfer(fees / 2);
422             owner.transfer(fees / 4);
423             dev.transfer(fees / 4);
424         }
425     }
426     
427     function changeFoundation (address _receiver) public
428     {
429         require(msg.sender == foundation);
430         foundation = _receiver;
431     }
432     
433     
434     function changeOwner (address _receiver) public
435     {
436         require(msg.sender == owner);
437         owner = _receiver;
438     }
439     
440     function changeDev (address _receiver) public
441     {
442         require(msg.sender == dev);
443         dev = _receiver;
444     }    
445 
446 }