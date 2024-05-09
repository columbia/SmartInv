1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
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
156 
157 contract DetailedERC20 is ERC20 {
158   string public name;
159   string public symbol;
160   uint8 public decimals;
161 
162   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
163     name = _name;
164     symbol = _symbol;
165     decimals = _decimals;
166   }
167 }
168 
169 /**
170  * @title Basic token
171  * @dev Basic version of StandardToken, with no allowances.
172  */
173 contract BasicToken is ERC20Basic {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   /**
181   * @dev total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185   }
186 
187   /**
188   * @dev transfer token for a specified address
189   * @param _to The address to transfer to.
190   * @param _value The amount to be transferred.
191   */
192   function transfer(address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[msg.sender]);
195 
196     // SafeMath.sub will throw if there is not enough balance.
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256 balance) {
209     return balances[_owner];
210   }
211 
212 }
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
240     Transfer(_from, _to, _value);
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
256     Approval(msg.sender, _spender, _value);
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
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
303     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Pausable token
311  * @dev StandardToken modified with pausable transfers.
312  **/
313 contract PausableToken is StandardToken, Pausable {
314 
315   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
316     return super.transfer(_to, _value);
317   }
318 
319   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
320     return super.transferFrom(_from, _to, _value);
321   }
322 
323   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
324     return super.approve(_spender, _value);
325   }
326 
327   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
328     return super.increaseApproval(_spender, _addedValue);
329   }
330 
331   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
332     return super.decreaseApproval(_spender, _subtractedValue);
333   }
334 }
335 
336 /**
337  * @title Mintable token
338  * @dev Simple ERC20 Token example, with mintable token creation
339  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
340  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
341  */
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   /**
355    * @dev Function to mint tokens
356    * @param _to The address that will receive the minted tokens.
357    * @param _amount The amount of tokens to mint.
358    * @return A boolean that indicates if the operation was successful.
359    */
360   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     Mint(_to, _amount);
364     Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     MintFinished();
375     return true;
376   }
377 }
378 
379 pragma solidity 0.4.20;
380 
381 contract TWIMToken is MintableToken, PausableToken, DetailedERC20 {
382 
383     address[] public holders;
384     uint256 undistributed = 0;
385 
386     event ShareSent(address indexed holder, uint256 value);
387 
388     function TWIMToken() public 
389       DetailedERC20("TWIM Token", "TWM", 0) {
390 
391       mint(0x00E7140Dd3b8144860064F7e6af959487d74c116, 50000000);
392       mint(0x006Ec9864C401a79e2aEF9F46349795B0E9B6860, 50000000);
393       finishMinting();
394     }
395 
396     function () external payable {
397       distribute();
398     }
399 
400     function distribute() whenNotPaused private {
401       require(msg.value > 0);
402 
403       // calculate weis per token
404       uint256 value = msg.value.add(undistributed);
405       uint256 grain = value.div(totalSupply_);
406       // handle remainder
407       uint256 remainder = value.sub(grain.mul(totalSupply_));
408       undistributed = remainder;
409 
410       if (grain == 0)
411         return;
412       
413       for (uint256 i = 0; i < holders.length; i++) {
414         address holder = holders[i];
415         uint256 balance = balances[holder];
416 
417         // do not fallback to empty accs
418         if (balance > 0) {
419           uint256 share = grain * balance;
420           holder.transfer(share);
421         }
422       }
423     }
424 
425     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
426       if (super.mint(_to, _amount)) {
427         if (balances[_to] == _amount) {
428           holders.push(_to);
429         }
430         return true; 
431       }
432       return false;
433     }
434 
435     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
436       if (super.transferFrom(_from, _to, _value)) {
437         if (balances[_to] == _value) {
438           holders.push(_to);
439         }
440         return true;
441       }
442       return false;
443     }
444 
445     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
446       if (super.transfer(_to, _value)) {
447         if (balances[_to] == _value) {
448           holders.push(_to);
449         }
450         return true;
451       }
452       return false;
453     }
454 }