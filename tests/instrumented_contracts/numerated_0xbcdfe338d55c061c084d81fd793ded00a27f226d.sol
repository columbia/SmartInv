1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * Math operations with safety checks
20  */
21 library SafeMath {
22   function mul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint a, uint b) internal returns (uint) {
29     assert(b > 0);
30     uint c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34 
35   function sub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a >= b ? a : b;
48   }
49 
50   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a < b ? a : b;
52   }
53 
54   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a >= b ? a : b;
56   }
57 
58   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a < b ? a : b;
60   }
61 }
62 
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   function Ownable() public {
82     owner = msg.sender;
83   }
84 
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) onlyOwner public {
100     require(newOwner != address(0));
101     OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 
105 }
106 
107 
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   /**
126   * @dev Fix for the ERC20 short address attack.
127    */
128   modifier onlyPayloadSize(uint size) {
129     require(msg.data.length >= size + 4) ;
130     _;
131   }
132 
133   mapping(address => uint256) balances;
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
141     require(_to != address(0));
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
155   function balanceOf(address _owner) public constant returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 
162 
163 
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * @dev https://github.com/ethereum/EIPs/issues/20
184  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   /**
189   * @dev Fix for the ERC20 short address attack.
190    */
191   modifier onlyPayloadSize(uint size) {
192     require(msg.data.length >= size + 4) ;
193     _;
194   }
195 
196   mapping (address => mapping (address => uint256)) allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
206     require(_to != address(0));
207 
208     uint256 _allowance = allowed[_from][msg.sender];
209 
210     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
211     // require (_value <= _allowance);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = _allowance.sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    */
252   function increaseApproval (address _spender, uint _addedValue)
253     public returns (bool success) {
254     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   function decreaseApproval (address _spender, uint _subtractedValue)
260     public returns (bool success) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 
274 
275 
276 
277 
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284   event Pause();
285   event Unpause();
286 
287   bool public paused = false;
288 
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!paused);
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(paused);
303     _;
304   }
305 
306   /**
307    * @dev called by the owner to pause, triggers stopped state
308    */
309   function pause() onlyOwner whenNotPaused public {
310     paused = true;
311     Pause();
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() onlyOwner whenPaused public {
318     paused = false;
319     Unpause();
320   }
321 }
322 
323 
324 /**
325  * @title DML Token Contract
326  * @dev DML Token Contract
327  * @dev inherite from StandardToken, Pasuable and Ownable by Zeppelin
328  * @author DML team
329  */
330 
331 contract DmlToken is StandardToken, Pausable{
332 	using SafeMath for uint;
333 
334  	string public constant name = "DML Token";
335 	uint8 public constant decimals = 18;
336 	string public constant symbol = 'DML';
337 
338 	uint public constant MAX_TOTAL_TOKEN_AMOUNT = 330000000 ether;
339 	address public minter;
340 	uint public endTime;
341 
342 	mapping (address => uint) public lockedBalances;
343 
344 	modifier onlyMinter {
345     	  assert(msg.sender == minter);
346     	  _;
347     }
348 
349     modifier maxDmlTokenAmountNotReached (uint amount){
350     	  assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
351     	  _;
352     }
353 
354     /**
355      * @dev Constructor
356      * @param _minter Contribution Smart Contract
357      * @return _endTime End of the contribution period
358      */
359 	function DmlToken(address _minter, uint _endTime){
360     	  minter = _minter;
361     	  endTime = _endTime;
362     }
363 
364     /**
365      * @dev Mint Token
366      * @param receipent address owning mint tokens    
367      * @param amount amount of token
368      */
369     function mintToken(address receipent, uint amount)
370         external
371         onlyMinter
372         maxDmlTokenAmountNotReached(amount)
373         returns (bool)
374     {
375         require(now <= endTime);
376       	lockedBalances[receipent] = lockedBalances[receipent].add(amount);
377       	totalSupply = totalSupply.add(amount);
378       	return true;
379     }
380 
381     /**
382      * @dev Unlock token for trade
383      */
384     function claimTokens(address receipent)
385         public
386         onlyMinter
387     {
388       	balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
389       	lockedBalances[receipent] = 0;
390     }
391 
392     function lockedBalanceOf(address _owner) constant returns (uint balance) {
393         return lockedBalances[_owner];
394     }
395 
396 	/**
397 	* @dev override to add validRecipient
398 	* @param _to The address to transfer to.
399 	* @param _value The amount to be transferred.
400 	*/
401 	function transfer(address _to, uint _value)
402 		public
403 		validRecipient(_to)
404 		returns (bool success)
405 	{
406 		return super.transfer(_to, _value);
407 	}
408 
409 	/**
410 	* @dev override to add validRecipient
411 	* @param _spender The address which will spend the funds.
412 	* @param _value The amount of tokens to be spent.
413 	*/
414 	function approve(address _spender, uint256 _value)
415 		public
416 		validRecipient(_spender)
417 		returns (bool)
418 	{
419 		return super.approve(_spender,  _value);
420 	}
421 
422 	/**
423 	* @dev override to add validRecipient
424 	* @param _from address The address which you want to send tokens from
425 	* @param _to address The address which you want to transfer to
426 	* @param _value uint256 the amount of tokens to be transferred
427 	*/
428 	function transferFrom(address _from, address _to, uint256 _value)
429 		public
430 		validRecipient(_to)
431 		returns (bool)
432 	{
433 		return super.transferFrom(_from, _to, _value);
434 	}
435 
436 	// MODIFIERS
437 
438  	modifier validRecipient(address _recipient) {
439     	require(_recipient != address(this));
440     	_;
441   	}
442 }