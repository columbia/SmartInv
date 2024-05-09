1 pragma solidity ^0.5.9;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 	/**
8 	 * @dev Multiplies two numbers, throws on overflow.
9 	 */
10 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 		if (a == 0) {
12 		  return 0;
13 		}
14 		uint256 c = a * b;
15 		assert(c / a == b);
16 		return c;
17 	}
18 	/**
19 	 * @dev Integer division of two numbers, truncating the quotient.
20 	 */
21 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
22 		uint256 c = a / b;
23 		return c;
24 	}
25 	/**
26 	 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27 	 */
28 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29 		assert(b <= a);
30 		return a - b;
31 	}
32 	/**
33 	 * @dev Adds two numbers, throws on overflow.
34 	 */
35 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
36 		uint256 c = a + b;
37 		assert(c >= a);
38 		return c;
39 	}
40 }
41 
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  */
46 contract ERC20Basic {
47 	function totalSupply() public view returns (uint256);
48 	function balanceOf(address who) public view returns (uint256);
49 	function transfer(address to, uint256 value) public returns (bool);
50 	event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title ERC20 interface
55  */
56 contract ERC20 is ERC20Basic {
57 	function allowance(address owner, address spender) public view returns (uint256);
58 	function transferFrom(address from, address to, uint256 value) public returns (bool);
59 	function approve(address spender, uint256 value) public returns (bool);
60 	event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract Ownable {
64 	address public owner;
65 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 	
67 	/**
68 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69 	 * account.
70 	 */
71 	constructor() public {
72 		owner = msg.sender;
73 	}
74 	/**
75 	 * @dev Throws if called by any account other than the owner.
76 	 */
77 	modifier onlyOwner() {
78 		require(msg.sender == owner);
79 		_;
80 	}
81 
82 	/**
83 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
84 	 * @param newOwner The address to transfer ownership to.
85 	 */
86 	function transferOwnership(address newOwner) public onlyOwner {
87 		require(newOwner != address(0));
88 		emit OwnershipTransferred(owner, newOwner);
89 		owner = newOwner;
90 	}
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic,ERC20 {
98 	using SafeMath for uint256;
99 	mapping(address => uint256) balances;
100 	mapping(address => uint256) public lockValues; //lock the amount of the specified address.
101 	uint256 totalSupply_ = 1000000000*10**8; //total
102 	/**
103 	 * @dev total number of tokens in existence
104 	 */
105 	function totalSupply() public view returns (uint256) {
106 		return totalSupply_;
107 	}
108 	/**
109 	 * @dev transfer token for a specified address
110 	 * @param _to The address to transfer to.
111 	 * @param _value The amount to be transferred.
112 	 */
113 	function transfer(address _to, uint256 _value) public returns (bool) {
114 		require(_to != address(0));
115 		address addr = msg.sender;
116 		require(_value <= balances[addr]);
117 		uint256 transBlalance = balances[msg.sender].sub(lockValues[msg.sender]);
118 		require(_value <= transBlalance);
119 		// SafeMath.sub will throw if there is not enough balance.
120 		balances[msg.sender] = balances[msg.sender].sub(_value);
121 		balances[_to] = balances[_to].add(_value);
122 		emit Transfer(msg.sender, _to, _value);
123 		return true;
124 	}
125 	/**
126 	 * @dev Gets the balance of the specified address.
127 	 * @param _owner The address to query the the balance of.
128 	 * @return An uint256 representing the amount owned by the passed address.
129 	 */
130 	function balanceOf(address _owner) public view returns (uint256 balance) {
131 		return balances[_owner];
132 	}
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  * @dev Implementation of the basic standard token.
138  */
139 contract StandardToken is ERC20, BasicToken {
140 	mapping (address => mapping (address => uint256)) internal allowed;
141 	/**
142 	 * @dev Transfer tokens from one address to another
143 	 * @param _from address The address which you want to send tokens from
144 	 * @param _to address The address which you want to transfer to
145 	 * @param _value uint256 the amount of tokens to be transferred
146 	 */
147 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148 		require(_to != address(0));
149 		require(_value <= balances[_from]);
150 		require(_value <= allowed[_from][msg.sender]);
151 		uint256 transBlalance = balances[_from].sub(lockValues[_from]);
152 		require(_value <= transBlalance);
153 		transBlalance = allowed[_from][msg.sender].sub(lockValues[msg.sender]);
154 		require(_value <= transBlalance);
155 		balances[_from] = balances[_from].sub(_value);
156 		balances[_to] = balances[_to].add(_value);
157 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158 		emit Transfer(_from, _to, _value);
159 		return true;
160 	}
161 
162 	/**
163 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164 	 *
165 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
166 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168 	 * @param _spender The address which will spend the funds.
169 	 * @param _value The amount of tokens to be spent.
170 	 */
171 	function approve(address _spender, uint256 _value) public returns (bool) {
172 		allowed[msg.sender][_spender] = _value;
173 		emit Approval(msg.sender, _spender, _value);
174 		return true;
175 	}
176 	/**
177 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
178 	 * @param _owner address The address which owns the funds.
179 	 * @param _spender address The address which will spend the funds.
180 	 * @return A uint256 specifying the amount of tokens still available for the spender.
181 	 */
182 	function allowance(address _owner, address _spender) public view returns (uint256) {
183 		return allowed[_owner][_spender];
184 	}
185 	/**
186 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
187 	 *
188 	 * approve should be called when allowed[_spender] == 0. To increment
189 	 * allowed value is better to use this function to avoid 2 calls (and wait until
190 	 * the first transaction is mined)
191 	 * From MonolithDAO Token.sol
192 	 * @param _spender The address which will spend the funds.
193 	 * @param _addedValue The amount of tokens to increase the allowance by.
194 	 */
195 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198 		return true;
199 	}
200 
201 	/**
202 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
203 	 *
204 	 * approve should be called when allowed[_spender] == 0. To decrement
205 	 * allowed value is better to use this function to avoid 2 calls (and wait until
206 	 * the first transaction is mined)
207 	 * From MonolithDAO Token.sol
208 	 * @param _spender The address which will spend the funds.
209 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
210 	 */
211 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212 		uint oldValue = allowed[msg.sender][_spender];
213 		if (_subtractedValue > oldValue) {
214 		  allowed[msg.sender][_spender] = 0;
215 		} else {
216 		  allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217 		}
218 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219 		return true;
220 	}
221 }
222 
223 /**
224  * @title Pausable
225  * @dev Base contract which allows children to implement an emergency stop mechanism.
226  */
227 contract Pausable is Ownable {
228 	event Pause();
229 	event Unpause();
230 	bool public paused = false;
231 	/**
232 	 * @dev Modifier to make a function callable only when the contract is not paused.
233 	 */
234 	modifier whenNotPaused() {
235 		require(!paused);
236 		_;
237 	}
238 	/**
239 	 * @dev Modifier to make a function callable only when the contract is paused.
240 	 */
241 	modifier whenPaused() {
242 		require(paused);
243 		_;
244 	}
245 	/**
246 	 * @dev called by the owner to pause, triggers stopped state
247 	 */
248 	function pause() onlyOwner whenNotPaused public {
249 		paused = true;
250 		emit Pause();
251 	}
252 	/**
253 	 * @dev called by the owner to unpause, returns to normal state
254 	 */
255 	function unpause() onlyOwner whenPaused public {
256 		paused = false;
257 		emit Unpause();
258 	}
259 }
260 /**
261  * @title Pausable token
262  * @dev StandardToken modified with pausable transfers.
263  **/
264 contract PausableToken is StandardToken, Pausable {
265 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
266 		return super.transfer(_to, _value);
267 	}
268 
269 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
270 		return super.transferFrom(_from, _to, _value);
271 	}
272 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
273 		return super.approve(_spender, _value);
274 	}
275 	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276 		return super.increaseApproval(_spender, _addedValue);
277 	}
278 	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
279 		return super.decreaseApproval(_spender, _subtractedValue);
280 	}
281 }
282 
283 /**
284  * @dev Token ERC20 contract
285  */
286 contract ATokenERC20 is PausableToken {
287 	string public constant version = "1.0";
288 	string public name = "Step chain";
289 	string public symbol = "IOC";
290 	uint8 public constant decimals = 8;
291 	
292 	constructor() public {
293 		balances[msg.sender] = totalSupply_;
294 	}
295 
296 	function addLockValue(address addr,uint256 _value) public onlyOwner {
297 		uint256 _reqlockValues= lockValues[addr].add(_value);
298 		require(_reqlockValues <= balances[addr]);    
299 		require(addr != address(0));
300 		lockValues[addr] = lockValues[addr].add(_value);        
301 	}    
302 	function subLockValue(address addr,uint256 _value) public onlyOwner {
303 		require(addr != address(0));
304 		require(_value <= lockValues[addr]);
305 		lockValues[addr] = lockValues[addr].sub(_value);        
306 	}
307 }