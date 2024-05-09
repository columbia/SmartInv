1 pragma solidity 0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     require(newOwner != owner);
61 
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 contract Whitelisted is Ownable {
69 
70 	// variables
71 	mapping (address => bool) public whitelist;
72 
73 	// events
74 	event WhitelistChanged(address indexed account, bool state);
75 
76 	// modifiers
77 
78 	// checkes if the address is whitelisted
79 	modifier isWhitelisted(address _addr) {
80 		require(whitelist[_addr] == true);
81 
82 		_;
83 	}
84 
85 	// methods
86 	function setWhitelist(address _addr, bool _state) onlyOwner external {
87 		require(_addr != address(0));
88 		require(whitelist[_addr] != _state);
89 
90 		whitelist[_addr] = _state;
91 
92 		WhitelistChanged(_addr, _state);
93 	}
94 
95 }
96 
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) public constant returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 contract BasicToken is ERC20Basic {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   /**
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value > 0);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public constant returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 contract BurnableToken is BasicToken {
137 	// events
138 	event Burn(address indexed burner, uint256 amount);
139 
140 	// reduce sender balance and Token total supply
141 	function burn(uint256 _value) public {
142 		balances[msg.sender] = balances[msg.sender].sub(_value);
143 		totalSupply = totalSupply.sub(_value);
144 
145 		Burn(msg.sender, _value);
146 	}
147 }
148 
149 contract FriendzToken is BurnableToken, Ownable {
150 
151 	// public variables
152 	mapping(address => uint256) public release_dates;
153 	mapping(address => uint256) public purchase_dates;
154 	mapping(address => uint256) public blocked_amounts;
155 	mapping (address => mapping (address => uint256)) public allowed;
156 	bool public free_transfer = false;
157 	uint256 public RELEASE_DATE = 1522540800; // 1th april 2018 00:00 UTC
158 
159 	// private variables
160 	address private co_owner;
161 	address private presale_holder = 0x1ea128767610c944Ff9a60E4A1Cbd0C88773c17c;
162 	address private ico_holder = 0xc1c643701803eca8DDfA2017547E8441516BE047;
163 	address private reserved_holder = 0x26226CfaB092C89eF3D79653D692Cc1425a0B907;
164 	address private wallet_holder = 0xBF0B56276e90fc4f0f1e2Ec66fa418E30E717215;
165 
166 	// ERC20 variables
167 	string public name;
168 	string public symbol;
169 	uint256 public decimals;
170 
171 	// constants
172 
173 	// events
174 	event Approval(address indexed owner, address indexed spender, uint256 value);
175 	event UpdatedBlockingState(address indexed to, uint256 purchase, uint256 end_date, uint256 value);
176 	event CoOwnerSet(address indexed owner);
177 	event ReleaseDateChanged(address indexed from, uint256 date);
178 
179 	function FriendzToken(string _name, string _symbol, uint256 _decimals, uint256 _supply) public {
180 		// safety checks
181 		require(_decimals > 0);
182 		require(_supply > 0);
183 
184 		// assign variables
185 		name = _name;
186 		symbol = _symbol;
187 		decimals = _decimals;
188 		totalSupply = _supply;
189 
190 		// assign the total supply to the owner
191 		balances[owner] = _supply;
192 	}
193 
194 	// modifiers
195 
196 	// checks if the address can transfer tokens
197 	modifier canTransfer(address _sender, uint256 _value) {
198 		require(_sender != address(0));
199 
200 		require(
201 			(free_transfer) ||
202 			canTransferBefore(_sender) ||
203 			canTransferIfLocked(_sender, _value)
204 	 	);
205 
206 	 	_;
207 	}
208 
209 	// check if we're in a free-transfter state
210 	modifier isFreeTransfer() {
211 		require(free_transfer);
212 
213 		_;
214 	}
215 
216 	// check if we're in non free-transfter state
217 	modifier isBlockingTransfer() {
218 		require(!free_transfer);
219 
220 		_;
221 	}
222 
223 	// functions
224 
225 	function canTransferBefore(address _sender) public view returns(bool) {
226 		return (
227 			_sender == owner ||
228 			_sender == presale_holder ||
229 			_sender == ico_holder ||
230 			_sender == reserved_holder ||
231 			_sender == wallet_holder
232 		);
233 	}
234 
235 	function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
236 		uint256 after_math = balances[_sender].sub(_value);
237 		return (
238 			now >= RELEASE_DATE &&
239 		    after_math >= getMinimumAmount(_sender)
240         );
241 	}
242 
243 	// set co-owner, can be set to 0
244 	function setCoOwner(address _addr) onlyOwner public {
245 		require(_addr != co_owner);
246 
247 		co_owner = _addr;
248 
249 		CoOwnerSet(_addr);
250 	}
251 
252 	// set release date
253 	function setReleaseDate(uint256 _date) onlyOwner public {
254 		require(_date > 0);
255 		require(_date != RELEASE_DATE);
256 
257 		RELEASE_DATE = _date;
258 
259 		ReleaseDateChanged(msg.sender, _date);
260 	}
261 
262 	// calculate the amount of tokens an address can use
263 	function getMinimumAmount(address _addr) constant public returns (uint256) {
264 		// if the address ha no limitations just return 0
265 		if(blocked_amounts[_addr] == 0x0)
266 			return 0x0;
267 
268 		// if the purchase date is in the future block all the tokens
269 		if(purchase_dates[_addr] > now){
270 			return blocked_amounts[_addr];
271 		}
272 
273 		uint256 alpha = uint256(now).sub(purchase_dates[_addr]); // absolute purchase date
274 		uint256 beta = release_dates[_addr].sub(purchase_dates[_addr]); // absolute token release date
275 		uint256 tokens = blocked_amounts[_addr].sub(alpha.mul(blocked_amounts[_addr]).div(beta)); // T - (α * T) / β
276 
277 		return tokens;
278 	}
279 
280 	// set blocking state to an address
281 	function setBlockingState(address _addr, uint256 _end, uint256 _value) isBlockingTransfer public {
282 		// only the onwer and the co-owner can call this function
283 		require(
284 			msg.sender == owner ||
285 			msg.sender == co_owner
286 		);
287 		require(_addr != address(0));
288 
289 		uint256 final_value = _value;
290 
291 		if(release_dates[_addr] != 0x0){
292 			// if it's not the first time this function is beign called for this address
293 			// update its information instead of setting them (add value to previous value)
294 			final_value = blocked_amounts[_addr].add(_value);
295 		}
296 
297 		release_dates[_addr] = _end;
298 		purchase_dates[_addr] = RELEASE_DATE;
299 		blocked_amounts[_addr] = final_value;
300 
301 		UpdatedBlockingState(_addr, _end, RELEASE_DATE, final_value);
302 	}
303 
304 	// all addresses can transfer tokens now
305 	function freeToken() public onlyOwner {
306 		free_transfer = true;
307 	}
308 
309 	// override function using canTransfer on the sender address
310 	function transfer(address _to, uint _value) canTransfer(msg.sender, _value) public returns (bool success) {
311 		return super.transfer(_to, _value);
312 	}
313 
314 	// transfer tokens from one address to another
315 	function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) public returns (bool success) {
316 		require(_from != address(0));
317 		require(_to != address(0));
318 
319 	    // SafeMath.sub will throw if there is not enough balance.
320 	    balances[_from] = balances[_from].sub(_value);
321 	    balances[_to] = balances[_to].add(_value);
322 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
323 
324 	    // this event comes from BasicToken.sol
325 	    Transfer(_from, _to, _value);
326 
327 	    return true;
328 	}
329 
330 	// erc20 functions
331   	function approve(address _spender, uint256 _value) public returns (bool) {
332 	 	require(_value == 0 || allowed[msg.sender][_spender] == 0);
333 
334 	 	allowed[msg.sender][_spender] = _value;
335 	 	Approval(msg.sender, _spender, _value);
336 
337 	 	return true;
338   	}
339 
340 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
341     	return allowed[_owner][_spender];
342   	}
343 
344 	/**
345 	* approve should be called when allowed[_spender] == 0. To increment
346 	* allowed value is better to use this function to avoid 2 calls (and wait until
347 	* the first transaction is mined)
348 	* From MonolithDAO Token.sol
349 	*/
350 	function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
351 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
352 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353 		return true;
354 	}
355 
356 	function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
357 		uint256 oldValue = allowed[msg.sender][_spender];
358 		if (_subtractedValue >= oldValue) {
359 			allowed[msg.sender][_spender] = 0;
360 		} else {
361 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362 		}
363 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364 		return true;
365 	}
366 
367 }