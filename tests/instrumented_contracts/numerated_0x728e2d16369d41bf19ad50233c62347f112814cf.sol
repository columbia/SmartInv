1 contract ERC20Basic {
2   uint public totalSupply;
3   function balanceOf(address who) constant returns (uint);
4   function transfer(address to, uint value);
5   event Transfer(address indexed from, address indexed to, uint value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) constant returns (uint);
10   function transferFrom(address from, address to, uint value);
11   function approve(address spender, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract Own {
16     address public owner;
17 
18     function Own() {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner {
23         if (msg.sender != owner) throw;
24         _;
25     }
26 
27     function transferOwnership(address newOwner) onlyOwner {
28         if (newOwner != address(0)) {
29             owner = newOwner;
30         }
31     }
32 }
33 
34 contract Pause is Own {
35   bool public stopped;
36 
37   modifier stopInEmergency {
38     if (stopped) {
39       throw;
40     }
41     _;
42   }
43   
44   modifier onlyInEmergency {
45     if (!stopped) {
46       throw;
47     }
48     _;
49   }
50 
51   // owner call to trigger a stop state
52   function emergencyStop() external onlyOwner {
53     stopped = true;
54   }
55 
56   // owner call to restart from the stop state
57   function release() external onlyOwner onlyInEmergency {
58     stopped = false;
59   }
60 
61 }
62 
63 contract Puller {
64 
65   using SafeMath for uint;
66   
67   mapping(address => uint) public payments;
68 
69   event LogRefundETH(address to, uint value);
70 
71   function asyncSend(address dest, uint amount) internal {
72     payments[dest] = payments[dest].add(amount);
73   }
74 
75   // withdrwaw call for refunding balance acumilated by payee
76   function withdrawPayments() {
77     address payee = msg.sender;
78     uint payment = payments[payee];
79     
80     if (payment == 0) {
81       throw;
82     }
83 
84     if (this.balance < payment) {
85       throw;
86     }
87 
88     payments[payee] = 0;
89 
90     if (!payee.send(payment)) {
91       throw;
92     }
93     LogRefundETH(payee,payment);
94   }
95 }
96 
97 contract BasicToken is ERC20Basic {
98   
99   using SafeMath for uint;
100   
101   mapping(address => uint) balances;
102   
103   modifier onlyPayloadSize(uint size) {
104      if(msg.data.length < size + 4) {
105        throw;
106      }
107      _;
108   }
109 
110   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114   }
115 
116   function balanceOf(address _owner) constant returns (uint balance) {
117     return balances[_owner];
118   }
119 }
120 
121 contract StandardToken is BasicToken, ERC20 {
122   mapping (address => mapping (address => uint)) allowed;
123 
124   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
125     var _allowance = allowed[_from][msg.sender];
126     balances[_to] = balances[_to].add(_value);
127     balances[_from] = balances[_from].sub(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130   }
131 
132   function approve(address _spender, uint _value) {
133     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136   }
137 
138   function allowance(address _owner, address _spender) constant returns (uint remaining) {
139     return allowed[_owner][_spender];
140   }
141 }
142 
143 contract Token is StandardToken, Own {
144   string public constant name = "TribeToken";
145   string public constant symbol = "TRIBE";
146   uint public constant decimals = 6;
147 
148   // Token constructor
149   function Token() {
150       totalSupply = 200000000000000;
151       balances[msg.sender] = totalSupply; // send all created tokens to the owner/creator
152   }
153 
154   // Burn function to burn a set amount of tokens
155   function burner(uint _value) onlyOwner returns (bool) {
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     totalSupply = totalSupply.sub(_value);
158     Transfer(msg.sender, 0x0, _value);
159     return true;
160   }
161 
162 }
163 
164 contract Crowdsale is Pause, Puller {
165     
166     using SafeMath for uint;
167 
168   	struct Backer {
169 		uint weiReceived; // Amount of Ether given
170 		uint coinSent;
171 	}
172     
173 	//CONSTANTS
174 	// Maximum number of TRIBE to sell
175 	uint public constant MAX_CAP = 160000000000000; // 160 000 000 TRIBE
176 	// Minimum amount to invest
177 	uint public constant MIN_INVEST_ETHER = 100 finney; // 0.1ETH
178 	// Crowdsale period
179 	uint private constant CROWDSALE_PERIOD = 22 days; // 22 days crowdsale run
180 	// Number of TRIBE per Ether
181 	uint public constant COIN_PER_ETHER = 3000000000; // 3 000 TRIBE
182 
183 
184 	//VARIABLES
185 	// TRIBE contract reference
186 	Token public coin;
187     // Multisig contract that will receive the Ether
188 	address public multisigEther;
189 	// Number of Ether received
190 	uint public etherReceived;
191 	// Number of TRIBE sent to Ether contributors
192 	uint public coinSentToEther;
193   // Number of TRIBE to burn
194   uint public coinToBurn;
195 	// Crowdsale start time
196 	uint public startTime;
197 	// Crowdsale end time
198 	uint public endTime;
199  	// Is crowdsale still on going
200 	bool public crowdsaleClosed;
201 	// Refund open variable
202 	bool public refundsOpen;
203 
204 	// Backers Ether indexed by their Ethereum address
205 	mapping(address => Backer) public backers;
206 
207 
208 	//MODIFIERS
209 	modifier respectTimeFrame() {
210 		if ((now < startTime) || (now > endTime )) throw;
211 		_;
212 	}
213 	
214 	modifier refundStatus() {
215 		if ((refundsOpen != true )) throw;
216 		_;
217 	}
218 
219 	//EVENTS
220 	event LogReceivedETH(address addr, uint value);
221 	event LogCoinsEmited(address indexed from, uint amount);
222 
223 	//Crowdsale Constructor
224 	function Crowdsale(address _TRIBEAddress, address _to) {
225 		coin = Token(_TRIBEAddress);
226 		multisigEther = _to;
227 	}
228 	
229 	// Default function to receive ether
230 	function() stopInEmergency respectTimeFrame payable {
231 		receiveETH(msg.sender);
232 	}
233 
234 	 
235 	// To call to start the crowdsale
236 	function start() onlyOwner {
237 		if (startTime != 0) throw; // Crowdsale was already started
238 
239 		startTime = now ;            
240 		endTime =  now + CROWDSALE_PERIOD;    
241 	}
242 
243 	// Main function on ETH receive
244 	function receiveETH(address beneficiary) internal {
245 		if (msg.value < MIN_INVEST_ETHER) throw; // Do not accept investment if the amount is lower than the minimum allowed investment
246 		
247 		uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Calculate the amount of tokens to send
248 		if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;	
249 
250 		Backer backer = backers[beneficiary];
251 		coin.transfer(beneficiary, coinToSend); // Transfer TRIBE
252 
253 		backer.coinSent = backer.coinSent.add(coinToSend);
254 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
255 
256 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
257 		coinSentToEther = coinSentToEther.add(coinToSend);
258 
259 		// Send events
260 		LogCoinsEmited(msg.sender ,coinToSend);
261 		LogReceivedETH(beneficiary, etherReceived); 
262 	}
263 	
264 
265 	// Bonus function for the first week
266 	function bonus(uint amount) internal constant returns (uint) {
267 		if (now < startTime.add(7 days)) return amount.add(amount.div(5));   // bonus 20%
268 		return amount;
269 	}
270 
271 	// Finalize function
272 	function finalize() onlyOwner public {
273 
274         // Check if the crowdsale has ended or if the old tokens have been sold
275     if(coinSentToEther != MAX_CAP){
276         if (now < endTime)  throw; // If Crowdsale still running
277     }
278 		
279 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
280 		
281 		uint remains = coin.balanceOf(this);
282 		if (remains > 0) {
283       coinToBurn = coinToBurn.add(remains);
284       // Transfer remains to owner to burn
285       coin.transfer(owner, remains);
286 		}
287 		crowdsaleClosed = true;
288 	}
289 
290 	// Drain functions in case of unexpected issues with the smart contract.
291   // ETH drain
292 	function drain() onlyOwner {
293     if (!multisigEther.send(this.balance)) throw; //Transfer to team multisig wallet
294 	}
295   // TOKEN drain
296   function coinDrain() onlyOwner {
297     uint remains = coin.balanceOf(this);
298     coin.transfer(owner, remains); // Transfer to owner wallet
299 	}
300 
301 	// Change multisig wallet in case its needed
302 	function changeMultisig(address addr) onlyOwner public {
303 		if (addr == address(0)) throw;
304 		multisigEther = addr;
305 	}
306 
307 	// Change contract ownership
308 	function changeTribeOwner() onlyOwner public {
309 		coin.transferOwnership(owner);
310 	}
311 
312 	// Toggle refund state on and off
313 	function setRefundState() onlyOwner public {
314 		if(refundsOpen == false){
315 			refundsOpen = true;
316 		}else{
317 			refundsOpen = false;
318 		}
319 	}
320 
321 	//Refund function when minimum cap isnt reached, this is step is step 2, THIS FUNCTION ONLY AVAILABLE AFTER BEING ENABLED.
322 	//STEP1: From TRIBE token contract use "approve" function with the amount of TRIBE you got in total.
323 	//STEP2: From TRIBE crowdsale contract use "refund" function with the amount of TRIBE you got in total.
324 	//STEP3: From TRIBE crowdsale contract use "withdrawPayement" function to recieve the ETH.
325 	function refund(uint _value) refundStatus public {
326 		
327 		if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
328 
329 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
330 
331 		uint ETHToSend = backers[msg.sender].weiReceived;
332 		backers[msg.sender].weiReceived=0;
333 
334 		if (ETHToSend > 0) {
335 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
336 		}
337 	}
338 
339 }
340 
341 library SafeMath {
342   function mul(uint a, uint b) internal returns (uint) {
343     uint c = a * b;
344     assert(a == 0 || c / a == b);
345     return c;
346   }
347   function div(uint a, uint b) internal returns (uint) {
348     assert(b > 0);
349     uint c = a / b;
350     assert(a == b * c + a % b);
351     return c;
352   }
353   function sub(uint a, uint b) internal returns (uint) {
354     assert(b <= a);
355     return a - b;
356   }
357   function add(uint a, uint b) internal returns (uint) {
358     uint c = a + b;
359     assert(c >= a);
360     return c;
361   }
362   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
363     return a >= b ? a : b;
364   }
365   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
366     return a < b ? a : b;
367   }
368   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
369     return a >= b ? a : b;
370   }
371   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
372     return a < b ? a : b;
373   }
374   function assert(bool assertion) internal {
375     if (!assertion) {
376       throw;
377     }
378   }
379 }