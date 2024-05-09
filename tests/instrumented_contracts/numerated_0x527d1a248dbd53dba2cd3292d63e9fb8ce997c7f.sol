1 pragma solidity ^0.4.18;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
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
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135     Transfer(burner, address(0), _value);
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
182 
183 /**
184  * @title Pausable
185  * @dev Base contract which allows children to implement an emergency stop mechanism.
186  */
187 contract Pausable is Ownable {
188   event Pause();
189   event Unpause();
190 
191   bool public paused = false;
192 
193 
194   /**
195    * @dev Modifier to make a function callable only when the contract is not paused.
196    */
197   modifier whenNotPaused() {
198     require(!paused);
199     _;
200   }
201 
202   /**
203    * @dev Modifier to make a function callable only when the contract is paused.
204    */
205   modifier whenPaused() {
206     require(paused);
207     _;
208   }
209 
210   /**
211    * @dev called by the owner to pause, triggers stopped state
212    */
213   function pause() onlyOwner whenNotPaused public {
214     paused = true;
215     Pause();
216   }
217 
218   /**
219    * @dev called by the owner to unpause, returns to normal state
220    */
221   function unpause() onlyOwner whenPaused public {
222     paused = false;
223     Unpause();
224   }
225 }
226 
227 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
228 
229 /**
230  * @title ERC20 interface
231  * @dev see https://github.com/ethereum/EIPs/issues/20
232  */
233 contract ERC20 is ERC20Basic {
234   function allowance(address owner, address spender) public view returns (uint256);
235   function transferFrom(address from, address to, uint256 value) public returns (bool);
236   function approve(address spender, uint256 value) public returns (bool);
237   event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
241 
242 /**
243  * @title Standard ERC20 token
244  *
245  * @dev Implementation of the basic standard token.
246  * @dev https://github.com/ethereum/EIPs/issues/20
247  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
248  */
249 contract StandardToken is ERC20, BasicToken {
250 
251   mapping (address => mapping (address => uint256)) internal allowed;
252 
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param _from address The address which you want to send tokens from
257    * @param _to address The address which you want to transfer to
258    * @param _value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
261     require(_to != address(0));
262     require(_value <= balances[_from]);
263     require(_value <= allowed[_from][msg.sender]);
264 
265     balances[_from] = balances[_from].sub(_value);
266     balances[_to] = balances[_to].add(_value);
267     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
268     Transfer(_from, _to, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274    *
275    * Beware that changing an allowance with this method brings the risk that someone may use both the old
276    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     allowed[msg.sender][_spender] = _value;
284     Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Function to check the amount of tokens that an owner allowed to a spender.
290    * @param _owner address The address which owns the funds.
291    * @param _spender address The address which will spend the funds.
292    * @return A uint256 specifying the amount of tokens still available for the spender.
293    */
294   function allowance(address _owner, address _spender) public view returns (uint256) {
295     return allowed[_owner][_spender];
296   }
297 
298   /**
299    * @dev Increase the amount of tokens that an owner allowed to a spender.
300    *
301    * approve should be called when allowed[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param _spender The address which will spend the funds.
306    * @param _addedValue The amount of tokens to increase the allowance by.
307    */
308   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
309     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Decrease the amount of tokens that an owner allowed to a spender.
316    *
317    * approve should be called when allowed[_spender] == 0. To decrement
318    * allowed value is better to use this function to avoid 2 calls (and wait until
319    * the first transaction is mined)
320    * From MonolithDAO Token.sol
321    * @param _spender The address which will spend the funds.
322    * @param _subtractedValue The amount of tokens to decrease the allowance by.
323    */
324   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
325     uint oldValue = allowed[msg.sender][_spender];
326     if (_subtractedValue > oldValue) {
327       allowed[msg.sender][_spender] = 0;
328     } else {
329       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
330     }
331     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335 }
336 
337 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
338 
339 /**
340  * @title Pausable token
341  * @dev StandardToken modified with pausable transfers.
342  **/
343 contract PausableToken is StandardToken, Pausable {
344 
345   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
346     return super.transfer(_to, _value);
347   }
348 
349   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
350     return super.transferFrom(_from, _to, _value);
351   }
352 
353   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
354     return super.approve(_spender, _value);
355   }
356 
357   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
358     return super.increaseApproval(_spender, _addedValue);
359   }
360 
361   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
362     return super.decreaseApproval(_spender, _subtractedValue);
363   }
364 }
365 
366 // File: contracts/token/HBOToken.sol
367 
368 // ----------------------------------------------------------------------------
369 // smart contract - ERC20 Token Interface
370 //
371 // The MIT Licence.
372 // ----------------------------------------------------------------------------
373 
374 contract HBOToken is PausableToken, BurnableToken {
375   
376   string public symbol = "HBO";
377 
378   string public name = "Harbor Chain Token";
379   
380   uint8 public decimals = 18;
381 
382   uint public constant INITIAL_SUPPLY = 100 * 10 ** 8 * 10 ** 18;
383 
384   function HBOToken() public {
385     totalSupply_ = INITIAL_SUPPLY;
386     balances[msg.sender] = INITIAL_SUPPLY;
387     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
388   }
389 
390   function () payable public {
391     revert();
392   }
393 
394 }