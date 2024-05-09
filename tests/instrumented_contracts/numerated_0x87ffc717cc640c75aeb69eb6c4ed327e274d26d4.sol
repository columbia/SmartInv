1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender)
22     public view returns (uint256);
23 
24   function transferFrom(address from, address to, uint256 value)
25     public returns (bool);
26 
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 contract Ownable {
36 
37     address public owner;
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner() {                                                  // to ensure only owner can manipulate a wallet
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));                                    // to ensure the owner's address isn't an uninitialised address, "0x0"
50         owner = newOwner;
51     }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (a == 0) {
68       return 0;
69     }
70 
71     c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return a / b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 contract Coingrid is ERC20, Ownable {
105 	string public name;
106 	string public symbol;
107 	uint8 public decimals;
108 
109 	address public crowdsale;
110 
111 	bool public paused;
112 
113 	using SafeMath for uint256;
114 
115 	mapping(address => uint256) balances;
116 	mapping (address => mapping (address => uint256)) internal allowed;
117 
118 	event Burn(address indexed burner, uint256 value);
119 
120 	uint256 totalSupply_;
121 
122 	modifier canMove() {
123 		require(paused == false || msg.sender == crowdsale);
124 		_;
125 	}
126 
127 	constructor() public {
128 		totalSupply_ = 100 * 1000000 * 1 ether; // 18 decimals, 100 Million CGT
129 		name = "Coingrid";
130 		symbol = "CGT";
131 		decimals = 18;
132 		paused = true;
133 		balances[msg.sender] = totalSupply_;
134 		emit Transfer(0x0, msg.sender, totalSupply_);
135 	}
136 
137 	function totalSupply() public view returns (uint256) {
138 		return totalSupply_;
139 	}
140 
141 	/**
142 	* @dev Transfer token for a specified address
143 	* @param _to The address to transfer to.
144 	* @param _value The amount to be transferred.
145 	*/
146 	function transfer(address _to, uint256 _value) public canMove returns (bool) {
147 		require(_value <= balances[msg.sender]);
148 		require(_to != address(0));
149 
150 		balances[msg.sender] = balances[msg.sender].sub(_value);
151 		balances[_to] = balances[_to].add(_value);
152 		emit Transfer(msg.sender, _to, _value);
153 		return true;
154 	}
155 
156 	/**
157 	* @dev Gets the balance of the specified address.
158 	* @param _owner The address to query the the balance of.
159 	* @return An uint256 representing the amount owned by the passed address.
160 	*/
161 	function balanceOf(address _owner) public view returns (uint256) {
162 		return balances[_owner];
163 	}
164 
165 	/**
166 	 * @dev Transfer tokens from one address to another
167 	 * @param _from address The address which you want to send tokens from
168 	 * @param _to address The address which you want to transfer to
169 	 * @param _value uint256 the amount of tokens to be transferred
170 	 */
171 	function transferFrom(
172 		address _from,
173 		address _to,
174 		uint256 _value
175 	)
176 		public
177 		canMove
178 		returns (bool)
179 	{
180 		require(_value <= balances[_from]);
181 		require(_value <= allowed[_from][msg.sender]);
182 		require(_to != address(0));
183 
184 		balances[_from] = balances[_from].sub(_value);
185 		balances[_to] = balances[_to].add(_value);
186 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187 		emit Transfer(_from, _to, _value);
188 		return true;
189 	}
190 
191 	/**
192 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
194 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197 	 * @param _spender The address which will spend the funds.
198 	 * @param _value The amount of tokens to be spent.
199 	 */
200 	function approve(address _spender, uint256 _value) public returns (bool) {
201 		allowed[msg.sender][_spender] = _value;
202 		emit Approval(msg.sender, _spender, _value);
203 		return true;
204 	}
205 
206 	/**
207 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
208 	 * @param _owner address The address which owns the funds.
209 	 * @param _spender address The address which will spend the funds.
210 	 * @return A uint256 specifying the amount of tokens still available for the spender.
211 	 */
212 	function allowance(
213 		address _owner,
214 		address _spender
215 	 )
216 		public
217 		view
218 		returns (uint256)
219 	{
220 		return allowed[_owner][_spender];
221 	}
222 
223 	/**
224 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
225 	 * approve should be called when allowed[_spender] == 0. To increment
226 	 * allowed value is better to use this function to avoid 2 calls (and wait until
227 	 * the first transaction is mined)
228 	 * From MonolithDAO Token.sol
229 	 * @param _spender The address which will spend the funds.
230 	 * @param _addedValue The amount of tokens to increase the allowance by.
231 	 */
232 	function increaseApproval(
233 		address _spender,
234 		uint256 _addedValue
235 	)
236 		public
237 		returns (bool)
238 	{
239 		allowed[msg.sender][_spender] = (
240 			allowed[msg.sender][_spender].add(_addedValue));
241 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242 		return true;
243 	}
244 
245 	/**
246 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
247 	 * approve should be called when allowed[_spender] == 0. To decrement
248 	 * allowed value is better to use this function to avoid 2 calls (and wait until
249 	 * the first transaction is mined)
250 	 * From MonolithDAO Token.sol
251 	 * @param _spender The address which will spend the funds.
252 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
253 	 */
254 	function decreaseApproval(
255 		address _spender,
256 		uint256 _subtractedValue
257 	)
258 		public
259 		returns (bool)
260 	{
261 		uint256 oldValue = allowed[msg.sender][_spender];
262 		if (_subtractedValue >= oldValue) {
263 			allowed[msg.sender][_spender] = 0;
264 		} else {
265 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266 		}
267 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268 		return true;
269 	}
270 
271 	/**
272 	  * @dev Burns a specific amount of tokens.
273 	  * @param _value The amount of token to be burned.
274 	*/
275 	function burn(uint256 _value) onlyOwner public {
276 		_burn(msg.sender, _value);
277 	}
278 
279 	function _burn(address _who, uint256 _value) internal {
280 		require(_value <= balances[_who]);
281 		// no need to require value <= totalSupply, since that would imply the
282 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284 		balances[_who] = balances[_who].sub(_value);
285 		totalSupply_ = totalSupply_.sub(_value);
286 		emit Burn(_who, _value);
287 		emit Transfer(_who, address(0), _value);
288 	}
289 
290 	function pause() onlyOwner public {
291 		paused = true;
292 	}
293 
294 	function unpause() onlyOwner public {
295 		paused = false;
296 	}
297 
298 	function setCrowdsale(address _crowdsale) onlyOwner public {
299 		crowdsale = _crowdsale;
300 	}
301 
302 	/// @dev This will be invoked by the owner, when owner wants to rescue tokens
303 	/// @param token Token which will we rescue to the owner from the contract
304 	function recoverTokens(ERC20 token) onlyOwner public {
305 		token.transfer(owner, tokensToBeReturned(token));
306 	}
307 
308 	/// @dev Interface function, can be overwritten by the superclass
309 	/// @param token Token which balance we will check and return
310 	/// @return The amount of tokens (in smallest denominator) the contract owns
311 	function tokensToBeReturned(ERC20 token) public view returns (uint) {
312 		return token.balanceOf(this);
313 	}
314 
315 }