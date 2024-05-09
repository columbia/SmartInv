1 pragma solidity ^0.4.11;
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
146 contract YupieToken is StandardToken {
147 	using SafeMath for uint256;
148 
149     // EVENTS
150     event CreatedYUPIE(address indexed _creator, uint256 _amountOfYUPIE);
151 
152 	
153 	// TOKEN DATA
154 	string public constant name = "YUPIE";
155 	string public constant symbol = "YUP";
156 	uint256 public constant decimals = 18;
157 	string public version = "1.0";
158 
159 	// YUPIE TOKEN PURCHASE LIMITS
160 	uint256 public maxPresaleSupply; 														// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
161 
162 	// PURCHASE DATES
163 	uint256 public constant preSaleStartTime = 1502784000; 									// GMT: Tuesday, August 15, 2017 8:00:00 AM
164 	uint256 public constant preSaleEndTime = 1505671200; 									// GMT: Sunday, September 17, 2017 6:00:00 PM
165 	uint256 public saleStartTime = 1509523200; 												// GMT: Wednesday, November 1, 2017 8:00:00 AM
166 	uint256 public saleEndTime = 1512115200; 												// GMT: Friday, December 1, 2017 8:00:00 AM
167 
168 	// PURCHASE BONUSES
169 	uint256 public lowEtherBonusLimit = 5 * 1 ether; 										// 5+ Ether
170 	uint256 public lowEtherBonusValue = 110;												// 10% Discount
171 	uint256 public midEtherBonusLimit = 24 * 1 ether; 										// 24+ Ether
172 	uint256 public midEtherBonusValue = 115;												// 15% Discount
173 	uint256 public highEtherBonusLimit = 50 * 1 ether; 										// 50+ Ether
174 	uint256 public highEtherBonusValue = 120; 												// 20% Discount
175 	uint256 public highTimeBonusLimit = 0; 													// 1-12 Days
176 	uint256 public highTimeBonusValue = 120; 												// 20% Discount
177 	uint256 public midTimeBonusLimit = 1036800; 											// 12-24 Days
178 	uint256 public midTimeBonusValue = 115; 												// 15% Discount
179 	uint256 public lowTimeBonusLimit = 2073600;												// 24+ Days
180 	uint256 public lowTimeBonusValue = 110;													// 10% Discount
181 
182 	// PRICING INFO
183 	uint256 public constant YUPIE_PER_ETH_PRE_SALE = 3000;  								// 3000 YUPIE = 1 ETH
184 	uint256 public constant YUPIE_PER_ETH_SALE = 1000;  									// 1000 YUPIE = 1 ETH
185 	
186 	// ADDRESSES
187 	address public constant ownerAddress = 0x20C84e76C691e38E81EaE5BA60F655b8C388718D; 		// The owners address
188 
189 	// STATE INFO	
190 	bool public allowInvestment = true;														// Flag to change if transfering is allowed
191 	uint256 public totalWEIInvested = 0; 													// Total WEI invested
192 	uint256 public totalYUPIESAllocated = 0;												// Total YUPIES allocated
193 	mapping (address => uint256) public WEIContributed; 									// Total WEI Per Account
194 
195 
196 	// INITIALIZATIONS FUNCTION
197 	function YupieToken() {
198 		require(msg.sender == ownerAddress);
199 
200 		totalSupply = 631*1000000*1000000000000000000; 										// MAX TOTAL YUPIES 631 million
201 		uint256 totalYUPIESReserved = totalSupply.mul(55).div(100);							// 55% reserved for Crowdholding
202 		maxPresaleSupply = totalSupply*8/1000 + totalYUPIESReserved; 						// MAX TOTAL DURING PRESALE (0.8% of MAXTOTALSUPPLY)
203 
204 		balances[msg.sender] = totalYUPIESReserved;
205 		totalYUPIESAllocated = totalYUPIESReserved;				
206 	}
207 
208 
209 	// FALL BACK FUNCTION TO ALLOW ETHER DONATIONS
210 	function() payable {
211 
212 		require(allowInvestment);
213 
214 		// Smallest investment is 0.00001 ether
215 		uint256 amountOfWei = msg.value;
216 		require(amountOfWei >= 10000000000000);
217 
218 		uint256 amountOfYUPIE = 0;
219 		uint256 absLowTimeBonusLimit = 0;
220 		uint256 absMidTimeBonusLimit = 0;
221 		uint256 absHighTimeBonusLimit = 0;
222 		uint256 totalYUPIEAvailable = 0;
223 
224 		// Investment periods
225 		if (block.timestamp > preSaleStartTime && block.timestamp < preSaleEndTime) {
226 			// Pre-sale ICO
227 			amountOfYUPIE = amountOfWei.mul(YUPIE_PER_ETH_PRE_SALE);
228 			absLowTimeBonusLimit = preSaleStartTime + lowTimeBonusLimit;
229 			absMidTimeBonusLimit = preSaleStartTime + midTimeBonusLimit;
230 			absHighTimeBonusLimit = preSaleStartTime + highTimeBonusLimit;
231 			totalYUPIEAvailable = maxPresaleSupply - totalYUPIESAllocated;
232 		} else if (block.timestamp > saleStartTime && block.timestamp < saleEndTime) {
233 			// ICO
234 			amountOfYUPIE = amountOfWei.mul(YUPIE_PER_ETH_SALE);
235 			absLowTimeBonusLimit = saleStartTime + lowTimeBonusLimit;
236 			absMidTimeBonusLimit = saleStartTime + midTimeBonusLimit;
237 			absHighTimeBonusLimit = saleStartTime + highTimeBonusLimit;
238 			totalYUPIEAvailable = totalSupply - totalYUPIESAllocated;
239 		} else {
240 			// Invalid investment period
241 			revert();
242 		}
243 
244 		// Check that YUPIES calculated greater than zero
245 		assert(amountOfYUPIE > 0);
246 
247 		// Apply Bonuses
248 		if (amountOfWei >= highEtherBonusLimit) {
249 			amountOfYUPIE = amountOfYUPIE.mul(highEtherBonusValue).div(100);
250 		} else if (amountOfWei >= midEtherBonusLimit) {
251 			amountOfYUPIE = amountOfYUPIE.mul(midEtherBonusValue).div(100);
252 		} else if (amountOfWei >= lowEtherBonusLimit) {
253 			amountOfYUPIE = amountOfYUPIE.mul(lowEtherBonusValue).div(100);
254 		}
255 		if (block.timestamp >= absLowTimeBonusLimit) {
256 			amountOfYUPIE = amountOfYUPIE.mul(lowTimeBonusValue).div(100);
257 		} else if (block.timestamp >= absMidTimeBonusLimit) {
258 			amountOfYUPIE = amountOfYUPIE.mul(midTimeBonusValue).div(100);
259 		} else if (block.timestamp >= absHighTimeBonusLimit) {
260 			amountOfYUPIE = amountOfYUPIE.mul(highTimeBonusValue).div(100);
261 		}
262 
263 		// Max sure it doesn't exceed remaining supply
264 		assert(amountOfYUPIE <= totalYUPIEAvailable);
265 
266 		// Update total YUPIE balance
267 		totalYUPIESAllocated = totalYUPIESAllocated + amountOfYUPIE;
268 
269 		// Update user YUPIE balance
270 		uint256 balanceSafe = balances[msg.sender].add(amountOfYUPIE);
271 		balances[msg.sender] = balanceSafe;
272 
273 		// Update total WEI Invested
274 		totalWEIInvested = totalWEIInvested.add(amountOfWei);
275 
276 		// Update total WEI Invested by account
277 		uint256 contributedSafe = WEIContributed[msg.sender].add(amountOfWei);
278 		WEIContributed[msg.sender] = contributedSafe;
279 
280 		// CHECK VALUES
281 		assert(totalYUPIESAllocated <= totalSupply);
282 		assert(totalYUPIESAllocated > 0);
283 		assert(balanceSafe > 0);
284 		assert(totalWEIInvested > 0);
285 		assert(contributedSafe > 0);
286 
287 		// CREATE EVENT FOR SENDER
288 		CreatedYUPIE(msg.sender, amountOfYUPIE);
289 	}
290 	
291 	
292 	// CHANGE PARAMETERS METHODS
293 	function transferEther(address addressToSendTo, uint256 value) {
294 		require(msg.sender == ownerAddress);
295 		addressToSendTo.transfer(value);
296 	}	
297 	function changeAllowInvestment(bool _allowInvestment) {
298 		require(msg.sender == ownerAddress);
299 		allowInvestment = _allowInvestment;
300 	}
301 	function changeSaleTimes(uint256 _saleStartTime, uint256 _saleEndTime) {
302 		require(msg.sender == ownerAddress);
303 		saleStartTime = _saleStartTime;
304 		saleEndTime	= _saleEndTime;
305 	}
306 	function changeEtherBonuses(uint256 _lowEtherBonusLimit, uint256 _lowEtherBonusValue, uint256 _midEtherBonusLimit, uint256 _midEtherBonusValue, uint256 _highEtherBonusLimit, uint256 _highEtherBonusValue) {
307 		require(msg.sender == ownerAddress);
308 		lowEtherBonusLimit = _lowEtherBonusLimit;
309 		lowEtherBonusValue = _lowEtherBonusValue;
310 		midEtherBonusLimit = _midEtherBonusLimit;
311 		midEtherBonusValue = _midEtherBonusValue;
312 		highEtherBonusLimit = _highEtherBonusLimit;
313 		highEtherBonusValue = _highEtherBonusValue;
314 	}
315 	function changeTimeBonuses(uint256 _highTimeBonusLimit, uint256 _highTimeBonusValue, uint256 _midTimeBonusLimit, uint256 _midTimeBonusValue, uint256 _lowTimeBonusLimit, uint256 _lowTimeBonusValue) {
316 		require(msg.sender == ownerAddress);
317 		highTimeBonusLimit = _highTimeBonusLimit;
318 		highTimeBonusValue = _highTimeBonusValue;
319 		midTimeBonusLimit = _midTimeBonusLimit;
320 		midTimeBonusValue = _midTimeBonusValue;
321 		lowTimeBonusLimit = _lowTimeBonusLimit;
322 		lowTimeBonusValue = _lowTimeBonusValue;
323 	}
324 
325 }