1 pragma solidity ^0.4.24;
2 /* compiler: 0.4.24+commit.e67f0147.Linux.g++ */
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender)
26     public view returns (uint256);
27 
28   function transferFrom(address from, address to, uint256 value)
29     public returns (bool);
30 
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (a == 0) {
55       return 0;
56     }
57 
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 
93 
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public
166     returns (bool)
167   {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(
202     address _owner,
203     address _spender
204    )
205     public
206     view
207     returns (uint256)
208   {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipRenounced(address indexed previousOwner);
276   event OwnershipTransferred(
277     address indexed previousOwner,
278     address indexed newOwner
279   );
280 
281 
282   /**
283    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
284    * account.
285    */
286   constructor() public {
287     owner = msg.sender;
288   }
289 
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297 
298   /**
299    * @dev Allows the current owner to relinquish control of the contract.
300    */
301   function renounceOwnership() public onlyOwner {
302     emit OwnershipRenounced(owner);
303     owner = address(0);
304   }
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address _newOwner) public onlyOwner {
311     _transferOwnership(_newOwner);
312   }
313 
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 
325 
326 
327 
328 
329 /**
330  * @title Pausable
331  * @dev Base contract which allows children to implement an emergency stop mechanism.
332  */
333 contract Pausable is Ownable {
334   event Pause();
335   event Unpause();
336 
337   bool public paused = false;
338 
339 
340   /**
341    * @dev Modifier to make a function callable only when the contract is not paused.
342    */
343   modifier whenNotPaused() {
344     require(!paused);
345     _;
346   }
347 
348   /**
349    * @dev Modifier to make a function callable only when the contract is paused.
350    */
351   modifier whenPaused() {
352     require(paused);
353     _;
354   }
355 
356   /**
357    * @dev called by the owner to pause, triggers stopped state
358    */
359   function pause() onlyOwner whenNotPaused public {
360     paused = true;
361     emit Pause();
362   }
363 
364   /**
365    * @dev called by the owner to unpause, returns to normal state
366    */
367   function unpause() onlyOwner whenPaused public {
368     paused = false;
369     emit Unpause();
370   }
371 }
372 
373 
374 
375 
376 /**
377  * @title Pausable token
378  * @dev StandardToken modified with pausable transfers.
379  **/
380 contract PausableToken is StandardToken, Pausable {
381 
382   function transfer(
383     address _to,
384     uint256 _value
385   )
386     public
387     whenNotPaused
388     returns (bool)
389   {
390     return super.transfer(_to, _value);
391   }
392 
393   function transferFrom(
394     address _from,
395     address _to,
396     uint256 _value
397   )
398     public
399     whenNotPaused
400     returns (bool)
401   {
402     return super.transferFrom(_from, _to, _value);
403   }
404 
405   function approve(
406     address _spender,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.approve(_spender, _value);
414   }
415 
416   function increaseApproval(
417     address _spender,
418     uint _addedValue
419   )
420     public
421     whenNotPaused
422     returns (bool success)
423   {
424     return super.increaseApproval(_spender, _addedValue);
425   }
426 
427   function decreaseApproval(
428     address _spender,
429     uint _subtractedValue
430   )
431     public
432     whenNotPaused
433     returns (bool success)
434   {
435     return super.decreaseApproval(_spender, _subtractedValue);
436   }
437 }
438 
439 
440 
441 contract NdxToken is PausableToken {
442 	string public constant   symbol = "NDXX";
443 	string public constant     name = "NDX Token";
444 	uint8  public constant decimals = 18;
445 
446 	uint256 private constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
447 
448 	address private constant REBECCA_FORBID_ACCESS = address(0x66633994b1dacce55);
449 
450 	constructor() public {
451 		totalSupply_ = INITIAL_SUPPLY;
452 		balances[msg.sender] = INITIAL_SUPPLY;
453 		emit Transfer(REBECCA_FORBID_ACCESS, msg.sender, INITIAL_SUPPLY);
454 	}
455 }