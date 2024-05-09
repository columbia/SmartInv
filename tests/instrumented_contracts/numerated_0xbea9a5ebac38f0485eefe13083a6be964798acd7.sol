1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9 	/**
10 	* @dev Multiplies two numbers, throws on overflow.
11 	*/
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13 		if (a == 0) {
14 			return 0;
15 		}
16 		uint256 c = a * b;
17 		assert(c / a == b);
18 		return c;
19 	}
20 
21 	/**
22 	* @dev Integer division of two numbers, truncating the quotient.
23 	*/
24 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 		// assert(b > 0); // Solidity automatically throws when dividing by 0
26 		uint256 c = a / b;
27 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 		return c;
29 	}
30 
31 	/**
32 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33 	*/
34 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35 		assert(b <= a);
36 		return a - b;
37 	}
38 
39 	/**
40 	* @dev Adds two numbers, throws on overflow.
41 	*/
42 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
43 		uint256 c = a + b;
44 		assert(c >= a);
45 		return c;
46 	}
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55 	address public owner;
56 
57 
58 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61 	/**
62 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63 	 * account.
64 	 */
65 	function Ownable() public {
66 		owner = msg.sender;
67 	}
68 
69 	/**
70 	 * @dev Throws if called by any account other than the owner.
71 	 */
72 	modifier onlyOwner() {
73 		require(msg.sender == owner);
74 		_;
75 	}
76 
77 	/**
78 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
79 	 * @param newOwner The address to transfer ownership to.
80 	 */
81 	function transferOwnership(address newOwner) public onlyOwner {
82 		require(newOwner != address(0));
83 		OwnershipTransferred(owner, newOwner);
84 		owner = newOwner;
85 	}
86 
87 }
88 
89 /**
90 *Standard ERC20 Token interface
91 */
92 contract ERC20 {
93 	// these functions aren't abstract since the compiler emits automatically generated getter functions as external
94 
95 	function totalSupply() public view returns (uint256);
96 	function balanceOf(address who) public view returns (uint256);
97 	function transfer(address to, uint256 value) public returns (bool);
98 	event Transfer(address indexed from, address indexed to, uint256 value);
99 
100 	function allowance(address owner, address spender) public view returns (uint256);
101 	function transferFrom(address from, address to, uint256 value) public returns (bool);
102 	function approve(address spender, uint256 value) public returns (bool);
103 	event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105 }
106 
107 
108 /**
109 * @title Standard ERC20 token
110 *
111 * @dev Implementation of the basic standard token.
112 * @dev https://github.com/ethereum/EIPs/issues/20
113 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114 */
115 contract StandardToken is ERC20 {
116 
117 	using SafeMath for uint256;
118 
119 	mapping(address => uint256) balances;
120 	mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123 	uint256 totalSupply_;
124 
125 	/**
126 	* @dev total number of tokens in existence
127 	*/
128 	function totalSupply() public view returns (uint256) {
129 		return totalSupply_;
130 	}
131 
132 	/**
133 	* @dev transfer token for a specified address
134 	* @param _to The address to transfer to.
135 	* @param _value The amount to be transferred.
136 	*/
137 	function transfer(address _to, uint256 _value) public returns (bool) {
138 		require(_to != address(0));
139 		require(_value <= balances[msg.sender]);
140 
141 		// SafeMath.sub will throw if there is not enough balance.
142 		balances[msg.sender] = balances[msg.sender].sub(_value);
143 		balances[_to] = balances[_to].add(_value);
144 		Transfer(msg.sender, _to, _value);
145 		return true;
146 	}
147 
148 	/**
149 	* @dev Gets the balance of the specified address.
150 	* @param _owner The address to query the the balance of.
151 	* @return An uint256 representing the amount owned by the passed address.
152 	*/
153 	function balanceOf(address _owner) public view returns (uint256 balance) {
154 		return balances[_owner];
155 	}
156 
157 
158 	/**
159 	* @dev Transfer tokens from one address to another
160 	* @param _from address The address which you want to send tokens from
161 	* @param _to address The address which you want to transfer to
162 	* @param _value uint256 the amount of tokens to be transferred
163 	*/
164 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165 		require(_to != address(0));
166 		require(_value <= balances[_from]);
167 		require(_value <= allowed[_from][msg.sender]);
168 
169 		balances[_from] = balances[_from].sub(_value);
170 		balances[_to] = balances[_to].add(_value);
171 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172 		Transfer(_from, _to, _value);
173 		return true;
174 	}
175 
176 	/**
177 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178 	*
179 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
180 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183 	* @param _spender The address which will spend the funds.
184 	* @param _value The amount of tokens to be spent.
185 	*/
186 	function approve(address _spender, uint256 _value) public returns (bool) {
187 		allowed[msg.sender][_spender] = _value;
188 		Approval(msg.sender, _spender, _value);
189 		return true;
190 	}
191 
192 	/**
193 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
194 	* @param _owner address The address which owns the funds.
195 	* @param _spender address The address which will spend the funds.
196 	* @return A uint256 specifying the amount of tokens still available for the spender.
197 	*/
198 	function allowance(address _owner, address _spender) public view returns (uint256) {
199 		return allowed[_owner][_spender];
200 	}
201 
202 	/**
203 	* @dev Increase the amount of tokens that an owner allowed to a spender.
204 	*
205 	* approve should be called when allowed[_spender] == 0. To increment
206 	* allowed value is better to use this function to avoid 2 calls (and wait until
207 	* the first transaction is mined)
208 	* From MonolithDAO Token.sol
209 	* @param _spender The address which will spend the funds.
210 	* @param _addedValue The amount of tokens to increase the allowance by.
211 	*/
212 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215 		return true;
216 	}
217 
218 	/**
219 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
220 	*
221 	* approve should be called when allowed[_spender] == 0. To decrement
222 	* allowed value is better to use this function to avoid 2 calls (and wait until
223 	* the first transaction is mined)
224 	* From MonolithDAO Token.sol
225 	* @param _spender The address which will spend the funds.
226 	* @param _subtractedValue The amount of tokens to decrease the allowance by.
227 	*/
228 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229 		uint oldValue = allowed[msg.sender][_spender];
230 		if (_subtractedValue > oldValue) {
231 				allowed[msg.sender][_spender] = 0;
232 		} else {
233 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234 		}
235 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236 		return true;
237 	}
238 }
239 
240 
241 /**
242 * @title CybCoin ERC20 token
243 *
244 */
245 contract CYBC is StandardToken, Ownable{
246 	using SafeMath for uint256;
247 
248 	string public name = "CybCoin";
249 	string public symbol = "CYBC";
250 	uint8 public constant decimals = 8;
251 
252 	uint256 private _N = (10 ** uint256(decimals));
253 	uint256 public INITIAL_SUPPLY = _N.mul(1000000000);
254 	uint256 public endTime = 1530403200;
255 	uint256 public cap = _N.mul(200000000);
256 	uint256 public rate = 6666;
257 	uint256 public totalTokenSales = 0;
258 
259 	mapping(address => uint8) public ACL;
260 	mapping (address => string) public keys;
261 	event LogRegister (address _user, string _key);
262 
263 	address public wallet = 0x7a0035EA0F2c08aF87Cc863D860d669505EA0b20;
264 	address public accountS = 0xe0b91C928DbC439399ed6babC4e6A0BeC2F048C7;
265 	address public accountA = 0x98207620eC7346471C98DDd1A4C7c75d344C344f;
266 	address public accountB = 0x6C7A09b9283c364a7Dff11B4fb4869B211D21fCb;
267 	address public accountC = 0x8df62d0B4a8b1131119527a148A9C54D4cC7F91D;
268 
269 	/**
270 	* @dev Constructor that gives msg.sender all of existing tokens.
271 	*/
272 	function CYBC() public {
273 		totalSupply_ = INITIAL_SUPPLY;
274 
275 		balances[accountS] = _N.mul(200000000);
276 		balances[accountA] = _N.mul(300000000);
277 		balances[accountB] = _N.mul(300000000);
278 		balances[accountC] = _N.mul(200000000);
279 
280 		ACL[wallet]=1;
281 		ACL[accountS]=1;
282 		ACL[accountA]=1;
283 		ACL[accountB]=1;
284 		ACL[accountC]=1;
285 	}
286 
287 	function transfer(address _to, uint256 _value) public isSaleClose returns (bool) {
288 		require(ACL[msg.sender] != 2);
289 		require(ACL[_to] != 2);
290 
291 		return super.transfer(_to, _value);
292 	}
293 
294 	function transferFrom(address _from, address _to, uint256 _value)  public isSaleClose returns (bool) {
295 		require(ACL[msg.sender] != 2);
296 		require(ACL[_from] != 2);
297 		require(ACL[_to] != 2);
298 
299 		return super.transferFrom(_from, _to, _value);
300 	}
301 
302 	function setRate(uint256 _rate)  public onlyOwner {
303 		require(_rate > 0);
304 		rate = _rate;
305 	}
306 
307 	function () public payable {
308 		ethSale(msg.sender);
309 	}
310 
311 	function ethSale(address _beneficiary) public isSaleOpen payable {
312 		require(_beneficiary != address(0));
313 		require(msg.value != 0);
314 		uint256 ethInWei = msg.value;
315 		uint256 tokenWeiAmount = ethInWei.div(10**10);
316 		uint256 tokens = tokenWeiAmount.mul(rate);
317 		totalTokenSales = totalTokenSales.add(tokens);
318 		wallet.transfer(ethInWei);
319 		balances[accountS] = balances[accountS].sub(tokens);
320 		balances[_beneficiary] = balances[_beneficiary].add(tokens);
321 		Transfer(accountS, _beneficiary, tokens);
322 	}
323 
324 	function cashSale(address _beneficiary, uint256 _tokens) public isSaleOpen onlyOwner {
325 		require(_beneficiary != address(0));
326 		require(_tokens != 0);
327 		totalTokenSales = totalTokenSales.add(_tokens);
328 		balances[accountS] = balances[accountS].sub(_tokens);
329 		balances[_beneficiary] = balances[_beneficiary].add(_tokens);
330 		Transfer(accountS, _beneficiary, _tokens);
331 	}
332 
333 	modifier isSaleOpen() {
334 		require(totalTokenSales < cap);
335 		require(now < endTime);
336 		_;
337 	}
338 
339 	modifier isSaleClose() {
340 		if( ACL[msg.sender] != 1 )  {
341 			require(totalTokenSales >= cap || now >= endTime);
342 		}
343 		_;
344 	}
345 
346 	function setWallet(address addr) onlyOwner public {
347 		require(addr != address(0));
348 		wallet = addr;
349 	}
350 	function setAccountA(address addr) onlyOwner public {
351 		require(addr != address(0));
352 		accountA = addr;
353 	}
354 
355 	function setAccountB(address addr) onlyOwner public {
356 		require(addr != address(0));
357 		accountB = addr;
358 	}
359 
360 	function setAccountC(address addr) onlyOwner public {
361 		require(addr != address(0));
362 		accountC = addr;
363 	}
364 
365 	function setAccountS(address addr) onlyOwner public {
366 		require(addr != address(0));
367 		accountS = addr;
368 	}
369 
370 	function setACL(address addr,uint8 flag) onlyOwner public {
371 		require(addr != address(0));
372 		require(flag >= 0);
373 		require(flag <= 255);
374 		ACL[addr] = flag;
375 	}
376 
377 	function setName(string _name)  onlyOwner public {
378 		name = _name;
379 	}
380 
381 	function setSymbol(string _symbol) onlyOwner public {
382 		symbol = _symbol;
383 	}
384 
385 	function register(string _key) public {
386 		require(ACL[msg.sender] != 2);
387 		require(bytes(_key).length <= 128);
388 		keys[msg.sender] = _key;
389 		LogRegister(msg.sender, _key);
390 	}
391 
392 }