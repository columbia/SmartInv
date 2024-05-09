1 pragma solidity ^0.4.13;
2 
3 contract Token {
4   /* This is a slight change to the ERC20 base standard.
5      function totalSupply() constant returns (uint256 supply);
6      is replaced with:
7      uint256 public totalSupply;
8      This automatically creates a getter function for the totalSupply.
9      This is moved to the base contract since public getter functions are not
10      currently recognised as an implementation of the matching abstract
11      function by the compiler.
12   */
13   /// total amount of tokens
14   uint256 public totalSupply;
15 
16   /// @param _owner The address from which the balance will be retrieved
17   /// @return The balance
18   function balanceOf(address _owner) constant returns (uint256 balance);
19 
20   /// @notice send `_value` token to `_to` from `msg.sender`
21   /// @param _to The address of the recipient
22   /// @param _value The amount of token to be transferred
23   /// @return Whether the transfer was successful or not
24   function transfer(address _to, uint256 _value) returns (bool success);
25 
26   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27   /// @param _from The address of the sender
28   /// @param _to The address of the recipient
29   /// @param _value The amount of token to be transferred
30   /// @return Whether the transfer was successful or not
31   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34   /// @param _spender The address of the account able to transfer the tokens
35   /// @param _value The amount of tokens to be approved for transfer
36   /// @return Whether the approval was successful or not
37   function approve(address _spender, uint256 _value) returns (bool success);
38 
39   /// @param _owner The address of the account owning tokens
40   /// @param _spender The address of the account able to transfer the tokens
41   /// @return Amount of remaining tokens allowed to spent
42   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49 
50   function transfer(address _to, uint256 _value) returns (bool success) {
51     //Default assumes totalSupply can't be over max (2^256 - 1).
52     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53     //Replace the if with this one instead.
54     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55     if (balances[msg.sender] >= _value && _value > 0) {
56       balances[msg.sender] -= _value;
57       balances[_to] += _value;
58       Transfer(msg.sender, _to, _value);
59       return true;
60     } else { return false; }
61   }
62 
63   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64     //same as above. Replace this line with the following if you want to protect against wrapping uints.
65     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67       balances[_to] += _value;
68       balances[_from] -= _value;
69       allowed[_from][msg.sender] -= _value;
70       Transfer(_from, _to, _value);
71       return true;
72     } else { return false; }
73   }
74 
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79   function approve(address _spender, uint256 _value) returns (bool success) {
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84 
85   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89   mapping (address => uint256) balances;
90   mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract EasyMineToken is StandardToken {
94 
95   string public constant name = "easyMINE Token";
96   string public constant symbol = "EMT";
97   uint8 public constant decimals = 18;
98 
99   function EasyMineToken(address _icoAddress,
100                          address _preIcoAddress,
101                          address _easyMineWalletAddress,
102                          address _bountyWalletAddress) {
103     require(_icoAddress != 0x0);
104     require(_preIcoAddress != 0x0);
105     require(_easyMineWalletAddress != 0x0);
106     require(_bountyWalletAddress != 0x0);
107 
108     totalSupply = 33000000 * 10**18;                     // 33.000.000 EMT
109 
110     uint256 icoTokens = 27000000 * 10**18;               // 27.000.000 EMT
111 
112     uint256 preIcoTokens = 2000000 * 10**18;             // 2.000.000 EMT
113 
114     uint256 easyMineTokens = 3000000 * 10**18;           // 1.500.000 EMT dev team +
115                                                          // 500.000 EMT advisors +
116                                                          // 1.000.000 EMT easyMINE corporation +
117                                                          // = 3.000.000 EMT
118 
119     uint256 bountyTokens = 1000000 * 10**18;             // 1.000.000 EMT
120 
121     assert(icoTokens + preIcoTokens + easyMineTokens + bountyTokens == totalSupply);
122 
123     balances[_icoAddress] = icoTokens;
124     Transfer(0, _icoAddress, icoTokens);
125 
126     balances[_preIcoAddress] = preIcoTokens;
127     Transfer(0, _preIcoAddress, preIcoTokens);
128 
129     balances[_easyMineWalletAddress] = easyMineTokens;
130     Transfer(0, _easyMineWalletAddress, easyMineTokens);
131 
132     balances[_bountyWalletAddress] = bountyTokens;
133     Transfer(0, _bountyWalletAddress, bountyTokens);
134   }
135 
136   function burn(uint256 _value) returns (bool success) {
137     if (balances[msg.sender] >= _value && _value > 0) {
138       balances[msg.sender] -= _value;
139       totalSupply -= _value;
140       Transfer(msg.sender, 0x0, _value);
141       return true;
142     } else {
143       return false;
144     }
145   }
146 }
147 
148 contract EasyMineTokenWallet {
149 
150   uint256 constant public VESTING_PERIOD = 180 days;
151   uint256 constant public DAILY_FUNDS_RELEASE = 15000 * 10**18; // 0.5% * 3M tokens = 15k tokens a day
152 
153   address public owner;
154   address public withdrawalAddress;
155   Token public easyMineToken;
156   uint256 public startTime;
157   uint256 public totalWithdrawn;
158 
159   modifier isOwner() {
160     require(msg.sender == owner);
161     _;
162   }
163 
164   function EasyMineTokenWallet() {
165     owner = msg.sender;
166   }
167 
168   function setup(address _easyMineToken, address _withdrawalAddress)
169     public
170     isOwner
171   {
172     require(_easyMineToken != 0x0);
173     require(_withdrawalAddress != 0x0);
174 
175     easyMineToken = Token(_easyMineToken);
176     withdrawalAddress = _withdrawalAddress;
177     startTime = now;
178   }
179 
180   function withdraw(uint256 requestedAmount)
181     public
182     isOwner
183     returns (uint256 amount)
184   {
185     uint256 limit = maxPossibleWithdrawal();
186     uint256 withdrawalAmount = requestedAmount;
187     if (requestedAmount > limit) {
188       withdrawalAmount = limit;
189     }
190 
191     if (withdrawalAmount > 0) {
192       if (!easyMineToken.transfer(withdrawalAddress, withdrawalAmount)) {
193         revert();
194       }
195       totalWithdrawn += withdrawalAmount;
196     }
197 
198     return withdrawalAmount;
199   }
200 
201   function maxPossibleWithdrawal()
202     public
203     constant
204     returns (uint256)
205   {
206     if (now < startTime + VESTING_PERIOD) {
207       return 0;
208     } else {
209       uint256 daysPassed = (now - (startTime + VESTING_PERIOD)) / 86400;
210       uint256 res = DAILY_FUNDS_RELEASE * daysPassed - totalWithdrawn;
211       if (res < 0) {
212         return 0;
213       } else {
214         return res;
215       }
216     }
217   }
218 
219 }
220 
221 contract EasyMineIco {
222 
223   event TokensSold(address indexed buyer, uint256 amount);
224   event TokensReserved(uint256 amount);
225   event IcoFinished(uint256 burned);
226 
227   struct PriceThreshold {
228     uint256 tokenCount;
229     uint256 price;
230     uint256 tokensSold;
231   }
232 
233   /* Maximum duration of ICO */
234   uint256 public maxDuration;
235 
236   /* Minimum start delay in blocks */
237   uint256 public minStartDelay;
238 
239   /* The owner of this contract */
240   address public owner;
241 
242   /* The sys address that handles token reservation */
243   address public sys;
244 
245   /* The reservation address - where reserved tokens will be send */
246   address public reservationAddress;
247 
248   /* The easyMINE wallet address */
249   address public wallet;
250 
251   /* The easyMINE token */
252   EasyMineToken public easyMineToken;
253 
254   /* ICO start block */
255   uint256 public startBlock;
256 
257   /* ICO end block */
258   uint256 public endBlock;
259 
260   /* The three price thresholds */
261   PriceThreshold[3] public priceThresholds;
262 
263   /* Current stage */
264   Stages public stage;
265 
266   enum Stages {
267     Deployed,
268     SetUp,
269     StartScheduled,
270     Started,
271     Ended
272   }
273 
274   modifier atStage(Stages _stage) {
275     require(stage == _stage);
276     _;
277   }
278 
279   modifier isOwner() {
280     require(msg.sender == owner);
281     _;
282   }
283 
284   modifier isSys() {
285     require(msg.sender == sys);
286     _;
287   }
288 
289   modifier isValidPayload() {
290     require(msg.data.length == 0 || msg.data.length == 4);
291     _;
292   }
293 
294   modifier timedTransitions() {
295     if (stage == Stages.StartScheduled && block.number >= startBlock) {
296       stage = Stages.Started;
297     }
298     if (stage == Stages.Started && block.number >= endBlock) {
299       finalize();
300     }
301     _;
302   }
303 
304   function EasyMineIco(address _wallet)
305     public {
306     require(_wallet != 0x0);
307 
308     owner = msg.sender;
309     wallet = _wallet;
310     stage = Stages.Deployed;
311   }
312 
313   /* Fallback function */
314   function()
315     public
316     payable
317     timedTransitions {
318     if (stage == Stages.Started) {
319       buyTokens();
320     } else {
321       revert();
322     }
323   }
324 
325   function setup(address _easyMineToken, address _sys, address _reservationAddress, uint256 _minStartDelay, uint256 _maxDuration)
326     public
327     isOwner
328     atStage(Stages.Deployed)
329   {
330     require(_easyMineToken != 0x0);
331     require(_sys != 0x0);
332     require(_reservationAddress != 0x0);
333     require(_minStartDelay > 0);
334     require(_maxDuration > 0);
335 
336     priceThresholds[0] = PriceThreshold(2000000  * 10**18, 0.00070 * 10**18, 0);
337     priceThresholds[1] = PriceThreshold(2000000  * 10**18, 0.00075 * 10**18, 0);
338     priceThresholds[2] = PriceThreshold(23000000 * 10**18, 0.00080 * 10**18, 0);
339 
340     easyMineToken = EasyMineToken(_easyMineToken);
341     sys = _sys;
342     reservationAddress = _reservationAddress;
343     minStartDelay = _minStartDelay;
344     maxDuration = _maxDuration;
345 
346     // Validate token balance
347     assert(easyMineToken.balanceOf(this) == maxTokensSold());
348 
349     stage = Stages.SetUp;
350   }
351 
352   function maxTokensSold()
353     public
354     constant
355     returns (uint256) {
356     uint256 total = 0;
357     for (uint8 i = 0; i < priceThresholds.length; i++) {
358       total += priceThresholds[i].tokenCount;
359     }
360     return total;
361   }
362 
363   function totalTokensSold()
364     public
365     constant
366     returns (uint256) {
367     uint256 total = 0;
368     for (uint8 i = 0; i < priceThresholds.length; i++) {
369       total += priceThresholds[i].tokensSold;
370     }
371     return total;
372   }
373 
374   /* Schedules start of the ICO */
375   function scheduleStart(uint256 _startBlock)
376     public
377     isOwner
378     atStage(Stages.SetUp)
379   {
380     // Start allowed minimum 5000 blocks from now
381     require(_startBlock > block.number + minStartDelay);
382 
383     startBlock = _startBlock;
384     endBlock = startBlock + maxDuration;
385     stage = Stages.StartScheduled;
386   }
387 
388   function updateStage()
389     public
390     timedTransitions
391     returns (Stages)
392   {
393     return stage;
394   }
395 
396   function buyTokens()
397     public
398     payable
399     isValidPayload
400     timedTransitions
401     atStage(Stages.Started)
402   {
403     require(msg.value > 0);
404 
405     uint256 amountRemaining = msg.value;
406     uint256 tokensToReceive = 0;
407 
408     for (uint8 i = 0; i < priceThresholds.length; i++) {
409       uint256 tokensAvailable = priceThresholds[i].tokenCount - priceThresholds[i].tokensSold;
410       uint256 maxTokensByAmount = amountRemaining * 10**18 / priceThresholds[i].price;
411 
412       uint256 tokens;
413       if (maxTokensByAmount > tokensAvailable) {
414         tokens = tokensAvailable;
415         amountRemaining -= (priceThresholds[i].price * tokens) / 10**18;
416       } else {
417         tokens = maxTokensByAmount;
418         amountRemaining = 0;
419       }
420       priceThresholds[i].tokensSold += tokens;
421       tokensToReceive += tokens;
422     }
423 
424     assert(tokensToReceive > 0);
425 
426     if (amountRemaining != 0) {
427       assert(msg.sender.send(amountRemaining));
428     }
429 
430     assert(wallet.send(msg.value - amountRemaining));
431     assert(easyMineToken.transfer(msg.sender, tokensToReceive));
432 
433     if (totalTokensSold() == maxTokensSold()) {
434       finalize();
435     }
436 
437     TokensSold(msg.sender, tokensToReceive);
438   }
439 
440   function reserveTokens(uint256 tokenCount)
441     public
442     isSys
443     timedTransitions
444     atStage(Stages.Started)
445   {
446     require(tokenCount > 0);
447 
448     uint256 tokensRemaining = tokenCount;
449 
450     for (uint8 i = 0; i < priceThresholds.length; i++) {
451       uint256 tokensAvailable = priceThresholds[i].tokenCount - priceThresholds[i].tokensSold;
452 
453       uint256 tokens;
454       if (tokensRemaining > tokensAvailable) {
455         tokens = tokensAvailable;
456       } else {
457         tokens = tokensRemaining;
458       }
459       priceThresholds[i].tokensSold += tokens;
460       tokensRemaining -= tokens;
461     }
462 
463     uint256 tokensReserved = tokenCount - tokensRemaining;
464 
465     assert(easyMineToken.transfer(reservationAddress, tokensReserved));
466 
467     if (totalTokensSold() == maxTokensSold()) {
468       finalize();
469     }
470 
471     TokensReserved(tokensReserved);
472   }
473 
474   /* Transfer any ether accidentally left in this contract */
475   function cleanup()
476     public
477     isOwner
478     timedTransitions
479     atStage(Stages.Ended)
480   {
481     assert(owner.send(this.balance));
482   }
483 
484   function finalize()
485     private
486   {
487     stage = Stages.Ended;
488 
489     // burn unsold tokens
490     uint256 balance = easyMineToken.balanceOf(this);
491     easyMineToken.burn(balance);
492     IcoFinished(balance);
493   }
494 
495 }