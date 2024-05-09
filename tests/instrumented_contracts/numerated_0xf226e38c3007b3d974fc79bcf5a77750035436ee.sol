1 pragma solidity 0.4.24;
2 
3 // File: contracts/library/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/library/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: contracts/library/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: contracts/ERC20/BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     emit Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 }
198 
199 // File: contracts/ERC20/ERC20.sol
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: contracts/ERC20/StandardToken.sol
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     allowed[msg.sender][_spender] = _value;
256     emit Approval(msg.sender, _spender, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266   function allowance(address _owner, address _spender) public view returns (uint256) {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303 
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 // File: contracts/ERC20/PausableToken.sol
311 
312 /**
313  * @title Pausable token
314  * @dev StandardToken modified with pausable transfers.
315  **/
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(
319     address _to,
320     uint256 _value
321   )
322     public
323     whenNotPaused
324     returns (bool)
325   {
326     return super.transfer(_to, _value);
327   }
328 
329   function transferFrom(
330     address _from,
331     address _to,
332     uint256 _value
333   )
334     public
335     whenNotPaused
336     returns (bool)
337   {
338     return super.transferFrom(_from, _to, _value);
339   }
340 
341   function approve(
342     address _spender,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.approve(_spender, _value);
350   }
351 
352   function increaseApproval(
353     address _spender,
354     uint _addedValue
355   )
356     public
357     whenNotPaused
358     returns (bool success)
359   {
360     return super.increaseApproval(_spender, _addedValue);
361   }
362 
363   function decreaseApproval(
364     address _spender,
365     uint _subtractedValue
366   )
367     public
368     whenNotPaused
369     returns (bool success)
370   {
371     return super.decreaseApproval(_spender, _subtractedValue);
372   }
373 }
374 
375 // File: contracts/CodexCoin.sol
376 
377 contract CodexCoin is PausableToken {
378 
379   /* solium-disable uppercase */
380   uint8 constant public decimals = 18;
381 
382   string constant public name = "CodexCoin";
383 
384   string constant public symbol = "CODX";
385   /* solium-enable */
386 
387   constructor(uint256 _totalSupply) public {
388     totalSupply_ = _totalSupply;
389     balances[msg.sender] = totalSupply_;
390   }
391 
392   /**
393    * @dev Reclaim all ERC20Basic compatible tokens
394    * @param token ERC20Basic The address of the token contract
395    */
396   function reclaimToken(ERC20Basic token) external onlyOwner {
397     uint256 balance = token.balanceOf(this);
398     token.transfer(owner, balance);
399   }
400 }