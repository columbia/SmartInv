1 /*
2  * VISTA FINTECH  
3  * SMART CONTRACT FOR CROWNSALE http://www.vistafin.com
4  * Edit by Ray Indinor
5  * Approved by Jacky Hsieh
6  */
7 
8 pragma solidity ^0.4.11;
9 library SafeMath {
10 	function mul(uint a, uint b) internal returns (uint) {
11 		uint c = a * b;
12 		assert(a == 0 || c / a == b);
13 		return c;
14 	}
15 	
16 	function div(uint a, uint b) internal returns (uint) {
17 		assert(b > 0);
18 		uint c = a / b;
19 		assert(a == b * c + a % b);
20 		return c;
21 	}
22 	
23 	function sub(uint a, uint b) internal returns (uint) {
24 		assert(b <= a);
25 		return a - b;
26 	}
27 	
28 	function add(uint a, uint b) internal returns (uint) {
29 		uint c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 	
34 	function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35 		return a >= b ? a : b;
36 	}
37 	
38 	function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39 		return a < b ? a : b;
40 	}
41 	
42 	function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43 		return a >= b ? a : b;
44 	}
45 	
46 	function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47 		return a < b ? a : b;
48 	}
49 	
50 	function assert(bool assertion) internal {
51 		if (!assertion) {
52 			throw;
53     }
54   }
55 }
56 
57 
58 contract Ownable {
59     address public owner;
60     function Ownable() {
61         owner = msg.sender;
62     }
63 	
64     modifier onlyOwner {
65         if (msg.sender != owner) throw;
66         _;
67     }
68 	
69     function transferOwnership(address newOwner) onlyOwner {
70         if (newOwner != address(0)) {
71             owner = newOwner;
72         }
73     }
74 }
75 
76 
77 
78 /*
79  * Pausable Function
80  * Abstract contract that allows children to implement an emergency stop function. 
81  */
82 contract Pausable is Ownable {
83 	bool public stopped = false;
84 	modifier stopInEmergency {
85 		if (stopped) {
86 			throw;
87 		}
88 		_;
89 	}
90   
91 	modifier onlyInEmergency {
92 		if (!stopped) {
93 			throw;
94 		}
95 		_;
96 	}
97 	
98 /*
99  * EmergencyStop Function
100  * called by the owner on emergency, triggers stopped state 
101  */
102 function emergencyStop() external onlyOwner {
103     stopped = true;
104 	}
105 
106 	
107 /*
108  * Release EmergencyState Function
109  * called by the owner on end of emergency, returns to normal state
110  */  
111 
112 function release() external onlyOwner onlyInEmergency {
113     stopped = false;
114 	}
115 }
116 
117 /*
118  * ERC20Basic class
119  * Abstract contract that allows children to implement ERC20basic persistent data in state variables.
120  */ 	
121 contract ERC20Basic {
122   uint public totalSupply;
123   function balanceOf(address who) constant returns (uint);
124   function transfer(address to, uint value);
125   event Transfer(address indexed from, address indexed to, uint value);
126 }
127 
128 
129 /*
130  * ERC20 class
131  * Abstract contract that allows children to implement ERC20 persistent data in state variables.
132  */ 
133 contract ERC20 is ERC20Basic {
134 	function allowance(address owner, address spender) constant returns (uint);
135 	function transferFrom(address from, address to, uint value);
136 	function approve(address spender, uint value);
137 	event Approval(address indexed owner, address indexed spender, uint value);
138 }
139 
140 
141 
142 /*
143  * BasicToken class
144  * Abstract contract that allows children to implement BasicToken functions and  persistent data in state variables.
145  */
146 
147 contract BasicToken is ERC20Basic {
148   
149 	using SafeMath for uint;
150   
151 	mapping(address => uint) balances;
152   
153 	/*
154 	* Fix for the ERC20 short address attack  
155 	*/
156 	modifier onlyPayloadSize(uint size) {
157 		if(msg.data.length < size + 4) {
158 		throw;
159 		}
160 		_;
161 	}
162 	
163 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
164 		balances[msg.sender] = balances[msg.sender].sub(_value);
165 		balances[_to] = balances[_to].add(_value);
166 		Transfer(msg.sender, _to, _value);
167 	}
168 	
169 	function balanceOf(address _owner) constant returns (uint balance) {
170 		return balances[_owner];
171 	}
172 }
173 
174 
175 
176 /*
177  * StandardToken class
178  * Abstract contract that allows children to implement StandToken functions and  persistent data in state variables.
179  */
180 contract StandardToken is BasicToken, ERC20 {
181 	mapping (address => mapping (address => uint)) allowed;
182 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
183     var _allowance = allowed[_from][msg.sender];
184     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
185     // if (_value > _allowance) throw;
186     balances[_to] = balances[_to].add(_value);
187     balances[_from] = balances[_from].sub(_value);
188     allowed[_from][msg.sender] = _allowance.sub(_value);
189     Transfer(_from, _to, _value);
190   }
191 	function approve(address _spender, uint _value) {
192 		// To change the approve amount you first have to reduce the addresses`
193 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
194 		//  already 0 to mitigate the race condition described here:
195 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
197 		allowed[msg.sender][_spender] = _value;
198 		Approval(msg.sender, _spender, _value);
199 	}
200 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
201 		return allowed[_owner][_spender];
202 	}
203 }
204 
205 
206 
207 /**
208  * ================================================================================
209  * VISTA token smart contract. Implements
210  * VISTACOIN class
211  */
212 contract VISTAcoin is StandardToken, Ownable {
213 	string public constant name = "VISTAcoin";
214 	string public constant symbol = "VTA";
215 	uint public constant decimals = 0;
216 	// Constructor
217 	function VISTAcoin() {
218 		totalSupply = 50000000;
219 		balances[msg.sender] = totalSupply; // Send all tokens to owner
220 	}
221 }
222 
223 
224 
225 
226 
227 
228 /**
229  * Crowdsale Smart Contract for VISTA FINTECH
230  * This smart contract collects ETH, and in return emits VISTAcoin tokens to the backers
231  */
232 contract VISTACrowdSaleP1 is Pausable {
233     
234     using SafeMath for uint;
235     struct Backer {
236         uint weiReceived; // Amount of Ether given
237         uint coinSent;
238     }
239 	
240     /*
241     * Constants
242     */
243     /* Minimum number of VISTAcoin to sell */
244     uint public constant MIN_CAP = 1; // 1 VISTAcoins
245     /* Maximum number of VISTAcoin to sell */
246     uint public constant MAX_CAP = 5000000; // 5000 VISTAcoins
247     /* Minimum amount to invest */
248     uint public constant MIN_INVEST_ETHER = 500 finney;
249     /* Crowdsale period */
250     uint private constant CROWDSALE_PERIOD = 15 days;
251     /* Number of VISTAcoins per Ether */
252     uint public constant COIN_PER_ETHER = 350; // 1 VISTAcoins/eth
253 	
254 	
255 	
256 	
257     /*
258     * Variables
259     */
260     /* VISTAcoin contract reference */
261     VISTAcoin public coin;
262     /* Multisig contract that will receive the Ether */
263     address public multisigEther;
264     /* Number of Ether received */
265     uint public etherReceived;
266     /* Number of VISTAcoins sent to Ether contributors */
267     uint public coinSentToEther;
268     /* Crowdsale start time */
269     uint public startTime;
270     /* Crowdsale end time */
271     uint public endTime;
272     /* Is crowdsale still on going */
273     bool public crowdsaleClosed = false;
274     /* Backers Ether indexed by their Ethereum address */
275     mapping(address => Backer) public backers;
276 	
277 	
278 	
279 	
280     /*
281     * Modifiers
282     */
283     modifier minCapNotReached() {
284         if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
285         _;
286     }
287     modifier respectTimeFrame() {
288         if ((now < startTime) || (now > endTime )) throw;
289         _;
290     }
291 	
292 	
293     /*
294      * Event
295     */
296     event LogReceivedETH(address addr, uint value);
297     event LogCoinsEmited(address indexed from, uint amount);
298 	
299 	
300     /*
301      * Constructor
302     */
303     function VISTACrowdSaleP1(address _VISTAcoinAddress, address _to) {
304         coin = VISTAcoin(_VISTAcoinAddress);
305         multisigEther = _to;
306     }
307 	
308 	
309     /* 
310      * The fallback function corresponds to a donation in ETH
311      */
312     function() stopInEmergency respectTimeFrame payable {
313         if (crowdsaleClosed) throw; //Crowdsale was closed.
314 		receiveETH(msg.sender);
315     }
316 	
317 	
318     /* 
319      * To call to start the crowdsale
320      */
321     function start() onlyOwner {
322         if (startTime != 0) throw; // Crowdsale was already started
323         startTime = now ;            
324         endTime =  now + CROWDSALE_PERIOD;    
325     }
326 	
327 	
328     /*
329      *  Receives a donation in Ether
330     */
331     function receiveETH(address beneficiary) internal {
332         if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold        
333         uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of VISTAcoin to send
334         if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;    
335         Backer backer = backers[beneficiary];
336         coin.transfer(beneficiary, coinToSend); // Transfer VISTAcoins right now
337 		if (!multisigEther.send(this.balance)) throw; //Transfer ETH to VISTA ECC		
338         backer.coinSent = backer.coinSent.add(coinToSend);
339         backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
340         etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
341         coinSentToEther = coinSentToEther.add(coinToSend);
342         // Send events
343         LogCoinsEmited(msg.sender ,coinToSend);
344         LogReceivedETH(beneficiary, etherReceived); 
345     }
346     
347     /*
348      *Compute the VISTAcoin BONUS according to the investment period
349      */
350     function bonus(uint amount) internal constant returns (uint) {
351         return amount.add(amount.div(5));   // bonus 20%
352     }
353 	
354 	
355 	
356 	
357     /*  
358      * FINALIZE the crowdsale, should be called after ico period
359     */
360     function finalize() onlyOwner public {
361         if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
362             if (coinSentToEther == MAX_CAP) {
363             } else {
364                 throw;
365             }
366         }
367         if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
368 		getRemainCoins();
369         crowdsaleClosed = true;
370     }
371 	
372 	
373     /*  
374     * Failsafe drain
375     */
376     function drain() onlyOwner {
377         if (!owner.send(this.balance)) throw;
378     }
379 	
380 	
381     /**
382      * Allow to change the team multisig address in the case of emergency.
383      */
384     function setMultisig(address addr) onlyOwner public {
385         if (addr == address(0)) throw;
386         multisigEther = addr;
387     }
388 	
389 	
390     /**
391      * Manually back VISTAcoin owner address.
392      */
393     function backVISTAcoinOwner() onlyOwner public {
394         coin.transferOwnership(owner);
395     }
396 	
397 	
398     /**
399      * Get reamin coins back to owner
400      */
401     function getRemainCoins() onlyOwner public {
402         var remains = MAX_CAP - coinSentToEther;
403         Backer backer = backers[owner];
404         coin.transfer(owner, remains); // Transfer VISTAcoins right now 
405         backer.coinSent = backer.coinSent.add(remains);
406         coinSentToEther = coinSentToEther.add(remains);
407         // Send events
408         LogCoinsEmited(this ,remains);
409         LogReceivedETH(owner, etherReceived); 
410     }
411 }