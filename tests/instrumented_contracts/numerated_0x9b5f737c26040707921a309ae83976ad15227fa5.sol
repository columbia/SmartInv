1 pragma solidity ^0.4.11;
2 library SafeMath {
3   function mul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c >= a);
21     return c;
22   }
23   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
24     return a >= b ? a : b;
25   }
26   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a < b ? a : b;
28   }
29   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
30     return a >= b ? a : b;
31   }
32   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a < b ? a : b;
34   }
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract Ownable {
42     address public owner;
43     function Ownable() {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         if (msg.sender != owner) throw;
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 /*
57  * Pausable
58  * Abstract contract that allows children to implement an
59  * emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   bool public stopped;
63   modifier stopInEmergency {
64     if (stopped) {
65       throw;
66     }
67     _;
68   }
69   
70   modifier onlyInEmergency {
71     if (!stopped) {
72       throw;
73     }
74     _;
75   }
76   // called by the owner on emergency, triggers stopped state
77   function emergencyStop() external onlyOwner {
78     stopped = true;
79   }
80   // called by the owner on end of emergency, returns to normal state
81   function release() external onlyOwner onlyInEmergency {
82     stopped = false;
83   }
84 }
85 contract ERC20Basic {
86   uint public totalSupply;
87   function balanceOf(address who) constant returns (uint);
88   function transfer(address to, uint value);
89   event Transfer(address indexed from, address indexed to, uint value);
90 }
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) constant returns (uint);
93   function transferFrom(address from, address to, uint value);
94   function approve(address spender, uint value);
95   event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 /*
98  * PullPayment
99  * Base contract supporting async send for pull payments.
100  * Inherit from this contract and use asyncSend instead of send.
101  */
102 contract PullPayment {
103   using SafeMath for uint;
104   
105   mapping(address => uint) public payments;
106   event LogRefundETH(address to, uint value);
107   /**
108   *  Store sent amount as credit to be pulled, called by payer 
109   **/
110   function asyncSend(address dest, uint amount) internal {
111     payments[dest] = payments[dest].add(amount);
112   }
113   // withdraw accumulated balance, called by payee
114   function withdrawPayments() {
115     address payee = msg.sender;
116     uint payment = payments[payee];
117     
118     if (payment == 0) {
119       throw;
120     }
121     if (this.balance < payment) {
122       throw;
123     }
124     payments[payee] = 0;
125     if (!payee.send(payment)) {
126       throw;
127     }
128     LogRefundETH(payee,payment);
129   }
130 }
131 contract BasicToken is ERC20Basic {
132   
133   using SafeMath for uint;
134   
135   mapping(address => uint) balances;
136   
137   /*
138    * Fix for the ERC20 short address attack  
139   */
140   modifier onlyPayloadSize(uint size) {
141      if(msg.data.length < size + 4) {
142        throw;
143      }
144      _;
145   }
146   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150   }
151   function balanceOf(address _owner) constant returns (uint balance) {
152     return balances[_owner];
153   }
154 }
155 contract StandardToken is BasicToken, ERC20 {
156   mapping (address => mapping (address => uint)) allowed;
157   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
158     var _allowance = allowed[_from][msg.sender];
159     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160     // if (_value > _allowance) throw;
161     balances[_to] = balances[_to].add(_value);
162     balances[_from] = balances[_from].sub(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
165   }
166   function approve(address _spender, uint _value) {
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174   }
175   function allowance(address _owner, address _spender) constant returns (uint remaining) {
176     return allowed[_owner][_spender];
177   }
178 }
179 /**
180  *  OrenCoin token contract. Implements
181  */
182 contract OrenCoin is StandardToken, Ownable {
183   string public constant name = "OrenCoin";
184   string public constant symbol = "OREN";
185   uint public constant decimals = 8;
186   // Constructor
187   function OrenCoin() {
188       totalSupply = 40000000000000000;
189       balances[msg.sender] = totalSupply; // Send all tokens to owner
190   }
191   /**
192    *  Burn away the specified amount of OrenCoin tokens
193    */
194   function burn(uint _value) onlyOwner returns (bool) {
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     totalSupply = totalSupply.sub(_value);
197     Transfer(msg.sender, 0x0, _value);
198     return true;
199   }
200 }
201 /*
202   Crowdsale Smart Contract for the Orenplatform.com project
203   This smart contract collects ETH, and in return emits OrenCoin tokens to the backers
204 */
205 contract Crowdsale is Pausable, PullPayment {
206     
207     using SafeMath for uint;
208     struct Backer {
209         uint weiReceived; // Amount of Ether given
210         uint coinSent;
211     }
212     /*
213     * Constants
214     */
215     /* Minimum number of OrenCoin to sell */
216     uint public constant MIN_CAP = 42000000000000; // softcap
217     /* Maximum number of OrenCoin to sell */
218     uint public constant MAX_CAP = 40000000000000000; // 400,000,000 OrenCoins
219     /* Minimum amount to invest */
220     uint public constant MIN_INVEST_ETHER = 100 finney;
221     /* Crowdsale period */
222     uint private constant CROWDSALE_PERIOD = 15 days;
223     /* Number of OrenCoins per Ether */
224     uint public constant COIN_PER_ETHER = 300000000000; // 3,000 OrenCoins
225     /*
226     * Variables
227     */
228     /* OrenCoin contract reference */
229     OrenCoin public coin;
230     /* Multisig contract that will receive the Ether */
231     address public multisigEther;
232     /* Number of Ether received */
233     uint public etherReceived;
234     /* Number of OrenCoins sent to Ether contributors */
235     uint public coinSentToEther;
236     /* Crowdsale start time */
237     uint public startTime;
238     /* Crowdsale end time */
239     uint public endTime;
240     /* Is crowdsale still on going */
241     bool public crowdsaleClosed;
242     /* Backers Ether indexed by their Ethereum address */
243     mapping(address => Backer) public backers;
244     /*
245     * Modifiers
246     */
247     modifier minCapNotReached() {
248         if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
249         _;
250     }
251     modifier respectTimeFrame() {
252         if ((now < startTime) || (now > endTime )) throw;
253         _;
254     }
255     /*
256      * Event
257     */
258     event LogReceivedETH(address addr, uint value);
259     event LogCoinsEmited(address indexed from, uint amount);
260     /*
261      * Constructor
262     */
263     function Crowdsale(address _OrenCoinAddress, address _to) {
264         coin = OrenCoin(_OrenCoinAddress);
265         multisigEther = _to;
266     }
267     /* 
268      * The fallback function corresponds to a donation in ETH
269      */
270     function() stopInEmergency respectTimeFrame payable {
271         receiveETH(msg.sender);
272     }
273     /* 
274      * To call to start the crowdsale
275      */
276     function start() onlyOwner {
277         if (startTime != 0) throw; // Crowdsale was already started
278         startTime = now ;            
279         endTime =  now + CROWDSALE_PERIOD;    
280     }
281     /*
282      *  Receives a donation in Ether
283     */
284     function receiveETH(address beneficiary) internal {
285         if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
286         
287         uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of OrenCoin to send
288         if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;    
289         Backer backer = backers[beneficiary];
290         coin.transfer(beneficiary, coinToSend); // Transfer OrenCoins right now 
291         backer.coinSent = backer.coinSent.add(coinToSend);
292         backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
293         etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
294         coinSentToEther = coinSentToEther.add(coinToSend);
295         // Send events
296         LogCoinsEmited(msg.sender ,coinToSend);
297         LogReceivedETH(beneficiary, etherReceived); 
298     }
299     
300     /*
301      *Compute the OrenCoin bonus according to the investment period
302      */
303     function bonus(uint amount) internal constant returns (uint) {
304         if (coinSentToEther < 20000000000000000) return amount.add(amount.mul(10).div(25));   // bonus 40%
305         return amount.add(amount.mul(100).div(333)); //bonus 30%
306     }
307     /*  
308      * Finalize the crowdsale, should be called after the refund period
309     */
310     function finalize() onlyOwner public {
311         if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
312             if (coinSentToEther == MAX_CAP) {
313             } else {
314                 throw;
315             }
316         }
317         if (coinSentToEther < MIN_CAP && now < endTime + 5 days) throw; // If MIN_CAP is not reached donors have 5days to get refund before we can finalise
318         
319 
320         if (!multisigEther.send(this.balance)) {
321             throw;
322         }
323         
324         
325         uint remains = coin.balanceOf(this);
326         if (remains > 0) { // Burn the rest of OrenCoins
327             if (!coin.burn(remains)) throw ;
328         }
329         crowdsaleClosed = true;
330     }
331     /*  
332     * Failsafe drain
333     */
334     function drain() onlyOwner {
335         if (!owner.send(this.balance)) throw;
336     }
337     /**
338      * Allow to change the team multisig address in the case of emergency.
339      */
340     function setMultisig(address addr) onlyOwner public {
341         if (addr == address(0)) throw;
342         multisigEther = addr;
343     }
344     /**
345      * Manually back OrenCoin owner address.
346      */
347     function backOrenCoinOwner() onlyOwner public {
348         coin.transferOwnership(owner);
349     }
350     /**
351      * Transfer remains to owner in case if impossible to do min invest
352      */
353     function getRemainCoins() onlyOwner public {
354         var remains = MAX_CAP - coinSentToEther;
355         uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
356         if(remains > minCoinsToSell) throw;
357         Backer backer = backers[owner];
358         coin.transfer(owner, remains); // Transfer OrenCoins right now 
359         backer.coinSent = backer.coinSent.add(remains);
360         coinSentToEther = coinSentToEther.add(remains);
361         // Send events
362         LogCoinsEmited(this ,remains);
363         LogReceivedETH(owner, etherReceived); 
364     }
365     /* 
366      * When MIN_CAP is not reach:
367      * 1) backer call the "approve" function of the OrenCoin token contract with the amount of all OrenCoins they got in order to be refund
368      * 2) backer call the "refund" function of the Crowdsale contract with the same amount of OrenCoins
369      * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
370      */
371     function refund(uint _value) minCapNotReached public {
372         
373         if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
374         coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
375         if (!coin.burn(_value)) throw ; // token sent for refund are burnt
376         uint ETHToSend = backers[msg.sender].weiReceived;
377         backers[msg.sender].weiReceived=0;
378         if (ETHToSend > 0) {
379             asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
380         }
381     }
382 }