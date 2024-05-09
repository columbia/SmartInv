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
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
102     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (a == 0) {
106       return 0;
107     }
108 
109     c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return a / b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   uint256 totalSupply_;
154 
155   /**
156   * @dev Total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return totalSupply_;
160   }
161 
162   /**
163   * @dev Transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170 
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     emit Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) public view returns (uint256) {
183     return balances[_owner];
184   }
185 
186 }
187 
188 
189 
190 
191 
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198   function allowance(address owner, address spender)
199     public view returns (uint256);
200 
201   function transferFrom(address from, address to, uint256 value)
202     public returns (bool);
203 
204   function approve(address spender, uint256 value) public returns (bool);
205   event Approval(
206     address indexed owner,
207     address indexed spender,
208     uint256 value
209   );
210 }
211 
212 
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * https://github.com/ethereum/EIPs/issues/20
219  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(
233     address _from,
234     address _to,
235     uint256 _value
236   )
237     public
238     returns (bool)
239   {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     emit Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     emit Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address _owner,
274     address _spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(
293     address _spender,
294     uint256 _addedValue
295   )
296     public
297     returns (bool)
298   {
299     allowed[msg.sender][_spender] = (
300       allowed[msg.sender][_spender].add(_addedValue));
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(
315     address _spender,
316     uint256 _subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     uint256 oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 
334 
335 
336 
337 
338 
339 /**
340  * @title Pausable
341  * @dev Base contract which allows children to implement an emergency stop mechanism.
342  */
343 contract Pausable is Ownable {
344   event Pause();
345   event Unpause();
346 
347   bool public paused = false;
348 
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is not paused.
352    */
353   modifier whenNotPaused() {
354     require(!paused);
355     _;
356   }
357 
358   /**
359    * @dev Modifier to make a function callable only when the contract is paused.
360    */
361   modifier whenPaused() {
362     require(paused);
363     _;
364   }
365 
366   /**
367    * @dev called by the owner to pause, triggers stopped state
368    */
369   function pause() onlyOwner whenNotPaused public {
370     paused = true;
371     emit Pause();
372   }
373 
374   /**
375    * @dev called by the owner to unpause, returns to normal state
376    */
377   function unpause() onlyOwner whenPaused public {
378     paused = false;
379     emit Unpause();
380   }
381 }
382 
383 
384 
385 /**
386  * @title Pausable token
387  * @dev StandardToken modified with pausable transfers.
388  **/
389 contract PausableToken is StandardToken, Pausable {
390 
391   function transfer(
392     address _to,
393     uint256 _value
394   )
395     public
396     whenNotPaused
397     returns (bool)
398   {
399     return super.transfer(_to, _value);
400   }
401 
402   function transferFrom(
403     address _from,
404     address _to,
405     uint256 _value
406   )
407     public
408     whenNotPaused
409     returns (bool)
410   {
411     return super.transferFrom(_from, _to, _value);
412   }
413 
414   function approve(
415     address _spender,
416     uint256 _value
417   )
418     public
419     whenNotPaused
420     returns (bool)
421   {
422     return super.approve(_spender, _value);
423   }
424 
425   function increaseApproval(
426     address _spender,
427     uint _addedValue
428   )
429     public
430     whenNotPaused
431     returns (bool success)
432   {
433     return super.increaseApproval(_spender, _addedValue);
434   }
435 
436   function decreaseApproval(
437     address _spender,
438     uint _subtractedValue
439   )
440     public
441     whenNotPaused
442     returns (bool success)
443   {
444     return super.decreaseApproval(_spender, _subtractedValue);
445   }
446 }
447 
448 
449 contract BitMinutes is PausableToken {
450     string public name = "BitMinutes";
451     string public symbol = "BMT";
452     uint8 public decimals = 18;
453     uint256 public constant TOTAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
454 
455     constructor() public {
456 	    owner = msg.sender;
457 	    totalSupply_ = TOTAL_SUPPLY;
458 	    balances[owner] = totalSupply_;
459 	    emit Transfer(0x0, owner, totalSupply_);
460     }
461 }