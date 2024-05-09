1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/20
46  */
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71     if (a == 0) {
72       return 0;
73     }
74     uint256 c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   /**
90   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256) {
101     uint256 c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[msg.sender]);
134 
135     // SafeMath.sub will throw if there is not enough balance.
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public view returns (uint256) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
222     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 /**
251  * @title Mintable token
252  * @dev Simple ERC20 Token example, with mintable token creation
253  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
254  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 contract MintableToken is StandardToken, Ownable {
257   event Mint(address indexed to, uint256 amount);
258   event MintFinished();
259 
260   bool public mintingFinished = false;
261 
262 
263   modifier canMint() {
264     require(!mintingFinished);
265     _;
266   }
267 
268   /**
269    * @dev Function to mint tokens
270    * @param _to The address that will receive the minted tokens.
271    * @param _amount The amount of tokens to mint.
272    * @return A boolean that indicates if the operation was successful.
273    */
274   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
275     totalSupply_ = totalSupply_.add(_amount);
276     balances[_to] = balances[_to].add(_amount);
277     Mint(_to, _amount);
278     Transfer(address(0), _to, _amount);
279     return true;
280   }
281 
282   /**
283    * @dev Function to stop minting new tokens.
284    * @return True if the operation was successful.
285    */
286   function finishMinting() onlyOwner canMint public returns (bool) {
287     mintingFinished = true;
288     MintFinished();
289     return true;
290   }
291 }
292 
293 
294 
295 /**
296  * @title Capped token
297  * @dev Mintable token with a token cap.
298  */
299 contract CappedToken is MintableToken {
300 
301   uint256 public cap;
302 
303   function CappedToken(uint256 _cap) public {
304     require(_cap > 0);
305     cap = _cap;
306   }
307 
308   /**
309    * @dev Function to mint tokens
310    * @param _to The address that will receive the minted tokens.
311    * @param _amount The amount of tokens to mint.
312    * @return A boolean that indicates if the operation was successful.
313    */
314   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
315     require(totalSupply_.add(_amount) <= cap);
316 
317     return super.mint(_to, _amount);
318   }
319 
320 }
321 
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     Unpause();
364   }
365 }
366 
367 
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
376     return super.transfer(_to, _value);
377   }
378 
379   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
380     return super.transferFrom(_from, _to, _value);
381   }
382 
383   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
384     return super.approve(_spender, _value);
385   }
386 
387   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
388     return super.increaseApproval(_spender, _addedValue);
389   }
390 
391   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
392     return super.decreaseApproval(_spender, _subtractedValue);
393   }
394 }
395 
396 
397 /*
398   TaxiToken is PausableToken and on the creation it is paused.
399   It is made so because you don't want token to be transferable etc,
400   while your ico is not over.
401 */
402 contract TaxiToken is CappedToken, PausableToken {
403 
404   uint256 private constant TOKEN_CAP = 500 * 10**24;
405 
406   string public constant name = "TAXI Token";
407   string public constant symbol = "TAXI";
408   uint8 public constant decimals = 18;
409 
410   function TaxiToken() public CappedToken(TOKEN_CAP) {
411     paused = true;
412   }
413 }