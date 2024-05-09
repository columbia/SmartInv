1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances. 
74  */
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203  //The Persian Daric was a gold coin which, along
204  //with a similar silver coin, the siglos, represented
205  //the bimetallic monetary standard of the 
206  //Achaemenid Persian Empire.in that era Daric
207  //was the best phenomena in purpose to making
208  //possible exchange in whole world.This is a 
209  //contract to celebrate our ancestors and to 
210  //remind us of the tradition. The tradition one 
211  //that made our lives today. We are going to the 
212  //future, while this is our past that drives us 
213  //forward. Author, Farhad Ghanaatgar 
214  //Constructor
215 contract DaRiCpAy is StandardToken {
216 	using SafeMath for uint256;
217 
218     // EVENTS
219     event CreatedIRC(address indexed _creator, uint256 _amountOfIRC);
220 
221 	
222 	// TOKEN DATA
223 	string public constant name = "DaRiC";
224 	string public constant symbol = "IRC";
225 	uint256 public constant decimals = 18;
226 	string public version = "1.0";
227 
228 	// IRC TOKEN PURCHASE LIMITS
229 	uint256 public maxPresaleSupply; 	// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
230 
231 	// PURCHASE DATES
232 	uint256 public constant preSaleStartTime = 1516406400; 	//Saturday, 20-Jan-18 00:00:00 UTC in RFC 2822
233 	uint256 public constant preSaleEndTime = 1518220800 ; 	// Saturday, 10-Feb-18 00:00:00 UTC in RFC 2822
234 	uint256 public saleStartTime = 1518267600 ; // Saturday, 10-Feb-18 13:00:00 UTC in RFC 2822
235 	uint256 public saleEndTime = 1522429200; //Friday, 30-Mar-18 17:00:00 UTC in RFC 2822
236 
237 
238 	// PURCHASE BONUSES
239 	uint256 public lowEtherBonusLimit = 5 * 1 ether;				// 5+ Ether
240 	uint256 public lowEtherBonusValue = 110;						// 10% Discount
241 	uint256 public midEtherBonusLimit = 24 * 1 ether; 		    	// 24+ Ether
242 	uint256 public midEtherBonusValue = 115;						// 15% Discount
243 	uint256 public highEtherBonusLimit = 50 * 1 ether; 				// 50+ Ether
244 	uint256 public highEtherBonusValue = 120; 						// 20% Discount
245 	uint256 public highTimeBonusLimit = 0; 							// 1-12 Days
246 	uint256 public highTimeBonusValue = 115; 						// 20% Discount
247 	uint256 public midTimeBonusLimit = 1036800; 					// 12-24 Days
248 	uint256 public midTimeBonusValue = 110; 						// 15% Discount
249 	uint256 public lowTimeBonusLimit = 3124800;						// 24+ Days
250 	uint256 public lowTimeBonusValue = 105;							// 5% Discount
251 
252 	// PRICING INFO
253 	uint256 public constant IRC_PER_ETH_PRE_SALE = 10000;  			// 10000 IRC = 1 ETH
254 	uint256 public constant IRC_PER_ETH_SALE = 8000;  				// 8000 IRC = 1 ETH
255 	
256 	// ADDRESSES
257 	address public constant ownerAddress = 0x88ce817Efd0dD935Eed8e9d553167d08870AA6e7; 	// The owners address
258 
259 	// STATE INFO	
260 	bool public allowInvestment = true;								// Flag to change if transfering is allowed
261 	uint256 public totalWEIInvested = 0; 							// Total WEI invested
262 	uint256 public totalIRCAllocated = 0;							// Total IRC allocated
263 	mapping (address => uint256) public WEIContributed; 			// Total WEI Per Account
264 
265 
266 	// INITIALIZATIONS FUNCTION
267 	function DaRiCpAy() {
268 		require(msg.sender == ownerAddress);
269 
270 		totalSupply = 20*1000000*1000000000000000000; 				// MAX TOTAL IRC 20 million
271 		uint256 totalIRCReserved = totalSupply.mul(20).div(100);	// 20% reserved for IRC
272 		maxPresaleSupply = totalSupply*8/1000 + totalIRCReserved; 	// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
273 
274 		balances[msg.sender] = totalIRCReserved;
275 		totalIRCAllocated = totalIRCReserved;				
276 	}
277 
278 
279 	// FALL BACK FUNCTION TO ALLOW ETHER DONATIONS
280 	function() payable {
281 
282 		require(allowInvestment);
283 
284 		// Smallest investment is 0.00001 ether
285 		uint256 amountOfWei = msg.value;
286 		require(amountOfWei >= 10000000000000);
287 
288 		uint256 amountOfIRC = 0;
289 		uint256 absLowTimeBonusLimit = 0;
290 		uint256 absMidTimeBonusLimit = 0;
291 		uint256 absHighTimeBonusLimit = 0;
292 		uint256 totalIRCAvailable = 0;
293 
294 		// Investment periods
295 		if (now > preSaleStartTime && now < preSaleEndTime) {
296 			// Pre-sale ICO
297 			amountOfIRC = amountOfWei.mul(IRC_PER_ETH_PRE_SALE);
298 			absLowTimeBonusLimit = preSaleStartTime + lowTimeBonusLimit;
299 			absMidTimeBonusLimit = preSaleStartTime + midTimeBonusLimit;
300 			absHighTimeBonusLimit = preSaleStartTime + highTimeBonusLimit;
301 			totalIRCAvailable = maxPresaleSupply - totalIRCAllocated;
302 		} else if (now > saleStartTime && now < saleEndTime) {
303 			// ICO
304 			amountOfIRC = amountOfWei.mul(IRC_PER_ETH_SALE);
305 			absLowTimeBonusLimit = saleStartTime + lowTimeBonusLimit;
306 			absMidTimeBonusLimit = saleStartTime + midTimeBonusLimit;
307 			absHighTimeBonusLimit = saleStartTime + highTimeBonusLimit;
308 			totalIRCAvailable = totalSupply - totalIRCAllocated;
309 		} else {
310 			// Invalid investment period
311 			revert();
312 		}
313 
314 		// Check that IRC calculated greater than zero
315 		assert(amountOfIRC > 0);
316 
317 		// Apply Bonuses
318 		if (amountOfWei >= highEtherBonusLimit) {
319 			amountOfIRC = amountOfIRC.mul(highEtherBonusValue).div(100);
320 		} else if (amountOfWei >= midEtherBonusLimit) {
321 			amountOfIRC = amountOfIRC.mul(midEtherBonusValue).div(100);
322 		} else if (amountOfWei >= lowEtherBonusLimit) {
323 			amountOfIRC = amountOfIRC.mul(lowEtherBonusValue).div(100);
324 		}
325 		if (now >= absLowTimeBonusLimit) {
326 			amountOfIRC = amountOfIRC.mul(lowTimeBonusValue).div(100);
327 		} else if (now >= absMidTimeBonusLimit) {
328 			amountOfIRC = amountOfIRC.mul(midTimeBonusValue).div(100);
329 		} else if (now >= absHighTimeBonusLimit) {
330 			amountOfIRC = amountOfIRC.mul(highTimeBonusValue).div(100);
331 		}
332 
333 		// Max sure it doesn't exceed remaining supply
334 		assert(amountOfIRC <= totalIRCAvailable);
335 
336 		// Update total IRC balance
337 		totalIRCAllocated = totalIRCAllocated + amountOfIRC;
338 
339 		// Update user IRC balance
340 		uint256 balanceSafe = balances[msg.sender].add(amountOfIRC);
341 		balances[msg.sender] = balanceSafe;
342 
343 		// Update total WEI Invested
344 		totalWEIInvested = totalWEIInvested.add(amountOfWei);
345 
346 		// Update total WEI Invested by account
347 		uint256 contributedSafe = WEIContributed[msg.sender].add(amountOfWei);
348 		WEIContributed[msg.sender] = contributedSafe;
349 
350 		// CHECK VALUES
351 		assert(totalIRCAllocated <= totalSupply);
352 		assert(totalIRCAllocated > 0);
353 		assert(balanceSafe > 0);
354 		assert(totalWEIInvested > 0);
355 		assert(contributedSafe > 0);
356 
357 		// CREATE EVENT FOR SENDER
358 		CreatedIRC(msg.sender, amountOfIRC);
359 	}
360 	
361 	
362 	// CHANGE PARAMETERS METHODS
363 	function transferEther(address addressToSendTo, uint256 value) {
364 		require(msg.sender == ownerAddress);
365 		addressToSendTo;
366 		addressToSendTo.transfer(value) ;
367 	}	
368 	function changeAllowInvestment(bool _allowInvestment) {
369 		require(msg.sender == ownerAddress);
370 		allowInvestment = _allowInvestment;
371 	}
372 	function changeSaleTimes(uint256 _saleStartTime, uint256 _saleEndTime) {
373 		require(msg.sender == ownerAddress);
374 		saleStartTime = _saleStartTime;
375 		saleEndTime	= _saleEndTime;
376 	}
377 	function changeEtherBonuses(uint256 _lowEtherBonusLimit, uint256 _lowEtherBonusValue, uint256 _midEtherBonusLimit, uint256 _midEtherBonusValue, uint256 _highEtherBonusLimit, uint256 _highEtherBonusValue) {
378 		require(msg.sender == ownerAddress);
379 		lowEtherBonusLimit = _lowEtherBonusLimit;
380 		lowEtherBonusValue = _lowEtherBonusValue;
381 		midEtherBonusLimit = _midEtherBonusLimit;
382 		midEtherBonusValue = _midEtherBonusValue;
383 		highEtherBonusLimit = _highEtherBonusLimit;
384 		highEtherBonusValue = _highEtherBonusValue;
385 	}
386 	function changeTimeBonuses(uint256 _highTimeBonusLimit, uint256 _highTimeBonusValue, uint256 _midTimeBonusLimit, uint256 _midTimeBonusValue, uint256 _lowTimeBonusLimit, uint256 _lowTimeBonusValue) {
387 		require(msg.sender == ownerAddress);
388 		highTimeBonusLimit = _highTimeBonusLimit;
389 		highTimeBonusValue = _highTimeBonusValue;
390 		midTimeBonusLimit = _midTimeBonusLimit;
391 		midTimeBonusValue = _midTimeBonusValue;
392 		lowTimeBonusLimit = _lowTimeBonusLimit;
393 		lowTimeBonusValue = _lowTimeBonusValue;
394 	}
395 
396 }