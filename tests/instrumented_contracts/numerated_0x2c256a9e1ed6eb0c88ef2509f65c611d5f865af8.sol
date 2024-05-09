1 pragma solidity 0.4.24;
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
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
151     require(token.transfer(to, value));
152   }
153 
154   function safeTransferFrom(
155     ERC20 token,
156     address from,
157     address to,
158     uint256 value
159   )
160     internal
161   {
162     require(token.transferFrom(from, to, value));
163   }
164 
165   function safeApprove(ERC20 token, address spender, uint256 value) internal {
166     require(token.approve(spender, value));
167   }
168 }
169 
170 
171 /**
172  * @title TokenTimelock
173  * @dev TokenTimelock is a token holder contract that will allow a
174  * beneficiary to extract the tokens after a given release time
175  */
176 contract TokenTimelock {
177   using SafeERC20 for ERC20Basic;
178 
179   // ERC20 basic token contract being held
180   ERC20Basic public token;
181 
182   // beneficiary of tokens after they are released
183   address public beneficiary;
184 
185   // timestamp when token release is enabled
186   uint256 public releaseTime;
187 
188   constructor(
189     ERC20Basic _token,
190     address _beneficiary,
191     uint256 _releaseTime
192   )
193     public
194   {
195     // solium-disable-next-line security/no-block-members
196     require(_releaseTime > block.timestamp);
197     token = _token;
198     beneficiary = _beneficiary;
199     releaseTime = _releaseTime;
200   }
201 
202   /**
203    * @notice Transfers tokens held by timelock to beneficiary.
204    */
205   function release() public {
206     // solium-disable-next-line security/no-block-members
207     require(block.timestamp >= releaseTime);
208 
209     uint256 amount = token.balanceOf(this);
210     require(amount > 0);
211 
212     token.safeTransfer(beneficiary, amount);
213   }
214 }
215 
216 
217 /**
218  * @title Basic token
219  * @dev Basic version of StandardToken, with no allowances.
220  */
221 contract BasicToken is ERC20Basic {
222   using SafeMath for uint256;
223 
224   mapping(address => uint256) balances;
225 
226   uint256 totalSupply_;
227 
228   /**
229   * @dev total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return totalSupply_;
233   }
234 
235   /**
236   * @dev transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[msg.sender]);
243 
244     balances[msg.sender] = balances[msg.sender].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     emit Transfer(msg.sender, _to, _value);
247     return true;
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public view returns (uint256) {
256     return balances[_owner];
257   }
258 
259 }
260 
261 /**
262  * @title Standard ERC20 token
263  *
264  * @dev Implementation of the basic standard token.
265  * @dev https://github.com/ethereum/EIPs/issues/20
266  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
267  */
268 contract StandardToken is ERC20, BasicToken {
269 
270   mapping (address => mapping (address => uint256)) internal allowed;
271 
272 
273   /**
274    * @dev Transfer tokens from one address to another
275    * @param _from address The address which you want to send tokens from
276    * @param _to address The address which you want to transfer to
277    * @param _value uint256 the amount of tokens to be transferred
278    */
279   function transferFrom(
280     address _from,
281     address _to,
282     uint256 _value
283   )
284     public
285     returns (bool)
286   {
287     require(_to != address(0));
288     require(_value <= balances[_from]);
289     require(_value <= allowed[_from][msg.sender]);
290 
291     balances[_from] = balances[_from].sub(_value);
292     balances[_to] = balances[_to].add(_value);
293     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
294     emit Transfer(_from, _to, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
300    *
301    * Beware that changing an allowance with this method brings the risk that someone may use both the old
302    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305    * @param _spender The address which will spend the funds.
306    * @param _value The amount of tokens to be spent.
307    */
308   function approve(address _spender, uint256 _value) public returns (bool) {
309     allowed[msg.sender][_spender] = _value;
310     emit Approval(msg.sender, _spender, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Function to check the amount of tokens that an owner allowed to a spender.
316    * @param _owner address The address which owns the funds.
317    * @param _spender address The address which will spend the funds.
318    * @return A uint256 specifying the amount of tokens still available for the spender.
319    */
320   function allowance(
321     address _owner,
322     address _spender
323    )
324     public
325     view
326     returns (uint256)
327   {
328     return allowed[_owner][_spender];
329   }
330 
331   /**
332    * @dev Increase the amount of tokens that an owner allowed to a spender.
333    *
334    * approve should be called when allowed[_spender] == 0. To increment
335    * allowed value is better to use this function to avoid 2 calls (and wait until
336    * the first transaction is mined)
337    * From MonolithDAO Token.sol
338    * @param _spender The address which will spend the funds.
339    * @param _addedValue The amount of tokens to increase the allowance by.
340    */
341   function increaseApproval(
342     address _spender,
343     uint _addedValue
344   )
345     public
346     returns (bool)
347   {
348     allowed[msg.sender][_spender] = (
349       allowed[msg.sender][_spender].add(_addedValue));
350     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353 
354   /**
355    * @dev Decrease the amount of tokens that an owner allowed to a spender.
356    *
357    * approve should be called when allowed[_spender] == 0. To decrement
358    * allowed value is better to use this function to avoid 2 calls (and wait until
359    * the first transaction is mined)
360    * From MonolithDAO Token.sol
361    * @param _spender The address which will spend the funds.
362    * @param _subtractedValue The amount of tokens to decrease the allowance by.
363    */
364   function decreaseApproval(
365     address _spender,
366     uint _subtractedValue
367   )
368     public
369     returns (bool)
370   {
371     uint oldValue = allowed[msg.sender][_spender];
372     if (_subtractedValue > oldValue) {
373       allowed[msg.sender][_spender] = 0;
374     } else {
375       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
376     }
377     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378     return true;
379   }
380 
381 }
382 
383 contract BonumToken is StandardToken, Ownable {
384 
385 	string public constant name = "BonumToken";
386 	string public constant symbol = "BONUM";
387 	uint8 public constant decimals = 18;
388 
389 	uint public constant INITIAL_SUPPLY = 65000000 * (10 ** uint256(decimals));
390 
391 	address public bounty;
392 	address public advisors;
393 
394 	bool public burnt = false;
395 
396 	TokenTimelock public reserveTimelock;
397 	TokenTimelock public teamTimelock;
398 
399 	event Burn(address indexed burner, uint256 value);
400 
401 	constructor(address _bounty, 
402 		address _reserve, 
403 		address _team, 
404 		address _advisors, 
405 		uint releaseTime) public {
406 		require(_bounty != address(0));
407 		require(_reserve != address(0));
408 		require(_advisors != address(0));
409 		totalSupply_ = INITIAL_SUPPLY;
410 		bounty = _bounty;
411 		advisors = _advisors;
412 		reserveTimelock = new TokenTimelock(this, _reserve, releaseTime); 
413 		teamTimelock = new TokenTimelock(this, _team, releaseTime);
414 
415 		uint factor = (10 ** uint256(decimals));
416 
417     uint bountyBalance = 1300000 * factor;
418 		balances[_bounty] = bountyBalance;
419     emit Transfer(address(0), _bounty, bountyBalance);
420 
421     uint advisorsBalance = 6500000 * factor;
422     balances[_advisors] = advisorsBalance;
423     emit Transfer(address(0), _advisors, advisorsBalance);
424 
425     uint reserveBalance = 13000000 * factor;
426 		balances[reserveTimelock] = reserveBalance;
427     emit Transfer(address(0), reserveTimelock, reserveBalance);
428 
429     uint teamBalance = 9750000 * factor;
430 		balances[teamTimelock] = teamBalance;
431     emit Transfer(address(0), teamTimelock, teamBalance);
432 
433     uint ownerBalance = 34450000 * factor;
434 		balances[msg.sender] = ownerBalance;
435     emit Transfer(address(0), msg.sender, ownerBalance);
436 
437 	}
438 	
439 	/**
440 	* @dev Burns a specific amount of tokens, could be called only once
441 	* @param _value The amount of token to be burned.
442 	*/
443 	function burn(uint256 _value) public onlyOwner {
444 		require(!burnt);
445 		require(_value > 0);
446 		require(_value <= balances[msg.sender]);
447 		require(block.timestamp < 1690848000); //tokens are available to be burnt only for 5 years
448 
449 		balances[msg.sender] = balances[msg.sender].sub(_value);
450 		totalSupply_ = totalSupply_.sub(_value);
451 		burnt = true;
452 		emit Burn(msg.sender, _value);
453 		emit Transfer(msg.sender, address(0), _value);
454 	}
455 
456 	/**
457 	* @dev Moves locked tokens to reserve account. Could be called only after release time, 
458 	* otherwise would throw an exeption.
459 	*/
460 	function releaseReserveTokens() public {
461 		reserveTimelock.release();
462 	}
463 
464 	/**
465 	* @dev Moves locked tokens to team account. Could be called only after release time, 
466 	* otherwise would throw an exeption.
467 	*/
468 	function releaseTeamTokens() public {
469 		teamTimelock.release();
470 	}
471 
472 }