1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 /**
30  * @title ERC20Basic
31  * @dev Simpler version of ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/179
33  */
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 /**
42  * @title ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) constant returns (uint256);
48   function transferFrom(address from, address to, uint256 value) returns (bool);
49   function approve(address spender, uint256 value) returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances. 
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) returns (bool) {
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of. 
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * @dev https://github.com/ethereum/EIPs/issues/20
90  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) allowed;
95 
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amout of tokens to be transfered
102    */
103   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
104     var _allowance = allowed[_from][msg.sender];
105 
106     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107     // require (_value <= _allowance);
108 
109     balances[_to] = balances[_to].add(_value);
110     balances[_from] = balances[_from].sub(_value);
111     allowed[_from][msg.sender] = _allowance.sub(_value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) returns (bool) {
122 
123     // To change the approve amount you first have to reduce the addresses`
124     //  allowance to zero by calling `approve(_spender, 0)` if it is not
125     //  already 0 to mitigate the race condition described here:
126     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifing the amount of tokens still available for the spender.
139    */
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 contract MilitaryPay is StandardToken {
147 	using SafeMath for uint256;
148 
149     // EVENTS
150     event CreatedMTP(address indexed _creator, uint256 _amountOfMTP);
151 
152 	
153 	// TOKEN DATA
154 	string public constant name = "MilitaryPay";
155 	string public constant symbol = "MTP";
156 	uint256 public constant decimals = 18;
157 	string public version = "1.0";
158 
159 	// MTP TOKEN PURCHASE LIMITS
160 	uint256 public maxPresaleSupply; 														// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
161 
162 	// PURCHASE DATES
163 	uint256 public constant preSaleStartTime = 1503130673; 									// GMT: Saturday, August 19, 2017 8:00:00 AM
164 	uint256 public constant preSaleEndTime = 1505894400; 									// GMT: Wednesday, September 20, 2017 8:00:00 AM
165 	uint256 public saleStartTime = 1509696000; 												// GMT: Friday, November 3, 2017 8:00:00 AM
166 	uint256 public saleEndTime = 1514707200; 												// GMT: Sunday, December 31, 2017 8:00:00 AM
167 
168 
169 	// PURCHASE BONUSES
170 	uint256 public lowEtherBonusLimit = 5 * 1 ether; 										// 5+ Ether
171 	uint256 public lowEtherBonusValue = 110;												// 10% Discount
172 	uint256 public midEtherBonusLimit = 24 * 1 ether; 										// 24+ Ether
173 	uint256 public midEtherBonusValue = 115;												// 15% Discount
174 	uint256 public highEtherBonusLimit = 50 * 1 ether; 										// 50+ Ether
175 	uint256 public highEtherBonusValue = 120; 												// 20% Discount
176 	uint256 public highTimeBonusLimit = 0; 													// 1-12 Days
177 	uint256 public highTimeBonusValue = 120; 												// 20% Discount
178 	uint256 public midTimeBonusLimit = 1036800; 											// 12-24 Days
179 	uint256 public midTimeBonusValue = 115; 												// 15% Discount
180 	uint256 public lowTimeBonusLimit = 2073600;												// 24+ Days
181 	uint256 public lowTimeBonusValue = 110;													// 10% Discount
182 
183 	// PRICING INFO
184 	uint256 public constant MTP_PER_ETH_PRE_SALE = 4000;  								// 4000 MTP = 1 ETH
185 	uint256 public constant MTP_PER_ETH_SALE = 2000;  									// 2000 MTP = 1 ETH
186 	
187 	// ADDRESSES
188 	address public constant ownerAddress = 0x144EFeF99F7F126987c2b5cCD717CF6eDad1E67d; 		// The owners address
189 
190 	// STATE INFO	
191 	bool public allowInvestment = true;														// Flag to change if transfering is allowed
192 	uint256 public totalWEIInvested = 0; 													// Total WEI invested
193 	uint256 public totalMTPAllocated = 0;												// Total MTP allocated
194 	mapping (address => uint256) public WEIContributed; 									// Total WEI Per Account
195 
196 
197 	// INITIALIZATIONS FUNCTION
198 	function MTPToken() {
199 		require(msg.sender == ownerAddress);
200 
201 		totalSupply = 631*1000000*1000000000000000000; 										// MAX TOTAL MTP 631 million
202 		uint256 totalMTPReserved = totalSupply.mul(55).div(100);							// 55% reserved for MTP
203 		maxPresaleSupply = totalSupply*8/1000 + totalMTPReserved; 						// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
204 
205 		balances[msg.sender] = totalMTPReserved;
206 		totalMTPAllocated = totalMTPReserved;				
207 	}
208 
209 
210 	// FALL BACK FUNCTION TO ALLOW ETHER DONATIONS
211 	function() payable {
212 
213 		require(allowInvestment);
214 
215 		// Smallest investment is 0.00001 ether
216 		uint256 amountOfWei = msg.value;
217 		require(amountOfWei >= 10000000000000);
218 
219 		uint256 amountOfMTP = 0;
220 		uint256 absLowTimeBonusLimit = 0;
221 		uint256 absMidTimeBonusLimit = 0;
222 		uint256 absHighTimeBonusLimit = 0;
223 		uint256 totalMTPAvailable = 0;
224 
225 		// Investment periods
226 		if (block.timestamp > preSaleStartTime && block.timestamp < preSaleEndTime) {
227 			// Pre-sale ICO
228 			amountOfMTP = amountOfWei.mul(MTP_PER_ETH_PRE_SALE);
229 			absLowTimeBonusLimit = preSaleStartTime + lowTimeBonusLimit;
230 			absMidTimeBonusLimit = preSaleStartTime + midTimeBonusLimit;
231 			absHighTimeBonusLimit = preSaleStartTime + highTimeBonusLimit;
232 			totalMTPAvailable = maxPresaleSupply - totalMTPAllocated;
233 		} else if (block.timestamp > saleStartTime && block.timestamp < saleEndTime) {
234 			// ICO
235 			amountOfMTP = amountOfWei.mul(MTP_PER_ETH_SALE);
236 			absLowTimeBonusLimit = saleStartTime + lowTimeBonusLimit;
237 			absMidTimeBonusLimit = saleStartTime + midTimeBonusLimit;
238 			absHighTimeBonusLimit = saleStartTime + highTimeBonusLimit;
239 			totalMTPAvailable = totalSupply - totalMTPAllocated;
240 		} else {
241 			// Invalid investment period
242 			revert();
243 		}
244 
245 		// Check that MTP calculated greater than zero
246 		assert(amountOfMTP > 0);
247 
248 		// Apply Bonuses
249 		if (amountOfWei >= highEtherBonusLimit) {
250 			amountOfMTP = amountOfMTP.mul(highEtherBonusValue).div(100);
251 		} else if (amountOfWei >= midEtherBonusLimit) {
252 			amountOfMTP = amountOfMTP.mul(midEtherBonusValue).div(100);
253 		} else if (amountOfWei >= lowEtherBonusLimit) {
254 			amountOfMTP = amountOfMTP.mul(lowEtherBonusValue).div(100);
255 		}
256 		if (block.timestamp >= absLowTimeBonusLimit) {
257 			amountOfMTP = amountOfMTP.mul(lowTimeBonusValue).div(100);
258 		} else if (block.timestamp >= absMidTimeBonusLimit) {
259 			amountOfMTP = amountOfMTP.mul(midTimeBonusValue).div(100);
260 		} else if (block.timestamp >= absHighTimeBonusLimit) {
261 			amountOfMTP = amountOfMTP.mul(highTimeBonusValue).div(100);
262 		}
263 
264 		// Max sure it doesn't exceed remaining supply
265 		assert(amountOfMTP <= totalMTPAvailable);
266 
267 		// Update total MTP balance
268 		totalMTPAllocated = totalMTPAllocated + amountOfMTP;
269 
270 		// Update user MTP balance
271 		uint256 balanceSafe = balances[msg.sender].add(amountOfMTP);
272 		balances[msg.sender] = balanceSafe;
273 
274 		// Update total WEI Invested
275 		totalWEIInvested = totalWEIInvested.add(amountOfWei);
276 
277 		// Update total WEI Invested by account
278 		uint256 contributedSafe = WEIContributed[msg.sender].add(amountOfWei);
279 		WEIContributed[msg.sender] = contributedSafe;
280 
281 		// CHECK VALUES
282 		assert(totalMTPAllocated <= totalSupply);
283 		assert(totalMTPAllocated > 0);
284 		assert(balanceSafe > 0);
285 		assert(totalWEIInvested > 0);
286 		assert(contributedSafe > 0);
287 
288 		// CREATE EVENT FOR SENDER
289 		CreatedMTP(msg.sender, amountOfMTP);
290 	}
291 	
292 	
293 	// CHANGE PARAMETERS METHODS
294 	function transferEther(address addressToSendTo, uint256 value) {
295 		require(msg.sender == ownerAddress);
296 		addressToSendTo.transfer(value);
297 	}	
298 	function changeAllowInvestment(bool _allowInvestment) {
299 		require(msg.sender == ownerAddress);
300 		allowInvestment = _allowInvestment;
301 	}
302 	function changeSaleTimes(uint256 _saleStartTime, uint256 _saleEndTime) {
303 		require(msg.sender == ownerAddress);
304 		saleStartTime = _saleStartTime;
305 		saleEndTime	= _saleEndTime;
306 	}
307 	function changeEtherBonuses(uint256 _lowEtherBonusLimit, uint256 _lowEtherBonusValue, uint256 _midEtherBonusLimit, uint256 _midEtherBonusValue, uint256 _highEtherBonusLimit, uint256 _highEtherBonusValue) {
308 		require(msg.sender == ownerAddress);
309 		lowEtherBonusLimit = _lowEtherBonusLimit;
310 		lowEtherBonusValue = _lowEtherBonusValue;
311 		midEtherBonusLimit = _midEtherBonusLimit;
312 		midEtherBonusValue = _midEtherBonusValue;
313 		highEtherBonusLimit = _highEtherBonusLimit;
314 		highEtherBonusValue = _highEtherBonusValue;
315 	}
316 	function changeTimeBonuses(uint256 _highTimeBonusLimit, uint256 _highTimeBonusValue, uint256 _midTimeBonusLimit, uint256 _midTimeBonusValue, uint256 _lowTimeBonusLimit, uint256 _lowTimeBonusValue) {
317 		require(msg.sender == ownerAddress);
318 		highTimeBonusLimit = _highTimeBonusLimit;
319 		highTimeBonusValue = _highTimeBonusValue;
320 		midTimeBonusLimit = _midTimeBonusLimit;
321 		midTimeBonusValue = _midTimeBonusValue;
322 		lowTimeBonusLimit = _lowTimeBonusLimit;
323 		lowTimeBonusValue = _lowTimeBonusValue;
324 	}
325 
326 }