1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 contract TTTToken is ERC20, Ownable {
113 	using SafeMath for uint;
114 
115 	string public constant name = "The Tip Token";
116 	string public constant symbol = "TTT";
117 
118 	uint8 public decimals = 18;
119 
120 	mapping(address=>uint256) balances;
121 	mapping(address=>mapping(address=>uint256)) allowed;
122 
123 	// Supply variables
124 	uint256 public totalSupply_;
125 	uint256 public presaleSupply;
126 	uint256 public crowdsaleSupply;
127 	uint256 public privatesaleSupply;
128 	uint256 public airdropSupply;
129 	uint256 public teamSupply;
130 	uint256 public ecoSupply;
131 
132 	// Vest variables
133 	uint256 public firstVestStartsAt;
134 	uint256 public secondVestStartsAt;
135 	uint256 public firstVestAmount;
136 	uint256 public secondVestAmount;
137 	uint256 public currentVestedAmount;
138 
139 	uint256 public crowdsaleBurnAmount;
140 
141 	// Token sale addresses
142 	address public privatesaleAddress;
143 	address public presaleAddress;
144 	address public crowdsaleAddress;
145 	address public teamSupplyAddress;
146 	address public ecoSupplyAddress;
147 	address public crowdsaleAirdropAddress;
148 	address public crowdsaleBurnAddress;
149 	address public tokenSaleAddress;
150 
151 	// Token sale state variables
152 	bool public privatesaleFinalized;
153 	bool public presaleFinalized;
154 	bool public crowdsaleFinalized;
155 
156 	event PrivatesaleFinalized(uint tokensRemaining);
157 	event PresaleFinalized(uint tokensRemaining);
158 	event CrowdsaleFinalized(uint tokensRemaining);
159 	event Burn(address indexed burner, uint256 value);
160 	event TokensaleAddressSet(address tSeller, address from);
161 
162 	modifier onlyTokenSale() {
163 		require(msg.sender == tokenSaleAddress);
164 		_;
165 	}
166 
167 	modifier canItoSend() {
168 		require(crowdsaleFinalized == true || (crowdsaleFinalized == false && msg.sender == ecoSupplyAddress));
169 		_;
170 	}
171 
172 	function TTTToken() {
173 		// 600 million total supply divided into
174 		//		90 million to privatesale address
175 		//		120 million to presale address
176 		//		180 million to crowdsale address
177 		//		90 million to eco supply address
178 		//		120 million to team supply address
179 		totalSupply_ = 600000000 * 10**uint(decimals);
180 		privatesaleSupply = 90000000 * 10**uint(decimals);
181 		presaleSupply = 120000000 * 10**uint(decimals);
182 		crowdsaleSupply = 180000000 * 10**uint(decimals);
183 		ecoSupply = 90000000 * 10**uint(decimals);
184 		teamSupply = 120000000 * 10**uint(decimals);
185 
186 		firstVestAmount = teamSupply.div(2);
187 		secondVestAmount = firstVestAmount;
188 		currentVestedAmount = 0;
189 
190 		privatesaleAddress = 0xE67EE1935bf160B48BA331074bb743630ee8aAea;
191 		presaleAddress = 0x4A41D67748D16aEB12708E88270d342751223870;
192 		crowdsaleAddress = 0x2eDf855e5A90DF003a5c1039bEcf4a721C9c3f9b;
193 		teamSupplyAddress = 0xc4146EcE2645038fbccf79784a6DcbE3C6586c03;
194 		ecoSupplyAddress = 0xdBA99B92a18930dA39d1e4B52177f84a0C27C8eE;
195 		crowdsaleAirdropAddress = 0x6BCb947a8e8E895d1258C1b2fc84A5d22632E6Fa;
196 		crowdsaleBurnAddress = 0xDF1CAf03FA89AfccdAbDd55bAF5C9C4b9b1ceBaB;
197 
198 		addToBalance(privatesaleAddress, privatesaleSupply);
199 		addToBalance(presaleAddress, presaleSupply);
200 		addToBalance(crowdsaleAddress, crowdsaleSupply);
201 		addToBalance(teamSupplyAddress, teamSupply);
202 		addToBalance(ecoSupplyAddress, ecoSupply);
203 
204 		// 12/01/2018 @ 12:00am (UTC)
205 		firstVestStartsAt = 1543622400;
206 		// 06/01/2019 @ 12:00am (UTC)
207 		secondVestStartsAt = 1559347200;
208 	}
209 
210 	// Transfer
211 	function transfer(address _to, uint256 _amount) public canItoSend returns (bool success) {
212 		require(balanceOf(msg.sender) >= _amount);
213 		addToBalance(_to, _amount);
214 		decrementBalance(msg.sender, _amount);
215 		Transfer(msg.sender, _to, _amount);
216 		return true;
217 	}
218 
219 	// Transfer from one address to another
220 	function transferFrom(address _from, address _to, uint256 _amount) public canItoSend returns (bool success) {
221 		require(allowance(_from, msg.sender) >= _amount);
222 		decrementBalance(_from, _amount);
223 		addToBalance(_to, _amount);
224 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
225 		Transfer(_from, _to, _amount);
226 		return true;
227 	}
228 
229 	// Function for token sell contract to call on transfers
230 	function transferFromTokenSell(address _to, address _from, uint256 _amount) external onlyTokenSale returns (bool success) {
231 		require(_amount > 0);
232 		require(_to != 0x0);
233 		require(balanceOf(_from) >= _amount);
234 		decrementBalance(_from, _amount);
235 		addToBalance(_to, _amount);
236 		Transfer(_from, _to, _amount);
237 		return true;
238 	}
239 
240 	// Approve another address a certain amount of TTT
241 	function approve(address _spender, uint256 _value) public returns (bool success) {
242 		require((_value == 0) || (allowance(msg.sender, _spender) == 0));
243 		allowed[msg.sender][_spender] = _value;
244 		Approval(msg.sender, _spender, _value);
245 		return true;
246 	}
247 
248 	// Get an address's TTT allowance
249 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
250 		return allowed[_owner][_spender];
251 	}
252 
253 	// Get TTT balance of an address
254 	function balanceOf(address _owner) public view returns (uint256 balance) {
255 		return balances[_owner];
256 	}
257 
258 	// Return total supply
259 	function totalSupply() public view returns (uint256 totalSupply) {
260 		return totalSupply_;
261 	}
262 
263 	// Set the tokenSell contract address, can only be set once
264 	function setTokenSaleAddress(address _tokenSaleAddress) external onlyOwner {
265 		require(tokenSaleAddress == 0x0);
266 		tokenSaleAddress = _tokenSaleAddress;
267 		TokensaleAddressSet(tokenSaleAddress, msg.sender);
268 	}
269 
270 	// Finalize private. If there are leftover TTT, overflow to presale
271 	function finalizePrivatesale() external onlyTokenSale returns (bool success) {
272 		require(privatesaleFinalized == false);
273 		uint256 amount = balanceOf(privatesaleAddress);
274 		if (amount != 0) {
275 			addToBalance(presaleAddress, amount);
276 			decrementBalance(privatesaleAddress, amount);
277 		}
278 		privatesaleFinalized = true;
279 		PrivatesaleFinalized(amount);
280 		return true;
281 	}
282 
283 	// Finalize presale. If there are leftover TTT, overflow to crowdsale
284 	function finalizePresale() external onlyTokenSale returns (bool success) {
285 		require(presaleFinalized == false && privatesaleFinalized == true);
286 		uint256 amount = balanceOf(presaleAddress);
287 		if (amount != 0) {
288 			addToBalance(crowdsaleAddress, amount);
289 			decrementBalance(presaleAddress, amount);
290 		}
291 		presaleFinalized = true;
292 		PresaleFinalized(amount);
293 		return true;
294 	}
295 
296 	// Finalize crowdsale. If there are leftover TTT, add 10% to airdrop, 20% to ecosupply, burn 70% at a later date
297 	function finalizeCrowdsale(uint256 _burnAmount, uint256 _ecoAmount, uint256 _airdropAmount) external onlyTokenSale returns(bool success) {
298 		require(presaleFinalized == true && crowdsaleFinalized == false);
299 		uint256 amount = balanceOf(crowdsaleAddress);
300 		assert((_burnAmount.add(_ecoAmount).add(_airdropAmount)) == amount);
301 		if (amount > 0) {
302 			crowdsaleBurnAmount = _burnAmount;
303 			addToBalance(ecoSupplyAddress, _ecoAmount);
304 			addToBalance(crowdsaleBurnAddress, crowdsaleBurnAmount);
305 			addToBalance(crowdsaleAirdropAddress, _airdropAmount);
306 			decrementBalance(crowdsaleAddress, amount);
307 			assert(balanceOf(crowdsaleAddress) == 0);
308 		}
309 		crowdsaleFinalized = true;
310 		CrowdsaleFinalized(amount);
311 		return true;
312 	}
313 
314 	/**
315 	* @dev Burns a specific amount of tokens. * added onlyOwner, as this will only happen from owner, if there are crowdsale leftovers
316 	* @param _value The amount of token to be burned.
317 	* @dev imported from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
318 	*/
319 	function burn(uint256 _value) public onlyOwner {
320 		require(_value <= balances[msg.sender]);
321 		require(crowdsaleFinalized == true);
322 		// no need to require value <= totalSupply, since that would imply the
323 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
324 
325 		address burner = msg.sender;
326 		balances[burner] = balances[burner].sub(_value);
327 		totalSupply_ = totalSupply_.sub(_value);
328 		Burn(burner, _value);
329 		Transfer(burner, address(0), _value);
330 	}
331 
332 	// Transfer tokens from the vested address. 50% available 12/01/2018, the rest available 06/01/2019
333 	function transferFromVest(uint256 _amount) public onlyOwner {
334 		require(block.timestamp > firstVestStartsAt);
335 		require(crowdsaleFinalized == true);
336 		require(_amount > 0);
337 		if(block.timestamp > secondVestStartsAt) {
338 			// all tokens available for vest withdrawl
339 			require(_amount <= teamSupply);
340 			require(_amount <= balanceOf(teamSupplyAddress));
341 		} else {
342 			// only first vest available
343 			require(_amount <= (firstVestAmount - currentVestedAmount));
344 			require(_amount <= balanceOf(teamSupplyAddress));
345 		}
346 		currentVestedAmount = currentVestedAmount.add(_amount);
347 		addToBalance(msg.sender, _amount);
348 		decrementBalance(teamSupplyAddress, _amount);
349 		Transfer(teamSupplyAddress, msg.sender, _amount);
350 	}
351 
352 	// Add to balance
353 	function addToBalance(address _address, uint _amount) internal {
354 		balances[_address] = balances[_address].add(_amount);
355 	}
356 
357 	// Remove from balance
358 	function decrementBalance(address _address, uint _amount) internal {
359 		balances[_address] = balances[_address].sub(_amount);
360 	}
361 
362 }