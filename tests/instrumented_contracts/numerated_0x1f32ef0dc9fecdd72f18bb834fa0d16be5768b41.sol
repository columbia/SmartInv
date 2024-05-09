1 pragma solidity 0.4.19;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20   
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
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40   
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61     
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 }
95 
96 
97 
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133     
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139   
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147   
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 }
174 
175 
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     Transfer(_from, _to, _value);
205     return true;
206   }
207 
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
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public view returns (uint256) {
233     return allowed[_owner][_spender];
234   }
235   
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 }
275 
276 
277 
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284     
285   event Pause();
286   event Unpause();
287 
288   bool public paused = true;
289 
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is not paused
293    * or when the owner is invoking the function.
294    */
295   modifier whenNotPaused() {
296     require(!paused || msg.sender == owner);
297     _;
298   }
299   
300 
301   /**
302    * @dev Modifier to make a function callable only when the contract is paused.
303    */
304   modifier whenPaused() {
305     require(paused);
306     _;
307   }
308 
309 
310   /**
311    * @dev called by the owner to pause, triggers stopped state
312    */
313   function pause() onlyOwner whenNotPaused public {
314     paused = true;
315     Pause();
316   }
317   
318 
319   /**
320    * @dev called by the owner to unpause, returns to normal state
321    */
322   function unpause() onlyOwner whenPaused public {
323     paused = false;
324     Unpause();
325   }
326 }
327 
328 
329 
330 
331 /**
332  * @title Pausable token
333  * @dev StandardToken modified with pausable transfers.
334  **/
335 contract PausableToken is StandardToken, Pausable {
336 
337   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
338     return super.transfer(_to, _value);
339   }
340 
341 
342   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
343     return super.transferFrom(_from, _to, _value);
344   }
345   
346 
347   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
348     return super.approve(_spender, _value);
349   }
350   
351 
352   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
353     return super.increaseApproval(_spender, _addedValue);
354   }
355   
356 
357   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
358     return super.decreaseApproval(_spender, _subtractedValue);
359   }
360 }
361 
362 
363 
364 
365 contract LMDA is PausableToken {
366     
367     string public  name;
368     string public symbol;
369     uint8 public decimals;
370     uint256 public totalSupply;
371 
372 
373     /**
374      * Constructor initializes the name, symbol, decimals and total 
375      * supply of the token. The owner of the contract which is initially 
376      * the ICO contract will receive the entire total supply. 
377      * */
378     function LMDA() public {
379         name = "LaMonedaCoin";
380         symbol = "LMDA";
381         decimals = 18;
382         totalSupply = 500000000e18;
383         
384         balances[owner] = totalSupply;
385         Transfer(address(this), owner, totalSupply);
386     }
387 }