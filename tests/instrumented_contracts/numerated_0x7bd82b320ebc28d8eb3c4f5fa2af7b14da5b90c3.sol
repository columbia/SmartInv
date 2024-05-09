1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath 
8 {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37 
38   /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47    * @dev Adds two numbers, throws on overflow.
48    */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable 
63 {
64   address public owner;
65 
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104   
105 }
106 
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Ownable 
113 {
114   event Pause();
115   event Unpause();
116 
117   bool public paused = false;
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is not paused.
121    */
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is paused.
129    */
130   modifier whenPaused() {
131     require(paused);
132     _;
133   }
134 
135   /**
136    * @dev called by the owner to pause, triggers stopped state
137    */
138   function pause() onlyOwner whenNotPaused public {
139     paused = true;
140     emit Pause();
141   }
142 
143   /**
144    * @dev called by the owner to unpauseunpause, returns to normal state
145    */
146   function unpause() onlyOwner whenPaused public {
147     paused = false;
148     emit Unpause();
149   }
150 
151 }
152 
153 /**
154  * @title ERC20Basic
155  * @dev Simpler version of ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/179
157  */
158 contract ERC20Basic 
159 {
160   function totalSupply() public view returns (uint256);
161   function balanceOf(address who) public view returns (uint256);
162   function transfer(address to, uint256 value) public returns (bool);
163   event Transfer(address indexed from, address indexed to, uint256 value);
164 }
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic 
171 {
172   function allowance(address owner, address spender) public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175 
176   function approve(address spender, uint256 value) public returns (bool);
177   
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 
184 }
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances.
189  */
190 contract BasicToken is ERC20Basic 
191 {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param _owner The address to query the the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address _owner) public view returns (uint256) {
226     return balances[_owner];
227   }
228 
229 }
230 
231 
232 /**
233  * @title Standard ERC20 token
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken 
239 {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     emit Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
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
284   function allowance(address _owner, address _spender) public view returns (uint256) {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
299     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
315     uint256 oldValue = allowed[msg.sender][_spender];
316     if (_subtractedValue > oldValue) {
317       allowed[msg.sender][_spender] = 0;
318     } else {
319       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320     }
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325 }
326 
327 
328 /**
329  * @title Pausable token
330  * @dev StandardToken modified with pausable transfers.
331  **/
332 contract PausableToken is StandardToken, Pausable 
333 {
334 
335   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
336     return super.transfer(_to, _value);
337   }
338 
339   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transferFrom(_from, _to, _value);
341   }
342 
343   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
344     return super.approve(_spender, _value);
345   }
346 
347   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
348     return super.increaseApproval(_spender, _addedValue);
349   }
350 
351   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
352     return super.decreaseApproval(_spender, _subtractedValue);
353   }
354 
355 }
356 
357 
358 /**
359  * @title Frozenable Token
360  * @dev Illegal address that can be frozened.
361  */
362 contract FrozenableToken is Ownable 
363 {
364     
365     mapping (address => bool) public frozenAccount;
366 
367     event FrozenFunds(address indexed to, bool frozen);
368 
369     modifier whenNotFrozen(address _who) {
370       require(!frozenAccount[msg.sender] && !frozenAccount[_who]);
371       _;
372     }
373 
374     function freezeAccount(address _to, bool _freeze) public onlyOwner {
375         require(_to != address(0));
376         frozenAccount[_to] = _freeze;
377         emit FrozenFunds(_to, _freeze);
378     }
379 
380 }
381 
382 
383 /**
384  * @title Mozik Token
385  * @dev digital music album NFT platform token.
386  * @author mozik.cc 
387  */
388 contract mozik is PausableToken, FrozenableToken 
389 {
390 
391     string public name = "Mozik Token";
392     string public symbol = "MOZ";
393     uint256 public decimals = 18;
394     uint256 INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
395 
396     /**
397      * @dev Initializes the total release
398      */
399     constructor() public {
400         totalSupply_ = INITIAL_SUPPLY;
401         balances[msg.sender] = totalSupply_;
402         emit Transfer(address(0), msg.sender, totalSupply_);
403     }
404 
405     /**
406      * if ether is sent to this address, send it back.
407      */
408     function() public payable {
409         revert();
410     }
411 
412     /**
413      * @dev transfer token for a specified address
414      * @param _to The address to transfer to.
415      * @param _value The amount to be transferred.
416      */
417     function transfer(address _to, uint256 _value) public whenNotFrozen(_to) returns (bool) {
418         return super.transfer(_to, _value);
419     }
420 
421     /**
422      * @dev Transfer tokens from one address to another
423      * @param _from address The address which you want to send tokens from
424      * @param _to address The address which you want to transfer to
425      * @param _value uint256 the amount of tokens to be transferred
426      */
427     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen(_from) returns (bool) {
428         return super.transferFrom(_from, _to, _value);
429     }        
430     
431 }