1 pragma solidity ^0.4.18;
2 
3 
4 contract FUTMOTO {
5 
6     uint256 constant MAX_UINT256 = 2**256 - 1;
7     
8     uint256 MAX_SUBMITTED = 15000000000000000000;
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
20       1000000000000000000,
21       3000000000000000000,
22       6000000000000000000,
23       10000000000000000000,
24       15000000000000000000
25     ];
26     
27     // Token amounts for each tier.
28     uint256[] ratios = [
29       100,
30       110,
31       121,
32       133,
33       146
34        
35       ]; 
36      
37     // total ether submitted before fees.
38     uint256 _submitted = 0;
39     
40     uint256 public tier = 0;
41     
42     // ERC20 events.
43     event Transfer(address indexed _from, address indexed _to, uint _value);
44     event Approval(address indexed _owner, address indexed _spender, uint _value);
45     
46     // FUTR events.
47     event Mined(address indexed _miner, uint _value);
48     event WaitStarted(uint256 endTime);
49     event SwapStarted(uint256 endTime);
50     event MiningStart(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
51     event MiningExtended(uint256 end_time, uint256 swap_time, uint256 swap_end_time);
52 
53  
54     // Optional ERC20 values.
55     string public name = "Futeremoto";
56     uint8 public decimals = 18;
57     string public symbol = "FUTMOTO";
58     
59     // Public variables so the curious can check the state.
60     bool public swap = false;
61     bool public wait = false;
62     bool public extended = false;
63     
64     // Public end time for the current state.
65     uint256 public endTime;
66     
67     // These are calculated at mining start.
68     uint256 swapTime;
69     uint256 swapEndTime;
70     uint256 endTimeExtended;
71     uint256 swapTimeExtended;
72     uint256 swapEndTimeExtended;
73     
74     // Pay rate calculated from balance later.
75     uint256 public payRate = 0;
76     
77     // Fee variables.  Fees are reserved and then withdrawn  later.
78     uint256 submittedFeesPaid = 0;
79     uint256 penalty = 0;
80     uint256 reservedFees = 0;
81     
82     // Storage.
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 
86 
87    // Fallback function mines the tokens.
88    // Send from a wallet you control.
89    // DON'T send from an exchange wallet!
90    // We recommend sending using a method that calculates gas for you.
91    // Here are some estimates (not guaranteed to be accurate):
92    // It usually costs around 90k gas.  It cost more if you cross a tier.
93    // Maximum around 190k gas.
94    function () external payable {
95    
96        require(msg.sender != address(0) &&
97                 tier != 5 &&
98                 swap == false &&
99                 wait == false);
100     
101         uint256 issued = mint(msg.sender, msg.value);
102         
103         Mined(msg.sender, issued);
104         Transfer(this, msg.sender, issued);
105     }
106     
107     // Constructor.
108     function FUTMOTO() public {
109         _start();
110     }
111     
112     // This gets called by constructor AND after the swap to restart evertying.
113     function _start() internal 
114     {
115         swap = false;
116         wait = false;
117         extended = false;
118     
119         endTime = now + 5 days;
120         swapTime = endTime + 1 days;
121         swapEndTime = swapTime + 1 days;
122         endTimeExtended = now + 7 days;
123         swapTimeExtended = endTimeExtended + 5 days;
124         swapEndTimeExtended = swapTimeExtended + 1 days;
125         
126         submittedFeesPaid = 0;
127         _submitted = 0;
128         
129         reservedFees = 0;
130         
131         payRate = 0;
132         
133         tier = 0;
134                 
135         MiningStart(endTime, swapTime, swapEndTime);
136     }
137     
138     // Restarts everything after swap.
139     // This is expensive, so we make someone call it and pay for the gas.
140     // Any holders that miss the swap get to keep their tokens.
141     // Ether stays in contract, minus 20% penalty fee.
142     function restart() public {
143         require(swap && now >= endTime);
144         
145         penalty = this.balance * 2000 / 10000;
146         
147         payFees();
148         
149         _start();
150     }
151     
152     // ERC20 standard supply function.
153     function totalSupply() public constant returns (uint)
154     {
155         return _totalSupply;
156     }
157     
158     // Mints new tokens when they are mined.
159     function mint(address _to, uint256 _value) internal returns (uint256) 
160     {
161         uint256 total = _submitted + _value;
162         
163         if (total > MAX_SUBMITTED)
164         {
165             uint256 refund = total - MAX_SUBMITTED - 1;
166             _value = _value - refund;
167             
168             // refund money and continue.
169             _to.transfer(refund);
170         }
171         
172         _submitted += _value;
173         
174         total -= refund;
175         
176         uint256 tokens = calculateTokens(total, _value);
177         
178         balances[_to] += tokens;
179        
180         _totalSupply += tokens;
181         
182         return tokens;
183     }
184     
185     // Calculates the tokens mined based on the tier.
186     function calculateTokens(uint256 total, uint256 _value) internal returns (uint256)
187     {
188          if (tier == 5) 
189         
190 
191         
192         uint256 tokens = 0;
193         
194         if (total > levels[tier])
195         {
196             uint256 remaining = total - levels[tier];
197             _value -= remaining;
198             tokens = (_value) * ratios[tier];
199            
200             tier += 1;
201             
202             tokens += calculateTokens(total, remaining);
203         }
204         else
205         {
206             tokens = _value * ratios[tier];
207         }
208         
209         return tokens;
210     }
211     
212     // This is basically so you don't have to add 1 to the last completed tier.
213     //  You're welcome.
214     function currentTier() public view returns (uint256) {
215         if (tier == 5)
216         {
217             return 5;
218         }
219         else
220         {
221             return tier + 1;
222         }
223     }
224     
225     // Ether remaining for tier.
226     function leftInTier() public view returns (uint256) {
227         if (tier == 5) {
228             return 0;
229         }
230         else
231         {
232             return levels[tier] - _submitted;
233         }
234     }
235     
236     // Total sumbitted for mining.
237     function submitted() public view returns (uint256) {
238         return _submitted;
239     }
240     
241     // Balance minus oustanding fees.
242     function balanceMinusFeesOutstanding() public view returns (uint256) {
243         return this.balance - (penalty + (_submitted - submittedFeesPaid) * 530 / 10000);  // fees are 5.3 % total.
244     }
245     
246     // Calculates the amount of ether per token from the balance.
247     // This is calculated once by the first account to swap.
248     function calulateRate() internal {
249         reservedFees = penalty + (_submitted - submittedFeesPaid) * 530 / 10000;  // fees are 15.3 % total.
250         
251         uint256 tokens = _totalSupply / 1 ether;
252         payRate = (this.balance - reservedFees);
253 
254         payRate = payRate / tokens;
255     }
256     
257     // This function is called on token transfer and fee payment.
258     // It checks the next deadline and then updates the deadline and state.
259     // 
260     // It uses the block time, but the time periods are days and months,
261     // so it should be pretty safe  ¯\_(ツ)_/¯ 
262     function _updateState() internal {
263         // Most of the time, this will just be skipped.
264         if (now >= endTime)
265         {
266             // We are not currently swapping or waiting to swap
267             if(!swap && !wait)
268             {
269                 if (extended)
270                 {
271                     // It's been 36 months.
272                     wait = true;
273                     endTime = swapTimeExtended;
274                     WaitStarted(endTime);
275                 }
276                 else if (tier == 5)
277                 {
278                     // Tiers filled
279                     wait = true;
280                     endTime = swapTime;
281                     WaitStarted(endTime);
282                 } 
283                 else
284                 {
285                     // Extended to 36 months
286                     endTime = endTimeExtended;
287                     extended = true;
288                     
289                     MiningExtended(endTime, swapTime, swapEndTime);
290                 }
291             } 
292             else if (wait)
293             {
294                 // It's time to swap.
295                 swap = true;
296                 wait = false;
297                 
298                 if (extended) 
299                 {
300                     endTime = swapEndTimeExtended;
301                 }
302                 else
303                 {
304                     endTime = swapEndTime;
305                 }
306                 
307                 SwapStarted(endTime);
308             }
309         }
310     }
311    
312     // Standard ERC20 transfer plus state check and token swap logic.
313     //
314     // We recommend sending using a method that calculates gas for you.
315     //
316     // Here are some estimates (not guaranteed to be accurate):
317     // It usually costs around 37k gas.  It cost more if the state changes.
318     // State change means around 55k - 65k gas.
319     // Swapping tokens for ether costs around 46k gas. (around 93k for the first account to swap)
320     function transfer(address _to, uint256 _value) public returns (bool success) {
321         
322         require(balances[msg.sender] >= _value);
323         
324          // Normal transfers check if time is expired.  
325         _updateState();
326 
327         // Check if sending in for swap.
328         if (_to == address(this)) 
329         {
330             // throw if they can't swap yet.
331             require(swap);
332             
333             if (payRate == 0)
334             {
335                 calulateRate(); // Gas to calc the rate paid by first unlucky soul.
336             }
337             
338             uint256 amount = _value * payRate;
339             // Adjust for decimals
340             amount /= 1 ether;
341             
342             // Burn tokens.
343             balances[msg.sender] -= _value;
344              _totalSupply -= _value;
345             Transfer(msg.sender, _to, _value);
346             
347             //send ether
348             msg.sender.transfer(amount);
349         } else
350         {
351             balances[msg.sender] -= _value;
352             balances[_to] += _value;
353             Transfer(msg.sender, _to, _value);
354         }
355         return true;
356     }
357     
358     // Standard ERC20.
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
360        
361         uint256 allowance = allowed[_from][msg.sender];
362         require(balances[_from] >= _value && allowance >= _value);
363         balances[_to] += _value;
364         balances[_from] -= _value;
365         if (allowance < MAX_UINT256) {
366             allowed[_from][msg.sender] -= _value;
367         }
368         Transfer(_from, _to, _value);
369         return true;
370     }
371 
372     // Standard ERC20.
373     function balanceOf(address _owner) view public returns (uint256 balance) {
374         return balances[_owner];
375     }
376 
377     // Standard ERC20.
378     function approve(address _spender, uint256 _value) public returns (bool success) {
379 
380         allowed[msg.sender][_spender] = _value;
381         Approval(msg.sender, _spender, _value);
382         return true;
383     }
384 
385     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
386       return allowed[_owner][_spender];
387     }
388     
389     // ********************
390     // Fee stuff.
391 
392     // Addresses for fees. Top owns all these
393     address public foundation = 0xE252765E4A71e3170b2215cf63C16E7553ec26bD;
394     address public owner = 0xa4cdd9c17d87EcceF6a02AC43F677501cAb05d04;
395     address public dev = 0x752607dc81e0336ea6ddccced509d8fd28610b54;
396     
397     // Pays fees to the foundation, the owner, and the dev.
398     // It also updates the state.  Anyone can call this.
399     function payFees() public {
400          // Check state to see if swap needs to happen.
401          _updateState();
402          
403         uint256 fees = penalty + (_submitted - submittedFeesPaid) * 530 / 10000;  // fees are 5.3 % total.
404         submittedFeesPaid = _submitted;
405         
406         reservedFees = 0;
407         penalty = 0;
408         
409         if (fees > 0) 
410         {
411             foundation.transfer(fees / 2);
412             owner.transfer(fees / 4);
413             dev.transfer(fees / 4);
414         }
415     }
416     
417     function changeFoundation (address _receiver) public
418     {
419         require(msg.sender == foundation);
420         foundation = _receiver;
421     }
422     
423     
424     function changeOwner (address _receiver) public
425     {
426         require(msg.sender == owner);
427         owner = _receiver;
428     }
429     
430     function changeDev (address _receiver) public
431     {
432         require(msg.sender == dev);
433         dev = _receiver;
434     }    
435 
436 }