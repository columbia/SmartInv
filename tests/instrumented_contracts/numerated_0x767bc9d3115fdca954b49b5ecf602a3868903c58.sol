1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     
22     uint256 c = a / b;
23     
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 
41 
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 
102 
103 
104 
105 
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 
121 
122 
123 
124 
125 
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) balances;
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 
165 
166 
167 
168 
169 
170 /**
171  * @title Pausable
172  * @dev Base contract which allows children to implement an emergency stop mechanism.
173  */
174 contract Pausable is Ownable {
175   event Pause();
176   event Unpause();
177 
178   bool public paused = false;
179 
180 
181   /**
182    * @dev Modifier to make a function callable only when the contract is not paused.
183    */
184   modifier whenNotPaused() {
185     require(!paused);
186     _;
187   }
188 
189   /**
190    * @dev Modifier to make a function callable only when the contract is paused.
191    */
192   modifier whenPaused() {
193     require(paused);
194     _;
195   }
196 
197   /**
198    * @dev called by the owner to pause, triggers stopped state
199    */
200   function pause() onlyOwner whenNotPaused public {
201     paused = true;
202     Pause();
203   }
204 
205   /**
206    * @dev called by the owner to unpause, returns to normal state
207    */
208   function unpause() onlyOwner whenPaused public {
209     paused = false;
210     Unpause();
211   }
212 }
213 
214 
215 
216 
217 
218 
219 
220 
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(address _owner, address _spender) public view returns (uint256) {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * approve should be called when allowed[_spender] == 0. To increment
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    */
284   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
285     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 
304 
305 
306 
307 
308 /**
309  * @title Burnable Token
310  * @dev Token that can be irreversibly burned (destroyed).
311  */
312 contract BurnableToken is StandardToken {
313 
314     event Burn(address indexed burner, uint256 value);
315 
316     /**
317      * @dev Burns a specific amount of tokens.
318      * @param _value The amount of token to be burned.
319      */
320     function burn(uint256 _value) public {
321         require(_value > 0);
322         require(_value <= balances[msg.sender]);
323         
324         
325 
326         address burner = msg.sender;
327         balances[burner] = balances[burner].sub(_value);
328         totalSupply = totalSupply.sub(_value);
329         Burn(burner, _value);
330     }
331 }
332 
333 
334 
335 
336 
337 
338 
339 /**
340  * @title Pausable token
341  *
342  * @dev StandardToken modified with pausable transfers.
343  **/
344 
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
368 
369 
370 
371 
372 
373 
374 contract MToken is BurnableToken, PausableToken {
375     string public name = "M Token";
376     string public symbol = "M";
377     uint256 public decimals = 18;
378     // 10 亿
379     uint256 public constant INITIAL_SUPPLY = 1000 * 1000 * 1000 * (10 ** uint256(decimals));
380 
381     function MToken() public {
382         totalSupply = INITIAL_SUPPLY;
383         balances[msg.sender] = INITIAL_SUPPLY;
384     }
385 }