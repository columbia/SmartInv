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
11     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
12     */
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   /**
19    * @dev Adds two numbers, throws on overflow.
20    */
21   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     c = a + b;
23     assert(c >= a);
24     return c;
25   }
26   
27 }
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable 
35 {
36   address public owner;
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address _newOwner) public onlyOwner {
65     _transferOwnership(_newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address _newOwner) internal {
73     require(_newOwner != address(0));
74     emit OwnershipTransferred(owner, _newOwner);
75     owner = _newOwner;
76   }
77   
78 }
79 
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable 
86 {
87   event Pause();
88   event Unpause();
89 
90   bool public paused = false;
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     emit Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpauseunpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     emit Unpause();
122   }
123 
124 }
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic 
132 {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address who) public view returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic 
144 {
145   function allowance(address owner, address spender) public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148 
149   function approve(address spender, uint256 value) public returns (bool);
150   
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 
157 }
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic 
164 {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256) {
199     return balances[_owner];
200   }
201 
202 }
203 
204 
205 /**
206  * @title Standard ERC20 token
207  * @dev Implementation of the basic standard token.
208  * @dev https://github.com/ethereum/EIPs/issues/20
209  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
210  */
211 contract StandardToken is ERC20, BasicToken 
212 {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param _from address The address which you want to send tokens from
219    * @param _to address The address which you want to transfer to
220    * @param _value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223     require(_to != address(0));
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226 
227     balances[_from] = balances[_from].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
288     uint256 oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable 
306 {
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
320   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
321     return super.increaseApproval(_spender, _addedValue);
322   }
323 
324   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
325     return super.decreaseApproval(_spender, _subtractedValue);
326   }
327 
328 }
329 
330 
331 /**
332  * @title Frozenable Token
333  * @dev Illegal address that can be frozened.
334  */
335 contract FrozenableToken is Ownable 
336 {
337     
338     mapping (address => bool) public frozenAccount;
339 
340     event FrozenFunds(address indexed to, bool frozen);
341 
342     modifier whenNotFrozen(address _who) {
343       require(!frozenAccount[msg.sender] && !frozenAccount[_who]);
344       _;
345     }
346 
347     function freezeAccount(address _to, bool _freeze) public onlyOwner {
348         require(_to != address(0));
349         frozenAccount[_to] = _freeze;
350         emit FrozenFunds(_to, _freeze);
351     }
352 
353 }
354 
355 
356 /**
357  * @title Ex Token
358  * @dev Global digital game open platform token.
359  * @author Ex.win 
360  */
361 contract BiForst is PausableToken, FrozenableToken 
362 {
363 
364     string public name = "Ex Token";
365     string public symbol = "EX";
366     uint256 public decimals = 18;
367     uint256 INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
368 
369     /**
370      * @dev Initializes the total release
371      */
372     constructor() public {
373         totalSupply_ = INITIAL_SUPPLY;
374         balances[msg.sender] = totalSupply_;
375         emit Transfer(address(0), msg.sender, totalSupply_);
376     }
377 
378     /**
379      * if ether is sent to this address, send it back.
380      */
381     function() public {
382         revert();
383     }
384 
385     /**
386      * @dev transfer token for a specified address
387      * @param _to The address to transfer to.
388      * @param _value The amount to be transferred.
389      */
390     function transfer(address _to, uint256 _value) public whenNotFrozen(_to) returns (bool) {
391         return super.transfer(_to, _value);
392     }
393 
394     /**
395      * @dev Transfer tokens from one address to another
396      * @param _from address The address which you want to send tokens from
397      * @param _to address The address which you want to transfer to
398      * @param _value uint256 the amount of tokens to be transferred
399      */
400     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen(_from) returns (bool) {
401         return super.transferFrom(_from, _to, _value);
402     }        
403     
404 
405 }