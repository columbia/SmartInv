1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /////////////////////////////////////////////////////////////////////////////
57 
58 
59 
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20Basic {
67   uint public totalSupply;
68   function balanceOf(address who) constant returns (uint);
69   function transfer(address to, uint value);
70   event Transfer(address indexed from, address indexed to, uint value);
71 }
72 
73 
74 ////////////////////////////////////////////////
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) constant returns (uint);
82   function transferFrom(address from, address to, uint value);
83   function approve(address spender, uint value);
84   event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 ///////////////////////////////////////////////
88 
89 
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances. 
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint;
98 
99   mapping(address => uint) balances;
100 
101   /**
102    * @dev Fix for the ERC20 short address attack.
103    */
104   modifier onlyPayloadSize(uint size) {
105      if(msg.data.length < size + 4) {
106        throw;
107      }
108      _;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of. 
125   * @return An uint representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) constant returns (uint balance) {
128     return balances[_owner];
129   }
130 
131 }
132 
133 ////////////////////////////////////////////////
134 
135 
136 
137 
138 
139 
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implemantation of the basic standart token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is BasicToken, ERC20 {
150 
151   mapping (address => mapping (address => uint)) allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint the amout of tokens to be transfered
159    */
160   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
161     var _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
164     // if (_value > _allowance) throw;
165 
166     balances[_to] = balances[_to].add(_value);
167     balances[_from] = balances[_from].sub(_value);
168     allowed[_from][msg.sender] = _allowance.sub(_value);
169     Transfer(_from, _to, _value);
170   }
171 
172   /**
173    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint _value) {
178 
179     // To change the approve amount you first have to reduce the addresses`
180     //  allowance to zero by calling `approve(_spender, 0)` if it is not
181     //  already 0 to mitigate the race condition described here:
182     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
184 
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens than an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 
202 ///////////////////////////////////////////////////////////////////////////////////////////////////
203 
204 
205 
206 
207 contract NIMFAToken is StandardToken {
208 	using SafeMath for uint256;
209 	
210 	
211 	
212 	event CreatedNIMFA(address indexed _creator, uint256 _amountOfNIMFA);
213 	
214 	// Token data
215 	string public constant name = "NIMFA Token";
216 	string public constant symbol = "NIMFA";
217 	uint256 public constant decimals = 18; 
218 	string public version = "1.0";
219 	
220 	// Addresses and contracts
221 	address public executor;
222 	address public teamETHAddress;  
223 	address public teamNIMFAAddress;
224 	address public creditFundNIMFAAddress;
225 	address public reserveNIMFAAddress;
226 	
227 	bool public preSaleHasEnded;
228 	bool public saleHasEnded;
229 	bool public allowTransfer;
230 	bool public maxPreSale;  // 1000000 NIMFA for pre sale price
231 	mapping (address => uint256) public ETHContributed;
232 	uint256 public totalETH;
233 	uint256 public preSaleStartBlock;
234 	uint256 public preSaleEndBlock;
235 	uint256 public saleStartBlock;
236 	uint256 public saleEndBlock;
237 	uint256 public constant NIMFA_PER_ETH_PRE_SALE = 1100;  // 1100 NIMFA = 1 ETH 
238 	uint256 public constant NIMFA_PER_ETH_SALE = 110;  // 110 NIMFA = 1 ETH 
239 	
240 
241 	
242 	function NIMFAToken(
243 		address _teamETHAddress,
244 		address _teamNIMFAAddress,
245 		address _creditFundNIMFAAddress,
246 		address _reserveNIMFAAddress,
247 		uint256 _preSaleStartBlock,
248 		uint256 _preSaleEndBlock
249 	) {
250 		
251 		if (_teamETHAddress == address(0x0)) throw;
252 		if (_teamNIMFAAddress == address(0x0)) throw;
253 		if (_creditFundNIMFAAddress == address(0x0)) throw;
254 		if (_reserveNIMFAAddress == address(0x0)) throw;
255 		// Reject if sale ends before the current block
256 		if (_preSaleEndBlock <= block.number) throw;
257 		// Reject if the sale end time is less than the sale start time
258 		if (_preSaleEndBlock <= _preSaleStartBlock) throw;
259 
260 		executor = msg.sender;
261 		preSaleHasEnded = false;
262 		saleHasEnded = false;
263 		allowTransfer = false;
264 		maxPreSale = false;
265 		teamETHAddress = _teamETHAddress;
266 		teamNIMFAAddress = _teamNIMFAAddress;
267 		creditFundNIMFAAddress = _creditFundNIMFAAddress;
268 		reserveNIMFAAddress = _reserveNIMFAAddress;
269 		totalETH = 0;
270 		preSaleStartBlock = _preSaleStartBlock;
271 		preSaleEndBlock = _preSaleEndBlock;
272 		saleStartBlock = _preSaleStartBlock;
273 		saleEndBlock = _preSaleEndBlock;
274 		totalSupply = 0;
275 	}
276 	
277 	function investment() payable external {
278 		// If preSale/Sale is not active, do not create NIMFA
279 		if (preSaleHasEnded && saleHasEnded) throw;
280 		if (!preSaleHasEnded) {
281 		    if (block.number < preSaleStartBlock) throw;
282 		    if (block.number > preSaleEndBlock) throw;
283 		}
284 		if (block.number < saleStartBlock) throw;
285 		if (block.number > saleEndBlock) throw;
286 		
287 		uint256 newEtherBalance = totalETH.add(msg.value);
288 
289 		// Do not do anything if the amount of ether sent is 0
290 		if (0 == msg.value) throw;
291 		
292 		// Calculate the amount of NIMFA being purchased
293 		uint256 amountOfNIMFA = msg.value.mul(NIMFA_PER_ETH_PRE_SALE);
294 		if (preSaleHasEnded || maxPreSale) amountOfNIMFA = msg.value.mul(NIMFA_PER_ETH_SALE);
295 		
296 		if (100000 ether < amountOfNIMFA) throw;
297 		
298 		// Ensure that the transaction is safe
299 		uint256 totalSupplySafe = totalSupply.add(amountOfNIMFA);
300 		uint256 balanceSafe = balances[msg.sender].add(amountOfNIMFA);
301 		uint256 contributedSafe = ETHContributed[msg.sender].add(msg.value);
302 
303 		// Update balances
304 		totalSupply = totalSupplySafe;
305 		if (totalSupply > 2000000 ether) maxPreSale = true;
306 		balances[msg.sender] = balanceSafe;
307 
308 		totalETH = newEtherBalance;
309 		ETHContributed[msg.sender] = contributedSafe;
310 		if (!preSaleHasEnded) teamETHAddress.transfer(msg.value);
311 
312 		CreatedNIMFA(msg.sender, amountOfNIMFA);
313 	}
314 	
315 	function endPreSale() {
316 		// Do not end an already ended sale
317 		if (preSaleHasEnded) throw;
318 		
319 		// Only allow the owner
320 		if (msg.sender != executor) throw;
321 		
322 		preSaleHasEnded = true;
323 	}
324 	
325 	
326 	function endSale() {
327 		
328 		if (!preSaleHasEnded) throw;
329 		// Do not end an already ended sale
330 		if (saleHasEnded) throw;
331 		
332 		// Only allow the owner
333 		if (msg.sender != executor) throw;
334 		
335 		saleHasEnded = true;
336 		uint256 EtherAmount = this.balance;
337 		teamETHAddress.transfer(EtherAmount);
338 		
339 		uint256 creditFund = totalSupply.mul(3);
340 		uint256 reserveNIMFA = totalSupply.div(2);
341 		uint256 teamNIMFA = totalSupply.div(2);
342 		uint256 totalSupplySafe = totalSupply.add(creditFund).add(reserveNIMFA).add(teamNIMFA);
343 
344 
345 		totalSupply = totalSupplySafe;
346 		balances[creditFundNIMFAAddress] = creditFund;
347 		balances[reserveNIMFAAddress] = reserveNIMFA;
348 		balances[teamNIMFAAddress] = teamNIMFA;
349 		
350 		CreatedNIMFA(creditFundNIMFAAddress, creditFund);
351 		CreatedNIMFA(reserveNIMFAAddress, reserveNIMFA);
352         CreatedNIMFA(teamNIMFAAddress, teamNIMFA);
353 	}
354 	
355 	
356 	function changeTeamETHAddress(address _newAddress) {
357 		if (msg.sender != executor) throw;
358 		teamETHAddress = _newAddress;
359 	}
360 	
361 	function changeTeamNIMFAAddress(address _newAddress) {
362 		if (msg.sender != executor) throw;
363 		teamNIMFAAddress = _newAddress;
364 	}
365 	
366 	function changeCreditFundNIMFAAddress(address _newAddress) {
367 		if (msg.sender != executor) throw;
368 		creditFundNIMFAAddress = _newAddress;
369 	}
370 	
371 	/*
372 	* Allow transfer only after sales
373 	*/
374 	function changeAllowTransfer() {
375 		if (msg.sender != executor) throw;
376 
377 		allowTransfer = true;
378 	}
379 	
380 	/*
381 	* 
382 	*/
383 	function changeSaleStartBlock(uint256 _saleStartBlock) {
384 		if (msg.sender != executor) throw;
385         saleStartBlock = _saleStartBlock;
386 	}
387 	
388 	/*
389 	* 
390 	*/
391 	function changeSaleEndBlock(uint256 _saleEndBlock) {
392 		if (msg.sender != executor) throw;
393         saleEndBlock = _saleEndBlock;
394 	}
395 	
396 	
397 	function transfer(address _to, uint _value) {
398 		// Cannot transfer unless the minimum cap is hit
399 		if (!allowTransfer) throw;
400 		
401 		super.transfer(_to, _value);
402 	}
403 	
404 	function transferFrom(address _from, address _to, uint _value) {
405 		// Cannot transfer unless the minimum cap is hit
406 		if (!allowTransfer) throw;
407 		
408 		super.transferFrom(_from, _to, _value);
409 	}
410 }