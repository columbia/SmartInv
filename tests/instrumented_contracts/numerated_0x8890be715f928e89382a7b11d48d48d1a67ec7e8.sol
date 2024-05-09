1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract Ownable {
44     address public owner;
45 
46     function Ownable() {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         if (msg.sender != owner) throw;
52         _;
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 }
61 
62 /*
63  * Pausable
64  * Abstract contract that allows children to implement an
65  * emergency stop mechanism.
66  */
67 
68 contract Pausable is Ownable {
69   bool public stopped;
70 
71   modifier stopInEmergency {
72     if (stopped) {
73       throw;
74     }
75     _;
76   }
77   
78   modifier onlyInEmergency {
79     if (!stopped) {
80       throw;
81     }
82     _;
83   }
84 
85   // called by the owner on emergency, triggers stopped state
86   function emergencyStop() external onlyOwner {
87     stopped = true;
88   }
89 
90   // called by the owner on end of emergency, returns to normal state
91   function release() external onlyOwner onlyInEmergency {
92     stopped = false;
93   }
94 
95 }
96 
97 
98 contract ERC20Basic {
99   uint public totalSupply;
100   function balanceOf(address who) constant returns (uint);
101   function transfer(address to, uint value);
102   event Transfer(address indexed from, address indexed to, uint value);
103 }
104 
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) constant returns (uint);
107   function transferFrom(address from, address to, uint value);
108   function approve(address spender, uint value);
109   event Approval(address indexed owner, address indexed spender, uint value);
110 }
111 
112 /*
113  * PullPayment
114  * Base contract supporting async send for pull payments.
115  * Inherit from this contract and use asyncSend instead of send.
116  */
117 contract PullPayment {
118 
119   using SafeMath for uint;
120   
121   mapping(address => uint) public payments;
122 
123   event LogRefundETH(address to, uint value);
124 
125 
126   /**
127   *  Store sent amount as credit to be pulled, called by payer 
128   **/
129   function asyncSend(address dest, uint amount) internal {
130     payments[dest] = payments[dest].add(amount);
131   }
132 
133   // withdraw accumulated balance, called by payee
134   function withdrawPayments() {
135     address payee = msg.sender;
136     uint payment = payments[payee];
137     
138     if (payment == 0) {
139       throw;
140     }
141 
142     if (this.balance < payment) {
143       throw;
144     }
145 
146     payments[payee] = 0;
147 
148     if (!payee.send(payment)) {
149       throw;
150     }
151     LogRefundETH(payee,payment);
152   }
153 }
154 
155 
156 contract BasicToken is ERC20Basic {
157   
158   using SafeMath for uint;
159   
160   mapping(address => uint) balances;
161   
162   /*
163    * Fix for the ERC20 short address attack  
164   */
165   modifier onlyPayloadSize(uint size) {
166      if(msg.data.length < size + 4) {
167        throw;
168      }
169      _;
170   }
171 
172   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176   }
177 
178   function balanceOf(address _owner) constant returns (uint balance) {
179     return balances[_owner];
180   }
181 }
182 
183 
184 contract StandardToken is BasicToken, ERC20 {
185   mapping (address => mapping (address => uint)) allowed;
186 
187   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
188     var _allowance = allowed[_from][msg.sender];
189     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190     // if (_value > _allowance) throw;
191     balances[_to] = balances[_to].add(_value);
192     balances[_from] = balances[_from].sub(_value);
193     allowed[_from][msg.sender] = _allowance.sub(_value);
194     Transfer(_from, _to, _value);
195   }
196 
197   function approve(address _spender, uint _value) {
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205   }
206 
207   function allowance(address _owner, address _spender) constant returns (uint remaining) {
208     return allowed[_owner][_spender];
209   }
210 }
211 
212 contract ERRLCoin is StandardToken, Ownable {
213   using SafeMath for uint256;
214 
215   string public name = "420 ErrL";
216   string public symbol = "ERRL";
217   uint256 public decimals = 18;
218   uint256 constant public ERRL_UNIT = 10 ** 18;
219   uint256 public INITIAL_SUPPLY = 1000000000000 * ERRL_UNIT; // 1 trillion ( 1,000,000,000,000 ) ERRL COINS
220   uint256 public totalAllocated = 0;             // Counter to keep track of overall token allocation
221   uint256 public remaintokens=0;
222   uint256 public factor=35;
223   //  Constants 
224     uint256 constant public maxOwnerSupply = 16000000000 * ERRL_UNIT;           // Owner seperate allocation
225     uint256 constant public DeveloperSupply = 2000000000 * ERRL_UNIT;     //  Developer's allocation
226 
227 
228 address public constant OWNERSTAKE = 0xea38f5e13FF11A4F519AC1a8a9AE526979750B01;
229    address public constant  DEVSTAKE = 0x625151089d010F2b1B7a72d16Defe2390D596dF8;
230    
231 
232 
233 
234   event Burn(address indexed from, uint256 value);
235 
236   function ERRLCoin() {
237       
238         totalAllocated+=maxOwnerSupply+DeveloperSupply;  // Add to total Allocated funds
239 
240    remaintokens=INITIAL_SUPPLY-totalAllocated;
241       
242     totalSupply = INITIAL_SUPPLY;
243     balances[OWNERSTAKE] = maxOwnerSupply; // owner seperate ERRL tokens
244     balances[DEVSTAKE] = DeveloperSupply; // Developer's share of ERRL tokens for coding the contract
245     balances[msg.sender] = remaintokens; // Send remaining tokens to owner's primary wallet from where contract is deployed
246   }
247 
248   function burn(uint _value) onlyOwner returns (bool) {
249     balances[msg.sender] = balances[msg.sender].sub(_value);
250     totalSupply = totalSupply.sub(_value);
251     Transfer(msg.sender, 0x0, _value);
252     return true;
253   }
254 
255 }
256 
257 /*
258   Crowdsale Smart Contract for the 420 ERRL Token project
259   This smart contract collects ETH, and in return emits equivalent ERRL tokens and 35% of the purchase amount to the purchasers 
260 */
261 contract Crowdsale is Pausable, PullPayment {
262     
263     using SafeMath for uint;
264 
265     struct Backer {
266     uint weiReceived; // Amount of Ether given
267     uint coinSent;
268   }
269 
270   /*
271   * Constants
272   */
273   
274  uint public constant MIN_CAP = 0; // no minimum cap
275   /* Maximum number of ERRLCOINS to sell */
276   uint public constant MAX_CAP = 600000000000 * 10 **18; 
277 
278   // 600,000,000,000 ERRL COINS (600 billions) 
279 
280   /* Crowdsale period */
281   uint private constant CROWDSALE_PERIOD = 3000 days;
282  /*uint private constant CROWDSALE_PERIOD = 1 seconds;*/
283    
284   /* Number of ERRL COINS per Ether */
285   uint public constant COIN_PER_ETHER = 700000 * 10**18; // 700,000 ERRL coins per eth,  1 eth=350$ Canadian , 1 ERRL coin=0.0005$ Canadian
286                                         
287 
288   /*
289   * Variables
290   */
291   /* ERRLCoin contract reference */
292   ERRLCoin public coin;
293     /* Multisig contract that will receive the Ether */
294   address public multisigEther;
295   /* Number of Ether received */
296   uint public etherReceived;
297   
298   uint public ETHToSend;
299   
300   
301   /* Number of ERRLCoin sent to Ether contributors */
302   uint public coinSentToEther;
303   /* Crowdsale start time */
304   uint public startTime;
305   /* Crowdsale end time */
306   uint public endTime;
307   
308   
309   
310   
311   
312   /* Is crowdsale still on going */
313   bool public crowdsaleClosed=false;
314   
315   
316 
317   /* Backers Ether indexed by their Ethereum address */
318   mapping(address => Backer) public backers;
319 
320 
321   /*
322   * Modifiers
323   */
324   
325 
326   modifier respectTimeFrame() {
327     require ((now > startTime) || (now < endTime )) ;
328     _;
329   }
330 
331   /*
332    * Event
333   */
334   event LogReceivedETH(address addr, uint value);
335   event LogCoinsEmited(address indexed from, uint amount);
336 
337   /*
338    * Constructor
339   */
340   function Crowdsale(address _ERRLCoinAddress, address _to) {
341     coin = ERRLCoin(_ERRLCoinAddress);
342     multisigEther = _to;
343   }
344 
345   /* 
346    * The fallback function corresponds to a donation in ETH
347    */
348   function() stopInEmergency respectTimeFrame payable {
349     receiveETH(msg.sender);
350   }
351 
352   /* 
353    * To call to start the crowdsale
354    */
355   function start() onlyOwner {
356    
357     startTime = now ;           
358     endTime =  now + CROWDSALE_PERIOD;  
359 
360     crowdsaleClosed=false;
361    
362   
363    
364   }
365 
366   /*
367    *  Receives a donation in Ether
368   */
369   function receiveETH(address beneficiary) internal {
370 
371 address OWNERICO_STAKE = 0x03bC8e32389082653ea4c25AcF427508499c0Bcb;
372     //if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
373     
374     uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of ERRLCoin to send
375     //if (coinToSend.add(coinSentToEther) > MAX_CAP) throw; 
376 
377     require(coinToSend.add(coinSentToEther) < MAX_CAP); 
378     require(crowdsaleClosed == false);
379     
380     
381 
382     Backer backer = backers[beneficiary];
383     coin.transfer(beneficiary, coinToSend); // Transfer ERRLCoins right now 
384 
385     backer.coinSent = backer.coinSent.add(coinToSend);
386     //backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer
387 uint factor=35;
388 //uint factoreth=65;
389 //ETHToSend = (factor.div(100)).mul(backers[msg.sender].weiReceived);
390 //ETHToSend = backers[msg.sender].weiReceived;
391 
392 ETHToSend = msg.value;
393 
394 ETHToSend=(ETHToSend * 35) / 100;
395 
396 //backers[msg.sender].weiReceived=(factoreth.div(100)).mul(backers[msg.sender].weiReceived);
397 
398 //backers[msg.sender].weiReceived=backers[msg.sender].weiReceived;
399 
400     //uint ETHToSend = (factor/100).mul(backers[msg.sender].weiReceived);
401     
402     //ETHToSend=ETHToSend.div(100);
403     
404    //backers[msg.sender].weiReceived=0; 
405     
406     if (ETHToSend > 0) {
407       //asyncSend(msg.sender, ETHToSend); // pull payment to get 35% refund in ETH
408       //transfer(msg.sender, ETHToSend);
409       beneficiary.transfer(ETHToSend);
410     }
411     
412 LogRefundETH(msg.sender, ETHToSend);
413     //backer.weiReceived = backer.weiReceived.sub(ETHToSend);
414     
415     //backers[msg.sender].weiReceived=(factoreth/100).mul(backers[msg.sender].weiReceived);
416     
417    //pays=(factoreth.div(100)).mul(msg.value);
418 
419     etherReceived = etherReceived.add((msg.value.mul(65)).div(100)); // Update the total wei collected during the crowdfunding
420     //etherReceived=etherReceived.div(100);
421     
422     coinSentToEther = coinSentToEther.add(coinToSend);
423 
424     // Send events
425     LogCoinsEmited(msg.sender ,coinToSend);
426     LogReceivedETH(beneficiary, etherReceived); 
427 
428    
429     coin.transfer(OWNERICO_STAKE,coinToSend); // Transfer ERRLCoins right now to beneficiary ownerICO  
430    
431 
432     coinSentToEther = coinSentToEther.add(coinToSend);
433 
434     LogCoinsEmited(OWNERICO_STAKE ,coinToSend);
435     
436     
437     
438   }
439   
440 
441   /*
442    *Compute the ERRLCoin bonus according to the investment period
443    */
444   function bonus(uint amount) internal constant returns (uint) {
445     
446     return amount;
447   }
448 
449  
450 
451   /*  
452   * Failsafe drain
453   */
454   function drain() onlyOwner {
455     if (!owner.send(this.balance)) throw;
456     crowdsaleClosed = true;
457   }
458 
459   /**
460    * Allow to change the team multisig address in the case of emergency.
461    */
462   function setMultisig(address addr) onlyOwner public {
463     //if (addr == address(0)) throw;
464     require(addr != address(0));
465     multisigEther = addr;
466   }
467 
468   /**
469    * Manually back ERRLCoin owner address.
470    */
471   function backERRLCoinOwner() onlyOwner public {
472     coin.transferOwnership(owner);
473   }
474 
475   /**
476    * Transfer remains to owner 
477    */
478   function getRemainCoins() onlyOwner public {
479       
480     var remains = MAX_CAP - coinSentToEther;
481     
482     Backer backer = backers[owner];
483     coin.transfer(owner, remains); // Transfer ERRLCoins right now 
484 
485     backer.coinSent = backer.coinSent.add(remains);
486 
487     coinSentToEther = coinSentToEther.add(remains);
488 
489     // Send events
490     LogCoinsEmited(this ,remains);
491     LogReceivedETH(owner, etherReceived); 
492   }
493 
494 
495   
496 
497 }