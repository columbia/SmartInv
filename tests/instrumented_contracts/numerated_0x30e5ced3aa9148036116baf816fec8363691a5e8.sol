1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
142 
143 /**
144  * @title Ownable
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() public {
160     owner = msg.sender;
161   }
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) public onlyOwner {
176     require(newOwner != address(0));
177     emit OwnershipTransferred(owner, newOwner);
178     owner = newOwner;
179   }
180 
181 }
182 
183 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
184 
185 /**
186  * @title Pausable
187  * @dev Base contract which allows children to implement an emergency stop mechanism.
188  */
189 contract Pausable is Ownable {
190   event Pause();
191   event Unpause();
192 
193   bool public paused = false;
194 
195 
196   /**
197    * @dev Modifier to make a function callable only when the contract is not paused.
198    */
199   modifier whenNotPaused() {
200     require(!paused);
201     _;
202   }
203 
204   /**
205    * @dev Modifier to make a function callable only when the contract is paused.
206    */
207   modifier whenPaused() {
208     require(paused);
209     _;
210   }
211 
212   /**
213    * @dev called by the owner to pause, triggers stopped state
214    */
215   function pause() onlyOwner whenNotPaused public {
216     paused = true;
217     emit Pause();
218   }
219 
220   /**
221    * @dev called by the owner to unpause, returns to normal state
222    */
223   function unpause() onlyOwner whenPaused public {
224     paused = false;
225     emit Unpause();
226   }
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
230 
231 /**
232  * @title ERC20 interface
233  * @dev see https://github.com/ethereum/EIPs/issues/20
234  */
235 contract ERC20 is ERC20Basic {
236   function allowance(address owner, address spender) public view returns (uint256);
237   function transferFrom(address from, address to, uint256 value) public returns (bool);
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
243 
244 /**
245  * @title Standard ERC20 token
246  *
247  * @dev Implementation of the basic standard token.
248  * @dev https://github.com/ethereum/EIPs/issues/20
249  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
250  */
251 contract StandardToken is ERC20, BasicToken {
252 
253   mapping (address => mapping (address => uint256)) internal allowed;
254 
255 
256   /**
257    * @dev Transfer tokens from one address to another
258    * @param _from address The address which you want to send tokens from
259    * @param _to address The address which you want to transfer to
260    * @param _value uint256 the amount of tokens to be transferred
261    */
262   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0));
264     require(_value <= balances[_from]);
265     require(_value <= allowed[_from][msg.sender]);
266 
267     balances[_from] = balances[_from].sub(_value);
268     balances[_to] = balances[_to].add(_value);
269     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270     emit Transfer(_from, _to, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276    *
277    * Beware that changing an allowance with this method brings the risk that someone may use both the old
278    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) public returns (bool) {
285     allowed[msg.sender][_spender] = _value;
286     emit Approval(msg.sender, _spender, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Function to check the amount of tokens that an owner allowed to a spender.
292    * @param _owner address The address which owns the funds.
293    * @param _spender address The address which will spend the funds.
294    * @return A uint256 specifying the amount of tokens still available for the spender.
295    */
296   function allowance(address _owner, address _spender) public view returns (uint256) {
297     return allowed[_owner][_spender];
298   }
299 
300   /**
301    * @dev Increase the amount of tokens that an owner allowed to a spender.
302    *
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
311     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
312     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316   /**
317    * @dev Decrease the amount of tokens that an owner allowed to a spender.
318    *
319    * approve should be called when allowed[_spender] == 0. To decrement
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _subtractedValue The amount of tokens to decrease the allowance by.
325    */
326   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
327     uint oldValue = allowed[msg.sender][_spender];
328     if (_subtractedValue > oldValue) {
329       allowed[msg.sender][_spender] = 0;
330     } else {
331       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332     }
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337 }
338 
339 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
340 
341 /**
342  * @title Pausable token
343  * @dev StandardToken modified with pausable transfers.
344  **/
345 contract PausableToken is StandardToken, Pausable {
346 
347   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
348     return super.transfer(_to, _value);
349   }
350 
351   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
352     return super.transferFrom(_from, _to, _value);
353   }
354 
355   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
356     return super.approve(_spender, _value);
357   }
358 
359   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
360     return super.increaseApproval(_spender, _addedValue);
361   }
362 
363   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
364     return super.decreaseApproval(_spender, _subtractedValue);
365   }
366 }
367 
368 // File: contracts/token/AlphaCarToken.sol
369 
370 // ----------------------------------------------------------------------------
371 // Alpha Car Token smart contract - ERC20 Token Interface
372 // ----- www.alphacar.io -----
373 //
374 // The MIT Licence.
375 // ----------------------------------------------------------------------------
376 
377 contract AlphaCarToken is PausableToken, BurnableToken {
378   
379   string public symbol = "ACAR";
380 
381   string public name = "AlphaCar Token";
382   
383   uint8 public decimals = 18;
384 
385   uint public constant INITIAL_SUPPLY = 100 * 10 ** 8 * 10 ** 18;
386 
387   function AlphaCarToken() public {
388     totalSupply_ = INITIAL_SUPPLY;
389     balances[msg.sender] = INITIAL_SUPPLY;
390     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
391   }
392 
393   function () payable public {
394     revert();
395   }
396 
397 }