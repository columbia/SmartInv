1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20 {
10 
11     function totalSupply() public constant returns (uint);
12 	function balanceOf(address who) public view returns (uint256);
13 	function transfer(address to, uint256 value) public returns (bool);
14 	function allowance(address owner, address spender) public view returns (uint256);
15 	function transferFrom(address from, address to, uint256 value) public returns (bool);
16 	function approve(address spender, uint256 value) public returns (bool);
17 	event Approval(address indexed owner, address indexed spender, uint256 value);
18 	event Transfer(address indexed from, address indexed to, uint256 value);
19 
20 }
21 
22 
23 
24 
25 /**
26  * @title Basic token
27  * @dev Basic version of StandardToken, with no allowances.
28  */
29 contract BasicToken is ERC20 {
30 
31   using SafeMath for uint256;
32 
33     uint256 public totalSupply = 10*10**26;
34     uint8 constant public decimals = 18;
35     string constant public name = "CLBToken";
36     string constant public symbol = "CLB";
37 
38 	mapping(address => uint256) balances;
39 	mapping (address => mapping (address => uint256)) internal allowed;
40 
41 	/**
42 	* @dev transfer token for a specified address
43 	* @param _to The address to transfer to.
44 	* @param _value The amount to be transferred.
45 	*/
46 	function transfer(address _to, uint256 _value) public returns (bool) {
47 		require(_to != address(0));
48 		require(_value <= balances[msg.sender]);
49 
50 		// SafeMath.sub will throw if there is not enough balance.
51 		balances[msg.sender] = balances[msg.sender].sub(_value);
52 		balances[_to] = balances[_to].add(_value);
53 		emit Transfer(msg.sender, _to, _value);
54 		return true;
55 	}
56 
57 
58 		/**
59 		 * @dev Transfer tokens from one address to another
60 		 * @param _from address The address which you want to send tokens from
61 		 * @param _to address The address which you want to transfer to
62 		 * @param _value uint256 the amount of tokens to be transferred
63 		 */
64 		function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65 			require(_to != address(0));
66 			require(_value <= balances[_from]);
67 			require(_value <= allowed[_from][msg.sender]);
68 
69 			balances[_from] = balances[_from].sub(_value);
70 			balances[_to] = balances[_to].add(_value);
71 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
72 			emit Transfer(_from, _to, _value);
73 			return true;
74 		}
75 
76 	/**
77 	* @dev Gets the balance of the specified address.
78 	* @param _owner The address to query the the balance of.
79 	* @return An uint256 representing the amount owned by the passed address.
80 	*/
81 	function balanceOf(address _owner) public view returns (uint256 balance) {
82 		return balances[_owner];
83 	}
84 
85 
86    function totalSupply() public constant returns (uint256){
87         return totalSupply;
88    }
89 
90 
91 	/**
92 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
93 	 *
94 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
95 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98 	 * @param _spender The address which will spend the funds.
99 	 * @param _value The amount of tokens to be spent.
100 	 */
101 	function approve(address _spender, uint256 _value) public returns (bool) {
102 		allowed[msg.sender][_spender] = _value;
103 		emit Approval(msg.sender, _spender, _value);
104 		return true;
105 	}
106 
107 	/**
108 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
109 	 * @param _owner address The address which owns the funds.
110 	 * @param _spender address The address which will spend the funds.
111 	 * @return A uint256 specifying the amount of tokens still available for the spender.
112 	 */
113 	function allowance(address _owner, address _spender) public view returns (uint256) {
114 		return allowed[_owner][_spender];
115 	}
116 
117 	/**
118 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
119 	 *
120 	 * approve should be called when allowed[_spender] == 0. To increment
121 	 * allowed value is better to use this function to avoid 2 calls (and wait until
122 	 * the first transaction is mined)
123 	 * From MonolithDAO Token.sol
124 	 * @param _spender The address which will spend the funds.
125 	 * @param _addedValue The amount of tokens to increase the allowance by.
126 	 */
127 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
128 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129 		emit  Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130 		return true;
131 	}
132 
133 	/**
134 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
135 	 *
136 	 * approve should be called when allowed[_spender] == 0. To decrement
137 	 * allowed value is better to use this function to avoid 2 calls (and wait until
138 	 * the first transaction is mined)
139 	 * From MonolithDAO Token.sol
140 	 * @param _spender The address which will spend the funds.
141 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
142 	 */
143 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144 		uint oldValue = allowed[msg.sender][_spender];
145 		if (_subtractedValue > oldValue) {
146 			allowed[msg.sender][_spender] = 0;
147 		} else {
148 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149 		}
150 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151 		return true;
152 	}
153 
154 }
155 
156 
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable {
164 	address public owner;
165 
166 
167 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169 
170 	/**
171 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172 	 * account.
173 	 */
174 	function Ownable() public {
175 		owner = msg.sender;
176 	}
177 
178 
179 	/**
180 	 * @dev Throws if called by any account other than the owner.
181 	 */
182 	modifier onlyOwner() {
183 		require(msg.sender == owner);
184 		_;
185 	}
186 
187 
188 	/**
189 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
190 	 * @param newOwner The address to transfer ownership to.
191 	 */
192 	function transferOwnership(address newOwner) public onlyOwner {
193 		require(newOwner != address(0));
194 		emit OwnershipTransferred(owner, newOwner);
195 		owner = newOwner;
196 	}
197 
198 }
199 
200 contract Controlled is Ownable{
201 
202     function Controlled() public {
203        setExclude(msg.sender);
204     }
205 
206     // Flag that determines if the token is transferable or not.
207     bool public transferEnabled = false;
208 
209     // flag that makes locked address effect
210     bool public lockFlag=true;
211     mapping(address => bool) locked;
212     mapping(address => bool) exclude;
213 
214     function enableTransfer(bool _enable) public onlyOwner{
215         transferEnabled=_enable;
216     }
217 
218     function disableLock(bool _enable) public onlyOwner returns (bool success){
219         lockFlag=_enable;
220         return true;
221     }
222 
223     function addLock(address _addr) public onlyOwner returns (bool success){
224         require(_addr!=msg.sender);
225         locked[_addr]=true;
226         return true;
227     }
228 
229     function setExclude(address _addr) public onlyOwner returns (bool success){
230         exclude[_addr]=true;
231         return true;
232     }
233 
234     function removeLock(address _addr) public onlyOwner returns (bool success){
235         locked[_addr]=false;
236         return true;
237     }
238 
239     modifier transferAllowed(address _addr) {
240         if (!exclude[_addr]) {
241             assert(transferEnabled);
242             if(lockFlag){
243                 assert(!locked[_addr]);
244             }
245         }
246         
247         _;
248     }
249 
250 }
251  
252 
253 /**
254  * @title Burnable Token
255  * @dev Token that can be irreversibly burned (destroyed).
256  */
257 contract BurnableToken is BasicToken {
258 
259 
260 	event Burn(address indexed burner, uint256 value);
261 
262 	/**
263 	 * @dev Burns a specific amount of tokens.
264 	 * @param _value The amount of token to be burned.
265 	 */
266 	function burn(uint256 _value) public {
267 		require(_value <= balances[msg.sender]);
268 		// no need to require value <= totalSupply, since that would imply the
269 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
270 
271 		address burner = msg.sender;
272 		balances[burner] = balances[burner].sub(_value);
273 		totalSupply = totalSupply.sub(_value);
274 		emit Burn(burner, _value);
275 	}
276 }
277 
278 /**
279  * @title Pausable token
280  *
281  * @dev StandardToken modified with pausable transfers.
282  **/
283 
284 contract ControlledToken is BasicToken, Controlled {
285 
286   function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
291     return super.transferFrom(_from, _to, _value);
292   }
293 
294   function approve(address _spender, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
295     return super.approve(_spender, _value);
296   }
297 
298   function increaseApproval(address _spender, uint _addedValue) public transferAllowed(msg.sender) returns (bool success) {
299     return super.increaseApproval(_spender, _addedValue);
300   }
301 
302   function decreaseApproval(address _spender, uint _subtractedValue) public transferAllowed(msg.sender) returns (bool success) {
303     return super.decreaseApproval(_spender, _subtractedValue);
304   }
305 }
306 
307 
308 contract CLBToken is ControlledToken, BurnableToken {
309 
310 
311 
312 	function CLBToken()	public {
313         balances[msg.sender] = totalSupply;
314         emit Transfer(address(0), msg.sender, totalSupply);
315 	}
316 
317 	event LogRedeem(address beneficiary, uint256 amount);
318 
319 	function redeem() public {
320 
321 		uint256 balance = balanceOf(msg.sender);
322 		// burn the tokens in this token smart contract
323 		super.burn(balance);
324  		emit LogRedeem(msg.sender, balance);
325 	}
326 
327 
328 }
329 
330 
331 /**
332  * @title SafeMath
333  * @dev Math operations with safety checks that throw on error
334  */
335 library SafeMath {
336 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
337 		if (a == 0) {
338 			return 0;
339 		}
340 		uint256 c = a * b;
341 		assert(c / a == b);
342 		return c;
343 	}
344 
345 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
346 		// assert(b > 0); // Solidity automatically throws when dividing by 0
347 		uint256 c = a / b;
348 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
349 		return c;
350 	}
351 
352 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
353 		assert(b <= a);
354 		return a - b;
355 	}
356 
357 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
358 		uint256 c = a + b;
359 		assert(c >= a);
360 		return c;
361 	}
362 }