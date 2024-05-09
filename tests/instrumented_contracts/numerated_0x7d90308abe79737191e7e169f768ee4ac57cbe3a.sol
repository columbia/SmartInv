1 pragma solidity ^0.4.23;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public view returns (uint256) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender)
109     public view returns (uint256);
110 
111   function transferFrom(address from, address to, uint256 value)
112     public returns (bool);
113 
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(
116     address indexed owner,
117     address indexed spender,
118     uint256 value
119   );
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(
142     address _from,
143     address _to,
144     uint256 _value
145   )
146     public
147     returns (bool)
148   {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(
183     address _owner,
184     address _spender
185    )
186     public
187     view
188     returns (uint256)
189   {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(
204     address _spender,
205     uint _addedValue
206   )
207     public
208     returns (bool)
209   {
210     allowed[msg.sender][_spender] = (
211       allowed[msg.sender][_spender].add(_addedValue));
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Ownable
248  * @dev The Ownable contract has an owner address, and provides basic authorization control
249  * functions, this simplifies the implementation of "user permissions".
250  */
251 contract Ownable {
252   address public owner;
253 
254 
255   event OwnershipRenounced(address indexed previousOwner);
256   event OwnershipTransferred(
257     address indexed previousOwner,
258     address indexed newOwner
259   );
260 
261 
262   /**
263    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
264    * account.
265    */
266   constructor() public {
267     owner = msg.sender;
268   }
269 
270   /**
271    * @dev Throws if called by any account other than the owner.
272    */
273   modifier onlyOwner() {
274     require(msg.sender == owner);
275     _;
276   }
277 
278   /**
279    * @dev Allows the current owner to relinquish control of the contract.
280    */
281   function renounceOwnership() public onlyOwner {
282     emit OwnershipRenounced(owner);
283     owner = address(0);
284   }
285 
286   /**
287    * @dev Allows the current owner to transfer control of the contract to a newOwner.
288    * @param _newOwner The address to transfer ownership to.
289    */
290   function transferOwnership(address _newOwner) public onlyOwner {
291     _transferOwnership(_newOwner);
292   }
293 
294   /**
295    * @dev Transfers control of the contract to a newOwner.
296    * @param _newOwner The address to transfer ownership to.
297    */
298   function _transferOwnership(address _newOwner) internal {
299     require(_newOwner != address(0));
300     emit OwnershipTransferred(owner, _newOwner);
301     owner = _newOwner;
302   }
303 }
304 
305 
306 /**
307  * @title Pausable
308  * @dev Base contract which allows children to implement an emergency stop mechanism.
309  */
310 contract Pausable is Ownable {
311   event Pause();
312   event Unpause();
313 
314   bool public paused = false;
315 
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused.
319    */
320   modifier whenNotPaused() {
321     require(!paused);
322     _;
323   }
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is paused.
327    */
328   modifier whenPaused() {
329     require(paused);
330     _;
331   }
332 
333   /**
334    * @dev called by the owner to pause, triggers stopped state
335    */
336   function pause() onlyOwner whenNotPaused public {
337     paused = true;
338     emit Pause();
339   }
340 
341   /**
342    * @dev called by the owner to unpause, returns to normal state
343    */
344   function unpause() onlyOwner whenPaused public {
345     paused = false;
346     emit Unpause();
347   }
348 }
349 
350 
351 /**
352  * @title Pausable token
353  * @dev StandardToken modified with pausable transfers.
354  **/
355 contract PausableToken is StandardToken, Pausable {
356 
357   function transfer(
358     address _to,
359     uint256 _value
360   )
361     public
362     whenNotPaused
363     returns (bool)
364   {
365     return super.transfer(_to, _value);
366   }
367 
368   function transferFrom(
369     address _from,
370     address _to,
371     uint256 _value
372   )
373     public
374     whenNotPaused
375     returns (bool)
376   {
377     return super.transferFrom(_from, _to, _value);
378   }
379 
380   function approve(
381     address _spender,
382     uint256 _value
383   )
384     public
385     whenNotPaused
386     returns (bool)
387   {
388     return super.approve(_spender, _value);
389   }
390 
391   function increaseApproval(
392     address _spender,
393     uint _addedValue
394   )
395     public
396     whenNotPaused
397     returns (bool success)
398   {
399     return super.increaseApproval(_spender, _addedValue);
400   }
401 
402   function decreaseApproval(
403     address _spender,
404     uint _subtractedValue
405   )
406     public
407     whenNotPaused
408     returns (bool success)
409   {
410     return super.decreaseApproval(_spender, _subtractedValue);
411   }
412 }
413 
414 
415 contract SphinxToken is PausableToken {
416   string public constant name = "SphinxToken";
417   string public constant symbol = "SPX";
418   uint8 public constant decimals = 18;
419   uint256 public constant totalSupply = 10000000000000000000000000000;
420 
421   constructor() public {
422     balances[msg.sender] = totalSupply;
423   }
424 }