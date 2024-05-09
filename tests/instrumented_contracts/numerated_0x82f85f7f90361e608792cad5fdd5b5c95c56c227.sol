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
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 
226 
227 
228 
229 /**
230  * @title Pausable
231  * @dev Base contract which allows children to implement an emergency stop mechanism.
232  */
233 contract Pausable is Ownable {
234   event Pause();
235   event Unpause();
236 
237   bool public paused = false;
238 
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is not paused.
242    */
243   modifier whenNotPaused() {
244     require(!paused);
245     _;
246   }
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is paused.
250    */
251   modifier whenPaused() {
252     require(paused);
253     _;
254   }
255 
256   /**
257    * @dev called by the owner to pause, triggers stopped state
258    */
259   function pause() onlyOwner whenNotPaused public {
260     paused = true;
261     Pause();
262   }
263 
264   /**
265    * @dev called by the owner to unpause, returns to normal state
266    */
267   function unpause() onlyOwner whenPaused public {
268     paused = false;
269     Unpause();
270   }
271 }
272 
273 
274 
275 /**
276  * @title Pausable token
277  * @dev StandardToken modified with pausable transfers.
278  **/
279 contract PausableToken is StandardToken, Pausable {
280 
281   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
282     return super.transfer(_to, _value);
283   }
284 
285   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
286     return super.transferFrom(_from, _to, _value);
287   }
288 
289   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
290     return super.approve(_spender, _value);
291   }
292 
293   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
294     return super.increaseApproval(_spender, _addedValue);
295   }
296 
297   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
298     return super.decreaseApproval(_spender, _subtractedValue);
299   }
300 }
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 
311 /**
312  * @title SafeMath
313  * @dev Math operations with safety checks that throw on error
314  */
315 library SafeMath {
316 
317   /**
318   * @dev Multiplies two numbers, throws on overflow.
319   */
320   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321     if (a == 0) {
322       return 0;
323     }
324     uint256 c = a * b;
325     assert(c / a == b);
326     return c;
327   }
328 
329   /**
330   * @dev Integer division of two numbers, truncating the quotient.
331   */
332   function div(uint256 a, uint256 b) internal pure returns (uint256) {
333     // assert(b > 0); // Solidity automatically throws when dividing by 0
334     uint256 c = a / b;
335     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
336     return c;
337   }
338 
339   /**
340   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
341   */
342   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
343     assert(b <= a);
344     return a - b;
345   }
346 
347   /**
348   * @dev Adds two numbers, throws on overflow.
349   */
350   function add(uint256 a, uint256 b) internal pure returns (uint256) {
351     uint256 c = a + b;
352     assert(c >= a);
353     return c;
354   }
355 }
356 
357 
358 
359 
360 /**
361  * @title Burnable Token
362  * @dev Token that can be irreversibly burned (destroyed).
363  */
364 contract BurnableToken is BasicToken {
365 
366   event Burn(address indexed burner, uint256 value);
367 
368   /**
369    * @dev Burns a specific amount of tokens.
370    * @param _value The amount of token to be burned.
371    */
372   function burn(uint256 _value) public {
373     require(_value <= balances[msg.sender]);
374     // no need to require value <= totalSupply, since that would imply the
375     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
376 
377     address burner = msg.sender;
378     balances[burner] = balances[burner].sub(_value);
379     totalSupply_ = totalSupply_.sub(_value);
380     Burn(burner, _value);
381     Transfer(burner, address(0), _value);
382   }
383 }
384 
385 
386 contract AdeniumLabsToken is PausableToken, BurnableToken {
387     string public constant name = "Adenium Token";
388     string public constant symbol = "ADE";
389     uint8 public constant decimals = 18;
390 
391     uint256 public constant INITIAL_SUPPLY = 13000000 * (10 ** uint256(decimals));
392 
393     /**
394    * @dev Constructor that gives msg.sender all of existing tokens.
395    */
396   function AdeniumLabsToken() public {
397     totalSupply_ = INITIAL_SUPPLY;
398     balances[msg.sender] = INITIAL_SUPPLY;
399     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
400   }
401 
402   /*
403   * No direct bay of tokens
404   */
405   function () public {
406       revert();
407   }
408 
409 }