1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8   function Ownable() {
9     owner = msg.sender;
10   }
11 
12 
13   modifier onlyOwner() {
14     if (msg.sender != owner) {
15       throw;
16     }
17     _;
18   }
19 
20 
21   function transferOwnership(address newOwner) onlyOwner {
22     if (newOwner != address(0)) {
23       owner = newOwner;
24     }
25   }
26 
27 }
28 
29 contract ERC20Basic {
30   uint public totalSupply;
31   function balanceOf(address who) constant returns (uint);
32   function transfer(address _to, uint _value) returns (bool success);
33   event Transfer(address indexed from, address indexed to, uint value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) constant returns (uint);
38   function transferFrom(address _from, address _to, uint _value) returns (bool success);
39   function approve(address _spender, uint _value) returns (bool success);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43 
44 contract FractionalERC20 is ERC20 {
45 
46   uint public decimals;
47 
48 }
49 
50 contract FinalizeAgent {
51 
52   function isFinalizeAgent() public constant returns(bool) {
53     return true;
54   }
55 
56 
57   function isSane() public constant returns (bool);
58 
59   function finalizeCrowdsale();
60 
61 }
62 
63 contract PricingStrategy {
64 
65   function isPricingStrategy() public constant returns (bool) {
66     return true;
67   }
68 
69   
70   function isSane(address crowdsale) public constant returns (bool) {
71     return true;
72   }
73 
74  
75   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
76 }
77 
78 
79 contract SafeMathLib {
80 
81   function safeMul(uint a, uint b) returns (uint) {
82     uint c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function safeSub(uint a, uint b) returns (uint) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   function safeAdd(uint a, uint b) returns (uint) {
93     uint c = a + b;
94     assert(c>=a);
95     return c;
96   }
97 
98   function assert(bool assertion) private {
99     if (!assertion) throw;
100   }
101 }
102 
103 contract Haltable is Ownable {
104   bool public halted;
105 
106   modifier stopInEmergency {
107     if (halted) throw;
108     _;
109   }
110 
111   modifier onlyInEmergency {
112     if (!halted) throw;
113     _;
114   }
115 
116   function halt() external onlyOwner {
117     halted = true;
118   }
119 
120   function unhalt() external onlyOwner onlyInEmergency {
121     halted = false;
122   }
123 
124 }
125 
126 contract Crowdsale is Haltable, SafeMathLib {
127 
128  
129   FractionalERC20 public token;
130 
131   PricingStrategy public pricingStrategy;
132 
133   FinalizeAgent public finalizeAgent;
134 
135   address public multisigWallet;
136 
137   uint public minimumFundingGoal;
138 
139   uint public startsAt;
140 
141   uint public endsAt;
142 
143   uint public tokensSold = 0;
144 
145   uint public weiRaised = 0;
146 
147   uint public investorCount = 0;
148   uint public loadedRefund = 0;
149   uint public weiRefunded = 0;
150   bool public finalized;
151   bool public requireCustomerId;
152   bool public requiredSignedAddress;
153   address public signerAddress;
154   mapping (address => uint256) public investedAmountOf;
155   mapping (address => uint256) public tokenAmountOf;
156   mapping (address => bool) public earlyParticipantWhitelist;
157   uint public ownerTestValue;
158   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
159   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
160   event Refund(address investor, uint weiAmount);
161   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
162   event Whitelisted(address addr, bool status);
163   event EndsAtChanged(uint endsAt);
164 
165   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
166 
167     owner = msg.sender;
168 
169     token = FractionalERC20(_token);
170 
171     setPricingStrategy(_pricingStrategy);
172 
173     multisigWallet = _multisigWallet;
174     if(multisigWallet == 0) {
175         throw;
176     }
177 
178     if(_start == 0) {
179         throw;
180     }
181 
182     startsAt = _start;
183 
184     if(_end == 0) {
185         throw;
186     }
187 
188     endsAt = _end;
189     if(startsAt >= endsAt) {
190         throw;
191     }
192     minimumFundingGoal = _minimumFundingGoal;
193   }
194   function() payable {
195     throw;
196   }
197   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
198     if(getState() == State.PreFunding) {
199       if(!earlyParticipantWhitelist[receiver]) {
200         throw;
201       }
202     } else if(getState() == State.Funding) {
203     } else {
204       throw;
205     }
206 
207     uint weiAmount = msg.value;
208     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
209 
210     if(tokenAmount == 0) {
211       throw;
212     }
213 
214     if(investedAmountOf[receiver] == 0) {
215        investorCount++;
216     }
217     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
218     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
219     weiRaised = safeAdd(weiRaised,weiAmount);
220     tokensSold = safeAdd(tokensSold,tokenAmount);
221     if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
222       throw;
223     }
224 
225     assignTokens(receiver, tokenAmount);
226     if(!multisigWallet.send(weiAmount)) throw;
227     Invested(receiver, weiAmount, tokenAmount, customerId);
228   }
229   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
230 
231     uint tokenAmount = fullTokens * 10**token.decimals();
232     uint weiAmount = weiPrice * fullTokens;
233 
234     weiRaised = safeAdd(weiRaised,weiAmount);
235     tokensSold = safeAdd(tokensSold,tokenAmount);
236 
237     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
238     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
239 
240     assignTokens(receiver, tokenAmount);
241     Invested(receiver, weiAmount, tokenAmount, 0);
242   }
243   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
244      bytes32 hash = sha256(addr);
245      if (ecrecover(hash, v, r, s) != signerAddress) throw;
246      if(customerId == 0) throw;
247      investInternal(addr, customerId);
248   }
249   function investWithCustomerId(address addr, uint128 customerId) public payable {
250     if(requiredSignedAddress) throw;
251     if(customerId == 0) throw;
252     investInternal(addr, customerId);
253   }
254   function invest(address addr) public payable {
255     if(requireCustomerId) throw;
256     if(requiredSignedAddress) throw;
257     investInternal(addr, 0);
258   }
259   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
260     investWithSignedAddress(msg.sender, customerId, v, r, s);
261   }
262   function buyWithCustomerId(uint128 customerId) public payable {
263     investWithCustomerId(msg.sender, customerId);
264   }
265   function buy() public payable {
266     invest(msg.sender);
267   }
268   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
269     if(finalized) {
270       throw;
271     }
272     if(address(finalizeAgent) != 0) {
273       finalizeAgent.finalizeCrowdsale();
274     }
275 
276     finalized = true;
277   }
278   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
279     finalizeAgent = addr;
280     if(!finalizeAgent.isFinalizeAgent()) {
281       throw;
282     }
283   }
284   function setRequireCustomerId(bool value) onlyOwner {
285     requireCustomerId = value;
286     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
287   }
288   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
289     requiredSignedAddress = value;
290     signerAddress = _signerAddress;
291     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
292   }
293   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
294     earlyParticipantWhitelist[addr] = status;
295     Whitelisted(addr, status);
296   }
297   function setEndsAt(uint time) onlyOwner {
298 
299     if(now > time) {
300       throw;
301     }
302 
303     endsAt = time;
304     EndsAtChanged(endsAt);
305   }
306   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
307     pricingStrategy = _pricingStrategy;
308     if(!pricingStrategy.isPricingStrategy()) {
309       throw;
310     }
311   }
312   function loadRefund() public payable inState(State.Failure) {
313     if(msg.value == 0) throw;
314     loadedRefund = safeAdd(loadedRefund,msg.value);
315   }
316   function refund() public inState(State.Refunding) {
317     uint256 weiValue = investedAmountOf[msg.sender];
318     if (weiValue == 0) throw;
319     investedAmountOf[msg.sender] = 0;
320     weiRefunded = safeAdd(weiRefunded,weiValue);
321     Refund(msg.sender, weiValue);
322     if (!msg.sender.send(weiValue)) throw;
323   }
324   function isMinimumGoalReached() public constant returns (bool reached) {
325     return weiRaised >= minimumFundingGoal;
326   }
327   function isFinalizerSane() public constant returns (bool sane) {
328     return finalizeAgent.isSane();
329   }
330   function isPricingSane() public constant returns (bool sane) {
331     return pricingStrategy.isSane(address(this));
332   }
333   function getState() public constant returns (State) {
334     if(finalized) return State.Finalized;
335     else if (address(finalizeAgent) == 0) return State.Preparing;
336     else if (!finalizeAgent.isSane()) return State.Preparing;
337     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
338     else if (block.timestamp < startsAt) return State.PreFunding;
339     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
340     else if (isMinimumGoalReached()) return State.Success;
341     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
342     else return State.Failure;
343   }
344   function setOwnerTestValue(uint val) onlyOwner {
345     ownerTestValue = val;
346   }
347   function isCrowdsale() public constant returns (bool) {
348     return true;
349   }
350   modifier inState(State state) {
351     if(getState() != state) throw;
352     _;
353   }
354   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
355   function isCrowdsaleFull() public constant returns (bool);
356   function assignTokens(address receiver, uint tokenAmount) private;
357 }
358 
359 
360 
361 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
362 
363   uint public constant MAX_TRANCHES = 10;
364   mapping (address => uint) public preicoAddresses;
365 
366   struct Tranche {
367       uint amount;
368       uint price;
369   }
370   Tranche[10] public tranches;
371   uint public trancheCount;
372   function EthTranchePricing(uint[] _tranches) {
373     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
374       throw;
375     }
376 
377     trancheCount = _tranches.length / 2;
378 
379     uint highestAmount = 0;
380 
381     for(uint i=0; i<_tranches.length/2; i++) {
382       tranches[i].amount = _tranches[i*2];
383       tranches[i].price = _tranches[i*2+1];
384       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
385         throw;
386       }
387 
388       highestAmount = tranches[i].amount;
389     }
390     if(tranches[0].amount != 0) {
391       throw;
392     }
393     if(tranches[trancheCount-1].price != 0) {
394       throw;
395     }
396   }
397   function setPreicoAddress(address preicoAddress, uint pricePerToken)
398     public
399     onlyOwner
400   {
401     preicoAddresses[preicoAddress] = pricePerToken;
402   }
403   function getTranche(uint n) public constant returns (uint, uint) {
404     return (tranches[n].amount, tranches[n].price);
405   }
406 
407   function getFirstTranche() private constant returns (Tranche) {
408     return tranches[0];
409   }
410 
411   function getLastTranche() private constant returns (Tranche) {
412     return tranches[trancheCount-1];
413   }
414 
415   function getPricingStartsAt() public constant returns (uint) {
416     return getFirstTranche().amount;
417   }
418 
419   function getPricingEndsAt() public constant returns (uint) {
420     return getLastTranche().amount;
421   }
422 
423   function isSane(address _crowdsale) public constant returns(bool) {
424     return true;
425   }
426   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
427     uint i;
428 
429     for(i=0; i < tranches.length; i++) {
430       if(weiRaised < tranches[i].amount) {
431         return tranches[i-1];
432       }
433     }
434   }
435   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
436     return getCurrentTranche(weiRaised).price;
437   }
438   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
439 
440     uint multiplier = 10 ** decimals;
441     if(preicoAddresses[msgSender] > 0) {
442       return safeMul(value,multiplier) / preicoAddresses[msgSender];
443     }
444 
445     uint price = getCurrentPrice(weiRaised);
446     return safeMul(value,multiplier) / price;
447   }
448 
449   function() payable {
450     throw;
451   }
452 
453 }