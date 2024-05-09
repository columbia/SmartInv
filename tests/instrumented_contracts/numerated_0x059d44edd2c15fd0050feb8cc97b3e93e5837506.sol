1 pragma solidity ^0.4.17;
2 
3 // Sources: https://github.com/OpenZeppelin/openzeppelin-solidity
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     if (a == 0) {
42       return 0;
43     }
44     c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   uint256 totalSupply_;
88 
89   /**
90   * @dev total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 
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
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     emit Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public view returns (uint256) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * @dev Increase the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _addedValue The amount of tokens to increase the allowance by.
188    */
189   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _subtractedValue The amount of tokens to decrease the allowance by.
204    */
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 
219 /**
220  * @title Ownable
221  * @dev The Ownable contract has an owner address, and provides basic authorization control
222  * functions, this simplifies the implementation of "user permissions".
223  */
224 contract Ownable {
225   address public owner;
226 
227 
228   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230 
231   /**
232    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
233    * account.
234    */
235   constructor() public {
236     owner = msg.sender;
237   }
238 
239   /**
240    * @dev Throws if called by any account other than the owner.
241    */
242   modifier onlyOwner() {
243     require(msg.sender == owner);
244     _;
245   }
246 
247   /**
248    * @dev Allows the current owner to transfer control of the contract to a newOwner.
249    * @param newOwner The address to transfer ownership to.
250    */
251   function transferOwnership(address newOwner) public onlyOwner {
252     require(newOwner != address(0));
253     emit OwnershipTransferred(owner, newOwner);
254     owner = newOwner;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Ownable {
265   event Pause();
266   event Unpause();
267 
268   bool public paused = false;
269 
270 
271   /**
272    * @dev Modifier to make a function callable only when the contract is not paused.
273    */
274   modifier whenNotPaused() {
275     require(!paused);
276     _;
277   }
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is paused.
281    */
282   modifier whenPaused() {
283     require(paused);
284     _;
285   }
286 
287   /**
288    * @dev called by the owner to pause, triggers stopped state
289    */
290   function pause() onlyOwner whenNotPaused public {
291     paused = true;
292     emit Pause();
293   }
294 
295   /**
296    * @dev called by the owner to unpause, returns to normal state
297    */
298   function unpause() onlyOwner whenPaused public {
299     paused = false;
300     emit Unpause();
301   }
302 }
303 
304 /**
305  * @title DecorumToken
306  * @dev Actual ERC20 Project Decorum Token contract.
307  */
308 contract DecorumToken is StandardToken, Pausable {
309   string public name = 'Project Decorum Coin';
310   string public symbol = 'PDC';
311   uint8 public constant decimals = 8;
312 
313   /// @dev 50,000,000 tokens
314   uint256 public constant INITIAL_SUPPLY = 50000000 * (10 ** uint256(decimals));
315 
316   /**
317    * @dev Transfer the initial supply to the sender (owner) of contract.
318    */
319   constructor() public {
320     balances[msg.sender] = INITIAL_SUPPLY;
321     totalSupply_ = INITIAL_SUPPLY;
322     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
323 
324     pause();
325   }
326 
327   /**
328    * @dev Set a new name.
329    *
330    * @param _name Name.
331    */
332   function setName(string _name) public onlyOwner {
333     name = _name;
334   }
335 
336   /**
337    * @dev Set a new symbol.
338    *
339    * @param _symbol Symbol.
340    */
341   function setSymbol(string _symbol) public onlyOwner {
342     symbol = _symbol;
343   }
344 
345   /**
346    * @dev Make transferFrom pausable
347    */
348   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   /**
353    * @dev Call approve() for multiple spenders.
354    *
355    * @param _spenders The addresses which will spend the funds.
356    * @param _values The amounts of tokens to be spent.
357    */
358   function approveBatch(address[] _spenders, uint256[] _values) public onlyOwner returns (bool) {
359     for (uint i = 0; i < _spenders.length; i++) {
360       approve(_spenders[i], _values[i]);
361     }
362 
363     return true;
364   }
365 
366   /**
367    * @dev Call increaseApproval() for multiple spenders.
368    *
369    * @param _spenders The addresses which will spend the funds.
370    * @param _addedValues The amounts of tokens to be added.
371    */
372   function increaseApprovalBatch(address[] _spenders, uint256[] _addedValues) public onlyOwner returns (bool) {
373     for (uint i = 0; i < _spenders.length; i++) {
374       increaseApproval(_spenders[i], _addedValues[i]);
375     }
376 
377     return true;
378   }
379 }