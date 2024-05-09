1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22 
23   address public owner;
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   /**
84   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 }
144 
145 /**
146  * @title Burnable Token
147  * @dev Token that can be irreversibly burned (destroyed).
148  */
149 contract BurnableToken is BasicToken {
150 
151   event Burn(address indexed burner, uint256 value);
152 
153   /**
154    * @dev Burns a specific amount of tokens.
155    * @param _value The amount of token to be burned.
156    */
157   function burn(uint256 _value) public {
158     require(_value <= balances[msg.sender]);
159     // no need to require value <= totalSupply, since that would imply the
160     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
161 
162     address burner = msg.sender;
163     balances[burner] = balances[burner].sub(_value);
164     totalSupply_ = totalSupply_.sub(_value);
165     Burn(burner, _value);
166   }
167 }
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) public view returns (uint256);
175   function transferFrom(address from, address to, uint256 value) public returns (bool);
176   function approve(address spender, uint256 value) public returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) public view returns (uint256) {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 }
272 
273 /**
274  * @title Pausable
275  * @dev Base contract which allows children to implement an emergency stop mechanism.
276  */
277 contract Pausable is Ownable {
278   event Pause();
279   event Unpause();
280 
281   bool public paused = false;
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is not paused.
285    */
286   modifier whenNotPaused() {
287     require(!paused);
288     _;
289   }
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is paused.
293    */
294   modifier whenPaused() {
295     require(paused);
296     _;
297   }
298 
299   /**
300    * @dev called by the owner to pause, triggers stopped state
301    */
302   function pause() onlyOwner whenNotPaused public {
303     paused = true;
304     Pause();
305   }
306 
307   /**
308    * @dev called by the owner to unpause, returns to normal state
309    */
310   function unpause() onlyOwner whenPaused public {
311     paused = false;
312     Unpause();
313   }
314 }
315 
316 /**
317  * @title Pausable token
318  * @dev StandardToken modified with pausable transfers.
319  **/
320 contract PausableToken is StandardToken, Pausable {
321 
322   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transfer(_to, _value);
324   }
325 
326   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
327     return super.transferFrom(_from, _to, _value);
328   }
329 
330   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
331     return super.approve(_spender, _value);
332   }
333 
334   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
335     return super.increaseApproval(_spender, _addedValue);
336   }
337 
338   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
339     return super.decreaseApproval(_spender, _subtractedValue);
340   }
341 }
342 
343 contract GrainToken is BurnableToken, PausableToken {
344 
345     string public name = "GrainToken";
346 
347     string public symbol = "GRAIN";
348 
349     uint256 public decimals = 18;
350 
351     // @dev Initial supply of Grain tokens (3.6B tokens, with 18 decimals)
352     uint256 public initialSupply = 3600000000 * (10 ** decimals);
353 
354     function GrainToken() public {
355         totalSupply_ = initialSupply;
356         balances[msg.sender] = initialSupply;
357     }
358 
359     function multipleTransfer(address[] investors, uint256[] amounts) public whenNotPaused {
360         require(investors.length == amounts.length);
361 
362         for (uint256 i = 0; i < investors.length; i++) {
363             address investor = investors[i];
364             uint256 amount = amounts[i];
365             transfer(investor, amount);
366         }
367     }
368 }