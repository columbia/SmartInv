1 pragma solidity ^0.4.0;
2 
3 interface Hash {
4    
5     function get() public returns (bytes32); 
6 
7 }
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 
40 contract StandardToken {
41 
42     using SafeMath for uint256;
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 
47     uint256 public totalSupply;
48     mapping (address => mapping (address => uint256)) allowed;
49     mapping(address => uint256) balances;
50 
51     /**
52     * @dev transfer token for a specified address
53     * @param _to The address to transfer to.
54     * @param _value The amount to be transferred.
55     */
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58 
59         // SafeMath.sub will throw if there is not enough balance.
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     /**
67     * @dev Gets the balance of the specified address.
68     * @param _owner The address to query the the balance of.
69     * @return An uint256 representing the amount owned by the passed address.
70     */
71     function balanceOf(address _owner) public constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75 
76     /**
77      * @dev Transfer tokens from one address to another
78      * @param _from address The address which you want to send tokens from
79      * @param _to address The address which you want to transfer to
80      * @param _value uint256 the amount of tokens to be transferred
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83         require(_to != address(0));
84 
85         uint256 _allowance = allowed[_from][msg.sender];
86 
87         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
88         // require (_value <= _allowance);
89 
90         balances[_from] = balances[_from].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         allowed[_from][msg.sender] = _allowance.sub(_value);
93         Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99      *
100      * Beware that changing an allowance with this method brings the risk that someone may use both the old
101      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
102      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
103      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104      * @param _spender The address which will spend the funds.
105      * @param _value The amount of tokens to be spent.
106      */
107     function approve(address _spender, uint256 _value) public returns (bool) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /**
114      * @dev Function to check the amount of tokens that an owner allowed to a spender.
115      * @param _owner address The address which owns the funds.
116      * @param _spender address The address which will spend the funds.
117      * @return A uint256 specifying the amount of tokens still available for the spender.
118      */
119     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123     /**
124      * approve should be called when allowed[_spender] == 0. To increment
125      * allowed value is better to use this function to avoid 2 calls (and wait until
126      * the first transaction is mined)
127      * From MonolithDAO Token.sol
128      */
129     /*function increaseApproval (address _spender, uint _addedValue)
130     returns (bool success) {
131         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133         return true;
134     }
135 
136     function decreaseApproval (address _spender, uint _subtractedValue)
137     returns (bool success) {
138         uint oldValue = allowed[msg.sender][_spender];
139         if (_subtractedValue > oldValue) {
140             allowed[msg.sender][_spender] = 0;
141         } else {
142             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143         }
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }*/
147 
148 }
149 
150 
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     address public owner;
159 
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163 
164     /**
165      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166      * account.
167      */
168     function Ownable() public {
169         owner = msg.sender;
170     }
171 
172 
173     /**
174      * @dev Throws if called by any account other than the owner.
175      */
176     modifier onlyOwner() {
177         require(msg.sender == owner);
178         _;
179     }
180 
181 
182     /**
183      * @dev Allows the current owner to transfer control of the contract to a newOwner.
184      * @param newOwner The address to transfer ownership to.
185      */
186     function transferOwnership(address newOwner) onlyOwner public {
187         require(newOwner != address(0));
188         OwnershipTransferred(owner, newOwner);
189         owner = newOwner;
190     }
191 
192 }
193 
194 contract Lotery is Ownable {
195 
196   //event when gamer is buying a new ticket
197   event TicketSelling(uint periodNumber, address indexed from, bytes32 hash, uint when);
198 
199   //event when period finished
200   event PeriodFinished(uint periodNumber, address indexed winnerAddr, uint reward, bytes32 winnerHash, uint when);
201 
202   //event when any funds transferred
203   event TransferBenefit(address indexed to, uint value);
204 
205   event JackPot(uint periodNumber, address winnerAddr, bytes32 winnerHash, uint value, uint when);
206 
207 
208 //current period of the game
209   uint public currentPeriod;
210 
211   //if maxTicketAmount is not rised and maxPeriodDuration from period start is gone everyone can finish current round
212   uint public maxPeriodDuration;
213 
214   uint public maxTicketAmount;
215 
216   //ticket price in this contract
217   uint public ticketPrice;
218 
219   //part for owner
220   uint public benefitPercents;
221 
222   //funds for owner
223   uint public benefitFunds;
224 
225   //jackPot percents
226   uint public jackPotPercents;
227 
228   uint public jackPotFunds;
229 
230   bytes32 public jackPotBestHash;
231 
232 
233   //base game hash from other contract Hash
234   bytes32 private baseHash;
235 
236   Hash private hashGenerator;
237 
238   //period struct
239   struct period {
240   uint number;
241   uint startDate;
242   bytes32 winnerHash;
243   address winnerAddress;
244   uint raised;
245   uint ticketAmount;
246   bool finished;
247   uint reward;
248   }
249 
250   //ticket struct
251   struct ticket {
252   uint number;
253   address addr;
254   bytes32 hash;
255   }
256 
257 
258   //ticket store
259   mapping (uint => mapping (uint => ticket)) public tickets;
260 
261   //periods store
262   mapping (uint => period) public periods;
263 
264 
265   function Lotery(uint _maxPeriodDuration, uint _ticketPrice, uint _benefitPercents, uint _maxTicketAmount, address _hashAddr, uint _jackPotPercents) public {
266 
267     require(_maxPeriodDuration > 0 && _ticketPrice > 0 && _benefitPercents > 0 && _benefitPercents < 50 && _maxTicketAmount > 0 && _jackPotPercents > 0 && _jackPotPercents < 50);
268     //set data in constructor
269     maxPeriodDuration = _maxPeriodDuration;
270     ticketPrice = _ticketPrice;
271     benefitPercents = _benefitPercents;
272     maxTicketAmount = _maxTicketAmount;
273     jackPotPercents = _jackPotPercents;
274 
275     //get initial hash
276     hashGenerator = Hash(_hashAddr);
277     baseHash = hashGenerator.get();
278 
279     //start initial period
280     periods[currentPeriod].number = currentPeriod;
281     periods[currentPeriod].startDate = now;
282 
283 
284   }
285 
286 
287 
288   //start new period
289   function startNewPeriod() private {
290     //if prev period finished
291     require(periods[currentPeriod].finished);
292     //init new period
293     currentPeriod++;
294     periods[currentPeriod].number = currentPeriod;
295     periods[currentPeriod].startDate = now;
296 
297   }
298 
299 
300 
301 
302 
303   //buy ticket with specified round and passing string data
304   function buyTicket(uint periodNumber, string data) payable public {
305 
306     //only with ticket price!
307     require(msg.value == ticketPrice);
308     //only if current ticketAmount < maxTicketAmount
309     require(periods[periodNumber].ticketAmount < maxTicketAmount);
310     //roundNumber is currentRound
311     require(periodNumber == currentPeriod);
312 
313     processTicketBuying(data, msg.value, msg.sender);
314 
315   }
316 
317 
318   //buy ticket with msg.data and currentRound when transaction happened
319   function() payable public {
320 
321     //only with ticket price!
322     require(msg.value == ticketPrice);
323     //only if current ticketAmount < maxTicketAmount
324     require(periods[currentPeriod].ticketAmount < maxTicketAmount);
325 
326 
327     processTicketBuying(string(msg.data), msg.value, msg.sender);
328 
329 
330   }
331 
332   function processTicketBuying(string data, uint value, address sender) private {
333 
334 
335     //MAIN SECRET!
336     //calc ticket hash from baseHash and user data
337     //nobody knows baseHash
338     bytes32 hash = sha256(data, baseHash);
339 
340     //update base hash for next tickets
341     baseHash = sha256(hash, baseHash);
342 
343     //set winner if this is a best hash in round
344     if (periods[currentPeriod].ticketAmount == 0 || (hash < periods[currentPeriod].winnerHash)) {
345       periods[currentPeriod].winnerHash = hash;
346       periods[currentPeriod].winnerAddress = sender;
347     }
348 
349     //update tickets store
350     tickets[currentPeriod][periods[currentPeriod].ticketAmount].number = periods[currentPeriod].ticketAmount;
351     tickets[currentPeriod][periods[currentPeriod].ticketAmount].addr = sender;
352     tickets[currentPeriod][periods[currentPeriod].ticketAmount].hash = hash;
353 
354 
355     //update periods store
356     periods[currentPeriod].ticketAmount++;
357     periods[currentPeriod].raised += value;
358 
359     //call events
360     TicketSelling(currentPeriod, sender, hash, now);
361 
362     //automatically finish and start new round if max ticket amount is raised
363     if (periods[currentPeriod].ticketAmount >= maxTicketAmount) {
364       finishRound();
365     }
366 
367   }
368 
369 
370   //finish round
371   function finishRound() private {
372 
373     //only if not finished yet
374     require(!periods[currentPeriod].finished);
375     //only if ticketAmount >= maxTicketAmount
376     require(periods[currentPeriod].ticketAmount >= maxTicketAmount);
377 
378 
379     //calc reward for current winner with minus %
380 
381     uint fee = ((periods[currentPeriod].raised * benefitPercents) / 100);
382     uint jack = ((periods[currentPeriod].raised * jackPotPercents) / 100);
383 
384 
385     uint winnerReward = periods[currentPeriod].raised - fee - jack;
386 
387     //calc owner benefit
388     benefitFunds += periods[currentPeriod].raised - winnerReward;
389 
390 
391     //if first time
392     if (jackPotBestHash == 0x0) {
393       jackPotBestHash = periods[currentPeriod].winnerHash;
394     }
395     //all other times
396     if (periods[currentPeriod].winnerHash < jackPotBestHash) {
397 
398       jackPotBestHash = periods[currentPeriod].winnerHash;
399 
400 
401       if (jackPotFunds > 0) {
402         winnerReward += jackPotFunds;
403         JackPot(currentPeriod, periods[currentPeriod].winnerAddress, periods[currentPeriod].winnerHash, jackPotFunds, now);
404 
405       }
406 
407       jackPotFunds = 0;
408 
409     }
410 
411     //move jack to next round
412     jackPotFunds += jack;
413 
414     //calc expected balance
415     uint plannedBalance = this.balance - winnerReward;
416 
417     //send ether to winner
418     periods[currentPeriod].winnerAddress.transfer(winnerReward);
419 
420     //update period data
421     periods[currentPeriod].reward = winnerReward;
422     periods[currentPeriod].finished = true;
423 
424     //call events
425     PeriodFinished(currentPeriod, periods[currentPeriod].winnerAddress, winnerReward, periods[currentPeriod].winnerHash, now);
426 
427     //automatically start new period
428     startNewPeriod();
429 
430     //check balance
431     assert(this.balance == plannedBalance);
432   }
433 
434   //benefit for owner
435   function benefit() public onlyOwner {
436     require(benefitFunds > 0);
437 
438     uint plannedBalance = this.balance - benefitFunds;
439     owner.transfer(benefitFunds);
440     benefitFunds = 0;
441 
442     TransferBenefit(owner, benefitFunds);
443     assert(this.balance == plannedBalance);
444   }
445 
446   //manually finish and restart round
447   function finishRoundAndStartNew() public {
448     //only if round has tickets
449     require(periods[currentPeriod].ticketAmount > 0);
450     //only if date is expired
451     require(periods[currentPeriod].startDate + maxPeriodDuration < now);
452     //restart round
453     finishRound();
454   }
455 
456 
457 }