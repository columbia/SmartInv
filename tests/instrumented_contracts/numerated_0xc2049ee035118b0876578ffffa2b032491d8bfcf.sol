1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  * @notice https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
30  */
31 library SafeMath {
32 	/**
33 	 * SafeMath mul function
34 	 * @dev function for safe multiply, throws on overflow.
35 	 **/
36 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37 		uint256 c = a * b;
38 		assert(a == 0 || c / a == b);
39 		return c;
40 	}
41 
42 	/**
43 	 * SafeMath div funciotn
44 	 * @dev function for safe devide, throws on overflow.
45 	 **/
46 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
47 		uint256 c = a / b;
48 		return c;
49 	}
50 
51 	/**
52 	 * SafeMath sub function
53 	 * @dev function for safe subtraction, throws on overflow.
54 	 **/
55 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56 		assert(b <= a);
57 		return a - b;
58 	}
59 
60 	/**
61 	 * SafeMath add function
62 	 * @dev Adds two numbers, throws on overflow.
63 	 */
64 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65 		c = a + b;
66 		assert(c >= a);
67 		return c;
68 	}
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181     allowed[msg.sender][_spender] = (
182       allowed[msg.sender][_spender].add(_addedValue));
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   /**
188    * @dev Decrease the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
198     uint oldValue = allowed[msg.sender][_spender];
199 
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205 
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipRenounced(address indexed previousOwner);
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   constructor() public {
230     owner = msg.sender;
231   }
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) public onlyOwner {
246     require(newOwner != address(0));
247     emit OwnershipTransferred(owner, newOwner);
248     owner = newOwner;
249   }
250 
251   /**
252    * @dev Allows the current owner to relinquish control of the contract.
253    */
254   function renounceOwnership() public onlyOwner {
255     emit OwnershipRenounced(owner);
256     owner = address(0);
257   }
258 }
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Ownable {
265   event Pause();
266   event Unpause();
267 
268   bool public paused = false;
269 
270   /**
271    * @dev Modifier to make a function callable only when the contract is not paused.
272    */
273   modifier whenNotPaused() {
274     require(!paused || msg.sender == owner);
275     _;
276   }
277 
278   /**
279    * @dev Modifier to make a function callable only when the contract is paused.
280    */
281   modifier whenPaused() {
282     require(paused);
283     _;
284   }
285 
286   /**
287      * @dev called by the owner to pause, triggers stopped state
288      **/
289     function _pause() public onlyOwner {
290         require(!paused);
291         paused = true;
292         emit Pause();
293     }
294 
295   /**
296    * @dev called by the owner to unpause, returns to normal state
297    */
298   function _unpause() onlyOwner whenPaused public {
299     require(paused == true);
300     paused = false;
301     emit Unpause();
302   }
303 }
304 
305 /**
306  * @title Pausable token
307  * @dev StandardToken modified with pausable transfers.
308  **/
309 contract CucunToken is StandardToken, Pausable {
310     string public name;// = "Cucu Token";
311     string public symbol;// = "CUCU";
312     uint256 public decimals;// = 8;
313     uint256 public initial_supply;// = 100000000000;// 1000 억
314 
315     bool public isPauseOn = false;
316 
317     modifier ifNotPaused(){
318       require(!isPauseOn || msg.sender == owner);
319       _;
320     }
321 
322     function _doPause() public{
323       require(msg.sender == owner);
324       isPauseOn = true;
325     }
326 
327     function _doUnpause() public{
328       require(msg.sender == owner);
329       isPauseOn = false;
330     }
331 
332     /**
333      * @dev Transfer tokens when not paused
334      **/
335     function transfer(address _to, uint256 _value) public ifNotPaused returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339     /**
340      * @dev transferFrom function to tansfer tokens when token is not paused
341      **/
342     function transferFrom(address _from, address _to, uint256 _value) public ifNotPaused returns (bool) {
343         return super.transferFrom(_from, _to, _value);
344     }
345 
346     /**
347      * @dev approve spender when not paused
348      **/
349     function approve(address _spender, uint256 _value) public ifNotPaused returns (bool) {
350         return super.approve(_spender, _value);
351     }
352 
353     /**
354      * @dev increaseApproval of spender when not paused
355      **/
356     function increaseApproval(address _spender, uint _addedValue) public ifNotPaused returns (bool success) {
357         return super.increaseApproval(_spender, _addedValue);
358     }
359 
360     /**
361      * @dev decreaseApproval of spender when not paused
362      **/
363     function decreaseApproval(address _spender, uint _subtractedValue) public ifNotPaused returns (bool success) {
364         return super.decreaseApproval(_spender, _subtractedValue);
365     }
366 
367 
368     // Mint more tokens
369     function _mint(uint mint_amt) public onlyOwner{
370         totalSupply_ = totalSupply_.add(mint_amt);
371         balances[owner] = balances[owner].add(mint_amt);
372     }
373 
374     /**
375    * Pausable Token Constructor
376    * @dev Create and issue tokens to msg.sender.
377    */
378   constructor() public {
379     name = "Cucu Token";
380     symbol = "CUCU";
381     decimals = 8;
382     initial_supply = 10000000000000000000;
383 
384     totalSupply_ = initial_supply;
385     balances[msg.sender] = initial_supply;
386   }
387 }