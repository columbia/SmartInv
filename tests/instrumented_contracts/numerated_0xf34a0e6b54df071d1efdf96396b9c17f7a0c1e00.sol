1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a >= b ? a : b;
10   }
11 
12   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
13     return a < b ? a : b;
14   }
15 
16   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a >= b ? a : b;
18   }
19 
20   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
21     return a < b ? a : b;
22   }
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   function Ownable() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) public onlyOwner {
105     require(newOwner != address(0));
106     OwnershipTransferred(owner, newOwner);
107     owner = newOwner;
108   }
109 
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     Unpause();
153   }
154 }
155 
156 /**
157  * @title ERC20Basic
158  * @dev Simpler version of ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/179
160  */
161 contract ERC20Basic {
162   function totalSupply() public view returns (uint256);
163   function balanceOf(address who) public view returns (uint256);
164   function transfer(address to, uint256 value) public returns (bool);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 }
167 
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
207     // SafeMath.sub will throw if there is not enough balance.
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256 balance) {
220     return balances[_owner];
221   }
222 
223 }
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
243   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
244     require(_to != address(0));
245     require(_value <= balances[_from]);
246     require(_value <= allowed[_from][msg.sender]);
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251     Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    *
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value) public returns (bool) {
266     allowed[msg.sender][_spender] = _value;
267     Approval(msg.sender, _spender, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public view returns (uint256) {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _addedValue The amount of tokens to increase the allowance by.
290    */
291   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
292     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
293     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297   /**
298    * @dev Decrease the amount of tokens that an owner allowed to a spender.
299    *
300    * approve should be called when allowed[_spender] == 0. To decrement
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param _spender The address which will spend the funds.
305    * @param _subtractedValue The amount of tokens to decrease the allowance by.
306    */
307   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
308     uint oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue > oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 
321 contract PausableToken is StandardToken, Pausable {
322 
323   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
324     return super.transfer(_to, _value);
325   }
326 
327   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
328     return super.transferFrom(_from, _to, _value);
329   }
330 
331   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
332     return super.approve(_spender, _value);
333   }
334 
335   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
336     return super.increaseApproval(_spender, _addedValue);
337   }
338 
339   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
340     return super.decreaseApproval(_spender, _subtractedValue);
341   }
342 }
343 
344 contract CICoin is Ownable, PausableToken {
345 
346   string public constant name = "CICoin";
347   string public constant symbol = "CIC";
348   uint8 public constant decimals = 8;
349 
350   uint256 public constant INITIAL_SUPPLY = 12000000 * (10 ** uint256(decimals));
351 
352   /**
353    * @dev Constructor that gives msg.sender all of existing tokens.
354    */
355   function CICoin() public {
356     totalSupply_ = INITIAL_SUPPLY;
357     balances[msg.sender] = INITIAL_SUPPLY;
358     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
359 
360     // Stop transferring
361     pause();
362   }
363 
364   function transferByOwner(address _to, uint256 _value) public onlyOwner returns (bool) {
365     // Transfers tokens during ICO
366     require(_to != address(0));
367     require(_value <= balances[msg.sender]);
368 
369     balances[msg.sender] = balances[msg.sender].sub(_value);
370     balances[_to] = balances[_to].add(_value);
371     Transfer(msg.sender, _to, _value);
372     return true;
373   }
374 
375   function() payable {
376       owner.transfer(msg.value);
377   }
378 }