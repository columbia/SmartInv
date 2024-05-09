1 pragma solidity ^0.5.17;
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
119  * @dev https://github.com/ethereum/EIPs/issues/2
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     emit Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public view returns (uint256) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * @dev Increase the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _addedValue The amount of tokens to increase the allowance by.
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = (
181       allowed[msg.sender][_spender].add(_addedValue));
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   /**
187    * @dev Decrease the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To decrement
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _subtractedValue The amount of tokens to decrease the allowance by.
195    */
196   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197     uint oldValue = allowed[msg.sender][_spender];
198     
199     if (_subtractedValue > oldValue) {
200       allowed[msg.sender][_spender] = 0;
201     } else {
202       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203     }
204     
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipRenounced(address indexed previousOwner);
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   constructor() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     emit OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250   /**
251    * @dev Allows the current owner to relinquish control of the contract.
252    */
253   function renounceOwnership() public onlyOwner {
254     emit OwnershipRenounced(owner);
255     owner = address(0);
256   }
257 }
258 
259 /**
260  * @title Pausable
261  * @dev Base contract which allows children to implement an emergency stop mechanism.
262  */
263 contract Pausable is Ownable {
264   event Pause();
265   event Unpause();
266   event NotPausable();
267 
268   bool public paused = false;
269   bool public canPause = true;
270   address public saleAgent;
271   
272   function setSaleAgent(address newSaleAgnet) public onlyOwner  {
273     saleAgent = newSaleAgnet;
274   }
275   /**
276    * @dev Modifier to make a function callable only when the contract is not paused.
277    */
278   modifier whenNotPaused() {
279     require(!paused || msg.sender == owner || msg.sender == saleAgent);
280     _;
281   }
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is paused.
285    */
286   modifier whenPaused() {
287     require(paused);
288     _;
289   }
290 
291   /**
292      * @dev called by the owner to pause, triggers stopped state
293      **/
294     function pause() onlyOwner whenNotPaused public {
295         require(canPause == true);
296         paused = true;
297         emit Pause();
298     }
299 
300   /**
301    * @dev called by the owner to unpause, returns to normal state
302    */
303   function unpause() onlyOwner whenPaused public {
304     require(paused == true);
305     paused = false;
306     emit Unpause();
307   }
308   
309   /**
310      * @dev Prevent the token from ever being paused again
311      **/
312     function notPausable() onlyOwner public{
313         paused = false;
314         canPause = false;
315         emit NotPausable();
316     }
317 }
318 contract BlackList is Ownable, BasicToken {
319 
320     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
321     function getBlackListStatus(address _maker) external view returns (bool) {
322         return isBlackListed[_maker];
323     }
324 
325     function getOwner() external view returns (address) {
326         return owner;
327     }
328 
329     mapping (address => bool) public isBlackListed;
330     
331     function addFreeze  (address _evilUser) public onlyOwner {
332         isBlackListed[_evilUser] = true;
333        emit AddedBlackList(_evilUser);
334     }
335 
336     function removeFreeze (address _clearedUser) public onlyOwner {
337         isBlackListed[_clearedUser] = false;
338        emit RemovedBlackList(_clearedUser);
339     }
340 
341     function BurnFrozenFunds (address _blackListedUser) public onlyOwner {
342         require(isBlackListed[_blackListedUser]);
343         uint dirtyFunds = balanceOf(_blackListedUser);
344         balances[_blackListedUser] = 0;
345         totalSupply_ -= dirtyFunds;
346        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
347     }
348 
349     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
350 
351     event AddedBlackList(address _user);
352 
353     event RemovedBlackList(address _user);
354 
355 }
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PXPv2Token is StandardToken, Pausable, BlackList {
361     string public constant name = " PointPay Crypto Banking Token V2 ";
362     string public constant symbol = "PXP";
363     uint256 public constant decimals = 18;
364 	 uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
365 
366     /**
367      * @dev Transfer tokens when not paused
368      **/
369     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
370      require(!isBlackListed[msg.sender]);
371         return super.transfer(_to, _value);
372     }
373     
374     /**
375      * @dev transferFrom function to tansfer tokens when token is not paused
376      **/
377     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
378      require(!isBlackListed[msg.sender]);
379         return super.transferFrom(_from, _to, _value);
380     }
381     
382     /**
383      * @dev approve spender when not paused
384      **/
385     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
386         return super.approve(_spender, _value);
387     }
388     
389     /**
390      * @dev increaseApproval of spender when not paused
391      **/
392     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
393         return super.increaseApproval(_spender, _addedValue);
394     }
395     
396     /**
397      * @dev decreaseApproval of spender when not paused
398      **/
399     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
400         return super.decreaseApproval(_spender, _subtractedValue);
401     }
402     
403     /**
404    * Pausable Token Constructor
405    * @dev Create and issue tokens to msg.sender.
406    */
407   constructor() public {
408     totalSupply_ = INITIAL_SUPPLY;
409     balances[msg.sender] = INITIAL_SUPPLY;
410   } 
411 }