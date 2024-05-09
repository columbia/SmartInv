1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 
33 
34 
35 /**
36  * @title Basic token
37  * @dev Basic version of StandardToken, with no allowances.
38  */
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   uint256 totalSupply_;
45 
46   /**
47   * @dev total number of tokens in existence
48   */
49   function totalSupply() public view returns (uint256) {
50     return totalSupply_;
51   }
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public view returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 
81 
82 
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94 
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 the amount of tokens to be transferred
100    */
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    *
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   /**
140    * @dev Increase the amount of tokens that an owner allowed to a spender.
141    *
142    * approve should be called when allowed[_spender] == 0. To increment
143    * allowed value is better to use this function to avoid 2 calls (and wait until
144    * the first transaction is mined)
145    * From MonolithDAO Token.sol
146    * @param _spender The address which will spend the funds.
147    * @param _addedValue The amount of tokens to increase the allowance by.
148    */
149   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155   /**
156    * @dev Decrease the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To decrement
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _subtractedValue The amount of tokens to decrease the allowance by.
164    */
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 
179 
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188 
189 
190   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192 
193   /**
194    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   function Ownable() public {
198     owner = msg.sender;
199   }
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) public onlyOwner {
214     require(newOwner != address(0));
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 
222 
223 
224 
225 contract DetailedERC20 is ERC20 {
226   string public name;
227   string public symbol;
228   uint8 public decimals;
229 
230   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
231     name = _name;
232     symbol = _symbol;
233     decimals = _decimals;
234   }
235 }
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 /**
246  * @title Mintable token
247  * @dev Simple ERC20 Token example, with mintable token creation
248  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
249  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
250  */
251 contract MintableToken is StandardToken, Ownable {
252   event Mint(address indexed to, uint256 amount);
253   event MintFinished();
254 
255   bool public mintingFinished = false;
256 
257 
258   modifier canMint() {
259     require(!mintingFinished);
260     _;
261   }
262 
263   /**
264    * @dev Function to mint tokens
265    * @param _to The address that will receive the minted tokens.
266    * @param _amount The amount of tokens to mint.
267    * @return A boolean that indicates if the operation was successful.
268    */
269   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     MintFinished();
284     return true;
285   }
286 }
287 
288 
289 
290 /**
291  * @title Capped token
292  * @dev Mintable token with a token cap.
293  */
294 contract CappedToken is MintableToken {
295 
296   uint256 public cap;
297 
298   function CappedToken(uint256 _cap) public {
299     require(_cap > 0);
300     cap = _cap;
301   }
302 
303   /**
304    * @dev Function to mint tokens
305    * @param _to The address that will receive the minted tokens.
306    * @param _amount The amount of tokens to mint.
307    * @return A boolean that indicates if the operation was successful.
308    */
309   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310     require(totalSupply_.add(_amount) <= cap);
311 
312     return super.mint(_to, _amount);
313   }
314 
315 }
316 
317 
318 
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 /**
329  * @title SafeMath
330  * @dev Math operations with safety checks that throw on error
331  */
332 library SafeMath {
333 
334   /**
335   * @dev Multiplies two numbers, throws on overflow.
336   */
337   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338     if (a == 0) {
339       return 0;
340     }
341     uint256 c = a * b;
342     assert(c / a == b);
343     return c;
344   }
345 
346   /**
347   * @dev Integer division of two numbers, truncating the quotient.
348   */
349   function div(uint256 a, uint256 b) internal pure returns (uint256) {
350     // assert(b > 0); // Solidity automatically throws when dividing by 0
351     uint256 c = a / b;
352     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
353     return c;
354   }
355 
356   /**
357   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
358   */
359   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
360     assert(b <= a);
361     return a - b;
362   }
363 
364   /**
365   * @dev Adds two numbers, throws on overflow.
366   */
367   function add(uint256 a, uint256 b) internal pure returns (uint256) {
368     uint256 c = a + b;
369     assert(c >= a);
370     return c;
371   }
372 }
373 
374 
375 
376 
377 
378 
379 /**
380  * @title Pausable
381  * @dev Base contract which allows children to implement an emergency stop mechanism.
382  */
383 contract Pausable is Ownable {
384   event Pause();
385   event Unpause();
386 
387   bool public paused = false;
388 
389 
390   /**
391    * @dev Modifier to make a function callable only when the contract is not paused.
392    */
393   modifier whenNotPaused() {
394     require(!paused);
395     _;
396   }
397 
398   /**
399    * @dev Modifier to make a function callable only when the contract is paused.
400    */
401   modifier whenPaused() {
402     require(paused);
403     _;
404   }
405 
406   /**
407    * @dev called by the owner to pause, triggers stopped state
408    */
409   function pause() onlyOwner whenNotPaused public {
410     paused = true;
411     Pause();
412   }
413 
414   /**
415    * @dev called by the owner to unpause, returns to normal state
416    */
417   function unpause() onlyOwner whenPaused public {
418     paused = false;
419     Unpause();
420   }
421 }
422 
423 
424 
425 /**
426  * @title Pausable token
427  * @dev StandardToken modified with pausable transfers.
428  **/
429 contract PausableToken is StandardToken, Pausable {
430 
431   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
432     return super.transfer(_to, _value);
433   }
434 
435   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
436     return super.transferFrom(_from, _to, _value);
437   }
438 
439   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
440     return super.approve(_spender, _value);
441   }
442 
443   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
444     return super.increaseApproval(_spender, _addedValue);
445   }
446 
447   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
448     return super.decreaseApproval(_spender, _subtractedValue);
449   }
450 }
451 
452 
453 
454 contract iFish is DetailedERC20("iFishYunYu", "iFish", 18), CappedToken(21000000000 * 10 ** 18), PausableToken {
455     function iFish() public {
456         totalSupply_ = 6300000000 * 10 ** 18;
457         balances[msg.sender] = balances[msg.sender].add(6300000000 * 10 ** 18);
458     }
459 }