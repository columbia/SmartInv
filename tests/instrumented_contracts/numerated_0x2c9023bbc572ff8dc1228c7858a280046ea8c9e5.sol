1 pragma solidity ^0.4.23;
2 
3 // openzeppelin-solidity: 1.10.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 /**
65  * @title Pausable
66  * @dev Base contract which allows children to implement an emergency stop mechanism.
67  */
68 contract Pausable is Ownable {
69   event Pause();
70   event Unpause();
71 
72   bool public paused = false;
73 
74 
75   /**
76    * @dev Modifier to make a function callable only when the contract is not paused.
77    */
78   modifier whenNotPaused() {
79     require(!paused);
80     _;
81   }
82 
83   /**
84    * @dev Modifier to make a function callable only when the contract is paused.
85    */
86   modifier whenPaused() {
87     require(paused);
88     _;
89   }
90 
91   /**
92    * @dev called by the owner to pause, triggers stopped state
93    */
94   function pause() onlyOwner whenNotPaused public {
95     paused = true;
96     emit Pause();
97   }
98 
99   /**
100    * @dev called by the owner to unpause, returns to normal state
101    */
102   function unpause() onlyOwner whenPaused public {
103     paused = false;
104     emit Unpause();
105   }
106 }
107 
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that throw on error
111  */
112 library SafeMath {
113 
114   /**
115   * @dev Multiplies two numbers, throws on overflow.
116   */
117   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
119     // benefit is lost if 'b' is also tested.
120     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
121     if (a == 0) {
122       return 0;
123     }
124 
125     c = a * b;
126     assert(c / a == b);
127     return c;
128   }
129 
130   /**
131   * @dev Integer division of two numbers, truncating the quotient.
132   */
133   function div(uint256 a, uint256 b) internal pure returns (uint256) {
134     // assert(b > 0); // Solidity automatically throws when dividing by 0
135     // uint256 c = a / b;
136     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137     return a / b;
138   }
139 
140   /**
141   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
142   */
143   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144     assert(b <= a);
145     return a - b;
146   }
147 
148   /**
149   * @dev Adds two numbers, throws on overflow.
150   */
151   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
152     c = a + b;
153     assert(c >= a);
154     return c;
155   }
156 }
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   function totalSupply() public view returns (uint256);
165   function balanceOf(address who) public view returns (uint256);
166   function transfer(address to, uint256 value) public returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender)
176     public view returns (uint256);
177 
178   function transferFrom(address from, address to, uint256 value)
179     public returns (bool);
180 
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(
183     address indexed owner,
184     address indexed spender,
185     uint256 value
186   );
187 }
188 
189 /**
190  * @title Basic token
191  * @dev Basic version of StandardToken, with no allowances.
192  */
193 contract BasicToken is ERC20Basic {
194   using SafeMath for uint256;
195 
196   mapping(address => uint256) balances;
197 
198   uint256 totalSupply_;
199 
200   /**
201   * @dev total number of tokens in existence
202   */
203   function totalSupply() public view returns (uint256) {
204     return totalSupply_;
205   }
206 
207   /**
208   * @dev transfer token for a specified address
209   * @param _to The address to transfer to.
210   * @param _value The amount to be transferred.
211   */
212   function transfer(address _to, uint256 _value) public returns (bool) {
213     require(_to != address(0));
214     require(_value <= balances[msg.sender]);
215 
216     balances[msg.sender] = balances[msg.sender].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     emit Transfer(msg.sender, _to, _value);
219     return true;
220   }
221 
222   /**
223   * @dev Gets the balance of the specified address.
224   * @param _owner The address to query the the balance of.
225   * @return An uint256 representing the amount owned by the passed address.
226   */
227   function balanceOf(address _owner) public view returns (uint256) {
228     return balances[_owner];
229   }
230 
231 }
232 
233 /**
234  * @title Standard ERC20 token
235  *
236  * @dev Implementation of the basic standard token.
237  * @dev https://github.com/ethereum/EIPs/issues/20
238  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  */
240 contract StandardToken is ERC20, BasicToken {
241 
242   mapping (address => mapping (address => uint256)) internal allowed;
243 
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(
252     address _from,
253     address _to,
254     uint256 _value
255   )
256     public
257     returns (bool)
258   {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     emit Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(
293     address _owner,
294     address _spender
295    )
296     public
297     view
298     returns (uint256)
299   {
300     return allowed[_owner][_spender];
301   }
302 
303   /**
304    * @dev Increase the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To increment
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _addedValue The amount of tokens to increase the allowance by.
312    */
313   function increaseApproval(
314     address _spender,
315     uint _addedValue
316   )
317     public
318     returns (bool)
319   {
320     allowed[msg.sender][_spender] = (
321       allowed[msg.sender][_spender].add(_addedValue));
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Decrease the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(
337     address _spender,
338     uint _subtractedValue
339   )
340     public
341     returns (bool)
342   {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 /**
356  * @title Pausable token
357  * @dev StandardToken modified with pausable transfers.
358  **/
359 contract PausableToken is StandardToken, Pausable {
360 
361   function transfer(
362     address _to,
363     uint256 _value
364   )
365     public
366     whenNotPaused
367     returns (bool)
368   {
369     return super.transfer(_to, _value);
370   }
371 
372   function transferFrom(
373     address _from,
374     address _to,
375     uint256 _value
376   )
377     public
378     whenNotPaused
379     returns (bool)
380   {
381     return super.transferFrom(_from, _to, _value);
382   }
383 
384   function approve(
385     address _spender,
386     uint256 _value
387   )
388     public
389     whenNotPaused
390     returns (bool)
391   {
392     return super.approve(_spender, _value);
393   }
394 
395   function increaseApproval(
396     address _spender,
397     uint _addedValue
398   )
399     public
400     whenNotPaused
401     returns (bool success)
402   {
403     return super.increaseApproval(_spender, _addedValue);
404   }
405 
406   function decreaseApproval(
407     address _spender,
408     uint _subtractedValue
409   )
410     public
411     whenNotPaused
412     returns (bool success)
413   {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416 }
417 
418 contract VideoCoin is PausableToken {
419 
420   string public constant name = "VideoCoin";
421   string public constant symbol = "VID";
422   uint8 public constant decimals = 18;
423   uint256 public constant INITIAL_SUPPLY = 265e6 * 10**uint256(decimals);
424 
425   constructor() {
426     totalSupply_ = INITIAL_SUPPLY;
427     balances[msg.sender] = INITIAL_SUPPLY;
428     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
429   }
430 }