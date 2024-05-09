1 pragma solidity ^0.4.25;
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
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipRenounced(address indexed previousOwner);
60   event OwnershipTransferred(
61     address indexed previousOwner,
62     address indexed newOwner
63   );
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 }
100 
101 
102 
103 /**
104  * @title Pausable
105  * @dev Base contract which allows children to implement an emergency stop mechanism.
106  */
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() onlyOwner whenNotPaused public {
134     paused = true;
135     emit Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     emit Unpause();
144   }
145 }
146 
147 
148 /**
149  * @title ERC20Basic
150  * @dev Simpler version of ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/179
152  */
153 contract ERC20Basic {
154   function totalSupply() public view returns (uint256);
155   function balanceOf(address who) public view returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 is ERC20Basic {
166   function allowance(address owner, address spender)
167     public view returns (uint256);
168 
169   function transferFrom(address from, address to, uint256 value)
170     public returns (bool);
171 
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(
174     address indexed owner,
175     address indexed spender,
176     uint256 value
177   );
178 }
179 
180 /**
181  * @title Basic token
182  * @dev Basic version of StandardToken, with no allowances.
183  */
184 contract BasicToken is ERC20Basic {
185   using SafeMath for uint256;
186 
187   mapping(address => uint256) balances;
188 
189   uint256 totalSupply_;
190 
191   /**
192   * @dev total number of tokens in existence
193   */
194   function totalSupply() public view returns (uint256) {
195     return totalSupply_;
196   }
197 
198   /**
199   * @dev transfer token for a specified address
200   * @param _to The address to transfer to.
201   * @param _value The amount to be transferred.
202   */
203   function transfer(address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[msg.sender]);
206 
207     balances[msg.sender] = balances[msg.sender].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     emit Transfer(msg.sender, _to, _value);
210     return true;
211   }
212 
213   /**
214   * @dev Gets the balance of the specified address.
215   * @param _owner The address to query the the balance of.
216   * @return An uint256 representing the amount owned by the passed address.
217   */
218   function balanceOf(address _owner) public view returns (uint256) {
219     return balances[_owner];
220   }
221 
222 }
223 
224 
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implementation of the basic standard token.
229  * @dev https://github.com/ethereum/EIPs/issues/20
230  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  */
232 contract StandardToken is ERC20, BasicToken {
233 
234   mapping (address => mapping (address => uint256)) internal allowed;
235 
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom(
244     address _from,
245     address _to,
246     uint256 _value
247   )
248     public
249     returns (bool)
250   {
251     require(_to != address(0));
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    *
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender The address which will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    */
272   function approve(address _spender, uint256 _value) public returns (bool) {
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(
285     address _owner,
286     address _spender
287    )
288     public
289     view
290     returns (uint256)
291   {
292     return allowed[_owner][_spender];
293   }
294 
295   /**
296    * @dev Increase the amount of tokens that an owner allowed to a spender.
297    *
298    * approve should be called when allowed[_spender] == 0. To increment
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    * @param _spender The address which will spend the funds.
303    * @param _addedValue The amount of tokens to increase the allowance by.
304    */
305   function increaseApproval(
306     address _spender,
307     uint _addedValue
308   )
309     public
310     returns (bool)
311   {
312     allowed[msg.sender][_spender] = (
313       allowed[msg.sender][_spender].add(_addedValue));
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318   /**
319    * @dev Decrease the amount of tokens that an owner allowed to a spender.
320    *
321    * approve should be called when allowed[_spender] == 0. To decrement
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseApproval(
329     address _spender,
330     uint _subtractedValue
331   )
332     public
333     returns (bool)
334   {
335     uint oldValue = allowed[msg.sender][_spender];
336     if (_subtractedValue > oldValue) {
337       allowed[msg.sender][_spender] = 0;
338     } else {
339       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
340     }
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345 }
346 
347 
348 /**
349  * @title Pausable token
350  * @dev StandardToken modified with pausable transfers.
351  **/
352 contract PausableToken is StandardToken, Pausable {
353 
354   function transfer(
355     address _to,
356     uint256 _value
357   )
358     public
359     whenNotPaused
360     returns (bool)
361   {
362     return super.transfer(_to, _value);
363   }
364 
365   function transferFrom(
366     address _from,
367     address _to,
368     uint256 _value
369   )
370     public
371     whenNotPaused
372     returns (bool)
373   {
374     return super.transferFrom(_from, _to, _value);
375   }
376 
377   function approve(
378     address _spender,
379     uint256 _value
380   )
381     public
382     whenNotPaused
383     returns (bool)
384   {
385     return super.approve(_spender, _value);
386   }
387 
388   function increaseApproval(
389     address _spender,
390     uint _addedValue
391   )
392     public
393     whenNotPaused
394     returns (bool success)
395   {
396     return super.increaseApproval(_spender, _addedValue);
397   }
398 
399   function decreaseApproval(
400     address _spender,
401     uint _subtractedValue
402   )
403     public
404     whenNotPaused
405     returns (bool success)
406   {
407     return super.decreaseApproval(_spender, _subtractedValue);
408   }
409 }
410 
411 contract ColdToken is PausableToken {
412     string public name = "Cold Token";
413     string public symbol = "COLD";
414     uint public decimals = 18;
415     uint public INITIAL_SUPPLY = 10**27;
416 
417     constructor() public {
418         totalSupply_ = INITIAL_SUPPLY;
419         balances[msg.sender] = INITIAL_SUPPLY;
420     }
421 }