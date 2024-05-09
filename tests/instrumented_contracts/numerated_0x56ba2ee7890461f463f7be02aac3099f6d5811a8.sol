1 pragma solidity^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint);
72   function transferFrom(address from, address to, uint value);
73   function approve(address spender, uint value);
74   event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances. 
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint;
83 
84   mapping(address => uint) balances;
85 
86   /**
87    * @dev Fix for the ERC20 short address attack.
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length < size + 4) {
91        throw;
92      }
93      _;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of. 
110   * @return An uint representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implemantation of the basic standart token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is BasicToken, ERC20 {
127 
128   mapping (address => mapping (address => uint)) allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint the amout of tokens to be transfered
136    */
137   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
138     var _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // if (_value > _allowance) throw;
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147   }
148 
149   /**
150    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint _value) {
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
161 
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens than an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint specifing the amount of tokens still avaible for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 
179 contract CATToken is StandardToken {
180 	using SafeMath for uint256;
181 	
182 	// keccak256 hash of hidden cap
183 	string public constant HIDDEN_CAP = "0xd22f19d54193ff5e08e7ba88c8e52ec1b9fc8d4e0cf177e1be8a764fa5b375fa";
184 	
185 	// Events
186 	event CreatedCAT(address indexed _creator, uint256 _amountOfCAT);
187 	event CATRefundedForWei(address indexed _refunder, uint256 _amountOfWei);
188 	
189 	// Token data
190 	string public constant name = "BlockCAT Token";
191 	string public constant symbol = "CAT";
192 	uint256 public constant decimals = 18;  // Since our decimals equals the number of wei per ether, we needn't multiply sent values when converting between CAT and ETH.
193 	string public version = "1.0";
194 	
195 	// Addresses and contracts
196 	address public executor;
197 	address public devETHDestination;
198 	address public devCATDestination;
199 	address public reserveCATDestination;
200 	
201 	// Sale data
202 	bool public saleHasEnded;
203 	bool public minCapReached;
204 	bool public allowRefund;
205 	mapping (address => uint256) public ETHContributed;
206 	uint256 public totalETHRaised;
207 	uint256 public saleStartBlock;
208 	uint256 public saleEndBlock;
209 	uint256 public saleFirstEarlyBirdEndBlock;
210 	uint256 public saleSecondEarlyBirdEndBlock;
211 	uint256 public constant DEV_PORTION = 20;  // In percentage
212 	uint256 public constant RESERVE_PORTION = 1;  // In percentage
213 	uint256 public constant ADDITIONAL_PORTION = DEV_PORTION + RESERVE_PORTION;
214 	uint256 public constant SECURITY_ETHER_CAP = 1000000 ether;
215 	uint256 public constant CAT_PER_ETH_BASE_RATE = 300;  // 300 CAT = 1 ETH during normal part of token sale
216 	uint256 public constant CAT_PER_ETH_FIRST_EARLY_BIRD_RATE = 330;
217 	uint256 public constant CAT_PER_ETH_SECOND_EARLY_BIRD_RATE = 315;
218 	
219 	function CATToken(
220 		address _devETHDestination,
221 		address _devCATDestination,
222 		address _reserveCATDestination,
223 		uint256 _saleStartBlock,
224 		uint256 _saleEndBlock
225 	) {
226 		// Reject on invalid ETH destination address or CAT destination address
227 		if (_devETHDestination == address(0x0)) throw;
228 		if (_devCATDestination == address(0x0)) throw;
229 		if (_reserveCATDestination == address(0x0)) throw;
230 		// Reject if sale ends before the current block
231 		if (_saleEndBlock <= block.number) throw;
232 		// Reject if the sale end time is less than the sale start time
233 		if (_saleEndBlock <= _saleStartBlock) throw;
234 
235 		executor = msg.sender;
236 		saleHasEnded = false;
237 		minCapReached = false;
238 		allowRefund = false;
239 		devETHDestination = _devETHDestination;
240 		devCATDestination = _devCATDestination;
241 		reserveCATDestination = _reserveCATDestination;
242 		totalETHRaised = 0;
243 		saleStartBlock = _saleStartBlock;
244 		saleEndBlock = _saleEndBlock;
245 		saleFirstEarlyBirdEndBlock = saleStartBlock + 6171;  // Equivalent to 24 hours later, assuming 14 second blocks
246 		saleSecondEarlyBirdEndBlock = saleFirstEarlyBirdEndBlock + 12342;  // Equivalent to 48 hours later after first early bird, assuming 14 second blocks
247 
248 		totalSupply = 0;
249 	}
250 	
251 	function createTokens() payable external {
252 		// If sale is not active, do not create CAT
253 		if (saleHasEnded) throw;
254 		if (block.number < saleStartBlock) throw;
255 		if (block.number > saleEndBlock) throw;
256 		// Check if the balance is greater than the security cap
257 		uint256 newEtherBalance = totalETHRaised.add(msg.value);
258 		if (newEtherBalance > SECURITY_ETHER_CAP) throw; 
259 		// Do not do anything if the amount of ether sent is 0
260 		if (0 == msg.value) throw;
261 		
262 		// Calculate the CAT to ETH rate for the current time period of the sale
263 		uint256 curTokenRate = CAT_PER_ETH_BASE_RATE;
264 		if (block.number < saleFirstEarlyBirdEndBlock) {
265 			curTokenRate = CAT_PER_ETH_FIRST_EARLY_BIRD_RATE;
266 		}
267 		else if (block.number < saleSecondEarlyBirdEndBlock) {
268 			curTokenRate = CAT_PER_ETH_SECOND_EARLY_BIRD_RATE;
269 		}
270 		
271 		// Calculate the amount of CAT being purchased
272 		uint256 amountOfCAT = msg.value.mul(curTokenRate);
273 		
274 		// Ensure that the transaction is safe
275 		uint256 totalSupplySafe = totalSupply.add(amountOfCAT);
276 		uint256 balanceSafe = balances[msg.sender].add(amountOfCAT);
277 		uint256 contributedSafe = ETHContributed[msg.sender].add(msg.value);
278 
279 		// Update individual and total balances
280 		totalSupply = totalSupplySafe;
281 		balances[msg.sender] = balanceSafe;
282 
283 		totalETHRaised = newEtherBalance;
284 		ETHContributed[msg.sender] = contributedSafe;
285 
286 		CreatedCAT(msg.sender, amountOfCAT);
287 	}
288 	
289 	function endSale() {
290 		// Do not end an already ended sale
291 		if (saleHasEnded) throw;
292 		// Can't end a sale that hasn't hit its minimum cap
293 		if (!minCapReached) throw;
294 		// Only allow the owner to end the sale
295 		if (msg.sender != executor) throw;
296 		
297 		saleHasEnded = true;
298 
299 		// Calculate and create developer and reserve portion of CAT
300 		uint256 additionalCAT = (totalSupply.mul(ADDITIONAL_PORTION)).div(100 - ADDITIONAL_PORTION);
301 		uint256 totalSupplySafe = totalSupply.add(additionalCAT);
302 
303 		uint256 reserveShare = (additionalCAT.mul(RESERVE_PORTION)).div(ADDITIONAL_PORTION);
304 		uint256 devShare = additionalCAT.sub(reserveShare);
305 
306 		totalSupply = totalSupplySafe;
307 		balances[devCATDestination] = devShare;
308 		balances[reserveCATDestination] = reserveShare;
309 		
310 		CreatedCAT(devCATDestination, devShare);
311 		CreatedCAT(reserveCATDestination, reserveShare);
312 
313 		if (this.balance > 0) {
314 			if (!devETHDestination.call.value(this.balance)()) throw;
315 		}
316 	}
317 
318 	// Allows BlockCAT to withdraw funds
319 	function withdrawFunds() {
320 		// Disallow withdraw if the minimum hasn't been reached
321 		if (!minCapReached) throw;
322 		if (0 == this.balance) throw;
323 
324 		if (!devETHDestination.call.value(this.balance)()) throw;
325 	}
326 	
327 	// Signals that the sale has reached its minimum funding goal
328 	function triggerMinCap() {
329 		if (msg.sender != executor) throw;
330 
331 		minCapReached = true;
332 	}
333 
334 	// Opens refunding.
335 	function triggerRefund() {
336 		// No refunds if the sale was successful
337 		if (saleHasEnded) throw;
338 		// No refunds if minimum cap is hit
339 		if (minCapReached) throw;
340 		// No refunds if the sale is still progressing
341 		if (block.number < saleEndBlock) throw;
342 		if (msg.sender != executor) throw;
343 
344 		allowRefund = true;
345 	}
346 
347 	function refund() external {
348 		// No refunds until it is approved
349 		if (!allowRefund) throw;
350 		// Nothing to refund
351 		if (0 == ETHContributed[msg.sender]) throw;
352 
353 		// Do the refund.
354 		uint256 etherAmount = ETHContributed[msg.sender];
355 		ETHContributed[msg.sender] = 0;
356 
357 		CATRefundedForWei(msg.sender, etherAmount);
358 		if (!msg.sender.send(etherAmount)) throw;
359 	}
360 
361 	function changeDeveloperETHDestinationAddress(address _newAddress) {
362 		if (msg.sender != executor) throw;
363 		devETHDestination = _newAddress;
364 	}
365 	
366 	function changeDeveloperCATDestinationAddress(address _newAddress) {
367 		if (msg.sender != executor) throw;
368 		devCATDestination = _newAddress;
369 	}
370 	
371 	function changeReserveCATDestinationAddress(address _newAddress) {
372 		if (msg.sender != executor) throw;
373 		reserveCATDestination = _newAddress;
374 	}
375 	
376 	function transfer(address _to, uint _value) {
377 		// Cannot transfer unless the minimum cap is hit
378 		if (!minCapReached) throw;
379 		
380 		super.transfer(_to, _value);
381 	}
382 	
383 	function transferFrom(address _from, address _to, uint _value) {
384 		// Cannot transfer unless the minimum cap is hit
385 		if (!minCapReached) throw;
386 		
387 		super.transferFrom(_from, _to, _value);
388 	}
389 }