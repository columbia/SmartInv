1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125   /**
126    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127    * account.
128    */
129   function Ownable() public {
130     owner = msg.sender;
131   }
132 
133 
134   /**
135    * @dev Throws if called by any account other than the owner.
136    */
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 
142 
143   /**
144    * @dev Allows the current owner to transfer control of the contract to a newOwner.
145    * @param newOwner The address to transfer ownership to.
146    */
147   function transferOwnership(address newOwner) onlyOwner public {
148     require(newOwner != address(0));
149     owner = newOwner;
150   }
151 
152 }
153 
154 /**
155  * @title Pausable
156  * @dev Base contract which allows children to implement an emergency stop mechanism.
157  */
158 contract Pausable is Ownable {
159   event Pause();
160   event Unpause();
161 
162   bool public paused = true;
163 
164 
165   /**
166    * @dev Modifier to make a function callable only when the contract is not paused.
167    */
168   modifier whenNotPaused() {
169     require(!paused);
170     _;
171   }
172 
173   /**
174    * @dev Modifier to make a function callable only when the contract is paused.
175    */
176   modifier whenPaused() {
177     require(paused);
178     _;
179   }
180 
181   /**
182    * @dev called by the owner to pause, triggers stopped state
183    */
184   function pause() onlyOwner whenNotPaused public {
185     paused = true;
186     Pause();
187   }
188 
189   /**
190    * @dev called by the owner to unpause, returns to normal state
191    */
192   function unpause() onlyOwner whenPaused public {
193     paused = false;
194     Unpause();
195   }
196 }
197 
198 /**
199  * @title Burnable Token
200  * @dev Token that can be irreversibly burned (destroyed).
201  */
202 contract BurnableToken is BasicToken {
203 
204   event Burn(address indexed burner, uint256 value);
205 
206   /**
207    * @dev Burns a specific amount of tokens.
208    * @param _value The amount of token to be burned.
209    */
210   function burn(uint256 _value) public {
211     require(_value <= balances[msg.sender]);
212     // no need to require value <= totalSupply, since that would imply the
213     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
214 
215     address burner = msg.sender;
216     balances[burner] = balances[burner].sub(_value);
217     totalSupply_ = totalSupply_.sub(_value);
218     Burn(burner, _value);
219     Transfer(burner, address(0), _value);
220   }
221 }
222 
223 
224 /**
225  * @title Standard ERC20 token
226  *
227  * @dev Implementation of the basic standard token.
228  * @dev https://github.com/ethereum/EIPs/issues/20
229  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
230  */
231 contract StandardToken is ERC20, BurnableToken {
232 
233   mapping (address => mapping (address => uint256)) internal allowed;
234 
235 
236   /**
237    * @dev Transfer tokens from one address to another
238    * @param _from address The address which you want to send tokens from
239    * @param _to address The address which you want to transfer to
240    * @param _value uint256 the amount of tokens to be transferred
241    */
242   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
243     require(_to != address(0));
244     require(_value <= balances[_from]);
245     require(_value <= allowed[_from][msg.sender]);
246 
247     balances[_from] = balances[_from].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250     Transfer(_from, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
256    *
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param _spender The address which will spend the funds.
262    * @param _value The amount of tokens to be spent.
263    */
264   function approve(address _spender, uint256 _value) public returns (bool) {
265     allowed[msg.sender][_spender] = _value;
266     Approval(msg.sender, _spender, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Function to check the amount of tokens that an owner allowed to a spender.
272    * @param _owner address The address which owns the funds.
273    * @param _spender address The address which will spend the funds.
274    * @return A uint256 specifying the amount of tokens still available for the spender.
275    */
276   function allowance(address _owner, address _spender) public view returns (uint256) {
277     return allowed[_owner][_spender];
278   }
279 
280   /**
281    * @dev Increase the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
291     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
292     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296   /**
297    * @dev Decrease the amount of tokens that an owner allowed to a spender.
298    *
299    * approve should be called when allowed[_spender] == 0. To decrement
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _subtractedValue The amount of tokens to decrease the allowance by.
305    */
306   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
307     uint oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue > oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 /**
320  * @title Pausable token
321  * @dev StandardToken modified with pausable transfers.
322  **/
323 contract PausableToken is StandardToken, Pausable {
324 
325   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
326     return super.transferFrom(_from, _to, _value);
327   }
328 
329   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
330     return super.approve(_spender, _value);
331   }
332 
333   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
334     return super.increaseApproval(_spender, _addedValue);
335   }
336 
337   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
338     return super.decreaseApproval(_spender, _subtractedValue);
339   }
340 }
341 
342 
343 contract ECOS is PausableToken {
344 
345   string public constant name = "ECOS";
346   string public constant symbol = "ECOS";
347   uint8 public constant decimals = 18;
348 
349   uint256 public constant INITIAL_SUPPLY = 770000000 * (10 ** uint256(decimals));
350   address public initialTokenOwner;
351   
352   modifier isAdmin() {
353     require(msg.sender == initialTokenOwner || msg.sender == owner);
354     _;
355   }
356   
357   modifier whenNotPausedOrAdmin () {
358       require(msg.sender == initialTokenOwner || msg.sender == owner || !paused);
359       _;
360   }
361   
362   function transfer(address _to, uint256 _value) public whenNotPausedOrAdmin returns (bool) {
363     return super.transfer(_to, _value);
364   }
365 
366   function ECOS(address tokenOwner) public {
367     totalSupply_ = INITIAL_SUPPLY;
368     balances[tokenOwner] = INITIAL_SUPPLY;
369     initialTokenOwner = tokenOwner;
370     Transfer(0x0, tokenOwner, INITIAL_SUPPLY);
371   }
372   
373   function sendTokens(address _to, uint _value) public isAdmin returns (bool) {
374     require(_to != address(0));
375     require(_value <= balances[initialTokenOwner]);
376     balances[initialTokenOwner] = balances[initialTokenOwner].sub(_value);
377     balances[_to] = balances[_to].add(_value);
378     Transfer(initialTokenOwner, _to, _value);
379     return true;
380   }
381 
382 }