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
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   uint256 totalSupply_;
166 
167   /**
168   * @dev total number of tokens in existence
169   */
170   function totalSupply() public view returns (uint256) {
171     return totalSupply_;
172   }
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     // SafeMath.sub will throw if there is not enough balance.
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256 balance) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 
297 /**
298  * @title Mintable token
299  * @dev Simple ERC20 Token example, with mintable token creation
300  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
301  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
302  */
303 contract MintableToken is StandardToken, Ownable {
304   event Mint(address indexed to, uint256 amount);
305   event MintFinished();
306 
307   bool public mintingFinished = false;
308 
309 
310   modifier canMint() {
311     require(!mintingFinished);
312     _;
313   }
314 
315   /**
316    * @dev Function to mint tokens
317    * @param _to The address that will receive the minted tokens.
318    * @param _amount The amount of tokens to mint.
319    * @return A boolean that indicates if the operation was successful.
320    */
321   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
322     totalSupply_ = totalSupply_.add(_amount);
323     balances[_to] = balances[_to].add(_amount);
324     Mint(_to, _amount);
325     Transfer(address(0), _to, _amount);
326     return true;
327   }
328 
329   /**
330    * @dev Function to stop minting new tokens.
331    * @return True if the operation was successful.
332    */
333   function finishMinting() onlyOwner canMint public returns (bool) {
334     mintingFinished = true;
335     MintFinished();
336     return true;
337   }
338 }
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
365 /**
366  * @title Capped token
367  * @dev Mintable token with a token cap.
368  */
369 contract CappedToken is MintableToken {
370 
371   uint256 public cap;
372 
373   function CappedToken(uint256 _cap) public {
374     require(_cap > 0);
375     cap = _cap;
376   }
377 
378   /**
379    * @dev Function to mint tokens
380    * @param _to The address that will receive the minted tokens.
381    * @param _amount The amount of tokens to mint.
382    * @return A boolean that indicates if the operation was successful.
383    */
384   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
385     require(totalSupply_.add(_amount) <= cap);
386 
387     return super.mint(_to, _amount);
388   }
389 
390 }
391 
392 contract CommunityCoin is CappedToken, PausableToken {
393 
394   using SafeMath for uint;
395 
396   string public constant symbol = "CTC";
397 
398   string public constant name = "Coin of The Community";
399 
400   uint8 public constant decimals = 18;
401 
402   uint public constant unit = 10 ** uint256(decimals);
403   
404   uint public lockPeriod = 90 days;
405   
406   uint public startTime;
407 
408   function CommunityCoin(uint _startTime,uint _tokenCap) CappedToken(_tokenCap.mul(unit)) public {
409       totalSupply_ = 0;
410       startTime=_startTime;
411       pause();
412     }
413     
414      function unpause() onlyOwner whenPaused public {
415     require(now > startTime + lockPeriod);
416     super.unpause();
417   }
418 
419   function setLockPeriod(uint _period) onlyOwner public {
420     lockPeriod = _period;
421   }
422 
423   function () payable public {
424         revert();
425     }
426 
427 
428 }