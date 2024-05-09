1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   uint256 totalSupply_;
126 
127   /**
128   * @dev total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[msg.sender]);
142 
143     // SafeMath.sub will throw if there is not enough balance.
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 /**
258  * @title Pausable
259  * @dev Base contract which allows children to implement an emergency stop mechanism.
260  */
261 contract Pausable is Ownable {
262   event Pause();
263   event Unpause();
264 
265   bool public paused = false;
266 
267 
268   /**
269    * @dev Modifier to make a function callable only when the contract is not paused.
270    */
271   modifier whenNotPaused() {
272     require(!paused);
273     _;
274   }
275 
276   /**
277    * @dev Modifier to make a function callable only when the contract is paused.
278    */
279   modifier whenPaused() {
280     require(paused);
281     _;
282   }
283 
284   /**
285    * @dev called by the owner to pause, triggers stopped state
286    */
287   function pause() onlyOwner whenNotPaused public {
288     paused = true;
289     Pause();
290   }
291 
292   /**
293    * @dev called by the owner to unpause, returns to normal state
294    */
295   function unpause() onlyOwner whenPaused public {
296     paused = false;
297     Unpause();
298   }
299 }
300 
301 
302 /**
303  * @title Pausable token
304  * @dev StandardToken modified with pausable transfers.
305  **/
306 contract PausableToken is StandardToken, Pausable {
307 
308   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
313     return super.transferFrom(_from, _to, _value);
314   }
315 
316   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
317     return super.approve(_spender, _value);
318   }
319 
320   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
321     return super.increaseApproval(_spender, _addedValue);
322   }
323 
324   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
325     return super.decreaseApproval(_spender, _subtractedValue);
326   }
327 }
328 
329 contract IKanCoin is PausableToken {
330 	function releaseTeam() public returns (bool);
331 	function fund(address _funder, uint256 _amount) public returns (bool);
332 	function releaseFund(address _funder) public returns (bool);
333 	function freezedBalanceOf(address _owner) public view returns (uint256 balance);
334 	function burn(uint256 _value) public returns (bool);
335 
336 	event ReleaseTeam(address indexed team, uint256 value);
337 	event Fund(address indexed funder, uint256 value);
338 	event ReleaseFund(address indexed funder, uint256 value);
339 }
340 
341 contract KanCoin is IKanCoin {
342 	string public name = 'KAN';
343 	string public symbol = 'KAN';
344 	uint8 public decimals = 18;
345 	uint256 public INITIAL_SUPPLY = 10000000000 * 10 ** uint256(decimals); 
346 	mapping(address => uint256) freezedBalances; 
347 	mapping(address => uint256) fundings; 
348 	uint256 fundingBalance;
349 	address launch; 
350 	uint256 teamBalance; 
351 
352 	function KanCoin(address _launch) public {
353 		launch = _launch;
354 		totalSupply_ = INITIAL_SUPPLY;
355 		teamBalance = INITIAL_SUPPLY.mul(2).div(10); // 20%
356 		fundingBalance = INITIAL_SUPPLY.mul(45).div(100); //45%
357 		balances[launch] = INITIAL_SUPPLY.mul(35).div(100); //35%
358 	}
359 
360 	function releaseTeam() public onlyOwner returns (bool) {
361 		require(teamBalance > 0); 
362 		uint256 amount = INITIAL_SUPPLY.mul(4).div(100); // 20% * 20%
363 		teamBalance = teamBalance.sub(amount); 
364 		balances[owner] = balances[owner].add(amount); 
365 		ReleaseTeam(owner, amount);
366 		return true;
367 	}
368 
369 	function fund(address _funder, uint256 _amount) public onlyOwner returns (bool) {
370 		require(_funder != address(0));
371 		require(fundingBalance >= _amount); 
372 		fundingBalance = fundingBalance.sub(_amount); 
373 		balances[_funder] = balances[_funder].add(_amount); 
374 		freezedBalances[_funder] = freezedBalances[_funder].add(_amount); 
375 		fundings[_funder] = fundings[_funder].add(_amount); 
376 		Fund(_funder, _amount);
377 		return true;
378 	}
379 
380 	function releaseFund(address _funder) public onlyOwner returns (bool) {
381 		require(freezedBalances[_funder] > 0); 
382 		uint256 fundReleaseRate = freezedBalances[_funder] == fundings[_funder] ? 25 : 15; 
383 		uint256 released = fundings[_funder].mul(fundReleaseRate).div(100); 
384 		freezedBalances[_funder] = released < freezedBalances[_funder] ? freezedBalances[_funder].sub(released) : 0; 
385 		ReleaseFund(_funder, released);
386 		return true;
387 	}
388 
389 	function freezedBalanceOf(address _owner) public view returns (uint256 balance) {
390 		return freezedBalances[_owner];
391 	}
392 
393 	function burn(uint256 _value) public onlyOwner returns (bool) {
394 		balances[msg.sender] = balances[msg.sender].sub(_value);
395 		balances[address(0)] = balances[address(0)].add(_value); 
396 		Transfer(msg.sender, address(0), _value);
397 		return true;
398 	}
399 
400 	function transfer(address _to, uint256 _value) public returns (bool) {
401 		require(_value <= balances[msg.sender] - freezedBalances[msg.sender]); 
402 		return super.transfer(_to, _value);
403 	}
404 
405 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
406 		require(_value <= balances[_from] - freezedBalances[_from]); 
407 		return super.transferFrom(_from, _to, _value);
408 	}
409 }