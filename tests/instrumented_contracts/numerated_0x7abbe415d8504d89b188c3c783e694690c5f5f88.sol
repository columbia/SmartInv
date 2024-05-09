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
180  *  GamePlayerCoin token contract. Implements
181  */
182 contract GamePlayerCoin is StandardToken, Ownable {
183   string public constant name = "GamePlayerCoin";
184   string public constant symbol = "GPC";
185   uint public constant decimals = 18;
186   // Constructor
187   function GamePlayerCoin() {
188       totalSupply = 100 * (10**6) * (10 ** decimals); // 100 million 
189       balances[msg.sender] = totalSupply; // Send all tokens to owner
190   }
191   /**
192    *  Burn away the specified amount of GamePlayerCoin tokens
193    */
194   function burn(uint _value) onlyOwner returns (bool) {
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     totalSupply = totalSupply.sub(_value);
197     Transfer(msg.sender, 0x0, _value);
198     return true;
199   }
200 }
201 /*
202   Crowdsale Smart Contract for the gameplayercoin.com project
203   This smart contract collects ETH, and in return emits GamePlayerCoin tokens to the backers
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
215     /* Minimum number of GamePlayerCoins to sell */
216     uint public constant MIN_CAP = 5 * (10**6) * (10 ** 18); // 10 million GamePlayerCoin , about 2500 ETH
217     /* Maximum number of GamePlayerCoins to sell */
218     uint public constant MAX_CAP = 70 * (10**6) * (10 ** 18); // 70 million GamePlayerCoin , about 35000 ETH
219     /* Minimum amount to invest */
220     uint public constant MIN_INVEST_ETHER = 100 finney;
221     /* Crowdsale period */
222     uint private constant CROWDSALE_PERIOD = 90 days;
223     /* Number of GamePlayerCoin per Ether */
224     uint public constant COIN_PER_ETHER = 2000 * (10 ** 18); // 2,000 GamePlayerCoin 
225     /*
226     * Variables
227     */
228     /* GamePlayercoin contract reference */
229     GamePlayerCoin public coin;
230     /* Multisig contract that will receive the Ether */
231     address public multisigEther;
232     /* Number of Ether received */
233     uint public etherReceived;
234     /* Number of GamePlayercoins sent to Ether contributors */
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
263     function Crowdsale(address _gamePlayerCoinAddress, address _to) {
264         coin = GamePlayerCoin(_gamePlayerCoinAddress);
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
287         uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of GamePlayerCoin to send
288         if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;    
289         Backer backer = backers[beneficiary];
290         coin.transfer(beneficiary, coinToSend); // Transfer Gameplayercoins right now 
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
301      *Compute the GamePlayercoin bonus according to the investment period
302      */
303     function bonus(uint amount) internal constant returns (uint) {
304         if (now < startTime.add(7 days)) return amount.add(amount.div(5));   // bonus 20%
305         if (now >= startTime.add(7 days) && now < startTime.add(14 days)) return amount.add(amount.div(10));   // bonus 10%
306         if (now >= startTime.add(14 days) && now < startTime.add(21 days)) return amount.add(amount.div(20));   // bonus 5%
307         return amount;
308     }
309     /*  
310      * Finalize the crowdsale, should be called after the refund period
311     */
312     function finalize() onlyOwner public {
313         if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
314             if (coinSentToEther == MAX_CAP) {
315             } else {
316                 throw;
317             }
318         }
319         if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
320         if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
321         
322         uint remains = coin.balanceOf(this);
323         if (remains > 0) { // Burn the rest of GamePlayercoins
324             if (!coin.burn(remains)) throw ;
325         }
326         crowdsaleClosed = true;
327     }
328     /*  
329     * Failsafe drain
330     */
331     function drain() onlyOwner {
332         if (!owner.send(this.balance)) throw;
333     }
334     /**
335      * Allow to change the team multisig address in the case of emergency.
336      */
337     function setMultisig(address addr) onlyOwner public {
338         if (addr == address(0)) throw;
339         multisigEther = addr;
340     }
341     /**
342      * Manually back GamePlayerCoins owner address.
343      */
344     function backGamePlayerCoinOwner() onlyOwner public {
345         coin.transferOwnership(owner);
346     }
347     /**
348      * Transfer remains to owner in case if impossible to do min invest
349      */
350     function getRemainCoins() onlyOwner public {
351         var remains = MAX_CAP - coinSentToEther;
352         uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
353         if(remains > minCoinsToSell) throw;
354         Backer backer = backers[owner];
355         coin.transfer(owner, remains); // Transfer GamePlayerCoins right now 
356         backer.coinSent = backer.coinSent.add(remains);
357         coinSentToEther = coinSentToEther.add(remains);
358         // Send events
359         LogCoinsEmited(this ,remains);
360         LogReceivedETH(owner, etherReceived); 
361     }
362     /* 
363      * When MIN_CAP is not reach:
364      * 1) backer call the "approve" function of the GamePlayerCoin token contract with the amount of all GamePlayerCoins they got in order to be refund
365      * 2) backer call the "refund" function of the Crowdsale contract with the same amount of GamePlayers
366      * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
367      */
368     function refund(uint _value) minCapNotReached public {
369         if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
370         coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
371         if (!coin.burn(_value)) throw ; // token sent for refund are burnt
372         uint ETHToSend = backers[msg.sender].weiReceived;
373         backers[msg.sender].weiReceived=0;
374         if (ETHToSend > 0) {
375             asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
376         }
377     }
378 }