1 pragma solidity ^0.4.11;
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
42 contract PullPayment {
43 
44   using SafeMath for uint;
45   
46   mapping(address => uint) public payments;
47 
48   event LogRefundETH(address to, uint value);
49 
50 
51   /**
52   *  Store sent amount as credit to be pulled, called by payer 
53   **/
54   function asyncSend(address dest, uint amount) internal {
55     payments[dest] = payments[dest].add(amount);
56   }
57 
58   // withdraw accumulated balance, called by payee
59   function withdrawPayments() {
60     address payee = msg.sender;
61     uint payment = payments[payee];
62     
63     if (payment == 0) {
64       throw;
65     }
66 
67     if (this.balance < payment) {
68       throw;
69     }
70 
71     payments[payee] = 0;
72 
73     if (!payee.send(payment)) {
74       throw;
75     }
76     LogRefundETH(payee,payment);
77   }
78 }
79 contract ERC20Basic {
80   uint public totalSupply;
81   function balanceOf(address who) constant returns (uint);
82   function transfer(address to, uint value);
83   event Transfer(address indexed from, address indexed to, uint value);
84 }
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) constant returns (uint);
87   function transferFrom(address from, address to, uint value);
88   function approve(address spender, uint value);
89   event Approval(address indexed owner, address indexed spender, uint value);
90 }
91 contract Migrations {
92   address public owner;
93   uint public last_completed_migration;
94 
95   modifier restricted() {
96     if (msg.sender == owner) _;
97   }
98 
99   function Migrations() {
100     owner = msg.sender;
101   }
102 
103   function setCompleted(uint completed) restricted {
104     last_completed_migration = completed;
105   }
106 
107   function upgrade(address new_address) restricted {
108     Migrations upgraded = Migrations(new_address);
109     upgraded.setCompleted(last_completed_migration);
110   }
111 }
112 contract Ownable {
113     address public owner;
114 
115     function Ownable() {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner {
120         if (msg.sender != owner) throw;
121         _;
122     }
123 
124     function transferOwnership(address newOwner) onlyOwner {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129 }
130 contract Pausable is Ownable {
131   bool public stopped;
132 
133   modifier stopInEmergency {
134     if (stopped) {
135       throw;
136     }
137     _;
138   }
139   
140   modifier onlyInEmergency {
141     if (!stopped) {
142       throw;
143     }
144     _;
145   }
146 
147   // called by the owner on emergency, triggers stopped state
148   function emergencyStop() external onlyOwner {
149     stopped = true;
150   }
151 
152   // called by the owner on end of emergency, returns to normal state
153   function release() external onlyOwner onlyInEmergency {
154     stopped = false;
155   }
156 
157 }
158 contract BasicToken is ERC20Basic {
159   
160   using SafeMath for uint;
161   
162   mapping(address => uint) balances;
163   
164   /*
165    * Fix for the ERC20 short address attack  
166   */
167   modifier onlyPayloadSize(uint size) {
168      if(msg.data.length < size + 4) {
169        throw;
170      }
171      _;
172   }
173 
174   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     Transfer(msg.sender, _to, _value);
178   }
179 
180   function balanceOf(address _owner) constant returns (uint balance) {
181     return balances[_owner];
182   }
183 }
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
211 /**
212  *  Tix token contract. Implements
213  */
214 contract Tix is StandardToken, Ownable {
215   string public constant name = "Tettix";
216   string public constant symbol = "TIX";
217   uint public constant decimals = 8;
218 
219 
220   // Constructor
221   function Tix() {
222       totalSupply = 100000000000000000;
223       balances[msg.sender] = totalSupply; // Send all tokens to owner
224   }
225 
226   /**
227    *  Burn away the specified amount of SkinCoin tokens
228    */
229   function burn(uint _value) onlyOwner returns (bool) {
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     totalSupply = totalSupply.sub(_value);
232     Transfer(msg.sender, 0x0, _value);
233     return true;
234   }
235 
236 }
237 /*
238   Crowdsale Smart Contract for the Tettix.io project
239   This smart contract collects ETH, and in return emits TIX tokens to the backers
240 */
241 contract Crowdsale is Pausable, PullPayment {
242     
243     using SafeMath for uint;
244 
245     struct Backer {
246         uint weiReceived; // Amount of Ether given
247         uint coinSent;
248     }
249 
250     /*
251     * Constants
252     */
253     /* Minimum number of TIX to sell */
254     uint public constant MIN_CAP = 1000000000000; 
255     /* Maximum number of TIX to sell */
256     uint public constant MAX_CAP = 40000000000000000;
257     /* Minimum amount to invest */
258     uint public constant MIN_INVEST_ETHER = 10 finney;
259     /* Crowdsale period */
260     uint private constant CROWDSALE_PERIOD = 21 days;
261     /* Number of TIX per Ether */
262     uint public constant COIN_PER_ETHER = 1000000000000;
263 
264 
265     /*
266     * Variables
267     */
268     /* TIX contract reference */
269     Tix public coin;
270     /* Multisig contract that will receive the Ether */
271     address public multisigEther;
272     /* Number of Ether received */
273     uint public etherReceived;
274     /* Number of TIX sent to Ether contributors */
275     uint public coinSentToEther;
276     /* Crowdsale start time */
277     uint public startTime;
278     /* Crowdsale end time */
279     uint public endTime;
280     /* Is crowdsale still on going */
281     bool public crowdsaleClosed;
282 
283     /* Backers Ether indexed by their Ethereum address */
284     mapping(address => Backer) public backers;
285 
286 
287     /*
288     * Modifiers
289     */
290     modifier minCapNotReached() {
291         if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
292         _;
293     }
294 
295     modifier respectTimeFrame() {
296         if ((now < startTime) || (now > endTime )) throw;
297         _;
298     }
299 
300     /*
301      * Event
302     */
303     event LogReceivedETH(address addr, uint value);
304     event LogCoinsEmited(address indexed from, uint amount);
305 
306     /*
307      * Constructor
308     */
309     function Crowdsale(address _tixAddress, address _to) {
310         coin = Tix(_tixAddress);
311         multisigEther = _to;
312     }
313 
314     /* 
315      * The fallback function corresponds to a donation in ETH
316      */
317     function() stopInEmergency respectTimeFrame payable {
318         receiveETH(msg.sender);
319     }
320 
321     /* 
322      * To call to start the crowdsale
323      */
324     function start() onlyOwner {
325         if (startTime != 0) throw; // Crowdsale was already started
326 
327         startTime = now ;            
328         endTime =  now + CROWDSALE_PERIOD;    
329     }
330 
331     /*
332      *  Receives a donation in Ether
333     */
334     function receiveETH(address beneficiary) internal {
335         if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
336         
337         uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of TIX to send
338         if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;   
339 
340         Backer backer = backers[beneficiary];
341         coin.transfer(beneficiary, coinToSend); // Transfer TIX right now 
342 
343         backer.coinSent = backer.coinSent.add(coinToSend);
344         backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
345 
346         etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
347         coinSentToEther = coinSentToEther.add(coinToSend);
348 
349         // Send events
350         LogCoinsEmited(msg.sender ,coinToSend);
351         LogReceivedETH(beneficiary, etherReceived); 
352     }
353     
354 
355     /*
356      *Compute the TIX bonus according to the investment period
357      */
358     function bonus(uint amount) internal constant returns (uint) {
359         if (now < startTime.add(5 days)) return amount.add(amount.div(5));   // bonus 20%
360         return amount;
361     }
362 
363     /*  
364      * Finalize the crowdsale, should be called after the refund period
365     */
366     function finalize() onlyOwner public {
367 
368         if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
369             if (coinSentToEther == MAX_CAP) {
370             } else {
371                 throw;
372             }
373         }
374 
375         if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
376 
377         if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
378         
379         uint remains = coin.balanceOf(this);
380         if (remains > 0) { // Burn the rest of TIX
381             if (!coin.burn(remains)) throw ;
382         }
383         crowdsaleClosed = true;
384     }
385 
386     /*  
387     * Failsafe drain
388     */
389     function drain() onlyOwner {
390         if (!owner.send(this.balance)) throw;
391     }
392 
393     /**
394      * Allow to change the team multisig address in the case of emergency.
395      */
396     function setMultisig(address addr) onlyOwner public {
397         if (addr == address(0)) throw;
398         multisigEther = addr;
399     }
400 
401     /**
402      * Manually back TIX owner address.
403      */
404     function backTixOwner() onlyOwner public {
405         coin.transferOwnership(owner);
406     }
407 
408     /**
409      * Transfer remains to owner in case if impossible to do min invest
410      */
411     function getRemainCoins() onlyOwner public {
412         var remains = MAX_CAP - coinSentToEther;
413         uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
414 
415         if(remains > minCoinsToSell) throw;
416 
417         Backer backer = backers[owner];
418         coin.transfer(owner, remains); // Transfer TIX right now 
419 
420         backer.coinSent = backer.coinSent.add(remains);
421 
422         coinSentToEther = coinSentToEther.add(remains);
423 
424         // Send events
425         LogCoinsEmited(this ,remains);
426         LogReceivedETH(owner, etherReceived); 
427     }
428 
429 
430     /* 
431      * When MIN_CAP is not reach:
432      * 1) backer call the "approve" function of the TIX token contract with the amount of all TIXs they got in order to be refund
433      * 2) backer call the "refund" function of the Crowdsale contract with the same amount of TIX
434      * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
435      */
436     function refund(uint _value) minCapNotReached public {
437         
438         if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
439 
440         coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
441 
442         if (!coin.burn(_value)) throw ; // token sent for refund are burnt
443 
444         uint ETHToSend = backers[msg.sender].weiReceived;
445         backers[msg.sender].weiReceived=0;
446 
447         if (ETHToSend > 0) {
448             asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
449         }
450     }
451 
452 }